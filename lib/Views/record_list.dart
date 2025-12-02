import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:magic_table/Model/new_record_popup_vm.dart';
import 'package:magic_table/Model/record_list_vm.dart';
import 'package:magic_table/Views/new_record_popup.dart';

class RecordListView extends StatelessWidget {
  RecordListViewModel viewModel;
  RecordListView(this.viewModel, {Key? key}) : super(key: key);

  void showOptionDialog(BuildContext context, int index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Column(
              children: const <Widget>[
                Text("Updating"),
                Icon(
                  Icons.favorite,
                  color: Colors.red,
                ),
              ],
            ),
            content: const Text("Select your choice:"),
            actions: <Widget>[
              CupertinoDialogAction(
                child: const Text("Edit"),
                onPressed: () {
                  Navigator.of(context).pop();
                  editRecord(context, index);
                },
              ),
              CupertinoDialogAction(
                isDestructiveAction: true,
                child: const Text("Delete"),
                onPressed: () {
                  Navigator.of(context).pop();
                  showConfirmPopUp(context, index);
                },
              ),
              CupertinoDialogAction(
                child: const Text("Cancel"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  void showConfirmPopUp(BuildContext context, int index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: const Text("Warning!!" , style: TextStyle(color: Colors.red),),
            content: const Text("Are you want to delete the record.?"),
            actions: <Widget>[
              CupertinoDialogAction(
                isDestructiveAction: true,
                child: const Text("Delete"),
                onPressed: () {
                  Navigator.of(context).pop();
                  viewModel.records.removeAt(index);
                },
              ),
              CupertinoDialogAction(
                child: const Text("Cancel"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
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

  Widget recordWidget(BuildContext context, List<int> record) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 1),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: record
              .map((e) => Expanded(
                      child: Container(
                    height: 50,
                    color: Colors.amber[500],
                    child: Row(
                      children: [
                        Expanded(
                          child: Center(
                              child: Text(
                            e.toString(),
                            style: const TextStyle(
                                color: Colors.white, fontSize: 18),
                          )),
                        ),
                        Container(height: 50, width: 1, color: Colors.black26)
                      ],
                    ),
                  )))
              .toList()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Expanded(
            child: ListView(
          padding: const EdgeInsets.only(top: 10),
          children: viewModel.records.map((e) {
            var arrayData = viewModel.userPoints
                .map((element) => e[element.name] ?? 0)
                .toList();
            return GestureDetector(
                onLongPress: () {
                  showOptionDialog(context, viewModel.records.indexOf(e));
                },
                child: recordWidget(context, arrayData));
          }).toList(),
        )));
  }
}
