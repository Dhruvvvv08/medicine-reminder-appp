import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:healthmvp/Utils/colors.dart';
import 'package:healthmvp/Utils/textstyles.dart';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:healthmvp/ViewModel/addmedicine_authmodel.dart';
import 'package:healthmvp/widgets/customdropdown.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AddMedicine extends StatefulWidget {
  const AddMedicine({super.key});

  @override
  State<AddMedicine> createState() => _AddMedicineState();
}

class _AddMedicineState extends State<AddMedicine> {
  AddmedicineAuthmodel? addmedicineauthmodel;
  @override
  void initState() {
    addmedicineauthmodel = Provider.of<AddmedicineAuthmodel>(
      context,
      listen: false,
    );
    addmedicineauthmodel?.getallmedicine(context);
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

  final dropDownKey = GlobalKey<DropdownSearchState>();
  //final TextEditingController _controller = TextEditingController();
  String? val;
  String? whentotake;
  String? type;
  String? amt;
  String? frequencyy;
  String? startdate;
  String? endate;
  @override
  Widget build(BuildContext context) {
    final medicineprovider = Provider.of<AddmedicineAuthmodel>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 30),
          child: SingleChildScrollView(
            child: Column(
              children: [
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
                          context.go('/bottomnavbar');
                        },
                      ),
                    ),
                    SizedBox(width: 60),
                    Text("Add Medicine", style: u_20_500_k000000),
                  ],
                ),
                SizedBox(height: 30),
                CustomDropdown(
                  title: Row(
                    children: [
                      Text(
                        "Medicine Name",
                        style: const TextStyle(
                          color: Color(0xff000000),
                          fontSize: 16,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                  data:
                      medicineprovider.medicinemodel?.data
                          .map((d) => d.name)
                          .toSet()
                          .toList() ??
                      [],

                  onChanged: (String? newValue) {
                    val = newValue;
                  },
                  hintText: "Enter Medicine Name   ",
                  selectedValue: val,
                ),
                // DropdownButtonHideUnderline(
                //   child: DropdownButton2<String>(
                //     isExpanded: true,
                //     hint: Text(
                //       'Select or add items',
                //       style: TextStyle(
                //         fontSize: 14,
                //         color: Theme.of(context).hintColor,
                //       ),
                //     ),
                //     items: [
                // Input field inside the dropdown menu
                //       DropdownMenuItem<String>(
                //         enabled: false,
                //         child: Padding(
                //           padding: const EdgeInsets.symmetric(horizontal: 12.0),
                //           child: Row(
                //             children: [
                //               // Expanded(
                //               //   child: TextField(
                //               //     controller: _addItemController,
                //               //     decoration: const InputDecoration(
                //               //       isDense: true,
                //               //       hintText: 'Add new item...',
                //               //       border: OutlineInputBorder(),
                //               //     ),
                //               //     onSubmitted: (val) => _addNewItem(val.trim()),
                //               //   ),
                //               // ),
                //               const SizedBox(width: 8),
                //               IconButton(
                //                 icon: const Icon(Icons.add),
                //                 onPressed: () =>
                //                     _addNewItem(_addItemController.text.trim()),
                //               ),
                //             ],
                //           ),
                //         ),
                //       ),

                //       // Divider
                //       const DropdownMenuItem<String>(
                //         enabled: false,
                //         child: Divider(thickness: 1),
                //       ),

                //       // List of selectable items
                //       ...items.map((item) {
                //         return DropdownMenuItem<String>(
                //           value: item,
                //           enabled: false,
                //           child: StatefulBuilder(
                //             builder: (context, menuSetState) {
                //               final isSelected = selectedItems.contains(item);

                //               return InkWell(
                //                 onTap: () {
                //                   setState(() {
                //                     isSelected
                //                         ? selectedItems.remove(item)
                //                         : selectedItems.add(item);
                //                   });
                //                   menuSetState(() {});
                //                 },
                //                 child: Container(
                //                   padding: const EdgeInsets.symmetric(horizontal: 8.0),
                //                   height: 40,
                //                   child: Row(
                //                     children: [
                //                       Icon(
                //                         isSelected
                //                             ? Icons.check_box
                //                             : Icons.check_box_outline_blank,
                //                         color: isSelected
                //                             ? Theme.of(context).primaryColor
                //                             : null,
                //                       ),
                //                       const SizedBox(width: 12),
                //                       Expanded(
                //                         child: Text(
                //                           item,
                //                           style: const TextStyle(fontSize: 14),
                //                         ),
                //                       ),
                //                     ],
                //                   ),
                //                 ),
                //               );
                //             },
                //           ),
                //         );
                //       }).toList(),
                //     ],
                //     value: selectedItems.isEmpty ? null : selectedItems.last,
                //     onChanged: (value) {},
                //     selectedItemBuilder: (context) {
                //       return items.map((item) {
                //         return Text(
                //           selectedItems.join(', '),
                //           style: const TextStyle(
                //             fontSize: 14,
                //             overflow: TextOverflow.ellipsis,
                //           ),
                //           maxLines: 1,
                //         );
                //       }).toList();
                //     },
                //     buttonStyleData: const ButtonStyleData(
                //       padding: EdgeInsets.only(left: 16, right: 8),
                //       height: 44,
                //       width: 300, // Adjust size if needed
                //     ),
                //     menuItemStyleData: const MenuItemStyleData(
                //       height: 50,
                //       padding: EdgeInsets.symmetric(vertical: 4),
                //     ),
                //   ),
                // ),
                SizedBox(height: 12),
                CustomDropdown(
                  title: Row(
                    children: [
                      Text(
                        "When to take",
                        style: const TextStyle(
                          color: Color(0xff000000),
                          fontSize: 16,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                  data: ["abcd"],

                  onChanged: (String? newValue) {
                    whentotake = newValue;
                  },
                  hintText: "Select When to take ",
                  selectedValue: whentotake,
                ),
                SizedBox(height: 12),
                CustomDropdown(
                  title: Row(
                    children: [
                      Text(
                        "Type",
                        style: const TextStyle(
                          color: Color(0xff000000),
                          fontSize: 16,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                  data: ["abcd"],

                  onChanged: (String? newValue) {
                    type = newValue;
                  },
                  hintText: "Select Medicine Type ",
                  selectedValue: type,
                ),
                Row(
                  children: [
                    Expanded(
                      child: CustomDropdown(
                        title: Row(
                          children: [
                            Text(
                              "Amount",
                              style: const TextStyle(
                                color: Color(0xff000000),
                                fontSize: 16,
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                        data: ["abcd"],

                        onChanged: (String? newValue) {
                          amt = newValue;
                        },
                        hintText: "Select Amount",
                        selectedValue: amt,
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: CustomDropdown(
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
                        data: ["abcd"],

                        onChanged: (String? newValue) {
                          frequencyy = newValue;
                        },
                        hintText: "Full Name",
                        selectedValue: frequencyy,
                      ),
                    ),
                  ],
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
                              
                              firstDate: DateTime(2000),
                              lastDate: DateTime.now(),
                              calendarType: CalendarDatePicker2Type.range,
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
                                  ).copyWith(secondary: const Color(0xff2B338C)),
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
                                startdate = DateFormat('yyyy-MM-dd').format(first);
                               // endate = DateFormat('yyyy-MM-dd').format(last);
                                // Add logic to handle selected range
                              });
                            }
                          }
                        },
                        child:Container(
                                    
                        decoration: BoxDecoration(
                          color: kf0f9ff,
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(12),
                        ),
                         //color: Colors.amber,
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Text(
                                  startdate == null
                                      ? "Select Date Range"
                                      : "$startdate" ,
                                    //  - $endate",
                                ),
                          ),
                        ) ,
                      
                                     
                      ),
                    ),
                    SizedBox(width: 20),
                     Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          final picked = await showCalendarDatePicker2Dialog(
                            context: context,
                            config: CalendarDatePicker2WithActionButtonsConfig(
                              
                              firstDate: DateTime(2000),
                              lastDate: DateTime.now(),
                              calendarType: CalendarDatePicker2Type.range,
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
                                  ).copyWith(secondary: const Color(0xff2B338C)),
                                ),
                                child: child ?? const SizedBox.shrink(),
                              );
                            },
                          );
                      
                          if (picked != null && picked.isNotEmpty) {
                           // final first = picked.first;
                            final last =
                                picked.last; 
                                //> 1 ? picked.last : picked.first;
                      
                            if (last != null
                            // && 
                          // last != null
                            ) {
                              setState(() {
                                //startdate = DateFormat('yyyy-MM-dd').format(last);
                               endate = DateFormat('yyyy-MM-dd').format(last);
                                // Add logic to handle selected range
                              });
                            }
                          }
                        },
                        child:Container(
                                    
                        decoration: BoxDecoration(
                          color: kf0f9ff,
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(12),
                        ),
                         //color: Colors.amber,
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Text(
                                  endate == null
                                      ? "Select Date Range"
                                      : "$endate" ,
                                    //  - $endate",
                                ),
                          ),
                        ) ,
                      
                                     
                      ),
                    ),
                  ],
                ),

                // Row(
                //   children: [
                //     Expanded(
                //       child: CustomDropdown(
                //         title: Row(
                //           children: [
                //             Text(
                //               "Start",
                //               style: const TextStyle(
                //                 color: Color(0xff000000),
                //                 fontSize: 16,
                //                 fontFamily: "Poppins",
                //                 fontWeight: FontWeight.w800,
                //               ),
                //             ),
                //           ],
                //         ),
                //         data: ["abcd"],

                //         onChanged: (String? newValue) {
                //           startdate = newValue;
                //         },
                //         hintText: "Select Date",
                //         selectedValue: startdate,
                //       ),
                //     ),
                //     SizedBox(width: 12),
                //     Expanded(
                //       child: CustomDropdown(
                //         title: Row(
                //           children: [
                //             Text(
                //               "Finish",
                //               style: const TextStyle(
                //                 color: Color(0xff000000),
                //                 fontSize: 16,
                //                 fontFamily: "Poppins",
                //                 fontWeight: FontWeight.w800,
                //               ),
                //             ),
                //           ],
                //         ),
                //         data: ["abcd"],

                //         onChanged: (String? newValue) {
                //           val = newValue;
                //         },
                //         hintText: "Select Date",
                //         selectedValue: val,
                //       ),
                //     ),
                //   ],
                // ),
                  SizedBox(height: 20),
                SizedBox(
                  height: 40,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: 7,
                    separatorBuilder: (context, index) => SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      final days = [
                        'Sun',
                        'Mon',
                        'Tue',
                        'Wed',
                        'Thu',
                        'Fri',
                        'Sat',
                      ];
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 9),
                        decoration: BoxDecoration(
                          color: Color(0xfff0f9fc), // light blue background
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            days[index],
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () {
                      // Handle button press
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
