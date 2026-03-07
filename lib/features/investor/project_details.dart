import 'package:flutter/material.dart';
import '../../../../shared/widgets/stage_badge.dart';
import '../../models/project.dart';
import '../../shared/app_state.dart';

class ProjectDetails extends StatelessWidget {
  final Project project;

  const ProjectDetails({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Project Details")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Text(
              project.title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            StageBadge(stage: project.stage),
            const SizedBox(height: 20),
            Text("Location: ${project.location}"),
            const SizedBox(height: 10),
            Text("Projected IRR: ${project.irr}%"),
            const SizedBox(height: 10),
            Text("Capital Required: ₹${project.capitalRequired} Cr"),
            const SizedBox(height: 20),
            const Text(
              "Market Snapshot",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              "Tourism growth in this region is 12% YoY with supply gap in eco-luxury segment.",
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                AppState.investorPortfolio.add(project);
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Interest expressed')));
              },
              child: const Text('Express Interest'),
            ),
          ],
        ),
      ),
    );
  }
}
