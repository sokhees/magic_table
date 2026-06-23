import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:magic_table/Model/new_record_popup_vm.dart';
import 'package:magic_table/theme/app_colors.dart';
import 'package:magic_table/widgets/winner_selection_tabs.dart';
import 'package:magic_table/widgets/loser_point_input.dart';
import 'package:magic_table/widgets/gradient_button.dart';

class NewRecordPopup extends StatefulWidget {
  final NewRecordPopUpViewModel viewModel;
  const NewRecordPopup(this.viewModel, {super.key});

  @override
  State<NewRecordPopup> createState() => _NewRecordPopupState();
}

class _NewRecordPopupState extends State<NewRecordPopup> {
  int _currentStep = 1;

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
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
          _currentStep == 1
              ? const Text(
                  '👑 SELECT WINNER',
                  style: TextStyle(
                    color: Color(0xFFffd700),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                )
              : const Text(
                  '😢 ENTER LOST POINTS',
                  style: TextStyle(
                    color: Color(0xFFFF6B6B),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  Widget _buildStep1Content() {
    final players = widget.viewModel.records.keys.toList();
    
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
      child: WinnerSelectionTabs(
        players: players,
        viewModel: widget.viewModel,
        onWinnerSelected: () {
          setState(() {
            _currentStep = 2;
          });
        },
      ),
    );
  }

  Widget _buildStep2Content() {
    final players = widget.viewModel.records.keys.toList();
    
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(() {
                final winnerName = widget.viewModel.getWinnerName();
                final winnerRecord = winnerName.isEmpty
                    ? null
                    : widget.viewModel.records[winnerName];
                final point = winnerRecord?.point ?? 0;
                final isNegative = winnerRecord?.isNegative ?? false;
                final sign = isNegative ? '-' : '+';
                return Row(
                  children: [
                    Text(
                      '🏆 ${winnerName.toUpperCase()}   ',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '$sign $point PTS',
                      style: TextStyle(
                        color: isNegative
                            ? AppColors.error
                            : const Color(0xFF4CAF50),
                        fontSize: 20,
                        fontWeight: FontWeight.w100,
                      ),
                    ),
                  ],
                );
              }),
              const SizedBox(height: 12),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Flexible(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              children: players.map((name) {
                return Obx(() {
                  if (widget.viewModel.records[name]!.isWinner) {
                    return const SizedBox.shrink();
                  }
                  
                  return LoserPointInput(
                    playerName: name,
                    record: widget.viewModel.records[name]!,
                    controller: widget.viewModel.textViewControllers[name]!,
                    onToggleSign: () {
                      widget.viewModel.records[name]!.isNegative =
                          !widget.viewModel.records[name]!.isNegative;
                      widget.viewModel.records[name] =
                          widget.viewModel.records[name]!;
                      widget.viewModel.calculateWinnerPoint();
                    },
                  );
                });
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomActions() {
    if (_currentStep == 1) {
      return const SizedBox.shrink();
    } else {
      return Container(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 50,
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      _currentStep = 1;
                    });
                  },
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                      side: const BorderSide(color: Colors.white30),
                    ),
                  ),
                  child: const Text(
                    '← BACK',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: GradientButton(
                text: '💾 SAVE',
                height: 50,
                borderRadius: BorderRadius.circular(25),
                onPressed: () {
                  if (!widget.viewModel.isAllZeroValue()) {
                    widget.viewModel.callback(widget.viewModel.records);
                    Navigator.of(context).pop();
                  }
                },
              ),
            ),
          ],
        ),
      );
    }
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
                if (_currentStep == 1) _buildStep1Content(),
                if (_currentStep == 2)
                  Expanded(
                    child: _buildStep2Content(),
                  ),
                _buildBottomActions(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}