import 'package:flutter/material.dart';
import 'package:healthmvp/ViewModel/addmedicine_authmodel.dart';
import 'package:healthmvp/services/notification_service.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ModernReminderScreen extends StatefulWidget {
  const ModernReminderScreen({Key? key}) : super(key: key);

  @override
  State<ModernReminderScreen> createState() => _ModernReminderScreenState();
}

class _ModernReminderScreenState extends State<ModernReminderScreen> {
  // Sample database of common medicines
  final List<Map<String, String>> commonMedicines = [
    {"name": "Vitamin C", "category": "tablet"},
    {"name": "Aspirin", "category": "tablet"},
    {"name": "Ibuprofen", "category": "tablet"},
    {"name": "Paracetamol", "category": "tablet"},
    {"name": "Amoxicillin", "category": "capsule"},
    {"name": "Lisinopril", "category": "tablet"},
    {"name": "Metformin", "category": "tablet"},
    {"name": "Atorvastatin", "category": "tablet"},
    {"name": "Omeprazole", "category": "capsule"},
    {"name": "Levothyroxine", "category": "tablet"},
  ];

  // Form data
  final formData = {
    'medicine_name': "",
    'medicine_dosage': "1",
    'medicine_instructions': "",
    'medicine_category': "tablet",
    'scheduleStart': DateTime.now(),
    'scheduleEnd': DateTime.now().add(const Duration(days: 4)),
    'frequency': "custom",
    'customTimes': <TimeOfDay>[
      const TimeOfDay(hour: 8, minute: 0),
      const TimeOfDay(hour: 18, minute: 30),
    ],
    'repeat': "daily",
  };

  String searchTerm = "";
  bool showDropdown = false;
  List<Map<String, String>> filteredMedicines = [];
  bool reminderNotifications = true;
  bool missedDoseAlerts = true;

  // @override
  // void initState() {
  //   super.initState();
  //   filteredMedicines = commonMedicines;
  // }

  void handleInputChange(String field, dynamic value) {
    setState(() {
      formData[field] = value;
    });
  }

  void handleMedicineSelect(
    Map<String, String> medicine,
    TextEditingController? txt,
  ) {
    setState(() {
      formData['medicine_name'] = medicine['name']!;
      txt?.text = medicine['name']!;
      formData['medicine_category'] = medicine['category']!;
      searchTerm = medicine['name'] ?? "";
      showDropdown = false;
    });
  }

  void handleAddTime() {
    setState(() {
      List<TimeOfDay> times = List<TimeOfDay>.from(
        formData['customTimes'] as List<TimeOfDay>,
      );
      times.add(const TimeOfDay(hour: 12, minute: 0));
      formData['customTimes'] = times;
    });
  }

  void handleRemoveTime(int index) {
    setState(() {
      List<TimeOfDay> times = List<TimeOfDay>.from(
        formData['customTimes'] as List<TimeOfDay>,
      );
      times.removeAt(index);
      formData['customTimes'] = times;
    });
  }

  void filterMedicines(String term) {
    setState(() {
      searchTerm = term;
      formData['medicine_name'] = term;

      if (term.isNotEmpty) {
        filteredMedicines =
            commonMedicines
                .where(
                  (med) =>
                      med['name']!.toLowerCase().contains(term.toLowerCase()),
                )
                .toList();
        showDropdown = true;
      } else {
        filteredMedicines = commonMedicines;
      }
    });
  }

