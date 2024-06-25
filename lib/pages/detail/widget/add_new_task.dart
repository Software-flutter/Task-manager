import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:task_manager/models/category.dart';
import 'package:task_manager/models/task.dart';
import 'package:task_manager/pages/home/widgets/home.dart';

class NewTask extends StatefulWidget {
  const NewTask(
      {super.key,
      required this.taskBox,
      required this.categoryBox,
      required this.categories});
  final Box<Task>? taskBox;
  final Box<String>? categoryBox;
  final Box<Category>? categories;

  @override
  State<NewTask> createState() => _NewTaskState();
}

class _NewTaskState extends State<NewTask> {
  DateTime today = DateTime.now();
  final TextEditingController textController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  bool isDone = false;
  String? selectedCategory;

  void addTask(String title, String? category, String? description, bool isDone,
      DateTime deadline, DateTime startedTime) {
    final newTask = Task(
      title: title,
      category: category,
      description: description,
      isDone: false,
      deadline: deadline,
      startedTime: startedTime,
    );

    widget.taskBox?.add(newTask);
    incrementCategoryLeft(category);
  }

  void incrementCategoryLeft(String? categoryTitle) {
    if (categoryTitle == null) return;

    final categoryIndex = widget.categories?.values
        .toList()
        .indexWhere((category) => category.title == categoryTitle);

    if (categoryIndex != null && categoryIndex != -1) {
      final category = widget.categories?.getAt(categoryIndex);
      if (category != null) {
        final updatedCategory = Category(
          title: category.title,
          left: (category.left ?? 0) + 1,
          done: category.done,
        );
        widget.categories?.putAt(categoryIndex, updatedCategory);
      }
    }
  }

  void _onDaySelected(DateTime day, DateTime focusedDay) {
    setState(() {
      today = day;
    });
  }

  @override
  Widget build(BuildContext context) {
    void addTaskNotification() {
      AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: 1,
          channelKey: 'basic_channel',
          title: 'Task Added',
          body: 'A new Task has been added successfully!',
          notificationLayout: NotificationLayout.BigPicture,
          largeIcon: 'resource://drawable/ic_stat_img',
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("New Task"),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Selected Day: ${today.toString().split(" ")[0]}",
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              TableCalendar(
                headerStyle: const HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                ),
                availableGestures: AvailableGestures.all,
                focusedDay: today,
                firstDay: DateTime.utc(2024, 1, 1),
                lastDay: DateTime.utc(2030, 12, 31),
                onDaySelected: _onDaySelected,
                selectedDayPredicate: (day) => isSameDay(day, today),
              ),
              const SizedBox(height: 20),
              const Text(
                "Task Name",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: textController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Enter task name",
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Category",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              widget.categoryBox != null
                  ? ValueListenableBuilder(
                      valueListenable: widget.categoryBox!.listenable(),
                      builder: (context, Box<String> box, _) {
                        List<String> categories = box.values.toList();
                        return DropdownButton<String>(
                          value: selectedCategory,
                          hint: const Text("Select category"),
                          onChanged: (newValue) {
                            setState(() {
                              selectedCategory = newValue;
                            });
                          },
                          items: categories
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        );
                      },
                    )
                  : const SizedBox(),
              const SizedBox(height: 20),
              const Text(
                "Description",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Enter description",
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    String taskName = textController.text;
                    String description = descriptionController.text;
                    addTask(
                      taskName,
                      selectedCategory,
                      description.isNotEmpty ? description : null,
                      isDone,
                      today,
                      DateTime.now(),
                    );
                    addTaskNotification();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const HomePage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1976D2),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 15,
                    ),
                  ),
                  child: const Text(
                    "Save Task",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
