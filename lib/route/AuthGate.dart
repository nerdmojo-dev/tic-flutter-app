import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tic_task_app/core/riverpod/AuthNotifier.dart';
import 'package:tic_task_app/route/ChangePassword.dart';
import 'package:tic_task_app/route/LoginScreen.dart';
import 'package:tic_task_app/route/SplashScreen.dart';
import 'package:tic_task_app/route/TasksScreen.dart';

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);

    // return auth.when(
    //   loading: () => const SplashScreen(),

    //   error: (_, __) => const LoginScreen(),

    //   data: (user) {
    //     if (user == null) {
    //       return const LoginScreen();
    //     }

    //     return const TaskScreen();
    //   },
    // );

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 350),
      switchInCurve: Curves.easeOut,
      switchOutCurve: Curves.easeIn,
      child: auth.when(
        loading: () => const SplashScreen(key: ValueKey("splash")),
        error: (_, __) => const LoginScreen(key: ValueKey("login")),
        data: (user) {
          if (user == null) {
            return const LoginScreen(key: ValueKey("login"));
          }

          if(user.isFirstLogin) return const ChangePasswordScreen(key: ValueKey("changePassword"),popOnSuccess: false,);

          return const TaskScreen(key: ValueKey("task"));
        },
      ),
    );
  }
}
