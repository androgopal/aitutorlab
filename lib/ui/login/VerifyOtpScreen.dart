import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../cantroller/LoginController.dart';
import '../../theme/mythemcolor.dart';
import '../../utils/styleUtil.dart';
import 'package:get/get.dart';

class VerifyOTPScreen extends StatefulWidget {
  final String email;
  final String pageType;
  const VerifyOTPScreen({Key? key, required this.email, required this.pageType}) : super(key: key);

  @override
  State<VerifyOTPScreen> createState() => _VerifyOTPScreenState();
}

class _VerifyOTPScreenState extends State<VerifyOTPScreen> with SingleTickerProviderStateMixin {
  int secondsRemaining = 60;
  bool enableResend = false;
  Timer? _timer; // <-- make nullable
  TextEditingController textEditingController = TextEditingController();

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Fade animation (same style as login/signup)
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();

    textEditingController = TextEditingController();

    // Start countdown
    _startTimer();
  }

  void _startTimer({int start = 60}) {
    // cancel existing timer if any (safe because _timer is nullable)
    _timer?.cancel();

    setState(() {
      secondsRemaining = start;
      enableResend = false;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      if (secondsRemaining > 0) {
        setState(() {
          secondsRemaining--;
        });
      } else {
        setState(() {
          enableResend = true;
        });
        timer.cancel();
      }
    });
  }

  void _resendCode(/* LoginController providerRead */) {
    // Reset timer and call provider to resend OTP
    _startTimer(start: 120);
    // providerRead.resendOtp(context, widget.email, "otp");
  }

  @override
  void dispose() {
    _animationController.dispose();
    _timer?.cancel(); // <-- safe cancel
    // textEditingController.dispose();
    super.dispose();
  }

  String enteredOtp = "";

  final _formKey = GlobalKey<FormState>();
  final LoginController loginController = Get.put(LoginController());
  @override
  Widget build(BuildContext context) {
    // keep status bar style same as existing screen
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
    ));

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).colorScheme.secondaryContainer,
              Theme.of(context).colorScheme.secondaryContainer,
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo circular container
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        shape: BoxShape.circle,
                      ),
                      child: Image.asset("assets/images/logo.png", height: 70),
                    ),
                    const SizedBox(height: 20),

                    // Title & subtitle
                    Text(
                      'OTP Verify',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontSize: 25,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Enter the OTP sent to ${widget.email}',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Card with pin-field and button
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 20,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            const SizedBox(height: 8),

                            // PIN CODE FIELD
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                              child: PinCodeTextField(
                                appContext: context,
                                length: 4,
                                controller: textEditingController,
                                animationType: AnimationType.fade,
                                keyboardType: TextInputType.number,
                                cursorColor: Colors.black,
                                animationDuration: const Duration(milliseconds: 300),
                                enableActiveFill: true,
                                pinTheme: PinTheme(
                                  shape: PinCodeFieldShape.box,
                                  fieldOuterPadding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 5),
                                  borderRadius: BorderRadius.circular(5),
                                  borderWidth: 1,
                                  fieldHeight: 45,
                                  fieldWidth: 45,
                                  errorBorderColor: Colors.redAccent,
                                  activeFillColor: Colors.white,
                                  inactiveFillColor: Colors.white,
                                  inactiveColor: Colors.grey,
                                  activeColor: Colors.green.shade50,
                                  selectedColor: myprimarycolorAccent,
                                  selectedFillColor: Colors.white,
                                ),
                                textStyle: const TextStyle(color: Colors.black, fontSize: 16),
                                boxShadows: const [BoxShadow(offset: Offset(0, 0.5), color: Colors.black12, blurRadius: 0)],
                                onCompleted: (v) {
                                  enteredOtp = v;
                                },
                                onChanged: (value) {
                                  enteredOtp = value;
                                  setState(() {});
                                },
                                beforeTextPaste: (text) => true,
                              ),
                            ),

                            const SizedBox(height: 12),

                            // Verify Button
                            Obx(
                                    () {
                                return SizedBox(
                                  width: double.infinity,
                                  height: 52,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      String otp = textEditingController.text.trim();
                                      if (otp.length != 4) {
                                        showToast("Enter valid 4 digit OTP");
                                        return;
                                      }
                                      if(!loginController.isLoading.value){
                                        Map<String, String> userData = {
                                          "user_email": widget.email.toString(),
                                          "otp": otp.toString(),
                                        };
                                        loginController.verifyOTP(userData);
                                      }


                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.deepPurple.shade400,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                      elevation: 0,
                                    ),
                                    child: !loginController.isLoading.value ? const Text(
                                      'Verify & Continue',
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                                    ) : buttonLoader(),
                                  ),
                                );
                              }
                            ),

                            const SizedBox(height: 12),

                            // Resend / countdown row
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (!enableResend)
                                  Text(
                                    'OTP not received? $secondsRemaining s',
                                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                                  ),
                                if (enableResend)
                                  InkWell(
                                    onTap: () {
                                      _resendCode();
                                      Map<String, String> userData = {
                                        "user_email" : widget.email.toString()
                                      };
                                      loginController.reSendOTP(userData);
                                    },
                                    child: const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                        'Resend OTP',
                                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 18),

                    // Back to previous / change email
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Wrong email? "),
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text(
                            "Change",
                            style: TextStyle(fontWeight: FontWeight.bold, color: myprimarycolor),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Optional helper to show the verification dialog if you still want to use
  Future<bool?> showVerificationDialog(context, msg) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              'Check your mail for otp',
              style: TextStyle(color: Colors.black),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  msg,
                  style: const TextStyle(color: Colors.black, fontSize: 13, fontFamily: "ssr"),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('', style: TextStyle(color: myprimarycolor, fontFamily: 'ssb', fontSize: 16)),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK', style: TextStyle(color: myprimarycolor, fontFamily: 'ssb', fontSize: 16)),
              ),
            ],
          );
        });
  }
}
