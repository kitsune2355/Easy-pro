import 'package:easy_pro/models/recent_activity.dart';
import 'package:easy_pro/services/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../services/api_service.dart';

class RepairController {
  static Future<bool> submitRepairRequest({
    required String name,
    required String phone,
    required String building,
    required String floor,
    required String room,
    required String problemDetail,
    required String reportDate,
    required String reportTime,
    XFile? image,
    required BuildContext context,
  }) async {
    // เตรียมข้อมูล text fields
    final Map<String, String> fields = {
      'name': name,
      'phone': phone,
      'building': building,
      'floor': floor,
      'room': room,
      'problemDetail': problemDetail,
      'reportDate': reportDate,
      'reportTime': reportTime,
      // สามารถเพิ่ม reportChannel, serviceType, jobType ตรงนี้ได้หากมีใน UI
    };

    try {
      final response = await ApiService.postMultipart(
        'submit_repair.php', // Endpoint ของ PHP Script ที่จะจัดการข้อมูล
        fields: fields,
        file: image,
        fileFieldName: 'image', // ต้องตรงกับชื่อ $_FILES ใน PHP
      );

      if (response != null && response is Map<String, dynamic>) {
        if (response['status'] == 'success') {
          // *** รับ repair_id จากการตอบกลับของ API ***
          final int? repairId = response['repair_id'] as int?;

          if (repairId == null) {
            print('API Error: Missing repair_id in response');
            return false; // หรือจัดการข้อผิดพลาดตามความเหมาะสม
          }

          final notificationService = Provider.of<NotificationService>(context, listen: false);
          notificationService.addNotification(
            NotificationItem(
              // *** ใช้ repairId.toString() เป็น id ของ NotificationItem ***
              id: repairId.toString(), // ใช้ ID ที่ได้จาก backend
              user_id: 'i', // หรือ user_id ของผู้ใช้ที่แจ้งซ่อมจริง
              type: 'repair_request',
              title: 'แจ้งซ่อมใหม่จากคุณ $name',
              desc: problemDetail,
              building: building,
              floor: floor,
              room: room,
              relatedId: repairId, // ส่ง repairId ไปที่ relatedId ด้วย
              isRead: false,
              createdAt: DateTime.now(),
            ),
          );
          return true;
        } else {
          // หาก backend ตอบกลับมาว่าไม่สำเร็จ พร้อมข้อความ error
          print('API Error: ${response['message']}');
          return false;
        }
      }
    } catch (e) {
      print('Error submitting repair request: $e');
    }
    return false;
  }
}

class RepairAllController {

  // เมธอดสำหรับเข้าสู่ระบบ (อันเดิมของคุณ)
  static Future<bool> login(String username, String password) async {
    final response = await ApiService.post(
      'login.php', // เปลี่ยนชื่อไฟล์เป็น login.php ถ้ามี
      body: {'username': username, 'password': password},
    );

    if (response is Map && response.containsKey('status')) {
      if (response['status'] == 'success') {
        return true;
      }
    }
    return false;
  }

  // --- เมธอดใหม่สำหรับดึงข้อมูลการซ่อมแซมทั้งหมด ---
  static Future<List<RecentActivity>> fetchAllRepairs() async {
    try {
      final responseData = await ApiService.get('get_all_repair_requests.php'); // ใช้เมธอด GET

      if (responseData is Map && responseData.containsKey('status')) {
        if (responseData['status'] == 'success') {
          final List<dynamic> data = responseData['data'];
          // แปลง List<dynamic> เป็น List<RecentActivity>
          return data.map((json) => RecentActivity.fromJson(json)).toList();
        } else {
          // กรณี API คืนค่า status เป็น error
          throw Exception(responseData['message'] ?? 'Failed to fetch all repairs from API.');
        }
      } else {
        // กรณี responseData ไม่เป็น Map หรือไม่มี key 'status'
        throw Exception('Invalid response format from API.');
      }
    } catch (e) {
      // ดักจับข้อผิดพลาดที่เกิดขึ้นระหว่างการเรียก API
      throw Exception('Error fetching all repairs: $e');
    }
  }
}