import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io'; // Import for File operations
import 'package:intl/intl.dart'; // Import for date formatting
import 'package:intl/date_symbol_data_local.dart'; // Import for locale-specific date symbols

class RepairScreen extends StatefulWidget {
  const RepairScreen({super.key});

  @override
  State<RepairScreen> createState() => _RepairScreenState();
}

class _RepairScreenState extends State<RepairScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _problemDetailController = TextEditingController();

  // Fields
  DateTime? _reportDate;
  TimeOfDay? _reportTime;
  DateTime? _repairDate;
  String? _reportChannel;
  String? _serviceType;
  String? _jobType;
  String? _building;
  String? _floor;
  String? _room;
  XFile? _image;

  // Sample dropdown values
  final _channels = ['โทรศัพท์', 'แอปพลิเคชัน', 'หน้าเคาน์เตอร์'];
  final _services = ['ซ่อมแซม', 'ติดตั้ง'];
  final _jobs = ['ไฟฟ้า', 'ประปา', 'ทั่วไป'];
  final _buildings = ['A', 'B', 'C'];
  final _floors = ['1', '2', '3'];
  final _rooms = ['101', '102', '103'];

  @override
  void initState() {
    super.initState();
    // Initialize date symbols for Thai locale
    initializeDateFormatting('th', null).then((_) {
      setState(() {
        // You might want to set initial dates/times here if needed
      });
    });
  }

  Future<void> _pickDate(BuildContext context, void Function(DateTime) onPicked) async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).primaryColor, // Header background color
              onPrimary: Colors.white, // Header text color
              onSurface: Colors.black, // Body text color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).primaryColor, // Button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (date != null) onPicked(date);
  }

  Future<void> _pickTime(BuildContext context) async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).primaryColor, // Header background color
              onPrimary: Colors.white, // Header text color
              onSurface: Colors.black, // Body text color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).primaryColor, // Button text color
              ),
            ),
          ),
          child: MediaQuery( // Wrap with MediaQuery to ensure 24-hour format can be applied
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
            child: child!,
          ),
        );
      },
    );
    if (time != null) setState(() => _reportTime = time);
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) setState(() => _image = pickedFile);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _problemDetailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('แจ้งซ่อม'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white, // For the back button and title color
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildDateField('วันที่แจ้งซ่อม', _reportDate, (val) => setState(() => _reportDate = val)),
              const SizedBox(height: 16),
              _buildTimeField('เวลาแจ้งซ่อม'),
              const SizedBox(height: 16),
              _buildDateField('วันที่เข้าซ่อม', _repairDate, (val) => setState(() => _repairDate = val)),
              const SizedBox(height: 16),

              _buildDropdown('ช่องทางแจ้งงาน', _reportChannel, _channels, (val) => setState(() => _reportChannel = val)),
              const SizedBox(height: 16),
              _buildDropdown('ชนิดของการบริการ', _serviceType, _services, (val) => setState(() => _serviceType = val)),
              const SizedBox(height: 16),
              _buildDropdown('ประเภทงาน', _jobType, _jobs, (val) => setState(() => _jobType = val)),
              const SizedBox(height: 16),

              _buildTextField('ชื่อผู้แจ้ง', _nameController),
              const SizedBox(height: 16),
              _buildTextField('เบอร์โทร', _phoneController, keyboardType: TextInputType.phone),
              const SizedBox(height: 16),

              _buildDropdown('อาคาร', _building, _buildings, (val) => setState(() => _building = val)),
              const SizedBox(height: 16),
              _buildDropdown('ชั้น', _floor, _floors, (val) => setState(() => _floor = val)),
              const SizedBox(height: 16),
              _buildDropdown('ห้อง', _room, _rooms, (val) => setState(() => _room = val)),
              const SizedBox(height: 16),

              TextFormField(
                controller: _problemDetailController,
                maxLines: 4, // Increased maxLines for more detail
                decoration: InputDecoration(
                  labelText: 'รายละเอียดของปัญหา',
                  hintText: 'กรุณากรอกรายละเอียดของปัญหาที่พบ',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                ),
                validator: (value) => value == null || value.isEmpty ? 'กรุณากรอกรายละเอียดของปัญหา' : null,
              ),

              const SizedBox(height: 24), // More space before image picker
              Column(
                children: [
                  ElevatedButton.icon(
                    icon: const Icon(Icons.camera_alt),
                    label: Text(_image == null ? 'แนบรูปประกอบ' : 'เปลี่ยนรูป'),
                    onPressed: _pickImage,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50), // Make button full width
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                  if (_image != null) ...[
                    const SizedBox(height: 12),
                    Text('รูปภาพที่เลือก: ${_image!.name}', style: TextStyle(color: Colors.grey.shade600)),
                    const SizedBox(height: 8),
                    // Display a small thumbnail or placeholder
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.file(
                          File(_image!.path),
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.broken_image, size: 50, color: Colors.grey),
                        ),
                      ),
                    ),
                  ],
                ],
              ),

              const SizedBox(height: 32), // More space before submit button
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Collect all data
                    final formData = {
                      'reportDate': _reportDate != null ? DateFormat('yyyy-MM-dd').format(_reportDate!) : null,
                      'reportTime': _reportTime != null ? '${_reportTime!.hour.toString().padLeft(2, '0')}:${_reportTime!.minute.toString().padLeft(2, '0')}' : null,
                      'repairDate': _repairDate != null ? DateFormat('yyyy-MM-dd').format(_repairDate!) : null,
                      'reportChannel': _reportChannel,
                      'serviceType': _serviceType,
                      'jobType': _jobType,
                      'name': _nameController.text,
                      'phone': _phoneController.text,
                      'building': _building,
                      'floor': _floor,
                      'room': _room,
                      'problemDetail': _problemDetailController.text,
                      'imagePath': _image?.path,
                    };
                    print(formData); // For debugging: print form data

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('กำลังส่งข้อมูลการแจ้งซ่อม...'),
                        backgroundColor: Colors.green,
                      ),
                    );
                    // In a real application, you would send this data to a backend.
                    // Example: API call, database save, etc.
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('กรุณากรอกข้อมูลให้ครบถ้วน'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(55), // Make button full width and slightly taller
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0), // Rounded corners
                  ),
                  elevation: 5, // Add shadow
                  textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                child: const Text('ส่งแจ้งซ่อม'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {TextInputType? keyboardType}) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      ),
      validator: (value) => value == null || value.isEmpty ? 'กรุณากรอก $label' : null,
    );
  }

  Widget _buildDropdown(String label, String? value, List<String> items, void Function(String?) onChanged) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      ),
      items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
      onChanged: onChanged,
      validator: (value) => value == null ? 'กรุณาเลือก $label' : null,
    );
  }

  Widget _buildDateField(String label, DateTime? value, void Function(DateTime) onPicked) {
    return TextFormField(
      readOnly: true,
      controller: TextEditingController(
        text: value == null ? '' : DateFormat('d MMMM y', 'th').format(value), // Thai date format
      ),
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        filled: true,
        fillColor: Colors.white,
        suffixIcon: const Icon(Icons.calendar_today),
        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      ),
      onTap: () => _pickDate(context, onPicked),
      validator: (val) => value == null ? 'กรุณาเลือก $label' : null,
    );
  }

  Widget _buildTimeField(String label) {
    return TextFormField(
      readOnly: true,
      controller: TextEditingController(
        text: _reportTime == null ? '' : DateFormat('HH:mm').format(DateTime(2023, 1, 1, _reportTime!.hour, _reportTime!.minute)), // 24-hour format
      ),
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        filled: true,
        fillColor: Colors.white,
        suffixIcon: const Icon(Icons.access_time),
        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      ),
      onTap: () => _pickTime(context),
      validator: (val) => _reportTime == null ? 'กรุณาเลือก $label' : null,
    );
  }
}