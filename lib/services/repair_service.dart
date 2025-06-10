import 'package:easy_pro/models/repair_history_item.dart';
import 'package:easy_pro/services/api_service.dart';
import 'package:flutter/material.dart';

// เปลี่ยน RepairService ให้เป็น ChangeNotifier
class RepairService extends ChangeNotifier {
  // เมธอด login อาจจะยังคงเป็น static ก็ได้หากไม่ได้จัดการ state ที่เกี่ยวข้องกับ Provider
  static Future<bool> login(String username, String password) async {
    try {
      final response = await ApiService.post(
        'login.php',
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

  List<RepairHistoryItem> _allRepairRequests = [];
  List<RepairHistoryItem> get allRepairRequests => _allRepairRequests; // Getter สำหรับข้อมูล

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  // ลบ static ออกจาก fetchAllRepairRequests
  Future<void> fetchAllRepairRequests() async {
    _isLoading = true;
    _error = null;
    notifyListeners(); // แจ้งเตือนว่ากำลังโหลด

    try {
      final responseData = await ApiService.get('get_all_repair.php');

      if (responseData is Map && responseData.containsKey('status')) {
        if (responseData['status'] == 'success') {
          final List<dynamic> data = responseData['data'];
          _allRepairRequests = data.map((json) => RepairHistoryItem.fromJson(json)).toList();
        } else {
          _error = responseData['message'] ?? 'Failed to load repair requests from API.';
          throw Exception(_error); // โยน Exception เพื่อให้ catch block จัดการ
        }
      } else {
        _error = 'Invalid response format from API.';
        throw Exception(_error); // โยน Exception เพื่อให้ catch block จัดการ
      }
    } catch (e) {
      _error = e.toString().replaceFirst('Exception: ', '');
      _allRepairRequests = []; // ล้างข้อมูลหากเกิดข้อผิดพลาด
    } finally {
      _isLoading = false;
      notifyListeners(); // แจ้งเตือนเมื่อการโหลดเสร็จสิ้น (ไม่ว่าจะสำเร็จหรือล้มเหลว)
    }
  }

  Future<RepairHistoryItem?> fetchRepairItemById(int id) async {
  _isLoading = true;
  _error = null;
  notifyListeners(); // แจ้งให้ UI อัปเดต (ถ้ามีตัวแสดงสถานะโหลด)

  try {
    final responseData = await ApiService.get('get_repair_by_id.php?id=$id');

    if (responseData is Map && responseData.containsKey('status')) {
      if (responseData['status'] == 'success' && responseData.containsKey('data')) {
        // แปลง JSON เป็น RepairHistoryItem
        final item = RepairHistoryItem.fromJson(responseData['data']);
        return item;
      } else {
        _error = responseData['message'] ?? 'ไม่สามารถโหลดข้อมูลแจ้งซ่อมจาก API ได้';
        throw Exception(_error);
      }
    } else {
      _error = 'รูปแบบข้อมูลที่ตอบกลับไม่ถูกต้อง';
      throw Exception(_error);
    }
  } catch (e) {
    _error = e.toString().replaceFirst('Exception: ', '');
    return null;
  } finally {
    _isLoading = false;
    notifyListeners();
  }
}

}