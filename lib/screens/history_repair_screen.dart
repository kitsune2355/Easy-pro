import 'package:easy_pro/screens/repair_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:easy_pro/models/repair_history_item.dart';
import 'package:easy_pro/services/repair_service.dart'; // Import RepairService (ที่เป็น ChangeNotifier)
import 'package:flutter/cupertino.dart'; // For iOS styling if applicable
import 'package:provider/provider.dart'; // เพิ่ม import provider

class HistoryRepairScreen extends StatefulWidget {
  const HistoryRepairScreen({super.key});

  @override
  State<HistoryRepairScreen> createState() => _HistoryRepairScreenState();
}

class _HistoryRepairScreenState extends State<HistoryRepairScreen> {
  // ไม่ต้องมี _historyItems, _isLoading, _error ที่เป็น State ของ Widget โดยตรงแล้ว
  // เพราะจะดึงจาก RepairService ผ่าน Provider แทน

  @override
  void initState() {
    super.initState();
    // เรียก fetchAllRepairRequests ทันทีเมื่อหน้าจอนี้ถูกสร้างขึ้น
    // ใช้ listen: false เพราะเราเรียกแค่ครั้งเดียวใน initState
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<RepairService>(context, listen: false).fetchAllRepairRequests();
    });
  }

  // ไม่ต้องมี _fetchRepairHistory() แล้ว เพราะจะใช้เมธอดจาก RepairService โดยตรง

  @override
  Widget build(BuildContext context) {
    final bool isIOS = Theme.of(context).platform == TargetPlatform.iOS;

    // ใช้ Consumer เพื่อ listen การเปลี่ยนแปลงของ RepairService
    return Consumer<RepairService>(
      builder: (context, repairService, child) {
        final List<RepairHistoryItem> historyItems = repairService.allRepairRequests;
        final bool isLoading = repairService.isLoading;
        final String? error = repairService.error;

        final Widget content = isLoading
            ? const Center(child: CircularProgressIndicator())
            : error != null
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Error: $error\nโปรดลองอีกครั้ง',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.red, fontSize: 16),
                      ),
                    ),
                  )
                : historyItems.isEmpty
                    ? const Center(
                        child: Text(
                          'ไม่พบประวัติการแจ้งซ่อม',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.all(16.0),
                        itemCount: historyItems.length,
                        separatorBuilder: (context, index) => const SizedBox(height: 1.0),
                        itemBuilder: (context, index) {
                          final item = historyItems[index];
                          return _buildHistoryItemCard(context, item);
                        },
                      );

        return isIOS
            ? CupertinoPageScaffold(
                navigationBar: const CupertinoNavigationBar(
                  middle: Text('ประวัติการแจ้งซ่อม'),
                ),
                child: SafeArea(
                  child: RefreshIndicator( // เพิ่ม RefreshIndicator
                    onRefresh: () => repairService.fetchAllRepairRequests(),
                    child: content,
                  ),
                ),
              )
            : Scaffold(
                body: RefreshIndicator( // เพิ่ม RefreshIndicator
                  onRefresh: () => repairService.fetchAllRepairRequests(),
                  child: content,
                ),
              );
      },
    );
  }

  Widget _buildHistoryItemCard(BuildContext context, RepairHistoryItem item) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RepairDetailScreen(repairItem: item),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      '#${item.id} ${item.displayTitle}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: item.statusColor.withOpacity(
                        0.1,
                      ), // Use statusColor
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: item.statusColor.withOpacity(0.5),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(item.icon, size: 16, color: item.statusColor),
                        const SizedBox(width: 4),
                        Text(
                          item.statusText,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: item.statusColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                item.problemDetail,
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                item.displayPlace,
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.calendar_today, size: 16, color: Colors.grey[500]),
                  const SizedBox(width: 8),
                  Text(
                    'แจ้งเมื่อ: ${item.reportDate}',
                    style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}