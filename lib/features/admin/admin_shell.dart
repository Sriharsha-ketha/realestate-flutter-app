import 'package:flutter/material.dart';
import 'admin_dashboard.dart';
import 'land_approval_screen.dart';
import 'project_management_screen.dart';

class AdminShell extends StatefulWidget {
  const AdminShell({super.key});

  @override
  State<AdminShell> createState() => _AdminShellState();
}

class _AdminShellState extends State<AdminShell> {
  int currentIndex = 0;

  final List<Widget> pages = const [
    AdminDashboard(),
    LandApprovalScreen(),
    ProjectManagementScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: "Overview",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.landscape),
            label: "Land Approvals",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: "Projects",
          ),
        ],
      ),
    );
  }
}
