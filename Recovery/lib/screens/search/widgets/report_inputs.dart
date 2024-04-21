import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recovery_app/resources/assets_manager.dart';
import 'package:recovery_app/resources/color_manager.dart';
import 'package:recovery_app/screens/HomePage/cubit/home_cubit.dart';
import 'package:recovery_app/services/loation.dart';
import 'package:recovery_app/services/utils.dart';

class ReportInputs extends StatefulWidget {
  final Map<String, String> details;
  final String status;
  const ReportInputs(
    this.details,
    this.status, {
    super.key,
  });

  @override
  State<ReportInputs> createState() => _ReportInputsState();
}

class _ReportInputsState extends State<ReportInputs> {
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _loadController = TextEditingController();
  String? locationUrl;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 8.0,
          vertical: 10,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Vehichel Address',
                style: GoogleFonts.poppins(),
              ),
            ),
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              // margin: const EdgeInsets.symmetric(
              //     horizontal: 20, vertical: 10),
              width: MediaQuery.of(context).size.width,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2), // Color of the shadow
                    spreadRadius: 2, // Spread radius
                    blurRadius: 4, // Blur radius
                    offset: const Offset(0, 3), // Shadow offset
                  ),
                ],
              ),
              child: TextField(
                controller: _addressController,
                // maxLength: 1000,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'street, area, locality...',
                  hintStyle: GoogleFonts.poppins(fontSize: 13),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Carries Goods',
                style: GoogleFonts.poppins(),
              ),
            ),
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              // margin: const EdgeInsets.symmetric(
              //     horizontal: 20, vertical: 10),
              width: MediaQuery.of(context).size.width,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2), // Color of the shadow
                    spreadRadius: 2, // Spread radius
                    blurRadius: 4, // Blur radius
                    offset: const Offset(0, 3), // Shadow offset
                  ),
                ],
              ),
              child: TextField(
                controller: _loadController,
                // maxLength: 1000,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Carries goods, load...',
                  hintStyle: GoogleFonts.poppins(fontSize: 13),
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width - 70,
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        if (locationUrl != null) {
                          locationUrl = null;
                          if (context.mounted) {
                            Utils.toastBar("Removed Currentl Location")
                                .show(context);
                          }
                        } else {
                          locationUrl = await LocationService.share();
                          if (context.mounted) {
                            Utils.toastBar("Added Currentl Location",
                                    Colors.greenAccent)
                                .show(context);
                          }
                        }

                        setState(() {});
                      },
                      style: locationUrl == null
                          ? ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: BorderSide(
                                    color: ColorManager.primary, width: 2),
                              ),
                              backgroundColor: ColorManager.white,
                            )
                          : ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  side: BorderSide(
                                      color: ColorManager.primary, width: 2)),
                              backgroundColor: ColorManager.primary,
                              alignment: Alignment.center),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "${locationUrl == null ? "Add" : "Remove"} Location ",
                            style: TextStyle(
                                color: locationUrl == null
                                    ? Colors.blue
                                    : Colors.white),
                            textAlign: TextAlign.center,
                          ),
                          const Flexible(
                            child: Icon(
                              FontAwesomeIcons.locationPin,
                              color: Colors.greenAccent,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                        onPressed: () {
                          if (_addressController.text.isNotEmpty) {
                            _showShareDialog();
                          } else {
                            Utils.toastBar("Address is Required").show(context);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: BorderSide(
                                  color: ColorManager.primary, width: 2),
                            ),
                            backgroundColor: ColorManager.white,
                            alignment: Alignment.center),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              "Send  ",
                              style: TextStyle(color: ColorManager.primary),
                              textAlign: TextAlign.center,
                            ),
                            const Icon(FontAwesomeIcons.share)
                          ],
                        )),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void _showShareDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Share details ', //of ${widget.heroTag}
                  style: GoogleFonts.russoOne(),
                ),
              ),
              ElevatedButton.icon(
                icon: SvgPicture.asset(IconAssets.whatsapp_ic),
                style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 40)),
                label: Text(
                  'Share on WhatsApp',
                  style: GoogleFonts.poppins(color: Colors.white),
                ),
                onPressed: () {
                  Utils.sendWhatsapp(
                    context
                            .read<HomeCubit>()
                            .state
                            .data
                            .agencyDetails
                            ?.agencyName ??
                        "",
                    widget.details,
                    widget.status,
                    context.read<HomeCubit>().state.user!.agent_name,
                    context.read<HomeCubit>().state.user!.number,
                    context.read<HomeCubit>().state.user!.isStaff,
                    _addressController.text,
                    locationUrl,
                    _loadController.text,
                  );
                },
              ),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 40)),
                label: Text(
                  'Share on Message App',
                  style: GoogleFonts.poppins(color: Colors.white),
                ),
                icon: Image.asset(IconAssets.sms_ic),
                onPressed: () {
                  Utils.sendSMS(
                    'Respected Sir,  \n${Utils.formatMap(
                      widget.details,
                      context.read<HomeCubit>().state.user!.isStaff,
                    )}  ${locationUrl != null ? "\nlocation : $locationUrl" : ""} \naddress : ${_addressController.text} \ncarries Goods : ${_loadController.text} \n\nstatus : ${widget.status} \n${context.read<HomeCubit>().state.user!.agent_name} - +91${context.read<HomeCubit>().state.user!.number} \nAgency: ${context.read<HomeCubit>().state.data.agencyDetails?.agencyName ?? ""}',
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
