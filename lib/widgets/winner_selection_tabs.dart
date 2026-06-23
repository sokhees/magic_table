import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:magic_table/Model/new_record_popup_vm.dart';
import 'package:magic_table/theme/app_colors.dart';

/// Winner selection tabs widget
class WinnerSelectionTabs extends StatelessWidget {
  final List<String> players;
  final NewRecordPopUpViewModel viewModel;

  const WinnerSelectionTabs({
    Key? key,
    required this.players,
    required this.viewModel,
  }) : super(key: key);

  Widget _buildWinnerTab(String name, int index, bool isWinner) {
    return Expanded(
      child: GestureDetector(
        onTap: () => viewModel.setWinner(name),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 2),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            gradient: isWinner ? AppColors.playerGradient(index) : null,
            color: isWinner ? null : AppColors.backgroundLight,
            borderRadius: BorderRadius.circular(12),
            border: isWinner
                ? Border.all(color: Colors.white.withOpacity(0.3), width: 2)
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
    );
  }

  Widget _buildWinnerPointsDisplay() {
    return Builder(
      builder: (context) {
        final winnerName = viewModel.getWinnerName();
        if (winnerName.isEmpty) {
          return const Text(
            '💰 Will receive:   0  pts',
            style: TextStyle(
              color: AppColors.success,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          );
        }
        final winnerRecord = viewModel.records[winnerName]!;
        final isNegative = winnerRecord.isNegative;
        final pointValue = winnerRecord.point;
        final sign = (isNegative && pointValue != 0) ? '-' : '+';
        
        return Text(
          '💰 Will receive:   $sign$pointValue  pts',
          style: TextStyle(
            color: (isNegative && pointValue != 0) ? AppColors.error : AppColors.success,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final totalPlayers = players.length;
      final needsTwoRows = totalPlayers > 5;
      
      return Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.backgroundDarkAlt,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            if (needsTwoRows) ...[
              // First row
              Row(
                children: players
                    .sublist(0, (totalPlayers / 2).ceil())
                    .asMap()
                    .entries
                    .map((entry) => _buildWinnerTab(
                          entry.value,
                          entry.key,
                          viewModel.records[entry.value]!.isWinner,
                        ))
                    .toList(),
              ),
              const SizedBox(height: 6),
              // Second row
              Row(
                children: players
                    .sublist((totalPlayers / 2).ceil())
                    .asMap()
                    .entries
                    .map((entry) => _buildWinnerTab(
                          entry.value,
                          (totalPlayers / 2).ceil() + entry.key,
                          viewModel.records[entry.value]!.isWinner,
                        ))
                    .toList(),
              ),
            ] else
              // Single row
              Row(
                children: players
                    .asMap()
                    .entries
                    .map((entry) => _buildWinnerTab(
                          entry.value,
                          entry.key,
                          viewModel.records[entry.value]!.isWinner,
                        ))
                    .toList(),
              ),
          ],
        ),
      );
    });
  }
}
