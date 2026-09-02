import 'package:dio/dio.dart';
import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:tic_task_app/core/dio/dio_client.dart';
import 'package:tic_task_app/core/riverpod/AppDatabase.dart';
import 'package:tic_task_app/core/riverpod/AuthNotifier.dart';
import 'package:tic_task_app/core/riverpod/TaskNotifier.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tic_task_app/dto/Task.dart';
import 'package:tic_task_app/database/app_database.dart';
import 'package:tic_task_app/shared/AnimatedSideBorderContainer.dart';
import 'package:tic_task_app/shared/AppColors.dart';
import 'package:tic_task_app/shared/AppOverlaySnackbar.dart';
import 'package:tic_task_app/shared/ConnectivityService.dart';
import 'package:tic_task_app/shared/SecureStorage.dart';
import 'package:uuid/uuid.dart';

class AddTask extends ConsumerStatefulWidget {
  const AddTask({Key? key, this.task}) : super(key: key);
  final Task? task;

  bool get isEdit => task != null;

  @override
  ConsumerState<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends ConsumerState<AddTask> {
  late final db;

  final SpeechToText _speech = SpeechToText();

  bool _isListening = false;
  final _formKey = GlobalKey<FormState>();
  String _confirmedText = ""; // Finalized speech
  String _liveText = ""; // Current partial speech
  String _displayText = "";
  String _translatedText = "";
  // confirmed + live

  String _locale = "bn_IN";
  bool _isSubmitting = false;
  bool _submittedToday = false;
  bool _showTranslateButton = false;
  bool _isTranslating = false;
  bool _showTranslation = false;

  String _selectedStatus = "Todo";

  final List<String> _statuses = [
    "Todo",
    "In Progress",
    "Completed",
    "Cancelled",
  ];

  @override
  void initState() {
    super.initState();
    // __initIsar();
    _controller.addListener(() {
      if (!_isListening) {
        print("Controller text changed: ${_controller.text}");
        _confirmedText = _controller.text;
        setState(() {});
      }
    });

    if (widget.isEdit) {
      _controller.text = widget.task!.description;
      _jobNumber.text = widget.task!.title ?? "";
      _liveText = widget.task!.description;
      _selectedStatus = widget.task!.status;

      _submittedToday = false; // editing shouldn't be blocked
    } else {
      _loadSubmissionStatus();
    }

    _initSpeech();
  }

  final TextEditingController _controller = TextEditingController();
  final TextEditingController _jobNumber = TextEditingController();

  Future<bool> hasSubmittedToday() async {
    final storage = ref.read(secureStorageProvider);

    final lastSubmitDate = await storage.read(key: "last_submit_date");
    print("LAST SUBMIT DATE $lastSubmitDate");

    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());

    return lastSubmitDate == today;
  }

  bool get _isSubmissionWindowOpen {
    final now = DateTime.now();

    final start = DateTime(
      now.year,
      now.month,
      now.day,
      16, // 4 PM
      0,
    );

    final end = DateTime(
      now.year,
      now.month,
      now.day,
      23, // 11:30 PM
      30,
    );

    return now.isAfter(start) && now.isBefore(end);
    // return true;
  }

  Future<void> _loadSubmissionStatus() async {
    setState(() {
      _isSubmitting = false;
    });
    final submitted = await hasSubmittedToday();
    print(_isSubmissionWindowOpen.toString()+submitted.toString());

    if (mounted) {
      setState(() {
        _submittedToday = submitted;
        // _submittedToday = false; // allow multiple submissions for testing
        _isSubmitting = false;
      });
    }
  }

