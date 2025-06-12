import 'package:easy_pro/screens/history_repair_screen.dart';
import 'package:easy_pro/screens/home_screen.dart';
import 'package:easy_pro/screens/notifications_screen.dart'
    show NotificationsScreen;
import 'package:easy_pro/screens/pending_jobs_screen.dart';
import 'package:easy_pro/screens/profile_screen.dart';
import 'package:easy_pro/screens/settings_screen.dart';
import 'package:easy_pro/screens/repair_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Import provider
import 'package:easy_pro/services/notification_service.dart'; // Import your service

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 1; // Current index for IndexedStack
  int _bottomNavIndex = 1; // Current index for BottomNavigationBar

  late final List<Widget> _pages;
  late final List<String> _pageTitles; // New: List of titles for each page
  late final List<Map<String, dynamic>> _mainDrawerItems;
  late final Map<String, dynamic> _logoutDrawerItem;

  @override
  void initState() {
    super.initState();
    _pages = [
      const ProfileScreen(),
      HomeScreen(
        onNavigateToRepair: () => _onItemTapped(3),
        onNavigateToHistory: () => _onItemTapped(4),
        onNavigateToPendingJob: () => _onItemTapped(6),
      ),
      const SettingsScreen(),
      const RepairScreen(),
      const HistoryRepairScreen(),
      const NotificationsScreen(),
      const PendingJobsScreen()
    ];

    _pageTitles = [
      'โปรไฟล์',
      'EasyPro',
      'ตั้งค่า',
      'แจ้งซ่อม',
      'ประวัติการซ่อม',
      'การแจ้งเตือน',
      'งานที่รอปิดตรวจ',
    ];

    _mainDrawerItems = [
      {
        'icon': Icons.build_circle_outlined,
        'label': 'แจ้งซ่อม',
        'action': () {
          Navigator.pop(context);
          _onItemTapped(3);
        },
      },
      {
        'icon': Icons.access_time_filled_rounded,
        'label': 'ประวัติการซ่อม',
        'action': () {
          Navigator.pop(context);
          _onItemTapped(4);
        },
      },
    ];

    _logoutDrawerItem = {
      'icon': Icons.logout,
      'label': 'ออกจากระบบ',
      'action': () {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Logout functionality not yet implemented'),
          ),
        );
      },
    };

    // Fetch notifications when MainScreen initializes
    // Provider.of<NotificationService>(context, listen: false).fetchNotifications();
    // Use Future.microtask to avoid calling setState during build
    Future.microtask(
      () => Provider.of<NotificationService>(
        context,
        listen: false,
      ).fetchNotifications(userId: 'i'),
    );
  }

  // เปลี่ยน _onItemTapped ให้เป็น async function
  void _onItemTapped(int index) async {
    setState(() {
      _selectedIndex = index;
      if (index <= 2) {
        _bottomNavIndex = index;
      }
    });

    // เมื่อ navigate ไปที่ NotificationsScreen (index 5) ให้ทำเครื่องหมายแจ้งเตือนที่ยังไม่ได้อ่านทั้งหมดว่าอ่านแล้ว
    if (index == 5) {
      final notificationService = Provider.of<NotificationService>(
        context,
        listen: false,
      );

      // สร้างรายการ Future สำหรับการเรียก markNotificationAsRead แต่ละครั้ง
      final List<Future<void>> markAsReadFutures = [];
      notificationService.notifications.where((n) => !n.isRead).forEach((n) {
        // เพิ่ม Future เข้าไปในลิสต์
        markAsReadFutures.add(notificationService.markAsRead(n.user_id));
      });

      // **สำคัญมาก:** รอให้การเรียก markNotificationAsRead ทั้งหมดเสร็จสิ้น
      await Future.wait(markAsReadFutures);

      // **สำคัญมาก:** หลังจากทำเครื่องหมายว่าอ่านแล้ว ให้ดึงข้อมูลการแจ้งเตือนล่าสุดจากเซิร์ฟเวอร์อีกครั้ง
      // เพื่อให้แน่ใจว่าสถานะ isRead ถูกอัปเดตและ UI จะแสดงผลได้อย่างถูกต้องแม้จะ hot reload
      await notificationService.fetchNotifications(userId: 'i');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Watch the NotificationService for changes
    final notificationService = Provider.of<NotificationService>(context);
    final int unreadCount = notificationService.unreadNotificationCount;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _pageTitles[_selectedIndex],
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        centerTitle: true,
        foregroundColor: Colors.white,
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        leading: [3, 4, 5, 6].contains(_selectedIndex)
            ? IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
                onPressed: () => _onItemTapped(_bottomNavIndex),
              )
            : null,

        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_none, color: Colors.white),
                onPressed: () {
                  _onItemTapped(5); // Navigate to notifications screen
                  // The marking as read logic is now in _onItemTapped
                },
              ),
              if (unreadCount > 0) // Use unreadCount from service
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      '$unreadCount', // Display unreadCount
                      style: const TextStyle(color: Colors.white, fontSize: 10),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      drawer: Drawer(
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        _onItemTapped(0);
                      },
                      child: CircleAvatar(
                        radius: 36,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.person,
                          size: 40,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'สมชาย ใจดี',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            'ตำแหน่ง: ช่างซ่อม',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.white70,
                            ),
                          ),
                          SizedBox(height: 3),
                          Text(
                            'รหัสพนักงาน: 123456789',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    ..._mainDrawerItems.map((item) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8.0,
                          vertical: 4.0,
                        ),
                        child: Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ListTile(
                            leading: Icon(
                              item['icon'],
                              color: Theme.of(context).primaryColor,
                            ),
                            title: Text(
                              item['label'],
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                            ),
                            onTap: () {
                              item['action']();
                            },
                            splashColor: Theme.of(
                              context,
                            ).primaryColor.withOpacity(0.2),
                          ),
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 4.0,
                ),
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    leading: Icon(
                      _logoutDrawerItem['icon'],
                      color: Colors.redAccent,
                    ),
                    title: Text(
                      _logoutDrawerItem['label'],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.red,
                      ),
                    ),
                    onTap: () {
                      _logoutDrawerItem['action']();
                    },
                    splashColor: Colors.redAccent.withOpacity(0.2),
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 5,
            ),
          ],
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: _bottomNavIndex,
            onTap: _onItemTapped,
            selectedItemColor: Colors.white,
            unselectedItemColor: const Color(0xFF9FD7F3),
            backgroundColor: Theme.of(context).primaryColor,
            elevation: 0,
            selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
            unselectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.normal,
            ),
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                activeIcon: Icon(Icons.person),
                label: 'โปรไฟล์',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home),
                label: 'หน้าหลัก',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings_outlined),
                activeIcon: Icon(Icons.settings),
                label: 'ตั้งค่า',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
