// ส่วน Import
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:easy_pro/models/repair_history_item.dart';
import 'package:easy_pro/services/repair_service.dart';

class AcceptJobScreen extends StatefulWidget {
  final RepairHistoryItem repairItem;

  const AcceptJobScreen({super.key, required this.repairItem});

  @override
  State<AcceptJobScreen> createState() => _AcceptJobScreenState();
}

class _AcceptJobScreenState extends State<AcceptJobScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  DateTime? _selectedDate;
  bool _isLoading = false;
  String? _errorMessage;

  final TextEditingController _repairDetailsController = TextEditingController();
  List<String> _imagePaths = [];

  @override
  void dispose() {
    _pageController.dispose();
    _repairDetailsController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final bool isIOS = Theme.of(context).platform == TargetPlatform.iOS;
    DateTime? pickedDate;

    if (isIOS) {
      await showCupertinoModalPopup(
        context: context,
        builder: (BuildContext builder) {
          return Container(
            height: MediaQuery.of(context).size.height / 3,
            color: Colors.white,
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.date,
              initialDateTime: _selectedDate ?? DateTime.now(),
              minimumDate: DateTime.now(),
              onDateTimeChanged: (DateTime newDate) {
                pickedDate = newDate;
              },
            ),
          );
        },
      );
    } else {
      pickedDate = await showDatePicker(
        context: context,
        initialDate: _selectedDate ?? DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2101),
      );
    }

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
        _errorMessage = null;
      });
    }
  }

  Future<void> _handleStep1Completion() async {
    if (_selectedDate == null) {
      setState(() {
        _errorMessage = 'กรุณาระบุวันที่ต้องเข้าปฏิบัติงาน';
      });
      return;
    }

    _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
    setState(() {
      _currentPage = 1;
      _errorMessage = null;
    });
  }

  void _handleStep2Completion() {
    if (_repairDetailsController.text.isEmpty) {
      setState(() {
        _errorMessage = 'กรุณากรอกรายละเอียดการแก้ไขปัญหา';
      });
      return;
    }

    _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
    setState(() {
      _currentPage = 2;
      _errorMessage = null;
    });
  }

  Future<void> _pickImage() async {
    setState(() {
      _imagePaths.add('path/to/image_${_imagePaths.length + 1}.jpg');
      _errorMessage = null;
    });
  }

  Future<void> _submitJobCompletion() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final repairService = Provider.of<RepairService>(context, listen: false);
      // await repairService.completeRepair(...);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ส่งงานเรียบร้อยแล้ว!'), backgroundColor: Colors.green),
      );
      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'เกิดข้อผิดพลาดในการส่งงาน: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final bool isIOS = Theme.of(context).platform == TargetPlatform.iOS;

    final body = Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStepIndicator(0, 'เสร็จสิ้นงาน'),
              _buildStepIndicator(1, 'บันทึกงาน'),
              _buildStepIndicator(2, 'ส่งงาน'),
            ],
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _buildStep1(context, textTheme),
              _buildStep2(context, textTheme),
              _buildStep3(context, textTheme),
            ],
          ),
        )
      ],
    );

    return isIOS
        ? CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
              middle: Text('ปิดงานซ่อม (${_currentPage + 1}/3)', style: textTheme.titleLarge),
            ),
            child: SafeArea(child: body),
          )
        : Scaffold(
            appBar: AppBar(
              title: Text('ปิดงานซ่อม (${_currentPage + 1}/3)', style: textTheme.titleLarge),
              centerTitle: true,
              backgroundColor: Theme.of(context).primaryColor,
            ),
            body: body,
          );
  }

  Widget _buildStep1(BuildContext context, TextTheme textTheme) {
    return _wrapWithBottom(context, Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('ปิดงานซ่อม', style: textTheme.headlineSmall),
        const SizedBox(height: 24),
        _buildJobDetailCard(textTheme),
        const SizedBox(height: 24),
        Text('กำหนดวันที่เข้าปฏิบัติงาน', style: textTheme.titleLarge),
        const SizedBox(height: 16),
        _buildDateSelectionField(context, textTheme),
        if (_errorMessage != null && _currentPage == 0)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
          ),
        const Spacer(),
        _buildBottomButton(
          label: 'ถัดไป',
          icon: Icons.arrow_forward_ios,
          onPressed: _isLoading ? null : _handleStep1Completion,
          loading: _isLoading,
          color: Theme.of(context).primaryColor,
        ),
      ],
    ));
  }

  Widget _buildStep2(BuildContext context, TextTheme textTheme) {
    return _wrapWithBottom(context, Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('บันทึกรายละเอียดงานซ่อม', style: textTheme.headlineSmall),
        const SizedBox(height: 24),
        TextField(
          controller: _repairDetailsController,
          maxLines: 5,
          decoration: InputDecoration(
            labelText: 'รายละเอียดการแก้ไขปัญหา',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        const SizedBox(height: 16),
        Text('รูปภาพประกอบ (ถ้ามี)', style: textTheme.titleMedium),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          children: [
            ..._imagePaths.map((path) => Chip(label: Text(path.split('/').last))),
            ActionChip(label: const Text('เพิ่มรูปภาพ'), avatar: const Icon(Icons.add_a_photo), onPressed: _pickImage),
          ],
        ),
        if (_errorMessage != null && _currentPage == 1)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
          ),
        const Spacer(),
        Row(
          children: [
            Expanded(
              child: _buildBottomButton(
                label: 'ย้อนกลับ',
                icon: Icons.arrow_back_ios,
                onPressed: () {
                  _pageController.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
                  setState(() => _currentPage = 0);
                },
                color: Colors.grey,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildBottomButton(
                label: 'ถัดไป',
                icon: Icons.arrow_forward_ios,
                onPressed: _handleStep2Completion,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ],
        ),
      ],
    ));
  }

  Widget _buildStep3(BuildContext context, TextTheme textTheme) {
    return _wrapWithBottom(context, Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('สรุปและส่งงาน', style: textTheme.headlineSmall),
        const SizedBox(height: 24),
        _buildSummaryCard(textTheme),
        if (_errorMessage != null && _currentPage == 2)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
          ),
        const Spacer(),
        _buildBottomButton(
          label: 'ส่งงาน',
          icon: Icons.send,
          onPressed: _isLoading ? null : _submitJobCompletion,
          loading: _isLoading,
          color: Colors.green.shade600,
        ),
        const SizedBox(height: 16),
        _buildBottomButton(
          label: 'ย้อนกลับ',
          icon: Icons.arrow_back_ios,
          onPressed: () {
            _pageController.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
            setState(() => _currentPage = 1);
          },
          color: Colors.grey,
        )
      ],
    ));
  }

  Widget _wrapWithBottom(BuildContext context, Widget child) {
    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight),
          child: IntrinsicHeight(child: Padding(padding: const EdgeInsets.all(24), child: child)),
        ),
      ),
    );
  }

  Widget _buildBottomButton({
    required String label,
    required IconData icon,
    required VoidCallback? onPressed,
    bool loading = false,
    Color? color,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: loading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
              )
            : Icon(icon),
        label: Text(loading ? 'กำลังดำเนินการ...' : label, style: const TextStyle(fontSize: 18)),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  Widget _buildStepIndicator(int stepIndex, String title) {
    bool isActive = _currentPage >= stepIndex;
    return Column(
      children: [
        CircleAvatar(
          radius: 18,
          backgroundColor: isActive ? Theme.of(context).primaryColor : Colors.grey[300],
          child: Text('${stepIndex + 1}', style: TextStyle(color: isActive ? Colors.white : Colors.grey[700])),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            color: isActive ? Theme.of(context).primaryColor : Colors.grey[600],
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildJobDetailCard(TextTheme textTheme) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'รายละเอียดงานซ่อม',
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade700,
              ),
            ),
            const Divider(height: 20, thickness: 1),
            _buildDetailRow(
              context,
              'รหัสงาน:',
              '#${widget.repairItem.id}',
              Icons.tag,
            ),
            _buildDetailRow(
              context,
              'ประเภทงาน:',
              widget.repairItem.displayTitle,
              Icons.build,
            ),
            _buildDetailRow(
              context,
              'สถานที่:',
              widget.repairItem.displayPlace,
              Icons.location_on,
            ),
            _buildDetailRow(
              context,
              'สถานะปัจจุบัน:',
              widget.repairItem.statusText,
              Icons.info_outline,
              valueColor: widget.repairItem.statusColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context,
    String label,
    String value,
    IconData icon, {
    Color? valueColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 12),
          Text(
            label,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: valueColor ?? Colors.black87,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateSelectionField(BuildContext context, TextTheme textTheme) {
    return GestureDetector(
      onTap: () => _selectDate(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _errorMessage != null && _currentPage == 0
                ? Colors.red
                : Colors.grey.shade300,
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(
              Icons.calendar_today_rounded,
              color: Theme.of(context).primaryColor,
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                _selectedDate == null
                    ? 'เลือกวันที่...'
                    : DateFormat('dd MMMM yyyy', 'th').format(_selectedDate!),
                style: textTheme.titleMedium?.copyWith(
                  color: _selectedDate == null
                      ? Colors.grey[600]
                      : Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const Icon(Icons.arrow_drop_down, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  // New: Builds a card summarizing all input details before final submission
  Widget _buildSummaryCard(TextTheme textTheme) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'สรุปรายละเอียดงาน',
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.green.shade700,
              ),
            ),
            const Divider(height: 20, thickness: 1),
            _buildDetailRow(
              context,
              'รหัสงาน:',
              '#${widget.repairItem.id}',
              Icons.tag,
            ),
            _buildDetailRow(
              context,
              'ประเภทงาน:',
              widget.repairItem.displayTitle,
              Icons.build,
            ),
            _buildDetailRow(
              context,
              'สถานที่:',
              widget.repairItem.displayPlace,
              Icons.location_on,
            ),
            _buildDetailRow(
              context,
              'วันที่เข้าปฏิบัติงาน:',
              _selectedDate != null
                  ? DateFormat('dd MMMM yyyy', 'th').format(_selectedDate!)
                  : 'ยังไม่ได้ระบุ',
              Icons.calendar_today,
            ),
            _buildDetailRow(
              context,
              'รายละเอียดการแก้ไข:',
              _repairDetailsController.text.isNotEmpty
                  ? _repairDetailsController.text
                  : 'ยังไม่ได้กรอก',
              Icons.description,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.image, size: 20, color: Colors.grey[600]),
                  const SizedBox(width: 12),
                  Text(
                    'จำนวนรูปภาพ:',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '${_imagePaths.length} รูป',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

}
