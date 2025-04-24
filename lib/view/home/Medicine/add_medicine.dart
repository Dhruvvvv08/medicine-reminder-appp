import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:healthmvp/Utils/colors.dart';
import 'package:healthmvp/Utils/textstyles.dart';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:healthmvp/ViewModel/addmedicine_authmodel.dart';
import 'package:healthmvp/services/notification_service.dart';
import 'package:healthmvp/widgets/customdropdown.dart';
import 'package:healthmvp/widgets/textformfield.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AddMedicine extends StatefulWidget {
  const AddMedicine({super.key});

  @override
  State<AddMedicine> createState() => _AddMedicineState();
}

class _AddMedicineState extends State<AddMedicine> {
  var _formkey = GlobalKey<FormState>();

  AddmedicineAuthmodel? addmedicineauthmodel;
  @override
  void initState() {
    addmedicineauthmodel = Provider.of<AddmedicineAuthmodel>(
      context,
      listen: false,
    );
    _notificationService.initialize();
    super.initState();
  }
  // final List<String> items = ['Paracetamol', 'Ibuprofen', 'Aspirin'];
  // final List<String> selectedItems = [];
  // final TextEditingController _addItemController = TextEditingController();

  // void _addNewItem(String newItem) {
  //   if (newItem.isNotEmpty && !items.contains(newItem)) {
  //     setState(() {
  //       items.add(newItem);
  //       selectedItems.add(newItem);
  //       _addItemController.clear();
  //     });
  //   }
  // }
  final NotificationService _notificationService = NotificationService();
  final dropDownKey = GlobalKey<DropdownSearchState>();
  //final TextEditingController _controller = TextEditingController();
  int selectedIndex = 0; // default selected day index

