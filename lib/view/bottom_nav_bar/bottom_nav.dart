import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:healthmvp/view/Auth/login_screen.dart';
import 'package:healthmvp/view/home/Dashbaord/dashboard.dart';
import 'package:healthmvp/view/home/Medicine/show_medicine.dart';
import 'package:healthmvp/view/home/Medicine/show_medicine_schdule.dart';
import 'package:healthmvp/view/setting/Setting_screen.dart';

class Botoomnavbar extends StatefulWidget {
  const Botoomnavbar({super.key});

  @override
  State<Botoomnavbar> createState() => _BotoomnavbarState();
}

class _BotoomnavbarState extends State<Botoomnavbar> {
  PageController _pageController=PageController(initialPage: 0);
  int indexxx=0;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(), // Disable swipe if you want only tap nav
        children:  [
          Center(child: DashboardScreen()),
          Center(child: MedicineSchedule()),
          Center(child: MedicineScreen()),
          Center(child: ProfileScreen()),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterDocked,
      
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blue,
        onPressed: () {
         context.go('/addmedicine');
        },
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 6.0,
        color: Colors.blue,
        child: SizedBox(
          height: kBottomNavigationBarHeight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.home_outlined,
                  color: indexxx == 0 ? Colors.white : Colors.black,
                ),
                onPressed: () {
                  setState(() {
                    indexxx = 0;
                    _pageController.jumpToPage(0);
                  });
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.search,
                  color: indexxx == 1 ? Colors.white : Colors.black,
                ),
                onPressed: () {
                  setState(() {
                    indexxx = 1;
                    _pageController.jumpToPage(1);
                  });
                },
              ),
              const SizedBox(width: 40), // Space for FAB
              IconButton(
                icon: Icon(
                  Icons.favorite_border_outlined,
                  color: indexxx == 2 ? Colors.white : Colors.black,
                ),
                onPressed: () {
                  setState(() {
                    indexxx = 2;
                    _pageController.jumpToPage(2);
                  });
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.account_circle_outlined,
                  color: indexxx == 3 ? Colors.white : Colors.black,
                ),
                onPressed: () {
                  setState(() {
                    indexxx = 3;
                    _pageController.jumpToPage(3);
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );

  }
}