import 'package:flutter/material.dart';
import '../models/land.dart';
import '../models/project.dart';
import '../services/api_service.dart';

class AppState extends ChangeNotifier {
  List<Land> _pendingLands = [];
  List<Land> _approvedLands = [];
  List<Project> _projects = [];
  List<Project> _investorPortfolio = [];

  List<Land> get pendingLands => _pendingLands;
  List<Land> get approvedLands => _approvedLands;
  List<Project> get projects => _projects;
  List<Project> get investorPortfolio => _investorPortfolio;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> fetchAll() async {
    _isLoading = true;
    notifyListeners();
    try {
      _projects = await ApiService.getProjects();
      _pendingLands = await ApiService.getLands();
      // For now, filter local approved/portfolio logic or fetch from backend if added
    } catch (e) {
      debugPrint("Error fetching data: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addProject(Project project) async {
    try {
      final newProj = await ApiService.createProject(project);
      _projects.add(newProj);
      notifyListeners();
    } catch (e) {
      debugPrint("Error adding project: $e");
    }
  }

  Future<void> addLand(Land land) async {
    try {
      final newLand = await ApiService.submitLand(land);
      _pendingLands.add(newLand);
      notifyListeners();
    } catch (e) {
      debugPrint("Error submitting land: $e");
    }
  }

  void addToPortfolio(Project project) {
    if (!_investorPortfolio.contains(project)) {
      _investorPortfolio.add(project);
      notifyListeners();
    }
  }
}
