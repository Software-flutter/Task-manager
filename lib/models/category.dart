import 'package:hive/hive.dart';

part 'category.g.dart';

@HiveType(typeId: 1)
class Category {
  Category({
    required this.title,
    this.left=0,
    this.done=0,
    
  });

  @HiveField(0)
  String title;

  @HiveField(1)
  int? left;

  @HiveField(2)
  int? done;
}