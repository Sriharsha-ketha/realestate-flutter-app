import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../shared/widgets/stage_badge.dart';
import '../../models/project.dart';
import '../../shared/app_state.dart';
import '../../widgets/milestone_tile.dart';
import '../projects/milestones_page.dart';

class ProjectDetails extends StatefulWidget {
  final Project project;

  const ProjectDetails({super.key, required this.project});

  @override
  State<ProjectDetails> createState() => _ProjectDetailsState();
}

class _ProjectDetailsState extends State<ProjectDetails> {
  bool _complianceAccepted = false;
  bool _eoiSubmitted = false;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _checkIfEOIExists();
  }

  Future<void> _checkIfEOIExists() async {
    final appState = context.read<AppState>();
    final exists = appState.hasEOIForProject(widget.project.id!);
    setState(() {
      _eoiSubmitted = exists;
    });
  }

  Future<void> _submitEOI() async {
    if (!_complianceAccepted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please accept the compliance terms first')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final appState = context.read<AppState>();
      final success = await appState.addToPortfolio(widget.project);
      
      if (success && mounted) {
        setState(() => _eoiSubmitted = true);
        
        await Future.delayed(const Duration(milliseconds: 300));
        if (mounted) {
          await appState.fetchAll();
        }
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('✓ Expression of Interest submitted for ${widget.project.title}'),
              backgroundColor: Colors.green,
            ),
          );
          Future.delayed(const Duration(milliseconds: 500), () {
            if (mounted) Navigator.pop(context);
          });
        }
      }
    } on Exception catch (e) {
      if (mounted) {
        final errorMessage = e.toString().contains('already submitted')
            ? 'You have already submitted an EOI for this project'
            : 'Failed to submit EOI. Please try again.';
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
          ),
        );
        
        setState(() => _eoiSubmitted = true);
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  String _fmt(double? value, {String suffix = '', String prefix = '', int decimals = 1}) {
    if (value == null || value == 0) return 'N/A';
    return '$prefix${value.toStringAsFixed(decimals)}$suffix';
  }

  String _fmtCurrency(double? value) {
    if (value == null || value == 0) return 'N/A';
    if (value >= 10000000) return '₹${(value / 10000000).toStringAsFixed(2)} Cr';
    if (value >= 100000) return '₹${(value / 100000).toStringAsFixed(2)} L';
    return '₹${value.toStringAsFixed(0)}';
  }

  @override
  Widget build(BuildContext context) {
    final proj = widget.project;
    return Scaffold(
      appBar: AppBar(title: const Text("Project analytics")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(proj.projectName, style: Theme.of(context).textTheme.headlineMedium),
                      Text("Tourism Investment", style: TextStyle(color: Theme.of(context).colorScheme.secondary, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                StageBadge(stage: proj.stage),
              ],
            ),
            const SizedBox(height: 24),

            _sectionHeader(context, "Investment Metrics"),
            const SizedBox(height: 12),
            _analyticsCard([
              _analyticRow("Expected ROI", _fmt(proj.expectedROI, suffix: '%'), Icons.trending_up, Colors.green),
              _analyticRow("Rental Yield", _fmt(proj.rentalYield, suffix: '%'), Icons.home_work_outlined, Colors.blue),
              _analyticRow("Proj. Annual Income", _fmtCurrency(proj.projectedAnnualIncome), Icons.payments_outlined, Colors.teal),
              _analyticRow("Break-even Period", _fmt(proj.breakEvenYears, suffix: ' yrs'), Icons.timer_outlined, Colors.orange),
              _analyticRow("Capital Appreciation", _fmt(proj.capitalAppreciation, suffix: '%'), Icons.moving, Colors.purple),
            ]),
            const SizedBox(height: 32),

            _sectionHeader(context, "Demand Metrics"),
            const SizedBox(height: 12),
            _analyticsCard([
              _analyticRow("Avg Occupancy", _fmt(proj.averageOccupancy ?? proj.occupancyRate, suffix: '%'), Icons.people_outline, Colors.blue),
              _analyticRow("Peak Occupancy", _fmt(proj.peakOccupancy, suffix: '%'), Icons.groups_outlined, Colors.indigo),
              _analyticRow("Seasonal Demand", proj.seasonalDemand ?? "MEDIUM", Icons.wb_sunny_outlined, Colors.amber),
              _analyticRow("ADR (Avg Daily Rate)", _fmtCurrency(proj.adr), Icons.bed_outlined, Colors.brown),
            ]),
            const SizedBox(height: 32),

            _sectionHeader(context, "Financial Metrics"),
            const SizedBox(height: 12),
            _analyticsCard([
              _analyticRow("Monthly Cash Flow", _fmtCurrency(proj.monthlyCashFlow), Icons.account_balance_wallet_outlined, Colors.green),
              _analyticRow("Net Operating Income", _fmtCurrency(proj.noi), Icons.pie_chart_outline, Colors.deepOrange),
              _analyticRow("IRR", _fmt(proj.expectedIRR, suffix: '%'), Icons.show_chart, Colors.indigo),
            ]),
            const SizedBox(height: 32),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.amber.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.amber.shade200),
              ),
              child: Column(
                children: [
                  const Text(
                    "Disclaimer: Real estate investments carry inherent risks. Projections are based on current market intelligence and historical data.",
                    style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Checkbox(
                        value: _complianceAccepted,
                        onChanged: _eoiSubmitted ? null : (val) => setState(() => _complianceAccepted = val!),
                      ),
                      const Expanded(
                        child: Text("I acknowledge the financial modelling assumptions and risk profile.", style: TextStyle(fontSize: 12)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            if (_eoiSubmitted)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green.shade300),
                ),
                child: Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.green.shade700, size: 24),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'EOI Submitted',
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green.shade700),
                          ),
                          const Text(
                            'This project has been added to your portfolio',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            else
              ElevatedButton(
                onPressed: (_complianceAccepted && !_isSubmitting) ? _submitEOI : null,
                child: _isSubmitting
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Submit Expression of Interest (EOI)'),
              ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _sectionHeader(BuildContext context, String title) {
    return Text(title, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold));
  }

  Widget _analyticsCard(List<Widget> rows) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(children: rows.expand((w) => [w, const Divider(height: 20, thickness: 0.5)]).toList()..removeLast()),
    );
  }

  Widget _analyticRow(String label, String value, IconData icon, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 12),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13)),
        const Spacer(),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
      ],
    );
  }
}
