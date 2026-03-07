class Project {
  final int? id;
  final String title;
  final String location;
  final String theme; // New
  final String description; // New
  final double irr;
  final double capitalRequired;
  final double capitalRaised;
  final String stage;
  final String? imageUrl;
  final double projectedGrowth; // New
  final int demandIndex; // New
  final String riskProfile; // New

  Project({
    this.id,
    required this.title,
    required this.location,
    required this.theme,
    required this.description,
    required this.irr,
    required this.capitalRequired,
    required this.capitalRaised,
    required this.stage,
    this.imageUrl,
    required this.projectedGrowth,
    required this.demandIndex,
    required this.riskProfile,
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json['id'],
      title: json['title'] ?? '',
      location: json['location'] ?? '',
      theme: json['theme'] ?? 'General',
      description: json['description'] ?? '',
      irr: (json['irr'] as num?)?.toDouble() ?? 0.0,
      capitalRequired: (json['capitalRequired'] as num?)?.toDouble() ?? 0.0,
      capitalRaised: (json['capitalRaised'] as num?)?.toDouble() ?? 0.0,
      stage: json['stage'] ?? 'Feasibility',
      imageUrl: json['imageUrl'],
      projectedGrowth: (json['projectedGrowth'] as num?)?.toDouble() ?? 0.0,
      demandIndex: json['demandIndex'] ?? 5,
      riskProfile: json['riskProfile'] ?? 'Medium',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'title': title,
      'location': location,
      'theme': theme,
      'description': description,
      'irr': irr,
      'capitalRequired': capitalRequired,
      'capitalRaised': capitalRaised,
      'stage': stage,
      'imageUrl': imageUrl,
      'projectedGrowth': projectedGrowth,
      'demandIndex': demandIndex,
      'riskProfile': riskProfile,
    };
  }
}
