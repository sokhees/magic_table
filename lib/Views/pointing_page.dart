import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:magic_table/Model/new_record_popup_vm.dart';
import 'package:magic_table/Views/card_style_view.dart';
import 'package:magic_table/Views/records_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Model/pointing_page_vm.dart';
import 'new_record_popup.dart';

class PointingPage extends StatefulWidget {
  const PointingPage({Key? key}) : super(key: key);

  @override
  State<PointingPage> createState() => _PointingPageState();
}

class _PointingPageState extends State<PointingPage> {
  var viewModel = PointingPageViewModel();
  var isShowOpenedDialog = false;
  final Future<SharedPreferences> prefs = SharedPreferences.getInstance();

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

  void handleCardTap(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RecordsPage(
          userPoints: viewModel.userPoints,
          records: viewModel.records,
        ),
      ),
    );
  }

  void handleLongPress(int index) {
    final user = viewModel.userPoints[index];
    final controller = TextEditingController(text: user.name);
    
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
                  Icons.edit,
                  color: Colors.white,
                  size: 48,
                ),
                const SizedBox(height: 16),
                const Text(
                  "Edit Player Name",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                
                // Text field
                TextField(
                  controller: controller,
                  autofocus: true,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xFF1a1a1a),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                
                // Save button
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      final newName = controller.text.trim();
                      if (newName.isNotEmpty) {
                        // Update user name
                        final updatedUser = UserPoint(
                          newName,
                          user.point,
                          user.color,
                        );
                        viewModel.userPoints.replaceRange(
                          index,
                          index + 1,
                          [updatedUser],
                        );
                        
                        // Update records with new name
                        for (var record in viewModel.records) {
                          if (record.containsKey(user.name)) {
                            final value = record[user.name]!;
                            record.remove(user.name);
                            record[newName] = value;
                          }
                        }
                      }
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Ink(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Container(
                        alignment: Alignment.center,
                        child: const Text(
                          "Save",
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
      },
    );
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

  Future<void> loadSavedPlayerNames(int playerCount) async {
    final tPref = await prefs;
    final savedNames = tPref.getStringList("default_player_names");
    
    if (savedNames != null && savedNames.isNotEmpty) {
      // Use saved names up to playerCount
      for (int i = 0; i < viewModel.userPoints.length && i < savedNames.length; i++) {
        final user = viewModel.userPoints[i];
        final updatedUser = UserPoint(savedNames[i], user.point, user.color);
        viewModel.userPoints.replaceRange(i, i + 1, [updatedUser]);
      }
      
      // Save to current users list
      await tPref.setStringList(
        "users",
        viewModel.userPoints.map((e) => e.name).toList(),
      );
    }
  }

  void showNumberPlayersDialog() {
    int selectedPlayerCount = 4; // Mặc định là 4
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF2a2a2a),
                borderRadius: BorderRadius.circular(24),
              ),
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Icon
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.people,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // Title
                  const Text(
                    'Lựa chọn số người chơi?',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  
                  // Player count selector with +/-
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Minus button
                      Container(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFff6b6b), Color(0xFFff5252)],
                          ),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFff6b6b).withOpacity(0.4),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.remove, color: Colors.white, size: 28),
                          onPressed: selectedPlayerCount > 2 
                              ? () {
                                  setState(() {
                                    selectedPlayerCount--;
                                  });
                                }
                              : null,
                        ),
                      ),
                      
                      const SizedBox(width: 32),
                      
                      // Number display
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF667eea).withOpacity(0.4),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            selectedPlayerCount.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      
                      const SizedBox(width: 32),
                      
                      // Plus button
                      Container(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF4caf50), Color(0xFF66bb6a)],
                          ),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF4caf50).withOpacity(0.4),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.add, color: Colors.white, size: 28),
                          onPressed: selectedPlayerCount < 7
                              ? () {
                                  setState(() {
                                    selectedPlayerCount++;
                                  });
                                }
                              : null,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Range indicator
                  Text(
                    '(Tối thiểu: 2 - Tối đa: 7)',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                      fontSize: 12,
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Confirm button
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () async {
                        Navigator.pop(context);
                        
                        // Adjust player count
                        viewModel.userPoints.clear();
                        for (int i = 0; i < selectedPlayerCount; i++) {
                          viewModel.userPoints.add(UserPoint("Player ${i + 1}", 0, Colors.red));
                        }
                        
                        await loadSavedPlayerNames(selectedPlayerCount);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF667eea),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Xác nhận',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void showContinueDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context2) {
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
                  const Text(
                    "MAGIC TABLE",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Icon(
                    Icons.favorite,
                    color: Colors.red,
                    size: 48,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Có game đang chơi dở có muốn tiếp tục ?",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  
                  // Có button
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
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
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF667eea),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "Có",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  // Không button
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () async {
                        Navigator.of(context2).pop();
                        showNumberPlayersDialog();
                        var ref = await prefs;
                        ref.remove("records");
                        ref.remove("users");
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFff6b6b),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "Không",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
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

  void showSettingsDialog() {
    final controllers = viewModel.userPoints.map((user) {
      return TextEditingController(text: user.name);
    }).toList();
    
    // Controller for new player input
    TextEditingController? newPlayerController;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            final canAddPlayer = controllers.length < 7;
            
            return Dialog(
              backgroundColor: Colors.transparent,
              child: Container(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.8,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF2a2a2a),
                  borderRadius: BorderRadius.circular(24),
                ),
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Icon
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.edit,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                    const SizedBox(height: 12),
                    
                    // Subtitle
                    const Text(
                      'Edit player names (saved as default)',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    
                    // Player name inputs with scroll
                    Flexible(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            // Existing players
                            ...List.generate(controllers.length, (index) {
                              final colors = [Colors.blue, Colors.purple, Colors.pink, Colors.orange, Colors.teal];
                              final color = colors[index % colors.length];
                              
                              return Container(
                                margin: const EdgeInsets.only(bottom: 10),
                                child: TextField(
                                  controller: controllers[index],
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  decoration: InputDecoration(
                                    labelText: 'Player ${index + 1}',
                                    labelStyle: TextStyle(
                                      color: color.withOpacity(0.8),
                                      fontSize: 14,
                                    ),
                                    filled: true,
                                    fillColor: const Color(0xFF1a1a1a),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide.none,
                                    ),
                                    prefixIcon: Icon(
                                      Icons.person,
                                      color: color.withOpacity(0.8),
                                    ),
                                  ),
                                ),
                              );
                            }),
                            
                            // Add new player button (only if < 7 players)
                            if (canAddPlayer && newPlayerController == null)
                              Container(
                                margin: const EdgeInsets.only(bottom: 10),
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      newPlayerController = TextEditingController(text: 'Player ${controllers.length + 1}');
                                    });
                                  },
                                  borderRadius: BorderRadius.circular(12),
                                  child: Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF1a1a1a),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: const Color(0xFF4caf50).withOpacity(0.5),
                                        width: 2,
                                        style: BorderStyle.solid,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.add_circle_outline,
                                          color: const Color(0xFF4caf50).withOpacity(0.8),
                                          size: 24,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          'Add New Player',
                                          style: TextStyle(
                                            color: const Color(0xFF4caf50).withOpacity(0.8),
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            
                            // New player input field
                            if (newPlayerController != null)
                              Container(
                                margin: const EdgeInsets.only(bottom: 10),
                                child: TextField(
                                  controller: newPlayerController,
                                  autofocus: true,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  decoration: InputDecoration(
                                    labelText: 'Player ${controllers.length + 1}',
                                    labelStyle: TextStyle(
                                      color: const Color(0xFF4caf50).withOpacity(0.8),
                                      fontSize: 14,
                                    ),
                                    filled: true,
                                    fillColor: const Color(0xFF1a1a1a),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide.none,
                                    ),
                                    prefixIcon: Icon(
                                      Icons.person_add,
                                      color: const Color(0xFF4caf50).withOpacity(0.8),
                                    ),
                                    suffixIcon: IconButton(
                                      icon: const Icon(Icons.close, color: Colors.red),
                                      onPressed: () {
                                        setState(() {
                                          newPlayerController?.dispose();
                                          newPlayerController = null;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                
                // Save button
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () async {
                      // Add new player if exists
                      if (newPlayerController != null) {
                        final newPlayerName = newPlayerController!.text.trim();
                        if (newPlayerName.isNotEmpty) {
                          final colors = [Colors.blue, Colors.purple, Colors.pink, Colors.orange, Colors.teal];
                          final newColor = colors[viewModel.userPoints.length % colors.length];
                          viewModel.userPoints.add(UserPoint(newPlayerName, 0, newColor));
                          
                          // Add to all existing records with 0 points
                          for (var record in viewModel.records) {
                            record[newPlayerName] = 0;
                          }
                        }
                      }
                      
                      // Update existing user names
                      for (int i = 0; i < controllers.length; i++) {
                        final newName = controllers[i].text.trim();
                        if (newName.isNotEmpty) {
                          final user = viewModel.userPoints[i];
                          final oldName = user.name;
                          final updatedUser = UserPoint(
                            newName,
                            user.point,
                            user.color,
                          );
                          viewModel.userPoints.replaceRange(i, i + 1, [updatedUser]);
                          
                          // Update all records with new name
                          for (var record in viewModel.records) {
                            if (record.containsKey(oldName)) {
                              final value = record[oldName]!;
                              record.remove(oldName);
                              record[newName] = value;
                            }
                          }
                        }
                      }
                      
                      // Save to SharedPreferences as default
                      final tPref = await prefs;
                      final playerNames = viewModel.userPoints.map((e) => e.name).toList();
                      
                      // Save as current users
                      await tPref.setStringList("users", playerNames);
                      
                      // Save as default template for future games
                      await tPref.setStringList("default_player_names", playerNames);
                      
                      await tPref.setString(
                        "records",
                        json.encode(viewModel.records),
                      );
                      
                      Navigator.of(context).pop();
                      
                      // Show success message
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Player names saved as default!'),
                          backgroundColor: Color(0xFF4caf50),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Ink(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Container(
                        alignment: Alignment.center,
                        child: const Text(
                          'Save',
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
                      'Cancel',
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
        },
      );
    });
  }

  void showResetConfirmDialog() {
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
                  "Reset All Records?",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "This will delete all game records and reset all scores to 0",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                
                // Continue button
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      showFinalResetConfirmDialog();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFff6b6b),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Continue",
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
      },
    );
  }

  void showFinalResetConfirmDialog() {
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
                  Icons.delete_forever,
                  color: Color(0xFFff6b6b),
                  size: 56,
                ),
                const SizedBox(height: 16),
                const Text(
                  "Are You Sure?",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "This action cannot be undone!\nAll records will be permanently deleted.",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                
                // Delete button
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () async {
                      // Reset all records
                      viewModel.records.clear();
                      
                      // Reset to 2 players
                      viewModel.userPoints.clear();
                      viewModel.userPoints.add(UserPoint("Player 1", 0, Colors.blue));
                      viewModel.userPoints.add(UserPoint("Player 2", 0, Colors.purple));
                      
                      // Save to SharedPreferences
                      final tPref = await prefs;
                      await tPref.setString("records", json.encode([]));
                      await tPref.setStringList("users", ["Player 1", "Player 2"]);
                      
                      Navigator.of(context).pop();
                      
                      // Show success message
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Reset to 2 players!'),
                          backgroundColor: Color(0xFF4caf50),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFff6b6b),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Yes, Delete Everything",
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
      },
    );
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
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.settings, color: Colors.blue),
          onPressed: () {
            showSettingsDialog();
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.blue),
            onPressed: () {
              showResetConfirmDialog();
            },
          ),
          Container(
            margin: const EdgeInsets.only(left: 20, right: 8),
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
              onPressed: () {
                addNewRecord(context);
              },
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: CardStyleView(
          userPoints: viewModel.userPoints,
          records: viewModel.records,
          onIncrement: handleIncrement,
          onDecrement: handleDecrement,
          onCardTap: handleCardTap,
          onLongPress: handleLongPress,
        ),
      ),
    );
  }
}

class UserPoint {
  String name = '';
  int point = 0;
  Color color = Colors.red;

  UserPoint(this.name, this.point, this.color);
}
