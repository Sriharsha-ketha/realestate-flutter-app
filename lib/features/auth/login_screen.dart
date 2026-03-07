import 'package:flutter/material.dart';
import '../investor/investor_shell.dart';
import '../landowner/landowner_shell.dart';
import '../admin/admin_shell.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String role = "Investor";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.primary.withOpacity(0.05),
              Theme.of(context).colorScheme.background,
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.account_balance,
                    size: 80,
                    color: Color(0xFF1A237E),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    "Investify",
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Tourism Investment Platform",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 48),
                  TextField(
                    decoration: const InputDecoration(
                      labelText: "Email",
                      prefixIcon: Icon(Icons.email_outlined),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: "Password",
                      prefixIcon: Icon(Icons.lock_outline),
                    ),
                  ),
                  const SizedBox(height: 20),
                  DropdownButtonFormField<String>(
                    value: role,
                    items: const [
                      DropdownMenuItem(
                        value: "Investor",
                        child: Text("Investor"),
                      ),
                      DropdownMenuItem(
                        value: "Landowner",
                        child: Text("Landowner"),
                      ),
                      DropdownMenuItem(
                        value: "Administrator",
                        child: Text("Administrator"),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        role = value!;
                      });
                    },
                    decoration: const InputDecoration(
                      labelText: "Role",
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: () {
                      if (role == "Investor") {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const InvestorShell()),
                        );
                      } else if (role == "Landowner") {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const LandownerShell()),
                        );
                      } else {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const AdminShell()),
                        );
                      }
                    },
                    child: const Text("Sign In"),
                  ),
                  const SizedBox(height: 24),
                  TextButton(
                    onPressed: () {},
                    child: const Text("Forgot Password?"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
