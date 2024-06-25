import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:task_manager/models/category.dart';
import 'package:task_manager/models/task.dart';

class EditTaskScreen extends StatefulWidget {
  final Box<Task> taskBox;
  final Task task;
  final Box<Category> categoriesBox;

  const EditTaskScreen({
    super.key,
    required this.taskBox,
    required this.task,
    required this.categoriesBox,
  });

  @override
  // ignore: library_private_types_in_public_api
  _EditTaskScreenState createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  DateTime? _deadline;
  DateTime? _startedTime;
  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task.title);
    _descriptionController =
        TextEditingController(text: widget.task.description);
    _deadline = widget.task.deadline;
    _startedTime = widget.task.startedTime;
    _selectedCategory = widget.task.category;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _updateTask() {
    widget.task.updateTask(
      title: _titleController.text,
      category: _selectedCategory,
      description: _descriptionController.text,
      deadline: _deadline,
      startedTime: _startedTime,
    );
    widget.taskBox.put(widget.task.key, widget.task);
    Navigator.pop(context); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Task'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _updateTask,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              onChanged: (newValue) {
                setState(() {
                  _selectedCategory = newValue;
                });
              },
              items: widget.categoriesBox.values.map((category) {
                return DropdownMenuItem<String>(
                  value: category.title,
                  child: Text(category.title),
                );
              }).toList(),
              decoration: const InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Text('Deadline: ${_deadline != null ? DateFormat.yMMMd().format(_deadline!) : 'No Deadline'}'),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () async {
                final selectedDate = await showDatePicker(
                  context: context,
                  initialDate: _deadline ?? DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2030),
                );
                if (selectedDate != null) {
                  setState(() {
                    _deadline = selectedDate;
                  });
                }
              },
              child: const Text('Select Deadline'),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
