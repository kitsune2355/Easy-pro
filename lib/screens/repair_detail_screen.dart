import 'package:easy_pro/models/repair_history_item.dart';
import 'package:flutter/material.dart';

class RepairDetailScreen extends StatelessWidget {
  final RepairHistoryItem repairItem;

  const RepairDetailScreen({super.key, required this.repairItem});

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          'รายละเอียดแจ้งซ่อม #${repairItem.id}',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        foregroundColor: Colors.white,
        backgroundColor: primaryColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // --- Status Header Card ---
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              margin: const EdgeInsets.only(bottom: 16.0),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Icon(
                      repairItem.icon,
                      size: 60,
                      color: repairItem.statusColor,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      repairItem.statusText,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: repairItem.statusColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      repairItem.statusText == 'เสร็จสิ้น'
                          ? 'งานซ่อมนี้เสร็จสมบูรณ์แล้ว'
                          : repairItem.statusText == 'กำลังดำเนินการ'
                              ? 'ช่างกำลังดำเนินการแก้ไขปัญหา'
                              : 'รอช่างรับงานและดำเนินการ',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // --- Original Repair Request Info ---
            _buildInfoCard(
              context,
              title: 'ข้อมูลการแจ้งซ่อมเดิม',
              children: [
                _buildInfoTile(
                    Icons.event, 'วันที่แจ้ง', repairItem.reportDate, primaryColor),
                _buildInfoTile(
                    Icons.subject, 'เรื่อง', repairItem.displayTitle, primaryColor),
                _buildInfoTile(Icons.description, 'รายละเอียดปัญหา',
                    repairItem.problemDetail, primaryColor),
                // Add more original details if needed, e.g., building, room
              ],
            ),
            const SizedBox(height: 16),

            // --- Technician Information ---
            if (repairItem.technicianName != null)
              _buildInfoCard(
                context,
                title: 'ข้อมูลช่างผู้รับผิดชอบ',
                children: [
                  _buildInfoTile(Icons.person, 'ชื่อช่าง',
                      repairItem.technicianName!, primaryColor),
                  _buildInfoTile(Icons.phone, 'เบอร์โทรช่าง',
                      repairItem.technicianPhone!, primaryColor),
                  // Add more technician details if available
                ],
              ),
            if (repairItem.technicianName != null) const SizedBox(height: 16),

            // --- Solution & Images ---
            if (repairItem.solution != null ||
                (repairItem.solutionImagePaths != null &&
                    repairItem.solutionImagePaths!.isNotEmpty))
              _buildInfoCard(
                context,
                title: 'วิธีการแก้ไข',
                children: [
                  if (repairItem.solution != null)
                    _buildInfoTile(
                        Icons.build, 'รายละเอียดการแก้ไข', repairItem.solution!, primaryColor),
                  if (repairItem.solutionImagePaths != null &&
                      repairItem.solutionImagePaths!.isNotEmpty) ...[
                    _buildInfoTile(Icons.photo_library, 'รูปภาพประกอบ', '', primaryColor),
                    const SizedBox(height: 8),
                    // Use a horizontal ListView for multiple images
                    SizedBox(
                      height: 100, // Fixed height for image gallery
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: repairItem.solutionImagePaths!.length,
                        itemBuilder: (context, imgIndex) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.network(
                                repairItem.solutionImagePaths![imgIndex],
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Container(
                                  width: 100,
                                  height: 100,
                                  color: Colors.grey[200],
                                  child: Icon(Icons.broken_image,
                                      color: Colors.grey[400], size: 40),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ],
              ),
          ],
        ),
      ),
    );
  }

  /// Reusable widget to build an information card.
  Widget _buildInfoCard(
    BuildContext context, {
    required String title,
    required List<Widget> children,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
            const Divider(height: 24, thickness: 1), // Separator
            ...children, // Spread the list of tiles
          ],
        ),
      ),
    );
  }

  /// Reusable widget to build an information tile.
  Widget _buildInfoTile(
      IconData icon, String label, String value, Color iconColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}