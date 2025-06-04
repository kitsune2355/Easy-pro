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

class RecentActivity {
  final IconData icon;
  final String task;
  final String status;
  final String time;
  final Color statusColor;

  RecentActivity({
    required this.icon,
    required this.task,
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
    // Add more statistic cards as needed
  ];

  List<RecentActivity> get _recentActivities => [
    RecentActivity(
      icon: Icons.build_circle_rounded,
      task: 'ซ่อมเครื่องปรับอากาศ #A123',
      status: 'เสร็จสิ้น',
      time: 'วันนี้, 14:30 น.',
      statusColor: Colors.green.shade600,
    ),
    RecentActivity(
      icon: Icons.lightbulb_outline_rounded,
      task: 'เปลี่ยนหลอดไฟชั้น 3 #L456',
      status: 'รอดำเนินการ',
      time: 'เมื่อวาน, 10:00 น.',
      statusColor: Colors.orange.shade600,
    ),
    RecentActivity(
      icon: Icons.water_drop_rounded,
      task: 'แก้ไขน้ำรั่วห้องน้ำ #W789',
      status: 'เสร็จสิ้น',
      time: '2 วันที่แล้ว',
      statusColor: Colors.green.shade600,
    ),
    RecentActivity(
      icon: Icons.electrical_services_rounded,
      task: 'ติดตั้งเต้ารับใหม่ #E012',
      status: 'รอดำเนินการ',
      time: '3 วันที่แล้ว',
      statusColor: Colors.orange.shade600,
    ),
    // Add more activities as needed
  ];

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final bool isIOS = Theme.of(context).platform == TargetPlatform.iOS;

    // Common body content to avoid duplication
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
          // Using LayoutBuilder to make GridView responsive
          LayoutBuilder(
            builder: (context, constraints) {
              int crossAxisCount = 3; // Default for mobile
              double childAspectRatio = 0.8;
              if (constraints.maxWidth > 600) {
                crossAxisCount = 4; // For tablets
                childAspectRatio = 1.0;
              }
              if (constraints.maxWidth > 900) {
                crossAxisCount = 4; // For larger screens
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
          // Using Wrap for responsive action buttons
          Wrap(
            spacing: 16.0, // Horizontal space between buttons
            runSpacing: 16.0, // Vertical space between rows of buttons
            alignment: WrapAlignment.center, // Center the buttons
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
            backgroundColor: CupertinoColors.systemGrey6, // iOS light grey
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
      elevation: 4, // Slightly less elevation for a modern feel
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      shadowColor: Colors.black.withOpacity(0.08), // Softer shadow
      child: Container(
        padding: const EdgeInsets.all(16), // Reduced padding to give more internal space
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(14), // Slightly smaller radius
              ),
              child: Icon(icon, size: 32, color: color), // Slightly smaller icon
            ),
            // Wrap title Text with Flexible to allow it to shrink if needed
            Flexible(
              child: Text(
                title,
                textAlign: TextAlign.center, // Center align title
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[600],
                  fontSize: 12, // Slightly smaller font size
                ),
                maxLines: 2, // Limit lines to prevent excessive height
                overflow: TextOverflow.ellipsis, // Add ellipsis if overflow
              ),
            ),
         
            // Wrap value Text with Flexible and FittedBox for scaling
            Flexible(
              child: FittedBox(
                fit: BoxFit.scaleDown, // Scale down if too large
                child: Text(
                  value,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                    fontSize: 24, // Adjusted font size for value
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
    return SizedBox( // Use SizedBox to control width in Wrap
      width: 150, // Fixed width for action buttons
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
                Icon(icon, size: 48, color: Colors.white), // Slightly larger icon
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
                      fontSize: 18, // Adjusted font size
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
            // Use ListView.builder for potentially long lists of activities
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(), // Disable its own scrolling
              itemCount: _recentActivities.length,
              separatorBuilder: (context, index) => Divider(height: 28, thickness: 0.8, color: Colors.grey.shade300), // Lighter divider
              itemBuilder: (context, index) {
                final activity = _recentActivities[index];
                return _buildActivityTile(
                  icon: activity.icon,
                  task: activity.task,
                  status: activity.status,
                  time: activity.time,
                  statusColor: activity.statusColor,
                );
              },
            ),
            const SizedBox(height: 16),
            Align( // Align the button to the right
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  // Navigate to full activities list
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
      padding: const EdgeInsets.symmetric(vertical: 8.0), // Padding for each tile
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 24, // Slightly larger avatar
            backgroundColor: statusColor.withOpacity(0.1),
            child: Icon(icon, size: 28, color: statusColor), // Slightly larger icon
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task,
                  style: const TextStyle(
                    fontSize: 17, // Slightly larger font
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  time,
                  style: const TextStyle(
                    fontSize: 14, // Slightly larger font
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8), // More padding
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(22), // More rounded corners
              border: Border.all(color: statusColor.withOpacity(0.3), width: 0.8),
            ),
            child: Text(
              status,
              style: TextStyle(
                color: statusColor,
                fontWeight: FontWeight.bold,
                fontSize: 13, // Slightly larger font
              ),
            ),
          ),
        ],
      ),
    );
  }
}
