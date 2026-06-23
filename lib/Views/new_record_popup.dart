import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:magic_table/Model/new_record_popup_vm.dart';
import 'package:magic_table/theme/app_colors.dart';
import 'package:magic_table/theme/app_text_styles.dart';
import 'package:magic_table/widgets/winner_selection_tabs.dart';
import 'package:magic_table/widgets/loser_point_input.dart';
import 'package:magic_table/widgets/gradient_button.dart';

class NewRecordPopup extends StatelessWidget {
  final NewRecordPopUpViewModel viewModel;
  const NewRecordPopup(this.viewModel, {super.key});

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 20),
      decoration: const BoxDecoration(
        color: AppColors.backgroundMedium,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('New Round', style: AppTextStyles.titleMedium),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  Widget _buildWinnerSection() {
    final players = viewModel.records.keys.toList();
    
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('👑 SELECT WINNER', style: AppTextStyles.sectionLabel),
              Obx(() {
                final winnerName = viewModel.getWinnerName();
                final point = winnerName.isEmpty
                    ? 0
                    : viewModel.records[winnerName]!.point;
                return Text(
                  winnerName.isEmpty ? '+ $point' : '$winnerName : + $point',
                  style: const TextStyle(
                    color: Color(0xFF4CAF50),
                    fontSize: 32,
                    fontWeight: FontWeight.w100,
                  ),
                );
              }),
            ],
          ),
          const SizedBox(height: 12),
          WinnerSelectionTabs(
            players: players,
            viewModel: viewModel,
          ),
          const SizedBox(height: 10),
          const Text('😢 ENTER LOST POINTS', style: AppTextStyles.errorLabel),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildLosersSection() {
    final players = viewModel.records.keys.toList();
    
    return Flexible(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Column(
          children: players.map((name) {
            return Obx(() {
              if (viewModel.records[name]!.isWinner) {
                return const SizedBox.shrink();
              }
              
              return LoserPointInput(
                playerName: name,
                record: viewModel.records[name]!,
                controller: viewModel.textViewControllers[name]!,
                onToggleSign: () {
                  viewModel.records[name]!.isNegative = !viewModel.records[name]!.isNegative;
                  viewModel.records[name] = viewModel.records[name]!;
                  viewModel.calculateWinnerPoint();
                },
              );
            });
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildSaveButton(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: GradientButton(
        text: '💾 SAVE ROUND',
        height: 50,
        borderRadius: BorderRadius.circular(25),
        onPressed: () {
          if (!viewModel.isAllZeroValue()) {
            viewModel.callback(viewModel.records);
            Navigator.of(context).pop();
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final maxHeight = mediaQuery.size.height - 
                      mediaQuery.padding.top - 
                      mediaQuery.padding.bottom - 32;
    
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(16),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: maxHeight),
        child: IntrinsicHeight(
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.backgroundDark,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildHeader(context),
                _buildWinnerSection(),
                _buildLosersSection(),
                _buildSaveButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }
}