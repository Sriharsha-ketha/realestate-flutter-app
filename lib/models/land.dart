class Land {
  final int? id; // Added id for backend database integration
  final String name;
  final String location;
  final double size;
  final String zoning;
  final String stage;

  Land({
    this.id,
    required this.name,
    required this.location,
    required this.size,
    required this.zoning,
    required this.stage,
  });

  factory Land.fromJson(Map<String, dynamic> json) {
    return Land(
      id: json['id'],
      name: json['name'],
      location: json['location'],
      size: (json['size'] as num).toDouble(),
      zoning: json['zoning'],
      stage: json['stage'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'location': location,
      'size': size,
      'zoning': zoning,
      'stage': stage,
    };
  }
}
