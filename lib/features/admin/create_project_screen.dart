import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/project.dart';
import '../../shared/app_state.dart';

class CreateProjectScreen extends StatefulWidget {
  const CreateProjectScreen({super.key});

  @override
  State<CreateProjectScreen> createState() => _CreateProjectScreenState();
}

class _CreateProjectScreenState extends State<CreateProjectScreen> {
  final _titleCtrl = TextEditingController();
  final _locationCtrl = TextEditingController();
  final _themeCtrl = TextEditingController(text: 'Eco-Luxury');
  final _descCtrl = TextEditingController();
  final _irrCtrl = TextEditingController();
  final _capReqCtrl = TextEditingController();
  final _capRaisedCtrl = TextEditingController();

  @override
  void dispose() {
    _titleCtrl.dispose();
    _locationCtrl.dispose();
    _themeCtrl.dispose();
    _descCtrl.dispose();
    _irrCtrl.dispose();
    _capReqCtrl.dispose();
    _capRaisedCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    final irr = double.tryParse(_irrCtrl.text) ?? 0;
    final capReq = double.tryParse(_capReqCtrl.text) ?? 0;
    final capRaised = double.tryParse(_capRaisedCtrl.text) ?? 0;

    final newProject = Project(
      title: _titleCtrl.text,
      location: _locationCtrl.text,
      theme: _themeCtrl.text,
      description: _descCtrl.text,
      irr: irr,
      capitalRequired: capReq,
      capitalRaised: capRaised,
      stage: 'Feasibility',
      imageUrl: null,
      projectedGrowth: 0,
      demandIndex: 5,
      riskProfile: 'Medium',
    );
    
    context.read<AppState>().addProject(newProject);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Project')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(
              controller: _titleCtrl,
              decoration: const InputDecoration(labelText: 'Project Title'),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _locationCtrl,
              decoration: const InputDecoration(labelText: 'Location'),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _themeCtrl,
              decoration: const InputDecoration(labelText: 'Theme (e.g. Wellness)'),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _descCtrl,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _irrCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Projected IRR (%)'),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _capReqCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Capital Required (₹Cr)'),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _capRaisedCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Capital Raised (₹Cr)'),
            ),
            const SizedBox(height: 25),
            ElevatedButton(onPressed: _submit, child: const Text('Create')),
          ],
        ),
      ),
    );
  }
}
