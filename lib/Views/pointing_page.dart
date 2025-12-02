import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:magic_table/Model/new_record_popup_vm.dart';
import 'package:magic_table/Model/pointing_header_vm.dart';
import 'package:magic_table/Model/record_list_vm.dart';
import 'package:magic_table/Views/card_style_view.dart';
import 'package:magic_table/Views/pointing_header.dart';
import 'package:magic_table/Views/record_list.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Model/pointing_page_vm.dart';
import 'new_record_popup.dart';

class PointingPage extends StatefulWidget {
  const PointingPage({Key? key}) : super(key: key);

  @override
  State<PointingPage> createState() => _PointingPageState();
}

class _PointingPageState extends State<PointingPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  var viewModel = PointingPageViewModel();
  var isShowOpenedDialog = false;
  final Future<SharedPreferences> prefs = SharedPreferences.getInstance();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void addNewRecord(BuildContext context) {
    Map<String, RoundPoint> map = {};
    for (var element in viewModel.userPoints) {
      map[element.name] = RoundPoint();
    }
    map.values.elementAt(0).isWinner = true;
    final recordPopupVM = NewRecordPopUpViewModel(map.obs, (map) {
      Map<String, int> mapPoint = {};
      for (int i = 0; i < viewModel.userPoints.length; i++) {
        final user = viewModel.userPoints[i];
        int point =
            map[user.name]!.point * (map[user.name]!.isNegative ? -1 : 1);
        mapPoint[user.name] = point;
      }
      viewModel.records.insert(0, mapPoint);
      });
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return NewRecordPopup(recordPopupVM);
        });
  }

  void handleIncrement(int index) {
    var user = viewModel.userPoints[index];
    var newUser = UserPoint(user.name, user.point + 1, user.color);
    viewModel.userPoints.replaceRange(index, index + 1, [newUser]);
  }

  void handleDecrement(int index) {
    var user = viewModel.userPoints[index];
    var newUser = UserPoint(user.name, user.point - 1, user.color);
    viewModel.userPoints.replaceRange(index, index + 1, [newUser]);
  }

  void listenRecordsChanged() {
    viewModel.records.listen((value) async {
      Map<String, int> tmp = {};
      if (value.isNotEmpty) {
        tmp = value.reduce((val, element) {
          Map<String, int> map = {};
          for (var name in val.keys) {
            map[name] = (val[name] ?? 0) + (element[name] ?? 0);
          }
          return map;
        });
      }

      for (int i = 0; i < viewModel.userPoints.length; i++) {
        var user = viewModel.userPoints[i];
        var newUser = UserPoint(user.name, tmp[user.name] ?? 0, user.color);
        viewModel.userPoints.replaceRange(i, i + 1, [newUser]);
      }

      var tPref = await prefs;
      tPref.setString("records", json.encode(viewModel.records));
      tPref.setStringList("users", viewModel.userPoints.map((element) => element.name).toList());

    });
  }

  void showNumberPlayersDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: const Text('Bao nhiêu thằng muốn nộp tiền ????'),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
                backgroundColor: Colors.pink, foregroundColor: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('   3   '),
          ),
          TextButton(
            style: TextButton.styleFrom(
                backgroundColor: Colors.blue, foregroundColor: Colors.white),
            onPressed: () {
              viewModel.addOnePlayer();
              Navigator.pop(context);
            },
            child: const Text('   4   '),
          ),
          TextButton(
            style: TextButton.styleFrom(
                backgroundColor: Colors.green, foregroundColor: Colors.white),
            onPressed: () {
              viewModel.addTwoPlayer();
              Navigator.pop(context);
            },
            child: const Text('   5   '),
          ),
        ],
      ),
    );
  }

  void showContinueDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context2) {
          return CupertinoAlertDialog(
            title: Column(
              children: const <Widget>[
                Text("MAGIC TABLE"),
                Icon(
                  Icons.favorite,
                  color: Colors.red,
                ),
              ],
            ),
            content: const Text("Có game đang chơi dở có muốn tiếp tục ?"),
            actions: <Widget>[
              CupertinoDialogAction(
                child: const Text("Có"),
                onPressed: () async {
                  Navigator.of(context2).pop();
                  var ref = await prefs;
                  viewModel.userPoints.clear();
                  viewModel.userPoints.addAll(ref.getStringList("users")!.map((e) => UserPoint(e, 0, Colors.red)).toList());
                  viewModel.records.clear();
                  List<dynamic> a = jsonDecode(ref.getString("records") ?? "");
                  List<Map<String, int>> b = a.map((e) {
                    var tmp = e as Map<String, dynamic>;
                    var tmp2 = tmp.map((key, value) => MapEntry(key, value as int));
                    return tmp2;
                  }).toList();

                  viewModel.records.addAll(b);

                },
              ),
              CupertinoDialogAction(
                isDestructiveAction: true,
                child: const Text("Không"),
                onPressed: () async {
                  Navigator.of(context2).pop();
                  showNumberPlayersDialog();
                  var ref = await prefs;
                  ref.remove("records");
                  ref.remove("users");
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (isShowOpenedDialog) {
        return;
      }
      isShowOpenedDialog = true;
      listenRecordsChanged();
      var tPref = await prefs;

      var users = tPref.getStringList("users");
      if (users != null) {
        showContinueDialog();
        return;
      }
      showNumberPlayersDialog();
    });

    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Container(
            color: Colors.black,
            child: SafeArea(
              bottom: false,
              child: TabBar(
                controller: _tabController,
                indicatorColor: Colors.blue,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.grey,
                tabs: const [
                  Tab(text: 'Classic'),
                  Tab(text: 'Cards'),
                ],
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Tab 1: Classic view (giao diện cũ)
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Column(
                      children: [
                        PointingHeaderView(
                          PointingHeaderViewModel(viewModel.userPoints, viewModel.records),
                        ),
                        RecordListView(
                          RecordListViewModel(viewModel.records, viewModel.userPoints),
                        )
                      ],
                    ),
                  ),
                ),
                // Tab 2: Card style view (giao diện mới)
                CardStyleView(
                  userPoints: viewModel.userPoints,
                  onIncrement: handleIncrement,
                  onDecrement: handleDecrement,
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: _tabController.index == 0
          ? FloatingActionButton(
              onPressed: () {
                addNewRecord(context);
              },
              tooltip: 'Increment',
              backgroundColor: Colors.red.withOpacity(0.3),
              child: Icon(Icons.add, color: Colors.white.withOpacity(0.5)),
            )
          : null,
    );
  }
}

class UserPoint {
  String name = '';
  int point = 0;
  Color color = Colors.red;

  UserPoint(this.name, this.point, this.color);
}
