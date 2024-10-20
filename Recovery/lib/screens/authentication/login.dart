import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recovery_app/models/agency_details.dart';
import 'package:recovery_app/resources/snack_bar.dart';
import 'package:recovery_app/resources/text_fiealds.dart';
import 'package:recovery_app/screens/authentication/sign_up_screen_initial.dart';
import 'package:recovery_app/services/auth_services.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool passwordObscure = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color.fromARGB(255, 242, 244, 255),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(height: 20),
                // Image.asset('assets/icons/logo.jpeg'),
                Text(
                  'Welcome 👋',
                  style: GoogleFonts.outfit(
                    textStyle: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff2c65d8),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Login with your phone number and password',
                  style: GoogleFonts.outfit(
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Color(0xff23202a),
                    ),
                  ),
                ),
                Column(
                  children: [
                    buildPhoneInputField(
                      controller: _phoneController,
                    ),
                    _inputField(
                      controller: _passwordController,
                      label: "Password",
                      icon: Icons.lock_outline,
                      isSensitive: passwordObscure,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (c) => const Login()),
                                (route) => false,
                              );
                            },
                            child: const Text(
                              'Use OTP instead',
                              style: TextStyle(
                                color: Color(0xff2c65d8),
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    if (_phoneController.text.isEmpty ||
                        _passwordController.text.isEmpty ||
                        _passwordController.text.isEmpty) {
                      showSnackbar(
                        "Every fiealds are required",
                        context,
                        Icons.no_encryption,
                      );
                      return;
                    }
                    AuthServices.loginUser(
                      userName: _userNameController.text,
                      phoneNumber: _phoneController.text,
                      password: _passwordController.text,
                      context: context,
                    );
                  },
                  style: ButtonStyle(
                    textStyle: MaterialStateProperty.all<TextStyle>(
                      const TextStyle(color: Colors.white),
                    ),
                    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                      const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 100), // Adjust the padding here
                    ),
                    backgroundColor: MaterialStateProperty.all<Color>(
                        const Color(0xff2c65d8)),
                    shape: MaterialStateProperty.all<OutlinedBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                  child: Text(
                    'Login',
                    maxLines: 1,
                    style: GoogleFonts.outfit(
                      textStyle: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (c) => SignUpScreenInitial(
                              agencyId: AgencyDetails().id,
                              agencyName: AgencyDetails().agencyName,
                            )));
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Don't have an account?"),
                      SizedBox(width: 5),
                      Text(
                        'Sign Up',
                        style: TextStyle(
                          color: Color(0xff2c65d8),
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container _inputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool? isSensitive,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.blue, width: 1.0)),
      child: TextFormField(
        style: GoogleFonts.poppins(color: Colors.black),
        controller: controller,
        obscureText: isSensitive ?? false,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "Password",
          hintStyle: GoogleFonts.poppins(fontSize: 16, color: Colors.black54),
          prefixIcon: Icon(icon),
          suffixIcon: isSensitive == null
              ? null
              : InkWell(
                  onTap: () {
                    setState(() {
                      passwordObscure = !passwordObscure;
                    });
                  },
                  child: Icon(
                    passwordObscure ? Icons.visibility_off : Icons.visibility,
                  ),
                ),
        ),
      ),
    );
  }
}
