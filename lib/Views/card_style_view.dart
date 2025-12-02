import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:magic_table/Views/pointing_page.dart';

class CardStyleView extends StatelessWidget {
  final RxList<UserPoint> userPoints;
  final Function(int) onIncrement;
  final Function(int) onDecrement;

  const CardStyleView({
    Key? key,
    required this.userPoints,
    required this.onIncrement,
    required this.onDecrement,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final screenHeight = MediaQuery.of(context).size.height;
      final topPadding = MediaQuery.of(context).padding.top;
      final cardHeight = (screenHeight - topPadding - 48) / userPoints.length - 16;
      
      return Column(
        children: userPoints.asMap().entries.map((entry) {
          final index = entry.key;
          final user = entry.value;
          
          return Container(
            height: cardHeight,
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  _getGradientColor(index, 0.8),
                  _getGradientColor(index, 1.0),
                ],
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  top: 16,
                  left: 16,
                  child: Text(
                    user.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    user.point.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 120,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 16,
                  left: 16,
                  child: IconButton(
                    icon: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.remove,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                    onPressed: () => onDecrement(index),
                  ),
                ),
                Positioned(
                  bottom: 16,
                  right: 16,
                  child: IconButton(
                    icon: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                    onPressed: () => onIncrement(index),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      );
    });
  }

  Color _getGradientColor(int index, double opacity) {
    final colors = [
      Colors.blue,
      Colors.purple,
      Colors.pink,
      Colors.orange,
      Colors.teal,
    ];
    return colors[index % colors.length].withOpacity(opacity);
  }
}
