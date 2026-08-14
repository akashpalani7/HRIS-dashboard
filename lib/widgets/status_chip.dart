import 'package:flutter/material.dart';

class StatusChip extends StatelessWidget {
  final String status;
  const StatusChip({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return Text(
      '[$status]',
      style: const TextStyle(fontWeight: FontWeight.normal),
    );
  }
}
