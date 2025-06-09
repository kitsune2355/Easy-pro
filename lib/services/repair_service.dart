import 'package:easy_pro/models/repair_history_item.dart'; // Import the new class
import 'package:easy_pro/services/api_service.dart';

class RepairService {
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

  static Future<List<RepairHistoryItem>> fetchAllRepairRequests() async {
    try {
      final responseData = await ApiService.get('get_all_repair.php');

      if (responseData is Map && responseData.containsKey('status')) {
        if (responseData['status'] == 'success') {
          final List<dynamic> data = responseData['data'];
          return data.map((json) => RepairHistoryItem.fromJson(json)).toList();
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
}