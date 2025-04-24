// import 'package:flutter/material.dart';
// import '../../services/notification_service.dart';

// class NotificationScreen extends StatefulWidget {
//   const NotificationScreen({super.key});

//   @override
//   State<NotificationScreen> createState() => _NotificationScreenState();
// }

// class _NotificationScreenState extends State<NotificationScreen> {
//   final NotificationService _notificationService = NotificationService();
//   bool _isLoading = false;

//   // Future<void> _showNotification() async {
//   //   setState(() {
//   //     _isLoading = true;
//   //   });

//   //   try {
//   //     await _notificationService.showNotification(
//   //       id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
//   //       title: 'Medicine Reminder',
//   //       body: 'Time to take your medicine!',
//   //     );
//   //     ScaffoldMessenger.of(context).showSnackBar(
//   //       const SnackBar(
//   //         content: Text('Notification sent successfully!'),
//   //         backgroundColor: Colors.green,
//   //       ),
//   //     );
//   //   } catch (e) {
//   //     ScaffoldMessenger.of(context).showSnackBar(
//   //       SnackBar(
//   //         content: Text('Error sending notification: $e'),
//   //         backgroundColor: Colors.red,
//   //       ),
//   //     );
//   //   } finally {
//   //     setState(() {
//   //       _isLoading = false;
//   //     });
//   //   }
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Notification Test'),
//         backgroundColor: Colors.blue,
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Text(
//               'Test Notification System',
//               style: TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 20),
//             const Text(
//               'Click the button below to send a test notification',
//               style: TextStyle(
//                 fontSize: 16,
//                 color: Colors.grey,
//               ),
//               textAlign: TextAlign.center,
//             ),
//             const SizedBox(height: 40),
//             ElevatedButton(
//                onPressed:
               
//                // _isLoading 
//                //? null : 
//                //_showNotification,
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.blue,
//                 padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//               ),
//               child: _isLoading
//                   ? const SizedBox(
//                       width: 20,
//                       height: 20,
//                       child: CircularProgressIndicator(
//                         color: Colors.white,
//                         strokeWidth: 2,
//                       ),
//                     )
//                   : const Text(
//                       'Send Notification',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// } 