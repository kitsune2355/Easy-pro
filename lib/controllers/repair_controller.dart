import 'package:image_picker/image_picker.dart';
import '../services/api_service.dart';

class RepairController {
  static Future<bool> submitRepairRequest({
    required String name,
    required String phone,
    required String building,
    required String floor,
    required String room,
    required String problemDetail,
    required String reportDate,
    required String reportTime,
    XFile? image, // Optional image file
  }) async {
    // เตรียมข้อมูล text fields
    final Map<String, String> fields = {
      'name': name,
      'phone': phone,
      'building': building,
      'floor': floor,
      'room': room,
      'problemDetail': problemDetail,
      'reportDate': reportDate,
      'reportTime': reportTime,
      // สามารถเพิ่ม reportChannel, serviceType, jobType ตรงนี้ได้หากมีใน UI
    };

    try {
      final response = await ApiService.postMultipart(
        'submit_repair.php', // Endpoint ของ PHP Script ที่จะจัดการข้อมูล
        fields: fields,
        file: image,
        fileFieldName: 'image', // ต้องตรงกับชื่อ $_FILES ใน PHP
      );

      if (response != null && response is Map<String, dynamic>) {
        if (response['status'] == 'success') {
          return true;
        } else {
          // หาก backend ตอบกลับมาว่าไม่สำเร็จ พร้อมข้อความ error
          print('API Error: ${response['message']}');
          return false;
        }
      }
    } catch (e) {
      print('Error submitting repair request: $e');
    }
    return false;
  }
}