import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:magic_table/Model/new_record_popup_vm.dart';
import 'package:magic_table/theme/app_colors.dart';

/// Winner selection tabs widget
class WinnerSelectionTabs extends StatefulWidget {
  final List<String> players;
  final NewRecordPopUpViewModel viewModel;
  final VoidCallback? onWinnerSelected;

  const WinnerSelectionTabs({
    Key? key,
    required this.players,
    required this.viewModel,
    this.onWinnerSelected,
  }) : super(key: key);

  @override
  State<WinnerSelectionTabs> createState() => _WinnerSelectionTabsState();
}

class _WinnerSelectionTabsState extends State<WinnerSelectionTabs> {
  String? _animatingWinner;
  int _shakeTrigger = 0;
  bool _isTransitioning = false;

  Future<void> _handleWinnerTap(String name) async {
    if (_isTransitioning) return;

    setState(() {
      _isTransitioning = true;
      _animatingWinner = name;
      _shakeTrigger++;
    });

    widget.viewModel.setWinner(name);

    await Future.delayed(const Duration(milliseconds: 1000));

    if (!mounted) return;
    setState(() {
      _isTransitioning = false;
    });
    widget.onWinnerSelected?.call();
  }

  Widget _buildWinnerTab(String name, int index, bool isWinner) {
    final isAnimating = _animatingWinner == name;

    return Expanded(
      child: GestureDetector(
        onTap: () => _handleWinnerTap(name),
        child: TweenAnimationBuilder<double>(
          key: ValueKey('$name-$_shakeTrigger'),
          tween: Tween(begin: 0, end: isAnimating ? 1 : 0),
          duration: const Duration(milliseconds: 700),
          curve: Curves.easeOut,
          builder: (context, value, child) {
            final shakeX = isAnimating
                ? math.sin(value * math.pi * 8) * 6 * (1 - value)
                : 0.0;
            final scale = isAnimating ? 1 + (0.04 * math.sin(value * math.pi)) : 1.0;
            return Transform.translate(
              offset: Offset(shakeX, 0),
              child: Transform.scale(
                scale: scale,
                child: child,
              ),
            );
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 280),
            curve: Curves.easeInOut,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              gradient: isWinner ? AppColors.playerGradient(index) : null,
              color: isWinner ? null : AppColors.backgroundLight,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isWinner
                    ? Colors.amberAccent.withOpacity(isAnimating ? 0.95 : 0.45)
                    : Colors.transparent,
                width: isWinner ? (isAnimating ? 3 : 2) : 1,
              ),
              boxShadow: isWinner
                  ? [
                      BoxShadow(
                        color: Colors.amberAccent.withOpacity(isAnimating ? 0.45 : 0.18),
                        blurRadius: isAnimating ? 14 : 8,
                        spreadRadius: isAnimating ? 1 : 0,
                      ),
                    ]
                  : null,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  name.toUpperCase(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: isWinner ? FontWeight.bold : FontWeight.normal,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final totalPlayers = widget.players.length;
      final playersPerRow = 3;
      final numRows = (totalPlayers / playersPerRow).ceil();
      
      return Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.backgroundDarkAlt,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: List.generate(numRows, (rowIndex) {
            final startIndex = rowIndex * playersPerRow;
            final endIndex = (startIndex + playersPerRow).clamp(0, totalPlayers);
            final rowPlayers = widget.players.sublist(startIndex, endIndex);
            
            return Column(
              children: [
                Row(
                  children: rowPlayers
                      .asMap()
                      .entries
                      .map((entry) => _buildWinnerTab(
                            entry.value,
                            startIndex + entry.key,
                            widget.viewModel.records[entry.value]!.isWinner,
                          ))
                      .toList(),
                ),
                if (rowIndex < numRows - 1) const SizedBox(height: 6),
              ],
            );
          }),
        ),
      );
    });
  }
}
