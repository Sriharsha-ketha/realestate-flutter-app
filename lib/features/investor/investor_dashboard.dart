import 'package:flutter/material.dart';
import 'package:realestate/shared/widgets/summary_card.dart';
import '../../shared/app_state.dart';

class InvestorDashboard extends StatelessWidget {
  const InvestorDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final portfolio = AppState.investorPortfolio;
    final totalInvested = portfolio.fold<double>(
        0, (prev, p) => prev + p.capitalRequired * p.capitalRaised);
    final activeCount = portfolio.length;
    final avgIrr = activeCount == 0
        ? 0
        : portfolio.fold<double>(0, (p, t) => p + t.irr) / activeCount;
    final nextMilestone = activeCount > 0 ? portfolio.first.stage : 'N/A';

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              "Investor Overview",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                SummaryCard(
                    title: "Total Invested",
                    value: "₹${totalInvested.toStringAsFixed(2)}L"),
                const SizedBox(width: 10),
                SummaryCard(title: "Active Projects", value: "$activeCount"),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                SummaryCard(
                    title: "Avg IRR", value: "${avgIrr.toStringAsFixed(1)}%"),
                const SizedBox(width: 10),
                SummaryCard(title: "Next Milestone", value: nextMilestone),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
