import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:todo_2/add.dart';
import 'package:todo_2/dbfunction.dart';
import 'package:todo_2/edit.dart';

// import 'package:todo_2/dbfunction.dart';
// import 'package:todo_2/dbfunction.dart'
import 'package:todo_2/model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  if (!Hive.isAdapterRegistered(TaskModelAdapter().typeId)) {
    Hive.registerAdapter(TaskModelAdapter());
  }
  // Hive.registerAdapter(TaskModelAdapter());
  await Hive.openBox<TaskModel>('tasks');
  runApp(const ToDoApp());
}

class ToDoApp extends StatelessWidget {
  const ToDoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => Taskprovider(),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: ToDoScreen(),
      ),
    );
  }
}

class ToDoScreen extends StatelessWidget {
  const ToDoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<Taskprovider>(builder: (context, provider, child) {
      final tasks = provider.tasks;
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'My To-Dos',
            style: TextStyle(
              color: Colors.teal,
              fontSize: 36,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: tasks.isEmpty
            ? Center(
                child: Text(
                  'No tasks added.Tap + to add one!',
                  style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                ),
              )
            : ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  final task = tasks[index];
                  return TaskCard(
                    task: task,
                    onEdit: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  EditTask(task: task, index: index)));
                    },
                    onDelete: () => provider.deleteTask(index),
                    onTogglecompletion: () =>
                        provider.toggleTaskCompletion(index),
                  );
                }),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddTask(),
              ),
            );
          },
          child: const Icon(Icons.add),
        ),
      );
    });
  }
}

class TaskCard extends StatelessWidget {
  final TaskModel task;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onTogglecompletion;
  const TaskCard({
    super.key,
    required this.task,
    required this.onEdit,
    required this.onDelete,
    required this.onTogglecompletion,
  });

  Color getPriorityColor(String priority) {
    return {
          'High': const Color.fromARGB(255, 250, 113, 104),
          'Medium': const Color.fromARGB(255, 248, 179, 5),
          'Low': const Color.fromARGB(255, 93, 203, 97)
        }[priority] ??
        Colors.white;
  }
  // String formatTime(String time)
  // {
  //   try{
  //     final timeParts=time.split(':');
  //     final hour =int.parse(timeParts[0]);
  //     final minute =int.parse(timeParts[1]);
  //     final period =hour >=12 ? 'PM' : 'AM';
  //     final formattedHour =hour >12 ? hour -12 :(hour ==0 ?12 :hour);
  //     return '${formattedHour.toString().padLeft(2,'0')}:${minute.toString().padLeft(2, '0')} $period';

  //   }
  //   catch(e)
  //   {
  //     return time;
  //   }
  // }
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Container(
        color: getPriorityColor(task.priority),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Checkbox(
                value: task.isCompleted,
                onChanged: (value) => onTogglecompletion(),
              ),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.tasktitle,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      decoration: task.isCompleted
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                    softWrap: true,
                    maxLines: null,
                    overflow: TextOverflow.visible,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    'Due Date:${task.date}',
                    style: const TextStyle(fontSize: 14, color: Colors.black),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Time:${task.time}',
                    style: const TextStyle(fontSize: 14, color: Colors.black),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Priority:${task.priority}',
                    style: const TextStyle(fontSize: 14, color: Colors.black),
                  )
                ],
              )),
              const SizedBox(
                width: 16,
              ),
              Column(
                children: [
                  IconButton(
                    onPressed: onEdit,
                    icon: const Icon(
                      Icons.edit,
                      color: Color.fromARGB(255, 6, 125, 83),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            backgroundColor: Colors.teal,
                            title: Center(
                              child: Column(
                                children: [
                                  const Text(
                                    'Do you want to delete this task?',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 19,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(
                                    height: 55,
                                  ),
                                  const Divider(
                                    thickness: 2,
                                    color: Color.fromARGB(255, 1, 95, 86),
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text(
                                          'Cancel',
                                          style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 235, 234, 234),
                                              fontSize: 20),
                                        ),
                                      ),
                                      Container(
                                        height: 35,
                                        width: 2,
                                        color: const Color.fromARGB(
                                            255, 1, 95, 86),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          onDelete();
                                          Navigator.pop(context);
                                        },
                                        child: const Text(
                                          'Delete',
                                          style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 252, 21, 5),
                                              fontSize: 20),
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                    child: Icon(
                      Icons.delete,
                      color: Colors.red[600],
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
