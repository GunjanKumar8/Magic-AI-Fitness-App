import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'workout_model.dart';
import 'workout_list_screen.dart';

Future<void> _initHive() async {
  await Hive.initFlutter();
  Hive.registerAdapter(WorkoutAdapter());
  Hive.registerAdapter(WorkoutSetAdapter());
  // boxes are opened lazily in controller to simplify tests
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _initHive();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Workout Tracker',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blue),
      home: WorkoutListScreen(),
    );
  }
}
