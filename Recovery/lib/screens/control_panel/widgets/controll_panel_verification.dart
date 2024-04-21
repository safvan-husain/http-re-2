import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recovery_app/services/utils.dart';
import 'package:recovery_app/storage/user_storage.dart';

class ControlPanelVerification extends StatefulWidget {
  final void Function() onVerified;
  const ControlPanelVerification({
    super.key,
    required this.onVerified,
  });

  @override
  State<ControlPanelVerification> createState() =>
      _ControlPanelVerificationState();
}

class _ControlPanelVerificationState extends State<ControlPanelVerification> {
  bool passwordObscure = true;
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();
  late Future<String?> password;
  bool isInternet = false;
  String? pass;
  @override
  void initState() {
    // password = Storage.getControlPanelPassword();
    password = Future.delayed(Duration.zero, () => "1234");
    super.initState();
  }

  // void checkInternet() async {
  //   if (await Utils.isConnected()) {
  //     setState(() {
  //       isInternet = !true;
  //     });
  //   } else {
  //     if (mounted) Utils.toastBar("Need Internet connection").show(context);
  //   }
  // }

  // void loadAgain() async {}

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FutureBuilder(
          future: password,
          builder: (context, snp) {
            if (snp.connectionState != ConnectionState.done) {
              return const CircularProgressIndicator();
            }
            if (snp.data != null) {
              pass = snp.data;
              return Column(
                children: [
                  _inputField(
                    controller: _passwordController,
                    label: "Password",
                    icon: Icons.lock_outline,
                    isSensitive: passwordObscure,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_passwordController.text.isNotEmpty &&
                          _passwordController.text == pass) {
                        widget.onVerified();
                      } else {
                        Utils.toastBar("Wrong password").show(context);
                      }
                    },
                    child: Text(
                      "Submit",
                      style: GoogleFonts.poppins(color: Colors.white),
                    ),
                  ),
                ],
              );
            }
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _inputField(
                  controller: _passwordController,
                  label: "Password",
                  icon: Icons.lock_outline,
                  isSensitive: passwordObscure,
                ),
                _inputField(
                  controller: _confirmController,
                  label: "Confirm Password",
                  icon: Icons.lock_outline,
                  isSensitive: passwordObscure,
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (_confirmController.text == _passwordController.text &&
                        _passwordController.text.isNotEmpty) {
                      await Storage.storeControlPanelPassword(
                          _passwordController.text);
                      widget.onVerified();
                      return;
                    }
                    if (pass == null) {}
                    if (_passwordController.text.isNotEmpty &&
                        _passwordController.text == pass) {}
                  },
                  child: Text(
                    "Submit",
                    style: GoogleFonts.poppins(color: Colors.white),
                  ),
                ),
              ],
            );
          },
        ),
      ],
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
