import 'package:flutter/material.dart';
import 'package:realestate/shared/widgets/stage_badge.dart';
import 'package:realestate/shared/widgets/capital_progress.dart';
import '../../shared/app_state.dart';
import 'project_details.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            "Explore Projects",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          ...AppState.projects.map((proj) {
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      proj.title,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    StageBadge(stage: proj.stage),
                    const SizedBox(height: 10),
                    Text("Expected IRR: ${proj.irr}%"),
                    const SizedBox(height: 10),
                    CapitalProgress(
                      progress: proj.capitalRaised /
                          (proj.capitalRequired == 0
                              ? 1
                              : proj.capitalRequired),
                      label: "Capital Raised",
                    ),
                    const SizedBox(height: 15),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ProjectDetails(project: proj),
                          ),
                        );
                      },
                      child: const Text("View Details"),
                    )
                  ],
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}
