import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:magic_table/Model/statistics_vm.dart';
import 'package:magic_table/Views/pointing_page.dart';

class StatisticsPage extends StatefulWidget {
  final RxList<Map<String, int>> records;
  final RxList<UserPoint> userPoints;

  const StatisticsPage({
    Key? key,
    required this.records,
    required this.userPoints,
  }) : super(key: key);

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

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

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFF2a2a2a),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    color: color,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = StatisticsViewModel(widget.records, widget.userPoints);
    final stats = viewModel.calculateStatistics();
    final players = widget.userPoints.toList();

    return Scaffold(
      backgroundColor: const Color(0xFF1a1a1a),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Text(
                    'Statistics',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  // Page indicators
                  ...List.generate(players.length, (index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _currentPage == index
                            ? Colors.white
                            : Colors.white.withOpacity(0.3),
                      ),
                    );
                  }),
                ],
              ),
            ),

            // PageView for each player
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: players.length,
                itemBuilder: (context, pageIndex) {
                  final player = players[pageIndex];
                  final stat = stats[player.name]!;

                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Player header
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                _getGradientColor(pageIndex, 0.8),
                                _getGradientColor(pageIndex, 1.0),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: _getGradientColor(pageIndex, 0.4),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.person,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  player.name.toUpperCase(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Statistics
                        _buildStatCard(
                          title: 'Tổng số ván thắng',
                          value: stat.totalWins.toString(),
                          icon: Icons.emoji_events,
                          color: const Color(0xFFffd700),
                        ),
                        const SizedBox(height: 6),

                        _buildStatCard(
                          title: 'Tổng số ván thua',
                          value: stat.totalLosses.toString(),
                          icon: Icons.trending_down,
                          color: const Color(0xFFff6b6b),
                        ),
                        const SizedBox(height: 6),

                        _buildStatCard(
                          title: 'Chuỗi thắng liên tục cao nhất',
                          value: '${stat.maxWinStreak} ván',
                          icon: Icons.whatshot,
                          color: const Color(0xFFff9800),
                        ),
                        const SizedBox(height: 6),

                        _buildStatCard(
                          title: 'Tổng điểm nhiều nhất liên tục',
                          value: stat.maxConsecutivePoints.toString(),
                          icon: Icons.trending_up,
                          color: const Color(0xFF4caf50),
                        ),
                        const SizedBox(height: 6),

                        _buildStatCard(
                          title: 'Tổng số ván Sâm',
                          value: stat.totalSamRounds.toString(),
                          icon: Icons.stars,
                          color: const Color(0xFF9c27b0),
                        ),
                        const SizedBox(height: 6),

                        _buildStatCard(
                          title: 'Tổng số ván bắt Sâm',
                          value: stat.totalCatchSamRounds.toString(),
                          icon: Icons.verified,
                          color: const Color(0xFF00bcd4),
                        ),
                        const SizedBox(height: 6),

                        _buildStatCard(
                          title: 'Tổng số ván Treo',
                          value: stat.totalTreoRounds.toString(),
                          icon: Icons.warning_amber,
                          color: const Color(0xFFff5722),
                        ),
                        const SizedBox(height: 6),

                        _buildStatCard(
                          title: 'Tổng số ván bị Sâm',
                          value: stat.totalBiSamRounds.toString(),
                          icon: Icons.crisis_alert,
                          color: const Color(0xFFe91e63),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