  Future<void> _submit() async {
    setState(() {
      _isSubmitting = true;
    });

    String id = await SecureStorage.getuserId() ?? "646313";
    if (!widget.isEdit) {
      if (!_isSubmissionWindowOpen) {
        AppOverlaySnackbar.showError(
          context,
          message: "Tasks can only be submitted between 4 PM and 11:30 PM.",
        );
        return;
      }

      if (_submittedToday) return;
    }

    if (_controller.text.trim().isEmpty) {
      AppOverlaySnackbar.showError(context, message: "Please enter some text");
      return;
    }

    if (_jobNumber.text.trim().isEmpty) {
      AppOverlaySnackbar.showError(
        context,
        message: "Please enter some Job Number",
      );
      return;
    }
    print("*****************SUBMITTING*****************");

    try {
      if (_locale == "bn_IN" && _translatedText.isEmpty) await _translate();
    } catch (e) {}

    await Future.delayed(const Duration(seconds: 4));

    try {
      print(
        "[APPLICATION] STARTING CHECKING INIT ${widget.task != null ? widget.task!.id : null}",
      );
      if (widget.isEdit) {
        final taskId = widget.task!.id;

        final result = await db
            .customSelect(
              'SELECT * FROM task_locals WHERE task_id = ?',
              variables: [Variable(taskId)],
            )
            .get();

        print("[APPLICATION] STARTING CHECKING");
        print("[APPLICATION] LOCAL TASKS: $result");

        if (result.isEmpty) {
          print("[APPLICATION] ADDED UPDATE TASK");

          await db
              .into(db.taskLocals)
              .insert(
                TaskLocalsCompanion.insert(
                  taskId: taskId,
                  title: _jobNumber.text,
                  isEdited: taskId.contains("-") ? Value(false) : Value(true),
                  description: _locale == "bn_IN"
                      ? (_translatedText.trim().isNotEmpty
                            ? _translatedText
                            : _controller.text)
                      : _controller.text,
                  status: _selectedStatus,
                  createdAt: DateTime.now(),
                  createdBy: id,
                ),
              );
        } else {
          print("[APPLICATION] FOUND LOCAL TASK AND UPDATED");

          await db.customStatement(
            '''
  UPDATE task_locals
  SET
    synced = ?,
    is_edited = ?,
    description = ?,
    title = ?,
    status = ?,
    created_by = ?
  WHERE task_id = ?
  ''',
            [
              false,
              taskId.contains("-") ? false : true,
              _locale == "bn_IN"
                  ? (_translatedText.trim().isNotEmpty
                        ? _translatedText
                        : _controller.text)
                  : _controller.text,
              _jobNumber.text,
              _selectedStatus,
              id,
              taskId,
            ],
          );
        }

        if (mounted) {
          Navigator.pop(context, true);
        }
      } else {
        print("[APPLICATION] CREATED LOCAL TASK");

        await db
            .into(db.taskLocals)
            .insert(
              TaskLocalsCompanion.insert(
                taskId: const Uuid().v4(),
                title: _jobNumber.text,
                description: _locale == "bn_IN"
                    ? (_translatedText.trim().isNotEmpty
                          ? _translatedText
                          : _controller.text)
                    : _controller.text,
                status: _selectedStatus,
                createdAt: DateTime.now(),
                createdBy: id,
              ),
            );
      }

      SecureStorage.saveLastSubmittedDate();

      AppOverlaySnackbar.showSuccess(
        context,
        message: widget.isEdit
            ? "Task updated successfully"
            : "Task created successfully",
      );
      _loadSubmissionStatus();
      _controller.clear();
      _jobNumber.clear();

      setState(() {
        _translatedText = "";
        _isTranslating = false;
      });
    } catch (e, stacktrace) {
      print("$e");
      print(stacktrace);
      final parts = e.toString().split(":");

      final message = parts.length > 1
          ? parts.sublist(1).join(":").trim()
          : parts.first;

      AppOverlaySnackbar.showError(context, message: message);
    } finally {
      print("*****************SUBMITTING*****************");

      setState(() {
        _isSubmitting = false;
      });
    }
  }

  Future<void> _initSpeech() async {
    db = ref.read(databaseProvider);

    await _speech.initialize(
      onStatus: (status) => print(status),
      onError: (error) => print(error),
    );
  }

