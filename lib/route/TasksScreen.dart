import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:tic_task_app/core/riverpod/AuthNotifier.dart';
import 'package:tic_task_app/shared/AppColors.dart';
import 'package:tic_task_app/shared/AppOverlaySnackbar.dart';
import 'package:tic_task_app/shared/SecureStorage.dart';

class TaskScreen extends ConsumerStatefulWidget {
  const TaskScreen({super.key});

  @override
  ConsumerState<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends ConsumerState<TaskScreen> {
  final SpeechToText _speech = SpeechToText();

  bool _isListening = false;
  String _currentTranscript = "";
  String _fullTranscript = "";
  String _locale = "bn_in";
  bool _isSubmitting = false;
  bool _submittedToday = false;

  @override
  void initState() {
    super.initState();
    _loadSubmissionStatus();

    _initSpeech();
  }

  final TextEditingController _controller = TextEditingController();

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
      17, // 5 PM
      0,
    );

    final end = DateTime(
      now.year,
      now.month,
      now.day,
      20, // 8 PM
      0,
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
        message: "Tasks can only be submitted between 5:00 PM and 8:00 PM.",
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
      await ref.read(authProvider.notifier).createTask(_controller.text);
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
    final user = ref.watch(authProvider);
    

    return Scaffold(
      body: SafeArea(
        child: user.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Center(child: Text(error.toString())),
          data: (user) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(15, 30, 15, 20),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Welcome ${user?.fullName},",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        Container(
                          width: 80,
                          height: 80,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(60),
                            child: Image(
                              image: AssetImage("lib/assets/logo.jpg"),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 30),

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
                            onChanged: (bool state) {
                              print("existing $_locale $state");
                              setState(() {
                                _locale = !state ? "en_IN" : "bn_IN";
                              });
                            },
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 30),
                    TextFormField(
                      controller: _controller,
                      maxLines: 10,
                      decoration: const InputDecoration(
                        hintText: "Speak something...",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 15),
                    Text(
                      "You can submit your daily task status only between 5:00 PM and 8:00 PM.",
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    SizedBox(height: 15),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton.icon(
                          onPressed: _isSubmissionWindowOpen && _submittedToday
                              ? _submit
                              : null,

                          icon: const Icon(Icons.send_rounded, size: 20),
                          label: const Text("Submit"),

                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            elevation: 3,
                            padding: EdgeInsets.symmetric(
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

                        GestureDetector(
                          onTap: () => {
                            if (_isListening)
                              {_stopListening()}
                            else
                              {_startListening()},
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
                                !_isListening
                                    ? Icons.mic_none_rounded
                                    : Icons.cancel_rounded,
                                color: Colors.white,
                                size: 32,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 30),
                    // OutlinedButton.icon(
                    //   onPressed: () async {
                    //     await ref.read(authProvider.notifier).logout();
                    //   },
                    //   icon: const Icon(Icons.logout_rounded),
                    //   label: const Text("Logout"),
                    //   style: OutlinedButton.styleFrom(
                    //     foregroundColor: AppColors.danger,
                    //     side: const BorderSide(color: AppColors.danger),
                    //     padding: const EdgeInsets.symmetric(
                    //       horizontal: 20,
                    //       vertical: 12,
                    //     ),
                    //     shape: RoundedRectangleBorder(
                    //       borderRadius: BorderRadius.circular(30),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          // Call your logout function here
          // Example:

          if (!mounted) return;
          await ref.read(authProvider.notifier).logout();
        },
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        tooltip: "Logout",
        icon: const Icon(Icons.logout),
        label: const Text("Logout"),
      ),
    );
  }
}
