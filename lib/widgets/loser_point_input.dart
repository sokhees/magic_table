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
          
          // Toggle +/- button
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: record.isNegative ? AppColors.error : AppColors.success,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: Icon(
                record.isNegative ? Icons.remove : Icons.add,
                color: Colors.white,
              ),
              onPressed: onToggleSign,
            ),
          ),
          const SizedBox(width: 12),
          
          // Input field
          Container(
            height: 48,
            width: 60,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: AutoHideKeyboard(
              child: TextField(
                controller: controller,
                textAlign: TextAlign.center,
                keyboardType: const TextInputType.numberWithOptions(
                  signed: false,
                  decimal: false,
                ),
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 8),
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