  bool alreadyProcessed = false;
  Future<void> _startListening() async {
    debugPrint("[APPLICATION] LOCALE : $_locale");
    if (_speech.isListening) _stopListening();

    setState(() {
      _translatedText = "";
      _liveText = "";
    });

    await _speech.listen(
      localeId: _locale, // or en_IN
      listenFor: const Duration(minutes: 30), // maximum desired duration
      pauseFor: const Duration(minutes: 5), // stop after 5 min of silence

      listenMode: ListenMode.dictation,
      partialResults: true,
      onResult: (result) {
        if (result.finalResult) {
          return;
        }

        print("LIVE TEXT: ${result.recognizedWords}");

        if (result.recognizedWords.trim().isEmpty && !alreadyProcessed) {
          alreadyProcessed = true;
          _confirmedText = _confirmedText.isEmpty
              ? _liveText
              : "$_confirmedText $_liveText";
        } else {
          alreadyProcessed = false;
          _liveText = result.recognizedWords;
        }

        print("CONFIRMED TEXT $_confirmedText");

        _displayText = _confirmedText;

        _controller.value = TextEditingValue(
          text: _displayText + _liveText,
          selection: TextSelection.collapsed(offset: _displayText.length),
        );

        setState(() {});
      },
    );

    setState(() {
      _isListening = true;
    });
  }

  Future<void> _stopListening() async {
    await Future.delayed(const Duration(seconds: 1));

    await _speech.stop();
    if (_liveText.trim().isNotEmpty) {
      _confirmedText = _confirmedText.isEmpty
          ? _liveText
          : "$_confirmedText $_liveText";
    }

    _liveText = "";
    _controller.text = _confirmedText;
    setState(() {
      _isListening = false;
      _showTranslateButton =
          _locale == "bn_IN" && _controller.text.trim().isNotEmpty;
    });
  }

