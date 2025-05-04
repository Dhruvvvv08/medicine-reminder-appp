import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:healthmvp/ViewModel/profile_authmodel.dart';
import 'package:healthmvp/data/services/shared_pref_service.dart';
import 'package:healthmvp/view/Auth/auth.dart';
import 'package:healthmvp/view/Auth/login_screenn.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  ProfileAuthmodel? profileauthmodel;
  @override
  void initState() {
    profileauthmodel = Provider.of<ProfileAuthmodel>(context, listen: false);
    profileauthmodel?.getdashboarddata(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final controllerprovider = Provider.of<ProfileAuthmodel>(context);
    return Scaffold(
      body:
          controllerprovider.profileloading == true
              ? Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                child: Column(
                  children: [
                    // Header Section
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: const BoxDecoration(
                        color: Color(0xFF2563EB),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(50),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 10,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.person,
                                color: Color(0xFF2563EB),
                                size: 40,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    controllerprovider
                                        .profiledatamodel!
                                        .data
                                        .name,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    controllerprovider
                                        .profiledatamodel!
                                        .data
                                        .email,
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.9),
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: const Icon(
                                Icons.edit,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Main Content
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Personal Information Card
                          _buildSectionCard(
                            "Personal Information",
                            Column(
                              children: [
                                _buildInfoItem(
                                  Icons.phone,
                                  "Phone",
                                  controllerprovider
                                      .profiledatamodel!
                                      .data
                                      .phone,
                                ),
                                const SizedBox(height: 16),
                                _buildInfoItem(
                                  Icons.email,
                                  "Email",
                                  controllerprovider
                                      .profiledatamodel!
                                      .data
                                      .email,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Dependents Card
                          _buildSectionCard(
                            "Dependents",
                            Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "Dependents",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF1F2937),
                                      ),
                                    ),
                                    TextButton.icon(
                                      onPressed: () {},
                                      icon: const Icon(Icons.add, size: 16),
                                      label: const Text("Add"),
                                      style: TextButton.styleFrom(
                                        foregroundColor: const Color(
                                          0xFF2563EB,
                                        ),
                                        tapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),

                                ...(controllerprovider
                                            .profiledatamodel
                                            ?.data
                                            ?.dependents ??
                                        [])
                                    .map(
                                      (dependent) =>
                                          _buildDependentItem(dependent),
                                    )
                                    .toList(),
                              ],
                            ),
                            showTitle: false,
                          ),
                          const SizedBox(height: 20),

                          // Notification Preferences Card
                          // _buildSectionCard(
                          //   "Notification Preferences",
                          //   Column(
                          //     children: [
                          //       Row(
                          //         children: [
                          //           const Icon(
                          //             Icons.notifications_outlined,
                          //             color: Color(0xFF2563EB),
                          //             size: 18,
                          //           ),
                          //           const SizedBox(width: 8),
                          //           const Text(
                          //             "Notification Preferences",
                          //             style: TextStyle(
                          //               fontSize: 18,
                          //               fontWeight: FontWeight.w600,
                          //               color: Color(0xFF1F2937),
                          //             ),
                          //           ),
                          //         ],
                          //       ),
                          //       const SizedBox(height: 16),
                          //       // _buildToggleOption("Email Notifications", true, (
                          //       //   value,
                          //       // ) {
                          //       //   // setState(() {
                          //       //   //   userData['notificationPreferences']['email'] = value;
                          //       //   // });
                          //       // }),
                          //       // const Divider(),
                          //       // _buildToggleOption("Push Notifications", true, (value) {
                          //       //   // setState(() {
                          //       //   //   userData['notificationPreferences']['push'] = value;
                          //       //   // });
                          //       // }),
                          //       // const Divider(),
                          //       // _buildToggleOption("SMS Notifications", true, (value) {
                          //       //   // setState(() {
                          //       //   //   userData['notificationPreferences']['sms'] = value;
                          //       //   // });
                          //       // }),
                          //     ],
                          //   ),
                          //   showTitle: false,
                          // ),
                          // const SizedBox(height: 20),

                          // Logout Button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                SharedPref.pref!.remove(Preferences.token);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AuthScreen(),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.logout),
                              label: const Text("Logout"),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                backgroundColor: const Color(0xFFFEE2E2),
                                foregroundColor: const Color(0xFFDC2626),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                elevation: 0,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
    );
  }

  Widget _buildSectionCard(
    String title,
    Widget content, {
    bool showTitle = true,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showTitle) ...[
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1F2937),
              ),
            ),
            const SizedBox(height: 16),
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
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFF2563EB).withOpacity(0.1),
            borderRadius: BorderRadius.circular(50),
          ),
          child: Icon(icon, color: const Color(0xFF2563EB), size: 20),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
            Text(
              value,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDependentItem(Map dependent) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF2563EB).withOpacity(0.1),
              borderRadius: BorderRadius.circular(50),
            ),
            child: const Icon(Icons.person, color: Color(0xFF2563EB), size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dependent['name'] as String,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
                Text(
                  dependent['email'] as String,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: Colors.grey),
        ],
      ),
    );
  }

  Widget _buildToggleOption(
    String label,
    bool value,
    Function(bool) onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Color(0xFF1F2937),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: const Color(0xFF2563EB),
          ),
        ],
      ),
    );
  }
}
