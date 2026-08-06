import 'package:isar/isar.dart';

@collection
class TaskLocal {
  Id id = Isar.autoIncrement;

  late String taskId;

  late String title;

  late String description;

  late String status;

  String? translatedDescription; // English

  late DateTime createdAt;

  bool synced = false;
  bool isEdited = false;
}
