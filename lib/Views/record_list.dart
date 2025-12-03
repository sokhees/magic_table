import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:magic_table/Model/new_record_popup_vm.dart';
import 'package:magic_table/Model/record_list_vm.dart';
import 'package:magic_table/Views/new_record_popup.dart';

// ignore: must_be_immutable
class RecordListView extends StatelessWidget {
  RecordListViewModel viewModel;
  RecordListView(this.viewModel, {Key? key}) : super(key: key);

  void showOptionDialog(BuildContext context, int index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF2a2a2a),
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.edit_note,
                    color: Colors.white,
                    size: 48,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Update Record",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Edit button
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.of(context).pop();
                        editRecord(context, index);
                      },
                      icon: const Icon(Icons.edit, color: Colors.white),
                      label: const Text(
                        "Edit",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  // Delete button
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.of(context).pop();
                        showConfirmPopUp(context, index);
                      },
                      icon: const Icon(Icons.delete, color: Colors.white),
                      label: const Text(
                        "Delete",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFff6b6b),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  // Cancel button
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "Cancel",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  void showConfirmPopUp(BuildContext context, int index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF2a2a2a),
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.warning_rounded,
                    color: Color(0xFFff6b6b),
                    size: 48,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Delete Record?",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "This action cannot be undone",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Delete button
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        viewModel.records.removeAt(index);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFff6b6b),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "Delete",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  // Cancel button
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "Cancel",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  void editRecord(BuildContext context, int index) {
    Map<String, RoundPoint> map = {};
    // for (var element in viewModel.re) {
    //   map[element.name] = RoundPoint();
    // }
    viewModel.records[index].forEach((key, value) {
      map[key] = RoundPoint(
          point: value > 0 ? value : value * -1, isNegative: value < 0);
    });
    map.values.first.isWinner = true;
    final recordPopupVM = NewRecordPopUpViewModel(map.obs, (map) {
      viewModel.records.replaceRange(index, index + 1, [
        map.map((key, value) =>
            MapEntry(key, value.point * (value.isNegative ? -1 : 1)))
      ]);
    });
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return NewRecordPopup(recordPopupVM);
        });
  }

  Widget recordWidget(BuildContext context, List<int> record, int recordIndex) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF2a2a2a),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF4a4a4a),
          width: 1,
        ),
      ),
      child: Row(
        children: record.asMap().entries.map((entry) {
          final index = entry.key;
          final value = entry.value;
          final isPositive = value >= 0;
          
          return Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                border: index < record.length - 1
                    ? const Border(
                        right: BorderSide(
                          color: Color(0xFF4a4a4a),
                          width: 1,
                        ),
                      )
                    : null,
              ),
              child: Text(
                value.toString(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isPositive ? const Color.fromARGB(255, 218, 232, 60) : const Color(0xFFff6b6b),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => ListView(
          padding: const EdgeInsets.only(top: 4),
          children: viewModel.records.map((e) {
            var arrayData = viewModel.userPoints
                .map((element) => e[element.name] ?? 0)
                .toList();
            final recordIndex = viewModel.records.indexOf(e);
            return GestureDetector(
                onLongPress: () {
                  showOptionDialog(context, recordIndex);
                },
                child: recordWidget(context, arrayData, recordIndex));
          }).toList(),
        ));
  }
}
