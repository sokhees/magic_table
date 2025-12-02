import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class RoundPoint {
  var point = 0;
  bool isWinner = true;
  bool isNegative = true;
  RoundPoint({this.point = 0, this.isWinner = false, this.isNegative = true});
}

class NewRecordPopUpViewModel extends GetxController {
  RxMap<String, RoundPoint> records;
  Map<String, TextEditingController> textViewControllers = {};
  Function(RxMap<String, RoundPoint>) callback;
  NewRecordPopUpViewModel(this.records, this.callback) {
    records.forEach((key, value) {
      var textController = TextEditingController();
      if (value.point != 0) {
        textController.text = value.point.toString();
      }
      textController.addListener(() {
        try {
          records[key] = RoundPoint(
              point: int.parse(textController.text), isWinner: records[key]?.isWinner ?? false, isNegative: records[key]?.isNegative ?? true);
          calculateWinnerPoint();
        } catch (e) {
          records[key] = RoundPoint(point: 0, isNegative: records[key]?.isNegative ?? true);
          if (kDebugMode) {
            print(e);
          }
        }
      });

      textViewControllers[key] = textController;
    });
  }

  String getWinnerName() {
    String winner = '';
    records.forEach((key, value) {
      if (value.isWinner) {
        winner = key;
      }
    });
    return winner;
  }

  void calculateWinnerPoint() {
    String winner = getWinnerName();
    int total = 0;

    records.forEach((key, value) {
      if (!value.isWinner) {
        total += (value.isNegative ? -1 : 1) * value.point;
      }
    });
    int point = total * -1;
    if (winner.isNotEmpty) {
      records[winner] = RoundPoint(point: point < 0 ? point * -1 : point, isNegative: point < 0, isWinner: true);
      textViewControllers[winner]?.text = (point < 0 ? point * -1 : point).toString();
    }
  }

  void resetPointFor(String name) {
    var record = records[name];
    if (record != null) {
      record.point = 0;
      records[name] = record;
    }
    calculateWinnerPoint();
    var textEditViewController = textViewControllers[name];
    textEditViewController?.text = '';
  }

  void setWinner(String name) {
    for (var element in records.keys) {
      records[element]!.isWinner = element == name;
      // The bellow line needed for updating UI
      records[element] = records[element]!;
    }
  }

  bool isAllZeroValue() {
    try {
      var record = records.values.firstWhere((element) => element.point != 0);
      return false;
    } catch(e) {
      return true;
    }
  }

  @override
  void dispose() {
    for (var element in textViewControllers.values) {
      element.dispose();
    }
    super.dispose();
  }
}
