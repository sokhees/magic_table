import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:magic_table/Views/pointing_page.dart';

class PointingPageViewModel extends GetxController {
  RxList<UserPoint> userPoints = [
    UserPoint("Lam", 0, Colors.red),
    UserPoint("T.Anh", 0, Colors.red),
    UserPoint("Quyen", 0, Colors.red)
  ].obs;
  
  RxList<Map<String,int>> records = RxList<Map<String,int>>();

  void addOnePlayer() {
    userPoints.add(
      UserPoint("Temp1", 0, Colors.red),
    );
  }

  void addTwoPlayer() {
    userPoints.addAll(
      [UserPoint("Temp1", 0, Colors.red),
      UserPoint("Temp2", 0, Colors.red)]
    );
  }
}
