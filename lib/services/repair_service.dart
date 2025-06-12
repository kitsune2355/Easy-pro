import 'package:easy_pro/models/repair_history_item.dart';
import 'package:easy_pro/services/api_service.dart';
import 'package:flutter/material.dart';

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

  /// Fetches repair requests that are currently in 'pending' status,
  /// meaning they are awaiting acceptance by a technician.
  Future<List<RepairHistoryItem>> getPendingRepairRequests() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Assuming you have an API endpoint to get pending jobs
      // You might need to filter 'allRepairRequests' locally or
      // have a specific API endpoint for 'pending' jobs.
      // For demonstration, let's filter from allRepairRequests if available.
      // In a real app, a dedicated API for pending jobs is better for performance.
      await fetchAllRepairRequests(); // First, ensure all requests are fetched/updated

      // Filter for pending status (you'll define what 'pending' means based on your RepairHistoryItem model)
      // For example, if statusText for pending is 'รอดำเนินการ'
      final List<RepairHistoryItem> pendingJobs = _allRepairRequests
          .where((item) => item.statusText == 'รอดำเนินการ' || item.statusText == 'รอรับงาน') // Adjust status based on your actual data
          .toList();

      return pendingJobs;
    } catch (e) {
      _error = 'Failed to fetch pending repair requests: ${e.toString()}';
      notifyListeners();
      return [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Accepts a repair request, changing its status and setting the work date.
  /// This is typically called after Step 1 in AcceptJobScreen.
  Future<bool> acceptRepairRequest(int repairId, DateTime workDate) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await ApiService.post(
        'accept_repair.php', // Your API endpoint for accepting jobs
        body: {
          'repair_id': repairId.toString(),
          'work_date': workDate.toIso8601String().split('T').first, // Format to YYYY-MM-DD
        },
      );

      if (response is Map && response.containsKey('status')) {
        if (response['status'] == 'success') {
          // Optionally, update the local list to reflect the status change
          final index = _allRepairRequests.indexWhere((item) => item.id == repairId);
          if (index != -1) {
            // Assuming your RepairHistoryItem has a way to update status/workDate
            // You might need to refetch the item or manually update its properties
            // For now, let's just trigger a re-fetch of all requests to ensure consistency.
            await fetchAllRepairRequests();
          }
          notifyListeners();
          return true;
        } else {
          _error = response['message'] ?? 'Failed to accept repair request.';
          throw Exception(_error);
        }
      } else {
        _error = 'Invalid response format when accepting repair.';
        throw Exception(_error);
      }
    } catch (e) {
      _error = e.toString().replaceFirst('Exception: ', '');
      notifyListeners();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Completes a repair request, adding repair details and image paths.
  /// This is typically called after Step 3 in AcceptJobScreen.
  Future<bool> completeRepair(
    int repairId,
    DateTime workDate, // You might still pass this if you want to confirm it on completion
    String repairDetails,
    List<String> imagePaths, // These would be file paths or base64 encoded strings
  ) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // In a real application, you'd upload images first and then send their URLs
      // or send images as base64 encoded strings along with other data.
      // For this example, we'll assume imagePaths are ready to be sent or are just references.
      final response = await ApiService.post(
        'complete_repair.php', // Your API endpoint for completing jobs
        body: {
          'repair_id': repairId.toString(),
          'work_date': workDate.toIso8601String().split('T').first, // Ensure correct format
          'repair_details': repairDetails,
          'image_paths': imagePaths.join(','), // Simple join for demonstration, adjust as per API
          // If you need to send actual image files, you'll use a multipart request
          // and may need a separate method in ApiService for file uploads.
        },
      );

      if (response is Map && response.containsKey('status')) {
        if (response['status'] == 'success') {
          // Update the local list to reflect the completed status
          final index = _allRepairRequests.indexWhere((item) => item.id == repairId);
          if (index != -1) {
            // For example, if your RepairHistoryItem has a status field
            // _allRepairRequests[index].status = 'Completed';
            // _allRepairRequests[index].statusText = 'เสร็จสิ้น';
            // It's often safer to re-fetch to ensure data consistency from the server.
            await fetchAllRepairRequests();
          }
          notifyListeners();
          return true;
        } else {
          _error = response['message'] ?? 'Failed to complete repair request.';
          throw Exception(_error);
        }
      } else {
        _error = 'Invalid response format when completing repair.';
        throw Exception(_error);
      }
    } catch (e) {
      _error = e.toString().replaceFirst('Exception: ', '');
      notifyListeners();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}