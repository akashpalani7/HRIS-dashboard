import 'package:flutter/material.dart';
import 'app_button.dart';

/// Problem 2 only asked us to build ONE feature (Leave Management). These
/// cards represent the other 4 HRIS modules from the Problem 1 design so the
/// dashboard still reads as a complete product, without pretending they're
/// functional.
class ModulePlaceholderCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final String subtitle;
  final Widget? destination;

  const ModulePlaceholderCard({
    super.key,
    required this.title,
    required this.icon,
    this.subtitle = 'Not built in this demo',
    this.destination,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: AppButton(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        onPressed: destination != null 
          ? () => Navigator.push(context, MaterialPageRoute(builder: (_) => destination!))
          : null,
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF5A72A0)),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF333333))),
                  const SizedBox(height: 2),
                  Text(destination != null ? 'Tap to open module' : subtitle, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        )
      ),
    );
  }
}
