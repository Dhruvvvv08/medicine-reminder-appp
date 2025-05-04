import 'package:flutter/material.dart';
import 'package:healthmvp/ViewModel/reminder_authviewmodel.dart';
import 'package:healthmvp/models/remindersmodel/reminder_model.dart';
import 'package:healthmvp/view/bottom_nav_bar/bottom_nav.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class MedicationReminderScreen extends StatefulWidget {
  const MedicationReminderScreen({Key? key}) : super(key: key);

  @override
  State<MedicationReminderScreen> createState() =>
      _MedicationReminderScreenState();
}

class _MedicationReminderScreenState extends State<MedicationReminderScreen> {
  DateTime selectedDate = DateTime.now();
  String filterStatus = 'all';
  bool showEmptyState = false;

  ReminderAuthviewmodel? reminderauthmodel;

  @override
  void initState() {
    super.initState();
    reminderauthmodel = Provider.of<ReminderAuthviewmodel>(
      context,
      listen: false,
    );
    _fetchReminders();
  }

  void _fetchReminders() {
    final status = filterStatus == 'all' ? 'pending' : filterStatus;
    reminderauthmodel?.getreminderoftheday(
      context,
      DateFormat('yyyy-MM-dd').format(selectedDate),
      status,
    );
  }

  void goToPreviousDay() {
    setState(() {
      selectedDate = selectedDate.subtract(const Duration(days: 1));
      _fetchReminders();
    });
  }

  void goToNextDay() {
    setState(() {
      selectedDate = selectedDate.add(const Duration(days: 1));
      _fetchReminders();
    });
  }

  void updateReminderStatus(String id, String newStatus) {
    // Here you should call an API to update the status
    // For now, we'll just refetch the data
    setState(() {
      filterStatus = newStatus;
      _fetchReminders();
    });
  }

  List<Datum> getFilteredReminders() {
    if (showEmptyState) return [];
    if (reminderauthmodel?.remindermodell == null) return [];

    // If filter is 'all', return all reminders regardless of status
    if (filterStatus == 'all') {
      return reminderauthmodel!.remindermodell!.data;
    }

    // Otherwise filter by status
    return reminderauthmodel!.remindermodell!.data
        .where((reminder) => reminder.status == filterStatus)
        .toList();
  }

  String formatTime(String time) {
    final timeParts = time.split(':');
    final hour = int.parse(timeParts[0]);
    final minute = timeParts[1];
    final period = hour >= 12 ? 'PM' : 'AM';
    final hour12 = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    return '$hour12:$minute $period';
  }

