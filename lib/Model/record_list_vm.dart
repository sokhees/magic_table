import 'package:get/get.dart';
import 'package:magic_table/Views/pointing_page.dart';

class RecordListViewModel extends GetxController {
  RxList<Map<String, int>> records = RxList<Map<String, int>>();
  RxList<UserPoint> userPoints;
  RecordListViewModel(this.records, this.userPoints);
}