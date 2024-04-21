// ignore_for_file: prefer_const_constructors

import 'dart:developer';
import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recovery_app/screens/HomePage/cubit/home_cubit.dart';
import 'package:recovery_app/screens/HomePage/notification_screen.dart';
import 'package:recovery_app/screens/HomePage/widgets/download_ui.dart';
import 'package:recovery_app/screens/search/search_screen.dart';
import 'package:recovery_app/services/csv_file_service.dart';
import 'package:recovery_app/services/home_service.dart';
import 'package:recovery_app/services/agency_details_services.dart';
import 'package:recovery_app/services/utils.dart';
import 'package:recovery_app/storage/user_storage.dart';

import '../../resources/color_manager.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentCarouselIndex = 0;
  final ScrollController _scrollController = ScrollController();
  bool _isDownloaded = false;

  @override
  void initState() {
    context.read<HomeCubit>().homeInitialization(context);
    getFileCount();

    super.initState();
  }

  void getFileCount() async {
    List<File> files = await CsvFileServices.getExcelFiles();
    setState(() {
      _isDownloaded = files.isNotEmpty;
    });
  }

  bool isHaveSubscription = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 242, 244, 255),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              SizedBox(height: 10),
              _buildSearchBar(context, MediaQuery.of(context).size.width),
              SizedBox(height: 20),
              _getCarousel(),
              SizedBox(height: 20),
              BlocConsumer<HomeCubit, HomeState>(
                listener: (context, state) {
                  getFileCount();
                  isHaveSubscription =
                      state.user!.subscriptionDetails.remainingDays != 0;
                },
                builder: (context, state) {
                  return ConstrainedBox(
                    constraints: BoxConstraints(minHeight: 200),
                    child: Center(
                      // child: true
                      child: state.changeType == ChangeType.loading
                          // child: true
                          ? DownloadUI(state)
                          : Column(
                              children: [
                                SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  height: 80,
                                  child: Row(
                                    children: [
                                      InkWell(
                                        onTap: () async {
                                          if (await Utils.isConnected()) {
                                            if (context.mounted) {
                                              await context
                                                  .read<HomeCubit>()
                                                  .downloadData();
                                            }
                                          } else {
                                            if (context.mounted) {
                                              Utils.toastBar(
                                                      'No internet connection')
                                                  .show(context);
                                            }
                                          }
                                        },
                                        child: Container(
                                          margin: EdgeInsets.only(right: 10),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey.withOpacity(
                                                    0.5), // Color of the shadow
                                                spreadRadius:
                                                    2, // Spread radius
                                                blurRadius: 4, // Blur radius
                                                offset: const Offset(
                                                    0, 3), // Shadow offset
                                              ),
                                            ],
                                          ),
                                          height: 80,
                                          alignment: Alignment.center,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(FontAwesomeIcons.download),
                                              Text(
                                                _isDownloaded
                                                    ? "Update Data"
                                                    : "Download",
                                                textAlign: TextAlign.center,
                                                style: GoogleFonts.poppins(
                                                    color: Colors.black),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: 80,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey.withOpacity(
                                                  0.5), // Color of the shadow
                                              spreadRadius: 2, // Spread radius
                                              blurRadius: 4, // Blur radius
                                              offset: const Offset(
                                                  0, 3), // Shadow offset
                                            ),
                                          ],
                                        ),
                                        alignment: Alignment.center,
                                        margin: EdgeInsets.only(left: 10),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Text(
                                              state.user!.subscriptionDetails
                                                  .remainingDays
                                                  .toString(),
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.poppins(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16),
                                            ),
                                            Text(
                                              "Days Remaining",
                                              style: GoogleFonts.poppins(),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ].map((e) => Expanded(child: e)).toList(),
                                  ),
                                ),
                                Row(
                                  children: [
                                    Container(
                                      // margin: EdgeInsets.only(
                                      //     right: state.user!.isStaff ? 10 : 0.0,
                                      //     top: 5),
                                      height: 80,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(5),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(
                                                0.5), // Color of the shadow
                                            spreadRadius: 2, // Spread radius
                                            blurRadius: 4, // Blur radius
                                            offset: const Offset(
                                                0, 3), // Shadow offset
                                          ),
                                        ],
                                      ),
                                      alignment: Alignment.center,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text(
                                            '${context.watch<HomeCubit>().state.entryCount}',
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.poppins(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16),
                                          ),
                                          Text(
                                            'Offline Records',
                                            style: GoogleFonts.poppins(),
                                          )
                                        ],
                                      ),
                                    ),
                                    // if (state.user!.isStaff)
                                    //   Container(
                                    //       height: 80,
                                    //       margin:
                                    //           EdgeInsets.only(left: 10, top: 5),
                                    //       decoration: BoxDecoration(
                                    //         color: Colors.white,
                                    //         borderRadius:
                                    //             BorderRadius.circular(5),
                                    //         boxShadow: [
                                    //           BoxShadow(
                                    //             color: Colors.grey.withOpacity(
                                    //                 0.5), // Color of the shadow
                                    //             spreadRadius:
                                    //                 2, // Spread radius
                                    //             blurRadius: 4, // Blur radius
                                    //             offset: const Offset(
                                    //                 0, 3), // Shadow offset
                                    //           ),
                                    //         ],
                                    //       ),
                                    //       alignment: Alignment.center,
                                    //       child: Column(
                                    //         mainAxisAlignment:
                                    //             MainAxisAlignment.spaceEvenly,
                                    //         children: [
                                    //           Icon(FontAwesomeIcons.car),
                                    //           Text(
                                    //             "Vehicle Confirmed",
                                    //             style: GoogleFonts.poppins(),
                                    //           ),
                                    //         ],
                                    //       )),
                                  ].map((e) => Expanded(child: e)).toList(),
                                ),
                              ]
                                  .map((e) => Padding(
                                        padding: const EdgeInsets.all(5),
                                        child: e,
                                      ))
                                  .toList(),
                            ),
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context, double scWidth) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              // width: MediaQuery.of(context).size.width - 100,
              child: GestureDetector(
                onTap: () {
                  if (isHaveSubscription) {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (c) => SearchScreen1()),
                    );
                  } else {
                    DelightToastBar(
                      autoDismiss: true,
                      snackbarDuration: Duration(seconds: 3),
                      builder: (context) => const ToastCard(
                        color: Colors.red,
                        leading: Icon(
                          Icons.flutter_dash,
                          size: 28,
                          color: Colors.red,
                        ),
                        title: Text(
                          "You don't have a subscription",
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ).show(context);
                  }
                },
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  height: 60,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const CircleAvatar(child: Icon(Icons.search)),
                      const SizedBox(
                        width: 20,
                      ),
                      Text(
                        'Search here',
                        style: GoogleFonts.poppins(
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () async {
              //FIXME:disable navigation for debugging.
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (c) => NotificationScreen(),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Stack(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(
                      FontAwesomeIcons.bell,
                      color: Colors.blue,
                    ),
                  ),
                  if (context.read<HomeCubit>().state.data.isThereNewData)
                    Positioned(
                      top: 0,
                      right: 0,
                      child: CircleAvatar(
                        radius: 5,
                        backgroundColor: Colors.red,
                      ),
                    )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _getCarousel() {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return Container(
          height: 200,
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5), // Color of the shadow
                spreadRadius: 2, // Spread radius
                blurRadius: 4, // Blur radius
                offset: const Offset(0, 3), // Shadow offset
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Column(
            children: [
              Expanded(
                flex: 2,
                child: Image.asset(
                  'assets/icons/logo.png',
                  fit: BoxFit.fitHeight,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    state.data.agencyDetails.agencyName,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
