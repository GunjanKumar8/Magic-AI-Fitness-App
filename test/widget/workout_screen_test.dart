import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_test/hive_test.dart';

import 'package:magic_ai_workout_tracker/workout_controller.dart';
import 'package:magic_ai_workout_tracker/workout_model.dart';
import 'package:magic_ai_workout_tracker/workout_screen.dart';

void main() {
  late Box<Workout> box;
  late WorkoutController controller;

  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await setUpTestHive();
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(WorkoutAdapter());
      Hive.registerAdapter(WorkoutSetAdapter());
    }
    box = await Hive.openBox<Workout>('workouts');
    controller = WorkoutController(box: box)..onInit();
    Get.put(controller);
  });

  tearDown(() async {
    await tearDownTestHive();
    Get.reset();
  });

  Widget app(Widget child) => GetMaterialApp(home: child);

  testWidgets('add set, fill fields, save', (tester) async {
    final workout = Workout(id: 'w1', date: DateTime(2025, 8, 14), sets: []);
    await tester.pumpWidget(app(WorkoutScreen(workout: workout)));

    await tester.tap(find.byKey(const Key('addSetButton')));
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const Key('weightField_0')), '50');
    await tester.enterText(find.byKey(const Key('repsField_0')), '8');

    await tester.tap(find.byKey(const Key('saveWorkout')));
    await tester.pumpAndSettle();

    final saved = controller.workouts.firstWhere((w) => w.id == 'w1');
    expect(saved.sets.length, 1);
    expect(saved.sets.first.weight, 50);
    expect(saved.sets.first.reps, 8);
  });

  testWidgets('validation error when saving without sets', (tester) async {
    final workout = Workout(id: 'w2', date: DateTime(2025, 8, 14), sets: []);
    await tester.pumpWidget(app(WorkoutScreen(workout: workout)));

    await tester.tap(find.byKey(const Key('saveWorkout')));
    await tester.pump();

    expect(find.text('Please add at least one set'), findsOneWidget);
  });
}
