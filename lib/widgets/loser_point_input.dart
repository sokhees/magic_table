import 'package:flutter/material.dart';
import 'package:auto_hide_keyboard/auto_hide_keyboard.dart';
import 'package:magic_table/Model/new_record_popup_vm.dart';
import 'package:magic_table/theme/app_colors.dart';
import 'package:magic_table/theme/app_text_styles.dart';

/// Loser point input row widget
class LoserPointInput extends StatelessWidget {
  final String playerName;
  final RoundPoint record;
  final TextEditingController controller;
  final VoidCallback onToggleSign;

  const LoserPointInput({
    Key? key,
    required this.playerName,
    required this.record,
    required this.controller,
    required this.onToggleSign,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.backgroundMedium,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderColor, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Player name
          SizedBox(
            width: 100,
            child: Text(
              playerName.toUpperCase(),
              style: AppTextStyles.bodyLarge,
            ),
          ),
          const Spacer(),
          
          // Segmented +/- toggle
          AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutCubic,
            width: 100,
            height: 52,
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: record.isNegative
                    ? AppColors.error.withOpacity(0.8)
                    : AppColors.success.withOpacity(0.8),
                width: 1.4,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _SignSegment(
                    label: '-',
                    isActive: record.isNegative,
                    activeColor: AppColors.error,
                    onTap: () {
                      if (!record.isNegative) {
                        onToggleSign();
                      }
                    },
                  ),
                ),
                const SizedBox(width: 3),
                Expanded(
                  child: _SignSegment(
                    label: '+',
                    isActive: !record.isNegative,
                    activeColor: AppColors.success,
                    onTap: () {
                      if (record.isNegative) {
                        onToggleSign();
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          
          // Input field
          Container(
            height: 52,
            width: 60,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: record.isNegative
                    ? AppColors.error.withOpacity(0.9)
                    : AppColors.success.withOpacity(0.9),
                width: 2.2,
              ),
            ),
            child: AutoHideKeyboard(
              child: TextField(
                controller: controller,
                textAlign: TextAlign.center,
                textAlignVertical: TextAlignVertical.center,
                keyboardType: const TextInputType.numberWithOptions(
                  signed: false,
                  decimal: false,
                ),
                style: const TextStyle(
                  fontSize: 29,
                  fontWeight: FontWeight.w100,
                  color: Colors.black,
                ),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
        ],
      ),
    );
  }
}

class _SignSegment extends StatelessWidget {
  final String label;
  final bool isActive;
  final Color activeColor;
  final VoidCallback onTap;

  const _SignSegment({
    required this.label,
    required this.isActive,
    required this.activeColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: AnimatedScale(
          scale: isActive ? 1.0 : 0.95,
          duration: const Duration(milliseconds: 260),
          curve: Curves.elasticOut,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutCubic,
            decoration: BoxDecoration(
              color: isActive ? activeColor : Colors.transparent,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isActive
                    ? Colors.white.withOpacity(0.28)
                    : Colors.white.withOpacity(0.12),
              ),
              boxShadow: isActive
                  ? [
                      BoxShadow(
                        color: activeColor.withOpacity(0.48),
                        blurRadius: 10,
                        spreadRadius: 0.8,
                      ),
                    ]
                  : null,
            ),
            alignment: Alignment.center,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontSize: 34,
                fontWeight: FontWeight.w700,
                height: 1,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
