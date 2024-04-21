import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recovery_app/screens/HomePage/cubit/home_cubit.dart';
import 'package:recovery_app/screens/control_panel/widgets/app_users_screen.dart';
import 'package:recovery_app/screens/control_panel/widgets/blocklist_screen.dart';
import 'package:recovery_app/screens/control_panel/widgets/controll_panel_verification.dart';
import 'package:recovery_app/screens/control_panel/widgets/finances_screen.dart';

import '../../resources/color_manager.dart';

class ControlPanelScreen extends StatefulWidget {
  const ControlPanelScreen({super.key});

  @override
  State<ControlPanelScreen> createState() => _ControlPanelScreenState();
}

class _ControlPanelScreenState extends State<ControlPanelScreen> {
  bool isVerified = false;
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
        title: Text(
          "Control Panel",
          style: GoogleFonts.poppins(
              color: Colors.white, fontWeight: FontWeight.w500, fontSize: 25),
        ),
      ),
      body: !isVerified
          ? Center(
              child: ControlPanelVerification(
                onVerified: () {
                  setState(() {
                    isVerified = true;
                  });
                },
              ),
            )
          : SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.all(20),
                child: Column(
                  children: insertBetweenAll(
                    [
                      _buildListTile(
                        title: "App Users",
                        icon: FontAwesomeIcons.users,
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (c) => const AppUsersScreen()),
                          );
                        },
                      ),
                      _buildListTile(
                        title: "Finance",
                        icon: FontAwesomeIcons.buildingColumns,
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (c) => const FinancesScreen()),
                          );
                        },
                      ),
                      // _buildListTile(
                      //   title: "Blacklist",
                      //   icon: FontAwesomeIcons.ban,
                      //   onTap: () {
                      //     Navigator.of(context).push(
                      //       MaterialPageRoute(
                      //         builder: (c) => const BlockListScreen(),
                      //       ),
                      //     );
                      //   },
                      // ),
                    ],
                    Divider(
                      color: Colors.grey[300],
                    ),
                  ),
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

  Widget _buildListTile({
    required String title,
    required IconData icon,
    required void Function() onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Icon(icon),
            ),
            Text(
              title,
              style: const TextStyle(
                  color: Colors.black, fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.blue,
            )
          ],
        ),
      ),
    );
  }
}

List<Widget> insertBetweenAll(List<Widget> list, Widget itemToInsert) {
  List<Widget> newList = [];
  for (int i = 0; i < list.length; i++) {
    newList.add(list[i]);
    if (i != list.length - 1) {
      // Don't add itemToInsert after the last item
      newList.add(itemToInsert);
    }
  }
  return newList;
}
