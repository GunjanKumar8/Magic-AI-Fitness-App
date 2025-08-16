import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'workout_controller.dart';
import 'workout_screen.dart';

class WorkoutListScreen extends StatelessWidget {
  final WorkoutController controller;

  WorkoutListScreen({super.key, WorkoutController? controller}) : controller = controller ?? Get.put(WorkoutController());

  String formatDate(DateTime d) => DateFormat('dd MMM yyyy, hh:mm a').format(d);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Workouts')),
      body: Obx(() {
        if (controller.workouts.isEmpty) {
          return const Center(child: Text('No workouts yet. Tap + to add one.'));
        }
        return ListView.builder(
          key: const Key('workoutList'),
          itemCount: controller.workouts.length,
          itemBuilder: (context, index) {
            final w = controller.workouts[index];
            return ListTile(
              key: Key('workoutTile_$index'),
              title: Text('Workout - ${formatDate(w.date)}'),
              subtitle: Text('${w.sets.length} sets'),
              onTap: () => Get.to(() => WorkoutScreen(workout: w)),
              trailing: IconButton(
                key: Key('deleteWorkout_$index'),
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => controller.deleteWorkout(w.id),
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        key: const Key('addWorkoutFab'),
        child: const Icon(Icons.add),
        onPressed: () {
          Get.to(() => WorkoutScreen(workout: controller.newEmptyWorkout()));
        },
      ),
    );
  }
}
