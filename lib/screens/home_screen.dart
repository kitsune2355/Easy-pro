import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final VoidCallback? onNavigateToRepair;
  final VoidCallback? onNavigateToHistory;

  const HomeScreen({
    super.key,
    this.onNavigateToRepair,
    this.onNavigateToHistory,
  });

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    int crossAxisCount = 4;
    if (screenWidth >= 900) {
      crossAxisCount = 8;
    } else if (screenWidth >= 600) {
      crossAxisCount = 6;
    }

    final List<_MenuItem> menuItems = [
      _MenuItem(
        title: 'แจ้งซ่อม',
        icon: Icons.build,
        onTap: () {
          onNavigateToRepair?.call();
        },
      ),
      _MenuItem(
        title: 'ประวัติ',
        icon: Icons.history,
        onTap: () {
          onNavigateToHistory?.call();
        },
      ),
    ];

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: GridView.count(
              padding: const EdgeInsets.all(16),
              crossAxisCount: crossAxisCount,
              mainAxisSpacing: 20,
              crossAxisSpacing: 20,
              children: menuItems.map((item) {
                return InkWell(
                  onTap: item.onTap,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(item.icon, size: 20, color: Colors.white),
                        const SizedBox(height: 4),
                        Text(
                          item.title,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuItem {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  _MenuItem({required this.title, required this.icon, required this.onTap});
}
