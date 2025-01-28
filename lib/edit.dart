import 'package:flutter/material.dart';
// import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo_2/dbfunction.dart';
import 'package:todo_2/model.dart';
// import 'package:todo_2/main.dart';

void main() {
  runApp(MultiProvider(
    providers: [ChangeNotifierProvider(create: (_) => Taskprovider())],
    child: MyAPP(),
  ));
}

class MyAPP extends StatelessWidget {
  const MyAPP({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: EditTask(
          task: TaskModel(
              tasktitle: '',
              date: '',
              priority: 'Medium',
              isCompleted: false,
              time: ''),
          index: 0),
    );
  }
}

class EditTask extends StatelessWidget {
  final TaskModel task;
  final int index;

  const EditTask({super.key, required this.task, required this.index});

  @override
  Widget build(BuildContext context) {
    final titleController = TextEditingController(text: task.tasktitle);
    final dateController = TextEditingController(text: task.date);
    final timeController = TextEditingController(text: task.time);
    final selectedPriority = ValueNotifier<String>(task.priority);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Edit NewTask',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 36),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                  labelText: 'Task Title',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  )),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: dateController,
                    readOnly: true,
                    decoration: InputDecoration(
                        labelText: 'Select Due Date',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0)),
                        suffixIcon: IconButton(
                            onPressed: () async {
                              final DateTime? pickeddate = await showDatePicker(
                                  context: context,
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(2027)
                                      .add(const Duration(days: 365)));
                              if (pickeddate != null) {
                                dateController.text =
                                    DateFormat("dd-MM-yyyy").format(pickeddate);
                              }

                              print(pickeddate);
                            },
                            icon: const Icon(Icons.calendar_today))),
                  ),
                ),
                const SizedBox(
                  width: 4,
                ),
                Expanded(
                    child: TextField(
                  controller: timeController,
                  decoration: InputDecoration(
                      labelText: 'Select Time',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0)),
                      suffixIcon: IconButton(
                          onPressed: () async {
                            TimeOfDay? pickedTime = await showTimePicker(
                                context: context, initialTime: TimeOfDay.now());
                            if (pickedTime != null) {
                              timeController.text = pickedTime.format(context);
                            }
                          },
                          icon: const Icon(Icons.access_time))),
                  readOnly: true,
                )),
              ],
            ),
            const SizedBox(height: 10),
            ValueListenableBuilder<String>(
              valueListenable: selectedPriority,
              builder: (context, tasks, child) {
                return DropdownButtonFormField<String>(
                  value: 'Low', // Default value
                  items: const [
                    DropdownMenuItem(
                      value: 'High',
                      child: Text('High', style: TextStyle(color: Colors.red)),
                    ),
                    DropdownMenuItem(
                      value: 'Medium',
                      child: Text('Medium',
                          style: TextStyle(color: Colors.yellow)),
                    ),
                    DropdownMenuItem(
                      value: 'Low',
                      child: Text('Low', style: TextStyle(color: Colors.green)),
                    ),
                  ],
                  onChanged: (newvalue) {
                    if (newvalue != null) {
                      selectedPriority.value = newvalue;
                    }
                  },
                  decoration: InputDecoration(
                      labelText: 'Priority Level',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0))),
                );
              },
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  final task = TaskModel(
                      tasktitle: titleController.text,
                      date: dateController.text,
                      time: timeController.text,
                      priority: selectedPriority.value);
                  Provider.of<Taskprovider>(context, listen: false)
                      .editTask(index, task);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                child: const Text('Save Task'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
