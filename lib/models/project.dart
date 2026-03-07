class Project {
  final int? id; // Added id for backend database integration
  final String title;
  final String location;
  final double irr;
  final double capitalRequired;
  final double capitalRaised;
  final String stage;
  final String? imageUrl;

  Project({
    this.id,
    required this.title,
    required this.location,
    required this.irr,
    required this.capitalRequired,
    required this.capitalRaised,
    required this.stage,
    this.imageUrl,
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json['id'],
      title: json['title'],
      location: json['location'],
      irr: (json['irr'] as num).toDouble(),
      capitalRequired: (json['capitalRequired'] as num).toDouble(),
      capitalRaised: (json['capitalRaised'] as num).toDouble(),
      stage: json['stage'],
      imageUrl: json['imageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'title': title,
      'location': location,
      'irr': irr,
      'capitalRequired': capitalRequired,
      'capitalRaised': capitalRaised,
      'stage': stage,
      'imageUrl': imageUrl,
    };
  }
}
