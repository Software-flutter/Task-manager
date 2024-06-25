import 'package:hive/hive.dart';

part 'task.g.dart';

@HiveType(typeId: 2)
class Task {
  Task({
    required this.title,
    this.category,
    this.description,
    this.isDone,
    this.deadline,
    this.startedTime,
    
  });

  @HiveField(0)
  String title;
  @HiveField(1)
  String? category;
  @HiveField(2)
  String? description;

  @HiveField(3)
  bool? isDone;
  @HiveField(4)
  DateTime? deadline;
  @HiveField(5)
  DateTime? startedTime;

}