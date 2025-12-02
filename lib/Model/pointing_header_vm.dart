import 'package:get/get.dart';
import 'package:magic_table/Views/pointing_page.dart';

class PointingHeaderViewModel extends GetxController {
  RxList<UserPoint> userPoints;
  RxList<Map<String, int>> records = RxList<Map<String, int>>();
  PointingHeaderViewModel(this.userPoints, this.records);

  void updatePoints(List<UserPoint> list) {
    userPoints = list.obs;
  }
}
