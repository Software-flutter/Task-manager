import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:task_manager/models/category.dart';
import 'package:task_manager/models/new_category.dart';
import 'package:task_manager/models/side_bar.dart';
import 'package:task_manager/models/task.dart';
import 'package:task_manager/models/task_catagories.dart';
import 'package:task_manager/pages/detail/widget/add_new_task.dart';
import 'package:task_manager/pages/detail/widget/search_result.dart';
import 'package:task_manager/pages/detail/widget/showing_task.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final TextEditingController textController = TextEditingController();
  int _selectedIndex = 0;
  late Box<String> categoriesName;
  late Box<Task> tasks;
  late Box<Category> categories;
  String name = 'USER';

  void addTask() {
    setState(() {});
  }

  void addCategory() {
    showDialog(
      context: context,
      builder: (context) {
        return CreateNewCategory(
          categories: categories,
          controller: textController,
          saveCategory: saveCategory,
        );
      },
    );
  }

  void saveCategory(String title) {
    setState(() {
      categories.add(Category(title: title));
      categoriesName.add(title);
    });
  }

  void deleteCategory(int index) {
    setState(() {
      categories.deleteAt(index);
      categoriesName.deleteAt(index);
    });
  }

  void changeUserName(String newName) {
    setState(() {
      name = newName;
    });
    final userNameBox = Hive.box<String>('userNameBox');
    userNameBox.put('userNameKey', newName);
  }

  @override
  void initState() {
    final userNameBox = Hive.box<String>('userNameBox');
    name = userNameBox.get('userNameKey', defaultValue: 'USER')!;
    AwesomeNotifications().isNotificationAllowed().then(
      (isAllowed) {
        if (!isAllowed) {
          AwesomeNotifications().requestPermissionToSendNotifications();
        }
      },
    );
    super.initState();
    tasks = Hive.box<Task>('tasks');
    categories = Hive.box<Category>('categories');
    categoriesName = Hive.box<String>('categoriesName');

    bool empty = categories.isEmpty;
    if (empty) {
      _addInitialCategory();
    }
  }

  Future<void> _addInitialCategory() async {
    await categories.add(Category(title: 'Personal', left: 0, done: 0));
    categoriesName.add("Personal");
    await categories.add(Category(title: 'School', left: 0, done: 0));
    categoriesName.add("School");
    await categories.add(Category(title: 'Workout', left: 0, done: 0));
    categoriesName.add("Workout");
    await categories.add(Category(title: 'Project', left: 0, done: 0));
    categoriesName.add("Project");
    setState(() {});
  }

  void _onItemTapped(int index) {
    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => TasksPage(
                  taskBox: tasks,
                  categoriesBox: categories,
                  categoriesName: categoriesName,
                )),
      );
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.white,
    appBar: AppBar(
      toolbarHeight: 80,
      backgroundColor: Colors.blueAccent,
      elevation: 0,
      title: Row(
        children: [
          Container(
            margin: const EdgeInsets.only(left: 15, right: 25),
            height: 45,
            width: 45,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset('assets/images/cloud.png'),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'WELCOME $name',
              overflow: TextOverflow.ellipsis, 
              maxLines: 1, 
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    ),
    drawer: SideBar(
      controller: textController,
      userName: name,
      changeName: changeUserName,
    ),
    body: _selectedIndex == 0 ? buildHomePage() : Container(),
    bottomNavigationBar: BottomNavigationBar(
      backgroundColor: Colors.blueAccent,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_month),
          label: 'Tasks',
        ),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: Colors.white,
      onTap: _onItemTapped,
    ),
  );
}

  Widget buildHomePage() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: AnimSearchBar(
              animationDurationInMilli: 800,
              width: double.maxFinite,
              textController: textController,
              onSuffixTap: () {
                textController.clear();
              },
              onSubmitted: (String value) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SearchResult(title: value),
                  ),
                );
              },
              helpText: 'Search for tasks',
              color: Colors.blueAccent,
              style: const TextStyle(color: Colors.blueAccent),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
            child: const Center(
              child: Text(
                'TASKS',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 350,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemCount: categories.length + 1,
              itemBuilder: (context, index) {
                if (index == categories.length) {
                  return GestureDetector(
                    onTap: addCategory,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        margin: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: const Color(0xFF1976D2),
                        ),
                        width: 200,
                        child: const Center(
                          child: Text(
                            '+ ADD CATEGORY',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                } else {
                  final category = categories.getAt(index);
                  return category != null
                      ? BuildCategory(
                          category: category,
                          onDelete: () => deleteCategory(index),
                          taskBox: tasks,
                          categoryBox: categories,
                        )
                      : Container();
                }
              },
            ),
          ),
          Center(
            child: Container(
              width: 75,
              height: 75,
              margin: const EdgeInsets.all(35),
              decoration: const BoxDecoration(
                color: Color(0xFF1976D2),
                shape: BoxShape.circle,
              ),
              child: GestureDetector(
                
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NewTask(
                      taskBox: tasks,
                      categoryBox: categoriesName,
                      categories: categories,
                    ),
                  ),
                ),
                child: const Icon(
                  Icons.add,
                  size: 30,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
