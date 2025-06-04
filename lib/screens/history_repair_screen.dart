import 'package:flutter/material.dart';

class RepairHistoryItem {
  final String id;
  final String title;
  final String problemDetail;
  final String reportDate;
  final String status; // e.g., 'รอดำเนินการ', 'กำลังดำเนินการ', 'เสร็จสิ้น'
  final String? technicianName;
  final String? technicianPhone;
  final String? solution;
  final List<String>? solutionImagePaths; // List of image URLs or local paths

  // Make the constructor const
  const RepairHistoryItem({
    required this.id,
    required this.title,
    required this.problemDetail,
    required this.reportDate,
    required this.status,
    this.technicianName,
    this.technicianPhone,
    this.solution,
    this.solutionImagePaths,
  });
}

// --- HistoryRepairScreen: List View ---
class HistoryRepairScreen extends StatelessWidget {
  const HistoryRepairScreen({super.key});
  final List<RepairHistoryItem> _dummyHistory = const [ 
    RepairHistoryItem( // Each item can still be const
      id: 'R001',
      title: 'แอร์ไม่เย็น ห้อง 201',
      problemDetail: 'แอร์ในห้อง 201 อาคาร A ไม่มีความเย็นออกมาเลย มีแต่ลมเป่า',
      reportDate: '01/06/2567',
      status: 'เสร็จสิ้น',
      technicianName: 'นายประหยัด ขยันซ่อม',
      technicianPhone: '081-123-4567',
      solution: 'ตรวจสอบพบน้ำยาแอร์ขาด ทำการเติมน้ำยาแอร์และทำความสะอาดฟิลเตอร์',
      solutionImagePaths: const [ // These lists must also be const if the parent is const
        'https://via.placeholder.com/150/FF0000/FFFFFF?text=Before', // Example image URL
        'https://via.placeholder.com/150/0000FF/FFFFFF?text=After',  // Example image URL
      ],
    ),
    RepairHistoryItem(
      id: 'R002',
      title: 'ก๊อกน้ำรั่ว ห้อง 305',
      problemDetail: 'ก๊อกน้ำในห้องน้ำชั้น 3 ห้อง 305 มีน้ำหยดตลอดเวลา',
      reportDate: '05/06/2567',
      status: 'กำลังดำเนินการ',
      technicianName: 'นางสาวสุขใจ บริการดี',
      technicianPhone: '089-987-6543',
      solution: null, // Still in progress
      solutionImagePaths: null,
    ),
    RepairHistoryItem(
      id: 'R003',
      title: 'ไฟดับบางส่วน อาคาร B',
      problemDetail: 'ไฟในโซนห้องประชุมชั้น 4 อาคาร B ดับบางดวง',
      reportDate: '10/05/2567',
      status: 'รอดำเนินการ',
      technicianName: null, // Not assigned yet
      technicianPhone: null,
      solution: null,
      solutionImagePaths: null,
    ),
    RepairHistoryItem(
      id: 'R004',
      title: 'พัดลมไม่หมุน ห้อง 102',
      problemDetail: 'พัดลมเพดานในห้อง 102 อาคาร C ไม่ทำงาน',
      reportDate: '28/04/2567',
      status: 'เสร็จสิ้น',
      technicianName: 'นายสมศักดิ์ ซ่อมไว',
      technicianPhone: '080-000-1111',
      solution: 'มอเตอร์พัดลมเสีย ทำการเปลี่ยนมอเตอร์ใหม่',
      solutionImagePaths: const [], // Empty const list is fine
    ),
  ];

