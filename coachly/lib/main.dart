import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'routes/router.dart';
import 'themes/theme.dart';

void main() {
  runApp(const ProviderScope(child: CoachlyApplication()));
}

class CoachlyApplication extends StatelessWidget {
  const CoachlyApplication({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Coachly',
      theme: AppTheme.dark,
      routerConfig: appRouter,
    );
  }
}
