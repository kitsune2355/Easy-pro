import '../services/api_service.dart';

class LoginController {
  static Future<bool> login(String username) async {
    final response = await ApiService.post(
      'login.php',
      // body: {'username': username, 'password': password},
      body: {'username': username},
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
