import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/land.dart';
import '../models/project.dart';
import '../models/eoi.dart';
import '../services/api_service.dart';

class AppState extends ChangeNotifier {
  List<Land> _lands = [];
  List<Project> _projects = [];
  List<Project> _investorProjects = [];
  List<Project> _ownerProjects = [];
  List<Eoi> _userEOIs = [];

  List<Land> get pendingLands =>
      _lands.where((l) => l.reviewStatus == 'PENDING').toList();
  List<Land> get approvedLands =>
      _lands.where((l) => l.reviewStatus == 'APPROVED').toList();
  
  List<Project> get projects => _projects;
  List<Project> get investorPortfolio => _investorProjects;
  List<Project> get ownerProjects => _ownerProjects;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  int? _currentUserId;
  String? _currentUserRole;
  String? _currentUserEmail;

  double? _minBudget;
  double? _maxBudget;
  String? _riskProfile;

  int? get currentUserId => _currentUserId;
  String? get currentUserRole => _currentUserRole;
  String? get currentUserEmail => _currentUserEmail;
  double? get minBudget => _minBudget;
  double? get maxBudget => _maxBudget;
  String? get riskProfile => _riskProfile;

  Future<void> fetchAll() async {
    _isLoading = true;
    notifyListeners();
    try {
      _projects = await ApiService.getProjects();

      if (_currentUserRole == 'ADMIN') {
        _lands = await ApiService.getLands();
      }

      if (_currentUserId != null) {
        _investorProjects = await ApiService.getInvestorProjects(_currentUserId!);
        _ownerProjects = await ApiService.getOwnerProjects(_currentUserId!);
        _userEOIs = await ApiService.getInvestorEOIs(_currentUserId!);
      }
    } catch (e) {
      debugPrint("Error fetching data: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchInvestorProjects() async {
    if (_currentUserId == null) return;
    try {
      _investorProjects = await ApiService.getInvestorProjects(_currentUserId!);
      notifyListeners();
    } catch (e) {
      debugPrint("Error fetching investor projects: $e");
    }
  }

  Future<void> fetchPendingFromServer() async {
    try {
      _isLoading = true;
      notifyListeners();
      _lands = await ApiService.getPendingLands();
    } catch (e) {
      debugPrint('Error fetching pending lands: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> login(String email, String password, {String? role}) async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await ApiService.login(email, password, role: role);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('jwt_token', response['token']);
      await prefs.setString('user_role', response['role']);
      _currentUserId = response['userId'];
      _currentUserRole = response['role'];
      _currentUserEmail = response['email'];
      
      _minBudget = (response['minBudget'] as num?)?.toDouble();
      _maxBudget = (response['maxBudget'] as num?)?.toDouble();
      _riskProfile = response['riskProfile'] as String?;
      
      await fetchAll();
      return true;
    } catch (e) {
      debugPrint("Login error: $e");
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> register(
    String email,
    String password,
    String role, {
    double? minBudget,
    double? maxBudget,
    String? riskProfile,
  }) async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await ApiService.register(
        email,
        password,
        role,
        minBudget: minBudget,
        maxBudget: maxBudget,
        riskProfile: riskProfile,
      );
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('jwt_token', response['token']);
      await prefs.setString('user_role', response['role']);
      _currentUserId = response['userId'];
      _currentUserRole = response['role'];
      _currentUserEmail = response['email'];
      
      _minBudget = (response['minBudget'] as num?)?.toDouble();
      _maxBudget = (response['maxBudget'] as num?)?.toDouble();
      _riskProfile = response['riskProfile'] as String?;
      
      await fetchAll();
      return true;
    } catch (e) {
      debugPrint("Registration error: $e");
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt_token');
    await prefs.remove('user_role');
    _currentUserId = null;
    _currentUserRole = null;
    _currentUserEmail = null;
    _minBudget = null;
    _maxBudget = null;
    _riskProfile = null;
    _lands = [];
    _projects = [];
    _investorProjects = [];
    _ownerProjects = [];
    _userEOIs = [];
    notifyListeners();
  }

  Future<void> addProject(Project project) async {
    try {
      await ApiService.createProject(project);
      await fetchAll();
    } catch (e) {
      debugPrint("Error adding project: $e");
    }
  }

  Future<void> updateProjectStage(int projectId, String stage) async {
    try {
      await ApiService.updateProjectStage(projectId, stage);
      await fetchAll();
    } catch (e) {
      debugPrint("Error updating project stage: $e");
    }
  }

  Future<void> addLand(Land land) async {
    try {
      await ApiService.submitLand(land);
      await fetchAll();
    } catch (e) {
      debugPrint("Error submitting land: $e");
    }
  }

  Future<void> adminApproveLand(int landId) async {
    try {
      await ApiService.approveLand(landId, adminNotes: 'Approved via admin UI');
      await fetchAll();
    } catch (e) {
      debugPrint('Error approving land: $e');
    }
  }

  Future<void> adminRejectLand(int landId, {String? adminNotes}) async {
    try {
      await ApiService.rejectLand(landId, adminNotes: adminNotes ?? 'Rejected via admin UI');
      await fetchAll();
    } catch (e) {
      debugPrint('Error rejecting land: $e');
    }
  }

  Future<Project?> convertLandToProject(int landId, Map<String, dynamic> payload) async {
    try {
      final project = await ApiService.convertLandToProject(landId, payload);
      await fetchAll();
      return project;
    } catch (e) {
      debugPrint('Error converting land: $e');
      return null;
    }
  }

  Future<bool> addToPortfolio(Project project) async {
    if (project.id == null || _currentUserId == null) return false;
    try {
      final eoi = Eoi(investorId: _currentUserId!, projectId: project.id!);
      await ApiService.submitEOI(eoi);
      await fetchAll();
      return true;
    } catch (e) {
      debugPrint("Error submitting EOI: $e");
      return false;
    }
  }

  bool hasEOIForProject(int projectId) {
    return _userEOIs.any((eoi) => eoi.projectId == projectId);
  }
}
