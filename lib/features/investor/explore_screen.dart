import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:realestate/widgets/project_card.dart';
import '../../shared/app_state.dart';
import 'project_details.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  String selectedTheme = 'All';
  final List<String> themes = ['All', 'Eco-Luxury', 'Wellness', 'Beachfront', 'Adventure'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Explore Themes"),
      ),
      body: Consumer<AppState>(
        builder: (context, appState, child) {
          if (appState.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final filteredProjects = selectedTheme == 'All'
              ? appState.projects
              : appState.projects.where((p) => p.theme == selectedTheme).toList();

          return Column(
            children: [
              // Theme Selector (Requirement: Theme-based discovery engine)
              Container(
                height: 60,
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: themes.length,
                  itemBuilder: (context, index) {
                    final theme = themes[index];
                    final isSelected = selectedTheme == theme;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(theme),
                        selected: isSelected,
                        onSelected: (val) {
                          setState(() {
                            selectedTheme = theme;
                          });
                        },
                        selectedColor: Theme.of(context).colorScheme.primary,
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                        ),
                      ),
                    );
                  },
                ),
              ),
              Expanded(
                child: filteredProjects.isEmpty
                    ? const Center(child: Text("No projects found for this theme."))
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        itemCount: filteredProjects.length,
                        itemBuilder: (context, index) {
                          final proj = filteredProjects[index];
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
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
