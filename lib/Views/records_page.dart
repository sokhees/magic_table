import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:magic_table/Model/new_record_popup_vm.dart';
import 'package:magic_table/Model/record_list_vm.dart';
import 'package:magic_table/Views/new_record_popup.dart';
import 'package:magic_table/Views/pointing_page.dart';
import 'package:magic_table/Views/record_list.dart';
import 'package:magic_table/Views/statistics_page.dart';

class RecordsPage extends StatelessWidget {
  final RxList<UserPoint> userPoints;
  final RxList<Map<String, int>> records;

  const RecordsPage({
    Key? key,
    required this.userPoints,
    required this.records,
  }) : super(key: key);

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
      backgroundColor: const Color(0xFF1a1a1a),
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
                  const Text(
                    'Records',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  // Statistics button
                  Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF6a11cb), Color(0xFF2575fc)],
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF6a11cb).withOpacity(0.4),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.bar_chart, color: Colors.white, size: 28),
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
                  ),
                  const SizedBox(width: 20),
                  // Add button
                  Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF667eea).withOpacity(0.4),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.add, color: Colors.white, size: 28),
                      onPressed: () => addNewRecord(context),
                    ),
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
                  return Expanded(
                    child: Container(
                      height: 80,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            _getGradientColor(index, 0.8),
                            _getGradientColor(index, 1.0),
                          ],
                        ),
                        border: Border.all(
                          color: Colors.black.withOpacity(0.2),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: _getGradientColor(index, 0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final name = player.name.toUpperCase();
                          double fontSize = 14.0;
                          
                          // Keep reducing font size until text fits
                          while (fontSize > 8.0) {
                            final textPainter = TextPainter(
                              text: TextSpan(
                                text: name,
                                style: TextStyle(
                                  fontSize: fontSize,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              maxLines: 1,
                              textDirection: TextDirection.ltr,
                            )..layout();
                            
                            if (textPainter.width <= constraints.maxWidth) {
                              break;
                            }
                            fontSize -= 1.0;
                          }
                          
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  name,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: fontSize,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                player.point.toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
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
