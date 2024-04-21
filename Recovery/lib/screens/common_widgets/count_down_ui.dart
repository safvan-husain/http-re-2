import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Countdown extends AnimatedWidget {
  const Countdown({Key? key, required this.animation})
      : super(key: key, listenable: animation);
  final Animation<int> animation;

  @override
  Widget build(BuildContext context) {
    Duration clockTimer = Duration(seconds: animation.value);

    String timerText =
        '${clockTimer.inMinutes.remainder(60).toString()}:${clockTimer.inSeconds.remainder(60).toString().padLeft(2, '0')}';

    return Text(
      "($timerText)",
      style: GoogleFonts.poppins(
        fontSize: 16,
        color: Colors.grey,
      ),
    );
  }
}
