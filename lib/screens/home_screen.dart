// lib/screens/home_screen.dart

import 'package:easy_pro/models/repair_history_item.dart';
import 'package:easy_pro/services/repair_service.dart'; // Import RepairService
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart'; // เพิ่ม import provider

// ยังคงใช้ GlobalKey<HomeScreenState> เหมือนเดิม
final GlobalKey<HomeScreenState> homeScreenKey = GlobalKey<HomeScreenState>();

class JobStatistic {
  final String title;
  final int value;
  final IconData icon;
  final Color color;

  JobStatistic({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });
}

class HomeScreen extends StatefulWidget {
  final VoidCallback? onNavigateToRepair;
  final VoidCallback? onNavigateToHistory;

  const HomeScreen({
    super.key,
    this.onNavigateToRepair,
    this.onNavigateToHistory,
  });

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  // ไม่ต้องมี _recentActivities, _isLoading, _error, _jobStatistics ที่เป็น State ของ Widget โดยตรงแล้ว
  // เพราะจะดึงจาก RepairService ผ่าน Provider แทน
  List<JobStatistic> _jobStatistics = []; // เก็บแค่ JobStatistic ที่คำนวณจากข้อมูลที่ได้มา

  @override
  void initState() {
    super.initState();
    // ไม่ต้องเรียก _fetchRecentActivities() ที่นี่แล้ว เพราะ refreshData() จะทำแทน
  }

  // เมธอด refreshData จะไปสั่งให้ RepairService ดึงข้อมูล
  Future<void> refreshData() async {
    // เข้าถึง instance ของ RepairService ผ่าน Provider
    await Provider.of<RepairService>(context, listen: false).fetchAllRepairRequests();
  }

  // เมธอดนี้จะหายไป หรือเปลี่ยนไปเป็นการคำนวณ JobStatistic จากข้อมูลใน RepairService
  // หรืออาจจะยังคงอยู่ แต่เปลี่ยน logic ภายใน
  // ขอแนะนำให้ลบออก แล้วให้ build method อ่านค่าจาก Provider โดยตรง
  // และคำนวณ JobStatistic ใน build หรือใน Consumer/Selector
  // หรืออีกทางคือให้ RepairService คำนวณและเก็บค่า JobStatistic ไว้เอง

  // หากต้องการให้ JobStatistic อัปเดตเมื่อข้อมูลมา, เราจะใช้ Consumer หรือ Selector ใน build method แทน
  // เพื่อให้ UI อัปเดตเมื่อ RepairService แจ้งเตือน

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final bool isIOS = Theme.of(context).platform == TargetPlatform.iOS;

