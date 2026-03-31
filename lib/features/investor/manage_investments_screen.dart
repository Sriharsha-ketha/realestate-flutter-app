import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../shared/app_state.dart';
import '../../services/api_service.dart';
import '../projects/milestones_page.dart';

class ManageInvestmentsScreen extends StatefulWidget {
  const ManageInvestmentsScreen({super.key});

  @override
  State<ManageInvestmentsScreen> createState() => _ManageInvestmentsScreenState();
}

class _ManageInvestmentsScreenState extends State<ManageInvestmentsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AppState>().fetchAll();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manage Investments')),
      body: Consumer<AppState>(
        builder: (context, appState, child) {
          final currentUserId = appState.currentUserId;
          
          // Filter projects owned by the current user
          final myProjects = appState.projects.where((p) => p.ownerId == currentUserId).toList();

          if (appState.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (myProjects.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24.0),
                child: Text(
                  'You do not have any active projects to manage.\nOnce your land is approved, your project will appear here.',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: myProjects.length,
            itemBuilder: (context, index) {
              final project = myProjects[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ExpansionTile(
                  title: Text(project.projectName, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('Location: ${project.location}'),
                  children: [
                    FutureBuilder<List<Map<String, dynamic>>>(
                      future: ApiService.getInvestorsByProject(project.id!),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
                          return const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Text('No investors have submitted EOIs yet.'),
                          );
                        }

                        final investors = snapshot.data!;
                        return Column(
                          children: [
                            const Divider(),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 8.0),
                              child: Text('Investors tracking this project:', style: TextStyle(fontSize: 12, color: Colors.grey)),
                            ),
                            ...investors.map((investor) {
                              return ListTile(
                                leading: const CircleAvatar(child: Icon(Icons.person, size: 20)),
                                title: Text(investor['email'] ?? 'Investor'),
                                subtitle: Text('Status: ${investor['status']}'),
                                trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => MilestonesPage(
                                        projectId: project.id!,
                                        projectName: project.projectName,
                                        investorId: investor['id'],
                                        investorEmail: investor['email'],
                                      ),
                                    ),
                                  );
                                },
                              );
                            }).toList(),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
