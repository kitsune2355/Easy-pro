import 'package:easy_pro/screens/history_repair_screen.dart';
import 'package:easy_pro/screens/home_screen.dart';
import 'package:easy_pro/screens/profile_screen.dart';
import 'package:easy_pro/screens/settings_screen.dart';
import 'package:easy_pro/screens/repair_screen.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key}); // Added Key for best practice

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 1; // Current index for IndexedStack
  int _bottomNavIndex =
      1; // Current index for BottomNavigationBar (Profile, Home, Settings)

  // List of all pages that can be displayed
  late final List<Widget> _pages;
  // List of items for the Drawer (excluding logout for now)
  late final List<Map<String, dynamic>> _mainDrawerItems;
  // Logout item, to be placed separately
  late final Map<String, dynamic> _logoutDrawerItem;

  @override
  void initState() {
    super.initState();
    // Initialize the list of pages
    _pages = [
      const ProfileScreen(),
      HomeScreen(
        // Callbacks to navigate to Repair or History screens from Home
        onNavigateToRepair: () => _onItemTapped(3),
        onNavigateToHistory: () => _onItemTapped(4),
      ),
      const SettingsScreen(),
      const RepairScreen(), // Index 3
      const HistoryRepairScreen(), // Index 4
    ];

    // Initialize the main drawer items
    _mainDrawerItems = [
      {
        'icon': Icons.build_circle_outlined, // Modern icon
        'label': 'แจ้งซ่อม',
        'action': () {
          // Navigate to Repair screen and close drawer
          Navigator.pop(context);
          _onItemTapped(3);
        },
      },
      {
        'icon': Icons.access_time_filled_rounded, // Modern icon
        'label': 'ประวัติการซ่อม', // More descriptive label
        'action': () {
          // Navigate to History screen and close drawer
          Navigator.pop(context);
          _onItemTapped(4);
        },
      },
      // Add other main drawer items here if needed
    ];

    // Initialize the logout drawer item
    _logoutDrawerItem = {
      'icon': Icons.logout, // Example logout icon
      'label': 'ออกจากระบบ',
      'action': () {
        Navigator.pop(context); // Close the drawer
        // TODO: Implement logout logic here
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Logout functionality not yet implemented'),
          ),
        );
      },
    };
  }

  // Handles item tap for both BottomNavigationBar and Drawer
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Update the page to display

      // Update _bottomNavIndex only if the index corresponds to a BottomNavigationBar item
      // This ensures the BottomNavigationBar highlights correctly when navigating to Repair/History
      if (index <= 2) {
        _bottomNavIndex = index;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'EasyPro',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        centerTitle: true, // Center the title
        foregroundColor: Colors.white,
        backgroundColor: Theme.of(context).primaryColor, // Use the primary color
        elevation: 0, // Remove shadow for a flatter look
        // Conditional leading icon for back navigation from Repair/History screens
        leading: _selectedIndex == 3 || _selectedIndex == 4
            ? IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.white,
                ), // Modern back icon
                onPressed: () {
                  // Navigate back to the last selected bottom navigation item
                  _onItemTapped(_bottomNavIndex);
                },
              )
            : null, // No leading icon for other pages (drawer icon will be there by default)
      ),

      drawer: Drawer(
        child: Container(
          color: Colors.white, // Keep it white for a cleaner look
          child: Column( // Use Column instead of ListView directly
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor, // Use the primary color
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        _onItemTapped(0);
                      },
                      child: CircleAvatar(
                        radius: 36, // Slightly larger avatar
                        backgroundColor: Colors.white,
                        child: Icon(Icons.person,
                            size: 40,
                            color: Theme.of(context).primaryColor), // Example for a default icon
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
                                fontSize: 18, // Slightly larger font
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 6), // More spacing
                          Text(
                            'ตำแหน่ง: ช่างซ่อม',
                            style:
                                TextStyle(fontSize: 13, color: Colors.white70),
                          ),
                          SizedBox(height: 3), // More spacing
                          Text(
                            'รหัสพนักงาน: 123456789',
                            style:
                                TextStyle(fontSize: 13, color: Colors.white70),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded( // Wrap the main drawer items in an Expanded widget
                child: ListView(
                  padding: EdgeInsets.zero, // Important to remove default padding
                  children: [
                    ..._mainDrawerItems.map((item) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 4.0),
                        child: Card(
                          elevation: 2, // Subtle elevation for luxury
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(10), // Rounded corners
                          ),
                          child: ListTile(
                            leading: Icon(
                              item['icon'],
                              color: Theme.of(context).primaryColor, // Icon color
                            ),
                            title: Text(
                              item['label'],
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500, // Slightly bolder text
                                color: Colors.black87,
                              ),
                            ),
                            onTap: () {
                              item['action']();
                            },
                            splashColor: Theme.of(context).primaryColor.withOpacity(0.2),
                          ),
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),
              // --- Spacer and Logout item at the bottom ---
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    leading: Icon(
                      _logoutDrawerItem['icon'],
                      color: Colors.redAccent, // A distinct color for logout
                    ),
                    title: Text(
                      _logoutDrawerItem['label'],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.red, // Distinct color for logout text
                      ),
                    ),
                    onTap: () {
                      _logoutDrawerItem['action']();
                    },
                    splashColor: Colors.redAccent.withOpacity(0.2),
                  ),
                ),
              ),
              const SizedBox(height: 10), // Add some bottom padding
            ],
          ),
        ),
      ),
      // Display the selected page using IndexedStack for state preservation
      body: IndexedStack(index: _selectedIndex, children: _pages),

      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor, // Background color of the container
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
            type:
                BottomNavigationBarType.fixed, // Ensures all items are visible
            currentIndex: _bottomNavIndex,
            onTap: _onItemTapped,
            selectedItemColor: Colors.white, // Color for selected icon/label
            unselectedItemColor: const Color(
                0xFF9FD7F3), // Lighter blue for unselected (remains good)
            backgroundColor: Theme.of(context).primaryColor, // Background of the nav bar
            elevation: 0, // Remove default elevation as container has shadow
            selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
            unselectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.normal,
            ),
            items: const [
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.person_outline,
                ), // Outline icon for modern look
                activeIcon: Icon(Icons.person), // Filled icon when active
                label: 'โปรไฟล์', // Thai label
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined), // Outline icon
                activeIcon: Icon(Icons.home), // Filled icon
                label: 'หน้าหลัก', // Thai label
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings_outlined), // Outline icon
                activeIcon: Icon(Icons.settings), // Filled icon
                label: 'ตั้งค่า', // Thai label
              ),
            ],
          ),
        ),
      ),
    );
  }
}