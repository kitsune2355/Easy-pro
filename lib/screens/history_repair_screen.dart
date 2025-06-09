import 'package:easy_pro/screens/repair_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:easy_pro/models/repair_history_item.dart';
import 'package:easy_pro/services/repair_service.dart'; // Assuming you fetch data here
import 'package:flutter/cupertino.dart'; // For iOS styling if applicable

class HistoryRepairScreen extends StatefulWidget {
  const HistoryRepairScreen({super.key});

  @override
  State<HistoryRepairScreen> createState() => _HistoryRepairScreenState();
}

class _HistoryRepairScreenState extends State<HistoryRepairScreen> {
  List<RepairHistoryItem> _historyItems = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchRepairHistory();
  }

  Future<void> _fetchRepairHistory() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final fetchedItems =
          await RepairService.fetchAllRepairRequests(); // Reuse this service call
      setState(() {
        _historyItems = fetchedItems;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString().replaceFirst('Exception: ', '');
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isIOS = Theme.of(context).platform == TargetPlatform.iOS;

    final Widget content = _isLoading
        ? const Center(child: CircularProgressIndicator())
        : _error != null
        ? Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Error: $_error\nโปรดลองอีกครั้ง',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red, fontSize: 16),
              ),
            ),
          )
        : _historyItems.isEmpty
        ? const Center(
            child: Text(
              'ไม่พบประวัติการแจ้งซ่อม',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          )
        : ListView.separated(
            padding: const EdgeInsets.all(16.0),
            itemCount: _historyItems.length,
            separatorBuilder: (context, index) => const SizedBox(height: 1.0),
            itemBuilder: (context, index) {
              final item = _historyItems[index];
              return _buildHistoryItemCard(context, item);
            },
          );

    return isIOS
        ? CupertinoPageScaffold(
            navigationBar: const CupertinoNavigationBar(
              middle: Text('ประวัติการแจ้งซ่อม'),
            ),
            child: SafeArea(child: content),
          )
        : Scaffold(body: content);
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
                      item.displayTitle, // Use the displayTitle getter
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
