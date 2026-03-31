import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../shared/app_state.dart';
import '../auth/login_screen.dart';
import 'investor_dashboard.dart';
import 'explore_screen.dart';
import 'add_land_screen.dart';
import 'my_lands_screen.dart';

class InvestorShell extends StatefulWidget {
  const InvestorShell({super.key});

  @override
  State<InvestorShell> createState() => _InvestorShellState();
}

class _InvestorShellState extends State<InvestorShell> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // We check role-based visibility but don't introduce new roles.
    // The "Manage" functionality is now inside "My Assets" page.
    final List<Widget> pages = [
      const InvestorDashboard(),
      const ExploreScreen(),
      const AddLandScreen(),
      const MyLandsScreen(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("MVPhi"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AppState>().logout();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
            },
          ),
        ],
      ),
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: theme.colorScheme.primary,
        unselectedItemColor: theme.colorScheme.onSurface.withOpacity(0.6),
        backgroundColor: Colors.white,
        elevation: 10,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: "Dashboard",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: "Explore",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_location),
            label: "Add Land",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: "My Assets",
          ),
        ],
      ),
    );
  }
}
