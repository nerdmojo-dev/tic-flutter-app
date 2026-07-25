import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tic_task_app/core/riverpod/AuthNotifier.dart';
import 'package:tic_task_app/core/riverpod/TaskNotifier.dart';
import 'package:tic_task_app/dto/Task.dart';
import 'package:tic_task_app/shared/AppOverlaySnackbar.dart';
import 'package:tic_task_app/shared/FilterCard.dart';
import 'package:tic_task_app/shared/TaskCard.dart';

class StatusReports extends ConsumerStatefulWidget {
  const StatusReports({Key? key}) : super(key: key);

  @override
  ConsumerState<StatusReports> createState() => _StatusReportsState();
}

class _StatusReportsState extends ConsumerState<StatusReports> {
  DateTime? startDate;
  DateTime? endDate;

  Future<void> _showEditDialog(Task task) async {
    final titleController = TextEditingController(text: task.title);
    final descriptionController = TextEditingController(text: task.description);

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Edit Task"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: "Title"),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: descriptionController,
                maxLines: 5,
                decoration: const InputDecoration(labelText: "Description"),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              await ref
                  .read(taskProvider.notifier)
                  .editTask(
                    task.id,
                    titleController.text.trim(),
                    descriptionController.text.trim(),
                  );

              Navigator.pop(context);

              ref.read(taskProvider.notifier).fetchTasks();
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final now = DateTime.now();

    final startDate = DateTime(now.year, now.month, now.day, 0, 0, 0);

    final endDate = DateTime(now.year, now.month, now.day, 23, 59, 59, 999);

    Future.microtask(() {
      ref
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
                    isEdited: task.isEdited,
                    status: task.status,
                    fullName: task.createdBy.fullName,
                    userId: task.createdBy.employeeId,
                    taskId: task.id,
                    onEdit: () => _showEditDialog(task),
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
