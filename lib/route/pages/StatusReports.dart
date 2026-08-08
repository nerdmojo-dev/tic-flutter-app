import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:tic_task_app/core/dio/dio_client.dart';
import 'package:tic_task_app/core/repository/TaskRepository.dart';
import 'package:tic_task_app/core/riverpod/AppDatabase.dart';
import 'package:tic_task_app/core/riverpod/AuthNotifier.dart';
import 'package:tic_task_app/core/riverpod/TaskNotifier.dart';
import 'package:tic_task_app/dto/Task.dart';
import 'package:tic_task_app/route/EditStatusPage.dart';
import 'package:tic_task_app/route/pages/AddTask.dart';
import 'package:tic_task_app/shared/AppOverlaySnackbar.dart';
import 'package:tic_task_app/shared/FilterCard.dart';
import 'package:tic_task_app/shared/SecureStorage.dart';
import 'package:tic_task_app/shared/SyncService.dart';
import 'package:tic_task_app/shared/TaskCard.dart';

class StatusReports extends ConsumerStatefulWidget {
  const StatusReports({Key? key}) : super(key: key);

  @override
  ConsumerState<StatusReports> createState() => _StatusReportsState();
}

class _StatusReportsState extends ConsumerState<StatusReports> {
  DateTime? startDate;
  DateTime? endDate;
  String? currentEmpId;

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

  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      // Load local tasks first

      // Then try fetching latest tasks from server
      final now = DateTime.now();

      startDate = DateTime(now.year, now.month, now.day, 0, 0, 0);

      endDate = DateTime(now.year, now.month, now.day, 23, 59, 59, 999);
      await ref
          .read(taskProvider.notifier)
          .fetchTasks(startDate: startDate, endDate: endDate);
    });

    ref.listenManual(taskProvider, (previous, next) {
      next.whenOrNull(
        error: (error, stackTrace) {
          AppOverlaySnackbar.showError(
            context,
            message: "Task fetching failed",
          );
        },
      );
    });

    _loadEmpId();
  }

  Future<void> _loadEmpId() async {
    currentEmpId = await SecureStorage.getuserId();
    setState(() {});
  }

  @override
  void dispose() {
    print("AddTask dispose");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tasks = ref.watch(taskProvider);

    return SafeArea(
      child: SingleChildScrollView(
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
                      "Welcome Back",
                      style: TextStyle(fontSize: 15, color: Color(0xff0F172A)),
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
                AnimatedContainer(
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
                            : const Color(0xFF2563EB).withValues(alpha: 0.2),
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
                        color: _isSyncing ? Colors.white70 : Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            //tasks add
            SizedBox(height: 30),
            FilterCard(
              startDate: startDate,
              endDate: endDate,
              onStartDateChanged: (date) {
                setState(() {
                  startDate = date;
                });
              },
              onEndDateChanged: (date) {
                setState(() {
                  endDate = date;
                });
              },
              onApply: () {
                ref
                    .read(taskProvider.notifier)
                    .fetchTasks(startDate: startDate, endDate: endDate);
              },
            ),

            SizedBox(height: 20),
            tasks.when(
              loading: () => const Center(child: CircularProgressIndicator()),

              error: (e, _) => const SizedBox(),

              data: (response) {
                final List<Task> allTasks = [];
                if (response[1].data.tasks.isNotEmpty) {
                  allTasks.addAll(response[1].data.tasks); // Local tasks first
                }
                if (response[0].hasError) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (!mounted) return;

                    AppOverlaySnackbar.showError(
                      context,
                      message: "Task fetching failed from server",
                    );
                  });
                } else {
                  allTasks.addAll(response[0].data.tasks);
                }

                debugPrint(
                  "Total tasks: ${response[1].data.tasks.length}-${response[0].data.tasks.length}=${allTasks.length}",
                );
                final startCloud = response[1].data.tasks.length;

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),

                  itemCount: allTasks.length,
                  itemBuilder: (_, index) {
                    final task = allTasks[index];
                    final localDate = task.dueDate.toLocal();
                    final date = DateFormat(
                      "MMM dd, yyyy hh:mm a",
                    ).format(localDate);
                    print(task.createdBy.id);
                    print(currentEmpId);

                    final isSynced = index >= startCloud;

                    return TaskCard(
                      taskName: task.title,
                      description: task.description,
                      dueDate: date,
                      isEdited: task.isEdited,
                      status: task.status,
                      fullName: task.createdBy.fullName,
                      userId: task.createdBy.employeeId,
                      taskId: task.id,
                      isSynced: isSynced,
                      isEditable: task.createdBy.id == currentEmpId,
                      onEdit: () async {
                        final updated = await Navigator.push<bool>(
                          context,
                          MaterialPageRoute(
                            builder: (_) => EditTaskPage(task: task),
                          ),
                        );

                        if (updated == true) {
                          ref
                              .read(taskProvider.notifier)
                              .fetchTasks(
                                startDate: startDate,
                                endDate: endDate,
                              );
                        }
                      },
                    );
                  },
                );
              },
            ),
            // FilterCard(),
            SizedBox(height: 15),
          ],
        ),
      ),
    );
  }
}
