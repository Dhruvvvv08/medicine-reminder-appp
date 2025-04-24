import 'package:flutter/material.dart';
import 'package:healthmvp/Utils/textstyles.dart';
import 'package:healthmvp/ViewModel/dashboard_viewmodel.dart';
import 'package:healthmvp/widgets/customdropdown.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  DashboardViewmodel? dashboardmodell;

  String? val;
  String? val2;

  @override
  void initState() {
    dashboardmodell = Provider.of<DashboardViewmodel>(context, listen: false);
    dashboardmodell?.getdashboarddata(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<DashboardViewmodel>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Color(0xfff0f9fc),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back),
                        color: Color(0xff000000),
                        onPressed: () {
                          // context.go('/bottomnavbar');
                        },
                      ),
                    ),
                    SizedBox(width: 60),
                    Text("Dashboard", style: u_20_500_k000000),
                  ],
                ),
                const SizedBox(height: 24),

                // Dropdowns
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: CustomDropdown(
                        data:
                            [
                              "Paracetamol",
                              "Crocine",
                              "All Medicine",
                            ].toSet().toList() ??
                            [],

                        onChanged: (String? newValue) {
                          val = newValue;
                        },
                        hintText: "All Medicine",
                        selectedValue: val,
                      ),
                    ),
                    SizedBox(width: 40),
                    Expanded(
                      child: CustomDropdown(
                        data:
                            [
                              "Today",
                              "This week",
                              "This Month",
                            ].toSet().toList() ??
                            [],

                        onChanged: (String? newValue) {
                          val2 = newValue;
                        },
                        hintText: "This Month",
                        selectedValue: val2,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Progress Chart
                const Text(
                  'Progress',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                // Container(
                //   padding: const EdgeInsets.all(16),
                //   decoration: BoxDecoration(
                //     color: const Color(0xFFEFF7FF),
                //     borderRadius: BorderRadius.circular(16),
                //   ),
                //   child: Column(
                //     children: [
                //       CircularPercentIndicator(
                //         radius: 60.0,
                //         lineWidth: 10.0,
                //         percent: 0.68,
                //         center: const Text(
                //           "68%",
                //           style: TextStyle(fontWeight: FontWeight.bold),
                //         ),
                //         circularStrokeCap: CircularStrokeCap.round,
                //         backgroundColor: Colors.grey.shade200,
                //         progressColor: const Color(0xFF5E57EA),
                //       ),
                //       const SizedBox(height: 16),
                //       // Row(
                //       //   mainAxisAlignment: MainAxisAlignment.center,
                //       //   children: [
                //       //     _buildLegendCircle(Colors.green, 'Week 01'),
                //       //     const SizedBox(width: 16),
                //       //     _buildLegendCircle(Colors.blue, 'Week 02'),
                //       //     const SizedBox(width: 16),
                //       //     _buildLegendCircle(Colors.orange, 'Week 03'),
                //       //   ],
                //       // )
                //       // ,
                //     ],
                //   ),
                // ),
                const SizedBox(height: 24),

                // Analysis Section
                // const Text(
                //   'Analysis',
                //   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                // ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 20,
                  runSpacing: 12,

                  children: [
                    _buildAnalysisBox(
                      'Taken',
                      '${controller.dashboardata?.data.reminderCounts.taken}',
                    ),
                    _buildAnalysisBox(
                      'Missed',
                      '${controller.dashboardata?.data.reminderCounts.missed}',
                    ),
                    _buildAnalysisBox(
                      'Pending',
                      '${controller.dashboardata?.data.reminderCounts.pending}',
                    ),
                    _buildAnalysisBox(
                      'Total',
                      '${controller.dashboardata?.data.reminderCounts.total}',
                    ),
                    _buildAnalysisBox(
                      'Points',
                      '${controller.dashboardata?.data.streakPoints}',
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Achievements
                const Text(
                  'Achievement',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF7FF),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: const [
                      _AchievementIcon(color: Colors.blue, label: 'Level 01'),
                      _AchievementIcon(color: Colors.orange, label: 'Level 02'),
                      _AchievementIcon(color: Colors.red, label: 'Level 03'),
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

  Widget _buildDropdown(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF7FF),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
          const Icon(Icons.keyboard_arrow_down),
        ],
      ),
    );
  }

  Widget _buildLegendCircle(Color color, String label) {
    return Row(
      children: [
        CircleAvatar(radius: 5, backgroundColor: color),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _buildAnalysisBox(String title, String value) {
    return Container(
      width: 150,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF7FF),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(title, style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class _AchievementIcon extends StatelessWidget {
  final Color color;
  final String label;

  const _AchievementIcon({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(Icons.emoji_events, color: color, size: 36),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
      ],
    );
  }
}
