import 'package:flutter/material.dart';
import 'package:magic_table/theme/app_colors.dart';

/// Reusable gradient icon button widget
class GradientIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final LinearGradient? gradient;
  final double size;
  final Color iconColor;

  const GradientIconButton({
    Key? key,
    required this.icon,
    required this.onPressed,
    this.gradient,
    this.size = 28,
    this.iconColor = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final effectiveGradient = gradient ?? AppColors.primaryGradient;
    final firstColor = effectiveGradient.colors.first;
    
    return Container(
      decoration: BoxDecoration(
        gradient: effectiveGradient,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: firstColor.withOpacity(0.4),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(icon, color: iconColor, size: size),
        onPressed: onPressed,
      ),
    );
  }
}
