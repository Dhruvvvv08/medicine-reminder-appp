import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:healthmvp/data/services/notifications_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    // Initialize notifications when the screen loads
    NotificationHelper.init();
  }
  // NotificationService notificationService = NotificationService();

  // // Trigger notification on profile option click
  // Future<void> onCreate() async {
  //   await notificationService.showNotification(
  //     0,  // Notification ID
  //     "Profile Option Clicked",  // Notification title
  //     "You clicked on a profile option!",  // Notification body
  //     "This is a simple notification when you clicked on a profile option.",  // Payload (optional)
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            // Handle back button press
          },
        ),
        title: const Text(
          'Your Profile',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          const Center(
            child: CircleAvatar(
              radius: 50,
              // backgroundImage: NetworkImage(
              //     'https://www.gstatic.com/flutter-onestack-prototype/genui/example_1.jpg'),
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Manas',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const Text(
            'manas@gmail.com',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 20),
          ProfileOption(
            icon: Icons.person_outline,
            text: 'My Account',
            onTap: () {
              NotificationHelper.scheduleNotification(
                "Notification test",
                "my app Notification",
                5,
              );
              //  onCreate();  // Show notification on tap
            },
          ),
          ProfileOption(
            icon: Icons.settings,
            text: 'Notification Settings',
            onTap: () {
              // onCreate();  // Show notification on tap
            },
          ),
          ProfileOption(
            icon: Icons.help_outline,
            text: 'Help Center',
            onTap: () {
              //   onCreate();  // Show notification on tap
            },
          ),
          ProfileOption(
            icon: Icons.logout,
            text: 'Log Out',
            onTap: () {
              //   onCreate();  // Show notification on tap
            },
          ),
        ],
      ),
    );
  }
}

class ProfileOption extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;

  const ProfileOption({
    super.key,
    required this.icon,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.blue[50],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Icon(icon, color: Colors.black54),
                const SizedBox(width: 16),
                Text(text, style: const TextStyle(fontSize: 16)),
                const Spacer(),
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.black54,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
