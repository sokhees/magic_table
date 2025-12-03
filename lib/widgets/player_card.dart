import 'package:flutter/material.dart';
import 'package:magic_table/theme/app_colors.dart';
import 'package:magic_table/theme/app_text_styles.dart';

/// Player card widget for main screen
class PlayerCard extends StatelessWidget {
  final String playerName;
  final int score;
  final int? latestRecord;
  final int colorIndex;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const PlayerCard({
    Key? key,
    required this.playerName,
    required this.score,
    this.latestRecord,
    required this.colorIndex,
    this.onTap,
    this.onLongPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: AppColors.playerGradient(colorIndex),
        ),
        child: Stack(
          children: [
            // Player name (top left)
            Positioned(
              top: 16,
              left: 16,
              child: Text(playerName, style: AppTextStyles.playerName),
            ),
            // Score (center)
            Center(
              child: Text(score.toString(), style: AppTextStyles.largeScore),
            ),
            // Latest record (bottom right)
            if (latestRecord != null)
              Positioned(
                bottom: 16,
                right: 16,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    latestRecord! >= 0 ? '+$latestRecord' : '$latestRecord',
                    style: AppTextStyles.smallScore,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