  @override
  Widget build(BuildContext context) {
    final filteredReminders = getFilteredReminders();
    final dateFormat = DateFormat('EEEE, MMMM d');

    return Scaffold(
      body: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.fromLTRB(16, 50, 16, 20),
            decoration: const BoxDecoration(
              color: Color(0xFF2563EB),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Medication Reminders',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Manage your medications',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.blue.shade500,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.notifications_outlined,
                      color: Colors.white,
                    ),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ),

          // Main content
          Expanded(
            child: Consumer<ReminderAuthviewmodel>(
              builder: (context, model, child) {
                if (model.isreminderloading) {
                  return const Center(child: CircularProgressIndicator());
                }

                return ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    // Date selector
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.chevron_left,
                              color: Color(0xFF2563EB),
                            ),
                            onPressed: goToPreviousDay,
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.calendar_today,
                                size: 18,
                                color: Color(0xFF2563EB),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                dateFormat.format(selectedDate),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.chevron_right,
                              color: Color(0xFF2563EB),
                            ),
                            onPressed: goToNextDay,
                          ),
                        ],
                      ),
                    ),

                    // Filter tabs
                    Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 2,
                      shadowColor: Colors.black.withOpacity(0.05),
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Reminders',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                _buildFilterButton('All', 'all'),
                                const SizedBox(width: 8),
                                _buildFilterButton('Pending', 'pending'),
                                const SizedBox(width: 8),
                                _buildFilterButton('Taken', 'taken'),
                                const SizedBox(width: 8),
                                _buildFilterButton('Missed', 'missed'),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Reminders list
                    Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 2,
                      shadowColor: Colors.black.withOpacity(0.05),
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child:
                            filteredReminders.isEmpty
                                ? _buildEmptyState()
                                : Column(
                                  children:
                                      filteredReminders.map((reminder) {
                                        return _buildReminderItem(reminder);
                                      }).toList(),
                                ),
                      ),
                    ),

                    // Add New button
                    Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 2,
                      shadowColor: Colors.black.withOpacity(0.05),
                      color: Colors.white,
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => Botoomnavbar(initialIndex: 2),
                            ),
                          );
                        },
                        borderRadius: BorderRadius.circular(16),
                        child: const Padding(
                          padding: EdgeInsets.all(16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '+',
                                style: TextStyle(
                                  fontSize: 24,
                                  color: Color(0xFF3B82F6),
                                ),
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Add New Reminder',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF3B82F6),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 60),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterButton(String label, String value) {
    final isSelected = filterStatus == value;

    return Expanded(
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            filterStatus = value;
            _fetchReminders();
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor:
              isSelected ? const Color(0xFF3B82F6) : const Color(0xFFF3F4F6),
          foregroundColor: isSelected ? Colors.white : Colors.black87,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 10),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 120,
            width: 120,
            child: CustomPaint(painter: EmptyStatePainter()),
          ),
          const SizedBox(height: 16),
          const Text(
            'No reminders found',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 4),
          const Text(
            'Try changing your filters or add a new reminder',
            style: TextStyle(fontSize: 14, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildReminderItem(Datum reminder) {
    final emojiMap = {
      'tablet': '💊',
      'injection': '💉',
      'liquid': '💧',
      'capsule': '💊',
    };

    final statusColorMap = {
      'pending': const Color(0xFFDBEAFE),
      'taken': const Color(0xFFDCFCE7),
      'missed': const Color(0xFFFEE2E2),
    };

    final statusTextColorMap = {
      'pending': const Color(0xFF1E40AF),
      'taken': const Color(0xFF15803D),
      'missed': const Color(0xFFB91C1C),
    };

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.withOpacity(0.2), width: 1),
        ),
      ),
      child: Column(
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
                  emojiMap[reminder.medicineCategory.toLowerCase()] ?? '💊',
                  style: const TextStyle(fontSize: 20),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      reminder.medicineName,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Text(
                      reminder.medicineCategory.capitalize(),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  const Icon(
                    Icons.access_time,
                    size: 16,
                    color: Color(0xFF3B82F6),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    formatTime(reminder.time),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color:
                      statusColorMap[reminder.status] ?? Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  reminder.status.capitalize(),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color:
                        statusTextColorMap[reminder.status] ??
                        Colors.grey.shade800,
                  ),
                ),
              ),
              Row(
                children: [
                  _buildStatusButton(
                    icon: Icons.check,
                    color: Colors.green,
                    isSelected: reminder.status == 'taken',
                    onTap:
                        () =>
                            updateReminderStatus(reminder.reminderId, 'taken'),
                  ),
                  const SizedBox(width: 6),
                  _buildStatusButton(
                    icon: Icons.close,
                    color: Colors.red,
                    isSelected: reminder.status == 'missed',
                    onTap:
                        () =>
                            updateReminderStatus(reminder.reminderId, 'missed'),
                  ),
                  const SizedBox(width: 6),
                  _buildStatusButton(
                    icon: Icons.access_time,
                    color: Colors.blue,
                    isSelected: reminder.status == 'pending',
                    onTap:
                        () => updateReminderStatus(
                          reminder.reminderId,
                          'pending',
                        ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusButton({
    required IconData icon,
    required Color color,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.1) : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(icon, size: 16, color: isSelected ? color : Colors.grey),
      ),
    );
  }
}

class EmptyStatePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    // Background circle
    paint.color = const Color(0xFFEFF6FF);
    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      size.width * 0.4,
      paint,
    );

    // Pill shape
    paint.color = const Color(0xFF93C5FD);
    final pillRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(size.width / 2, size.height / 2),
        width: size.width * 0.6,
        height: size.width * 0.25,
      ),
      Radius.circular(size.width * 0.125),
    );
    canvas.drawRRect(pillRect, paint);

    // Pill division line
    paint.color = const Color(0xFFDBEAFE);
    paint.strokeWidth = 2;
    canvas.drawLine(
      Offset(size.width / 2, size.height / 2 - size.width * 0.125),
      Offset(size.width / 2, size.height / 2 + size.width * 0.125),
      paint,
    );

    // Clock outline
    paint.color = const Color(0xFF3B82F6);
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 3;
    canvas.drawCircle(
      Offset(size.width * 0.7, size.height * 0.3),
      size.width * 0.15,
      paint,
    );

    // Clock hands
    canvas.drawLine(
      Offset(size.width * 0.7, size.height * 0.3),
      Offset(size.width * 0.7, size.height * 0.2),
      paint,
    );
    canvas.drawLine(
      Offset(size.width * 0.7, size.height * 0.3),
      Offset(size.width * 0.8, size.height * 0.3),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}
