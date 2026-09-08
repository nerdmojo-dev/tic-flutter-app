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
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                      "Welcome",
                      style: TextStyle(fontSize: 15, color: Color(0xff0F172A)),
                    ),
                    Text(
                      "Edit Task",
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
            AddTask(task: task),
          ],
        ),
      ),
    );
  }
}
