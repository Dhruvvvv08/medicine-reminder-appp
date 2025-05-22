import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:healthmvp/ViewModel/dashboard_viewmodel.dart';
import 'package:healthmvp/ViewModel/profile_authmodel.dart';
import 'package:healthmvp/models/dashboard/dashboard.dart';
import 'package:healthmvp/models/dependent/dependent_model.dart';
import 'package:healthmvp/view/bottom_nav_bar/bottom_nav.dart';
import 'package:healthmvp/view/dependent/dependent_explore.dart';
import 'package:healthmvp/view/home/Medicine/add_medicine.dart';
import 'package:healthmvp/view/home/Medicine/create_reminder.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DependentDashboard extends StatefulWidget {
  String dependentid;
  DependentDashboard({super.key, required this.dependentid});

  @override
  _DependentDashboardState createState() => _DependentDashboardState();
}

class _DependentDashboardState extends State<DependentDashboard> {
  int _selectedIndex = 0;
  ProfileAuthmodel? dashboardViewModel;

  final date = DateTime.now();

  @override
  void initState() {
    super.initState();
    dashboardViewModel = Provider.of<ProfileAuthmodel>(context, listen: false);
    _fetchDashboardData();
  }

  String dateee = DateFormat('yyyy-MM-dd').format(DateTime.now());

  String? dependentid;
  Future<void> _fetchDashboardData() async {
    try {
      await dashboardViewModel?.getdependentdashboard(
        context,
        dateee,
        widget.dependentid,
      );
    } catch (e) {
      // Handle error appropriately
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load dashboard data: $e')),
      );
    }
  }

  String _getGreeting() {
    return "Dependent Dashboard";
  }

  @override
  Widget build(BuildContext context) {
    final controllerProvider = Provider.of<ProfileAuthmodel>(context);

    return Scaffold(
      body:
          controllerProvider.dependentloading == true
              ? Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                onRefresh: _fetchDashboardData,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 50),
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          _getGreeting(),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          controllerProvider
                                              .dependentdashboard!
                                              .data
                                              .user
                                              .name,
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
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
                                              controllerProvider
                                                          .dependentdashboard!
                                                          .data
                                                          .reminderCounts
                                                          .total ==
                                                      0
                                                  ? 0.0
                                                  : controllerProvider
                                                          .dependentdashboard!
                                                          .data
                                                          .reminderCounts
                                                          .taken
                                                          .toDouble() /
                                                      controllerProvider
                                                          .dependentdashboard!
                                                          .data
                                                          .reminderCounts
                                                          .total,
                                          backgroundColor: Colors.grey[200],
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                Theme.of(context).primaryColor,
                                              ),
                                          minHeight: 12,
                                        ),
                                      ),
                                      const SizedBox(height: 16),

                                      // Stat Counters
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          _buildStatItem(
                                            context,
                                            Icons.check_circle,
                                            Colors.green,
                                            controllerProvider
                                                .dependentdashboard!
                                                .data
                                                .reminderCounts
                                                .taken,
                                            "Taken",
                                          ),
                                          _buildStatItem(
                                            context,
                                            Icons.cancel,
                                            Colors.red,
                                            controllerProvider
                                                .dependentdashboard!
                                                .data
                                                .reminderCounts
                                                .missed,
                                            "Missed",
                                          ),
                                          _buildStatItem(
                                            context,
                                            Icons.access_time,
                                            Colors.orange,
                                            controllerProvider
                                                .dependentdashboard!
                                                .data
                                                .reminderCounts
                                                .pending,
                                            "Pending",
                                          ),
                                          _buildStatItem(
                                            context,
                                            Icons.calendar_today,
                                            Theme.of(context).primaryColor,
                                            controllerProvider
                                                .dependentdashboard!
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFFEF3C7),
                                            borderRadius: BorderRadius.circular(
                                              50,
                                            ),
                                          ),
                                          child: const Icon(
                                            Icons.emoji_events,
                                            color: Color(0xFFEFB700),
                                            size: 24,
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
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
                                      "${controllerProvider.dependentdashboard?.data.streakPoints}",
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
                                      "View Reminders",
                                      Icons.calendar_today,
                                      const Color(0xFF8B5CF6),
                                      () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder:
                                                (context) => DependentExpore(
                                                  dependentid:
                                                      widget.dependentid
                                                          .toString(),
                                                ),
                                          ),
                                        );
                                      },
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
                              if (controllerProvider
                                          .dependentdashboard
                                          ?.data
                                          .mostTakenMedicines !=
                                      null &&
                                  controllerProvider
                                      .dependentdashboard!
                                      .data
                                      .mostTakenMedicines
                                      .isNotEmpty)
                                ...List.generate(
                                  controllerProvider
                                      .dependentdashboard!
                                      .data
                                      .mostTakenMedicines
                                      .length,
                                  (index) => _buildMedicineItem(context, index),
                                )
                              else
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 80),
                                    child: Text(
                                      "No medicines available",
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
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

  Widget _buildActionButton(
    String label,
    IconData icon,
    Color color,
    Function() ontap,
  ) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: ontap,
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
    final medicine =
        dashboardViewModel?.dependentdashboard?.data.mostTakenMedicines[index];

    final emojiMap = {
      'tablet': '⚪',
      'injection': '💉',
      'liquid': '💧',
      'capsule': '💊',
    };

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
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFFDBEAFE),
                  borderRadius: BorderRadius.circular(20),
                ),
                alignment: Alignment.center,
                child: Text(
                  emojiMap[medicine!.category.toLowerCase()] ?? '💊',
                  style: const TextStyle(fontSize: 20),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    medicine.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    medicine.category,
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
              "${medicine.count} times",
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
