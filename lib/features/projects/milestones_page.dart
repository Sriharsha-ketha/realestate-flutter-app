import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/project_milestone.dart';
import '../../services/api_service.dart';
import '../../shared/app_state.dart';

class MilestonesPage extends StatefulWidget {
  final int projectId;
  final String? projectName;
  final int investorId;
  final String? investorEmail;

  const MilestonesPage({
    Key? key, 
    required this.projectId, 
    this.projectName,
    required this.investorId,
    this.investorEmail,
  }) : super(key: key);

  @override
  State<MilestonesPage> createState() => _MilestonesPageState();
}

class _MilestonesPageState extends State<MilestonesPage> {
  late Future<List<ProjectMilestone>> _future;

  final _formKey = GlobalKey<FormState>();
  final _milestoneController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _dateController = TextEditingController();
  String _status = 'PENDING';

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    setState(() {
      _future = ApiService.getMilestones(widget.projectId, widget.investorId);
    });
  }

  @override
  void dispose() {
    _milestoneController.dispose();
    _descriptionController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    
    final milestone = ProjectMilestone(
      projectId: widget.projectId,
      investorId: widget.investorId,
      milestone: _milestoneController.text.trim(),
      description: _descriptionController.text.trim().isEmpty ? null : _descriptionController.text.trim(),
      date: _dateController.text.trim().isEmpty ? null : _dateController.text.trim(),
      status: _status,
    );

    try {
      await ApiService.addMilestone(milestone);
      _milestoneController.clear();
      _descriptionController.clear();
      _dateController.clear();
      _status = 'PENDING';
      _load();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to add milestone: $e')));
    }
  }

  Future<void> _updateStatus(int milestoneId, String status) async {
    try {
      await ApiService.updateMilestoneStatus(milestoneId, status);
      _load();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to update status: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.read<AppState>();
    final currentUserId = appState.currentUserId;
    
    // Authorization: Investor can only see their own milestones. 
    // Project owner (or admin for demo) can manage them.
    // We'll determine "Owner" status by checking if the project's ownerId matches currentUserId.
    
    // For this UI, we assume the caller handled visibility. 
    // But we restrict editing based on role and ownership.
    final bool canEdit = appState.projects.any((p) => p.id == widget.projectId && p.ownerId == currentUserId);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.projectName ?? 'Milestones', style: const TextStyle(fontSize: 16)),
            if (widget.investorEmail != null)
              Text('Investor: ${widget.investorEmail}', style: const TextStyle(fontSize: 12)),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Expanded(
              child: FutureBuilder<List<ProjectMilestone>>(
                future: _future,
                builder: (context, snap) {
                  if (snap.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
                  if (snap.hasError) return Center(child: Text('Error: ${snap.error}'));
                  final list = snap.data ?? [];
                  if (list.isEmpty) return const Center(child: Text('No milestones created yet.'));
                  return ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (context, i) {
                      final m = list[i];
                      return Card(
                        child: ListTile(
                          title: Text(m.milestone),
                          subtitle: Text('${m.description ?? ''}\n${m.date ?? ''}'),
                          isThreeLine: true,
                          trailing: canEdit
                              ? PopupMenuButton<String>(
                                  onSelected: (val) => _updateStatus(m.id!, val),
                                  itemBuilder: (_) => [
                                    const PopupMenuItem(value: 'PENDING', child: Text('Set PENDING')),
                                    const PopupMenuItem(value: 'COMPLETED', child: Text('Set COMPLETED')),
                                  ],
                                )
                              : Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: m.status == 'COMPLETED' ? Colors.green : Colors.orange,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(m.status, style: const TextStyle(color: Colors.white, fontSize: 10)),
                                ),
                          leading: CircleAvatar(
                            backgroundColor: m.status == 'COMPLETED' ? Colors.green : Colors.orange,
                            child: Icon(
                              m.status == 'COMPLETED' ? Icons.check : Icons.access_time,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            if (canEdit) ...[
              const Divider(),
              _buildForm(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('Add Personal Milestone', style: TextStyle(fontWeight: FontWeight.bold)),
          TextFormField(
            controller: _milestoneController,
            decoration: const InputDecoration(labelText: 'Milestone Title'),
            validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
          ),
          TextFormField(
            controller: _descriptionController,
            decoration: const InputDecoration(labelText: 'Notes'),
          ),
          TextFormField(
            controller: _dateController,
            decoration: const InputDecoration(labelText: 'Target Date (yyyy-MM-dd)'),
          ),
          const SizedBox(height: 8),
          ElevatedButton(onPressed: _submit, child: const Text('Add Milestone')),
        ],
      ),
    );
  }
}
