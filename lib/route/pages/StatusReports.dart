import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:tic_task_app/core/riverpod/TaskNotifier.dart';
import 'package:tic_task_app/dto/Task.dart';
import 'package:tic_task_app/route/EditStatusPage.dart';
import 'package:tic_task_app/shared/AppOverlaySnackbar.dart';
import 'package:tic_task_app/shared/DateTime.dart';
import 'package:tic_task_app/shared/SecureStorage.dart';
import 'package:tic_task_app/shared/TaskCard.dart';

class StatusReports extends ConsumerStatefulWidget {
  const StatusReports({super.key});

  @override
  ConsumerState<StatusReports> createState() => _StatusReportsState();
}

class _StatusReportsState extends ConsumerState<StatusReports> {
  DateTime? startDate;
  DateTime? endDate;
  String? currentEmpId;

  

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

  bool isToday(DateTime a) {
    DateTime b = DateTime.now();
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  @override
  Widget build(BuildContext context) {
    final tasks = ref.watch(taskProvider);

    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            
            DateTimeWidget(),

            // FilterCard(
            //   startDate: startDate,
            //   endDate: endDate,
            //   onStartDateChanged: (date) {
            //     setState(() {
            //       startDate = date;
            //     });
            //   },
            //   onEndDateChanged: (date) {
            //     setState(() {
            //       endDate = date;
            //     });
            //   },
            //   onApply: () {
            //     ref
            //         .read(taskProvider.notifier)
            //         .fetchTasks(startDate: startDate, endDate: endDate);
            //   },
            // ),
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

                print(
                  "Total tasks: ${response[1].data.tasks.length}-${response[0].data.tasks.length}=${allTasks.length}",
                );
                final startCloud = response[1].data.tasks.length;
                if (allTasks.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.assignment_outlined,
                            size: 42,
                            color: Colors.grey.shade500,
                          ),
                        ),

                        const Text(
                          "No tasks submitted yet",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),

                        const SizedBox(height: 8),

                        Text(
                          "Your submitted tasks will appear here.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
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
                        isEditable:
                            task.createdBy.id == currentEmpId && isToday(localDate),
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
                }
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
