import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:go_router/go_router.dart';
import 'package:healthmvp/Utils/colors.dart';
import 'package:healthmvp/Utils/textstyles.dart';
import 'package:healthmvp/ViewModel/auth_viewmodel.dart';
import 'package:healthmvp/view/Auth/emailwithotp.dart';
import 'package:healthmvp/widgets/submitbutton.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sms_autofill/sms_autofill.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  void checkforotp() async {
    await SmsAutoFill().listenForCode();
  }

  @override
  void initState() {
    checkforotp();
    super.initState();
  }

  @override
  void dispose() {
    SmsAutoFill().unregisterListener();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<AuthViewmodel>(context);
    return Scaffold(
      backgroundColor: Color(0xFF2563EB),
      body: Padding(
        padding: const EdgeInsets.only(
          top: 80,
          right: 20,
          left: 20,
          bottom: 60,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Emailwithotp()),
                    );
                  },
                ),
              ],
            ),
            Center(
              child: Image.asset(
                "images/HealthMVP Logo Mark PNG 1 .png",
                height: 80,
                width: 80,
              ),
            ),
            // Container(
            //   decoration: BoxDecoration(
            //     borderRadius: BorderRadius.circular(20),
            //   ),
            //   child: Center(child: Image.asset('images/logo.png')),
            // ),
            SizedBox(height: 80),

            Center(child: Text('Verify OTP', style: u_24_800_k000000)),
            const SizedBox(height: 12),
            Center(
              child: Text(
                'Sign in to access your account and stay connected to',
                style: u_12_500_kkc0c0c0,
              ),
            ),
            Center(
              child: Text('your health journey.', style: u_12_500_kkc0c0c0),
            ),
            SizedBox(height: 50),
            // OtpTextField(
            //   numberOfFields: 6,
            //   borderColor: Color(0xFF512DA8),

            //   showFieldAsBox: true,
            //   keyboardType: TextInputType.number,
            //   fieldWidth: 50,
            //   onCodeChanged: (String code) {},

            //   onSubmit: (String verificationCode) {
            //     controller.InputOtp.value = verificationCode.toString();
            //     print("$verificationCode");
            //     // showDialog(
            //     //     context: context,
            //     //     builder: (context){
            //     //     return AlertDialog(
            //     //         title: Text("Verification Code"),
            //     //         content: Text('Code entered is $verificationCode'),
            //     //     );
            //     //     }
            //     // );
            //   }, // end onSubmit
            // ),
            PinFieldAutoFill(
              decoration: BoxLooseDecoration(
                strokeColorBuilder: PinListenColorBuilder(
                  Colors.black,
                  Colors.black26,
                ),
                bgColorBuilder: const FixedColorBuilder(Color(0xfff0f9ff)),
                strokeWidth: 1,
              ),
              autoFocus: true,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                FilteringTextInputFormatter.digitsOnly,
              ],
              cursor: Cursor(color: Colors.red, enabled: true, width: 1),
              currentCode: '',
              onCodeSubmitted: (code) {},
              codeLength: 6,
              onCodeChanged: (code) {
                if (code.toString().length == 6) {
                  controller.InputOtp = code.toString();
                  controller.verifyotp(context);
                }
              },
            ),
            SizedBox(height: 12),

            //      controller.isresendenable
            // ? Align(
            //     alignment: Alignment.bottomRight,
            //     child: GestureDetector(
            //       onTap: () {
            //         controller.getotp(context);
            //         controller.resendotppp(); // start countdown
            //       },
            //       child: Text("Resend OTP", style: u_14_500_k000000),
            //     ),
            //   )
            // : Align(
            //     alignment: Alignment.bottomRight,
            //     child: Text("Wait for ${controller.counter} sec to resend OTP", style: u_14_500_k000000),
            //   ),
            Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF525CEB),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                onPressed: () {
                  //  provider.getotp(context);
                  controller.submitotp(context);
                  controller.verifyotp(context);
                  print('otppppp${controller.InputOtp}');
                  // controller
                  //     .validateMobile(controller.phonenumbercontroller.text);

                  print("abcd");
                },
                child: const Text('Verify', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
