import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/project.dart';
import '../../shared/app_state.dart';

class LandApprovalScreen extends StatefulWidget {
  const LandApprovalScreen({super.key});

  @override
  State<LandApprovalScreen> createState() => _LandApprovalScreenState();
}

class _LandApprovalScreenState extends State<LandApprovalScreen> {
  void _approve(BuildContext context, int index) {
    final appState = context.read<AppState>();
    final land = appState.pendingLands[index];
    
    // In a real app, this would be a single atomic backend call
    // For now, we update local state which would trigger backend calls
    appState.addProject(
      Project(
        title: '${land.name} Project',
        location: land.location,
        irr: 0,
        capitalRequired: 0,
        capitalRaised: 0,
        stage: 'Feasibility',
        imageUrl: null,
      ),
    );
    
    // Note: Ideally we'd have an approveLand method in AppState
    // and remove from pending.
    setState(() {});
  }

  void _reject(int index) {
    // AppState.pendingLands.removeAt(index);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, child) {
        if (appState.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        return SafeArea(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: appState.pendingLands.length,
            itemBuilder: (context, i) {
              final land = appState.pendingLands[i];
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
                        onPressed: () => _approve(context, i),
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
      },
    );
  }
}