    // ใช้ Consumer หรือ Selector เพื่อ listen การเปลี่ยนแปลงของ RepairService
    return Consumer<RepairService>(
      builder: (context, repairService, child) {
        // คำนวณ JobStatistic ที่นี่ หรือให้ RepairService เตรียมไว้ให้
        final List<RepairHistoryItem> recentActivities = repairService.allRepairRequests;
        final bool isLoading = repairService.isLoading;
        final String? error = repairService.error;

        _jobStatistics = [
          JobStatistic(
            title: 'งานทั้งหมด',
            value: recentActivities.length,
            icon: Icons.receipt_long_rounded,
            color: Colors.blue.shade600,
          ),
          JobStatistic(
            title: 'รอดำเนินการ',
            value: recentActivities
                .where((activity) => activity.statusText == 'รอดำเนินการ')
                .length,
            icon: Icons.pending_actions_rounded,
            color: Colors.orange.shade600,
          ),
          JobStatistic(
            title: 'เสร็จสิ้น',
            value: recentActivities
                .where((activity) => activity.statusText == 'เสร็จสิ้น')
                .length,
            icon: Icons.task_alt_rounded,
            color: Colors.green.shade600,
          ),
        ];

        final Widget bodyContent = SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'ภาพรวมงานซ่อม',
                style: textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              const SizedBox(height: 16),
              LayoutBuilder(
                builder: (context, constraints) {
                  int crossAxisCount = 3;
                  if (constraints.maxWidth > 600) {
                    crossAxisCount = 6;
                  }
                  if (constraints.maxWidth > 900) {
                    crossAxisCount = 6;
                  }
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _jobStatistics.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 1.0,
                      mainAxisSpacing: 1.0,
                      childAspectRatio: 1.0,
                    ),
                    itemBuilder: (context, index) {
                      final stat = _jobStatistics[index];
                      return _buildStatisticCard(
                        context,
                        title: stat.title,
                        value: stat.value.toString(),
                        icon: stat.icon,
                        color: stat.color,
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 32),
              Text(
                'ดำเนินการด่วน',
                style: textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              const SizedBox(height: 16),
              LayoutBuilder(
                builder: (context, constraints) {
                  int crossAxisCount = 2;
                  double childAspectRatio = 1.2;

                  if (constraints.maxWidth > 600) {
                    crossAxisCount = 3;
                    childAspectRatio = 1.0;
                  }
                  if (constraints.maxWidth > 900) {
                    crossAxisCount = 4;
                    childAspectRatio = 1.0;
                  }

                  final actions = [
                    {
                      'title': 'แจ้งซ่อม',
                      'icon': Icons.build_circle_outlined,
                      'onTap': widget.onNavigateToRepair,
                      'color': Colors.teal.shade600,
                      'gradient': [const Color(0xFF006289), Colors.teal.shade400],
                    },
                    {
                      'title': 'ประวัติ',
                      'icon': Icons.access_time_filled_rounded,
                      'onTap': widget.onNavigateToHistory,
                      'color': Colors.deepPurple.shade600,
                      'gradient': [
                        const Color(0xFFB13579),
                        Colors.deepPurple.shade400,
                      ],
                    },
                  ];

                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: actions.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 16.0,
                      mainAxisSpacing: 16.0,
                      childAspectRatio: childAspectRatio,
                    ),
                    itemBuilder: (context, index) {
                      final action = actions[index];
                      return _buildActionButton(
                        context,
                        title: action['title'] as String,
                        icon: action['icon'] as IconData,
                        onTap: action['onTap'] as VoidCallback,
                        color: action['color'] as Color,
                        gradientColors: action['gradient'] as List<Color>,
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 32),
              Text(
                'กิจกรรมล่าสุด',
                style: textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              const SizedBox(height: 16),
              // ส่งข้อมูลที่ได้จาก provider ไปยัง _buildRecentActivitiesCard
              _buildRecentActivitiesCard(
                recentActivities: recentActivities,
                isLoading: isLoading,
                error: error,
              ),
            ],
          ),
        );

        return isIOS
            ? CupertinoPageScaffold(
                backgroundColor: CupertinoColors.systemGrey6,
                child: SafeArea(
                  child: RefreshIndicator(
                    onRefresh: () => repairService.fetchAllRepairRequests(), // เรียกเมธอดของ provider
                    child: bodyContent,
                  ),
                ),
              )
            : Scaffold(
                backgroundColor: Colors.grey[50],
                body: RefreshIndicator(
                  onRefresh: () => repairService.fetchAllRepairRequests(), // เรียกเมธอดของ provider
                  child: bodyContent,
                ),
              );
      },
    );
  }

  Widget _buildStatisticCard(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      shadowColor: Colors.black.withOpacity(0.08),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, size: 32, color: color),
            ),
            Flexible(
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Flexible(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  value,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                    fontSize: 24,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required String title,
    required IconData icon,
    VoidCallback? onTap,
    required Color color,
    List<Color>? gradientColors,
  }) {
    return SizedBox(
      width: 150,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(22),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(22),
          splashColor: Colors.white.withOpacity(0.3),
          highlightColor: Colors.white.withOpacity(0.1),
          child: Container(
            height: 160,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors:
                    gradientColors ??
                    [Colors.teal.shade600, Colors.teal.shade400],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(22),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.3),
                  blurRadius: 18,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 48, color: Colors.white),
                const SizedBox(height: 14),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: 0.5,
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ปรับปรุง _buildRecentActivitiesCard ให้รับข้อมูลจากภายนอก
  Widget _buildRecentActivitiesCard({
    required List<RepairHistoryItem> recentActivities,
    required bool isLoading,
    required String? error,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : error != null
                ? Center(
                    child: Text(
                      'Error: $error',
                      style: const TextStyle(color: Colors.red),
                    ),
                  )
                : recentActivities.isEmpty
                    ? const Center(
                        child: Text(
                          'ไม่พบกิจกรรมล่าสุด.',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      )
                    : Column(
                        children: [
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: recentActivities.length,
                            separatorBuilder: (context, index) => Divider(
                              height: 28,
                              thickness: 0.8,
                              color: Colors.grey.shade300,
                            ),
                            itemBuilder: (context, index) {
                              final activity = recentActivities[index];
                              return _buildActivityTile(
                                id: activity.id,
                                icon: Icons.build_circle_rounded,
                                task: activity.displayTitle,
                                statusText: activity.statusText,
                                time: activity.fullReportDateTime,
                                statusColor: activity.statusColor,
                                place: activity.displayPlace,
                              );
                            },
                          ),
                          const SizedBox(height: 16),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                widget.onNavigateToHistory?.call();
                              },
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 10,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                'ดูทั้งหมด',
                                style: TextStyle(
                                  color: Colors.grey[500],
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
      ),
    );
  }

  Widget _buildActivityTile({
    required String id,
    required IconData icon,
    required String task,
    required String statusText,
    required String time,
    required Color statusColor,
    required String place,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: statusColor.withOpacity(0.1),
            child: Icon(icon, size: 28, color: statusColor),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '#${id} ${task}',
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  place,
                  style: const TextStyle(fontSize: 15, color: Colors.black45),
                ),
                const SizedBox(height: 6),
                Text(
                  time,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: statusColor.withOpacity(0.3),
                width: 0.8,
              ),
            ),
            child: Text(
              statusText,
              style: TextStyle(
                color: statusColor,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}