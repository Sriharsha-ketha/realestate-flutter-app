import 'package:flutter/material.dart';
import '../../../../shared/widgets/stage_badge.dart';
import '../../shared/app_state.dart';

class LandownerDashboard extends StatelessWidget {
  const LandownerDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            "Landowner Overview",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          if (AppState.pendingLands.isNotEmpty) ...[
            const Text(
              'Pending submissions',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            ...AppState.pendingLands.map((land) => Card(
                  child: ListTile(
                    title: Text(land.name),
                    subtitle: Text('Size: ${land.size} acres'),
                    trailing: StageBadge(stage: land.stage),
                  ),
                )),
            const SizedBox(height: 20),
          ],
          if (AppState.approvedLands.isNotEmpty) ...[
            const Text(
              'Approved parcels',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            ...AppState.approvedLands.map((land) => Card(
                  child: ListTile(
                    title: Text(land.name),
                    subtitle: Text('Size: ${land.size} acres'),
                    trailing: StageBadge(stage: land.stage),
                  ),
                )),
          ],
        ],
      ),
    );
  }
}
