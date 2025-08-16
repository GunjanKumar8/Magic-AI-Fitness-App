import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:hive_test/hive_test.dart';
import 'package:get/get.dart';

import 'package:magic_ai_workout_tracker/workout_controller.dart';
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
  });

  tearDown(() async {
    await tearDownTestHive();
    Get.reset();
  });

  test('add, update, delete and sorting', () async {
    final w1 = Workout(id: '1', date: DateTime(2025, 8, 10), sets: [
      WorkoutSet(exercise: 'Bench press', weight: 40, reps: 10),
    ]);
    final w2 = Workout(id: '2', date: DateTime(2025, 8, 12), sets: [
      WorkoutSet(exercise: 'Deadlift', weight: 70, reps: 8),
    ]);

    controller.addWorkout(w1);
    controller.addWorkout(w2);

    expect(controller.workouts.length, 2);
    expect(controller.workouts.first.id, '2'); // latest first

    w1.sets.add(WorkoutSet(exercise: 'Bench press', weight: 45, reps: 8));
    controller.updateWorkout(w1);
    expect(controller.workouts.last.sets.length, 2);

    controller.deleteWorkout('2');
    expect(controller.workouts.length, 1);
    expect(controller.workouts.first.id, '1');
  });

  test('totalSets helper', () {
    final w = Workout(id: 'x', date: DateTime.now(), sets: [
      WorkoutSet(exercise: 'Squat', weight: 60, reps: 10),
      WorkoutSet(exercise: 'Squat', weight: 70, reps: 8),
    ]);
    expect(controller.totalSets(w), 2);
  });
}
