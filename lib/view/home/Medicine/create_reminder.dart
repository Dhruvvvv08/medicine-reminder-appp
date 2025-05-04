import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:healthmvp/Utils/colors.dart';
import 'package:healthmvp/ViewModel/addmedicine_authmodel.dart';
import 'package:healthmvp/ViewModel/show_medicine_authmodel.dart';
import 'package:healthmvp/services/notification_service.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ModernReminderScreen extends StatefulWidget {
  const ModernReminderScreen({Key? key}) : super(key: key);

  @override
  State<ModernReminderScreen> createState() => _ModernReminderScreenState();
}

class _ModernReminderScreenState extends State<ModernReminderScreen> {
  // Form data
  // final formData = {
  //   'medicine_name': "",
  //   'medicine_dosage': "1",
  //   'medicine_instructions': "",
  //   'medicine_category': "tablet",
  //   'scheduleStart': DateTime.now(),
  //   'scheduleEnd': DateTime.now().add(const Duration(days: 4)),
  //   'frequency': "custom",
  //   'customTimes': <TimeOfDay>[
  //     const TimeOfDay(hour: 8, minute: 0),
  //     const TimeOfDay(hour: 18, minute: 30),
  //   ],
  //   'repeat': "daily",
  // };

  String searchTerm = "";
  bool showDropdown = false;
  List<Map<String, String>> filteredMedicines = [];
  bool reminderNotifications = true;
  bool missedDoseAlerts = true;

  // Helper function to validate medicine category
  String validateMedicineCategory(String? inputCategory) {
    const validCategories = [
      'tablet',
      'capsule',
      'liquid',
      'injection',
      'syrup',
    ];
    final category = inputCategory?.toLowerCase() ?? 'tablet';
    return validCategories.contains(category) ? category : 'tablet';
  }

  var _formkey = GlobalKey<FormState>();
  void handleAddTime() {
    setState(() {
      addmedicineauthmodel?.selectedTimes.add(TimeOfDay.now());
      addmedicineauthmodel?.notifyListeners();
    });
  }

  void handleRemoveTime(int index) {
    setState(() {
      addmedicineauthmodel?.selectedTimes.removeAt(index);
      addmedicineauthmodel?.notifyListeners();
    });
  }

