import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recovery_app/screens/search/widgets/report_inputs.dart';

class ReportScreen extends StatefulWidget {
  final String title;
  final Map<String, String> details;
  const ReportScreen({
    super.key,
    required this.title,
    required this.details,
  });

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 242, 244, 255),
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: widget.details.entries
                        .map((e) => Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Text(
                                      e.key,
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    " :    ",
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Expanded(
                                      flex: 2,
                                      child: Text(
                                        e.value.toString(),
                                        style: GoogleFonts.poppins(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      )),
                                ],
                              ),
                            ))
                        .toList(),
                  ),
                ),
              ),
              ReportInputs(
                widget.details,
                widget.title,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
