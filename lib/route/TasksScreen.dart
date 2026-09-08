import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:tic_task_app/core/dio/dio_client.dart';
import 'package:tic_task_app/core/repository/TaskRepository.dart';
import 'package:tic_task_app/core/riverpod/AppDatabase.dart';
import 'package:tic_task_app/core/riverpod/AuthNotifier.dart';
import 'package:tic_task_app/core/riverpod/TaskNotifier.dart';
import 'package:tic_task_app/route/pages/AddTask.dart';
import 'package:tic_task_app/route/pages/ProfilePage.dart';
import 'package:tic_task_app/route/pages/StatusReports.dart';
import 'package:tic_task_app/shared/AppColors.dart';
import 'package:tic_task_app/shared/AppOverlaySnackbar.dart';
import 'package:tic_task_app/shared/CustomBottomBar.dart';
import 'package:tic_task_app/shared/FilterCard.dart';
import 'package:tic_task_app/shared/SecureStorage.dart';
import 'package:tic_task_app/shared/SyncService.dart';

class TaskScreen extends ConsumerStatefulWidget {
  const TaskScreen({super.key});

  @override
  ConsumerState<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends ConsumerState<TaskScreen> {
  int currentIndex = 0;

  bool _isSyncing = false;

  Future<void> _syncTasks() async {
    if (_isSyncing) return;

    setState(() {
      _isSyncing = true;
    });

    try {
      final db = ref.read(databaseProvider);

      // TODO: Sync local tasks
      final repo = Taskrepository(DioClient.dio, db);
      final service = TaskSyncService(repo, db);

      await service.syncPendingTasks();
    } catch (e, stackTrace) {
      debugPrint("SYNC ERROR: $e");
      debugPrintStack(stackTrace: stackTrace);
    } finally {
      if (mounted) {
        setState(() {
          _isSyncing = false;
        });
      }
      ref.invalidate(taskProvider);
      await ref.read(taskProvider.future);
    }
  }

  Widget getCurrentPage() {
    switch (currentIndex) {
      case 1:
        return StatusReports(key: UniqueKey());

      case 0:
        return AddTask();

      case 2:
        return ProfilePage(key: UniqueKey());

      default:
        return const SizedBox();
    }
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
            return Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
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
                            color: const Color(
                              0xFF2563EB,
                            ).withValues(alpha: 0.3),
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(
                                0xFF2563EB,
                              ).withValues(alpha: 0.1),
                              blurRadius: 15,
                              offset: Offset.zero,
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.asset(
                            "lib/assets/logo.jpg",
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),

                      const SizedBox(width: 15),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            "Welcome",
                            style: TextStyle(
                              fontSize: 15,
                              color: Color(0xff0F172A),
                            ),
                          ),
                          Text(
                            "Status Reports",
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 22,
                              color: Color(0xff0F172A),
                            ),
                          ),
                        ],
                      ),

                      const Spacer(),

                      // Sync button
                      currentIndex == 1
                          ? AnimatedContainer(
                              duration: const Duration(milliseconds: 250),
                              decoration: BoxDecoration(
                                color: _isSyncing
                                    ? Colors.grey.shade400
                                    : const Color(0xFF2563EB),
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: _isSyncing
                                        ? Colors.transparent
                                        : const Color(
                                            0xFF2563EB,
                                          ).withValues(alpha: 0.2),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: IconButton(
                                onPressed: _isSyncing ? null : _syncTasks,
                                tooltip: _isSyncing ? "Syncing..." : "Sync",
                                icon: AnimatedRotation(
                                  turns: _isSyncing ? 1 : 0,
                                  duration: const Duration(milliseconds: 800),
                                  child: Icon(
                                    Icons.sync,
                                    color: _isSyncing
                                        ? Colors.white70
                                        : Colors.white,
                                    size: 24,
                                  ),
                                ),
                              ),
                            )
                          : SizedBox(),
                    ],
                  ),

                  //tasks add
                  SizedBox(height: 10),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: getCurrentPage(),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: CustomBottomBar(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
    );
  }
}
