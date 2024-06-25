import 'package:hive/hive.dart';

part 'task.g.dart';

@HiveType(typeId: 5)
class Task extends HiveObject {
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

  Task({
    required this.title,
    this.category,
    this.description,
    this.isDone=false ,
    this.deadline,
    this.startedTime,
  });

  
  void updateTask({
    String? title,
    String? category,
    String? description,
    bool? isDone,
    DateTime? deadline,
    DateTime? startedTime,
  }) {
    this.title = title ?? this.title;
    this.category = category ?? this.category;
    this.description = description ?? this.description;
    this.isDone = isDone ?? this.isDone;
    this.deadline = deadline ?? this.deadline;
    this.startedTime = startedTime ?? this.startedTime;
  }
}
