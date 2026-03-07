import 'package:flutter/material.dart';
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
  final _irrCtrl = TextEditingController();
  final _capReqCtrl = TextEditingController();
  final _capRaisedCtrl = TextEditingController();

  @override
  void dispose() {
    _titleCtrl.dispose();
    _locationCtrl.dispose();
    _irrCtrl.dispose();
    _capReqCtrl.dispose();
    _capRaisedCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    final irr = double.tryParse(_irrCtrl.text) ?? 0;
    final capReq = double.tryParse(_capReqCtrl.text) ?? 0;
    final capRaised = double.tryParse(_capRaisedCtrl.text) ?? 0;

    AppState.projects.add(
      Project(
        title: _titleCtrl.text,
        location: _locationCtrl.text,
        irr: irr,
        capitalRequired: capReq,
        capitalRaised: capRaised,
        stage: 'Feasibility',
      ),
    );
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
              decoration: InputDecoration(
                labelText: 'Project Title',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _locationCtrl,
              decoration: InputDecoration(
                labelText: 'Location',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _irrCtrl,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Projected IRR (%)',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _capReqCtrl,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Capital Required (₹Cr)',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _capRaisedCtrl,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Capital Raised (₹Cr)',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 25),
            ElevatedButton(onPressed: _submit, child: const Text('Create')),
          ],
        ),
      ),
    );
  }
}
