import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:magic_table/Model/new_record_popup_vm.dart';
import 'package:magic_table/Model/record_list_vm.dart';
import 'package:magic_table/Views/new_record_popup.dart';
import 'package:magic_table/Views/pointing_page.dart';
import 'package:magic_table/Views/record_list.dart';
import 'package:magic_table/Views/statistics_page.dart';
import 'package:magic_table/theme/app_colors.dart';
import 'package:magic_table/theme/app_text_styles.dart';
import 'package:magic_table/widgets/gradient_icon_button.dart';
import 'package:magic_table/widgets/player_summary_card.dart';

class RecordsPage extends StatelessWidget {
  final RxList<UserPoint> userPoints;
  final RxList<Map<String, int>> records;

  const RecordsPage({
    Key? key,
    required this.userPoints,
    required this.records,
  }) : super(key: key);



  void addNewRecord(BuildContext context) {
    Map<String, RoundPoint> map = {};
    for (var element in userPoints) {
      map[element.name] = RoundPoint();
    }
    map.values.elementAt(0).isWinner = true;
    final recordPopupVM = NewRecordPopUpViewModel(map.obs, (map) {
      Map<String, int> mapPoint = {};
      for (int i = 0; i < userPoints.length; i++) {
        final user = userPoints[i];
        int point =
            map[user.name]!.point * (map[user.name]!.isNegative ? -1 : 1);
        mapPoint[user.name] = point;
      }
      records.insert(0, mapPoint);
    });
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return NewRecordPopup(recordPopupVM);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: SafeArea(
        child: Column(
          children: [
            // Header with back button and title
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Text('Records', style: AppTextStyles.title),
                  const Spacer(),
                  // Statistics button
                  GradientIconButton(
                    icon: Icons.bar_chart,
                    gradient: AppColors.blueGradient,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => StatisticsPage(
                            records: records,
                            userPoints: userPoints,
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 20),
                  // Add button
                  GradientIconButton(
                    icon: Icons.add,
                    onPressed: () => addNewRecord(context),
                  ),
                ],
              ),
            ),
            
            // Player names header with gradient cards
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Obx(() => Row(
                children: userPoints.asMap().entries.map((entry) {
                  final index = entry.key;
                  final player = entry.value;
                  return PlayerSummaryCard(
                    playerName: player.name,
                    totalScore: player.point,
                    colorIndex: index,
                  );
                }).toList(),
              )),
            ),

            // Records list
            Expanded(
              child: RecordListView(
                RecordListViewModel(records, userPoints),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
