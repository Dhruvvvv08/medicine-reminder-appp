import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:healthmvp/Utils/colors.dart';
import 'package:healthmvp/view/Auth/login_screen.dart';
import 'package:healthmvp/view/home/Dashbaord/dashboard.dart';
import 'package:healthmvp/view/home/Medicine/Medicine_schedule.dart';
import 'package:healthmvp/view/home/Medicine/add_medicine.dart';
import 'package:healthmvp/view/home/Medicine/create_reminder.dart';
import 'package:healthmvp/view/home/Medicine/show_all_medicine.dart';
import 'package:healthmvp/view/home/Medicine/show_medicine.dart';
import 'package:healthmvp/view/home/Medicine/show_medicine_schdule.dart';
import 'package:healthmvp/view/setting/Profile.dart';
import 'package:healthmvp/view/setting/Setting_screen.dart';

class Botoomnavbar extends StatefulWidget {
  const Botoomnavbar({super.key});

  @override
  State<Botoomnavbar> createState() => _BotoomnavbarState();
}

class _BotoomnavbarState extends State<Botoomnavbar> {
  PageController _pageController = PageController(initialPage: 0);
  int indexxx = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBody: true,
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          Center(child: DashboardScreen()),
          Center(child: MedicineSchedulePage()),
          Center(child: AddMedicine()),
          //Center(child: MedicineScreen()),
          Center(child: MedicineListScreen()),
          Center(child: Profile()),
        ],
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // floatingActionButton: Container(
      //   width: 60,
      //   height: 60,
      //   decoration: BoxDecoration(
      //     shape: BoxShape.circle,
      //     color: Colors.white,
      //     boxShadow: [
      //       BoxShadow(
      //         color: Colors.black.withOpacity(0.15),
      //         blurRadius: 8,
      //         offset: const Offset(0, 2),
      //       ),
      //     ],
      //   ),
      //   child: FloatingActionButton(
      //     backgroundColor: Colors.purple,
      //     elevation: 0,
      //     onPressed: () {
      //       context.go('/addmedicine');
      //     },
      //     child: const Icon(Icons.add, color: Colors.black),
      //   ),
      // ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        color: Colors.white,
        child: SizedBox(
          height: 70,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              navItem(icon: Icons.home, label: 'Home', pageIndex: 0),
              navItem(
                icon: Icons.explore_outlined,
                label: 'Explore',
                pageIndex: 1,
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    indexxx = 2;
                    _pageController.jumpToPage(2);
                  });
                },
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: kf0f9ff,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.add,
                    color: indexxx == 2 ? Colors.black : Colors.black,
                  ),
                ),
              ),
              navItem(
                icon: Icons.medical_information,
                label: 'Medicines',
                pageIndex: 3,
              ),
              navItem(icon: Icons.settings, label: 'Settings', pageIndex: 4),
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
          Icon(icon, color: isSelected ? Colors.teal : Colors.grey),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.teal : Colors.grey,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
