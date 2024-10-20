import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recovery_app/resources/snack_bar.dart';
import 'package:recovery_app/resources/text_fiealds.dart';
import 'package:recovery_app/screens/authentication/login.dart';
import 'package:recovery_app/services/auth_services.dart';
import 'package:recovery_app/services/image_file_reciever.dart';
import 'package:recovery_app/services/sim_services.dart';
import 'package:recovery_app/services/utils.dart';

class SignUpScreenInitial extends StatefulWidget {
  final String agencyName;
  final String agencyId;

  const SignUpScreenInitial({
    super.key,
    required this.agencyName,
    required this.agencyId,
  });

  @override
  State<SignUpScreenInitial> createState() => _SignUpScreenInitialState();
}

class _SignUpScreenInitialState extends State<SignUpScreenInitial> {
  bool isPasswordHide = true;
  bool isCPasswordHide = true;
  bool _isLoading = false;
  File? panCard;
  File? adharCard;
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _pinCodeController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _districtController = TextEditingController();
  final TextEditingController _villageController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();
  bool passwordObscure = true;
  bool isSecondPage = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      backgroundColor: const Color.fromARGB(255, 242, 244, 255),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height - 50),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    Text(
                      'Provide your details here for verification\n from ${widget.agencyName}',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.outfit(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Color(0xff23202a),
                      ),
                    ),
                    const SizedBox(height: 10),
                    if (isSecondPage) ...[
                      _inputFieald(
                        controller: _addressController,
                        icon: FontAwesomeIcons.addressCard,
                        label: 'Address',
                      ),
                      _inputFieald(
                        controller: _stateController,
                        icon: FontAwesomeIcons.addressCard,
                        label: 'State',
                      ),
                      _inputFieald(
                        controller: _districtController,
                        icon: FontAwesomeIcons.addressCard,
                        label: 'district ',
                      ),
                      _inputFieald(
                        controller: _villageController,
                        icon: FontAwesomeIcons.addressCard,
                        label: 'Village',
                      ),
                      _inputFieald(
                        controller: _pinCodeController,
                        icon: FontAwesomeIcons.addressCard,
                        label: 'Pin Code',
                      ),
                    ] else ...[
                      _inputFieald(
                        controller: _userNameController,
                        icon: FontAwesomeIcons.user,
                        label: 'Full Name',
                      ),
                      buildPhoneInputField(
                        controller: _emailController,
                      ),
                      _inputFieald(
                        controller: _passwordController,
                        label: "Password",
                        icon: Icons.lock_outline,
                        isSensitive: passwordObscure,
                      ),
                      _inputFieald(
                        controller: _confirmController,
                        label: "Confirm Password",
                        icon: Icons.lock_outline,
                        isSensitive: passwordObscure,
                      ),
                      Container(
                        padding: const EdgeInsets.all(10),
                        width: MediaQuery.of(context).size.width,
                        height: 60,
                        child: Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () async {
                                  var file = await ImageFile.pick(context);
                                  setState(() {
                                    panCard = file;
                                  });
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  margin: const EdgeInsets.all(5),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 5),
                                  decoration: BoxDecoration(
                                      color: panCard == null
                                          ? Colors.white
                                          : Colors.greenAccent,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                          color: Colors.blue, width: 1.0)),
                                  child: Text(
                                    panCard == null
                                        ? "Pick Pan Card"
                                        : "Pan Card ✔️",
                                    style: GoogleFonts.poppins(fontSize: 12),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: InkWell(
                                onTap: () async {
                                  var file = await ImageFile.pick(context);
                                  setState(() {
                                    adharCard = file;
                                  });
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  margin: const EdgeInsets.all(5),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 5,
                                  ),
                                  decoration: BoxDecoration(
                                      color: adharCard == null
                                          ? Colors.white
                                          : Colors.greenAccent,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                          color: Colors.blue, width: 1.0)),
                                  child: Text(
                                    adharCard == null
                                        ? "Pick Adhar Card"
                                        : "Adhar Card ✔️",
                                    style: GoogleFonts.poppins(fontSize: 12),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () async {
                        if (isSecondPage) {
                          if (_pinCodeController.text.isEmpty ||
                              _stateController.text.isEmpty ||
                              _villageController.text.isEmpty ||
                              _districtController.text.isEmpty) {
                            Utils.toastBar("Please enter all details")
                                .show(context);
                            return;
                          }
                          setState(() {
                            _isLoading = true;
                          });

                          await AuthServices.registerUser(
                            userName: _userNameController.text,
                            email: _emailController.text,
                            password: _passwordController.text,
                            context: context,
                            panCard: panCard!,
                            adharCard: adharCard!,
                            agencyId: widget.agencyId,
                            address: _addressController.text,
                            phone: _emailController.text,
                            state: _stateController.text,
                            district: _districtController.text,
                            pinCode: _pinCodeController.text,
                            village: _villageController.text,
                            deviceId: await Utils.getImei(),
                          );

                          setState(() {
                            _isLoading = false;
                          });
                          return;
                        }
                        if (_passwordController.text.isEmpty ||
                            _userNameController.text.isEmpty) {
                          showSnackbar(
                            "Every field required",
                            context,
                            FontAwesomeIcons.fill,
                            Colors.redAccent,
                          );
                          return;
                        }
                        if (mounted) {
                          if (_passwordController.text !=
                              _confirmController.text) {
                            showSnackbar(
                              "Password mismatch",
                              context,
                              FontAwesomeIcons.cancel,
                              Colors.redAccent,
                            );
                            return;
                          }
                          if (panCard == null || adharCard == null) {
                            showSnackbar(
                              "Please provide Pan and Adhar cards",
                              context,
                              FontAwesomeIcons.cancel,
                              Colors.redAccent,
                            );
                            return;
                          }
                        }
                        setState(() {
                          isSecondPage = true;
                        });
                      },
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                          const EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal: 70,
                          ), // Adjust the padding here
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
                        isSecondPage ? 'Sign Up' : "Next",
                        maxLines: 1,
                        style: GoogleFonts.outfit(
                          textStyle: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (c) => const Login()),
                          (p) => false,
                        );
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Already have an account?"),
                          SizedBox(width: 5),
                          Text(
                            'Log In',
                            style: TextStyle(
                              color: Color(0xff2c65d8),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
          if (_isLoading) ...[
            ModalBarrier(
              dismissible: false,
              color: Colors.black.withOpacity(0.3),
            ),
            const Center(
              child: CircularProgressIndicator(),
            )
          ],
        ],
      ),
    );
  }

  Container _inputFieald({
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
        controller: controller,
        obscureText: isSensitive ?? false,
        style: GoogleFonts.poppins(color: Colors.black),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: label,
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
