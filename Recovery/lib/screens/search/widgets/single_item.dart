import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recovery_app/models/agency_details.dart';
import 'package:recovery_app/resources/snack_bar.dart';
import 'package:recovery_app/screens/HomePage/cubit/home_cubit.dart';
import 'package:recovery_app/screens/search/widgets/report_inputs.dart';
import 'package:recovery_app/screens/search/widgets/report_screen.dart';
import 'package:recovery_app/services/utils.dart';

class SingleItemScreen extends StatefulWidget {
  final Map<String, String> details;
  final String heroTag;
  const SingleItemScreen({
    super.key,
    required this.details,
    required this.heroTag,
  });

  @override
  State<SingleItemScreen> createState() => _SingleItemScreenState();
}

class _SingleItemScreenState extends State<SingleItemScreen> {
  late bool isStaff;
  List<String> titles = [
    "VEHICLE NO",
    "CHASSIS NO",
    "MODEL",
    "ENGINE NO",
    "CUSTOMER NAME",
  ].map((e) => e.toLowerCase()).toList();

  @override
  void initState() {
    isStaff = context.read<HomeCubit>().state.user!.isStaff;

    super.initState();
  }

  bool _isReporting = false;

  @override
  Widget build(BuildContext context) {
    Map<String, String> data = {};
    if (isStaff) {
      data = widget.details;
    } else {
      data = titles.fold<Map<String, String>>(data, (previousValue, element) {
        data[element] = widget.details[element] ??
            widget.details[element.replaceAll(" ", "")] ??
            "";
        if (element == "model" && data[element]!.isEmpty) {
          data[element] = data["make"] ?? "";
        }
        return data;
      });
      if (data["VEHICLE NO".toLowerCase()] == "") {
        data["VEHICLE NO".toLowerCase()] = widget.details["vehicleno"] ??
            widget.details["vehicle no"] ??
            widget.details["vehicalno"] ??
            widget.details["vehical no"] ??
            "";
      }
    }
    List<MapEntry<String, dynamic>> agencyDetails = [];
    agencyDetails = context
        .read<HomeCubit>()
        .state
        .data
        .agencyDetails
        .toDisplayMap()
        .entries
        .toList();
    data.remove("");
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Card(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: data.entries
                            .map((e) => Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          Utils.formatString(e.key),
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
                                            e.value.toString().toUpperCase(),
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
                      const Divider(),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Text(
                              "AGENCY ",
                              style: GoogleFonts.poppins(color: Colors.black87),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: agencyDetails
                            .map((e) => Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          Utils.formatString(e.key),
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
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              if (!_isReporting)
                if (context.read<HomeCubit>().state.user!.isStaff)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: {
                      "Confirm": Icons.done_outline_rounded,
                      "Whatsapp": Icons.message,
                      "Ok Repo": Icons.chair,
                      "Cancel": Icons.cancel,
                      "Copy": Icons.copy
                    }
                        .entries
                        .map((e) => InkWell(
                              onTap: () {
                                takeActionForSpecificButton(
                                  e.key,
                                  data,
                                );
                              },
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(e.value),
                                  Text(e.key),
                                ],
                              ),
                            ))
                        .toList(),
                  )
                else
                  ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _isReporting = true;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 40)),
                      child: Text(
                        "Report",
                        style: GoogleFonts.poppins(color: Colors.white),
                      )),
              if (_isReporting) ...[
                ReportInputs(
                  data,
                  'Please confirm this vehicle.',
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _isReporting = false;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 40)),
                  child: Text(
                    "Cancel",
                    style: GoogleFonts.poppins(color: Colors.white),
                  ),
                )
              ]
            ],
          ),
        ),
      )),
    );
  }

  void takeActionForSpecificButton(
    String button,
    Map<String, String> details,
  ) {
    switch (button) {
      case "Confirm":
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (c) => ReportScreen(
              title: button,
              details: details,
            ),
          ),
        );
        break;
      case "Whatsapp":
        showModalBottomSheet(
          context: context,
          builder: (c) {
            String agentName = context.read<HomeCubit>().state.user!.agent_name;
            String agencyName = context
                    .read<HomeCubit>()
                    .state
                    .data
                    .agencyDetails
                    ?.agencyName ??
                "";
            String phone = context.read<HomeCubit>().state.user!.number;
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  onTap: () {
                    Utils.sendWhatsapp(
                      agencyName,
                      details,
                      'Please confirm this vehicle.',
                      agentName,
                      phone,
                      context.read<HomeCubit>().state.user!.isStaff,
                      '',
                      null,
                      null,
                    );
                  },
                  child: ListTile(
                    leading: const Icon(FontAwesomeIcons.buildingColumns),
                    title: Text(
                      'Bank for confirmation',
                      style: GoogleFonts.poppins(),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Utils.sendWhatsapp(
                      agencyName,
                      details,
                      'Ok for confirmation',
                      agentName,
                      phone,
                      context.read<HomeCubit>().state.user!.isStaff,
                      '',
                      null,
                      null,
                    );
                  },
                  child: ListTile(
                    leading: const Icon(Icons.done),
                    title: Text(
                      'Ok for Report',
                      style: GoogleFonts.poppins(),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Utils.sendWhatsapp(
                      agencyName,
                      details,
                      'Not confirmed',
                      agentName,
                      phone,
                      context.read<HomeCubit>().state.user!.isStaff,
                      '',
                      null,
                      null,
                    );
                  },
                  child: ListTile(
                    leading: const Icon(Icons.cancel),
                    title: Text(
                      'Not confirmed',
                      style: GoogleFonts.poppins(),
                    ),
                  ),
                ),
              ],
            );
          },
        );
        break;
      case "Ok Repo":
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (c) => ReportScreen(
              title: button,
              details: details,
            ),
          ),
        );
        break;
      case "Cancel":
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (c) => ReportScreen(
              title: button,
              details: details,
            ),
          ),
        );
        break;
      case "Copy":
        copyToClipboard(Utils.formatMap(
          details,
          context.read<HomeCubit>().state.user!.isStaff,
        ));
        showSnackbar('Copied!', context, Icons.copy);
        break;
      default:
    }
  }
}

void copyToClipboard(String text) {
  Clipboard.setData(ClipboardData(text: text));
}
