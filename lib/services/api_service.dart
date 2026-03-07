import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/project.dart';
import '../models/land.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:8080/api';

  // Project Endpoints
  static Future<List<Project>> getProjects() async {
    final response = await http.get(Uri.parse('$baseUrl/projects'));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Project.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load projects');
    }
  }

  static Future<Project> createProject(Project project) async {
    final response = await http.post(
      Uri.parse('$baseUrl/projects'),
      headers: {"Content-Type": "application/json"},
      body: json.encode(project.toJson()),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return Project.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create project');
    }
  }

  // Land Endpoints
  static Future<List<Land>> getLands() async {
    final response = await http.get(Uri.parse('$baseUrl/lands'));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Land.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load lands');
    }
  }

  static Future<Land> submitLand(Land land) async {
    final response = await http.post(
      Uri.parse('$baseUrl/lands'),
      headers: {"Content-Type": "application/json"},
      body: json.encode(land.toJson()),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return Land.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to submit land');
    }
  }
}
