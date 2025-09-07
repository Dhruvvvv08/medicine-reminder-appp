import 'package:flutter/material.dart';
import 'package:healthmvp/ViewModel/admin_aurhmodel.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:healthmvp/models/admin/getallusers.dart';


class ViewAllUsersScreen extends StatefulWidget {
  const ViewAllUsersScreen({super.key});

  @override
  State<ViewAllUsersScreen> createState() => _ViewAllUsersScreenState();
}

class _ViewAllUsersScreenState extends State<ViewAllUsersScreen> {
  @override
  void initState() {
    super.initState();
    print("ViewAllUsersScreen initState called");
    Future.microtask(() {
      print("Calling getallusersdata from initState");
      Provider.of<AdminAurhmodel>(context, listen: false)
          .getallusersdata(context);
    });
  }

  @override
  Widget build(BuildContext context) {
      final controllerProvider = Provider.of<AdminAurhmodel>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("All Users"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              print("Manual refresh triggered");
              Provider.of<AdminAurhmodel>(context, listen: false)
                  .getallusersdata(context);
            },
          ),
        ],
      ),
      body: Consumer<AdminAurhmodel>(
  builder: (context, adminModel, child) {
    // Debug information
    print("Admin Model State:");
    print("  - Loading: ${adminModel.isadminloading}");
    print("  - Error: ${adminModel.errorMessage}");
    print("  - Users count: ${adminModel.viewallUsers.length}");
    
    if (adminModel.isadminloading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (adminModel.errorMessage.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Error: ${adminModel.errorMessage}"),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                adminModel.getallusersdata(context);
              },
              child: const Text("Retry"),
            ),
          ],
        ),
      );
    }

    if (adminModel.viewallUsers.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("No users found"),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                adminModel.getallusersdata(context);
              },
              child: const Text("Refresh"),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      itemCount: adminModel.viewallUsers.length,
      itemBuilder: (context, index) {
        final user = adminModel.viewallUsers[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: _getStatusColor(user.subscription?.status ?? "Free"),
              child: Text(
                user.name.isNotEmpty ? user.name[0].toUpperCase() : "?",
                style: const TextStyle(color: Colors.white),
              ),
            ),
            title: Text(user.name),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("ID: ${user.id}", style: const TextStyle(fontSize: 12, color: Colors.grey)),
                Text("Email: ${user.email}"),
                if (user.phone != null) Text("Phone: ${user.phone}"),
                Text("Status: ${user.subscription?.status ?? 'Free'}"),
                if (user.subscription?.endDate.isNotEmpty ?? false)
                  Text("End Date: ${_formatDate(user.subscription!.endDate)}"),
              ],
            ),
            trailing: Container(
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => _showDeleteConfirmation(context, adminModel, user),
                tooltip: 'Delete User',
              ),
            ),
          ),
        );
      },
    );
  },
),

    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case "premium":
        return Colors.green;
      case "free":
        return Colors.blue;
      case "expired":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _formatDate(String dateStr) {
    try {
      final dateTime = DateTime.parse(dateStr);
      return DateFormat('dd MMM yyyy').format(dateTime);
    } catch (e) {
      return dateStr;
    }
  }

  void _showDeleteConfirmation(BuildContext context, AdminAurhmodel adminModel, ViewallUsersModel user) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete User'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Are you sure you want to delete ${user.name}?'),
              const SizedBox(height: 8),
              Text('User ID: ${user.id}', style: const TextStyle(fontSize: 12, color: Colors.grey)),
              const SizedBox(height: 8),
              const Text('This action cannot be undone.', style: TextStyle(color: Colors.red)),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await _deleteUser(context, adminModel, user);
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteUser(BuildContext context, AdminAurhmodel adminModel, ViewallUsersModel user) async {
    // Validate user ID
    if (user.id.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error: Invalid user ID'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 16),
              Text('Deleting user...'),
            ],
          ),
        );
      },
    );

    // Perform delete operation
    final success = await adminModel.deleteUser(context, user.id);
    
    // Hide loading indicator
    Navigator.of(context).pop();
    
    if (success) {
      // User was deleted successfully, list is already updated
      print('User ${user.name} (ID: ${user.id}) deleted successfully');
    }
  }
}
