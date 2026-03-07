import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/project.dart';
import '../../shared/app_state.dart';
import 'create_project_screen.dart';

class ProjectManagementScreen extends StatefulWidget {
  const ProjectManagementScreen({super.key});

  @override
  State<ProjectManagementScreen> createState() =>
      _ProjectManagementScreenState();
}

class _ProjectManagementScreenState extends State<ProjectManagementScreen> {
  void _updateStage(BuildContext context, int idx, String newStage) {
    final appState = context.read<AppState>();
    final currentProj = appState.projects[idx];
    
    final updatedProj = Project(
      id: currentProj.id,
      title: currentProj.title,
      location: currentProj.location,
      theme: currentProj.theme,
      description: currentProj.description,
      irr: currentProj.irr,
      capitalRequired: currentProj.capitalRequired,
      capitalRaised: currentProj.capitalRaised,
      stage: newStage,
      imageUrl: currentProj.imageUrl,
      projectedGrowth: currentProj.projectedGrowth,
      demandIndex: currentProj.demandIndex,
      riskProfile: currentProj.riskProfile,
    );
    
    appState.addProject(updatedProj);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Projects'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CreateProjectScreen()),
              );
            },
          )
        ],
      ),
      body: Consumer<AppState>(
        builder: (context, appState, child) {
          if (appState.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return SafeArea(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: appState.projects.length,
              itemBuilder: (context, i) {
                final proj = appState.projects[i];
                return Card(
                  child: ListTile(
                    title: Text(proj.title),
                    subtitle: Text("Stage: ${proj.stage}"),
                    trailing: DropdownButton<String>(
                      value: proj.stage,
                      items: const [
                        DropdownMenuItem(
                            value: 'Feasibility', child: Text('Feasibility')),
                        DropdownMenuItem(
                            value: 'Approvals', child: Text('Approvals')),
                        DropdownMenuItem(
                            value: 'Construction', child: Text('Construction')),
                        DropdownMenuItem(
                            value: 'Operational', child: Text('Operational')),
                      ],
                      onChanged: (v) {
                        if (v != null) {
                          _updateStage(context, i, v);
                        }
                      },
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
