import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:recovery_app/models/user_model.dart';
import 'package:recovery_app/resources/color_manager.dart';
import 'package:recovery_app/screens/HomePage/cubit/home_cubit.dart';

import 'package:flutter/rendering.dart';
import 'package:recovery_app/services/utils.dart';

class IdCardScreen extends StatefulWidget {
  const IdCardScreen({super.key});

  @override
  State<IdCardScreen> createState() => _IdCardScreenState();
}

class _IdCardScreenState extends State<IdCardScreen> {
  GlobalKey globalKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    UserModel user = context.read<HomeCubit>().state.user!;
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 242, 244, 255),
      appBar: AppBar(
        leading: const BackButton(),
        centerTitle: true,
        backgroundColor: ColorManager.primary,
        systemOverlayStyle: SystemUiOverlayStyle(
          systemNavigationBarColor: ColorManager.primary,
          statusBarColor: ColorManager.primary,
          statusBarBrightness: Brightness.light,
          statusBarIconBrightness: Brightness.light,
        ),
        title: const Text(
          "ID card",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.w500, fontSize: 25),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                Utils.saveIdCard(globalKey, context);
              },
              child: const CircleAvatar(
                backgroundColor: Colors.greenAccent,
                child: Icon(
                  Icons.download,
                  color: Colors.black,
                ),
              ),
            ),
          )
        ],
      ),
      body: RepaintBoundary(
        key: globalKey,
        child: Container(
          // height: MediaQuery.of(context).size.width * 1.2,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: Image.asset('assets/images/id-card.jpg').image,
              fit: BoxFit.cover,
            ),
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
          margin: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 20,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                children: [
                  Image.asset(
                    'assets/icons/logo.jpeg',
                    height: 60,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Flexible(
                    child: Text(
                      user.details!.agencyName,
                      style: GoogleFonts.kanit(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                height: 100,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: Image.asset(
                      'assets/icons/user.png',
                      scale: 2,
                      fit: BoxFit.fitHeight,
                    ).image,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Column(
                children: {
                  "Name": user.agent_name,
                  "EmployeeId": user.agencyId,
                  "From Date": formatDate(user.subscriptionDetails!.start),
                  "End Date": formatDate(user.subscriptionDetails!.end),
                }
                    .entries
                    .map(
                      (e) => Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20.0,
                          vertical: 10,
                        ),
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
                              style: GoogleFonts.poppins(),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                e.value.toString(),
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Divider(
                  color: Colors.grey,
                ),
              ),
              Text(
                user.details!.contact,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

String formatDate(DateTime dateTime) {
  final String formattedDate =
      "${dateTime.year}-${dateTime.month}-${dateTime.day}";
  return formattedDate;
}
