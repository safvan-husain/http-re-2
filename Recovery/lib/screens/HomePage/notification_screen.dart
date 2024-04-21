import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recovery_app/resources/color_manager.dart';
import 'package:recovery_app/screens/HomePage/cubit/home_cubit.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isThereNew = context.read<HomeCubit>().state.data.isThereNewData;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 242, 244, 255),
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarBrightness: Brightness.light,
          statusBarIconBrightness: Brightness.dark,
        ),
        elevation: 1,
        leading: const BackButton(),
        backgroundColor: ColorManager.primary,
        title: Text(
          "Notifications",
          style: GoogleFonts.poppins(
            color: Colors.white,
          ),
        ),
      ),
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            context.read<HomeCubit>().isDeviceChangedOnServer();
          },
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: ListView.builder(
              itemCount: isThereNew ? 1 : 0,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.all(10),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ListTile(
                    // contentPadding: EdgeInsets.all(10),
                    leading: Icon(FontAwesomeIcons.solidBell),
                    title: Text(
                      "New Data found on database",
                      style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Text(
                      "please update to get latest Data",
                      style: GoogleFonts.poppins(color: Colors.black),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
