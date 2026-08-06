import 'package:flutter/material.dart';
import 'package:tic_task_app/dto/Task.dart';
import 'package:tic_task_app/route/pages/AddTask.dart';

class EditTaskPage extends StatelessWidget {
  const EditTaskPage({super.key, this.task});
  final Task? task;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: AddTask(key: UniqueKey(), task: task),
      ),
    );
  }
}
