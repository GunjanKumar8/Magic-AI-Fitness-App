import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_test/hive_test.dart';

import 'package:magic_ai_workout_tracker/workout_controller.dart';
import 'package:magic_ai_workout_tracker/workout_list_screen.dart';
import 'package:magic_ai_workout_tracker/workout_model.dart';

void main() {
  late Box<Workout> box;
  late WorkoutController controller;

  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await setUpTestHive();
    Hive.registerAdapter(WorkoutAdapter());
    Hive.registerAdapter(WorkoutSetAdapter());
    box = await Hive.openBox<Workout>('workouts');
    controller = WorkoutController(box: box)..onInit();

    controller.addWorkout(Workout(
      id: 'seed',
      date: DateTime(2025, 8, 14),
      sets: [WorkoutSet(exercise: 'Bench press', weight: 40, reps: 10)],
    ));
  });

  tearDown(() async {
    await tearDownTestHive();
    Get.reset();
  });

  Widget app() => GetMaterialApp(home: WorkoutListScreen(controller: controller));

  testWidgets('lists and deletes a workout', (tester) async {
    await tester.pumpWidget(app());
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('workoutList')), findsOneWidget);
    expect(find.byKey(const Key('workoutTile_0')), findsOneWidget);

    await tester.tap(find.byKey(const Key('deleteWorkout_0')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('workoutTile_0')), findsNothing);
  });
}
