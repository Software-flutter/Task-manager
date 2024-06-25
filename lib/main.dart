import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:task_manager/models/category.dart';
import 'package:task_manager/models/task.dart';
import 'package:task_manager/pages/splash_screen.dart';

void main() async {
  AwesomeNotifications().initialize('resource://drawable/ic_stat_img',[
    NotificationChannel(
        channelKey: 'basic_channel',
        channelName: 'Basic notifications',
        channelDescription: 'Notification channel for basic tests',
        defaultColor:  Colors.blueAccent,
        ledColor: Colors.blueAccent,
        importance: NotificationImportance.Max, 
        playSound: true,
        enableVibration: true,
        enableLights: true,),
  ],
  debug: true);
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(CategoryAdapter());
  Hive.registerAdapter(TaskAdapter());
  await Hive.openBox<Task>('tasks');
  await Hive.openBox<Category>('categories');
  await Hive.openBox<String>('categoriesName');
  await Hive.openBox<String>('userNameBox');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TASK MANAGER',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}
