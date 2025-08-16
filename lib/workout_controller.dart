import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import 'workout_model.dart';

class WorkoutController extends GetxController {
  var workouts = <Workout>[].obs;

  // injected for tests
  Box<Workout>? _injectedBox;
  late Box<Workout> workoutBox;

  WorkoutController({Box<Workout>? box}) {
    _injectedBox = box;
  }

  @override
  void onInit() async {
    super.onInit();
    workoutBox = _injectedBox ?? await Hive.openBox<Workout>('workouts');
    loadWorkouts();
  }

  void loadWorkouts() {
    workouts.value = workoutBox.values.toList()..sort((a, b) => b.date.compareTo(a.date)); // latest first
  }

  void addWorkout(Workout w) {
    workoutBox.put(w.id, w);
    loadWorkouts();
  }

  void updateWorkout(Workout w) {
    workoutBox.put(w.id, w);
    loadWorkouts();
  }

  void deleteWorkout(String id) {
    workoutBox.delete(id);
    loadWorkouts();
  }

  Workout newEmptyWorkout() => Workout(
        id: const Uuid().v4(),
        date: DateTime.now(),
        sets: [],
      );

  int totalSets(Workout w) => w.sets.length;
}
