import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:healthmvp/Utils/colors.dart';
import 'package:healthmvp/Utils/textstyles.dart';

class MedicineScreen extends StatefulWidget {
  @override
  State<MedicineScreen> createState() => _MedicineScreenState();
}

class _MedicineScreenState extends State<MedicineScreen> {
  final List<Map<String, String>> medicines = [
    {'name': 'Melformin 500mg tablets'},
    {'name': 'Paracetamol'},
    {'name': 'Omega - 4'},
    {'name': 'Vitamin C'},
    {'name': 'Napa Extra'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:kf0f9ff ,
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
              child: ListView.builder(
                itemCount: medicines.length,
                itemBuilder: (context, index) {
                  return MedicineCard(name: medicines[index]['name']!);
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

  const MedicineCard({required this.name});

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
            child: Icon(Icons.local_pharmacy_sharp, color:k3a2aab),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: u_16_bold_k000000,
                ),
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
                  children: [
                    Icon(Icons.access_time, size: 16,color: kc0c0c0,),
                    SizedBox(width: 4),
                    Text('8:30 AM',style: u_18_500_kkc0c0c0),
                  ],
                ),
              ],
            ),
          ),
         PopupMenuButton<String>(
          color: kf0f9ff,
            onSelected: (value) {
              if (value == 'taken') {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('$name marked as taken')),
                );
              } else if (value == 'delete') {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('$name deleted')),
                );
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'taken',
                child: Text('Taken'),
              ),
              PopupMenuItem(
                value: 'delete',
                child: Text('Delete'),
              ),
            ],
            icon: Icon(Icons.more_horiz),
          ),
        ],
      ),
    );
  }
}
