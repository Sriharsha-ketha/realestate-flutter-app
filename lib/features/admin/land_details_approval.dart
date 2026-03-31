import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import '../../models/land.dart';
import '../../shared/app_state.dart';

class LandDetailsApproval extends StatefulWidget {
  final Land land;

  const LandDetailsApproval({super.key, required this.land});

  @override
  State<LandDetailsApproval> createState() => _LandDetailsApprovalState();
}

class _LandDetailsApprovalState extends State<LandDetailsApproval> {
  bool _isApproving = false;
  final _rejectionController = TextEditingController();
  
  // Financial data controllers
  final _estimatedCostController = TextEditingController();
  final _expectedRevenueController = TextEditingController();
  final _evaluationYearsController = TextEditingController(text: '5');

  // Manual Analytics Controllers
  final _rentalYieldCtrl = TextEditingController();
  final _projAnnualIncomeCtrl = TextEditingController();
  final _capAppreciationCtrl = TextEditingController();
  final _avgOccupancyCtrl = TextEditingController();
  final _peakOccupancyCtrl = TextEditingController();
  final _adrCtrl = TextEditingController();
  final _cashFlowCtrl = TextEditingController();
  final _noiCtrl = TextEditingController();
  String _seasonalDemand = 'MEDIUM';

  // Override Toggle
  bool _overrideCalculated = false;
  final _manualRoiCtrl = TextEditingController();
  final _manualIrrCtrl = TextEditingController();

  @override
  void dispose() {
    _rejectionController.dispose();
    _estimatedCostController.dispose();
    _expectedRevenueController.dispose();
    _evaluationYearsController.dispose();
    _rentalYieldCtrl.dispose();
    _projAnnualIncomeCtrl.dispose();
    _capAppreciationCtrl.dispose();
    _avgOccupancyCtrl.dispose();
    _peakOccupancyCtrl.dispose();
    _adrCtrl.dispose();
    _cashFlowCtrl.dispose();
    _noiCtrl.dispose();
    _manualRoiCtrl.dispose();
    _manualIrrCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final land = widget.land;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Land Details - Approval'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with Status Badge
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            land.name,
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          _buildStatusBadge(land.reviewStatus),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Location Section
              _buildSectionHeader(context, 'Location Details'),
              const SizedBox(height: 12),
              _buildInfoCard(
                icon: Icons.location_on_outlined,
                label: 'Location',
                value: land.location,
              ),
              if (land.stateCategory != null && land.stateCategory!.isNotEmpty)
                _buildInfoCard(
                  icon: Icons.map_outlined,
                  label: 'State / Region',
                  value: land.stateCategory!,
                ),
              if (land.destination != null && land.destination!.isNotEmpty)
                _buildInfoCard(
                  icon: Icons.place_outlined,
                  label: 'Tourist Destination',
                  value: land.destination!,
                ),
              _buildInfoCard(
                icon: Icons.landscape_outlined,
                label: 'Land Size',
                value: '${land.size} acres',
              ),
              const SizedBox(height: 24),

              // Zoning & Properties
              _buildSectionHeader(context, 'Property Details'),
              const SizedBox(height: 12),
              _buildInfoCard(
                icon: Icons.domain_outlined,
                label: 'Zoning Type',
                value: land.zoning,
              ),
              _buildInfoCard(
                icon: Icons.description_outlined,
                label: 'Development Stage',
                value: land.stage,
              ),
              const SizedBox(height: 24),

              // Utilities
              if (land.utilities != null && land.utilities!.isNotEmpty) ...[
                _buildSectionHeader(context, 'Available Utilities'),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: land.utilities!
                      .map((utility) => Chip(
                    label: Text(utility),
                    avatar: const Icon(Icons.check_circle, size: 20),
                    backgroundColor: Colors.green.shade100,
                    labelStyle: TextStyle(
                      color: Colors.green.shade800,
                      fontWeight: FontWeight.w600,
                    ),
                  ))
                      .toList(),
                ),
                const SizedBox(height: 24),
              ],

