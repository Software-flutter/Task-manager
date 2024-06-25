import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:task_manager/models/task.dart';

class SearchResult extends StatefulWidget {
  const SearchResult({
    super.key,
    required this.title,
  });

  final String title;

  @override
  State<SearchResult> createState() => _SearchResultState();
}

class _SearchResultState extends State<SearchResult> {
  late Box<Task> _taskBox;
  late List<Task> _filteredTasks;

  @override
  void initState() {
    super.initState();
    _taskBox = Hive.box<Task>('tasks');
    _filteredTasks = _taskBox.values.where((task) => task.title == widget.title).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search Result"),
        backgroundColor: Colors.blueAccent,
      ),
      body: _filteredTasks.isEmpty
          ? Center(
              child: Text(
                'No tasks found with title ${widget.title}',
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: _filteredTasks.length,
              itemBuilder: (context, index) {
                Task task = _filteredTasks[index];
                return Card(
                  elevation: 3,
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                  ),
                );
              },
            ),
    );
  }
}
