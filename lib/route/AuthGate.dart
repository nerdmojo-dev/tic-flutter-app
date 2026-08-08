import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tic_task_app/core/dio/dio_client.dart';
import 'package:tic_task_app/core/repository/TaskRepository.dart';
import 'package:tic_task_app/core/riverpod/AppDatabase.dart';
import 'package:tic_task_app/core/riverpod/AuthNotifier.dart';
import 'package:tic_task_app/core/riverpod/TaskNotifier.dart';
import 'package:tic_task_app/database/app_database.dart';
import 'package:tic_task_app/route/ChangePassword.dart';
import 'package:tic_task_app/route/LoginScreen.dart';
import 'package:tic_task_app/route/SplashScreen.dart';
import 'package:tic_task_app/route/TasksScreen.dart';
import 'package:tic_task_app/shared/ConnectivityService.dart';
import 'package:tic_task_app/shared/SyncService.dart';

class AuthGate extends ConsumerStatefulWidget {
  const AuthGate({super.key});

  @override
  ConsumerState<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends ConsumerState<AuthGate> {
  late final ConnectivityService _connectivityService;
  late final AppDatabase db;
  @override
  void initState() {
    super.initState();

    db = ref.read(databaseProvider);
    _connectivityService = ConnectivityService();

    _connectivityService.start(() async {
      try {
        final repo = Taskrepository(DioClient.dio, db);
        final service = TaskSyncService(repo, db);

        await service.syncPendingTasks();
      } finally {
        debugPrint("[FLUTTER] TRIED SYNCING TASKS");
        final now = DateTime.now();

        final startDate = DateTime(now.year, now.month, now.day, 0, 0, 0);

        final endDate = DateTime(now.year, now.month, now.day, 23, 59, 59, 999);
        print("[APPLICATION] FETCHING TODAYS TASKS");
        await ref
            .read(taskProvider.notifier)
            .fetchTasks(startDate: startDate, endDate: endDate);
      }
    });
  }

  @override
  void dispose() {
    _connectivityService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);

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

          if (user.isFirstLogin) {
            return const ChangePasswordScreen(
              key: ValueKey("changePassword"),
              popOnSuccess: false,
            );
          }

          return const TaskScreen(key: ValueKey("task"));
        },
      ),
    );
  }
}
