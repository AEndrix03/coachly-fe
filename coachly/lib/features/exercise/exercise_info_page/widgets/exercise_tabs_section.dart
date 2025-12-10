import 'package:flutter/material.dart';

import 'tabs/exercise_muscles_tab.dart';
import 'tabs/exercise_technique_tab.dart';
import 'tabs/exercise_variants_tab.dart';

class ExerciseTabsSection extends StatefulWidget {
  const ExerciseTabsSection({super.key});

  @override
  State<ExerciseTabsSection> createState() => _ExerciseTabsSectionState();
}

class _ExerciseTabsSectionState extends State<ExerciseTabsSection>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildTabBar(),
        const SizedBox(height: 20),
        SizedBox(
          height: 400,
          child: TabBarView(
            controller: _tabController,
            children: const [
              ExerciseTechniqueTab(),
              ExerciseMusclesTab(),
              ExerciseVariantsTab(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTabBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A2E),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
        ),
        child: TabBar(
          controller: _tabController,
          indicator: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF2196F3), Color(0xFF1976D2)],
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF2196F3).withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          indicatorSize: TabBarIndicatorSize.tab,
          dividerColor: Colors.transparent,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white.withOpacity(0.5),
          labelStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          tabs: const [
            Tab(text: 'Tecnica'),
            Tab(text: 'Muscoli'),
            Tab(text: 'Varianti'),
          ],
        ),
      ),
    );
  }
}
