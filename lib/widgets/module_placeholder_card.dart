import 'package:flutter/material.dart';

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
    return Card(
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        subtitle: Text(destination != null ? 'Tap to open module' : subtitle),
        trailing: const Icon(Icons.arrow_forward),
        onTap: destination != null 
          ? () => Navigator.push(context, MaterialPageRoute(builder: (_) => destination!))
          : null,
      ),
    );
  }
}
