import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_2/model.dart';

class Taskprovider with ChangeNotifier {
  final Box<TaskModel> taskBox = Hive.box<TaskModel>('tasks');
  List<TaskModel> get tasks => taskBox.values.toList();

  addTask(TaskModel task) {
    taskBox.add(task);
    notifyListeners();
  }

  void editTask(int index, TaskModel task) {
    taskBox.putAt(index, task);
    notifyListeners();
  }

  void deleteTask(int index) {
    taskBox.delete(index);
    notifyListeners();
  }

  void toggleTaskCompletion(int index) {
    final task = taskBox.getAt(index)!;
    task.isCompleted = !task.isCompleted;
    taskBox.putAt(index, task);
    notifyListeners();
  }
}
