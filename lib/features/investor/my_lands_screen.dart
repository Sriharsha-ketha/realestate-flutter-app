import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../shared/app_state.dart';
import '../../services/api_service.dart';
import 'milestone_management_screen.dart';

class MyLandsScreen extends StatefulWidget {
  const MyLandsScreen({super.key});

  @override
  State<MyLandsScreen> createState() => _MyLandsScreenState();
}

class _MyLandsScreenState extends State<MyLandsScreen> {
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
      appBar: AppBar(title: const Text('My Assets (Owner View)')),
      body: Consumer<AppState>(
        builder: (context, appState, child) {
          final currentUserId = appState.currentUserId;
          
          if (appState.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final myProjects = appState.ownerProjects;

          if (myProjects.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24.0),
                child: Text(
                  'No assets found. \nOnce you submit land and it is approved by Admin, your projects will appear here.',
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
                              child: Text('Investors:', style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold)),
                            ),
                            ...investors.map((investor) {
                              return ListTile(
                                leading: const CircleAvatar(child: Icon(Icons.person, size: 20)),
                                title: Text(investor['email'] ?? 'Investor'),
                                subtitle: Text('Status: ${investor['status']}'),
                                trailing: IconButton(
                                  icon: const Icon(Icons.settings, color: Colors.blue),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => MilestoneManagementScreen(
                                          projectId: project.id!,
                                          projectName: project.projectName,
                                          investorId: investor['id'],
                                          investorEmail: investor['email'],
                                        ),
                                      ),
                                    );
                                  },
                                ),
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
