import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Access the theme's primary color for consistency
    final Color primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      backgroundColor: Colors.grey[100], // A subtle background color
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0), // Overall padding
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // --- Profile Header Section ---
            Card(
              elevation: 4, // More pronounced shadow
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              margin: const EdgeInsets.only(bottom: 24.0),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50, // Larger avatar
                      backgroundColor: primaryColor.withOpacity(0.2), // Light background
                      child: Icon(
                        Icons.person,
                        size: 60,
                        color: primaryColor, // Icon color matches theme
                      ),
                      // You can use a NetworkImage or AssetImage here for a real profile picture
                      // backgroundImage: NetworkImage('URL_TO_PROFILE_PIC'),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'สมชาย ใจดี', // User's name
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[850],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'ช่างซ่อม • รหัสพนักงาน: 123456789', // Role and ID
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: () {
                        // TODO: Implement edit profile action
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('แก้ไขโปรไฟล์ (ยังไม่พร้อมใช้งาน)'),
                          ),
                        );
                      },
                      icon: const Icon(Icons.edit, size: 20),
                      label: const Text('แก้ไขโปรไฟล์'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor, // Button color
                        foregroundColor: Colors.white, // Text color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                        textStyle: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // --- Contact Information Section ---
            _buildInfoCard(
              context,
              title: 'ข้อมูลติดต่อ',
              children: [
                _buildInfoTile(
                    Icons.phone, 'เบอร์โทรศัพท์', '081-234-5678', primaryColor),
                _buildInfoTile(
                    Icons.email, 'อีเมล', 'somchai.j@example.com', primaryColor),
                _buildInfoTile(
                    Icons.location_on, 'ที่อยู่', '123 ถนนสุขุมวิท, กรุงเทพฯ', primaryColor),
              ],
            ),
            const SizedBox(height: 16), // Spacing between cards

            // --- Other Information Section ---
            _buildInfoCard(
              context,
              title: 'ข้อมูลอื่น ๆ',
              children: [
                _buildInfoTile(Icons.work, 'แผนก', 'บำรุงรักษาอาคาร', primaryColor),
                _buildInfoTile(Icons.calendar_today, 'วันที่เริ่มงาน', '01 มกราคม 2560', primaryColor),
                // Add more relevant information here
              ],
            ),
            const SizedBox(height: 16), // Spacing at the bottom
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