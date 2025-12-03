import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:magic_table/Model/new_record_popup_vm.dart';
import 'package:auto_hide_keyboard/auto_hide_keyboard.dart';

class NewRecordPopup extends StatelessWidget {
  final NewRecordPopUpViewModel viewModel;
  const NewRecordPopup(this.viewModel, {super.key});

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

  @override
  Widget build(BuildContext context) {
    final players = viewModel.records.keys.toList();
    final mediaQuery = MediaQuery.of(context);
    final maxHeight = mediaQuery.size.height - mediaQuery.padding.top - mediaQuery.padding.bottom - 32;
    
    // Create FocusNodes for each loser TextField
    final focusNodes = <String, FocusNode>{};
    final loserPlayers = players.where((name) => !viewModel.records[name]!.isWinner).toList();
    for (var name in loserPlayers) {
      focusNodes[name] = FocusNode();
    }
    
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(16),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: maxHeight),
        child: IntrinsicHeight(
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF1a1a1a),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
              // Header
              Container(
                padding: const EdgeInsets.only(left: 20),
                decoration: const BoxDecoration(
                  color: Color(0xFF2a2a2a),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'New Round',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),
          
              // Winner Section - Fixed (not scrollable)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '👑 SELECT WINNER',
                      style: TextStyle(
                        color: Color(0xFFffd700),
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 12),
                    
                    // Winner Tabs
                    Obx(() {
                      final totalPlayers = players.length;
                      final needsTwoRows = totalPlayers > 5;
                      
                      if (needsTwoRows) {
                        // Split into 2 rows
                        final firstRowCount = (totalPlayers / 2).ceil();
                        final firstRowPlayers = players.sublist(0, firstRowCount);
                        final secondRowPlayers = players.sublist(firstRowCount);
                        
                        return Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2a2a3e),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            children: [
                              // First row
                              Row(
                                children: firstRowPlayers.asMap().entries.map((entry) {
                                  final originalIndex = entry.key;
                                  final name = entry.value;
                                  final isWinner = viewModel.records[name]!.isWinner;
                                  
                                  return Expanded(
                                    child: GestureDetector(
                                      onTap: () => viewModel.setWinner(name),
                                      child: Container(
                                        margin: const EdgeInsets.symmetric(horizontal: 2),
                                        padding: const EdgeInsets.symmetric(vertical: 10),
                                        decoration: BoxDecoration(
                                          gradient: isWinner
                                              ? LinearGradient(
                                                  colors: [
                                                    _getGradientColor(originalIndex, 0.8),
                                                    _getGradientColor(originalIndex, 1.0),
                                                  ],
                                                )
                                              : null,
                                          color: isWinner ? null : const Color(0xFF3a3a4e),
                                          borderRadius: BorderRadius.circular(12),
                                          border: isWinner
                                              ? Border.all(color: Colors.white.withOpacity(0.3), width: 2)
                                              : null,
                                        ),
                                        child: Column(
                                          children: [
                                            Padding(
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
                                            if (isWinner) ...[
                                              const SizedBox(height: 4),
                                              const Text(
                                                '🎯',
                                                style: TextStyle(fontSize: 20),
                                              ),
                                            ],
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                              const SizedBox(height: 6),
                              // Second row
                              Row(
                                children: secondRowPlayers.asMap().entries.map((entry) {
                                  final originalIndex = firstRowCount + entry.key;
                                  final name = entry.value;
                                  final isWinner = viewModel.records[name]!.isWinner;
                                  
                                  return Expanded(
                                    child: GestureDetector(
                                      onTap: () => viewModel.setWinner(name),
                                      child: Container(
                                        margin: const EdgeInsets.symmetric(horizontal: 2),
                                        padding: const EdgeInsets.symmetric(vertical: 10),
                                        decoration: BoxDecoration(
                                          gradient: isWinner
                                              ? LinearGradient(
                                                  colors: [
                                                    _getGradientColor(originalIndex, 0.8),
                                                    _getGradientColor(originalIndex, 1.0),
                                                  ],
                                                )
                                              : null,
                                          color: isWinner ? null : const Color(0xFF3a3a4e),
                                          borderRadius: BorderRadius.circular(12),
                                          border: isWinner
                                              ? Border.all(color: Colors.white.withOpacity(0.3), width: 2)
                                              : null,
                                        ),
                                        child: Column(
                                          children: [
                                            Padding(
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
                                            if (isWinner) ...[
                                              const SizedBox(height: 4),
                                              const Text(
                                                '🎯',
                                                style: TextStyle(fontSize: 20),
                                              ),
                                            ],
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                              const SizedBox(height: 6),
                              Builder(
                                builder: (context) {
                                  final winnerName = viewModel.getWinnerName();
                                  if (winnerName.isEmpty) {
                                    return const Text(
                                      '💰 Will receive:   0  pts',
                                      style: TextStyle(
                                        color: Color(0xFF4caf50),
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
                                      color: (isNegative && pointValue != 0) ? const Color(0xFFff6b6b) : const Color(0xFF4caf50),
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        );
                      } else {
                        // Single row for 5 or fewer players
                        return Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2a2a3e),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: players.asMap().entries.map((entry) {
                                  final index = entry.key;
                                  final name = entry.value;
                                  final isWinner = viewModel.records[name]!.isWinner;
                                  
                                  return Expanded(
                                    child: GestureDetector(
                                      onTap: () => viewModel.setWinner(name),
                                      child: Container(
                                        margin: const EdgeInsets.symmetric(horizontal: 2),
                                        padding: const EdgeInsets.symmetric(vertical: 10),
                                        decoration: BoxDecoration(
                                          gradient: isWinner
                                              ? LinearGradient(
                                                  colors: [
                                                    _getGradientColor(index, 0.8),
                                                    _getGradientColor(index, 1.0),
                                                  ],
                                                )
                                              : null,
                                          color: isWinner ? null : const Color(0xFF3a3a4e),
                                          borderRadius: BorderRadius.circular(12),
                                          border: isWinner
                                              ? Border.all(color: Colors.white.withOpacity(0.3), width: 2)
                                              : null,
                                        ),
                                        child: Column(
                                          children: [
                                            Padding(
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
                                            if (isWinner) ...[
                                              const SizedBox(height: 4),
                                              const Text(
                                                '🎯',
                                                style: TextStyle(fontSize: 20),
                                              ),
                                            ],
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                              const SizedBox(height: 6),
                              Builder(
                                builder: (context) {
                                  final winnerName = viewModel.getWinnerName();
                                  if (winnerName.isEmpty) {
                                    return const Text(
                                      '💰 Will receive:   0  pts',
                                      style: TextStyle(
                                        color: Color(0xFF4caf50),
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
                                      color: (isNegative && pointValue != 0) ? const Color(0xFFff6b6b) : const Color(0xFF4caf50),
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        );
                      }
                    }),
          
                    const SizedBox(height: 10),
          
                    // Losers Section Title
                    const Text(
                      '😢 ENTER LOST POINTS',
                      style: TextStyle(
                        color: Color(0xFFff6b6b),
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
          
              // Losers List - Scrollable
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Column(
                    children: players.asMap().entries.map((entry) {
                      final name = entry.value;
                      
                      return Obx(() {
                        if (viewModel.records[name]!.isWinner) {
                          return const SizedBox.shrink();
                        }
                        
                        // Get current index in loser players list
                        final loserPlayers = players.where((n) => !viewModel.records[n]!.isWinner).toList();
                        final loserIndex = loserPlayers.indexOf(name);
                        final isLastLoser = loserIndex == loserPlayers.length - 1;
                        
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2a2a2a),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: const Color(0xFF4a4a4a),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: 100,
                                child: Text(
                                  name.toUpperCase(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Expanded(child: Container(),),
                              // Toggle +/- button
                              Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: viewModel.records[name]!.isNegative 
                                      ? const Color(0xFFff6b6b)
                                      : const Color(0xFF4caf50),
                                  shape: BoxShape.circle,
                                ),
                                child: IconButton(
                                  icon: Icon(
                                    viewModel.records[name]!.isNegative 
                                        ? Icons.remove 
                                        : Icons.add,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    viewModel.records[name]!.isNegative = !viewModel.records[name]!.isNegative;
                                    viewModel.records[name] = viewModel.records[name]!;
                                    viewModel.calculateWinnerPoint();
                                  },
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
                                    controller: viewModel.textViewControllers[name]!,
                                    // focusNode: focusNodes[name],
                                    textAlign: TextAlign.center,
                                    keyboardType: const TextInputType.numberWithOptions(signed: false, decimal: false),
                                    // textInputAction: TextInputAction.done,
                                    // onSubmitted: (_) {
                                    //   focusNodes[name]?.unfocus();
                                    // },
                                    // onTapOutside: (event) =>  focusNodes[name]?.unfocus(),
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
                      });
                    }).toList(),
                  ),
                ),
              ),
          
              // Save Button
              Container(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      if (!viewModel.isAllZeroValue()) {
                        viewModel.callback(viewModel.records);
                        Navigator.of(context).pop();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: Ink(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                        ),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Container(
                        alignment: Alignment.center,
                        child: const Text(
                          '💾 SAVE ROUND',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
          ),
    );
  }
}