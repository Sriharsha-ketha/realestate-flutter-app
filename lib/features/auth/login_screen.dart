import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../shared/app_state.dart';
import '../investor/investor_shell.dart';
import '../admin/admin_shell.dart';
import 'forgot_password_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _isLogin = true;
  String _role = "Investor";

  void _submit() async {
    final appState = context.read<AppState>();
    bool success;
    if (_isLogin) {
      success = await appState.login(_emailCtrl.text, _passwordCtrl.text, role: _role.toUpperCase());
    } else {
      success = await appState.register(_emailCtrl.text, _passwordCtrl.text, _role.toUpperCase());
    }

    if (success) {
      final role = appState.currentUserRole?.toUpperCase();
      if (role == "INVESTOR" || role == "LANDOWNER") {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const InvestorShell()));
      } else if (role == "ADMIN") {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const AdminShell()));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Authentication Failed")));
    }
  }

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
                  const Icon(Icons.account_balance, size: 80, color: Color(0xFF1A237E)),
                  const SizedBox(height: 24),
                  Text("Investify", style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(height: 8),
                  Text(_isLogin ? "Welcome Back" : "Create Account", style: Theme.of(context).textTheme.bodyMedium),
                  const SizedBox(height: 48),
                  TextField(
                    controller: _emailCtrl,
                    decoration: const InputDecoration(labelText: "Email", prefixIcon: Icon(Icons.email_outlined)),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _passwordCtrl,
                    obscureText: true,
                    decoration: const InputDecoration(labelText: "Password", prefixIcon: Icon(Icons.lock_outline)),
                  ),
                  const SizedBox(height: 20),
                  DropdownButtonFormField<String>(
                    value: _role,
                    items: const [
                      DropdownMenuItem(value: "Investor", child: Text("Investor")),
                      DropdownMenuItem(value: "Admin", child: Text("Admin")),
                    ],
                    onChanged: (v) => setState(() => _role = v!),
                    decoration: const InputDecoration(labelText: "Role", prefixIcon: Icon(Icons.person_outline)),
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: context.watch<AppState>().isLoading ? null : _submit,
                    child: context.watch<AppState>().isLoading 
                      ? const CircularProgressIndicator(color: Colors.white) 
                      : Text(_isLogin ? "Sign In" : "Sign Up"),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () => setState(() => _isLogin = !_isLogin),
                    child: Text(_isLogin ? "Don't have an account? Sign Up" : "Already have an account? Sign In"),
                  ),
                  if (_isLogin)
                    TextButton(
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ForgotPasswordScreen())),
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
