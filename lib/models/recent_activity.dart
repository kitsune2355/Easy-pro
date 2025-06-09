import 'package:flutter/material.dart'; // Import for Colors

class RecentActivity {
  final String date;
  final String title;
  final String detail;
  final String status;
  final String time;
  final Color statusColor;
  final String? building;
  final String? floor;
  final String? room;

  RecentActivity({
    required this.date,
    required this.title,
    required this.detail,
    required this.status,
    required this.time,
    required this.statusColor,
    this.building,
    this.floor,
    this.room,
  });

  factory RecentActivity.fromJson(Map<String, dynamic> json) {
    Color statusColor;
    String statusText;
    switch (json['status']) {
      case 'pending':
        statusText = 'รอดำเนินการ';
        statusColor = Colors.orange.shade600;
        break;
      case 'success':
        statusText = 'เสร็จสิ้น';
        statusColor = Colors.green.shade600;
        break;
      case 'inprogress':
        statusText = 'กำลังดำเนินการ';
        statusColor = Colors.blue.shade600;
        break;
      default:
        statusText = 'ไม่ทราบสถานะ';
        statusColor = Colors.grey;
    }

    // Assuming your PHP returns 'report_date' and 'report_time'
    String date = json['report_date'] ?? '';
    String time = json['report_time'] ?? '';

    return RecentActivity(
      date: date,
      title: json['problem_detail'] ?? 'ไม่มีรายละเอียด',
      detail: json['problem_detail'] ?? 'ไม่มีรายละเอียด',
      status: statusText ?? 'pending',
      time: time,
      statusColor: statusColor,
      building: json['building'],
      floor: json['floor'],
      room: json['room'],
    );
  }
}
