import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:realestate/widgets/project_card.dart';
import '../../models/project.dart';
import '../../shared/app_state.dart';
import '../../services/api_service.dart';
import 'project_details.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  String selectedMain = 'All';
  String selectedSub = 'All';

  Map<String, List<String>> _tourismMap = {};
  bool _loadingTourismMap = false;
  
  List<Project> _allProjects = [];
  List<Project> _displayed = [];

  @override
  void initState() {
    super.initState();
    // Load all projects once when the screen appears
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadTourismFilters();
      _loadAllProjects();
    });
  }

  Future<void> _loadTourismFilters() async {
    setState(() => _loadingTourismMap = true);
    try {
      _tourismMap = await ApiService.getTourismFilters();
      setState(() {});
    } catch (e) {
      debugPrint('Error loading tourism filters: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading tourism filters: $e')),
        );
      }
    } finally {
      setState(() => _loadingTourismMap = false);
    }
  }

  Future<void> _loadAllProjects() async {
    final appState = context.read<AppState>();
    await appState.fetchAll();
    setState(() {
      _allProjects = List.from(appState.projects);
      _applyTourismFilter();
    });
  }

  void _applyTourismFilter() {
    if (selectedMain == 'All') {
      _displayed = List.from(_allProjects);
      return;
    }

    final state = selectedMain;
    final sub = selectedSub == 'All' ? null : selectedSub;

    _displayed = _allProjects.where((p) {
      final pState = (p.stateCategory ?? '').toString();
      final pDest = (p.destination ?? '').toString();
      if (pState.toLowerCase() != state.toLowerCase()) return false;
      if (sub == null) return true;
      return pDest.toLowerCase() == sub.toLowerCase();
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Explore Themes"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
                onPressed: () => _loadAllProjects(),
          ),
        ],
      ),
      body: Consumer<AppState>(
        builder: (context, appState, child) {
          return Column(
            children: [
              // Main filters (states/regions)
              Container(
                height: 60,
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: const Text('All'),
                        selected: selectedMain == 'All',
                        onSelected: (v) {
                          if (v) {
                            setState(() {
                              selectedMain = 'All';
                              selectedSub = 'All';
                              _applyTourismFilter();
                            });
                          }
                        },
                        selectedColor: Theme.of(context).colorScheme.primary,
                        labelStyle: TextStyle(color: selectedMain == 'All' ? Colors.white : Colors.black),
                      ),
                    ),
                    ...?_tourismMap.keys.map((state) {
                      final isSelected = selectedMain == state;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(state),
                          selected: isSelected,
                          onSelected: (v) {
                            if (v) {
                              setState(() {
                                selectedMain = state;
                                selectedSub = 'All';
                                _applyTourismFilter();
                              });
                            }
                          },
                          selectedColor: Theme.of(context).colorScheme.primary,
                          labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black),
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),
              // Sub-filters (destinations) — show only when a state is selected
              if (selectedMain != 'All')
                Container(
                  height: 60,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: const Text('All'),
                          selected: selectedSub == 'All',
                          onSelected: (v) {
                            if (v) {
                              setState(() {
                                selectedSub = 'All';
                                _applyTourismFilter();
                              });
                            }
                          },
                          selectedColor: Theme.of(context).colorScheme.primary,
                          labelStyle: TextStyle(color: selectedSub == 'All' ? Colors.white : Colors.black),
                        ),
                      ),
                      ...?_tourismMap[selectedMain]?.map((dest) {
                        final isSelected = selectedSub == dest;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            label: Text(dest),
                            selected: isSelected,
                            onSelected: (v) {
                              if (v) {
                                setState(() {
                                  selectedSub = dest;
                                  _applyTourismFilter();
                                });
                              }
                            },
                            selectedColor: Theme.of(context).colorScheme.primary,
                            labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black),
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                ),
              Expanded(
                child: appState.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _displayed.isEmpty
                        ? const Center(child: Text("No projects found for this theme."))
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            itemCount: _displayed.length,
                            itemBuilder: (context, index) {
                              final proj = _displayed[index];
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
