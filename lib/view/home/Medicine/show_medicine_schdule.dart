import 'package:flutter/material.dart';
import 'package:healthmvp/Utils/colors.dart';
import 'package:healthmvp/Utils/textstyles.dart';

class MedicineSchedule extends StatefulWidget {
  @override
  State<MedicineSchedule> createState() => _MedicineScheduleState();
}

class _MedicineScheduleState extends State<MedicineSchedule> {
  final List<String> days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  final List<int> dates = [16, 17, 18, 19, 20, 21, 22];
  int selectedDayIndex = 3; 

  final List<Map<String, String>> medicines = [
    {'name': 'Melformin 500mg tablets', 'time': '8:30 AM'},
    {'name': 'Paracetamol', 'time': '8:30 AM'},
    {'name': 'Omega - 4', 'time': '8:30 AM'},
    {'name': 'Vitamin C', 'time': '8:30 AM'},
  ];
 bool selected=false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       backgroundColor:kf0f9ff,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              SizedBox(height: 20),
              _buildDatePicker(),
              SizedBox(height: 20),
              Text('Today', style: u_20_500_k000000),
              SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: medicines.length,
                  itemBuilder: (context, index) {
                    return _buildMedicineCard(
                      title: medicines[index]['name']!,
                      time: medicines[index]['time']!,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),

    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            // CircleAvatar(
            //   backgroundImage: AssetImage('assets/user.jpg'),
            //   radius: 22,
            // ),
            SizedBox(width: 10),
            Text('Dhruv Madaan', style: u_15_500_k000000),
          ],
        ),
        Icon(Icons.menu, size: 26),
      ],
    );
  }

  Widget _buildDatePicker() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(7, (index) {
        final isSelected = index == selectedDayIndex;
        return GestureDetector(
          onTap: () {
            setState(() {
              selectedDayIndex = index;
         
            });
          },
          child: Column(
            children: [
              Text(days[index], style: u_14_500_kkc0c0c0),
              SizedBox(height: 6),
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isSelected ? Color(0xFF5E57EA) : Colors.transparent,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  dates[index].toString(),
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                    fontWeight: FontWeight.bold,
                 fontFamily: "Urbanist",
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildMedicineCard({required String title, required String time}) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Color(0xFFEFF7FF),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 45,
            height: 65,
            decoration: BoxDecoration(
              color: Color(0xFFD5D4FF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.local_pharmacy, color: Color(0xFF5E57EA)),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.circle, size: 12, color: Colors.grey),
                    SizedBox(width: 4),
                    Text('1 Pill'),
                    SizedBox(width: 12),
                    Icon(Icons.schedule, size: 12, color: Colors.grey),
                    SizedBox(width: 4),
                    Text(time),
                  ],
                ),
              ],
            ),
          ),
          selected==true?   Icon(Icons.check_circle, color: Colors.green):  Icon(Icons.cancel, color: Colors.red)
        ],
      ),
    );
  }

  // Widget _buildBottomNav() {
  //   return BottomNavigationBar(
  //     currentIndex: 0,
  //     type: BottomNavigationBarType.fixed,
  //     selectedItemColor: Color(0xFF5E57EA),
  //     items: [
  //       BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
  //       BottomNavigationBarItem(icon: Icon(Icons.edit), label: ''),
  //       BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: ''),
  //       BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: ''),
  //     ],
  //   );
  // }
}
