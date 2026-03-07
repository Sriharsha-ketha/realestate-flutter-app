import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
        padding: const EdgeInsets.all(24),
        child: ListView(
          children: [
            Text(
              project.title,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 12),
            StageBadge(stage: project.stage),
            const SizedBox(height: 32),
            _infoRow(context, Icons.location_on_outlined, "Location", project.location),
            _infoRow(context, Icons.trending_up, "Projected IRR", "${project.irr}%"),
            _infoRow(context, Icons.account_balance, "Capital Required", "₹${project.capitalRequired} Cr"),
            const SizedBox(height: 32),
            Text(
              "Market Snapshot",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            const Text(
              "Tourism growth in this region is 12% YoY with a significant supply gap in the eco-luxury segment. This project aims to capture high-yield seasonal demand.",
              style: TextStyle(height: 1.5),
            ),
            const SizedBox(height: 48),
            ElevatedButton(
              onPressed: () {
                context.read<AppState>().addToPortfolio(project);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Interested in ${project.title}!'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              child: const Text('Express Interest'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(BuildContext context, IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 12),
          Text("$label: ", style: const TextStyle(fontWeight: FontWeight.w500)),
          Text(value),
        ],
      ),
    );
  }
}
