import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TaskCard extends StatelessWidget {
  const TaskCard({
    super.key,
    required this.status,
    required this.taskName,
    required this.description,
    required this.isEdited,
    required this.dueDate,
    this.fullName,
    this.userId,
    required this.taskId,
    required this.onEdit,
  });
  final VoidCallback? onEdit;
  final String taskId;
  final bool isEdited;
  final String status;
  final String taskName;
  final String description;
  final DateTime dueDate;
  final String? fullName;
  final String? userId;

  bool get _isSubmissionWindowOpen {
    final now = DateTime.now();

    final start = DateTime(
      now.year,
      now.month,
      now.day,
      16, // 4 PM
      0,
    );

    final end = DateTime(
      now.year,
      now.month,
      now.day,
      23, // 11:30 PM
      30,
    );

    return now.isAfter(start) && now.isBefore(end);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      shadowColor: Colors.transparent,
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(color: Colors.grey.shade300, width: 1.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Badge
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.autorenew,
                        size: 16,
                        color: Colors.green.shade700,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        status,
                        style: TextStyle(
                          color: Colors.green.shade700,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 8),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade100,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.verified_user_rounded,
                        size: 16,
                        color: Colors.blue.shade700,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        userId!.toUpperCase(),
                        style: TextStyle(
                          color: Colors.blue.shade700,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),

                const Spacer(),
                !isEdited
                    ? _isSubmissionWindowOpen
                          ? OutlinedButton.icon(
                              onPressed: onEdit,
                              icon: const Icon(Icons.edit_outlined),
                              label: const Text("Edit"),
                            ):SizedBox()
                    : const Text("Edited"),
              ],
            ),

            const SizedBox(height: 10),

            // Report Details
            Text(
              taskName,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),
            Text(
              description,
              style: const TextStyle(color: Colors.grey),
              maxLines: 10,
            ),
            const SizedBox(height: 6),

            Row(
              children: [
                Icon(
                  Icons.calendar_today_outlined,
                  size: 16,
                  color: Colors.grey,
                ),
                const SizedBox(width: 4),
                Text(
                  DateFormat("MMM dd, yyyy").format(dueDate),
                  style: const TextStyle(color: Colors.grey),
                ),

                const SizedBox(width: 10),

                // Container(
                //   width: 5,
                //   height: 5,
                //   decoration: const BoxDecoration(
                //     color: Colors.grey,
                //     shape: BoxShape.circle,
                //   ),
                // ),

                // const SizedBox(width: 10),

                // Icon(Icons.access_time_outlined, size: 16, color: Colors.grey),
                // const SizedBox(width: 4),
                // Text(
                //   DateFormat("hh:mm a").format(dueDate),
                //   style: TextStyle(color: Colors.grey),
                // ),
                // const SizedBox(width: 10),
                Container(
                  width: 5,
                  height: 5,
                  decoration: const BoxDecoration(
                    color: Colors.grey,
                    shape: BoxShape.circle,
                  ),
                ),

                const SizedBox(width: 10),
                Icon(Icons.person_2, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(fullName!, style: TextStyle(color: Colors.grey)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
