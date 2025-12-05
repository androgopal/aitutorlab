import 'dart:async';

import 'package:aitutorlab/cantroller/LoginController.dart';
import 'package:aitutorlab/theme/mythemcolor.dart';
import 'package:aitutorlab/utils/styleUtil.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpPage extends StatefulWidget {
  final email;
  const SignUpPage({Key? key, required this.email}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  late var _email = TextEditingController();
  final _mobile = TextEditingController();
  final _dob = TextEditingController();
  final _password = TextEditingController();

  bool _obscurePassword = true;
  String dobApiFormat = "";

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  final LoginController loginController = Get.find<LoginController>();
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _fadeAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
          parent: _animationController,
          curve: Curves.easeInOut,
        ));
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _firstName.dispose();
    _lastName.dispose();
    _email.dispose();
    _mobile.dispose();
    _dob.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _pickDOB() async {
    DateTime today = DateTime.now();
    DateTime minAllowedDate = DateTime(today.year - 11, today.month, today.day);

    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: minAllowedDate,
      firstDate: DateTime(1950),
      lastDate: minAllowedDate,
      helpText: "Select Date of Birth",
    );

    if (picked != null) {
      // Display format -> DD/MM/YYYY
      _dob.text = "${picked.day}/${picked.month}/${picked.year}";

      // API format -> YYYY-MM-DD
      dobApiFormat =
      "${picked.year.toString().padLeft(4, '0')}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.secondaryContainer,
              Theme.of(context).colorScheme.secondaryContainer,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        shape: BoxShape.circle,
                      ),
                      child: Image.asset(
                        "assets/images/logo.png",
                        height: 90,
                      ),
                    ),
                    const SizedBox(height: 20),

                    const Text(
                      "Create Account",
                      style:
                      TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Register to get started",
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).hintColor,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // CARD
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 20,
                          ),
                        ],
                      ),

                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            _inputField(
                              controller: _firstName,
                              label: "First Name",
                              icon: Icons.person_outline,
                              validator: (v) =>
                              v!.isEmpty ? "Enter first name" : null,
                            ),
                            const SizedBox(height: 15),

                            _inputField(
                              controller: _lastName,
                              label: "Last Name",
                              icon: Icons.person_outline,
                              validator: (v) =>
                              v!.isEmpty ? "Enter last name" : null,
                            ),
                            const SizedBox(height: 15),

                            /*_inputField(
                              controller: _email,
                              label: "Email",
                              icon: Icons.email_outlined,
                              keyboard: TextInputType.emailAddress,
                              validator: (v) {
                                if (v!.isEmpty) return "Enter email";
                                if (!v.contains("@")) return "Invalid email";
                                return null;
                              },
                            ),
                            const SizedBox(height: 15),*/

                            _inputField(
                              controller: _mobile,
                              label: "Mobile No",
                              icon: Icons.phone_android,
                              keyboard: TextInputType.phone,
                              validator: (v) =>
                              v!.length < 10 ? "Enter valid mobile no" : null,
                            ),
                            const SizedBox(height: 15),

                            // DOB FIELD
                            TextFormField(
                              controller: _dob,
                              readOnly: true,
                              onTap: _pickDOB,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                labelText: "Date of Birth",
                                prefixIcon: Icon(Icons.date_range,
                                    color: Colors.deepPurple.shade300),
                                border: _outlineBorder(),
                                enabledBorder: _enableBorder(),
                                focusedBorder: _focusBorder(),
                              ),
                              validator: (v) =>
                              v!.isEmpty ? "Please select DOB" : null,
                            ),
                            const SizedBox(height: 15),

                            // PASSWORD FIELD
                            TextFormField(
                              obscureText: _obscurePassword,
                              controller: _password,
                              decoration: InputDecoration(
                                labelText: "Password",
                                prefixIcon: Icon(Icons.lock_outline,
                                    color: Colors.deepPurple.shade300),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                  ),
                                  onPressed: () =>
                                      setState(() => _obscurePassword =
                                      !_obscurePassword),
                                ),
                                border: _outlineBorder(),
                                enabledBorder: _enableBorder(),
                                focusedBorder: _focusBorder(),
                              ),
                              validator: (v) => v!.length < 3
                                  ? "Password must be 3+ characters"
                                  : null,
                            ),
                            const SizedBox(height: 25),

                            // SIGN UP BUTTON
                            Obx(
                                    () {
                                return SizedBox(
                                  width: double.infinity,
                                  height: 54,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        if(!loginController.isLoading.value){
                                          Map<String, dynamic> userData = {
                                            "user_fname" : _firstName.text.trim().toString(),
                                            "user_lname" : _lastName.text.trim().toString(),
                                            "user_email" : widget.email.toString(),
                                            "user_mobile" : _mobile.text.trim().toString(),
                                            "user_dob" : dobApiFormat.toString(),
                                            "user_password" : _password.text.trim().toString(),
                                          };
                                          debugPrint("userData: $userData");
                                          loginController.finalRegister(userData);
                                        }
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.deepPurple.shade400,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      elevation: 0,
                                    ),
                                    child: !loginController.isLoading.value ? const Text(
                                      "Sign Up",
                                      style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ) : buttonLoader(),
                                  ),
                                );
                              }
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Already have an account? "),
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text(
                            "Login",
                            style: TextStyle(
                              color: myprimarycolor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
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

  // ----------------------------------------------------------------------

  Widget _inputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboard = TextInputType.text,
    FormFieldValidator<String>? validator,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboard,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.deepPurple.shade300),
        border: _outlineBorder(),
        enabledBorder: _enableBorder(),
        focusedBorder: _focusBorder(),
      ),
    );
  }

  OutlineInputBorder _outlineBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
    );
  }

  OutlineInputBorder _enableBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.grey.shade300),
    );
  }

  OutlineInputBorder _focusBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide:
      BorderSide(color: Colors.deepPurple.shade400, width: 2),
    );
  }
}
