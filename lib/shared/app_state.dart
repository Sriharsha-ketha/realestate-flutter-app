import '../models/land.dart';
import '../models/project.dart';

/// A very simple in-memory state holder used by the UI while we don't have a
/// backend connected.  Everything is static so the data can be mutated from any
/// screen and the changes are immediately visible elsewhere.  This mirrors the
/// requirements described in the project specification: investors see approved
/// projects, landowners submit parcels for evaluation, and administrators
/// review/approve them.
class AppState {
  /// Land that has been submitted by landowners but not yet reviewed by an admin.
  static final List<Land> pendingLands = [];

  /// Land that has been approved by an administrator.
  static final List<Land> approvedLands = [];

  /// Investment projects that are live on the platform and visible to investors.
  static final List<Project> projects = [
    Project(
      title: 'Eco Resort - Coorg',
      location: 'Coorg',
      irr: 18,
      capitalRequired: 1.0,
      capitalRaised: 0.65,
      stage: 'Feasibility',
    )
  ];

  /// The portfolio of projects that the investor (currently logged‑in user)
  /// has invested in.  This is static for now but demonstrates the intended
  /// structure.
  static final List<Project> investorPortfolio = [
    Project(
      title: 'Beach Resort - Goa',
      location: 'Goa',
      irr: 17,
      capitalRequired: 1.5,
      capitalRaised: 0.3,
      stage: 'Construction',
    )
  ];
}
