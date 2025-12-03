import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:magic_table/Views/pointing_page.dart';
import 'package:magic_table/widgets/player_card.dart';

class CardStyleView extends StatelessWidget {
  final RxList<UserPoint> userPoints;
  final RxList<Map<String, int>> records;
  final Function(int) onIncrement;
  final Function(int) onDecrement;
  final Function(int) onCardTap;
  final Function(int) onLongPress;

  const CardStyleView({
    Key? key,
    required this.userPoints,
    required this.records,
    required this.onIncrement,
    required this.onDecrement,
    required this.onCardTap,
    required this.onLongPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Calculate available height
      final screenHeight = MediaQuery.of(context).size.height;
      final statusBarHeight = MediaQuery.of(context).padding.top;
      final bottomPadding = MediaQuery.of(context).padding.bottom;
      final appBarHeight = 56.0; // Standard AppBar height
      
      final availableHeight = screenHeight - appBarHeight - statusBarHeight - bottomPadding;
      
      // Calculate height per card
      final numberOfCards = userPoints.length;
      final totalMargin = numberOfCards * 16.0; // 8px top + 8px bottom per card
      final calculatedHeight = (availableHeight - totalMargin) / numberOfCards;
      
      // Check if we need minimum height and scrolling
      final needsMinHeight = calculatedHeight < 120;
      final cardHeight = needsMinHeight ? 120.0 : calculatedHeight;
      
      // Build card list
      final cardsList = userPoints.asMap().entries.map((entry) {
        final index = entry.key;
        final user = entry.value;
        final latestRecord = (records.isNotEmpty && records.first.containsKey(user.name))
            ? records.first[user.name]
            : null;
        
        return Container(
          height: needsMinHeight ? cardHeight : null,
          child: PlayerCard(
            playerName: user.name,
            score: user.point,
            latestRecord: latestRecord,
            colorIndex: index,
            onTap: () => onCardTap(index),
            onLongPress: () => onLongPress(index),
          ),
        );
      }).toList();
      
      // If needs minimum height, use scrollable ListView
      // Otherwise use Column with Expanded to fill space evenly
      if (needsMinHeight) {
        return ListView(
          padding: const EdgeInsets.symmetric(vertical: 8),
          children: cardsList,
        );
      } else {
        return Column(
          children: cardsList.map((card) {
            return Expanded(child: card);
          }).toList(),
        );
      }
    });
  }
}
