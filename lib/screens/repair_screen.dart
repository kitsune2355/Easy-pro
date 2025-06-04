import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class RepairScreen extends StatefulWidget {
  const RepairScreen({super.key});

  @override
  State<RepairScreen> createState() => _RepairScreenState();
}

class _RepairScreenState extends State<RepairScreen> {
  final _formKey = GlobalKey<FormState>();

  // MARK: - Controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _problemDetailController =
      TextEditingController();

  // MARK: - Form Data Fields
  // Initialize with current date and time
  DateTime? _reportDate = DateTime.now();
  TimeOfDay? _reportTime = TimeOfDay.now();
  DateTime? _repairDate;
  String? _reportChannel;
  String? _serviceType;
  String? _jobType;
  String? _building;
  String? _floor;
  String? _room;
  XFile? _image;

  // MARK: - Dropdown Data Sources
  static const List<String> _buildings = ['A', 'B', 'C'];
  static const List<String> _floors = ['1', '2', '3', '4', '5'];
  static const List<String> _rooms = ['101', '102', '103', '201', '202'];

  @override
  void initState() {
    super.initState();
    _initializeThaiDateFormatting();
  }

  Future<void> _initializeThaiDateFormatting() async {
    // Ensure Thai locale data is loaded for date formatting
    await initializeDateFormatting('th', null);
    setState(() {
      // Rebuild widget tree after locale data is loaded if needed
    });
  }

  @override
  void dispose() {
    // Dispose controllers to prevent memory leaks
    _nameController.dispose();
    _phoneController.dispose();
    _problemDetailController.dispose();
    super.dispose();
  }

