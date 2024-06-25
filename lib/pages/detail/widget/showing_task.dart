import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:task_manager/models/category.dart';
import 'package:task_manager/models/task.dart';
import 'package:task_manager/pages/detail/widget/add_new_task.dart';
import 'package:task_manager/pages/home/widgets/home.dart';

class TasksPage extends StatelessWidget {
  const TasksPage({
    super.key,
    required this.taskBox,
    required this.categoriesBox,
    required this.categoriesName,
  });

  final Box<Task> taskBox;
  final Box<Category> categoriesBox;
  final Box<String> categoriesName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
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
          return Column(
            children: [
              Expanded( // Wrap ListView.builder with Expanded
                child: ListView.builder(
                  itemCount: box.length,
                  itemBuilder: (context, index) {
                    Task? task = box.getAt(index);
                    return Card(
                      elevation: 3,
                      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        leading: Checkbox(
                          value: task?.isDone ?? false,
                          onChanged: (bool? value) {
                            if (task != null) {
                              task.isDone = value ?? false;
                              box.putAt(index, task);
                              updateCategory(task.category, value ?? false);
                            }
                          },
                        ),
                        title: Text(
                          task?.title ?? 'No Title',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 5),
                            Text(
                              task?.category ?? 'No Category',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              'Description: ${task?.description ?? 'No Description'}',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              'Deadline: ${DateFormat.yMMMd().format(task?.deadline ?? DateTime.now())}',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              'Started Time: ${DateFormat.yMMMd().format(task?.startedTime ?? DateTime.now())}',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ],
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            deleteTaskAndUpdateCategory(task, index);
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NewTask(
                        taskBox: taskBox,
                        categoryBox: categoriesName,
                        categories: categoriesBox,
                      ),
                    ),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    padding: const EdgeInsets.all(10),
                    child: const Icon(
                      Icons.add,
                      size: 30,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.blueAccent,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: 'Tasks',
          ),
        ],
        selectedItemColor: Colors.black,
        onTap: (index) {
          if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
            );
          }
        },
      ),
    );
  }

  void updateCategory(String? categoryTitle, bool isChecked) {
    if (categoryTitle == null) return;

    final categoryIndex =
        categoriesBox.values.toList().indexWhere((category) => category.title == categoryTitle);

    if (categoryIndex != -1) {
      final category = categoriesBox.getAt(categoryIndex);
      if (category != null) {
        final updatedCategory = Category(
          title: category.title,
          left: category.left,
          done: isChecked ? (category.done ?? 0) + 1 : (category.done ?? 0) - 1,
        );
        categoriesBox.putAt(categoryIndex, updatedCategory);
      }
    }
  }

  void deleteTaskAndUpdateCategory(Task? task, int index) {
    if (task == null) return;

    final bool isTaskDone = task.isDone ?? false;

    final categoryIndex = categoriesBox.values
        .toList()
        .indexWhere((category) => category.title == task.category);

    if (categoryIndex != -1) {
      final category = categoriesBox.getAt(categoryIndex);
      if (category != null) {
        final int leftCount = category.left ?? 0;
        final int doneCount = category.done ?? 0;

        final updatedCategory = Category(
          title: category.title,
          left: isTaskDone ? leftCount : leftCount - 1,
          done: isTaskDone ? doneCount - 1 : doneCount,
        );
        categoriesBox.putAt(categoryIndex, updatedCategory);
      }
    }
    taskBox.deleteAt(index);
  }
}
