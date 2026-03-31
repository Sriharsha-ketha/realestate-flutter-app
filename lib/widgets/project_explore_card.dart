import 'package:flutter/material.dart';
import '../models/project.dart';
import '../shared/widgets/stage_badge.dart';

class ProjectExploreCard extends StatelessWidget {
  final Project project;
  final VoidCallback onTap;

  const ProjectExploreCard({
    super.key,
    required this.project,
    required this.onTap,
  });

  String _fmtMonthly(double? v) {
    if (v == null || v == 0) return '—';
    if (v >= 100000) return '₹${(v / 100000).toStringAsFixed(1)}L/mo';
    return '₹${v.toStringAsFixed(0)}/mo';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12, left: 16, right: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      project.projectName,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                  StageBadge(stage: project.stage),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                project.location,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
              ),
              const SizedBox(height: 16),
              
              // Key Metrics Grid
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _metricItem('ROI', '${project.expectedROI.toStringAsFixed(1)}%'),
                  _metricItem('Yield', '${(project.rentalYield ?? 0).toStringAsFixed(1)}%'),
                  _metricItem('Income', _fmtMonthly(project.estimatedMonthlyIncome)),
                  _metricItem('Occ.', '${project.occupancyRate.toStringAsFixed(0)}%'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _metricItem(String label, String value) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.w500)),
        const SizedBox(height: 2),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black87)),
      ],
    );
  }
}
