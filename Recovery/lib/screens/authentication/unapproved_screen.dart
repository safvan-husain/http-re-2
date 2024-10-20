import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class UnApprovedScreen extends StatelessWidget {
  const UnApprovedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 242, 244, 255),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset('assets/icons/logo.png'),
              Text(
                "Thank you for your interest in joining, We will let you know once approved",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(fontSize: 18),
              ),
              const SizedBox(height: 90),
              ElevatedButton(
                onPressed: () => SystemNavigator.pop(),
                child: Text(
                  "Exit the app",
                  style: GoogleFonts.poppins(fontSize: 18, color: Colors.white),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
