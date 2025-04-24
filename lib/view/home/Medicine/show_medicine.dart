import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:healthmvp/Utils/colors.dart';
import 'package:healthmvp/Utils/textstyles.dart';
import 'package:healthmvp/ViewModel/addmedicine_authmodel.dart';
import 'package:healthmvp/ViewModel/show_medicine_authmodel.dart';
import 'package:provider/provider.dart';

class MedicineScreen extends StatefulWidget {
  @override
  State<MedicineScreen> createState() => _MedicineScreenState();
}

class _MedicineScreenState extends State<MedicineScreen> {
  ShowMedicineAuthmodel? showmedicinemodell;
  @override
  void initState() {
    showmedicinemodell = Provider.of<ShowMedicineAuthmodel>(
      context,
      listen: false,
    );
    showmedicinemodell?.getallmedicineusers(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final medicineprovider = Provider.of<ShowMedicineAuthmodel>(context);
    final medicines = medicineprovider.getusermedicines;

    return Scaffold(
      backgroundColor: kffffff,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
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
                  Text("Your Medicine", style: u_20_500_k000000),
                ],
              ),
            ),
            Expanded(
              child:
                  medicines == null
                      ? Center(child: CircularProgressIndicator())
                      : ListView.builder(
                        itemCount: medicines.data.length,
                        itemBuilder: (context, index) {
                          final med = medicines.data[index];
                          return MedicineCard(
                            name: med.name ?? "",
                            doses: med.dosage ?? "",
                            category: med.category ?? "",
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }
}

class MedicineCard extends StatelessWidget {
  final String name;
  final String doses;
  final String category;

  const MedicineCard({
    required this.name,
    required this.doses,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kf0f9ff,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: kd5d7ff,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Image.network(
              'http://192.168.29.249:3002/images/tablet.png',
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: u_16_bold_k000000),
                SizedBox(height: 4),

                // Row(
                //   children: [
                //     Icon(Icons.medication_outlined, size: 12,color: kc0c0c0,),
                //     SizedBox(width: 4),
                //     Text('1 Pill',style: u_16_500_kkc0c0c0,),

                //     SizedBox(width: 16),
                //     Icon(Icons.restaurant, size: 12,color: kc0c0c0,),
                //     SizedBox(width: 4),
                //     Text('After Meal',style: u_16_500_kkc0c0c0),
                //   ],
                // ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(width: 4),
                    Text('${doses}', style: u_18_500_kkc0c0c0),
                    Spacer(),
                    Text('${category}', style: u_18_500_kkc0c0c0),
                  ],
                ),
              ],
            ),
          ),
          //   PopupMenuButton<String>(
          //     color: kf0f9ff,
          //     onSelected: (value) {
          //       if (value == 'taken') {
          //         ScaffoldMessenger.of(context).showSnackBar(
          //           SnackBar(content: Text('$name marked as taken')),
          //         );
          //       } else if (value == 'delete') {
          //         ScaffoldMessenger.of(
          //           context,
          //         ).showSnackBar(SnackBar(content: Text('$name deleted')));
          //       }
          //     },
          //     itemBuilder:
          //         (context) => [
          //           PopupMenuItem(value: 'taken', child: Text('Taken')),
          //           PopupMenuItem(value: 'delete', child: Text('Delete')),
          //         ],
          //     icon: Icon(Icons.more_horiz),
          //   ),
        ],
      ),
    );
  }
}
