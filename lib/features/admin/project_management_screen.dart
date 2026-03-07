import 'package:flutter/material.dart';
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
  void _updateStage(int idx, String newStage) {
    AppState.projects[idx] = Project(
      title: AppState.projects[idx].title,
      location: AppState.projects[idx].location,
      irr: AppState.projects[idx].irr,
      capitalRequired: AppState.projects[idx].capitalRequired,
      capitalRaised: AppState.projects[idx].capitalRaised,
      stage: newStage,
    );
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
              ).then((_) => setState(() {}));
            },
          )
        ],
      ),
      body: SafeArea(
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: AppState.projects.length,
          itemBuilder: (context, i) {
            final proj = AppState.projects[i];
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
                      _updateStage(i, v);
                    }
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
