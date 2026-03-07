import 'package:flutter/material.dart';
import '../../shared/app_state.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final pending = AppState.pendingLands.length;
    final approved = AppState.approvedLands.length;
    final projects = AppState.projects.length;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Administrator Overview",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text("Pending land submissions: $pending"),
            Text("Approved land parcels: $approved"),
            Text("Active investment projects: $projects"),
          ],
        ),
      ),
    );
  }
}