              // Project Files
              if (land.legalDocuments != null && land.legalDocuments!.isNotEmpty) ...[
                _buildSectionHeader(context, 'Project Files'),
                const SizedBox(height: 12),
                _buildProjectFilesDisplay(land.legalDocuments!),
                const SizedBox(height: 24),
              ],

              // Summary Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.indigo.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.indigo.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Summary',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Land Owner ID:', style: Theme.of(context).textTheme.bodySmall),
                        Text('${land.ownerId}', style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Action Buttons
              if (land.reviewStatus == 'PENDING') ...[
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _isApproving ? null : () => _showFinancialAndAnalyticsDialog(context),
                        icon: const Icon(Icons.check_circle),
                        label: const Text('Approve & Launch'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _isApproving ? null : () => _showRejectionDialog(context),
                        icon: const Icon(Icons.close),
                        label: const Text('Reject'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ],
                ),
              ] else ...[
                _buildFinalStatusIndicator(land.reviewStatus),
              ],
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color = Colors.orange;
    if (status == 'APPROVED') color = Colors.green;
    if (status == 'REJECTED') color = Colors.red;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.bold,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  Widget _buildInfoCard({required IconData icon, required String label, required String value}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: Theme.of(context).colorScheme.primary),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey.shade600)),
                const SizedBox(height: 4),
                Text(value, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProjectFilesDisplay(String filePathsString) {
    final filePaths = filePathsString.split('|').where((path) => path.trim().isNotEmpty).toList();
    if (filePaths.isEmpty) return const SizedBox.shrink();

    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: filePaths.length,
        itemBuilder: (context, index) {
          final filePath = filePaths[index].trim();
          final fileName = filePath.split('/').last;
          return ListTile(
            leading: const Icon(Icons.description_outlined, color: Colors.blue),
            title: Text(fileName, maxLines: 1, overflow: TextOverflow.ellipsis),
            trailing: const Icon(Icons.download, color: Colors.blue),
          );
        },
      ),
    );
  }

  void _showFinancialAndAnalyticsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setDialogState) {
          return AlertDialog(
            title: const Text('Project Launch & Analytics'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('1. Financials (Calculated)', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  TextField(controller: _estimatedCostController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Estimated Project Cost (₹)', border: OutlineInputBorder())),
                  const SizedBox(height: 12),
                  TextField(controller: _expectedRevenueController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Expected Annual Revenue (₹)', border: OutlineInputBorder())),
                  const SizedBox(height: 12),
                  TextField(controller: _evaluationYearsController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Evaluation Period (Years)', border: OutlineInputBorder())),
                  
                  const SizedBox(height: 24),
                  const Text('2. Advanced Analytics (Manual)', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  TextField(controller: _rentalYieldCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Rental Yield (%)', border: OutlineInputBorder())),
                  const SizedBox(height: 12),
                  TextField(controller: _projAnnualIncomeCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Projected Annual Income (₹)', border: OutlineInputBorder())),
                  const SizedBox(height: 12),
                  TextField(controller: _capAppreciationCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Capital Appreciation (%)', border: OutlineInputBorder())),
                  const SizedBox(height: 12),
                  TextField(controller: _avgOccupancyCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Avg Occupancy (%)', border: OutlineInputBorder())),
                  const SizedBox(height: 12),
                  TextField(controller: _peakOccupancyCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Peak Occupancy (%)', border: OutlineInputBorder())),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: _seasonalDemand,
                    decoration: const InputDecoration(labelText: 'Seasonal Demand', border: OutlineInputBorder()),
                    items: const [DropdownMenuItem(value: 'HIGH', child: Text('High')), DropdownMenuItem(value: 'MEDIUM', child: Text('Medium')), DropdownMenuItem(value: 'LOW', child: Text('Low'))],
                    onChanged: (v) => setDialogState(() => _seasonalDemand = v!),
                  ),
                  const SizedBox(height: 12),
                  TextField(controller: _adrCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'ADR (Average Daily Rate)', border: OutlineInputBorder())),
                  const SizedBox(height: 12),
                  TextField(controller: _cashFlowCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Monthly Cash Flow (₹)', border: OutlineInputBorder())),
                  const SizedBox(height: 12),
                  TextField(controller: _noiCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'NOI (Net Operating Income)', border: OutlineInputBorder())),
                  
                  const SizedBox(height: 24),
                  SwitchListTile(
                    title: const Text('Override auto ROI/IRR', style: TextStyle(fontSize: 14)),
                    value: _overrideCalculated,
                    onChanged: (val) => setDialogState(() => _overrideCalculated = val),
                  ),
                  if (_overrideCalculated) ...[
                    TextField(controller: _manualRoiCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Manual ROI (%)')),
                    const SizedBox(height: 12),
                    TextField(controller: _manualIrrCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Manual IRR (%)')),
                  ],
                ],
              ),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
              ElevatedButton(
                onPressed: () => _submitApproval(context),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                child: const Text('Launch Project', style: TextStyle(color: Colors.white)),
              ),
            ],
          );
        });
      },
    );
  }

  double? _parse(TextEditingController ctrl) => double.tryParse(ctrl.text.trim());

  Future<void> _submitApproval(BuildContext context) async {
    if (_estimatedCostController.text.isEmpty || _expectedRevenueController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Enter cost and revenue')));
      return;
    }

    try {
      setState(() => _isApproving = true);
      
      final payload = {
        'title': '${widget.land.name} Project',
        'estimatedCost': _parse(_estimatedCostController),
        'expectedAnnualRevenue': _parse(_expectedRevenueController),
        'evaluationYears': int.tryParse(_evaluationYearsController.text) ?? 5,
        'rentalYield': _parse(_rentalYieldCtrl),
        'projectedAnnualIncome': _parse(_projAnnualIncomeCtrl),
        'capitalAppreciation': _parse(_capAppreciationCtrl),
        'averageOccupancy': _parse(_avgOccupancyCtrl),
        'peakOccupancy': _parse(_peakOccupancyCtrl),
        'seasonalDemand': _seasonalDemand,
        'adr': _parse(_adrCtrl),
        'monthlyCashFlow': _parse(_cashFlowCtrl),
        'noi': _parse(_noiCtrl),
        'overrideCalculated': _overrideCalculated,
        'manualROI': _parse(_manualRoiCtrl),
        'manualIRR': _parse(_manualIrrCtrl),
      };

      await context.read<AppState>().convertLandToProject(widget.land.id!, payload);

      if (mounted) {
        Navigator.pop(context);
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      if (mounted) setState(() => _isApproving = false);
    }
  }

  void _showRejectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reject Submission'),
        content: TextField(
          controller: _rejectionController,
          maxLines: 3,
          decoration: const InputDecoration(hintText: 'Enter reason...', border: OutlineInputBorder()),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              if (_rejectionController.text.isEmpty) return;
              await context.read<AppState>().adminRejectLand(widget.land.id!, adminNotes: _rejectionController.text);
              if (mounted) {
                Navigator.pop(context);
                Navigator.pop(context, true);
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Reject', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildFinalStatusIndicator(String status) {
    final isApproved = status == 'APPROVED' || status == 'CONVERTED_TO_PROJECT';
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isApproved ? Colors.green.shade50 : Colors.red.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isApproved ? Colors.green.shade200 : Colors.red.shade200),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(isApproved ? Icons.check_circle : Icons.cancel, color: isApproved ? Colors.green : Colors.red),
          const SizedBox(width: 12),
          Text(isApproved ? 'Project Launched' : 'Submission Rejected', style: TextStyle(color: isApproved ? Colors.green.shade700 : Colors.red.shade700, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