  // List<TimeOfDay?> selectedTimes = [];
  // List<String> isoTimes = [];
  DateTime convertToDateTime(TimeOfDay time) {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day, time.hour, time.minute);
  }

  String? val;
  String? whentotake;
  String? type;
  String? amt;

  @override
  void dispose() {
    addmedicineauthmodel!.dosecontroller.clear();
    addmedicineauthmodel!.medicinenamecontroller.clear();
    addmedicineauthmodel!.notecontroller.clear();
    addmedicineauthmodel!.type = null;
    addmedicineauthmodel!.startdate = null;
    addmedicineauthmodel!.endate = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final medicineprovider = Provider.of<AddmedicineAuthmodel>(context);
    return Form(
      key: _formkey,
      child: Scaffold(
        backgroundColor: Colors.white,
        body:
            medicineprovider.submitaddmedicinebool == true
                ? Center(child: CircularProgressIndicator())
                : Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16, top: 30),
                  child: ListView(
                    //  crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Container(
                          //   decoration: BoxDecoration(
                          //     color: Color(0xfff0f9fc),
                          //     borderRadius: BorderRadius.circular(20),
                          //   ),
                          //   child: IconButton(
                          //     icon: const Icon(Icons.arrow_back),
                          //     color: Color(0xff000000),
                          //     onPressed: () {
                          //       context.go('/bottomnavbar');
                          //     },
                          //   ),
                          // ),
                          Text("Add Medicine", style: u_20_500_k000000),
                        ],
                      ),
                      SizedBox(height: 30),
                      TitledInputField(
                        title: "Medicine Name",
                        hintText: "Enter Medicine Name",
                        backgroundColor: kf0f9ff,
                        textEditingController:
                            medicineprovider.medicinenamecontroller,
                        validators: (value) {
                          if (value == null || value.isEmpty) {
                            return "This field is required";
                          }
                          return null;
                        },
                      ),

                      SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: TitledInputField(
                              title: "Dose",
                              hintText: "Enter Dose",
                              backgroundColor: kf0f9ff,
                              textEditingController:
                                  medicineprovider.dosecontroller,
                              validators: (value) {
                                if (value == null || value.isEmpty) {
                                  return "This field is required";
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(width: 20),
                          Expanded(
                            child: CustomDropdown(
                              title: Text(
                                "Type",
                                style: const TextStyle(
                                  color: Color(0xff000000),
                                  fontSize: 16,
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              data: [
                                'Tablet',
                                'Syrup ',
                                'Injection',
                                'Cream',
                                'Drops',
                                'Inhalers',
                                'Suppositories',
                              ],

                              onChanged: (String? newValue) {
                                medicineprovider.type = newValue;
                              },
                              hintText: "Select Type ",
                              selectedValue: medicineprovider.type,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 12),

                      //  SizedBox(height: 20),
                      Text(
                        "Select Date Range",
                        style: const TextStyle(
                          color: Color(0xff000000),
                          fontSize: 16,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () async {
                                final picked = await showCalendarDatePicker2Dialog(
                                  context: context,
                                  config: CalendarDatePicker2WithActionButtonsConfig(
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime(2030),
                                    // calendarType: CalendarDatePicker2Type.range,
                                  ),
                                  dialogSize: const Size(325, 400),
                                  value: [DateTime.now()],
                                  borderRadius: BorderRadius.circular(15),
                                  builder: (context, child) {
                                    return Theme(
                                      data: ThemeData().copyWith(
                                        primaryColor: const Color(0xff2B338C),
                                        buttonTheme: const ButtonThemeData(
                                          textTheme: ButtonTextTheme.primary,
                                        ),
                                        colorScheme: const ColorScheme.light(
                                          primary: Color(0xff2B338C),
                                        ).copyWith(
                                          secondary: const Color(0xff2B338C),
                                        ),
                                      ),
                                      child: child ?? const SizedBox.shrink(),
                                    );
                                  },
                                );

                                if (picked != null && picked.isNotEmpty) {
                                  final first = picked.first;
                                  // final last =
                                  //     picked.length > 1 ? picked.last : picked.first;

                                  if (first != null
                                  // &&
                                  // last != null
                                  ) {
                                    setState(() {
                                      medicineprovider.startdate = DateFormat(
                                        'yyyy-MM-dd',
                                      ).format(first);
                                      print(medicineprovider.startdate);
                                      // endate = DateFormat('yyyy-MM-dd').format(last);
                                      // Add logic to handle selected range
                                    });
                                  }
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: kf0f9ff,
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                //color: Colors.amber,
                                child: Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Text(
                                    medicineprovider.startdate == null
                                        ? "Select Start Date "
                                        : "${medicineprovider.startdate}",
                                    //  - $endate",
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 20),
                          Expanded(
                            child: GestureDetector(
                              onTap: () async {
                                final picked = await showCalendarDatePicker2Dialog(
                                  context: context,
                                  config: CalendarDatePicker2WithActionButtonsConfig(
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime(2030),
                                    // calendarType: CalendarDatePicker2Type.range,
                                  ),
                                  dialogSize: const Size(325, 400),
                                  value: [DateTime.now()],
                                  borderRadius: BorderRadius.circular(15),
                                  builder: (context, child) {
                                    return Theme(
                                      data: ThemeData().copyWith(
                                        primaryColor: const Color(0xff2B338C),
                                        buttonTheme: const ButtonThemeData(
                                          textTheme: ButtonTextTheme.primary,
                                        ),
                                        colorScheme: const ColorScheme.light(
                                          primary: Color(0xff2B338C),
                                        ).copyWith(
                                          secondary: const Color(0xff2B338C),
                                        ),
                                      ),
                                      child: child ?? const SizedBox.shrink(),
                                    );
                                  },
                                );

                                if (picked != null && picked.isNotEmpty) {
                                  // final first = picked.first;
                                  final last = picked.last;
                                  //> 1 ? picked.last : picked.first;

                                  if (last != null
                                  // &&
                                  // last != null
                                  ) {
                                    setState(() {
                                      //startdate = DateFormat('yyyy-MM-dd').format(last);
                                      medicineprovider.endate = DateFormat(
                                        'yyyy-MM-dd',
                                      ).format(last);
                                      // Add logic to handle selected range
                                    });
                                  }
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: kf0f9ff,
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                //color: Colors.amber,
                                child: Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Text(
                                    medicineprovider.endate == null
                                        ? "Select End  Date"
                                        : "${medicineprovider.endate}",
                                    //  - $endate",
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 12),
                      TitledInputField(
                        title: "Note",
                        hintText: "Enter Medicine Note",
                        backgroundColor: kf0f9ff,
                        textEditingController: medicineprovider.notecontroller,
                        validators: (value) {
                          if (value == null || value.isEmpty) {
                            return "This field is required";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 12),
                      CustomDropdown(
                        title: Row(
                          children: [
                            Text(
                              "Frequency",
                              style: const TextStyle(
                                color: Color(0xff000000),
                                fontSize: 16,
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                        data: ["1", "2", "3", "4", "5"],

                        onChanged: (String? newValue) {
                          setState(() {
                            medicineprovider.frequencyy = newValue;
                            int freq = int.tryParse(newValue!) ?? 0;
                            medicineprovider
                                .selectedTimes = List<TimeOfDay?>.filled(
                              freq,
                              null,
                              growable: false,
                            );
                            print(medicineprovider.selectedTimes);
                          });
                        },
                        hintText: " Frequency",
                        selectedValue: medicineprovider.frequencyy,
                      ),
                      SizedBox(height: 12),
                      if (medicineprovider.frequencyy != null)
                        Column(
                          children: List.generate(
                            int.parse(medicineprovider.frequencyy!),
                            (index) => Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: GestureDetector(
                                onTap: () async {
                                  TimeOfDay? picked = await showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.now(),
                                  );
                                  if (picked != null) {
                                    setState(() {
                                      medicineprovider.selectedTimes[index] =
                                          picked;
                                      medicineprovider.isoTimes =
                                          medicineprovider.selectedTimes
                                              .where((time) => time != null)
                                              .map(
                                                (time) =>
                                                    convertToDateTime(
                                                      time!,
                                                    ).toUtc().toIso8601String(),
                                              )
                                              .toList();

                                      print(medicineprovider.isoTimes);
                                    });
                                    print(
                                      medicineprovider.selectedTimes
                                          .map((time) => time?.format(context))
                                          .toList(),
                                    );
                                  }
                                },
                                child: Column(
                                  children: [
                                    Container(
                                      color: kf0f9ff,
                                      width: double.infinity,
                                      height: 60,
                                      child: Center(
                                        child: Text(
                                          medicineprovider
                                                          .selectedTimes
                                                          .length >
                                                      index &&
                                                  medicineprovider
                                                          .selectedTimes[index] !=
                                                      null
                                              ? medicineprovider
                                                  .selectedTimes[index]!
                                                  .format(context)
                                              : 'Select Timing',
                                          style: TextStyle(
                                            color: Color(0xff000000),
                                            fontSize: 16,
                                            fontFamily: "Poppins",
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),

                      SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        height: 55,
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
                            backgroundColor: Color(0xFF5B4DF2), // Purple color
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                30,
                              ), // Fully rounded
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            'Make Schedule',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
      ),
    );
  }
}
