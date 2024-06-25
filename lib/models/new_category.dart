import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class CreateNewCategory extends StatelessWidget {
  const CreateNewCategory({
    super.key,
    required this.categories,
    required this.controller,
    required this.saveCategory,
  });

  final Box categories;
  final TextEditingController controller;
  final Function saveCategory;

  @override
  Widget build(BuildContext context) {
    void addCategoryNotification() {
      AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: 1,
          channelKey: 'basic_channel',
          title: 'Category Added',
          body: 'A new category has been added successfully!',
          
          notificationLayout: NotificationLayout.BigPicture,
          largeIcon: 'resource://drawable/ic_stat_img',
        ),
      );
    }

    return AlertDialog(
      content: SizedBox(
        height: 150,
        width: 400,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Category Name",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Enter category name",
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                MaterialButton(
                  onPressed: () => {
                    saveCategory(controller.text),
                    Navigator.of(context).pop(),
                    addCategoryNotification(),
                    controller.clear(),
                  },
                  child: const Text('ADD'),
                ),
                MaterialButton(
                  onPressed: Navigator.of(context).pop,
                  child: const Text('CANCEL'),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
