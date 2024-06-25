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
                  leading: Checkbox(
                    value: task.isDone,
                    onChanged: (bool? value) {
                      if (value != null) {
                        task.isDone = value;
                        taskBox.put(task.key, task);
                        updateCategory(task.category, value);
                      }
                    },
                  ),
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
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          showEditTaskDialog(context, task);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          deleteTaskAndUpdateCategory(task, index);
                        },
                      ),
                    ],
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

  void showEditTaskDialog(BuildContext context, Task task) {
    TextEditingController titleController = TextEditingController(text: task.title);
    TextEditingController descriptionController = TextEditingController(text: task.description);
    DateTime? selectedDeadline = task.deadline;
    DateTime? selectedStartedTime = task.startedTime;
    String? selectedCategory = task.category;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Edit Task"),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: "Title"),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: "Description"),
                ),
                const SizedBox(height: 10),
                const Text("Deadline"),
                ElevatedButton(
                  onPressed: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: selectedDeadline ?? DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );
                    if (pickedDate != null) {
                      selectedDeadline = pickedDate;
                    }
                  },
                  child: Text(selectedDeadline != null
                      ? DateFormat.yMMMd().format(selectedDeadline!)
                      : "Pick a deadline"),
                ),
                const SizedBox(height: 10),
                const Text("Started Time"),
                ElevatedButton(
                  onPressed: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: selectedStartedTime ?? DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );
                    if (pickedDate != null) {
                      selectedStartedTime = pickedDate;
                    }
                  },
                  child: Text(selectedStartedTime != null
                      ? DateFormat.yMMMd().format(selectedStartedTime!)
                      : "Pick a start time"),
                ),
                const SizedBox(height: 10),
                const Text("Category"),
                ValueListenableBuilder(
                  valueListenable: categoriesBox.listenable(),
                  builder: (context, Box<Category> box, _) {
                    List<String> categories = box.values.map((c) => c.title).toList();
                    return DropdownButton<String>(
                      value: selectedCategory,
                      hint: const Text("Select category"),
                      onChanged: (newValue) {
                        selectedCategory = newValue;
                      },
                      items: categories.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    );
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                task.updateTask(
                  title: titleController.text,
                  description: descriptionController.text,
                  category: selectedCategory,
                  deadline: selectedDeadline,
                  startedTime: selectedStartedTime,
                );
                task.save();
                Navigator.of(context).pop();
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }
}
