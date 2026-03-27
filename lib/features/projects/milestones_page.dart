import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../helpers/milestone_helper.dart';
import '../../models/project.dart';
import '../../shared/app_state.dart';

class MilestonesPage extends StatefulWidget {
  final int projectId;
  final String? projectName;
  final String? initialStage;

  const MilestonesPage({
    Key? key,
    required this.projectId,
    this.projectName,
    this.initialStage,
  }) : super(key: key);


  @override
  State<MilestonesPage> createState() => _MilestonesPageState();
}

class _MilestonesPageState extends State<MilestonesPage> {
  late String _currentStage;

  @override
  void initState() {
    super.initState();
    // Use provided initial stage, fallback to LAND_APPROVED
    _currentStage = widget.initialStage ?? 'LAND_APPROVED';
    _loadProjectStage();
  }

  Future<void> _loadProjectStage() async {
    final appState = context.read<AppState>();
    try {
      final project = appState.projects.firstWhere(
        (p) => p.id == widget.projectId,
        orElse: () => Project(projectName: '', location: ''),
      );
      if (project.id != null && project.stage.isNotEmpty) {
        setState(() {
          // Use project stage if valid, otherwise keep default
          _currentStage = project.stage;
        });
      }
    } catch (e) {
      // Project not found in app state, keep the initial stage
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  /// Build a milestone timeline item
  Widget _buildMilestoneItem(int index, String milestone, bool isCompleted) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Milestone status indicator
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isCompleted
                  ? Colors.green.shade500
                  : Colors.grey.shade300,
            ),
            child: Center(
              child: isCompleted
                  ? const Icon(Icons.check, color: Colors.white)
                  : Text(
                      '${index + 1}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade600,
                      ),
                    ),
            ),
          ),
          const SizedBox(width: 16),
          // Milestone text and connector
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  milestone,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isCompleted ? Colors.green.shade700 : Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  isCompleted ? 'Completed' : 'Upcoming',
                  style: TextStyle(
                    fontSize: 12,
                    color: isCompleted ? Colors.green : Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          // Vertical connector line (except for last item)
          if (index < MilestoneHelper.milestones.length - 1)
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: SizedBox(
                width: 2,
                height: 40,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: isCompleted ? Colors.green.shade300 : Colors.grey.shade300,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final milestoneStatuses = MilestoneHelper.getMilestoneCompletionStatus(_currentStage);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.projectName ?? 'Milestones'),
        elevation: 0,
      ),
      body: Consumer<AppState>(
        builder: (context, appState, child) {
          // Get current project to reflect any stage changes
          Project? currentProject;
          try {
            currentProject = appState.projects.firstWhere(
              (p) => p.id == widget.projectId,
            );
            _currentStage = currentProject.stage;
          } catch (e) {
            // Project not found, use current stage
          }

          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Current stage indicator
                  if (_currentStage != 'CANCELLED')
                    Padding(
                      padding: const EdgeInsets.only(bottom: 24.0),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          border: Border.all(color: Colors.blue.shade300),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.info, color: Colors.blue.shade700),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Current Stage',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.blue.shade600,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    MilestoneHelper.getStageDisplayName(_currentStage),
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue.shade900,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  
                  // Milestone progress heading
                  const Padding(
                    padding: EdgeInsets.only(bottom: 16.0),
                    child: Text(
                      'Project Progress',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  // Milestone timeline
                  if (_currentStage == 'CANCELLED')
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        border: Border.all(color: Colors.red.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          Icon(Icons.cancel, color: Colors.red.shade700, size: 32),
                          const SizedBox(height: 8),
                          Text(
                            'Project Cancelled',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.red.shade900,
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: MilestoneHelper.milestones.length,
                      itemBuilder: (context, index) {
                        return _buildMilestoneItem(
                          index,
                          MilestoneHelper.milestones[index],
                          milestoneStatuses[index],
                        );
                      },
                    ),

                  // Progress percentage
                  if (_currentStage != 'CANCELLED')
                    Padding(
                      padding: const EdgeInsets.only(top: 24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Overall Progress',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                              Text(
                                '${((milestoneStatuses.where((s) => s).length / milestoneStatuses.length) * 100).toStringAsFixed(0)}%',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: LinearProgressIndicator(
                              value: milestoneStatuses.where((s) => s).length /
                                  milestoneStatuses.length,
                              minHeight: 8,
                              backgroundColor: Colors.grey.shade300,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.green.shade500,
                              ),
                            ),
                          ),
                        ],
                      ),
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