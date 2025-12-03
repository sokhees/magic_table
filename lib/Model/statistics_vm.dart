import 'package:get/get.dart';
import 'package:magic_table/Views/pointing_page.dart';

class PlayerStatistics {
  final String playerName;
  int totalWins = 0;
  int totalLosses = 0;
  int maxWinStreak = 0;
  int maxConsecutivePoints = 0;
  int totalSamRounds = 0; // Tổng số ván Sâm (tất cả người khác bị -20)
  int totalCatchSamRounds = 0; // Tổng số ván bắt sâm (điểm = số người * 20)
  int totalTreoRounds = 0; // Tổng số ván treo (bị -15)
  int totalBiSamRounds = 0; // Tổng số ván bị sâm (ít nhất 2 người bị -20)

  PlayerStatistics(this.playerName);
}

class StatisticsViewModel extends GetxController {
  final RxList<Map<String, int>> records;
  final RxList<UserPoint> userPoints;
  
  StatisticsViewModel(this.records, this.userPoints);

  Map<String, PlayerStatistics> calculateStatistics() {
    Map<String, PlayerStatistics> stats = {};
    
    // Khởi tạo statistics cho mỗi người chơi
    for (var player in userPoints) {
      stats[player.name] = PlayerStatistics(player.name);
    }

    // Theo dõi chuỗi thắng và điểm liên tục
    Map<String, int> currentWinStreak = {};
    Map<String, int> currentPointsStreak = {};
    Map<String, int> lastPoints = {};
    
    for (var player in userPoints) {
      currentWinStreak[player.name] = 0;
      currentPointsStreak[player.name] = 0;
      lastPoints[player.name] = 0;
    }

    // Duyệt qua từng ván chơi (từ mới nhất đến cũ nhất)
    for (var record in records.reversed) {
      // Tìm người thắng (điểm dương lớn nhất hoặc âm nhỏ nhất nếu không có điểm dương)
      String? winner;
      int maxPoints = -999999;
      
      record.forEach((name, points) {
        if (points > maxPoints) {
          maxPoints = points;
          winner = name;
        }
      });

      // Tính toán thống kê cho mỗi người chơi trong ván này
      record.forEach((name, points) {
        var stat = stats[name]!;
        
        // 1. Thắng/Thua
        if (name == winner && points > 0) {
          stat.totalWins++;
          currentWinStreak[name] = (currentWinStreak[name] ?? 0) + 1;
          if (currentWinStreak[name]! > stat.maxWinStreak) {
            stat.maxWinStreak = currentWinStreak[name]!;
          }
        } else {
          stat.totalLosses++;
          currentWinStreak[name] = 0;
        }

        // 4. Tổng điểm liên tục nhiều nhất
        if (points > 0) {
          currentPointsStreak[name] = (currentPointsStreak[name] ?? 0) + points;
          if (currentPointsStreak[name]! > stat.maxConsecutivePoints) {
            stat.maxConsecutivePoints = currentPointsStreak[name]!;
          }
        } else {
          currentPointsStreak[name] = 0;
        }

        // 5. Ván Sâm: Người thắng và tất cả người khác bị -20
        if (name == winner && points > 0) {
          bool isSam = true;
          for (var otherName in record.keys) {
            if (otherName != name && record[otherName] != -20) {
              isSam = false;
              break;
            }
          }
          if (isSam && record.length > 1) {
            stat.totalSamRounds++;
          }
        }

        // 6. Ván bắt sâm: Điểm = số người chơi * 20
        int expectedCatchSam = userPoints.length * 20;
        if (name == winner && points == expectedCatchSam) {
          stat.totalCatchSamRounds++;
        }

        // 7. Ván treo: Người chơi bị -15 điểm
        if (points == -15) {
          stat.totalTreoRounds++;
        }
      });

      // 8. Ván bị sâm: Đếm số người bị -20 trong ván này
      int countMinus20 = 0;
      record.forEach((name, points) {
        if (points == -20) {
          countMinus20++;
        }
      });

      // Nếu có ít nhất 2 người bị -20, tất cả người bị -20 được tính là bị sâm
      if (countMinus20 >= 2) {
        record.forEach((name, points) {
          if (points == -20) {
            stats[name]!.totalBiSamRounds++;
          }
        });
      }
    }

    return stats;
  }
}
