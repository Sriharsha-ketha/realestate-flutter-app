import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:realestate/widgets/project_explore_card.dart';
import '../../models/project.dart';
import '../../shared/app_state.dart';
import 'project_details.dart';
import '../projects/milestones_page.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  bool isDestinationsSelected = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadAllData();
    });
  }

  Future<void> _loadAllData() async {
    final appState = context.read<AppState>();
    await appState.fetchAll();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Explore'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadAllData,
          ),
        ],
      ),
      body: Column(
        children: [
          // Clear Segmented Toggle for Section Separation
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => isDestinationsSelected = false),
                      child: Container(
                        decoration: BoxDecoration(
                          color: !isDestinationsSelected ? theme.colorScheme.primary : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'Projects',
                          style: TextStyle(
                            color: !isDestinationsSelected ? Colors.white : Colors.black87,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => isDestinationsSelected = true),
                      child: Container(
                        decoration: BoxDecoration(
                          color: isDestinationsSelected ? theme.colorScheme.primary : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'Destinations',
                          style: TextStyle(
                            color: isDestinationsSelected ? Colors.white : Colors.black87,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          Expanded(
            child: Consumer<AppState>(
              builder: (context, appState, child) {
                if (appState.isLoading && (isDestinationsSelected ? appState.projects.isEmpty : appState.investorPortfolio.isEmpty)) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (isDestinationsSelected) {
                  return _buildDestinationsList(appState.projects, appState);
                } else {
                  return _buildProjectsList(appState.investorPortfolio, appState);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDestinationsList(List<Project> projects, AppState appState) {
    if (projects.isEmpty) {
      return _buildEmptyState("No destinations available at the moment.");
    }
    return RefreshIndicator(
      onRefresh: _loadAllData,
      child: ListView.builder(
        padding: const EdgeInsets.only(bottom: 24),
        itemCount: projects.length,
        itemBuilder: (context, index) {
          final proj = projects[index];
          return ProjectExploreCard(
            project: proj,
            onTap: () {
              // Destinations -> Analytics
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ProjectDetails(project: proj),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildProjectsList(List<Project> projects, AppState appState) {
    if (projects.isEmpty) {
      return _buildEmptyState("No active projects. Submit an EOI in Destinations to start tracking.");
    }
    return RefreshIndicator(
      onRefresh: _loadAllData,
      child: ListView.builder(
        padding: const EdgeInsets.only(bottom: 24),
        itemCount: projects.length,
        itemBuilder: (context, index) {
          final proj = projects[index];
          return ProjectExploreCard(
            project: proj,
            onTap: () {
              // Projects -> Milestones
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => MilestonesPage(
                    projectId: proj.id!,
                    projectName: proj.projectName,
                    investorId: appState.currentUserId!,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inventory_2_outlined, size: 64, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
