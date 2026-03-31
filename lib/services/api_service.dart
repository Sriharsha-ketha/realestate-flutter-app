import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/project.dart';
import '../models/land.dart';
import '../models/eoi.dart';
import '../models/destination.dart';
import '../models/project_milestone.dart';
import 'package:flutter/foundation.dart';

class ApiService {
  static String get baseUrl {
    if (Platform.isAndroid) return 'http://10.0.2.2:8080/api';
    return 'http://localhost:8080/api';
  }

  static Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');
    return {
      "Content-Type": "application/json",
      if (token != null) "Authorization": "Bearer $token",
    };
  }

  // Auth Endpoints
  static Future<Map<String, dynamic>> login(String email, String password,
      {String? role}) async {
    final payload = {"email": email, "password": password};
    if (role != null) payload['role'] = role;
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {"Content-Type": "application/json"},
      body: json.encode(payload),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Login failed');
    }
  }

  static Future<Map<String, dynamic>> register(
    String email,
    String password,
    String role, {
    double? minBudget,
    double? maxBudget,
    String? riskProfile,
  }) async {
    final payload = <String, dynamic>{
      "email": email,
      "password": password,
      "role": role,
      if (minBudget != null) "minBudget": minBudget,
      if (maxBudget != null) "maxBudget": maxBudget,
      if (riskProfile != null) "riskProfile": riskProfile,
    };

    final response = await http.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: {"Content-Type": "application/json"},
      body: json.encode(payload),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Registration failed');
    }
  }

  static Future<void> forgotPassword(String email) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/forgot-password'),
      headers: {"Content-Type": "application/json"},
      body: json.encode(email),
    );
    if (response.statusCode != 200) throw Exception('Failed to request reset');
  }

  static Future<void> verifyOtp(String email, String otp) async {
    final payload = {"email": email, "otp": otp};
    final response = await http.post(
      Uri.parse('$baseUrl/auth/verify-otp'),
      headers: {"Content-Type": "application/json"},
      body: json.encode(payload),
    );
    if (response.statusCode != 200) throw Exception('OTP verification failed');
  }

  static Future<void> resetPassword(
      String email, String otp, String newPassword) async {
    final payload = {"email": email, "otp": otp, "newPassword": newPassword};
    final response = await http.post(
      Uri.parse('$baseUrl/auth/reset-password'),
      headers: {"Content-Type": "application/json"},
      body: json.encode(payload),
    );
    if (response.statusCode != 200) throw Exception('Password reset failed');
  }

  // Finance Endpoints
  static Future<double> calculateROI(double investment, double finalValue) async {
    final url = Uri.parse('$baseUrl/finance/roi?investment=${investment.toString()}&finalValue=${finalValue.toString()}');
    final response = await http.get(url, headers: await _getHeaders());
    if (response.statusCode == 200) {
      return (json.decode(response.body) as num).toDouble();
    } else {
      throw Exception('Failed to calculate ROI');
    }
  }

  static Future<Map<String, double>> getScenarioROI(double investment) async {
    final url = Uri.parse('$baseUrl/finance/roi/scenarios?investment=${investment.toString()}');
    final response = await http.get(url, headers: await _getHeaders());
    if (response.statusCode == 200) {
      final map = json.decode(response.body) as Map<String, dynamic>;
      return map.map((k, v) => MapEntry(k, (v as num).toDouble()));
    } else {
      throw Exception('Failed to fetch ROI scenarios');
    }
  }

  static Future<double> calculateIRR(List<double> cashFlows) async {
    final response = await http.post(
      Uri.parse('$baseUrl/finance/irr'),
      headers: await _getHeaders(),
      body: json.encode(cashFlows),
    );
    if (response.statusCode == 200) {
      return (json.decode(response.body) as num).toDouble();
    } else {
      throw Exception('Failed to calculate IRR');
    }
  }

  // Project Endpoints
  static Future<List<Project>> getProjects({String? theme}) async {
    var url = '$baseUrl/projects';
    if (theme != null && theme != 'All') {
      url += '?theme=${Uri.encodeComponent(theme)}';
    }
    final headers = await _getHeaders();
    final response = await http.get(Uri.parse(url), headers: headers);
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Project.fromJson(data as Map<String, dynamic>)).toList();
    } else {
      throw Exception('Failed to load projects');
    }
  }

  static Future<List<Project>> getInvestorProjects(int investorId) async {
    final url = '$baseUrl/projects/investor/$investorId';
    final response = await http.get(Uri.parse(url), headers: await _getHeaders());
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Project.fromJson(data as Map<String, dynamic>)).toList();
    } else {
      throw Exception('Failed to load investor projects');
    }
  }

  static Future<List<Project>> getOwnerProjects(int ownerId) async {
    final url = '$baseUrl/projects/owner/$ownerId';
    final response = await http.get(Uri.parse(url), headers: await _getHeaders());
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Project.fromJson(data as Map<String, dynamic>)).toList();
    } else {
      throw Exception('Failed to load owner projects');
    }
  }

  static Future<Project> createProject(Project project) async {
    final url = '$baseUrl/projects/create';
    final headers = await _getHeaders();
    final response = await http.post(Uri.parse(url), headers: headers, body: json.encode(project.toJson()));
    if (response.statusCode == 200 || response.statusCode == 201) {
      return Project.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create project');
    }
  }

  static Future<Project> updateProjectStage(int projectId, String stage) async {
    final url = '$baseUrl/projects/update-stage/$projectId?stage=${Uri.encodeComponent(stage)}';
    final headers = await _getHeaders();
    final response = await http.put(Uri.parse(url), headers: headers);
    if (response.statusCode == 200) {
      return Project.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update project stage');
    }
  }

  // Land Endpoints
  static Future<List<Land>> getLands() async {
    final response = await http.get(Uri.parse('$baseUrl/lands'), headers: await _getHeaders());
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Land.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load lands');
    }
  }

  static Future<List<Land>> getAvailableLands() async {
    final response = await http.get(Uri.parse('$baseUrl/lands/available'), headers: await _getHeaders());
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Land.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load available lands');
    }
  }

  static Future<Land> submitLand(Land land) async {
    final response = await http.post(
      Uri.parse('$baseUrl/lands'),
      headers: await _getHeaders(),
      body: json.encode(land.toJson()),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return Land.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to submit land');
    }
  }

  static Future<Land> updateLandReview(int landId, String status) async {
    final response = await http.put(
      Uri.parse('$baseUrl/lands/$landId/review'),
      headers: await _getHeaders(),
      body: json.encode(status),
    );
    if (response.statusCode == 200) {
      return Land.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update land review');
    }
  }

  // Eoi Endpoints
  static Future<Eoi> submitEOI(Eoi eoi) async {
    final response = await http.post(
      Uri.parse('$baseUrl/eois'),
      headers: await _getHeaders(),
      body: json.encode(eoi.toJson()),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return Eoi.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to submit EOI');
    }
  }

  static Future<bool> checkEOIExists(int investorId, int projectId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/eois/check/$investorId/$projectId'),
      headers: await _getHeaders(),
    );
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return jsonResponse['exists'] ?? false;
    }
    return false;
  }

  static Future<List<Eoi>> getInvestorEOIs(int investorId) async {
    final response = await http.get(Uri.parse('$baseUrl/eois/investor/$investorId'), headers: await _getHeaders());
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Eoi.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load investor EOIs');
    }
  }

  // Investor management
  static Future<List<Map<String, dynamic>>> getInvestorsByProject(int projectId) async {
    final response = await http.get(Uri.parse('$baseUrl/eois/project/$projectId'), headers: await _getHeaders());
    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    } else {
      throw Exception('Failed to load investors');
    }
  }

  // Milestone Endpoints (INVESTOR DRIVEN)
  static Future<List<ProjectMilestone>> getMilestones(int projectId, int investorId) async {
    final url = '$baseUrl/projects/$projectId/milestones/$investorId';
    final response = await http.get(Uri.parse(url), headers: await _getHeaders());
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((d) => ProjectMilestone.fromJson(d as Map<String, dynamic>)).toList();
    } else {
      throw Exception('Failed to load milestones');
    }
  }

  static Future<ProjectMilestone> addMilestone(ProjectMilestone milestone) async {
    final response = await http.post(
      Uri.parse('$baseUrl/milestones/add'),
      headers: await _getHeaders(),
      body: json.encode(milestone.toJson()),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return ProjectMilestone.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to add milestone');
    }
  }

  static Future<ProjectMilestone> updateMilestoneStatus(int milestoneId, String status) async {
    final response = await http.put(
      Uri.parse('$baseUrl/milestones/$milestoneId/status?status=${Uri.encodeComponent(status)}'),
      headers: await _getHeaders(),
    );
    if (response.statusCode == 200) {
      return ProjectMilestone.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update milestone status');
    }
  }

  // Admin Endpoints
  static Future<List<Land>> getPendingLands() async {
    final response = await http.get(Uri.parse('$baseUrl/admin/pending-lands'), headers: await _getHeaders());
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Land.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load pending lands');
    }
  }

  static Future<Land> approveLand(int landId, {String? adminNotes}) async {
    final response = await http.put(
      Uri.parse('$baseUrl/admin/approve/$landId'),
      headers: await _getHeaders(),
      body: json.encode(adminNotes ?? ''),
    );
    if (response.statusCode == 200) {
      return Land.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to approve land');
    }
  }

  static Future<Land> rejectLand(int landId, {String? adminNotes}) async {
    final response = await http.put(
      Uri.parse('$baseUrl/admin/reject/$landId'),
      headers: await _getHeaders(),
      body: json.encode(adminNotes ?? ''),
    );
    if (response.statusCode == 200) {
      return Land.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to reject land');
    }
  }

  static Future<Project> convertLandToProject(int landId, Map<String, dynamic> payload) async {
    final response = await http.post(
      Uri.parse('$baseUrl/admin/convert/$landId'),
      headers: await _getHeaders(),
      body: json.encode(payload),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return Project.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to convert land to project');
    }
  }

  // Tourism Filters
  static Future<Map<String, List<String>>> getTourismFilters() async {
    final response = await http.get(Uri.parse('$baseUrl/destinations/tourism'), headers: await _getHeaders());
    if (response.statusCode == 200) {
      final jsonBody = json.decode(response.body) as Map<String, dynamic>;
      return jsonBody.map((key, value) => MapEntry(key, (value as List).map((v) => v.toString()).toList()));
    } else {
      throw Exception('Failed to load tourism filters');
    }
  }
}
