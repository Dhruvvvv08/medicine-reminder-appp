import 'package:flutter/material.dart';
import 'package:healthmvp/ViewModel/dashboard_viewmodel.dart';
import 'package:healthmvp/view/bottom_nav_bar/bottom_nav.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchDashboardData();
    });
  }

  Future<void> _fetchDashboardData() async {
    final dashboardViewModel = context.read<DashboardViewmodel>();
    await dashboardViewModel.getdashboarddata(context);
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 17) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardViewmodel>(
      builder: (context, controllerProvider, child) {
        if (controllerProvider.isdashboardloading &&
            controllerProvider.dashboardata == null) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controllerProvider.errorMessage.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(controllerProvider.errorMessage),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _fetchDashboardData,
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }
        return Scaffold(
          backgroundColor: Colors.grey[100],
          body: RefreshIndicator(
            onRefresh: _fetchDashboardData,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 50),
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
                        padding: const EdgeInsets.only(top: 20),
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
                                      '${_getGreeting()},',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      controllerProvider
                                              .dashboardata
                                              ?.data
                                              .user
                                              .name ??
                                          'User',
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
                                  const Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
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
                                          (controllerProvider
                                                          .dashboardata
                                                          ?.data
                                                          .reminderCounts
                                                          .total ??
                                                      0) ==
                                                  0
                                              ? 0.0
                                              : (controllerProvider
                                                              .dashboardata
                                                              ?.data
                                                              .reminderCounts
                                                              .taken ??
                                                          0)
                                                      .toDouble() /
                                                  (controllerProvider
                                                          .dashboardata
                                                          ?.data
                                                          .reminderCounts
                                                          .total ??
                                                      1),
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      _buildStatItem(
                                        context,
                                        Icons.check_circle,
                                        Colors.green,
                                        controllerProvider
                                                .dashboardata
                                                ?.data
                                                .reminderCounts
                                                .taken ??
                                            0,
                                        "Taken",
                                      ),
                                      _buildStatItem(
                                        context,
                                        Icons.cancel,
                                        Colors.red,
                                        controllerProvider
                                                .dashboardata
                                                ?.data
                                                .reminderCounts
                                                .missed ??
                                            0,
                                        "Missed",
                                      ),
                                      _buildStatItem(
                                        context,
                                        Icons.access_time,
                                        Colors.orange,
                                        controllerProvider
                                                .dashboardata
                                                ?.data
                                                .reminderCounts
                                                .pending ??
                                            0,
                                        "Pending",
                                      ),
                                      _buildStatItem(
                                        context,
                                        Icons.calendar_today,
                                        Theme.of(context).primaryColor,
                                        controllerProvider
                                                .dashboardata
                                                ?.data
                                                .reminderCounts
                                                .total ??
                                            0,
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
                                    const Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
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
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Text(
                                  "${controllerProvider.dashboardata?.data.streakPoints ?? 0}",
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
                                  "Add Reminder",
                                  Icons.add,
                                  const Color(0xFF2563EB),
                                  () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) =>
                                                Botoomnavbar(initialIndex: 2),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(width: 16),
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
                                            (context) =>
                                                Botoomnavbar(initialIndex: 1),
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
                                      .dashboardata
                                      ?.data
                                      .mostTakenMedicines !=
                                  null &&
                              controllerProvider
                                  .dashboardata!
                                  .data
                                  .mostTakenMedicines
                                  .isNotEmpty)
                            ...List.generate(
                              controllerProvider
                                  .dashboardata!
                                  .data
                                  .mostTakenMedicines
                                  .length,
                              (index) => _buildMedicineItem(
                                context,
                                index,
                                controllerProvider,
                              ),
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
      },
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
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }

  // PreferredSize _buildappbar() {
  //   return
  // }

  Widget _buildActionButton(
    String label,
    IconData icon,
    Color color,
    VoidCallback onTap,
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
          onTap: onTap,
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

  Widget _buildMedicineItem(
    BuildContext context,
    int index,
    DashboardViewmodel controllerProvider,
  ) {
    final medicine =
        controllerProvider.dashboardata!.data.mostTakenMedicines[index];
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
                  emojiMap[medicine.category.toLowerCase()] ?? '💊',
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
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
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
