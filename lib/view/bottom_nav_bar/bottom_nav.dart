import 'package:flutter/material.dart';
import 'package:healthmvp/view/home/Dashbaord/dashboard.dart';
import 'package:healthmvp/view/home/Medicine/Medicine_schedule.dart';
import 'package:healthmvp/view/home/Medicine/create_reminder.dart';
import 'package:healthmvp/view/home/Medicine/explore_screen.dart';
import 'package:healthmvp/view/home/Medicine/show_all_medicine.dart';
import 'package:healthmvp/view/setting/Profile.dart';

class Botoomnavbar extends StatefulWidget {
  final int initialIndex;

  const Botoomnavbar({super.key, this.initialIndex = 0});

  @override
  State<Botoomnavbar> createState() => _BotoomnavbarState();
}

class _BotoomnavbarState extends State<Botoomnavbar> {
  late PageController _pageController;
  late int indexxx;

  @override
  void initState() {
    super.initState();
    indexxx = widget.initialIndex;
    _pageController = PageController(initialPage: indexxx);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBody: true,
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          const DashboardScreen(),
          const MedicationReminderScreen(),
          const ModernReminderScreen(),
          const MedicineListScreen(),
          Profile(),
        ],
      ),

      // ✅ FIXED Bottom Nav Bar without tap-through issues
      bottomNavigationBar: Material(
        elevation: 8,
        color: Colors.white,
        child: Container(
          height: 70,
          child: Row(
            children: [
              Expanded(
                child: navItem(
                  icon: Icons.home,
                  label: 'Dashboard',
                  pageIndex: 0,
                ),
              ),
              Expanded(
                child: navItem(
                  icon: Icons.notifications,
                  label: 'Reminders',
                  pageIndex: 1,
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: () {
                  setState(() {
                    indexxx = 2;
                    _pageController.jumpToPage(2);
                  });
                },
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF2563EB),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.add, color: Colors.white),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: navItem(
                  icon: Icons.medical_information,
                  label: 'Medicines',
                  pageIndex: 3,
                ),
              ),
              Expanded(
                child: navItem(
                  icon: Icons.person,
                  label: 'Profile',
                  pageIndex: 4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget navItem({
    required IconData icon,
    required String label,
    required int pageIndex,
  }) {
    final isSelected = indexxx == pageIndex;
    return GestureDetector(
      onTap: () {
        setState(() {
          indexxx = pageIndex;
          _pageController.jumpToPage(pageIndex);
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: isSelected ? const Color(0xFF2563EB) : Colors.grey),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? const Color(0xFF2563EB) : Colors.grey,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
