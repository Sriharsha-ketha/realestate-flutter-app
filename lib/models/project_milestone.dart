class ProjectMilestone {
  final int? id;
  final int projectId;
  final int investorId;
  final String milestone;
  final String? description;
  final String? date; // yyyy-MM-dd
  final String status; // PENDING, COMPLETED

  ProjectMilestone({
    this.id,
    required this.projectId,
    required this.investorId,
    required this.milestone,
    this.description,
    this.date,
    this.status = 'PENDING',
  });

  factory ProjectMilestone.fromJson(Map<String, dynamic> json) {
    return ProjectMilestone(
      id: json['id'],
      projectId: json['projectId'],
      investorId: json['investorId'],
      milestone: json['milestone'] ?? '',
      description: json['description'],
      date: json['date'],
      status: json['status'] ?? 'PENDING',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'projectId': projectId,
      'investorId': investorId,
      'milestone': milestone,
      'description': description,
      'date': date,
      'status': status,
    };
  }
}