  DateTime convertToDateTime(TimeOfDay time) {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day, time.hour, time.minute);
  }

  Future<void> _selectTime(BuildContext context, int index) async {
    final currentTimes = addmedicineauthmodel?.selectedTimes ?? [];
    if (index >= currentTimes.length) return;

    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: currentTimes[index],
    );

    if (picked != null && addmedicineauthmodel != null) {
      setState(() {
        addmedicineauthmodel!.selectedTimes[index] = picked;
        addmedicineauthmodel!.notifyListeners();
        addmedicineauthmodel?.selectedTimes[index] = picked;
        addmedicineauthmodel?.isoTimes =
            addmedicineauthmodel!.selectedTimes
                .map((time) => convertToDateTime(time!).toIso8601String())
                .toList();
      });
    }
  }

  // void handleAddTime() {
  //   setState(() {
  //     addmedicineauthmodel?.selectedTimes.add(const TimeOfDay(hour: 12, minute: 0));
  //     addmedicineauthmodel?.notifyListeners();
  //   });
  // }

  // void handleRemoveTime(int index) {
  //   setState(() {
  //     addmedicineauthmodel?.selectedTimes.removeAt(index);
  //     addmedicineauthmodel?.notifyListeners();
  //   });
  // }

  // Future<void> _selectTime(BuildContext context, int index) async {
  //   final currentTimes = addmedicineauthmodel?.selectedTimes ?? [];
  //   if (index >= currentTimes.length) return;

  //   final TimeOfDay? picked = await showTimePicker(
  //     context: context,
  //     initialTime: currentTimes[index],
  //   );

  //   if (picked != null && addmedicineauthmodel != null) {
  //     setState(() {
  //       addmedicineauthmodel!.selectedTimes[index] = picked;
  //       addmedicineauthmodel!.notifyListeners();
  //     });
  //   }
  // }
  void handleMedicineSelect(
    Map<String, String> medicine,
    TextEditingController? txt,
  ) {
    setState(() {
      // Update the medicine name in the controller and model
      addmedicineauthmodel?.medicinenamecontroller.text = medicine['name']!;
      txt?.text = medicine['name']!;

      // Update the medicine category in the model
      addmedicineauthmodel?.type = validateMedicineCategory(
        medicine['category'],
      );

      // Update search term and hide dropdown
      searchTerm = medicine['name'] ?? "";
      showDropdown = false;

      // Notify listeners if using ChangeNotifier
      addmedicineauthmodel?.notifyListeners();
    });
  }

  // void handleAddTime() {
  //   setState(() {
  //     List<TimeOfDay> times = List<TimeOfDay>.from(
  //       formData['customTimes'] as List<TimeOfDay>,
  //     );
  //     times.add(const TimeOfDay(hour: 12, minute: 0));
  //     formData['customTimes'] = times;
  //   });
  // }

  // void handleRemoveTime(int index) {
  //   setState(() {
  //     List<TimeOfDay> times = List<TimeOfDay>.from(
  //       formData['customTimes'] as List<TimeOfDay>,
  //     );
  //     times.removeAt(index);
  //     formData['customTimes'] = times;
  //   });
  // }

  void filterMedicines(String term) {
    setState(() {
      searchTerm = term;
      // Update the medicine name in the controller directly
      addmedicineauthmodel?.medicinenamecontroller.text = term;

      final medicineProvider = Provider.of<ShowMedicineAuthmodel>(
        context,
        listen: false,
      );

      if (medicineProvider.getusermedicines != null) {
        filteredMedicines =
            medicineProvider.getusermedicines!.data
                .where(
                  (med) =>
                      term.isEmpty ||
                      (med.name?.toLowerCase().contains(term.toLowerCase()) ??
                          false),
                )
                .map(
                  (med) => {
                    'name': med.name ?? '',
                    'category': validateMedicineCategory(med.category),
                  },
                )
                .toList();
      }

      showDropdown = term.isNotEmpty;
    });
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final initialDate =
        addmedicineauthmodel?.startdate != null
            ? DateFormat('yyyy-MM-dd').parse(addmedicineauthmodel!.startdate!)
            : DateTime.now();

    final picked = await showCalendarDatePicker2Dialog(
      context: context,
      config: CalendarDatePicker2WithActionButtonsConfig(
        firstDate: DateTime.now(),
        lastDate: DateTime(2030),
      ),
      dialogSize: const Size(325, 400),
      value: [initialDate],
      borderRadius: BorderRadius.circular(15),
    );

    if (picked != null && picked.isNotEmpty && picked.first != null) {
      setState(() {
        addmedicineauthmodel!.startdate = DateFormat(
          'yyyy-MM-dd',
        ).format(picked.first!);
        addmedicineauthmodel!.notifyListeners();
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final initialDate =
        addmedicineauthmodel?.endate != null
            ? DateFormat('yyyy-MM-dd').parse(addmedicineauthmodel!.endate!)
            : DateTime.now();

    final picked = await showCalendarDatePicker2Dialog(
      context: context,
      config: CalendarDatePicker2WithActionButtonsConfig(
        firstDate: DateTime.now(),
        lastDate: DateTime(2030),
      ),
      dialogSize: const Size(325, 400),
      value: [initialDate],
      borderRadius: BorderRadius.circular(15),
    );

    if (picked != null && picked.isNotEmpty && picked.first != null) {
      setState(() {
        addmedicineauthmodel!.endate = DateFormat(
          'yyyy-MM-dd',
        ).format(picked.first!);
        addmedicineauthmodel!.notifyListeners();
      });
    }
  }
  // Future<void> _selectTime(BuildContext context, int index) async {
  //   List<TimeOfDay> times = List<TimeOfDay>.from(
  //     formData['customTimes'] as List<TimeOfDay>,
  //   );
  //   final TimeOfDay? picked = await showTimePicker(
  //     context: context,
  //     initialTime: times[index],
  //   );
  //   if (picked != null && picked != times[index]) {
  //     setState(() {
  //       times[index] = picked;
  //       formData['customTimes'] = times;
  //     });
  //   }
  // }

  // Future<void> _selectDate(BuildContext context, String field) async {
  //   final DateTime? picked = await showDatePicker(
  //     context: context,
  //     initialDate: formData[field] as DateTime,
  //     firstDate: DateTime(2020),
  //     lastDate: DateTime(2030),
  //   );

  //   if (picked != null && picked != formData[field]) {
  //     setState(() {
  //       formData[field] = picked;
  //     });
  //   }
  // }

  AddmedicineAuthmodel? addmedicineauthmodel;
  ShowMedicineAuthmodel? showmedicinemodell;
  final NotificationService _notificationService = NotificationService();

  @override
  void initState() {
    super.initState();
    addmedicineauthmodel = Provider.of<AddmedicineAuthmodel>(
      context,
      listen: false,
    );
    _notificationService.initialize();

    showmedicinemodell = Provider.of<ShowMedicineAuthmodel>(
      context,
      listen: false,
    );
    showmedicinemodell?.getallmedicineusers(context).then((_) {
      if (showmedicinemodell?.getusermedicines != null) {
        setState(() {
          filteredMedicines =
              showmedicinemodell!.getusermedicines!.data
                  .map(
                    (med) => {
                      'name': med.name ?? '',
                      'category': validateMedicineCategory(med.category),
                    },
                  )
                  .toList();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final medicineprovider = Provider.of<AddmedicineAuthmodel>(context);
    final medicineproviderr = Provider.of<ShowMedicineAuthmodel>(context);

    return Form(
      key: _formkey,
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.only(bottom: 60),
          child: Column(
            children: [
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
                child: Padding(
                  padding: const EdgeInsets.only(top: 40),
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
              ),

              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
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
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                            vertical: 12,
                                            horizontal: 12,
                                          ),
                                    ),
                                    onChanged: filterMedicines,
                                  ),
                                ),

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
                                    constraints: BoxConstraints(
                                      maxHeight:
                                          MediaQuery.of(context).size.height *
                                          0.4, // 40% of screen height
                                    ),
                                    child:
                                        medicineproviderr.showmedicines
                                            ? Text("No medicine Available")
                                            : filteredMedicines.isEmpty
                                            ? const Padding(
                                              padding: EdgeInsets.all(16.0),
                                              child: Text('No medicines found'),
                                            )
                                            : Scrollbar(
                                              child: ListView.builder(
                                                shrinkWrap: true,
                                                physics:
                                                    const AlwaysScrollableScrollPhysics(), // This enables scrolling
                                                itemCount:
                                                    filteredMedicines.length,
                                                itemBuilder: (context, index) {
                                                  final medicine =
                                                      filteredMedicines[index];
                                                  return ListTile(
                                                    leading: Container(
                                                      width: 24,
                                                      height: 24,
                                                      decoration: BoxDecoration(
                                                        color:
                                                            Colors
                                                                .blue
                                                                .shade100,
                                                        shape: BoxShape.circle,
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          medicine['name']![0],
                                                          style:
                                                              const TextStyle(
                                                                fontSize: 12,
                                                                color:
                                                                    Colors.blue,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                        ),
                                                      ),
                                                    ),
                                                    title: Text(
                                                      medicine['name']!,
                                                    ),
                                                    subtitle: Text(
                                                      medicine['category']!,
                                                      style: const TextStyle(
                                                        fontSize: 12,
                                                      ),
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
                                  ),
                              ],
                            ),

                            const SizedBox(height: 16),

                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                          borderRadius: BorderRadius.circular(
                                            15,
                                          ),
                                        ),
                                        child: TextFormField(
                                          decoration: const InputDecoration(
                                            border: InputBorder.none,
                                            hintText: "Enter Dosage",
                                            hintStyle: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                            ),
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                  vertical: 12,
                                                  horizontal: 12,
                                                ),
                                          ),
                                          keyboardType: TextInputType.number,
                                          controller:
                                              medicineprovider.dosecontroller,
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return "This field is required";
                                            }
                                            return null;
                                          },
                                          // initialValue:
                                          //     formData['medicine_dosage'] as String,
                                          // onChanged:
                                          //     (value) => handleInputChange(
                                          //       'medicine_dosage',
                                          //       value,
                                          //     ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                          borderRadius: BorderRadius.circular(
                                            15,
                                          ),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                        ),
                                        child: DropdownButtonHideUnderline(
                                          child: DropdownButton<String>(
                                            isExpanded: true,
                                            value: medicineprovider.type,
                                            hint: Text("Please select"),
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
                                              DropdownMenuItem(
                                                value: 'syrup',
                                                child: Text('Syrup'),
                                              ),
                                            ],
                                            onChanged: (String? newValue) {
                                              medicineprovider.type = newValue;
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
                                    controller: medicineprovider.notecontroller,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "This field is required";
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),
                    Card(
                      color: Colors.white,
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                          right: 16,
                          left: 16,
                          top: 16,
                          bottom: 16,
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                        onTap: () => _selectStartDate(context),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 12,
                                            horizontal: 12,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade100,
                                            borderRadius: BorderRadius.circular(
                                              15,
                                            ),
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
                                                medicineprovider.startdate ==
                                                        null
                                                    ? "Select Start Date"
                                                    : medicineprovider
                                                        .startdate!,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                        onTap: () => _selectEndDate(context),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 12,
                                            horizontal: 12,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade100,
                                            borderRadius: BorderRadius.circular(
                                              15,
                                            ),
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
                                                medicineprovider.endate == null
                                                    ? "Select End Date"
                                                    : medicineprovider.endate!,
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
                            SizedBox(height: 20),
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
                                    color: Colors.grey,
                                  ),
                                  label: const Text('Add Time'),
                                  style: TextButton.styleFrom(
                                    foregroundColor: const Color(0xFF2563EB),
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

                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount:
                                  addmedicineauthmodel?.selectedTimes.length ??
                                  0,
                              itemBuilder: (context, index) {
                                final time =
                                    addmedicineauthmodel?.selectedTimes[index];
                                if (time == null)
                                  return const SizedBox.shrink();

                                return Container(
                                  margin: const EdgeInsets.only(bottom: 8),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
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
                                      if ((addmedicineauthmodel
                                                  ?.selectedTimes
                                                  .length ??
                                              0) >
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
                        ),
                      ),
                    ),

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formkey.currentState!.validate()) {
                            if (medicineprovider.startdate == null ||
                                medicineprovider.endate == null ||
                                medicineprovider.selectedTimes.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    "Please Select the Date and Time",
                                  ),
                                  duration: Duration(seconds: 3),
                                ),
                              );
                            } else if (medicineprovider.startdate != null &&
                                medicineprovider.endate != null &&
                                medicineprovider.selectedTimes.isNotEmpty) {
                              // final socketService = Provider.of<SocketService>(
                              //   context,
                              //   listen: false,
                              // );
                              // if (socketService.isConnected()) {
                              //   ScaffoldMessenger.of(context).showSnackBar(
                              //     SnackBar(
                              //       content: Text(
                              //         'Socket is connected! Sending test event...',
                              //       ),
                              //     ),
                              //   );
                              //   socketService.sendTestEvent();
                              // } else {
                              //   ScaffoldMessenger.of(context).showSnackBar(
                              //     SnackBar(
                              //       content: Text('Socket is not connected!'),
                              //     ),
                              //   );
                              // }
                              medicineprovider.submitaddmedicine(context, {
                                "medicine_name":
                                    medicineprovider
                                        .medicinenamecontroller
                                        .text,
                                "medicine_dosage":
                                    medicineprovider.dosecontroller.text,
                                "medicine_instructions":
                                    medicineprovider.notecontroller.text,
                                "medicine_category": medicineprovider.type,
                                "scheduleStart": medicineprovider.startdate,
                                "scheduleEnd": medicineprovider.endate,
                                "frequency": "custom",
                                "customTimes": medicineprovider.isoTimes,
                              });
                            }
                          }
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
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
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
        ),
      ),
    );
  }
}
