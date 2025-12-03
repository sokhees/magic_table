import 'package:flutter/material.dart';
import 'package:magic_table/theme/app_colors.dart';
import 'package:magic_table/theme/app_text_styles.dart';

/// Reusable dialog container widget
class CustomDialog extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData icon;
  final Color iconColor;
  final List<Widget> actions;
  final Widget? content;

  const CustomDialog({
    Key? key,
    required this.title,
    this.subtitle,
    required this.icon,
    this.iconColor = Colors.white,
    required this.actions,
    this.content,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.backgroundMedium,
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: iconColor, size: 48),
            const SizedBox(height: 16),
            Text(title, style: AppTextStyles.titleMedium),
            if (subtitle != null) ...[
              const SizedBox(height: 8),
              Text(subtitle!, style: AppTextStyles.subtitle),
            ],
            if (content != null) ...[
              const SizedBox(height: 16),
              content!,
            ],
            const SizedBox(height: 24),
            ...actions,
          ],
        ),
      ),
    );
  }
}
