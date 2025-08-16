import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter/material.dart';

import 'package:magic_ai_workout_tracker/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('add, edit, delete workout end-to-end', (tester) async {
    app.main();
    await tester.pumpAndSettle();

    // Add new workout
    await tester.tap(find.byKey(const Key('addWorkoutFab')));
    await tester.pumpAndSettle();

    // Add a set
    await tester.tap(find.byKey(const Key('addSetButton')));
    await tester.pumpAndSettle();

    // Fill fields
    await tester.enterText(find.byKey(const Key('weightField_0')), '40');
    await tester.enterText(find.byKey(const Key('repsField_0')), '10');

    // Save
    await tester.tap(find.byKey(const Key('saveWorkout')));
    await tester.pumpAndSettle();

    // On list
    expect(find.byKey(const Key('workoutTile_0')), findsOneWidget);

    // Open to edit
    await tester.tap(find.byKey(const Key('workoutTile_0')));
    await tester.pumpAndSettle();

    // Add another set
    await tester.tap(find.byKey(const Key('addSetButton')));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('weightField_1')), '45');
    await tester.enterText(find.byKey(const Key('repsField_1')), '8');

    // Save
    await tester.tap(find.byKey(const Key('saveWorkout')));
    await tester.pumpAndSettle();

    // Delete from list
    await tester.tap(find.byKey(const Key('deleteWorkout_0')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('workoutTile_0')), findsNothing);
  });
}
