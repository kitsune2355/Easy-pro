import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart'; // Import for Cupertino widgets

// --- Mock Data Models ---
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

// Re-defining RecentActivity to match the structure of your HistoryRepairItem
class RecentActivity {
  final String date;
  final String title;
  final String detail;
  final String status;
  final String time;
  final Color statusColor; // Added for convenience

  RecentActivity({
    required this.date,
    required this.title,
    required this.detail,
    required this.status,
    required this.time,
    required this.statusColor,
  });
}

class HomeScreen extends StatelessWidget {
  final VoidCallback? onNavigateToRepair;
  final VoidCallback? onNavigateToHistory;

  const HomeScreen({
    super.key,
    this.onNavigateToRepair,
    this.onNavigateToHistory,
  });

  // --- Mock Data ---
  List<JobStatistic> get _jobStatistics => [
    JobStatistic(
      title: 'งานทั้งหมด',
      value: 150,
      icon: Icons.receipt_long_rounded,
      color: Colors.blue.shade600,
    ),
    JobStatistic(
      title: 'รอดำเนินการ',
      value: 25,
      icon: Icons.pending_actions_rounded,
      color: Colors.orange.shade600,
    ),
    JobStatistic(
      title: 'เสร็จสิ้น',
      value: 125,
      icon: Icons.task_alt_rounded,
      color: Colors.green.shade600,
    ),
  ];

  // Updated _recentActivities to reflect HistoryRepairItem data
  List<RecentActivity> get _recentActivities => [
    RecentActivity(
      date: '2567-05-30',
      title: 'ซ่อมเครื่องปรับอากาศ',
      detail: 'แอร์ไม่เย็น มีน้ำหยด',
      status: 'เสร็จสิ้น',
      time: '14:30 น.',
      statusColor: Colors.green.shade600,
    ),
    RecentActivity(
      date: '2567-05-28',
      title: 'เปลี่ยนหลอดไฟ',
      detail: 'ไฟห้องประชุมเสีย',
      status: 'รอดำเนินการ',
      time: '10:00 น.',
      statusColor: Colors.orange.shade600,
    ),
    RecentActivity(
      date: '2567-05-25',
      title: 'แก้ไขน้ำรั่ว',
      detail: 'น้ำรั่วจากเพดานห้องน้ำ',
      status: 'เสร็จสิ้น',
      time: '09:00 น.',
      statusColor: Colors.green.shade600,
    ),
    RecentActivity(
      date: '2567-05-22',
      title: 'ติดตั้งเต้ารับใหม่',
      detail: 'ติดตั้งเต้ารับเพิ่มในห้องทำงาน',
      status: 'รอดำเนินการ',
      time: '11:00 น.',
      statusColor: Colors.orange.shade600,
    ),
     RecentActivity(
      date: '2567-05-20',
      title: 'บำรุงรักษาระบบเครือข่าย',
      detail: 'ตรวจสอบและแก้ไขปัญหาอินเทอร์เน็ต',
      status: 'เสร็จสิ้น',
      time: '16:00 น.',
      statusColor: Colors.green.shade600,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final bool isIOS = Theme.of(context).platform == TargetPlatform.iOS;

    final Widget bodyContent = SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- Statistics Section ---
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
              double childAspectRatio = 0.8;
              if (constraints.maxWidth > 600) {
                crossAxisCount = 4;
                childAspectRatio = 1.0;
              }
              if (constraints.maxWidth > 900) {
                crossAxisCount = 4;
                childAspectRatio = 1.0;
              }
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _jobStatistics.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 1.0,
                  mainAxisSpacing: 1.0,
                  childAspectRatio: childAspectRatio,
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

          // --- Main Actions Section ---
          Text(
            'ดำเนินการด่วน',
            style: textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 16.0,
            runSpacing: 16.0,
            alignment: WrapAlignment.center,
            children: [
              _buildActionButton(
                context,
                title: 'แจ้งซ่อม',
                icon: Icons.build_circle_outlined,
                onTap: onNavigateToRepair,
                color: Colors.teal.shade600,
                gradientColors: [const Color(0xFF006289), Colors.teal.shade400],
              ),
              _buildActionButton(
                context,
                title: 'ประวัติ',
                icon: Icons.access_time_filled_rounded,
                onTap: onNavigateToHistory,
                color: Colors.deepPurple.shade600,
                gradientColors: [const Color(0xFFB13579), Colors.deepPurple.shade400],
              ),
            ],
          ),
          const SizedBox(height: 32),

          // --- Recent Activities Section ---
          Text(
            'กิจกรรมล่าสุด',
            style: textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 16),
          _buildRecentActivitiesCard(),
        ],
      ),
    );

    return isIOS
        ? CupertinoPageScaffold(
            backgroundColor: CupertinoColors.systemGrey6,
            child: SafeArea(
              child: bodyContent,
            ),
          )
        : Scaffold(
            backgroundColor: Colors.grey[50],
            body: bodyContent,
          );
  }

  /// Helper widget for displaying a single statistic card.
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

  /// Helper widget for main action buttons.
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
                colors: gradientColors ?? [Colors.teal.shade600, Colors.teal.shade400],
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

  /// Helper widget for the card containing recent activities.
  Widget _buildRecentActivitiesCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _recentActivities.length,
              separatorBuilder: (context, index) => Divider(height: 28, thickness: 0.8, color: Colors.grey.shade300),
              itemBuilder: (context, index) {
                final activity = _recentActivities[index];
                // Pass a generic icon, or map based on title/detail if specific icons are needed
                return _buildActivityTile(
                  // Use a generic icon for now, or you can add an icon property to RecentActivity
                  icon: Icons.build_circle_rounded, // Generic repair icon
                  task: activity.title, // Use title for the main task description
                  status: activity.status,
                  time: "${activity.date}, ${activity.time}", // Combine date and time
                  statusColor: activity.statusColor,
                );
              },
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  // Navigate to full activities list
                  onNavigateToHistory?.call(); // Use the callback to navigate to history
                },
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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

  /// Helper widget for a single recent activity item.
  Widget _buildActivityTile({
    required IconData icon,
    required String task,
    required String status,
    required String time,
    required Color statusColor,
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
                  task,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  time,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: statusColor.withOpacity(0.3), width: 0.8),
            ),
            child: Text(
              status,
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