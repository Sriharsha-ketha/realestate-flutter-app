class Project {
  final int? id;
  final int? landId;
  final int? ownerId; // New field for ownership
  final String projectName;
  final String location;
  final double landSize;
  final double investmentRequired;
  final double expectedROI;
  final double expectedIRR;
  final String stage;
  final String? stateCategory;
  final String? destination;

  // Investment metrics
  final double? rentalYield;
  final double? projectedAnnualIncome;
  final double? capitalAppreciation;
  final double breakEvenYears;

  // Demand metrics
  final double occupancyRate;
  final double? averageOccupancy;
  final double? peakOccupancy;
  final String? seasonalDemand;
  final double averageDailyRate;
  final double? adr;

  // Financial metrics
  final double monthlyCashFlow;
  final double netOperatingIncome;
  final double? noi;

  // Compatibility fields
  final double? estimatedMonthlyIncome;
  final double capitalAppreciation5Year;
  final double peakSeasonOccupancy;

  Project({
    this.id,
    this.landId,
    this.ownerId,
    required this.projectName,
    required this.location,
    this.landSize = 0.0,
    this.investmentRequired = 0.0,
    this.expectedROI = 0.0,
    this.expectedIRR = 0.0,
    this.stage = 'LAND_APPROVED',
    this.stateCategory,
    this.destination,
    this.rentalYield,
    this.projectedAnnualIncome,
    this.capitalAppreciation,
    this.breakEvenYears = 0.0,
    this.occupancyRate = 0.0,
    this.averageOccupancy,
    this.peakOccupancy,
    this.seasonalDemand,
    this.averageDailyRate = 0.0,
    this.adr,
    this.monthlyCashFlow = 0.0,
    this.netOperatingIncome = 0.0,
    this.noi,
    this.estimatedMonthlyIncome,
    this.capitalAppreciation5Year = 0.0,
    this.peakSeasonOccupancy = 0.0,
  });

  String get title => projectName;

  factory Project.fromJson(Map<String, dynamic> json) {
    final projectName = (json['projectName'] ?? json['title'] ?? '') as String;
    final location = (json['location'] ?? '') as String;

    double parseDouble(dynamic v) {
      if (v == null) return 0.0;
      if (v is num) return v.toDouble();
      return double.tryParse(v.toString()) ?? 0.0;
    }

    double? parseDoubleOpt(dynamic v) {
      if (v == null) return null;
      if (v is num) return v.toDouble();
      return double.tryParse(v.toString());
    }

    return Project(
      id: json['id'] as int?,
      landId: json['landId'] ?? json['land_id'],
      ownerId: json['ownerId'] ?? json['owner_id'],
      projectName: projectName,
      location: location,
      landSize: parseDouble(json['landSize'] ?? json['land_size']),
      investmentRequired: parseDouble(json['investmentRequired'] ?? json['capital_required']),
      expectedROI: parseDouble(json['expectedROI'] ?? json['expected_roi']),
      expectedIRR: parseDouble(json['expectedIRR'] ?? json['expected_irr']),
      stage: (json['stage'] ?? 'LAND_APPROVED') as String,
      stateCategory: json['stateCategory'] ?? json['state_category'],
      destination: json['destination'],
      rentalYield: parseDoubleOpt(json['rentalYield']),
      projectedAnnualIncome: parseDoubleOpt(json['projectedAnnualIncome']),
      capitalAppreciation: parseDoubleOpt(json['capitalAppreciation']),
      breakEvenYears: parseDouble(json['breakEvenYears'] ?? json['break_even_years']),
      occupancyRate: parseDouble(json['occupancyRate'] ?? json['occupancy_rate']),
      averageOccupancy: parseDoubleOpt(json['averageOccupancy']),
      peakOccupancy: parseDoubleOpt(json['peakOccupancy']),
      seasonalDemand: json['seasonalDemand'],
      averageDailyRate: parseDouble(json['averageDailyRate'] ?? json['average_daily_rate']),
      adr: parseDoubleOpt(json['adr']),
      monthlyCashFlow: parseDouble(json['monthlyCashFlow'] ?? json['monthly_cash_flow']),
      netOperatingIncome: parseDouble(json['netOperatingIncome'] ?? json['net_operating_income']),
      noi: parseDoubleOpt(json['noi']),
      estimatedMonthlyIncome: parseDoubleOpt(json['estimatedMonthlyIncome']),
      capitalAppreciation5Year: parseDouble(json['capitalAppreciation5Year'] ?? 0.0),
      peakSeasonOccupancy: parseDouble(json['peakSeasonOccupancy'] ?? 0.0),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (landId != null) 'landId': landId,
      if (ownerId != null) 'ownerId': ownerId,
      'projectName': projectName,
      'location': location,
      'landSize': landSize,
      'investmentRequired': investmentRequired,
      'expectedROI': expectedROI,
      'expectedIRR': expectedIRR,
      'stage': stage,
      if (stateCategory != null) 'stateCategory': stateCategory,
      if (destination != null) 'destination': destination,
      'rentalYield': rentalYield,
      'projectedAnnualIncome': projectedAnnualIncome,
      'capitalAppreciation': capitalAppreciation,
      'breakEvenYears': breakEvenYears,
      'occupancyRate': occupancyRate,
      'averageOccupancy': averageOccupancy,
      'peakOccupancy': peakOccupancy,
      'seasonalDemand': seasonalDemand,
      'averageDailyRate': averageDailyRate,
      'adr': adr,
      'monthlyCashFlow': monthlyCashFlow,
      'netOperatingIncome': netOperatingIncome,
      'noi': noi,
      'estimatedMonthlyIncome': estimatedMonthlyIncome,
      'capitalAppreciation5Year': capitalAppreciation5Year,
      'peakSeasonOccupancy': peakSeasonOccupancy,
    };
  }

  // Compatibility helpers
  String get theme => 'General';
  String get description => '';
  double get projectedGrowth => expectedROI;
  int get demandIndex => 5;
  String get riskProfile => 'Medium';
  double get irr => expectedIRR;
  double get capitalRequired => investmentRequired;
  double get capitalRaised => 0.0;
}
