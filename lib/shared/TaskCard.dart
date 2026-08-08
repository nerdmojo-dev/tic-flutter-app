import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tic_task_app/shared/GlowingGreenDot.dart';

class TaskCard extends StatelessWidget {
  const TaskCard({
    super.key,
    required this.status,
    required this.taskName,
    required this.description,
    required this.isEdited,
    required this.dueDate,
    required this.isEditable,
    required this.isSynced,
    this.fullName,
    this.userId,
    required this.taskId,
    required this.onEdit,
  });
  final VoidCallback? onEdit;
  final String taskId;
  final bool isEdited;
  final String status;
  final bool isEditable;
  final bool isSynced;
  final String taskName;
  final String description;
  final String dueDate;
  final String? fullName;
  final String? userId;

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color textColor;
    IconData icon;
    switch (status) {
      case "Completed":
        bgColor = Colors.green.shade100;
        textColor = Colors.green.shade700;
        icon = Icons.check_circle;
        break;

      case "In Progress":
        bgColor = Colors.orange.shade100;
        textColor = Colors.orange.shade700;
        icon = Icons.autorenew;
        break;

      case "Cancelled":
        bgColor = Colors.red.shade100;
        textColor = Colors.red.shade700;
        icon = Icons.cancel;
        break;

      case "Todo":
      default:
        bgColor = Colors.blue.shade100;
        textColor = Colors.blue.shade700;
        icon = Icons.schedule;
        break;
    }
    print("ISEDITABLE:$isEditable");
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
                    color: bgColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(icon, size: 16, color: textColor),
                      const SizedBox(width: 6),
                      Text(
                        status,
                        style: TextStyle(
                          color: textColor,
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
                        userId!.length > 7
                            ? "...${userId!.substring(userId!.length - 7)}"
                            : userId!,

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

                isEditable
                    ? !isEdited
                          ? Transform.scale(
                              scale: 0.8, // 80% of original size
                              alignment: Alignment.centerRight,
                              child: OutlinedButton.icon(
                                onPressed: onEdit,
                                icon: const Icon(Icons.edit_outlined, size: 16),
                                label: const Text("Edit"),
                              ),
                            )
                          : const Text("Edited")
                    : const SizedBox(),
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
                  dueDate.substring(0, 12),
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
                Expanded(
                  child: Text(
                    fullName!,
                    softWrap: true,
                    maxLines: 1,
                    style: const TextStyle(color: Colors.grey),
                  ),
                ),
                SizedBox(width: 10,),
                GlowingGreenDot(size: 8,isSynced: isSynced,),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
