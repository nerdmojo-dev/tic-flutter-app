import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tic_task_app/route/AuthGate.dart';
import 'package:flutter/services.dart';
import 'package:tic_task_app/route/ChangePassword.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.manual,
    overlays: [
      SystemUiOverlay.bottom, // Keep navigation bar, hide status bar
    ],
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: const AuthGate(),
        // home: const ChangePasswordScreen(),
      ),
    );
  }
}
