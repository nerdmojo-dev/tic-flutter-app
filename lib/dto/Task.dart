import 'package:tic_task_app/dto/User.dart';

class Task {
  final String id;
  final String title;
  final String description;
  final String status;
  final String priority;
  final List<dynamic> assignedTo;
  final User createdBy;
  final DateTime dueDate;
  final List<dynamic> tags;
  final bool isDeleted;
  final List<dynamic> comments;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int version;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.priority,
    required this.assignedTo,
    required this.createdBy,
    required this.dueDate,
    required this.tags,
    required this.isDeleted,
    required this.comments,
    required this.createdAt,
    required this.updatedAt,
    required this.version,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json["_id"],
      title: json["title"],
      description: json["description"],
      status: json["status"],
      priority: json["priority"],
      assignedTo: List<dynamic>.from(json["assignedTo"]),
      createdBy: User.fromJson(json["createdBy"]),
      dueDate: DateTime.parse(json["dueDate"]),
      tags: List<dynamic>.from(json["tags"]),
      isDeleted: json["isDeleted"],
      comments: List<dynamic>.from(json["comments"]),
      createdAt: DateTime.parse(json["createdAt"]),
      updatedAt: DateTime.parse(json["updatedAt"]),
      version: json["__v"],
    );
  }
}