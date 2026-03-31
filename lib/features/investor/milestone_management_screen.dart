import 'package:flutter/material.dart';
import '../../models/project_milestone.dart';
import '../../services/api_service.dart';

class MilestoneManagementScreen extends StatefulWidget {
  final int projectId;
  final String projectName;
  final int investorId;
  final String investorEmail;

  const MilestoneManagementScreen({
    super.key,
    required this.projectId,
    required this.projectName,
    required this.investorId,
    required this.investorEmail,
  });

  @override
  State<MilestoneManagementScreen> createState() => _MilestoneManagementScreenState();
}

class _MilestoneManagementScreenState extends State<MilestoneManagementScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _dateController = TextEditingController();
  String _status = 'PENDING';
  
  List<ProjectMilestone> _milestones = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchMilestones();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  Future<void> _fetchMilestones() async {
    setState(() => _isLoading = true);
    try {
      final milestones = await ApiService.getMilestones(widget.projectId, widget.investorId);
      setState(() {
        _milestones = milestones;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  Future<void> _selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _dateController.text = picked.toString().split(' ')[0];
      });
    }
  }

  Future<void> _addMilestone() async {
    if (!_formKey.currentState!.validate()) return;

    final milestone = ProjectMilestone(
      projectId: widget.projectId,
      investorId: widget.investorId,
      milestone: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      date: _dateController.text.trim(),
      status: _status,
    );

    try {
      await ApiService.addMilestone(milestone);
      _titleController.clear();
      _descriptionController.clear();
      _dateController.clear();
      _status = 'PENDING';
      _fetchMilestones();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Milestone added successfully')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error adding milestone: $e')));
      }
    }
  }

  Future<void> _updateStatus(int milestoneId, String newStatus) async {
    try {
      await ApiService.updateMilestoneStatus(milestoneId, newStatus);
      _fetchMilestones();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error updating status: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Milestones'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.projectName, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            Text('Investor: ${widget.investorEmail}', style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 24),
            
            const Text('Milestone List', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 8),
            _isLoading 
              ? const Center(child: CircularProgressIndicator())
              : _milestones.isEmpty 
                ? const Padding(padding: EdgeInsets.symmetric(vertical: 20), child: Text('No milestones yet.'))
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _milestones.length,
                    itemBuilder: (context, index) {
                      final m = _milestones[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          title: Text(m.milestone, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text('${m.description ?? ''}\nDate: ${m.date ?? 'N/A'}'),
                          trailing: DropdownButton<String>(
                            value: m.status,
                            items: const [
                              DropdownMenuItem(value: 'PENDING', child: Text('PENDING')),
                              DropdownMenuItem(value: 'COMPLETED', child: Text('COMPLETED')),
                            ],
                            onChanged: (val) {
                              if (val != null) _updateStatus(m.id!, val);
                            },
                          ),
                        ),
                      );
                    },
                  ),
            
            const Divider(height: 40),
            const Text('Add New Milestone', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 16),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextField(
                    controller: _titleController,
                    decoration: const InputDecoration(labelText: 'Milestone Title', border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _descriptionController,
                    maxLines: 2,
                    decoration: const InputDecoration(labelText: 'Description', border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _dateController,
                    readOnly: true,
                    onTap: _selectDate,
                    decoration: const InputDecoration(
                      labelText: 'Date',
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: _status,
                    decoration: const InputDecoration(labelText: 'Status', border: OutlineInputBorder()),
                    items: const [
                      DropdownMenuItem(value: 'PENDING', child: Text('PENDING')),
                      DropdownMenuItem(value: 'COMPLETED', child: Text('COMPLETED')),
                    ],
                    onChanged: (v) => setState(() => _status = v!),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _addMilestone,
                      child: const Text('Add Milestone'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
