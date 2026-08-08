import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tic_task_app/core/dio/dio_client.dart';
import 'package:tic_task_app/core/repository/TaskRepository.dart';
import 'package:tic_task_app/database/app_database.dart';
import 'package:tic_task_app/route/AuthGate.dart';
import 'package:flutter/services.dart';
import 'package:tic_task_app/route/ChangePassword.dart';
import 'package:tic_task_app/shared/SyncService.dart';
import 'package:workmanager/workmanager.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    debugPrint("Worker started");

    final db = AppDatabase();

    try {
      debugPrint("Checking internet");

      final repo = Taskrepository(DioClient.dio, db);

      debugPrint("Repository created");

      final service = TaskSyncService(repo, db);

      await service.syncPendingTasks();

      debugPrint("Sync finished");

      return true;
    } catch (e, st) {
      debugPrint("$e");
      debugPrint("$st");

      return false;
    } finally {
      await db.close();
    }
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Workmanager().initialize(callbackDispatcher);

  await Workmanager().registerPeriodicTask(
    "taskSync",
    "syncTasks",
    frequency: const Duration(minutes: 15),
  );

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
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        ),
        home: const AuthGate(),
        // home: const ChangePasswordScreen(),
      ),
    );
  }
}
