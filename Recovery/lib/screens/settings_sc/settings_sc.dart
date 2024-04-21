import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recovery_app/screens/HomePage/cubit/home_cubit.dart';

import '../../resources/color_manager.dart';

class SettingsScView extends StatefulWidget {
  const SettingsScView({super.key});

  @override
  State<SettingsScView> createState() => _SettingsScViewState();
}

class _SettingsScViewState extends State<SettingsScView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 242, 244, 255),
      appBar: AppBar(
        // leading: const BackButton(),
        centerTitle: true,
        backgroundColor: ColorManager.primary,
        systemOverlayStyle: SystemUiOverlayStyle(
          systemNavigationBarColor: ColorManager.primary,
          statusBarColor: ColorManager.primary,
          statusBarBrightness: Brightness.light,
          statusBarIconBrightness: Brightness.light,
        ),
        title: const Text(
          "Settings",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.w500, fontSize: 25),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(20),
          child: Column(
            children: [
              _getRowUOS(
                  value: context
                      .watch<HomeCubit>()
                      .state
                      .searchSettings
                      .isTwoColumnSearch,
                  ctx: context),
              Divider(
                color: Colors.grey[300],
              ),
              InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          backgroundColor:
                              const Color.fromARGB(255, 242, 244, 255),
                          title: const Text('Confirm Delete'),
                          content:
                              const Text('Are you sure you want to delete?'),
                          actions: <Widget>[
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white),
                              child: const Text('Cancel'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white),
                              child: Text(
                                'Delete',
                                style: GoogleFonts.poppins(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold),
                              ),
                              onPressed: () {
                                context.read<HomeCubit>().deleteAllData();
                                // Perform delete operation here
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: _getRow(title: "Delete all data")),
              Divider(
                color: Colors.grey[300],
              ),
              _getRow(
                title: "Terms and Conditions",
                icon: Icons.arrow_forward_ios,
              ),
              InkWell(
                onTap: () {},
                child: _getRow(
                  title: "Privacy Policy",
                  icon: Icons.arrow_forward_ios,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getRowUOS({required bool value, required BuildContext ctx}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Two column Search",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          CupertinoSwitch(
            // thumb color (round icon)
            activeColor: ColorManager.primary,
            thumbColor: Colors.white,
            trackColor: value == true ? ColorManager.primary : Colors.grey,
            value: value,
            // changes the state of the switch
            onChanged: ctx.read<HomeCubit>().updateIsColumSearch,
          ),
        ],
      ),
    );
  }

  Widget _getRow({required String title, IconData? icon}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold),
          ),
          Icon(
            icon ?? Icons.delete,
            color: icon == null ? Colors.red : Colors.black,
          )
        ],
      ),
    );
  }
}
