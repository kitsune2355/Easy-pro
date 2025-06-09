import 'package:flutter/material.dart';
import 'package:easy_pro/services/notification_service.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  String? _currentUserId; // ID ของผู้ใช้ที่เข้าสู่ระบบ

  @override
  void initState() {
    super.initState();
    // **ตัวอย่างการดึง user ID:** (คุณต้องปรับใช้ตามโครงสร้างโปรเจกต์ของคุณ)
    // สำหรับการทดสอบเบื้องต้น คุณสามารถกำหนด user ID ตรงนี้ได้
    _currentUserId = 'i'; // **เปลี่ยนเป็น user ID ที่คุณต้องการทดสอบ**

    // ดึงการแจ้งเตือนครั้งแรกเมื่อหน้าจอเริ่มต้น
    _fetchNotifications();
  }

  // เมธอดสำหรับเรียกใช้ fetchNotifications จาก NotificationService
  Future<void> _fetchNotifications() async {
    // ใช้ listen: false เพราะเราเรียกใช้ใน initState และใน _onRefresh
    await Provider.of<NotificationService>(context, listen: false).fetchNotifications(userId: _currentUserId);
  }

  // เมธอดที่จะถูกเรียกเมื่อผู้ใช้ดึงลงเพื่อรีเฟรช
  Future<void> _onRefresh() async {
    await _fetchNotifications();
  }

  @override
  Widget build(BuildContext context) {
    // Watch the NotificationService for changes to the list of notifications
    final notificationService = Provider.of<NotificationService>(context);
    // Filter notifications based on the current user ID and sort by createdAt
    final notifications = notificationService.notifications
        .where((notification) => notification.user_id == _currentUserId)
        .toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt)); // Sort in descending order

    return Scaffold(
      body: notifications.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.notifications_none, size: 32, color: Colors.grey.shade400),
                  const SizedBox(height: 10),
                  Text(
                    'คุณยังไม่มีการแจ้งเตือนใหม่',
                    style: TextStyle(fontSize: 16, color: Colors.grey.shade500),
                  ),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: _onRefresh,
              child: ListView.builder(
                padding: const EdgeInsets.all(8.0),
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  final notification = notifications[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 4.0),
                    elevation: notification.isRead ? 0.5 : 2,
                    // **Change background color based on isRead status**
                    color: notification.isRead
                        ? Colors.white // White if read
                        : const Color.fromARGB(255, 241, 249, 255), // Light blue if unread
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: notification.isRead ? BorderSide(color: Colors.grey.shade200) : BorderSide.none,
                    ),
                    child: ListTile(
                      leading: Icon(
                        _getNotificationIcon(notification.type),
                        color: notification.isRead ? Colors.grey : Theme.of(context).primaryColor,
                      ),
                      title: Text(
                        '${notification.title} ${notification.desc}',
                        style: TextStyle(
                          fontWeight: notification.isRead ? FontWeight.normal : FontWeight.bold,
                          color: notification.isRead ? Colors.grey.shade700 : Colors.black87,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'อาคาร ${notification.building ?? 'ไม่ระบุ'} ชั้น ${notification.floor ?? 'ไม่ระบุ'} ห้อง ${notification.room ?? 'ไม่ระบุ'}',
                            style: TextStyle(
                              color: notification.isRead ? Colors.grey.shade600 : Colors.black54,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            DateFormat('d MMMM y, HH:mm', 'th').format(notification.createdAt),
                            style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                          ),
                        ],
                      ),
                      trailing: notification.isRead
                          ? null
                          : Icon(Icons.circle, size: 12, color: Colors.cyan),
                      onTap: () {
                        // Mark the specific notification as read by its ID
                        notificationService.markAsRead(notification.user_id); 
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Clicked on notification: ${notification.title}')),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
    );
  }

  IconData _getNotificationIcon(String type) {
    switch (type) {
      case 'repair_request':
        return Icons.build;
      case 'status_update':
        return Icons.info;
      default:
        return Icons.notifications;
    }
  }
}