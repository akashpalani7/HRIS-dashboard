import 'package:flutter/material.dart';
import '../models/app_user.dart';
import 'app_card.dart';

class OrgGraphView extends StatelessWidget {
  final List<AppUser> allUsers;
  final Function(AppUser) onUserTap;

  const OrgGraphView({
    super.key,
    required this.allUsers,
    required this.onUserTap,
  });

  @override
  Widget build(BuildContext context) {
    // Find all root nodes (users with no manager, or manager not in list)
    final rootUsers = allUsers.where((u) {
      if (u.managerId == null) return true;
      final hasManager = allUsers.any((m) => m.id == u.managerId);
      return !hasManager;
    }).toList();

    return InteractiveViewer(
      constrained: false,
      boundaryMargin: const EdgeInsets.all(500),
      minScale: 0.1,
      maxScale: 2.0,
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: rootUsers.map((r) => _buildTreeNode(r, isFirst: true, isLast: true, isOnly: true)).toList(),
        ),
      ),
    );
  }

  Widget _buildTreeNode(AppUser user, {required bool isFirst, required bool isLast, required bool isOnly}) {
    final children = allUsers.where((u) => u.managerId == user.id).toList();

    final Widget content = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Parent connection line placeholder
        if (user.managerId != null || !isOnly) 
          const SizedBox(height: 24),
        
        // Node Card
        GestureDetector(
          onTap: () => onUserTap(user),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: AppCard(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              borderRadius: 16,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    radius: 20, 
                    backgroundColor: const Color(0xFF5A72A0), 
                    child: Text(user.name.substring(0, 1), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))
                  ),
                  const SizedBox(height: 8),
                  Text(user.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  const SizedBox(height: 4),
                  Text(user.department ?? 'N/A', style: const TextStyle(color: Colors.grey, fontSize: 10)),
                ],
              )
            ),
          ),
        ),

        // Stem to children
        if (children.isNotEmpty)
          Container(
            width: 2,
            height: 24,
            color: const Color(0xFF5A72A0),
          ),
        
        // Children Row
        if (children.isNotEmpty)
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(children.length, (i) {
              return _buildTreeNode(
                children[i],
                isFirst: i == 0,
                isLast: i == children.length - 1,
                isOnly: children.length == 1,
              );
            }),
          )
      ],
    );

    if (user.managerId == null && isOnly) {
       return content;
    }

    return Stack(
      children: [
        content,
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: 24,
          child: CustomPaint(
            painter: _BranchPainter(isFirst: isFirst, isLast: isLast, isOnly: isOnly),
          ),
        )
      ],
    );
  }
}

class _BranchPainter extends CustomPainter {
  final bool isFirst;
  final bool isLast;
  final bool isOnly;

  _BranchPainter({required this.isFirst, required this.isLast, required this.isOnly});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF5A72A0)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final w = size.width;
    final h = size.height;
    final centerX = w / 2;
    const y = 0.0;

    if (isOnly) {
      canvas.drawLine(Offset(centerX, y), Offset(centerX, h), paint);
    } else if (isFirst) {
      canvas.drawLine(Offset(centerX, y), Offset(w, y), paint);
      canvas.drawLine(Offset(centerX, y), Offset(centerX, h), paint);
    } else if (isLast) {
      canvas.drawLine(Offset(0, y), Offset(centerX, y), paint);
      canvas.drawLine(Offset(centerX, y), Offset(centerX, h), paint);
    } else {
      canvas.drawLine(Offset(0, y), Offset(w, y), paint);
      canvas.drawLine(Offset(centerX, y), Offset(centerX, h), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
