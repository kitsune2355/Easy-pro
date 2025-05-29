import '../services/api_service.dart';

class LoginController {
  static Future<bool> login(String username, String password) async {
    final response = await ApiService.post(
      'login.php',
      body: {'username': username, 'password': password},
    );

    if (response['status'] == 'success') {
      // บันทึก token หรือข้อมูลผู้ใช้
      return true;
    } else {
      return false;
    }
  }
}
