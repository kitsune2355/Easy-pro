// lib/screens/pending_jobs_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_pro/models/repair_history_item.dart'; // Assuming you have this model
import 'package:easy_pro/services/repair_service.dart'; // Your service for fetching jobs
import 'package:easy_pro/screens/accept_job_screen.dart'; // To navigate to the accept job screen

class PendingJobsScreen extends StatefulWidget {
  const PendingJobsScreen({super.key});

  @override
  State<PendingJobsScreen> createState() => _PendingJobsScreenState();
}

class _PendingJobsScreenState extends State<PendingJobsScreen> {
  // A list to hold the pending repair jobs
  List<RepairHistoryItem> _pendingJobs = [];
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchPendingJobs();
  }

  // Fetches pending jobs from your service
  Future<void> _fetchPendingJobs() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final repairService = Provider.of<RepairService>(context, listen: false);
      // Assuming a method to get pending jobs
      final jobs = await repairService.getPendingRepairRequests();
      setState(() {
        _pendingJobs = jobs;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load pending jobs: ${e.toString()}';
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
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: colorScheme.error,
                      size: 48,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _errorMessage!,
                      textAlign: TextAlign.center,
                      style: textTheme.titleMedium?.copyWith(
                        color: colorScheme.error,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _fetchPendingJobs,
                      child: const Text('ลองอีกครั้ง'),
                    ),
                  ],
                ),
              ),
            )
          : _pendingJobs.isEmpty
          ? Center(
              child: Text(
                'ไม่มีงานที่รอรับในขณะนี้',
                style: textTheme.titleMedium?.copyWith(color: Colors.grey[600]),
              ),
            )
          : RefreshIndicator(
              onRefresh: _fetchPendingJobs,
              child: ListView.builder(
                itemCount: _pendingJobs.length,
                itemBuilder: (context, index) {
                  final job = _pendingJobs[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ), // เพิ่มระยะห่างแนวตั้งเล็กน้อย
                    elevation: 4, // เพิ่มเงาเพื่อให้มีมิติมากขึ้น
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12), // มุมโค้งมนขึ้น
                    ),
                    child: ExpansionTile(
                      tilePadding: const EdgeInsets.fromLTRB(
                        16.0,
                        10.0,
                        16.0,
                        10.0,
                      ), // ปรับ padding ของส่วนหัว
                      childrenPadding:
                          EdgeInsets.zero, // ให้ children จัดการ padding เอง
                      controlAffinity:
                          ListTileControlAffinity.leading, // ลูกศรอยู่ซ้าย
                      // Title แสดงชื่อหลักและ ID ย่อย
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            job.displayTitle,
                            style: textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.primary,
                            ), // ตัวใหญ่ขึ้น
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'รหัสงาน: #${job.id}',
                            style: textTheme.bodySmall?.copyWith(
                              color: Colors.grey[600],
                            ), // เล็กและสีจางลง
                          ),
                        ],
                      ),
                      trailing: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context)
                              .push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      AcceptJobScreen(repairItem: job),
                                ),
                              )
                              .then(
                                (_) => _fetchPendingJobs(),
                              ); // รีเฟรชรายการหลังกลับมา
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: colorScheme.onPrimary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ), // ปุ่มโค้งมนขึ้น
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 10,
                          ), // ขนาดปุ่ม
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: const Text(
                          'ส่งงาน',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ), // ตัวหนาขึ้น
                        ),
                      ),
                      // Children แสดงรายละเอียดเมื่อขยาย
                      children: [
                        const Divider(
                          height: 1,
                          indent: 16,
                          endIndent: 16,
                        ), // เส้นคั่นบางๆ
                        Padding(
                          padding: const EdgeInsets.fromLTRB(
                            16.0,
                            12.0,
                            16.0,
                            16.0,
                          ), // Padding สำหรับเนื้อหาที่ขยาย
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.location_on_outlined,
                                    size: 20,
                                    color: Colors.grey[700],
                                  ), // เพิ่มไอคอน
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      'สถานที่: ${job.displayPlace}',
                                      style: textTheme
                                          .bodyLarge, // ตัวใหญ่ขึ้นเล็กน้อย
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(
                                    Icons.info_outline,
                                    size: 20,
                                    color: job.statusColor,
                                  ), // เพิ่มไอคอน
                                  const SizedBox(width: 10),
                                  Text(
                                    'สถานะ: ${job.statusText}',
                                    style: textTheme.bodyLarge?.copyWith(
                                      color: job.statusColor,
                                      fontWeight: FontWeight.w700,
                                    ), // ตัวหนาขึ้นและใหญ่ขึ้น
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
    );
  }
}
