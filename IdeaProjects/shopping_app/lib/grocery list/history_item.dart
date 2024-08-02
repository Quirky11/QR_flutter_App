import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HistoryItemWidget extends StatelessWidget {
  final String action;
  final String item;
  final DateTime timestamp;

  const HistoryItemWidget({
    Key? key,
    required this.action,
    required this.item,
    required this.timestamp,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Define your date format
    final dateFormat = DateFormat('yMMMd').add_jm();

    return ListTile(
      title: Text('$action: $item'),
      subtitle: Text('Timestamp: ${dateFormat.format(timestamp)}'),
    );
  }
}
