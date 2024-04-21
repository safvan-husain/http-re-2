import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recovery_app/resources/color_manager.dart';
import 'package:recovery_app/screens/HomePage/cubit/home_cubit.dart';

class DownloadUI extends StatelessWidget {
  final HomeState state;
  const DownloadUI(
    this.state, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "Please keep your app open, it may take a while.",
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 10),
        StreamBuilder(
            stream: state.streamController.stream,
            builder: (context, snp) {
              return Center(
                  child: Container(
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color:
                          Colors.grey.withOpacity(0.5), // Color of the shadow
                      spreadRadius: 2, // Spread radius
                      blurRadius: 4, // Blur radius
                      offset: const Offset(0, 3), // Shadow offset
                    ),
                  ],
                ),
                width: MediaQuery.of(context).size.width - 50,
                height: 80,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                            snp.data == null
                                ? "Please Wait..."
                                : "${(snp.data!.values.toList()[0])}%  ${snp.data!.keys.toList()[0]}",
                            style: GoogleFonts.poppins(
                                color: ColorManager.primary,
                                fontWeight: FontWeight.bold)),
                        if (state.estimatedTime.isNotEmpty)
                          Text(' est : ${state.estimatedTime}',
                              maxLines: 1,
                              overflow: TextOverflow.fade,
                              style: GoogleFonts.poppins(
                                  color: ColorManager.primary,
                                  fontWeight: FontWeight.bold))
                      ],
                    ),
                    const SizedBox(height: 10),
                    LinearProgressIndicator(
                      value: snp.data == null
                          ? null
                          : (snp.data!.values.toList()[0] / 100),
                      borderRadius: BorderRadius.circular(10),
                      minHeight: 10,
                      color: ColorManager.primary,
                      backgroundColor: const Color.fromARGB(
                        220,
                        169,
                        211,
                        255,
                      ),
                    ),
                  ],
                ),
              ));
            }),
      ].reversed.toList(),
    );
  }
}
