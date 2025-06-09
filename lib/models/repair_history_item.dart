import 'package:flutter/material.dart';

class RepairHistoryItem {
  final String id;
  // Combine report_date and report_time from API into a single display string
  final String reportDate; // Renamed from report_date to reportDate for consistency with existing UI
  final String reportTime; // New field for report_time from API
  final String reporterName; // Maps to 'name' from API
  final String reporterPhone; // Maps to 'phone' from API
  final String building;
  final String floor;
  final String room;
  final String problemDetail;
  final String? imageUrl; // Changed to single String? from List<String>?
  final String statusText;
  final Color statusColor;
  final IconData? icon;

  // These might be populated later, keeping them nullable
  final String? technicianName;
  final String? technicianPhone;
  final String? solution;
  final List<String>? solutionImagePaths; // Still kept as list for future proofing if API changes

  const RepairHistoryItem({
    required this.id,
    required this.reportDate,
    required this.reportTime,
    required this.reporterName,
    required this.reporterPhone,
    required this.building,
    required this.floor,
    required this.room,
    required this.problemDetail,
    this.imageUrl, // Made nullable
    required this.statusText,
    required this.statusColor,
    this.icon,
    this.technicianName,
    this.technicianPhone,
    this.solution,
    this.solutionImagePaths,
  });

  // Factory constructor to create a RepairHistoryItem from a JSON map
  factory RepairHistoryItem.fromJson(Map<String, dynamic> json) {
    Color statusColor;
    String statusText;
    IconData? icon;
    switch (json['status']) {
      case 'pending':
        statusText = 'รอดำเนินการ';
        statusColor = Colors.orange.shade600;
        icon = Icons.pending_actions;
        break;
      case 'success':
        statusText = 'เสร็จสิ้น';
        statusColor = Colors.green.shade600;
        icon = Icons.check_circle;
        break;
      case 'inprogress':
        statusText = 'กำลังดำเนินการ';
        statusColor = Colors.blue.shade600;
        icon = Icons.hourglass_bottom;
        break;
      default:
        statusText = 'ไม่ทราบสถานะ';
        statusColor = Colors.grey;
        icon = Icons.info_outline;
    }

    return RepairHistoryItem(
      id: json['id'] as String,
      reportDate: json['report_date'] as String,
      reportTime: json['report_time'] as String,
      reporterName: json['name'] as String,
      reporterPhone: json['phone'] as String,
      building: json['building'] as String,
      floor: json['floor'] as String,
      room: json['room'] as String,
      problemDetail: json['problem_detail'] as String,
      // API provides a single image_url, map it to a list for now, or just keep as string
      imageUrl: json['image_url'] as String?,
      statusText: statusText,
      statusColor: statusColor,
      icon: icon,
      // These fields are not in the provided JSON, so they'll be null
      technicianName: null,
      technicianPhone: null,
      solution: null,
      solutionImagePaths: null,
    );
  }

  // Added a getter to construct the title for display
  String get displayTitle {
    return '${problemDetail.length > 30 ? problemDetail.substring(0, 30) + '...' : problemDetail}';
  }

  // Helper for full report date and time
  String get fullReportDateTime {
    return '$reportDate, $reportTime';
  }

  // Helper for place display
  String get displayPlace {
    return 'อาคาร $building ชั้น $floor ห้อง $room';
  }
}