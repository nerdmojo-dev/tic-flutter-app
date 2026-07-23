import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:tic_task_app/core/riverpod/AuthNotifier.dart';
import 'package:tic_task_app/shared/AppColors.dart';
import 'package:tic_task_app/shared/AppOverlaySnackbar.dart';
import 'package:tic_task_app/shared/SecureStorage.dart';

class AddTask extends ConsumerStatefulWidget {
  const AddTask({Key? key}) : super(key: key);

  @override
  ConsumerState<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends ConsumerState<AddTask> {
  final SpeechToText _speech = SpeechToText();

  bool _isListening = false;
  final _formKey = GlobalKey<FormState>();
  String _currentTranscript = "";
  String _fullTranscript = "";

  String _locale = "bn_in";
  bool _isSubmitting = false;
  bool _submittedToday = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      if (!_isListening) {
        _fullTranscript = _controller.text;
      }
    });

    _loadSubmissionStatus();

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
  }

  Future<void> _loadSubmissionStatus() async {
    final submitted = await hasSubmittedToday();
    print(_isSubmissionWindowOpen);

    if (mounted) {
      setState(() {
        _submittedToday = submitted;
      });
    }
  }

  Future<void> _submit() async {
    if (!_isSubmissionWindowOpen) {
      AppOverlaySnackbar.showError(
        context,
        message: "Tasks can only be submitted between 4:00 PM and 11:30 PM.",
      );
      return;
    }

    if (_submittedToday) return;

    if (_controller.text.trim().isEmpty) {
      AppOverlaySnackbar.showError(context, message: "Please enter some text");
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      await ref
          .read(authProvider.notifier)
          .createTask(_controller.text, _jobNumber.text);
      SecureStorage.saveLastSubmittedDate();

      AppOverlaySnackbar.showSuccess(
        context,
        message: "Task created successfully",
      );
      _loadSubmissionStatus();
      _controller.clear();
    } catch (e) {
      print(e);
      AppOverlaySnackbar.showError(context, message: "$e");
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  Future<void> _initSpeech() async {
    await _speech.initialize(
      onStatus: (status) => print(status),
      onError: (error) => print(error),
    );
  }

  Future<void> _startListening() async {
    if (_speech.isListening) _stopListening();

    await _speech.listen(
      localeId: _locale, // or en_IN
      listenFor: const Duration(minutes: 30), // maximum desired duration
      pauseFor: const Duration(minutes: 5), // stop after 5 min of silence

      listenMode: ListenMode.dictation,
      partialResults: true,
      onResult: (result) {
        _currentTranscript = result.recognizedWords;

        if (result.finalResult) {
          _fullTranscript = _fullTranscript.isEmpty
              ? _currentTranscript
              : "$_fullTranscript $_currentTranscript";

          _currentTranscript = "";
        }

        _controller.text = _currentTranscript.isEmpty
            ? _fullTranscript
            : "$_fullTranscript $_currentTranscript";

        _controller.selection = TextSelection.fromPosition(
          TextPosition(offset: _controller.text.length),
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

    setState(() {
      _isListening = false;
    });
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
                  const Text(
                    "Add new task status",
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
                      _fullTranscript = "";
                      _currentTranscript = "";
                      _controller.clear();
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
          Text(
            "Tap to record & convert voice to text",
            style: TextStyle(fontSize: 13),
          ),
          SizedBox(height: 30),
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
              onPressed: _isSubmissionWindowOpen
                  ? _submittedToday
                        ? null
                        : _submit
                  : null,
              label: const Text("Submit Status"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                elevation: 3,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
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
