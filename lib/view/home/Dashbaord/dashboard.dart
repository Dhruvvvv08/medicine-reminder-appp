import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:healthmvp/ViewModel/dashboard_viewmodel.dart';
import 'package:healthmvp/models/dashboard/dashboard.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // Sample user data (in real app, this would come from API or local storage)
  final userData = {
    "user": {"name": "Manas Baranwal", "email": "mystmanas@mailinator.com"},
    "reminderCounts": {"taken": 10, "missed": 7, "pending": 14, "total": 31},
    "streakPoints": 1,
    "mostTakenMedicines": [
      {"count": 6, "name": "Vitamin C", "category": "tablet"},
      {"count": 5, "name": "vhh", "category": "Tablet"},
      {"count": 2, "name": "gsbsb", "category": "Tablet / Capsule"},
      {"count": 1, "name": "dhruvv", "category": "Tablet / Capsule"},
      {"count": 1, "name": "gy", "category": "Cream / Ointment / Gel"},
    ],
  };

  int _selectedIndex = 0;
  DashboardViewmodel? dashboardmedicinemodelll;
  final date = DateTime.now();
  @override
  void initState() {
    dashboardmedicinemodelll = Provider.of<DashboardViewmodel>(
      context,
      listen: false,
    );
    dashboardmedicinemodelll?.getdashboarddata(context);
    super.initState();
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good morning';
    } else if (hour < 17) {
      return 'Good afternoon';
    } else {
      return 'Good evening';
    }
  }

  @override
  Widget build(BuildContext context) {
    final contollerprovider = Provider.of<DashboardViewmodel>(context);
    // Calculate completion percentage
    final completionPercentage = ((1) / 31 * 100).round();

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Section
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Color(0xFF2563EB),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.only(top: 20),
                child: Column(
                  children: [
                    // Greeting and Icons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _getGreeting() + ',',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              contollerprovider.dashboardata!.data.user.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Today's Progress Card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Today's Progress",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  color: Color(0xFF1F2937),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Progress Bar
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: LinearProgressIndicator(
                              value:
                                  contollerprovider
                                      .dashboardata!
                                      .data
                                      .reminderCounts
                                      .taken
                                      .toDouble() /
                                  contollerprovider
                                      .dashboardata!
                                      .data
                                      .reminderCounts
                                      .total,
                              backgroundColor: Colors.grey[200],
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Theme.of(context).primaryColor,
                              ),
                              minHeight: 12,
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Stat Counters
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildStatItem(
                                context,
                                Icons.check_circle,
                                Colors.green,
                                contollerprovider
                                    .dashboardata!
                                    .data
                                    .reminderCounts
                                    .taken,
                                "Taken",
                              ),
                              _buildStatItem(
                                context,
                                Icons.cancel,
                                Colors.red,
                                contollerprovider
                                    .dashboardata!
                                    .data
                                    .reminderCounts
                                    .missed,
                                "Missed",
                              ),
                              _buildStatItem(
                                context,
                                Icons.access_time,
                                Colors.orange,
                                contollerprovider
                                    .dashboardata!
                                    .data
                                    .reminderCounts
                                    .pending,
                                "Pending",
                              ),
                              _buildStatItem(
                                context,
                                Icons.calendar_today,
                                Theme.of(context).primaryColor,
                                contollerprovider
                                    .dashboardata!
                                    .data
                                    .reminderCounts
                                    .total,
                                "Total",
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Main Content
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Streak Card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFEF3C7),
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: const Icon(
                                Icons.emoji_events,
                                color: Color(0xFFEFB700),
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Streak Points",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    color: Color(0xFF1F2937),
                                  ),
                                ),
                                Text(
                                  "Keep taking your medicines on time",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Text(
                          "${userData['streakPoints']}",
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFEFB700),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Quick Actions
                  Row(
                    children: [
                      Expanded(
                        child: _buildActionButton(
                          "Add Redminder",
                          Icons.add,
                          const Color(0xFF2563EB),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildActionButton(
                          "View Reminders",
                          Icons.calendar_today,
                          const Color(0xFF8B5CF6),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Most Taken Medicines
                  const Text(
                    "Most Taken Medicines",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...List.generate(
                    (userData['mostTakenMedicines'] as List).length,
                    (index) => _buildMedicineItem(context, index),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      // bottomNavigationBar: _buildBottomNavigationBar(),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {},
      //   backgroundColor: const Color(0xFF2563EB),
      //   child: const Icon(Icons.add),
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    IconData icon,
    Color color,
    int count,
    String label,
  ) {
    return Column(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 4),
        Text(
          "$count",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
      ],
    );
  }

  Widget _buildActionButton(String label, IconData icon, Color color) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 28),
              const SizedBox(height: 8),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMedicineItem(BuildContext context, int index) {
    final medicine = (userData['mostTakenMedicines'] as List)[index];

    // Select color based on index
    Color avatarColor;
    if (index == 0) {
      avatarColor = const Color(0xFF2563EB);
    } else if (index == 1) {
      avatarColor = const Color(0xFF8B5CF6);
    } else if (index == 2) {
      avatarColor = const Color(0xFF10B981);
    } else {
      avatarColor = Colors.grey;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: avatarColor,
                radius: 20,
                child: Text(
                  (medicine['name'] as String)[0].toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    medicine['name'] as String,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    medicine['category'] as String,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(50),
            ),
            child: Text(
              "${medicine['count']}x",
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  // Widget _buildBottomNavigationBar() {
  //   return BottomAppBar(
  //     shape: const CircularNotchedRectangle(),
  //     notchMargin: 8,
  //     child: Padding(
  //       padding: const EdgeInsets.symmetric(horizontal: 10),
  //       child: Row(
  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //         children: [
  //           _buildNavItem(0, Icons.home, "Home"),
  //           _buildNavItem(1, Icons.calendar_today, "Schedule"),
  //           // Empty space for FAB
  //           const SizedBox(width: 40),
  //           _buildNavItem(2, Icons.notifications_outlined, "Reminders"),
  //           _buildNavItem(3, Icons.person, "Profile"),
  //         ],
  //       ),
  //     ),
  //   );
}

  // Widget _buildNavItem(int index, IconData icon, String label) {
  //   final isSelected = _selectedIndex == index;
  //   return InkWell(
  //     onTap: () {
  //       setState(() {
  //         _selectedIndex = index;
  //       });
  //     },
  //     child: Padding(
  //       padding: const EdgeInsets.all(12.0),
  //       child: Column(
  //         mainAxisSize: MainAxisSize.min,
  //         children: [
  //           Icon(
  //             icon,
  //             color:
  //                 isSelected
  //                     ? Theme.of(context).primaryColor
  //                     : Colors.grey[400],
  //           ),
  //           const SizedBox(height: 4),
  //           Text(
  //             label,
  //             style: TextStyle(
  //               fontSize: 12,
  //               color:
  //                   isSelected
  //                       ? Theme.of(context).primaryColor
  //                       : Colors.grey[400],
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
//}
