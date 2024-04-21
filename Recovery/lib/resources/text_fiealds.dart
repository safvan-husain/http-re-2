import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

Widget buildPhoneInputField({
  required TextEditingController controller,
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
    child: TextField(
      keyboardType: TextInputType.phone,
      style: GoogleFonts.poppins(fontSize: 16, color: Colors.black),
      inputFormatters: [LengthLimitingTextInputFormatter(10)],
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: "Phone",
        hintStyle: GoogleFonts.poppins(fontSize: 16, color: Colors.black54),
        prefixIcon: Padding(
          padding: const EdgeInsets.symmetric(vertical: 13),
          child: Text(
            "🇮🇳  +91  ",
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(fontSize: 16, color: Colors.black),
          ),
        ),
      ),
      controller: controller,
    ),
  );
}