  Future<void> _translate() async {
    print("****************translating******************");
    print("[TRANSLATING] ${_controller.text}");
    setState(() {
      _isTranslating = true;
      _showTranslation = true;
    });

    try {
      final response = await Dio().post(
        "http://3.26.191.191:8000/translate",
        data: {"text": _controller.text},
      );

      print("[APPLICATION] TRANSLATED : $response");

      setState(() {
        _translatedText = response.data["translated"];
      });
    } finally {
      print("****************translating******************");
      setState(() {
        _isTranslating = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 75,
                padding: const EdgeInsets.all(8),
                height: 75,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.white,
                  border: Border.all(
                    color: const Color(0xFF2563EB).withValues(alpha: 0.3),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF2563EB).withValues(alpha: 0.1),
                      blurRadius: 15,
                      offset: Offset.zero,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image(image: AssetImage("lib/assets/logo.jpg")),
                ),
              ),
              SizedBox(width: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Submit Status",
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 22,
                      color: Color(0xff0F172A),
                    ),
                  ),
                  Text(
                    widget.isEdit ? "Update Task Status" : "Submit Status",
                    style: TextStyle(fontSize: 15, color: Color(0xff0F172A)),
                  ),
                ],
              ),
            ],
          ),
          //tasks add
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Choose your language",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                  fontWeight: FontWeight.w300,
                ),
              ),
              Transform.scale(
                scale: 0.75,
                child: LiteRollingSwitch(
                  value: true,
                  width: 80,
                  textOn: 'অ',
                  textOff: 'En',
                  colorOn: Colors.blueGrey,
                  colorOff: Colors.pink,
                  iconOn: Icons.done,
                  iconOff: Icons.remove_circle_outline,
                  textSize: 16,
                  textOnColor: Colors.white,
                  textOffColor: Colors.white,
                  onTap: () {
                    print("TAP");
                  },
                  onDoubleTap: () {
                    print("DOUBLE TAP");
                  },
                  onSwipe: () {
                    print("SWIPE");
                  },
                  onChanged: (bool state) async {
                    print("existing $_locale $state");
                    if (_isListening) {
                      await _stopListening();
                    }

                    setState(() {
                      _locale = state ? "bn_IN" : "en_IN";
                      _liveText = "";
                      _confirmedText = "";
                      _displayText = "";
                      _showTranslateButton =
                          _locale == "bn_IN" &&
                          _controller.text.trim().isNotEmpty;
                      if (!widget.isEdit) _controller.clear();
                    });
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: 15),
          TextFormField(
            controller: _controller,
            maxLines: 6,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return "Task Status is required";
              }
              return null;
            },
            decoration: const InputDecoration(
              hintText: "Speak something...",
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 15),
          Row(
            children: [
              Spacer(),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _liveText = "";
                    _confirmedText = "";
                    _displayText = "";
                    _translatedText = "";
                    _showTranslateButton =
                        _locale == "bn_IN" &&
                        _controller.text.trim().isNotEmpty;
                    _controller.clear();
                  });
                },
                child: Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _isListening ? Colors.red : Colors.blue,
                  ),
                  child: Icon(Icons.refresh, color: Colors.white),
                ),
              ),
            ],
          ),
          SizedBox(height: 15),
          Text(
            "You can submit your daily task status only between 4:00 PM and 11:30 PM.",
            style: TextStyle(
              color: Colors.blue,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 15),
          GestureDetector(
            onTap: () => {
              if (_isListening) {_stopListening()} else {_startListening()},
            },
            child: Container(
              height: 80,
              width: 80,
              padding: EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 209, 223, 236),
                shape: BoxShape.circle,
              ),
              child: Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: AppColors.lightPinkGradient,
                ),
                child: Icon(
                  !_isListening ? Icons.mic_none_rounded : Icons.cancel_rounded,
                  color: Colors.white,
                  size: 32,
                ),
              ),
            ),
          ),
          SizedBox(height: 10),

          AnimatedContainer(
            duration: const Duration(milliseconds: 350),
            curve: Curves.easeInOut,
            height: _showTranslateButton ? 55 : 0,
            width: double.infinity,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 250),
              opacity: _showTranslateButton ? 1 : 0,
              child: ElevatedButton(
                onPressed: _isSubmissionWindowOpen
                    ? _isTranslating
                          ? null
                          : _translate
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
                child: _isTranslating
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.blueAccent,
                          ),
                        ),
                      )
                    : const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.translate),
                          SizedBox(width: 8),
                          Text("Translate to English"),
                        ],
                      ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          AnimatedSlide(
            duration: const Duration(milliseconds: 400),
            offset: !_isTranslating && _translatedText.isNotEmpty
                ? Offset.zero
                : const Offset(0, .25),
            child: AnimatedSize(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeOut,
              child: !_isTranslating && _translatedText.isNotEmpty
                  ? AnimatedSideBorderContainer(
                      expanded: true,
                      child: SizedBox(
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(_translatedText),
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ),

          SizedBox(height: 30),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Status",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedStatus,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.flag_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                items: _statuses
                    .map(
                      (status) =>
                          DropdownMenuItem(value: status, child: Text(status)),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedStatus = value;
                    });
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 20),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Job Number",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _jobNumber,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Job ID is required";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  hintText: "e.g. JOB-5542",
                  prefixIcon: const Icon(Icons.badge_rounded),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 30),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _isSubmissionWindowOpen && !_submittedToday && !_isSubmitting
                  ? _submit
                  : null,
              icon: _isSubmitting
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : null,
              label: Text(
                _isSubmitting
                    ? "Submitting..."
                    : widget.isEdit
                    ? "Update Task"
                    : "Submit Status",
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                disabledBackgroundColor: Colors.blueGrey.shade100,
                disabledForegroundColor: Colors.white,
                elevation: 3,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          SizedBox(height: 30),
        ],
      ),
    );
  }
}
