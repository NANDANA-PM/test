import 'package:hive/hive.dart';
part 'model.g.dart';

@HiveType(typeId: 1)
class TaskModel {
  @HiveField(0)
  int? id;
  @HiveField(1)
  final String tasktitle;

  @HiveField(2)
  final String date;

  @HiveField(3)
  final String time;

  @HiveField(4)
  String priority;
  @HiveField(5)
  bool isCompleted;
  TaskModel({
    this.id,
    required this.tasktitle,
    required this.date,
    required this.time,
    required this.priority,
    this.isCompleted = false,
  });

  // static getAt(int index) {}
}
