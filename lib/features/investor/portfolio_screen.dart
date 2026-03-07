import 'package:flutter/material.dart';
import '../../../../shared/widgets/stage_badge.dart';
import '../../shared/app_state.dart';

class PortfolioScreen extends StatelessWidget {
  const PortfolioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            "My Portfolio",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          ...AppState.investorPortfolio.map((proj) => Card(
                child: ListTile(
                  title: Text(proj.title),
                  subtitle: Text(
                      "Invested: ₹${(proj.capitalRequired * proj.capitalRaised).toStringAsFixed(2)}L | IRR: ${proj.irr}%"),
                  trailing: StageBadge(stage: proj.stage),
                ),
              )),
        ],
      ),
    );
  }
}
