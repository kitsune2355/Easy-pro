// lib/services/repair_service.dart
import 'package:easy_pro/models/recent_activity.dart';
import 'package:easy_pro/services/api_service.dart';

class RepairService {
  // เมธอดสำหรับเข้าสู่ระบบ (ใช้ ApiService.post)
  static Future<bool> login(String username, String password) async {
    try {
      final response = await ApiService.post(
        'login.php', // ตรวจสอบชื่อไฟล์ PHP สำหรับ login
        body: {'username': username, 'password': password},
      );

      if (response is Map && response.containsKey('status')) {
        if (response['status'] == 'success') {
          return true;
        }
      }
      return false;
    } catch (e) {
      print('Login error: $e');
      return false;
    }
  }

  // เมธอดสำหรับดึงข้อมูลการซ่อมแซมทั้งหมด (ใช้ ApiService.get)
  static Future<List<RecentActivity>> fetchAllRepairRequests() async {
    try {
      final responseData = await ApiService.get('get_all_repair.php'); // ใช้ endpoint ของคุณ

      if (responseData is Map && responseData.containsKey('status')) {
        if (responseData['status'] == 'success') {
          final List<dynamic> data = responseData['data'];
          return data.map((json) => RecentActivity.fromJson(json)).toList();
        } else {
          throw Exception(responseData['message'] ?? 'Failed to load repair requests from API.');
        }
      } else {
        throw Exception('Invalid response format from API.');
      }
    } catch (e) {
      throw Exception('Error fetching all repair requests: $e');
    }
  }

  // เพิ่มเมธอดอื่นๆ ที่เกี่ยวข้องกับการซ่อมแซมได้ที่นี่
  // เช่น submitRepairRequest, getRepairRequestById, updateRepairStatus
}