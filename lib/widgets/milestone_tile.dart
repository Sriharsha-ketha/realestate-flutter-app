import 'package:flutter/material.dart';

class MilestoneTile extends StatelessWidget {
  final String title;
  final bool completed;
  final bool inProgress;

  const MilestoneTile({
    super.key,
    required this.title,
    this.completed = false,
    this.inProgress = false,
  });

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    IconData statusIcon;
    
    if (completed) {
      statusColor = Colors.green.shade600;
      statusIcon = Icons.check_circle;
    } else if (inProgress) {
      statusColor = Theme.of(context).colorScheme.secondary;
      statusIcon = Icons.pending_actions;
    } else {
      statusColor = Colors.grey.shade400;
      statusIcon = Icons.radio_button_off;
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: inProgress ? statusColor.withOpacity(0.5) : Colors.grey.shade200,
          width: inProgress ? 2 : 1,
        ),
      ),
      child: ListTile(
        leading: Icon(statusIcon, color: statusColor),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: inProgress ? FontWeight.bold : FontWeight.normal,
            color: completed ? Colors.grey : Colors.black87,
            decoration: completed ? TextDecoration.lineThrough : null,
          ),
        ),
        trailing: completed 
          ? const Icon(Icons.done_all, size: 16, color: Colors.green)
          : null,
      ),
    );
  }
}
