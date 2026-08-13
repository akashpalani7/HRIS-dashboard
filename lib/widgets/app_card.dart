import 'package:flutter/material.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double borderRadius;
  final Color? baseColor;

  const AppCard({
    super.key, 
    required this.child, 
    this.padding, 
    this.borderRadius = 10,
    this.baseColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      color: baseColor ?? Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        side: BorderSide(color: Colors.grey.shade200, width: 1),
      ),
      child: Padding(
        padding: padding ?? const EdgeInsets.all(16),
        child: child,
      ),
    );
  }
}
