import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';

class ApiService {
  static Future<dynamic> post(String endpoint, {Map<String, String>? body}) async {
    final url = Uri.parse('${ApiConfig.baseUrl}/$endpoint');
    final response = await http.post(url, body: body);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to connect to server');
    }
  }
}
