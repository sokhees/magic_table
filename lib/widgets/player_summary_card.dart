import 'package:flutter/material.dart';
import 'package:magic_table/theme/app_colors.dart';

/// Player summary header card (for records page)
class PlayerSummaryCard extends StatelessWidget {
  final String playerName;
  final int totalScore;
  final int colorIndex;

  const PlayerSummaryCard({
    Key? key,
    required this.playerName,
    required this.totalScore,
    required this.colorIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 80,
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          gradient: AppColors.playerGradient(colorIndex),
          border: Border.all(
            color: Colors.black.withOpacity(0.2),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.getPlayerColor(colorIndex, 0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final name = playerName.toUpperCase();
            double fontSize = 14.0;
            
            // Keep reducing font size until text fits
            while (fontSize > 8.0) {
              final textPainter = TextPainter(
                text: TextSpan(
                  text: name,
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                maxLines: 1,
                textDirection: TextDirection.ltr,
              )..layout();
              
              if (textPainter.width <= constraints.maxWidth) {
                break;
              }
              fontSize -= 1.0;
            }
            
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    name,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: fontSize,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  totalScore.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
