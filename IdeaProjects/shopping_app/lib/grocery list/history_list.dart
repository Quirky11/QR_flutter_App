import 'package:flutter/material.dart';

import 'history_item.dart';

class HistoryListView extends StatelessWidget {
  final List<Map<String, dynamic>> history;

  const HistoryListView({
    Key? key,
    required this.history,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: history.length,
      itemBuilder: (ctx, index) {
        final historyEntry = history[index];

        // Debug log to see the current history entry
        print('Rendering history entry: $historyEntry');

        final action = historyEntry['action'] as String? ?? 'Unknown Action';
        final item = historyEntry['item'] as String? ?? 'Unknown Item';
        final timestampValue = historyEntry['timestamp'];

        DateTime timestamp;

        if (timestampValue is String) {
          try {
            timestamp = DateTime.parse(timestampValue);
            print('Parsed timestamp from String: $timestamp'); // Debug log
          } catch (e) {
            print('Failed to parse timestamp: $timestampValue'); // Debug log
            timestamp = DateTime.now(); // Default to current time if parsing fails
          }
        } else if (timestampValue is DateTime) {
          timestamp = timestampValue;
          print('Using DateTime object: $timestamp'); // Debug log
        } else {
          print('Unexpected timestamp type: $timestampValue'); // Debug log
          timestamp = DateTime.now(); // Default to current time if type is unexpected
        }

        // Convert timestamp to local time if needed
        timestamp = timestamp.toLocal();

        return HistoryItemWidget(
          action: action,
          item: item,
          timestamp: timestamp,
        );
      },
    );
  }
}