  Future<void> _selectTime(BuildContext context, int index) async {
    List<TimeOfDay> times = List<TimeOfDay>.from(
      formData['customTimes'] as List<TimeOfDay>,
    );
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: times[index],
    );
    if (picked != null && picked != times[index]) {
      setState(() {
        times[index] = picked;
        formData['customTimes'] = times;
      });
    }
  }

  Future<void> _selectDate(BuildContext context, String field) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: formData[field] as DateTime,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (picked != null && picked != formData[field]) {
      setState(() {
        formData[field] = picked;
      });
    }
  }

  AddmedicineAuthmodel? addmedicineauthmodel;
  @override
  void initState() {
    addmedicineauthmodel = Provider.of<AddmedicineAuthmodel>(
      context,
      listen: false,
    );
    _notificationService.initialize();
    filteredMedicines = commonMedicines;
    super.initState();
  }

  final NotificationService _notificationService = NotificationService();
  @override
  Widget build(BuildContext context) {
    final medicineprovider = Provider.of<AddmedicineAuthmodel>(context);
    return Scaffold(
      body: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              color: Color(0xFF2563EB),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      'Create Reminder',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  'Start creating your',
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
                const Text(
                  'Medicine Reminder',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // Form Content
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Medicine Details Section
                Card(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.blue.shade50,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Icon(
                                Icons.check_circle_outline,
                                color: Color(0xFF2563EB),
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              'Medicine Details',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Medicine Name Field with Dropdown
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Medicine Name*',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: TextFormField(
                                controller:
                                    medicineprovider.medicinenamecontroller,
                                decoration: InputDecoration(
                                  hintText: 'Search or type medicine name',
                                  prefixIcon: const Icon(
                                    Icons.search,
                                    color: Colors.grey,
                                  ),
                                  suffixIcon: IconButton(
                                    icon: const Icon(
                                      Icons.arrow_drop_down,
                                      color: Colors.grey,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        showDropdown = !showDropdown;
                                      });
                                    },
                                  ),
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                    horizontal: 12,
                                  ),
                                ),
                                onChanged: filterMedicines,
                                // value: searchTerm,
                              ),
                            ),

                            // Dropdown for medicines
                            if (showDropdown)
                              Container(
                                margin: const EdgeInsets.only(top: 4),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.2),
                                      spreadRadius: 2,
                                      blurRadius: 8,
                                    ),
                                  ],
                                ),
                                constraints: const BoxConstraints(
                                  maxHeight: 200,
                                ),
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: filteredMedicines.length,
                                  itemBuilder: (context, index) {
                                    final medicine = filteredMedicines[index];
                                    return ListTile(
                                      leading: Container(
                                        width: 24,
                                        height: 24,
                                        decoration: BoxDecoration(
                                          color: Colors.blue.shade100,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Center(
                                          child: Text(
                                            medicine['name']![0],
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.blue,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                      title: Text(medicine['name']!),
                                      subtitle: Text(
                                        medicine['category']!,
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                      onTap:
                                          () => handleMedicineSelect(
                                            medicine,
                                            medicineprovider
                                                .medicinenamecontroller,
                                          ),
                                    );
                                  },
                                ),
                              ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // Dosage and Category
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Dosage',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade100,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: TextFormField(
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        contentPadding: EdgeInsets.symmetric(
                                          vertical: 12,
                                          horizontal: 12,
                                        ),
                                      ),
                                      keyboardType: TextInputType.number,
                                      initialValue:
                                          formData['medicine_dosage'] as String,
                                      onChanged:
                                          (value) => handleInputChange(
                                            'medicine_dosage',
                                            value,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Category',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade100,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                    ),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton<String>(
                                        isExpanded: true,
                                        value:
                                            formData['medicine_category']
                                                as String,
                                        items: const [
                                          DropdownMenuItem(
                                            value: 'tablet',
                                            child: Text('Tablet'),
                                          ),
                                          DropdownMenuItem(
                                            value: 'capsule',
                                            child: Text('Capsule'),
                                          ),
                                          DropdownMenuItem(
                                            value: 'liquid',
                                            child: Text('Liquid'),
                                          ),
                                          DropdownMenuItem(
                                            value: 'injection',
                                            child: Text('Injection'),
                                          ),
                                        ],
                                        onChanged: (value) {
                                          handleInputChange(
                                            'medicine_category',
                                            value,
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // Instructions
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Instructions',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: TextFormField(
                                decoration: const InputDecoration(
                                  hintText: 'e.g. take with water',
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                    vertical: 12,
                                    horizontal: 12,
                                  ),
                                ),
                                initialValue:
                                    formData['medicine_instructions'] as String,
                                onChanged:
                                    (value) => handleInputChange(
                                      'medicine_instructions',
                                      value,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Schedule Section
                Card(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.purple.shade50,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Icon(
                                Icons.calendar_today,
                                color: Colors.purple,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              'Schedule',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Date selection
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Start Date',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  InkWell(
                                    onTap:
                                        () => _selectDate(
                                          context,
                                          'scheduleStart',
                                        ),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 12,
                                        horizontal: 12,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade100,
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.calendar_today,
                                            size: 16,
                                            color: Colors.grey,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            DateFormat('yyyy-MM-dd').format(
                                              formData['scheduleStart']
                                                  as DateTime,
                                            ),
                                            style: const TextStyle(
                                              fontSize: 16,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'End Date',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  InkWell(
                                    onTap:
                                        () =>
                                            _selectDate(context, 'scheduleEnd'),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 12,
                                        horizontal: 12,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade100,
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.calendar_today,
                                            size: 16,
                                            color: Colors.grey,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            DateFormat('yyyy-MM-dd').format(
                                              formData['scheduleEnd']
                                                  as DateTime,
                                            ),
                                            style: const TextStyle(
                                              fontSize: 16,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // Frequency buttons
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Frequency',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed:
                                        () => handleInputChange(
                                          'frequency',
                                          'daily',
                                        ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          formData['frequency'] == 'daily'
                                              ? Colors.blue
                                              : Colors.grey.shade200,
                                      foregroundColor:
                                          formData['frequency'] == 'daily'
                                              ? Colors.white
                                              : Colors.black,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 12,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                    ),
                                    child: const Text('Daily'),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed:
                                        () => handleInputChange(
                                          'frequency',
                                          'weekly',
                                        ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          formData['frequency'] == 'weekly'
                                              ? Colors.blue
                                              : Colors.grey.shade200,
                                      foregroundColor:
                                          formData['frequency'] == 'weekly'
                                              ? Colors.white
                                              : Colors.black,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 12,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                    ),
                                    child: const Text('Weekly'),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed:
                                        () => handleInputChange(
                                          'frequency',
                                          'custom',
                                        ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          formData['frequency'] == 'custom'
                                              ? Color(0xFF2563EB)
                                              : Colors.grey.shade200,
                                      foregroundColor:
                                          formData['frequency'] == 'custom'
                                              ? Colors.white
                                              : Colors.black,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 12,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                    ),
                                    child: const Text('Custom'),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        if (formData['frequency'] == 'custom') ...[
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Time Schedule',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey,
                                ),
                              ),
                              TextButton.icon(
                                onPressed: handleAddTime,
                                icon: const Icon(
                                  Icons.add_circle_outline,
                                  size: 16,
                                ),
                                label: const Text('Add Time'),
                                style: TextButton.styleFrom(
                                  foregroundColor: Color(0xFF2563EB),
                                  backgroundColor: Colors.blue.shade50,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount:
                                (formData['customTimes'] as List<TimeOfDay>)
                                    .length,
                            itemBuilder: (context, index) {
                              final time =
                                  (formData['customTimes']
                                      as List<TimeOfDay>)[index];
                              return Container(
                                margin: const EdgeInsets.only(bottom: 8),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 32,
                                      height: 32,
                                      decoration: BoxDecoration(
                                        color: Colors.blue.shade100,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.access_time,
                                        size: 16,
                                        color: Color(0xFF2563EB),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    TextButton(
                                      onPressed:
                                          () => _selectTime(context, index),
                                      child: Text(
                                        time.format(context),
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    ),
                                    const Spacer(),
                                    if ((formData['customTimes']
                                                as List<TimeOfDay>)
                                            .length >
                                        1)
                                      IconButton(
                                        icon: const Icon(
                                          Icons.close,
                                          size: 16,
                                          color: Colors.red,
                                        ),
                                        onPressed:
                                            () => handleRemoveTime(index),
                                      ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],

                        // const SizedBox(height: 16),

                        // Repeat dropdown
                        // Column(
                        //   crossAxisAlignment: CrossAxisAlignment.start,
                        //   children: [
                        //     const Text(
                        //       'Repeat',
                        //       style: TextStyle(
                        //         fontSize: 14,
                        //         fontWeight: FontWeight.w500,
                        //         color: Colors.grey,
                        //       ),
                        //     ),
                        //     const SizedBox(height: 4),
                        //     Container(
                        //       decoration: BoxDecoration(
                        //         color: Colors.grey.shade100,
                        //         borderRadius: BorderRadius.circular(15),
                        //       ),
                        //       padding: const EdgeInsets.symmetric(
                        //         horizontal: 12,
                        //       ),
                        //       child: DropdownButtonHideUnderline(
                        //         child: DropdownButton<String>(
                        //           isExpanded: true,
                        //           value: formData['repeat'] as String,
                        //           items: const [
                        //             DropdownMenuItem(
                        //               value: 'daily',
                        //               child: Text('Every day'),
                        //             ),
                        //             DropdownMenuItem(
                        //               value: 'weekdays',
                        //               child: Text('Weekdays only'),
                        //             ),
                        //             DropdownMenuItem(
                        //               value: 'weekends',
                        //               child: Text('Weekends only'),
                        //             ),
                        //             DropdownMenuItem(
                        //               value: 'custom',
                        //               child: Text('Custom days'),
                        //             ),
                        //           ],
                        //           onChanged: (value) {
                        //             handleInputChange('repeat', value);
                        //           },
                        //         ),
                        //       ),
                        //     ),
                        //   ],
                        // ),
                      ],
                    ),
                  ),
                ),

                // const SizedBox(height: 16),

                // Notification Settings
                // Card(
                //   shape: RoundedRectangleBorder(
                //     borderRadius: BorderRadius.circular(20),
                //   ),
                //   elevation: 2,
                //   child: Padding(
                //     padding: const EdgeInsets.all(16),
                //     child: Column(
                //       crossAxisAlignment: CrossAxisAlignment.start,
                //       children: [
                //         Row(
                //           children: [
                //             Container(
                //               width: 40,
                //               height: 40,
                //               decoration: BoxDecoration(
                //                 color: Colors.orange.shade50,
                //                 borderRadius: BorderRadius.circular(20),
                //               ),
                //               child: const Icon(
                //                 Icons.notifications_none,
                //                 color: Colors.orange,
                //                 size: 20,
                //               ),
                //             ),
                //             const SizedBox(width: 12),
                //             const Text(
                //               'Notifications',
                //               style: TextStyle(
                //                 fontSize: 18,
                //                 fontWeight: FontWeight.w600,
                //               ),
                //             ),
                //           ],
                //         ),
                //         const SizedBox(height: 16),

                //         // Reminder Notifications
                //         Container(
                //           padding: const EdgeInsets.all(12),
                //           decoration: BoxDecoration(
                //             color: Colors.grey.shade100,
                //             borderRadius: BorderRadius.circular(15),
                //           ),
                //           child: Row(
                //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //             children: [
                //               Column(
                //                 crossAxisAlignment: CrossAxisAlignment.start,
                //                 children: const [
                //                   Text(
                //                     'Reminder notifications',
                //                     style: TextStyle(
                //                       fontWeight: FontWeight.w500,
                //                     ),
                //                   ),
                //                   Text(
                //                     'Receive alerts before medicine time',
                //                     style: TextStyle(
                //                       fontSize: 12,
                //                       color: Colors.grey,
                //                     ),
                //                   ),
                //                 ],
                //               ),
                //               Switch(
                //                 value: reminderNotifications,
                //                 onChanged: (value) {
                //                   setState(() {
                //                     reminderNotifications = value;
                //                   });
                //                 },
                //                 activeColor: Colors.blue,
                //               ),
                //             ],
                //           ),
                //         ),

                //         const SizedBox(height: 8),

                //         // Missed Dose Alerts
                //         Container(
                //           padding: const EdgeInsets.all(12),
                //           decoration: BoxDecoration(
                //             color: Colors.grey.shade100,
                //             borderRadius: BorderRadius.circular(15),
                //           ),
                //           child: Row(
                //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //             children: [
                //               Column(
                //                 crossAxisAlignment: CrossAxisAlignment.start,
                //                 children: const [
                //                   Text(
                //                     'Missed dose alerts',
                //                     style: TextStyle(
                //                       fontWeight: FontWeight.w500,
                //                     ),
                //                   ),
                //                   Text(
                //                     'Get notified if you miss a dose',
                //                     style: TextStyle(
                //                       fontSize: 12,
                //                       color: Colors.grey,
                //                     ),
                //                   ),
                //                 ],
                //               ),
                //               Switch(
                //                 value: missedDoseAlerts,
                //                 onChanged: (value) {
                //                   setState(() {
                //                     missedDoseAlerts = value;
                //                   });
                //                 },
                //                 activeColor: Colors.blue,
                //               ),
                //             ],
                //           ),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ],
      ),
      // Bottom Action Button
      bottomNavigationBar: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: () {
            // Implement save functionality
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Reminder saved successfully!'),
                backgroundColor: Colors.green,
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            elevation: 5,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.check_circle_outline),
              SizedBox(width: 8),
              Text(
                'Save Reminder',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
