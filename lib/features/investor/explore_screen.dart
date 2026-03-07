import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:realestate/widgets/project_card.dart';
import '../../shared/app_state.dart';
import 'project_details.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Explore Opportunities"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<AppState>().fetchAll(),
          ),
        ],
      ),
      body: Consumer<AppState>(
        builder: (context, appState, child) {
          if (appState.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (appState.projects.isEmpty) {
            return const Center(child: Text("No projects available."));
          }
          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 16),
            itemCount: appState.projects.length,
            itemBuilder: (context, index) {
              final proj = appState.projects[index];
              return ProjectCard(
                project: proj,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ProjectDetails(project: proj),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
