import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:task_manager/models/category.dart';
import 'package:task_manager/models/task.dart';
import 'package:task_manager/pages/home/widgets/home.dart';

class CategoryTask extends StatelessWidget {
  final String categoryTitle;
  final Box<Task> taskBox;
  final Box<Category> categoriesBox;

  const CategoryTask({
    super.key,
    required this.categoryTitle,
    required this.taskBox,
    required this.categoriesBox,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(categoryTitle),
      ),
      body: ValueListenableBuilder(
        valueListenable: taskBox.listenable(),
        builder: (context, Box<Task> box, _) {
          List<Task> categoryTasks =
              box.values.where((task) => task.category == categoryTitle).toList();

          if (categoryTasks.isEmpty) {
            return Center(
              child: Text(
                'No tasks found for $categoryTitle',
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          return ListView.builder(
            itemCount: categoryTasks.length,
            itemBuilder: (context, index) {
              Task task = categoryTasks[index];
              return Card(
                elevation: 3,
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  title: Text(
                    task.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 5),
                      Text(
                        'Description: ${task.description ?? 'No Description'}',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'Deadline: ${task.deadline != null ? DateFormat.yMMMd().format(task.deadline!) : 'No Deadline'}',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'Started Time: ${task.startedTime != null ? DateFormat.yMMMd().format(task.startedTime!) : 'No Start Time'}',
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
            icon: Icon(Icons.calendar_today),
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

  void deleteTaskAndUpdateCategory(Task task, int index) {
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
