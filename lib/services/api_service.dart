import 'dart:convert';
import 'dart:io'; // Import for File
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart'; // Import for XFile
import '../config/api_config.dart';

class ApiService {
  // สำหรับการส่งข้อมูลแบบ JSON (เหมือนเดิม)
  static Future<dynamic> post(
    String endpoint, {
    Map<String, String>? body,
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
      // อาจจะ log ข้อผิดพลาดหรือจัดการได้ดีกว่านี้
      print('Error in ApiService.post: ${response.statusCode} - ${response.body}');
      throw Exception('Failed to connect to server: ${response.statusCode}');
    }
  }

  // เพิ่มเมธอดสำหรับส่งข้อมูลแบบ multipart (สำหรับอัปโหลดไฟล์)
  static Future<dynamic> postMultipart(
    String endpoint, {
    required Map<String, String> fields, // ข้อมูล text fields
    XFile? file, // ไฟล์รูปภาพ (optional)
    String fileFieldName = 'image', // ชื่อ field สำหรับไฟล์ใน PHP ($_FILES['image'])
  }) async {
    final url = Uri.parse('${ApiConfig.baseUrl}/$endpoint');
    var request = http.MultipartRequest('POST', url);

    // เพิ่ม text fields ทั้งหมด
    request.fields.addAll(fields);

    // เพิ่มไฟล์ถ้ามี
    if (file != null) {
      request.files.add(await http.MultipartFile.fromPath(
        fileFieldName,
        file.path,
        filename: file.name,
      ));
    }

    try {
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print('Error in ApiService.postMultipart: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to upload data: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception in ApiService.postMultipart: $e');
      throw Exception('Network error or server unreachable');
    }
  }
}