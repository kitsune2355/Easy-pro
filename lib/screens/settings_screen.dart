import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      backgroundColor: Colors.grey[100], // Consistent subtle background
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0), // Overall padding
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // --- General Settings Section ---
            _buildSettingsCard(
              context,
              title: 'ทั่วไป',
              children: [
                _buildSettingsTile(
                  context,
                  icon: Icons.language,
                  label: 'ภาษา',
                  trailing: const Text('ไทย'),
                  onTap: () {
                    // TODO: Implement language change
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('เปลี่ยนภาษา')),
                    );
                  },
                ),
                _buildSettingsTile(
                  context,
                  icon: Icons.notifications_active_outlined,
                  label: 'การแจ้งเตือน',
                  onTap: () {
                    // TODO: Navigate to notification settings details
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('ตั้งค่าการแจ้งเตือน')),
                    );
                  },
                ),
                // Example with a Switch
                _buildSettingsTile(
                  context,
                  icon: Icons.dark_mode_outlined,
                  label: 'โหมดมืด',
                  trailing: Switch(
                    value: false, // Replace with actual theme setting
                    onChanged: (bool value) {
                      // TODO: Implement theme change logic
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('เปิด/ปิด โหมดมืด: $value')),
                      );
                    },
                    activeColor: primaryColor,
                  ),
                  onTap: () {
                    // Handle tap on the whole tile
                    // Often, the switch handles the main action
                  },
                ),
              ],
            ),
            const SizedBox(height: 16), // Spacing between cards

            // --- Account Settings Section ---
            _buildSettingsCard(
              context,
              title: 'บัญชี',
              children: [
                _buildSettingsTile(
                  context,
                  icon: Icons.person_outline,
                  label: 'ข้อมูลส่วนตัว',
                  onTap: () {
                    // TODO: Navigate to personal info screen
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('ดูข้อมูลส่วนตัว')),
                    );
                  },
                ),
                _buildSettingsTile(
                  context,
                  icon: Icons.lock_outline,
                  label: 'เปลี่ยนรหัสผ่าน',
                  onTap: () {
                    // TODO: Navigate to change password screen
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('เปลี่ยนรหัสผ่าน')),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),

            // --- About Section ---
            _buildSettingsCard(
              context,
              title: 'เกี่ยวกับ',
              children: [
                _buildSettingsTile(
                  context,
                  icon: Icons.info_outline,
                  label: 'เวอร์ชันแอป',
                  trailing: const Text('1.0.0'),
                  onTap: () {
                    // Show dialog with app info
                    showAboutDialog(
                      context: context,
                      applicationName: 'EasyPro',
                      applicationVersion: '1.0.0',
                      applicationIcon: Icon(Icons.build_circle, color: primaryColor),
                      children: [
                        const Text('แอปพลิเคชันสำหรับแจ้งซ่อมและติดตามสถานะ'),
                      ],
                    );
                  },
                ),
                _buildSettingsTile(
                  context,
                  icon: Icons.policy_outlined,
                  label: 'นโยบายความเป็นส่วนตัว',
                  onTap: () {
                    // TODO: Navigate to privacy policy
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('ดูนโยบายความเป็นส่วนตัว')),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  /// Reusable widget to build a card section for settings.
  Widget _buildSettingsCard(
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

  /// Reusable widget to build a single settings option tile.
  Widget _buildSettingsTile(
    BuildContext context, {
    required IconData icon,
    required String label,
    Widget? trailing,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: Theme.of(context).primaryColor, size: 28),
          title: Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
          trailing: trailing ??
              Icon(Icons.arrow_forward_ios,
                  size: 18, color: Colors.grey[500]), // Default arrow icon
          onTap: onTap,
          contentPadding: EdgeInsets.zero, // Remove default padding
          visualDensity: VisualDensity.compact, // Make it a bit more compact
        ),
        // Add a subtle divider between list tiles, but not after the last one in a group
        if (trailing == null || trailing is! Switch) // Don't add divider if it's a switch
          const Divider(height: 0, indent: 56), // Indent to align with text
      ],
    );
  }
}