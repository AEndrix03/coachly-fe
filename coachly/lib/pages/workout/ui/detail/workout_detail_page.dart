import 'package:flutter/material.dart';

class WorkoutDetailPage extends StatelessWidget {
  final String id;

  const WorkoutDetailPage({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dettagli Workout')),
      body: Center(
        child: Text(
          'Workout ID: $id',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
}
