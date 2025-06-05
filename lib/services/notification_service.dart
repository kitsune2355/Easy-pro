import 'package:easy_pro/config/api_config.dart';
import 'package:flutter/material.dart';
import 'dart:convert'; // For JSON encoding/decoding
import 'package:http/http.dart' as http; // For making HTTP requests

// Class to represent a single notification item
class NotificationItem {
  final String id;
  final String user_id;
  final String type;
  final String title;
  final String desc;
  final String building;
  final String floor;
  final String room;
  final int? relatedId; // repair_request_id
  bool isRead;
  final DateTime createdAt;

  NotificationItem({
    required this.id,
    required this.user_id,
    required this.type,
    required this.title,
    required this.desc,
    required this.building,
    required this.floor,
    required this.room,
    this.relatedId,
    this.isRead = false,
    required this.createdAt,
  });

  // Factory constructor to create a NotificationItem from JSON
  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    return NotificationItem(
      id: json['id'].toString(),
      user_id: json['user_id'],
      type: json['type'],
      title: json['title'],
      desc: json['desc'],
      building: json['building'],
      floor: json['floor'],
      room: json['room'],
      relatedId: json['related_id'] as int?,
      isRead: json['is_read'] == 1 || json['is_read'] == true, // Handle boolean from DB
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}

class NotificationService extends ChangeNotifier {
  List<NotificationItem> _notifications = [];

  static const String _baseUrl = ApiConfig.baseUrl;

  List<NotificationItem> get notifications => _notifications;

  int get unreadNotificationCount =>
      _notifications.where((n) => !n.isRead).length;

  Future<void> fetchNotifications({String? userId}) async {
    try {
      String url = '$_baseUrl/get_notifications.php';
      if (userId != null) {
        url += '?user_id=$userId'; // เพิ่ม user_id เข้าไปใน URL
      }
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData['success'] == true) {
          final List<dynamic> notificationData = responseData['data'];
          _notifications = notificationData
              .map((json) => NotificationItem.fromJson(json))
              .toList();
          notifyListeners();
        } else {
          print('Failed to fetch notifications: ${responseData['message']}');
        }
      } else {
        print('Failed to load notifications. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching notifications: $e');
    }
  }

  // Method to mark a notification as read
  // พารามิเตอร์ notificationIdToMark คือ ID ที่ไม่ซ้ำกันของการแจ้งเตือน (int ที่แปลงเป็น String)
  Future<void> markAsRead(String notificationIdToMark) async {
    // ค้นหาการแจ้งเตือนจาก id ที่ไม่ซ้ำกัน
    final index = _notifications.indexWhere((n) => n.id == notificationIdToMark);
    
    if (index != -1 && !_notifications[index].isRead) {
      // อัปเดตสถานะใน UI ทันทีเพื่อประสบการณ์ผู้ใช้ที่ดีขึ้น
      _notifications[index].isRead = true;
      notifyListeners();

      // เรียก API เพื่ออัปเดตสถานะใน Backend
      try {
        final response = await http.post(
          Uri.parse('$_baseUrl/mark_notification_as_read.php'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          // ส่ง 'notification_id' พร้อมค่า ID ที่ได้จากการแจ้งเตือน
          body: jsonEncode(<String, String>{
            'notification_id': notificationIdToMark, // ส่ง ID ที่ไม่ซ้ำกันของการแจ้งเตือน
          }),
        );

        if (response.statusCode == 200) {
          final Map<String, dynamic> responseData = json.decode(response.body);
          print(responseData);
          if (responseData['success'] == true) {
            print('Notification $notificationIdToMark marked as read in backend.');
          } else {
            print('Failed to mark notification $notificationIdToMark as read in backend: ${responseData['message']}');
            // หากเกิดข้อผิดพลาด ให้เปลี่ยนสถานะกลับใน UI
            _notifications[index].isRead = false;
            notifyListeners();
          }
        } else {
          print('Failed to mark notification $notificationIdToMark as read. Status code: ${response.statusCode}');
          // หากเกิดข้อผิดพลาด ให้เปลี่ยนสถานะกลับใน UI
          _notifications[index].isRead = false;
          notifyListeners();
        }
      } catch (e) {
        print('Error marking notification $notificationIdToMark as read: $e');
        // หากเกิดข้อผิดพลาด ให้เปลี่ยนสถานะกลับใน UI
        _notifications[index].isRead = false;
        notifyListeners();
      }
    }
  }

  void addNotification(NotificationItem newNotification) {
    _notifications.insert(0, newNotification); // Add to the top
    notifyListeners();
  }
}