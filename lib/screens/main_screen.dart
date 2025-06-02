import 'package:easy_pro/screens/history_repair_screen.dart';
import 'package:easy_pro/screens/home_screen.dart';
import 'package:easy_pro/screens/profile_screen.dart';
import 'package:easy_pro/screens/settings_screen.dart';
import 'package:easy_pro/screens/repair_screen.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 1; // ใช้กับ IndexedStack
  int _bottomNavIndex = 1; // ใช้กับ BottomNavigationBar

  late final List<Widget> _pages;
  late final List<Map<String, dynamic>> _drawerItems;

  @override
  void initState() {
    super.initState();
    _pages = [
      ProfileScreen(),
      HomeScreen(
        onNavigateToRepair: () => _onItemTapped(3),
        onNavigateToHistory: () => _onItemTapped(4),
      ),
      SettingsScreen(),
      RepairScreen(),
      HistoryRepairScreen(),
    ];

    _drawerItems = [
      {
        'icon': Icons.build,
        'label': 'แจ้งซ่อม',
        'action': () => _onItemTapped(3),
      },
      {
        'icon': Icons.history,
        'label': 'ประวัติ',
        'action': () => _onItemTapped(4),
      },
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;

      // อัปเดต _bottomNavIndex เฉพาะถ้า index อยู่ในช่วง BottomNavigationBar
      if (index <= 2) {
        _bottomNavIndex = index;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('EasyPro'),
        leading: _selectedIndex == 3 || _selectedIndex == 4
            ? IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  _onItemTapped(_bottomNavIndex);
                },
              )
            : null, // ถ้าไม่ใช่หน้า Repair ก็ไม่ต้องแสดงปุ่ม
        foregroundColor: Colors.white,
        backgroundColor: Theme.of(context).primaryColor,
      ),

      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: Color(0xFF006B9F)),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      _onItemTapped(0);
                    },
                    child: const CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.white,
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
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'ตำแหน่ง: ช่างซ่อม',
                          style: TextStyle(fontSize: 12, color: Colors.white70),
                        ),
                        SizedBox(height: 1),
                        Text(
                          'รหัสพนักงาน: 123456789',
                          style: TextStyle(fontSize: 12, color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            ..._drawerItems.map((item) {
              return ListTile(
                leading: Icon(item['icon']),
                title: Text(item['label']),
                onTap: () {
                  Navigator.pop(context);
                  item['action']();
                },
              );
            }).toList(),
          ],
        ),
      ),
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _bottomNavIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.white,
        unselectedItemColor: const Color(0xFF6DC0E9),
        backgroundColor: Theme.of(context).primaryColor,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
