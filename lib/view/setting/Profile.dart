import 'package:flutter/material.dart';
import 'package:healthmvp/ViewModel/profile_authmodel.dart';
import 'package:healthmvp/view/Auth/auth.dart';
import 'package:healthmvp/view/Auth/login_screen.dart';
import 'package:healthmvp/view/bottom_nav_bar/bottom_nav.dart';
import 'package:healthmvp/view/dependent/dependent_dashboard.dart';
import 'package:healthmvp/view/subscription/subscription.dart';
import 'package:healthmvp/widgets/textformfield.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchProfileData();
    });
  }

  Future<void> _fetchProfileData() async {
    final profileAuthModel = context.read<ProfileAuthmodel>();
    await profileAuthModel.getdashboarddata(context);
    profileAuthModel.initializeRazorpay();
  }

  Future<void> fetchrazorpay() async {
    final razorpayauthmodel = context.read<ProfileAuthmodel>();
    await razorpayauthmodel.initializeBookingAndPay(context);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileAuthmodel>(
      builder: (context, controllerProvider, child) {
        if (controllerProvider.profileloading &&
            controllerProvider.profiledatamodel == null) {
          return Center(child: CircularProgressIndicator());
        }

        return Scaffold(
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 50),
              child: Column(
                children: [
                  // Header Section
                  Container(
                    padding: EdgeInsets.only(right: 20, left: 20, bottom: 20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFF2563EB),
                          Color.fromARGB(255, 36, 75, 158),
                        ],
                      ),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(top: 40),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(50),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 10,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.person,
                              color: Color(0xFF2563EB),
                              size: 40,
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  controllerProvider
                                          .profiledatamodel
                                          ?.data
                                          .name ??
                                      'User',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  controllerProvider
                                          .profiledatamodel
                                          ?.data
                                          .email ??
                                      '',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.9),
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Container(
                          //   padding: EdgeInsets.all(8),
                          //   decoration: BoxDecoration(
                          //     color: Colors.white.withOpacity(0.2),
                          //     borderRadius: BorderRadius.circular(50),
                          //   ),
                          //   child: Icon(
                          //     Icons.edit,
                          //     color: Colors.white,
                          //     size: 18,
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ),

                  // Main Content
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Personal Information Card
                        _buildSectionCard(
                          "Personal Information",
                          showTitle: false,
                          Column(
                            children: [
                              Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Personal Information",
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF1F2937),
                                        ),
                                      ),
                                      TextButton.icon(
                                        onPressed:
                                            () => _showEditDialog(
                                              controllerProvider
                                                      .profiledatamodel
                                                      ?.data
                                                      .name ??
                                                  'User',
                                              controllerProvider
                                                      .profiledatamodel
                                                      ?.data
                                                      .phone ??
                                                  'User',
                                            ),
                                        icon: Icon(Icons.edit, size: 16),
                                        label: Text("Edit"),
                                        style: TextButton.styleFrom(
                                          foregroundColor: Color(0xFF2563EB),
                                          tapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 12),
                                ],
                              ),

                              _buildInfoItem(
                                Icons.phone,
                                "Phone",
                                controllerProvider
                                        .profiledatamodel
                                        ?.data
                                        .phone ??
                                    'Not provided',
                              ),
                              SizedBox(height: 16),
                              _buildInfoItem(
                                Icons.email,
                                "Email",
                                controllerProvider
                                        .profiledatamodel
                                        ?.data
                                        .email ??
                                    '',
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
                        _buildSectionCard(
                          showTitle: false,
                          "",
                          Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      fetchrazorpay();
                                    },
                                    child: Text(
                                      "Subscription Detail's",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF1F2937),
                                      ),
                                    ),
                                  ),

                                  TextButton.icon(
                                    onPressed:
                                        () => showSubscriptionSheet(context),
                                    icon: Icon(Icons.upgrade, size: 16),
                                    label: Text("Upgrade"),
                                    style: TextButton.styleFrom(
                                      foregroundColor: Color(0xFF2563EB),
                                      tapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              _buildInfoItem(
                                Icons.subscriptions,
                                "Status",
                                controllerProvider
                                        .profiledatamodel
                                        ?.data
                                        .subscription
                                        .status ??
                                    'Not provided',
                              ),
                              SizedBox(height: 16),
                              _buildInfoItem(
                                Icons.date_range,
                                "End's on ",
                                controllerProvider
                                        .profiledatamodel
                                        ?.data
                                        .subscription
                                        .end
                                        .toString()
                                        .split('T')[0] ??
                                    '',
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 20),

                        // Dependents Card
                        _buildSectionCard(
                          "Dependents",
                          Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Dependents",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF1F2937),
                                    ),
                                  ),
                                  TextButton.icon(
                                    onPressed:
                                        () => _showAddDependentDialog(context),
                                    icon: Icon(Icons.add, size: 16),
                                    label: Text("Add"),
                                    style: TextButton.styleFrom(
                                      foregroundColor: Color(0xFF2563EB),
                                      tapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 12),

                              if (controllerProvider
                                      .profiledatamodel
                                      ?.data
                                      .dependents
                                      ?.isEmpty ??
                                  true)
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 16),
                                  child: Text(
                                    "No dependents added yet",
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                )
                              else
                                ...(controllerProvider
                                            .profiledatamodel
                                            ?.data
                                            .dependents ??
                                        [])
                                    .map(
                                      (dependent) => _buildDependentItem(
                                        dependent.toJson(),
                                      ),
                                    )
                                    .toList(),
                            ],
                          ),
                          showTitle: false,
                        ),
                        SizedBox(height: 20),

                        // Logout Button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () => _logout(context),
                            icon: Icon(Icons.logout),
                            label: Text("Logout"),
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              backgroundColor: Color(0xFFFEE2E2),
                              foregroundColor: Color(0xFFDC2626),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 0,
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _showAddDependentDialog(BuildContext context) async {
    final controllerProvider = context.read<ProfileAuthmodel>();
    final emailController = TextEditingController();

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 24,
          ), // wider padding
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: SizedBox(
            width: 400, // wider dialog
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Add Dependent',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: TextFormField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        hintText: 'Dependent Email',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 12,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(color: Color(0xFF2563EB)),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                            Color(0xFF2563EB),
                          ),
                        ),
                        onPressed: () async {
                          final email = emailController.text.trim();
                          if (email.isNotEmpty) {
                            Navigator.of(context).pop();
                            await controllerProvider.linkdependentapi(context, {
                              "dependentEmail": email,
                            });
                            await _fetchProfileData(); // Refresh data after adding
                          }
                        },
                        child: const Text(
                          'Add',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _logout(BuildContext context) async {
    final controllerProvider = context.read<ProfileAuthmodel>();
    await controllerProvider.logoutstatus(context);
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => AuthScreen()),
      (route) => false,
    );
  }

  Widget _buildSectionCard(
    String title,
    Widget content, {
    bool showTitle = true,
  }) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showTitle) ...[
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1F2937),
              ),
            ),
            SizedBox(height: 16),
          ],
          content,
        ],
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String label, String value) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Color(0xFF2563EB).withOpacity(0.1),
            borderRadius: BorderRadius.circular(50),
          ),
          child: Icon(icon, color: Color(0xFF2563EB), size: 20),
        ),
        SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: TextStyle(fontSize: 12, color: Colors.grey)),
            Text(
              value,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDependentItem(Map<String, dynamic> dependent) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => DependentDashboard(dependentid: dependent['_id']),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 8),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Color(0xFF2563EB).withOpacity(0.1),
                borderRadius: BorderRadius.circular(50),
              ),
              child: Icon(Icons.person, color: Color(0xFF2563EB), size: 18),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dependent['name'] ?? 'No name',
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                  ),
                  Text(
                    dependent['email'] ?? 'No email',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  void _showEditDialog(String name, String phonenumber) {
    final namecontroller = TextEditingController(text: name ?? '');
    final phonenumbercontroller = TextEditingController(
      text: phonenumber ?? '',
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          insetPadding: const EdgeInsets.symmetric(horizontal: 24),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: SizedBox(
            width: 400,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Edit Profile',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),

                  // Name Field
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: TextField(
                      controller: namecontroller,
                      decoration: const InputDecoration(
                        hintText: 'User Name',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 12,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Dosage Field
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: TextField(
                      maxLength: 13,
                      keyboardType: TextInputType.number,
                      controller: phonenumbercontroller,
                      decoration: const InputDecoration(
                         counterText: '', 
                        hintText: 'Phone Number',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 12,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Category Dropdown
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(color: Color(0xFF2563EB)),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                            Color(0xFF2563EB),
                          ),
                        ),
                        onPressed: () async {
                          final updatedName = namecontroller.text.trim();
                          final updatedPhone =
                              phonenumbercontroller.text.trim();

                          if (updatedName.isEmpty || updatedPhone.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Please fill all fields"),
                              ),
                            );
                            return;
                          }

                          await Provider.of<ProfileAuthmodel>(
                            context,
                            listen: false,
                          ).updateprofile(context, updatedName, updatedPhone);

                          await Provider.of<ProfileAuthmodel>(
                            context,
                            listen: false,
                          ).getdashboarddata(context);
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          'Save',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
