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