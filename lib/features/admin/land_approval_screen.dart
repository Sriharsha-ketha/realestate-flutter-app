import 'package:flutter/material.dart';
import '../../models/project.dart';
import '../../shared/app_state.dart';

class LandApprovalScreen extends StatefulWidget {
  const LandApprovalScreen({super.key});

  @override
  State<LandApprovalScreen> createState() => _LandApprovalScreenState();
}

class _LandApprovalScreenState extends State<LandApprovalScreen> {
  void _approve(int index) {
    final land = AppState.pendingLands.removeAt(index);
    // move to approved list
    AppState.approvedLands.add(land);
    // optionally create a blank project when a land is approved
    AppState.projects.add(
      Project(
        title: '${land.name} Project',
        location: land.location,
        irr: 0,
        capitalRequired: 0,
        capitalRaised: 0,
        stage: 'Feasibility',
      ),
    );
    setState(() {});
  }

  void _reject(int index) {
    AppState.pendingLands.removeAt(index);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: AppState.pendingLands.length,
        itemBuilder: (context, i) {
          final land = AppState.pendingLands[i];
          return Card(
            child: ListTile(
              title: Text(land.name),
              subtitle:
                  Text("Location: ${land.location} | Size: ${land.size} acres"),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.check, color: Colors.green),
                    onPressed: () => _approve(i),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.red),
                    onPressed: () => _reject(i),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
