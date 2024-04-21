import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void showSnackbar(
  String text,
  BuildContext context,
  IconData icon, [
  Color? color,
]) {
  DelightToastBar(
    snackbarDuration: const Duration(seconds: 3),
    autoDismiss: true,
    builder: (context) => ToastCard(
      color: color ?? Colors.blueAccent[300],
      trailing: Padding(
        padding: const EdgeInsets.only(right: 10),
        child: Icon(
          icon,
          size: 28,
          // color: color == null ? null : Colors.white,
        ),
      ),
      title: Text(
        text,
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w700,
          fontSize: 14,
          // color: color == null ? null : Colors.white,
        ),
      ),
    ),
  ).show(context);
}
