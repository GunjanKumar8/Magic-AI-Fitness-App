import 'package:hive/hive.dart';

part 'workout_model.g.dart';

@HiveType(typeId: 0)
class Workout extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  DateTime date;

  @HiveField(2)
  List<WorkoutSet> sets;

  Workout({
    required this.id,
    required this.date,
    required this.sets,
  });
}

@HiveType(typeId: 1)
class WorkoutSet {
  @HiveField(0)
  String exercise;

  @HiveField(1)
  double weight;

  @HiveField(2)
  int reps;

  WorkoutSet({
    required this.exercise,
    required this.weight,
    required this.reps,
  });
}
