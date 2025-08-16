import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'workout_controller.dart';
import 'workout_model.dart';

class WorkoutScreen extends StatefulWidget {
  final Workout workout;
  const WorkoutScreen({super.key, required this.workout});

  @override
  State<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  final controller = Get.find<WorkoutController>();

  final exercises = const [
    'Barbell row',
    'Bench press',
    'Shoulder press',
    'Deadlift',
    'Squat',
  ];

  bool _isValidWorkout() {
    if (widget.workout.sets.isEmpty) {
      Get.snackbar('Error', 'Please add at least one set');
      return false;
    }
    for (final s in widget.workout.sets) {
      if (s.weight <= 0 || s.reps <= 0) {
        Get.snackbar('Error', 'Please fill valid weight & reps for all sets');
        return false;
      }
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Workout Details'),
        actions: [
          IconButton(
            key: const Key('saveWorkout'),
            icon: const Icon(Icons.save),
            onPressed: () {
              if (!_isValidWorkout()) return;
              controller.updateWorkout(widget.workout);
              Get.back();
            },
          ),
        ],
      ),
      body: ListView.builder(
        key: const Key('setsList'),
        itemCount: widget.workout.sets.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          final set = widget.workout.sets[index];
          return Card(
            margin: const EdgeInsets.all(8),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  DropdownButton<String>(
                    key: Key('exerciseDropdown_$index'),
                    value: set.exercise,
                    onChanged: (v) => setState(() => set.exercise = v!),
                    items: exercises
                        .map((e) => DropdownMenuItem(
                              value: e,
                              child: Text(e),
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          key: Key('weightField_$index'),
                          decoration: const InputDecoration(
                            labelText: 'Weight (kg)',
                            border: OutlineInputBorder(),
                          ),
                          initialValue: set.weight > 0 ? '${set.weight}' : '',
                          keyboardType: TextInputType.number,
                          onChanged: (v) => set.weight = double.tryParse(v) ?? 0,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextFormField(
                          key: Key('repsField_$index'),
                          decoration: const InputDecoration(
                            labelText: 'Reps',
                            border: OutlineInputBorder(),
                          ),
                          initialValue: set.reps > 0 ? '${set.reps}' : '',
                          keyboardType: TextInputType.number,
                          onChanged: (v) => set.reps = int.tryParse(v) ?? 0,
                        ),
                      ),
                      IconButton(
                        key: Key('deleteSet_$index'),
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => setState(() => widget.workout.sets.removeAt(index)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        key: const Key('addSetButton'),
        child: const Icon(Icons.add),
        onPressed: () {
          setState(() {
            widget.workout.sets.add(
              WorkoutSet(exercise: exercises.first, weight: 0, reps: 0),
            );
          });
        },
      ),
    );
  }
}
