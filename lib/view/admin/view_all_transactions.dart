import 'package:flutter/material.dart';
import 'package:healthmvp/ViewModel/admin_aurhmodel.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:healthmvp/models/payment/payment_transaction.dart';

class ViewAllTransactionsScreen extends StatefulWidget {
  const ViewAllTransactionsScreen({super.key});

  @override
  State<ViewAllTransactionsScreen> createState() => _ViewAllTransactionsScreenState();
}

class _ViewAllTransactionsScreenState extends State<ViewAllTransactionsScreen> {
  @override
  void initState() {
    super.initState();
    print("ViewAllTransactionsScreen initState called");
    Future.microtask(() {
      print("Calling getPaymentTransactions from initState");
      Provider.of<AdminAurhmodel>(context, listen: false)
          .getPaymentTransactions(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final controllerProvider = Provider.of<AdminAurhmodel>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("All Transactions"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              print("Manual refresh triggered");
              Provider.of<AdminAurhmodel>(context, listen: false)
                  .getPaymentTransactions(context);
            },
          ),
        ],
      ),
      body: Consumer<AdminAurhmodel>(
        builder: (context, adminModel, child) {
          // Debug information
          print("Admin Model State:");
          print("  - Transactions Loading: ${adminModel.isTransactionsLoading}");
          print("  - Transactions Error: ${adminModel.transactionsErrorMessage}");
          print("  - Transactions count: ${adminModel.paymentTransactions.length}");
          
          if (adminModel.isTransactionsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (adminModel.transactionsErrorMessage.isNotEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Error: ${adminModel.transactionsErrorMessage}"),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      adminModel.getPaymentTransactions(context);
                    },
                    child: const Text("Retry"),
                  ),
                ],
              ),
            );
          }

          if (adminModel.paymentTransactions.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("No transactions found"),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      adminModel.getPaymentTransactions(context);
                    },
                    child: const Text("Refresh"),
                  ),
                ],
              ),
            );
          }

          // Calculate summary
          double totalAmount = 0;
          for (var transaction in adminModel.paymentTransactions) {
            try {
              totalAmount += double.parse(transaction.amount);
            } catch (e) {
              print("Error parsing amount: ${transaction.amount}");
            }
          }

          return Column(
            children: [
              // Summary Card
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue.shade400, Colors.blue.shade600],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        const Text(
                          "Total Transactions",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          "${adminModel.paymentTransactions.length}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        const Text(
                          "Total Amount",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          "₹${totalAmount.toStringAsFixed(2)}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Transactions List
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemCount: adminModel.paymentTransactions.length,
                  itemBuilder: (context, index) {
                    final transaction = adminModel.paymentTransactions[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: _getTransactionColor(transaction.plan ?? "Unknown"),
                                  child: Icon(
                                    Icons.payment,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "₹${transaction.amount}",
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green,
                                        ),
                                      ),
                                      Text(
                                        transaction.plan ?? 'N/A',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: _getTransactionColor(transaction.plan ?? "Unknown"),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            if (transaction.user != null) ...[
                              _buildInfoRow("User", transaction.user!.name),
                              _buildInfoRow("Email", transaction.user!.email),
                            ],
                            _buildInfoRow("Date", _formatDate(transaction.createdAt)),
                            _buildInfoRow("Transaction ID", transaction.transactionId, isSmall: true),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Color _getTransactionColor(String plan) {
    switch (plan.toLowerCase()) {
      case "premium":
        return Colors.green;
      case "basic":
        return Colors.blue;
      case "free":
        return Colors.grey;
      default:
        return Colors.orange;
    }
  }

  String _formatDate(String dateStr) {
    try {
      final dateTime = DateTime.parse(dateStr);
      return DateFormat('dd MMM yyyy, HH:mm').format(dateTime);
    } catch (e) {
      return dateStr;
    }
  }

  Widget _buildInfoRow(String label, String value, {bool isSmall = false}) {
    return Row(
      children: [
        Text(
          "$label: ",
          style: TextStyle(
            fontSize: isSmall ? 14 : 16,
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isSmall ? 14 : 16,
            fontWeight: FontWeight.w400,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
} 