/// Helper class to manage project milestones automatically derived from project stages
class MilestoneHelper {
  /// Fixed milestone sequence for all projects
  static const List<String> milestones = [
    'Land Approved',
    'Investors Joined',
    'Design Planning',
    'Construction Started',
    'Resort Completed',
    'Tourists Arriving',
  ];

  /// Map of project stage to milestone index
  static const Map<String, int> stageToMilestoneIndex = {
    'LAND_APPROVED': 0,
    'FUNDING': 1,
    'PLANNING': 2,
    'CONSTRUCTION': 3,
    'COMPLETED': 4,
    'OPERATIONAL': 5,
  };

  /// Get the current milestone index based on project stage
  /// Returns 0 (LAND_APPROVED) if stage is not recognized or empty
  static int getMilestoneIndexForStage(String stage) {
    // Always default to LAND_APPROVED (index 0) if stage is empty or null
    if (stage.isEmpty) return 0;
    return stageToMilestoneIndex[stage] ?? 0;
  }

  /// Get list of milestone statuses
  /// Returns list of booleans where true = completed, false = pending
  static List<bool> getMilestoneCompletionStatus(String stage) {
    final currentIndex = getMilestoneIndexForStage(stage);
    // currentIndex can never be negative now - always >= 0

    return List.generate(
      milestones.length,
      (index) => index <= currentIndex,
    );
  }

  /// Get human-readable display name for stage
  static String getStageDisplayName(String stage) {
    switch (stage) {
      case 'LAND_APPROVED':
        return 'Land Approved';
      case 'FUNDING':
        return 'Investors Joined';
      case 'PLANNING':
        return 'Design Planning';
      case 'CONSTRUCTION':
        return 'Construction Started';
      case 'COMPLETED':
        return 'Resort Completed';
      case 'OPERATIONAL':
        return 'Tourists Arriving';
      case 'CANCELLED':
        return 'Cancelled';
      default:
        return stage;
    }
  }
}
