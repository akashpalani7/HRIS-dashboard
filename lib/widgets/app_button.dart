import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final EdgeInsetsGeometry? padding;
  final double borderRadius;
  final Color? baseColor;

  const AppButton({
    super.key, 
    required this.child, 
    required this.onPressed,
    this.padding, 
    this.borderRadius = 10,
    this.baseColor,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: baseColor ?? Colors.grey.shade50,
        foregroundColor: Colors.blueGrey.shade900,
        padding: padding ?? const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius)),
        elevation: 1,
      ),
      child: child,
    );
  }
}
