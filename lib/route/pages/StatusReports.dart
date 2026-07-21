import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tic_task_app/shared/FilterCard.dart';
import 'package:tic_task_app/shared/TaskCard.dart';

class StatusReports extends ConsumerStatefulWidget {
  const StatusReports({Key? key}) : super(key: key);

  @override
  ConsumerState<StatusReports> createState() => _StatusReportsState();
}

class _StatusReportsState extends ConsumerState<StatusReports> {
  @override
  Widget build(BuildContext context) {
    return Column(
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

        FilterCard(),

        SizedBox(height: 15),
        TaskCard(taskName: "Database Developmenr", description: "LOREM IPSUM HELLO", dueDate: DateTime.now())
      ],
    );
  }
}
