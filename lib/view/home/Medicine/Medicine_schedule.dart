import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:healthmvp/Utils/colors.dart';
import 'package:healthmvp/Utils/textstyles.dart';
import 'package:healthmvp/ViewModel/reminder_authviewmodel.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class MedicineSchedulePage extends StatefulWidget {
  @override
  State<MedicineSchedulePage> createState() => _MedicineSchedulePageState();
}

class _MedicineSchedulePageState extends State<MedicineSchedulePage> {
  ReminderAuthviewmodel? reminderauthmodel;

  @override
  void initState() {
    reminderauthmodel = Provider.of<ReminderAuthviewmodel>(
      context,
      listen: false,
    );
    reminderauthmodel!.getreminderoftheday(context, reminderauthmodel!.date,"pending");
    super.initState();
  }

  @override
  void deactivate() {
    reminderauthmodel?.date = DateFormat('yyyy-MM-dd').format(DateTime.now());
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<ReminderAuthviewmodel>(context);
    return Scaffold(
      backgroundColor: k7dddf2,
      body:
          controller.remindermodell == null
              ? Center(child: CircularProgressIndicator())
              : Column(
                children: [
                  // Top image area (no curve here)
                  Container(
                    height: 300,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('images/bg_medicine.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20.0,
                        vertical: 40.0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Hello', style: u_15_500_k000000),
                                  Text('Manas', style: u_20_500_k000000),
                                ],
                              ),
                              GestureDetector(
                                onTap: () async {
                                  final picked =
                                      await showCalendarDatePicker2Dialog(
                                        context: context,
                                        config:
                                            CalendarDatePicker2WithActionButtonsConfig(
                                              firstDate: DateTime(2000),
                                              lastDate: DateTime.now(),
                                              calendarType:
                                                  CalendarDatePicker2Type.range,
                                            ),
                                        dialogSize: const Size(325, 400),
                                        value: [DateTime.now()],
                                        borderRadius: BorderRadius.circular(15),
                                        builder: (context, child) {
                                          return Theme(
                                            data: ThemeData().copyWith(
                                              primaryColor: const Color(
                                                0xff2B338C,
                                              ),
                                              buttonTheme:
                                                  const ButtonThemeData(
                                                    textTheme:
                                                        ButtonTextTheme.primary,
                                                  ),
                                              colorScheme:
                                                  const ColorScheme.light(
                                                    primary: Color(0xff2B338C),
                                                  ).copyWith(
                                                    secondary: const Color(
                                                      0xff2B338C,
                                                    ),
                                                  ),
                                            ),
                                            child:
                                                child ??
                                                const SizedBox.shrink(),
                                          );
                                        },
                                      );

                                  if (picked != null && picked.isNotEmpty) {
                                    final last = picked.last;
                                    if (last != null) {
                                      setState(() {
                                        controller.date = DateFormat(
                                          'yyyy-MM-dd',
                                        ).format(last);
                                      });
                                    }
                                    controller.getreminderoftheday(
                                      context,
                                      controller.date,
                                      "pending"
                                    );
                                  }
                                },
                                child: Icon(
                                  Icons.calendar_month_outlined,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          Spacer(),
                          Text(
                            'CREATE\nNEW SCHEDULE',
                            style: u_17_bold_k000000,
                          ),
                          SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () {},
                            child: Text('Start', style: u_15_500_k000000),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Bottom white container with curves
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                          right: 16,
                          left: 16,
                          bottom: 16,
                        ),
                        child:
                            controller.isreminderloading == true
                                ? Center(child: CircularProgressIndicator())
                                : controller.remindermodell?.data.isEmpty ??
                                    true
                                ? Center(child: Text("No reminders found"))
                                : ListView.builder(
                                  itemCount:
                                      controller.remindermodell?.data.length ??
                                      0,
                                  itemBuilder: (context, index) {
                                    var reminder =
                                        controller.remindermodell?.data[index];
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children:
                                          controller.remindermodell!.data.map((
                                            med,
                                          ) {
                                            return Card(
                                              child: ListTile(
                                                leading: Icon(
                                                  Icons.local_pharmacy_sharp,
                                                  size: 30,
                                                  color: Colors.purple,
                                                ),
                                                title: Text(
                                                  med.medicineName ?? "",
                                                  style: u_15_500_k000000,
                                                ),
                                                subtitle: Text(
                                                  med.medicineCategory,
                                                  style: u_14_500_kd1d0d3,
                                                ),
                                                trailing: Text(
                                                  reminder!.time,
                                                  // reminder?.time != null
                                                  //     ? DateFormat(
                                                  //       'hh:mm a',
                                                  //     ).format(
                                                  //       DateTime.parse(
                                                  //         reminder!.time,
                                                  //       ).toLocal(),
                                                  //     )
                                                  //     : "",
                                                  style: u_12_500_kd1d0d3,
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                    );
                                  },
                                ),
                      ),
                    ),
                  ),
                ],
              ),
    );
  }
}

class MedicineCard extends StatelessWidget {
  final Map<String, dynamic> med;

  MedicineCard(this.med);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: kffffff,
      elevation: 0, // Remove the shadow/border effect
      margin: EdgeInsets.zero, // Remove any margin
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          0,
        ), // Remove any corner rounding if you want sharp edges
      ),
      child: ListTile(
        leading: Icon(med['icon'], size: 30, color: Colors.purple),
        title: Text(med['name'], style: u_15_500_k000000),
        subtitle: Text(med['dose'], style: u_14_500_kd1d0d3),
        trailing: Text(med['time'], style: u_12_500_kd1d0d3),
      ),
    );
  }
}
