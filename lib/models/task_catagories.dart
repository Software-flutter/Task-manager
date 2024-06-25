import 'package:flutter/material.dart';
import 'package:easy_pie_chart/easy_pie_chart.dart';
import 'package:hive/hive.dart';
import 'package:task_manager/constants/constants.dart';
import 'package:task_manager/models/category.dart';
import 'package:task_manager/models/task.dart'; 
import 'package:task_manager/pages/detail/widget/category_task.dart'; 

class BuildCategory extends StatelessWidget {
  const BuildCategory({
    super.key,
    required this.category,
    required this.onDelete,
    required this.taskBox, 
    required this.categoryBox,
  });

  final Category? category;
  final VoidCallback onDelete;
  final Box<Task> taskBox; 
  final Box<Category>categoryBox;
  @override
  Widget build(BuildContext context) {
    IconData iconData = Icons.task_alt_rounded; 

    if (category != null) {
      if (category!.title == 'Personal') {
        iconData = Icons.person;
      } else if (category!.title == 'Workout') {
        iconData = Icons.self_improvement_sharp;
      } else if (category!.title == 'School') {
        iconData = Icons.school_rounded;
      } else if (category!.title == 'Project') {
        iconData = Icons.work;
      }
    }

    int totalTasks = (category?.left ?? 0) + (category?.done ?? 0);
    double completedFraction = totalTasks > 0 ? (category?.done ?? 0) / totalTasks : 0.0;
    double remainingFraction = totalTasks > 0 ? (category?.left ?? 0) / totalTasks : 0.0;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CategoryTask(categoryTitle: category!.title, taskBox: taskBox,categoriesBox: categoryBox,), 
          ),
        );
      },
      onLongPress: () {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: SizedBox(
                height: 75,
                child: Column(
                  children: [
                    const Text(
                      "Delete The Task",
                      style: TextStyle(fontSize: 16),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        MaterialButton(
                          onPressed: () {
                            onDelete();
                            Navigator.pop(context);
                          },
                          child: const Text("Yes"),
                        ),
                        const SizedBox(
                          width: 50,
                        ),
                        MaterialButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text("No"),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
      child: Container(
        width: 200,
        decoration: boxDecoration, 
        padding: const EdgeInsets.all(25),
        margin: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(iconData, color: Colors.white, size: 50),
            const SizedBox(height: 20),
            Text(
              category?.title ?? 'Unknown Category',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 50),
            if (totalTasks == 0)
              const Text(
                'No tasks',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                ),
              )
            else
              EasyPieChart(
                size: 100,
                centerText: 'Tasks',
                centerStyle: const TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                ),
                gap: 0.75,
                showValue: false,
                children: [
                  PieData(
                    value: completedFraction,
                    color: Colors.blue,
                  ),
                  PieData(
                    value: remainingFraction,
                    color: Colors.white,
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