  /// Handles date picking and updates the relevant state variable.
  Future<void> _pickDate(
    BuildContext context,
    void Function(DateTime) onPicked,
  ) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).primaryColor,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).primaryColor,
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (pickedDate != null) {
      onPicked(pickedDate);
    }
  }

  /// Handles time picking and updates the _reportTime state variable.
  Future<void> _pickTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).primaryColor,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).primaryColor,
              ),
            ),
          ),
          child: MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
            child: child!,
          ),
        );
      },
    );
    if (pickedTime != null) {
      setState(() => _reportTime = pickedTime);
    }
  }

  /// Handles image picking from the gallery or camera.
  Future<void> _pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() => _image = pickedFile);
    }
  }

  /// Submits the form data after validation.
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final Map<String, dynamic> formData = {
        'reportDate': _reportDate != null
            ? DateFormat('yyyy-MM-dd').format(_reportDate!)
            : null,
        'reportTime': _reportTime != null
            ? _formatTimeOfDay(_reportTime!)
            : null,
        'repairDate': _repairDate != null
            ? DateFormat('yyyy-MM-dd').format(_repairDate!)
            : null,
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
      print(formData); // For debugging purposes

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('สำเร็จ!', style: TextStyle(color: Colors.green)),
            content: const Text(
              'ข้อมูลการแจ้งซ่อมถูกส่งเรียบร้อยแล้ว',
              style: TextStyle(color: Colors.black),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('ตกลง'),
                onPressed: () {
                  Navigator.of(context).pop(); // Dismiss the dialog
                },
              ),
            ],
          );
        },
      );
      // In a real application, you would typically send this data to a backend API.
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              'เกิดข้อผิดพลาด!',
              style: TextStyle(color: Colors.red),
            ),
            content: const Text(
              'กรุณากรอกข้อมูลให้ครบถ้วน',
              style: TextStyle(color: Colors.black),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('ปิด'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  /// Formats TimeOfDay to a HH:mm string.
  String _formatTimeOfDay(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('แจ้งซ่อม'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionHeader('ข้อมูลการแจ้ง'),
              const SizedBox(height: 12),
              _buildCardSection([
                _buildDateField(
                  'วันที่แจ้งซ่อม',
                  _reportDate,
                  (val) => setState(() => _reportDate = val),
                ),
                const SizedBox(height: 16),
                _buildTimeField('เวลาแจ้งซ่อม'),
              ]),
              const SizedBox(height: 24),

              _buildSectionHeader('ข้อมูลผู้แจ้ง'),
              const SizedBox(height: 12),
              _buildCardSection([
                _buildTextField(
                  'ชื่อผู้แจ้ง',
                  _nameController,
                  hintText: 'กรุณากรอกชื่อ-นามสกุล',
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  'เบอร์โทร',
                  _phoneController,
                  keyboardType: TextInputType.phone,
                  hintText: 'เช่น 0812345678',
                ),
              ]),
              const SizedBox(height: 24),

              _buildSectionHeader('สถานที่'),
              const SizedBox(height: 12),
              _buildCardSection([
                _buildDropdown(
                  'อาคาร',
                  _building,
                  _buildings,
                  (val) => setState(() => _building = val),
                ),
                const SizedBox(height: 16),
                _buildDropdown(
                  'ชั้น',
                  _floor,
                  _floors,
                  (val) => setState(() => _floor = val),
                ),
                const SizedBox(height: 16),
                _buildDropdown(
                  'ห้อง',
                  _room,
                  _rooms,
                  (val) => setState(() => _room = val),
                ),
              ]),
              const SizedBox(height: 24),

              _buildSectionHeader('รายละเอียดปัญหา'),
              const SizedBox(height: 12),
              _buildCardSection([
                _buildProblemDetailField(),
                const SizedBox(height: 24),
                _buildImagePicker(), // Updated to call the new _buildImagePicker
                if (_image != null) ...[
                  const SizedBox(height: 12),
                  Text(
                    'รูปภาพที่เลือก: ${_image!.name}',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 8),
                  _buildImagePreview(),
                ],
              ]),

              const SizedBox(height: 32),

              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  // MARK: - Reusable Widget Builders

  /// Builds a standard text input field.
  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    TextInputType? keyboardType,
    String? hintText,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: _buildInputDecoration(label, hintText: hintText),
      validator: (value) =>
          value == null || value.isEmpty ? 'กรุณากรอก $label' : null,
    );
  }

  /// Builds a standard dropdown input field.
  Widget _buildDropdown(
    String label,
    String? value,
    List<String> items,
    void Function(String?) onChanged,
  ) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: _buildInputDecoration(label),
      items: items
          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
          .toList(),
      onChanged: onChanged,
      validator: (value) => value == null ? 'กรุณาเลือก $label' : null,
    );
  }

  /// Builds a date input field with a date picker.
  Widget _buildDateField(
    String label,
    DateTime? value,
    void Function(DateTime) onPicked,
  ) {
    return TextFormField(
      readOnly: true,
      controller: TextEditingController(
        text: value == null ? '' : DateFormat('d MMMM y', 'th').format(value),
      ),
      decoration: _buildInputDecoration(
        label,
        prefixIcon: Icon(
          Icons.calendar_today,
          color: Theme.of(context).primaryColor,
        ),
      ),
      onTap: () => _pickDate(context, onPicked),
      validator: (val) => value == null ? 'กรุณาเลือก $label' : null,
    );
  }

  /// Builds a time input field with a time picker.
  Widget _buildTimeField(String label) {
    return TextFormField(
      readOnly: true,
      controller: TextEditingController(
        text: _reportTime == null ? '' : _formatTimeOfDay(_reportTime!),
      ),
      decoration: _buildInputDecoration(
        label,
        prefixIcon: Icon(
          Icons.access_time,
          color: Theme.of(context).primaryColor,
        ),
      ),
      onTap: () => _pickTime(context),
      validator: (val) => _reportTime == null ? 'กรุณาเลือก $label' : null,
    );
  }

  /// Builds the problem detail text area.
  Widget _buildProblemDetailField() {
    return TextFormField(
      controller: _problemDetailController,
      maxLines: 5,
      decoration: _buildInputDecoration(
        'รายละเอียดของปัญหา',
        hintText:
            'โปรดอธิบายปัญหาที่พบอย่างละเอียด เช่น แอร์ไม่เย็น, ก๊อกน้ำรั่ว, ไฟฟ้าดับ',
      ),
      validator: (value) =>
          value == null || value.isEmpty ? 'กรุณากรอกรายละเอียดของปัญหา' : null,
    );
  }

  /// Builds the image picker button and provides options to use camera or gallery.
  Widget _buildImagePicker() {
    return ElevatedButton.icon(
      icon: const Icon(Icons.camera_alt),
      label: Text(_image == null ? 'แนบรูปภาพประกอบ (ถ้ามี)' : 'เปลี่ยนรูปภาพ'),
      onPressed: () {
        showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    leading: const Icon(Icons.camera_alt),
                    title: const Text('ถ่ายรูปด้วยกล้อง'),
                    onTap: () {
                      Navigator.pop(context);
                      _pickImage(ImageSource.camera);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.photo_library),
                    title: const Text('เลือกจากอัลบั้มรูป'),
                    onTap: () {
                      Navigator.pop(context);
                      _pickImage(ImageSource.gallery);
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
      style: ElevatedButton.styleFrom(
        minimumSize: const Size.fromHeight(50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        padding: const EdgeInsets.symmetric(vertical: 12),
        backgroundColor: Theme.of(context).colorScheme.secondary,
        foregroundColor: Colors.white,
      ),
    );
  }

  /// Builds the image preview thumbnail.
  Widget _buildImagePreview() {
    return Container(
      width: 120,
      height: 120,
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
              const Icon(Icons.broken_image, size: 60, color: Colors.grey),
        ),
      ),
    );
  }

  /// Builds the submit button.
  Widget _buildSubmitButton() {
    return ElevatedButton(
      onPressed: _submitForm,
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        minimumSize: const Size.fromHeight(55),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 5,
        textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      child: const Text('ส่งแจ้งซ่อม'),
    );
  }

  /// Builds a common InputDecoration for text fields and dropdowns.
  InputDecoration _buildInputDecoration(
    String label, {
    String? hintText,
    Widget? prefixIcon,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hintText,
      prefixIcon: prefixIcon,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: Colors.grey.shade400),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2),
      ),
      filled: true,
      fillColor: Colors.grey[50],
      contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
    );
  }

  /// Builds a card section with a list of children.
  Widget _buildCardSection(List<Widget> children) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(children: children),
      ),
    );
  }

  /// Builds a section header text.
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }
}
