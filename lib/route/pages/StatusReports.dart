import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tic_task_app/core/riverpod/AuthNotifier.dart';
import 'package:tic_task_app/core/riverpod/TaskNotifier.dart';
import 'package:tic_task_app/shared/AppOverlaySnackbar.dart';
import 'package:tic_task_app/shared/FilterCard.dart';
import 'package:tic_task_app/shared/StatusReportsFilterDateCard.dart';
import 'package:tic_task_app/shared/TaskCard.dart';

class StatusReports extends ConsumerStatefulWidget {
  const StatusReports({Key? key}) : super(key: key);

  @override
  ConsumerState<StatusReports> createState() => _StatusReportsState();
}

class _StatusReportsState extends ConsumerState<StatusReports> {
  DateTime? startDate;
  DateTime? endDate;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ref.listenManual(taskProvider, (previous, next) {
      next.whenOrNull(
        error: (error, stackTrace) {
          print(error);
          print(stackTrace);
          AppOverlaySnackbar.showError(
            context,
            message: "Task fetching failed",
          );
        },
      );
    });
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
                    child: Image(image: AssetImage("lib/assets/logo.jpg")),
                  ),
                ),
                SizedBox(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Welcome Back",
                      style: TextStyle(fontSize: 15, color: Color(0xff0F172A)),
                    ),
                    const Text(
                      "Status Reports",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 22,
                        color: Color(0xff0F172A),
                      ),
                    ),
                  ],
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

              data: (response) => ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),

                itemCount: response.data.tasks.length,
                itemBuilder: (_, index) {
                  final task = response.data.tasks[index];
                  print(task);

                  return TaskCard(
                    taskName: task.title,
                    description: task.description,
                    dueDate: task.dueDate,
                    status: task.status,
                    fullName: task.createdBy.fullName,
                    userId: task.createdBy.employeeId,
                  );
                },
              ),
            ),
            // FilterCard(),
            SizedBox(height: 15),
          ],
        ),
      ),
    );
  }
}
