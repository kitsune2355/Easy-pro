import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import '../config/api_config.dart';

class ApiService {
  // --- เมธอด GET สำหรับดึงข้อมูล ---
  static Future<dynamic> get(String endpoint) async {
    final url = Uri.parse('${ApiConfig.baseUrl}/$endpoint');
    try {
      final response = await http.get(
        url,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print(
          'Error in ApiService.get: ${response.statusCode} - ${response.body}',
        );
        throw Exception(
          'Failed to load data: Server responded with status ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Exception in ApiService.get: $e');
      throw Exception('Network error or server unreachable: $e');
    }
  }

  // --- สำหรับการส่งข้อมูลแบบ JSON ---
  static Future<dynamic> post(
    String endpoint, {
    Map<String, dynamic>?
    body, // เปลี่ยนเป็น dynamic เพื่อความยืดหยุ่น (หรือ Map<String, String> หากยืนยัน)
  }) async {
    final url = Uri.parse('${ApiConfig.baseUrl}/$endpoint');
    final response = await http.post(
      url,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print(
        'Error in ApiService.post: ${response.statusCode} - ${response.body}',
      );
      throw Exception('Failed to connect to server: ${response.statusCode}');
    }
  }

  // --- เมธอดสำหรับส่งข้อมูลแบบ multipart (สำหรับอัปโหลดไฟล์) ---
  static Future<dynamic> postMultipart(
    String endpoint, {
    required Map<String, String> fields,
    XFile? file,
    String fileFieldName = 'image',
  }) async {
    final url = Uri.parse('${ApiConfig.baseUrl}/$endpoint');
    var request = http.MultipartRequest('POST', url);

    request.fields.addAll(fields);

    if (file != null) {
      request.files.add(
        await http.MultipartFile.fromPath(
          fileFieldName,
          file.path,
          filename: file.name,
        ),
      );
    }

    try {
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print(
          'Error in ApiService.postMultipart: ${response.statusCode} - ${response.body}',
        );
        throw Exception('Failed to upload data: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception in ApiService.postMultipart: $e');
      throw Exception('Network error or server unreachable');
    }
  }
}