  Color _getStatusColor(String status) {
    switch (status) {
      case 'เสร็จสิ้น':
        return Colors.green;
      case 'กำลังดำเนินการ':
        return Colors.orange;
      case 'รอดำเนินการ':
        return Colors.blueGrey;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'เสร็จสิ้น':
        return Icons.check_circle;
      case 'กำลังดำเนินการ':
        return Icons.hourglass_bottom;
      case 'รอดำเนินการ':
        return Icons.pending_actions;
      default:
        return Icons.info_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: _dummyHistory.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history_toggle_off, size: 80, color: Colors.grey),
                  SizedBox(height: 20),
                  Text(
                    'คุณยังไม่มีประวัติการแจ้งซ่อม',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: _dummyHistory.length,
              itemBuilder: (context, index) {
                final item = _dummyHistory[index];
                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  child: InkWell(
                    // Use InkWell for ripple effect on tap
                    borderRadius: BorderRadius.circular(15),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RepairDetailScreen(item: item),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'แจ้งซ่อม #${item.id}',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: primaryColor,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: _getStatusColor(item.status)
                                      .withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      _getStatusIcon(item.status),
                                      size: 16,
                                      color: _getStatusColor(item.status),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      item.status,
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: _getStatusColor(item.status),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            item.title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item.problemDetail.length > 100
                                ? '${item.problemDetail.substring(0, 100)}...'
                                : item.problemDetail,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Icon(Icons.calendar_today,
                                  size: 16, color: Colors.grey[500]),
                              const SizedBox(width: 8),
                              Text(
                                'แจ้งเมื่อ: ${item.reportDate}',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}

// --- RepairDetailScreen: Detail View ---
class RepairDetailScreen extends StatelessWidget {
  final RepairHistoryItem item;

  const RepairDetailScreen({super.key, required this.item});

  Color _getStatusColor(String status) {
    switch (status) {
      case 'เสร็จสิ้น':
        return Colors.green;
      case 'กำลังดำเนินการ':
        return Colors.orange;
      case 'รอดำเนินการ':
        return Colors.blueGrey;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'เสร็จสิ้น':
        return Icons.check_circle;
      case 'กำลังดำเนินการ':
        return Icons.hourglass_bottom;
      case 'รอดำเนินการ':
        return Icons.pending_actions;
      default:
        return Icons.info_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          'รายละเอียดแจ้งซ่อม #${item.id}',
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
                      _getStatusIcon(item.status),
                      size: 60,
                      color: _getStatusColor(item.status),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      item.status,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: _getStatusColor(item.status),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item.status == 'เสร็จสิ้น'
                          ? 'งานซ่อมนี้เสร็จสมบูรณ์แล้ว'
                          : item.status == 'กำลังดำเนินการ'
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
                    Icons.event, 'วันที่แจ้ง', item.reportDate, primaryColor),
                _buildInfoTile(
                    Icons.subject, 'เรื่อง', item.title, primaryColor),
                _buildInfoTile(Icons.description, 'รายละเอียดปัญหา',
                    item.problemDetail, primaryColor),
                // Add more original details if needed, e.g., building, room
              ],
            ),
            const SizedBox(height: 16),

            // --- Technician Information ---
            if (item.technicianName != null)
              _buildInfoCard(
                context,
                title: 'ข้อมูลช่างผู้รับผิดชอบ',
                children: [
                  _buildInfoTile(Icons.person, 'ชื่อช่าง',
                      item.technicianName!, primaryColor),
                  _buildInfoTile(Icons.phone, 'เบอร์โทรช่าง',
                      item.technicianPhone!, primaryColor),
                  // Add more technician details if available
                ],
              ),
            if (item.technicianName != null) const SizedBox(height: 16),

            // --- Solution & Images ---
            if (item.solution != null ||
                (item.solutionImagePaths != null &&
                    item.solutionImagePaths!.isNotEmpty))
              _buildInfoCard(
                context,
                title: 'วิธีการแก้ไข',
                children: [
                  if (item.solution != null)
                    _buildInfoTile(
                        Icons.build, 'รายละเอียดการแก้ไข', item.solution!, primaryColor),
                  if (item.solutionImagePaths != null &&
                      item.solutionImagePaths!.isNotEmpty) ...[
                    _buildInfoTile(Icons.photo_library, 'รูปภาพประกอบ', '', primaryColor),
                    const SizedBox(height: 8),
                    // Use a horizontal ListView for multiple images
                    SizedBox(
                      height: 100, // Fixed height for image gallery
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: item.solutionImagePaths!.length,
                        itemBuilder: (context, imgIndex) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.network(
                                item.solutionImagePaths![imgIndex],
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