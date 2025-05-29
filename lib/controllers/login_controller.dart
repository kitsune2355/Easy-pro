import '../services/api_service.dart';

class LoginController {
  static Future<bool> login(String username,String password) async {
    final response = await ApiService.post(
      'login.php',
      body: {'username': username, 'password': password},
    );

    if (response is List && response.isNotEmpty) {
      final first = response[0];

      if (first['status'] == 'success') {
        return true;
      }
    }
    return false;
  }
}
