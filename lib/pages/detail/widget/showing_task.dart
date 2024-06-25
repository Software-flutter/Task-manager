import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:task_manager/models/category.dart';
import 'package:task_manager/models/task.dart';
import 'package:task_manager/pages/detail/widget/edit_task.dart';

class TasksPage extends StatelessWidget {
  final Box<Task> taskBox;
  final Box<Category> categoriesBox;
  final Box<String> categoriesName;

  const TasksPage({
    super.key,
    required this.taskBox,
    required this.categoriesBox,
    required this.categoriesName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("All Tasks"),
      ),
      body: ValueListenableBuilder(
        valueListenable: taskBox.listenable(),
        builder: (context, Box<Task> box, _) {
          if (box.isEmpty) {
            return const Center(
              child: Text(
                'No tasks added yet',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }
          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (context, index) {
              Task task = box.getAt(index)!;
              return ListTile(
                title: Text(task.title),
                subtitle: Text(task.category ?? 'No Category'),
                trailing: IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditTaskScreen(
                          taskBox: taskBox,
                          task: task,
                          categoriesBox: categoriesBox,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
