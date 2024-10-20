import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:recovery_app/resources/color_manager.dart';
import 'package:recovery_app/services/control_panel_services.dart';
import 'package:recovery_app/services/utils.dart';

class UserView extends StatefulWidget {
  final Agent agent;
  final void Function() onChange;

  const UserView({
    super.key,
    required this.agent,
    required this.onChange,
  });

  @override
  State<UserView> createState() => _UserViewState();
}

class _UserViewState extends State<UserView> {
  bool isAdmin = false;
  bool isActive = false;
  @override
  void initState() {
    isActive = widget.agent.status;
    isAdmin = widget.agent.staff;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 242, 244, 255),
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
        title: Text(
          "App Users",
          style: GoogleFonts.poppins(
              color: Colors.white, fontWeight: FontWeight.w500, fontSize: 25),
        ),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height - 100),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 120,
                  alignment: Alignment.center,
                  child: Image.asset(
                    'assets/icons/user.png',
                    fit: BoxFit.cover,
                    height: 80,
                  ),
                ),
                const Text('Account Information'),
                _buildTile('Name', widget.agent.agentName),
                _buildTile('Mobile Number', widget.agent.email),
                _buildTile('Address', widget.agent.address),
                // Container(
                //   margin: const EdgeInsets.only(top: 15),
                //   padding: const EdgeInsets.all(15),
                //   decoration: BoxDecoration(
                //     color: Colors.white,
                //     borderRadius: BorderRadius.circular(10),
                //     boxShadow: [
                //       BoxShadow(
                //         color:
                //             Colors.grey.withOpacity(0.5), // Color of the shadow
                //         spreadRadius: 2, // Spread radius
                //         blurRadius: 4, // Blur radius
                //         offset: const Offset(0, 3), // Shadow offset
                //       ),
                //     ],
                //   ),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //     children: [
                //       Text(isActive ? "active" : "inactive"),
                //       Text((isAdmin ?? widget.agent.staff)
                //           ? "Admin"
                //           : "Not admin"),
                Container(
                  margin: const EdgeInsets.only(top: 15),
                  padding: const EdgeInsets.all(15),
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(isActive ? "active" : "inactive"),
                      CupertinoSwitch(
                        // thumb color (round icon)
                        activeColor: ColorManager.primary,
                        thumbColor: Colors.white,
                        trackColor: isActive == true
                            ? ColorManager.primary
                            : Colors.grey,
                        value: isActive,
                        // changes the state of the switch
                        onChanged: (v) {
                          ControlPanelService.switchActiveAccess(
                            v,
                            widget.agent.id,
                          );
                          if (v) {
                            Utils.toastBar(
                              "Activated",
                              Colors.greenAccent,
                            ).show(context);
                          } else {
                            Utils.toastBar(
                              "Inactivated",
                              Colors.redAccent,
                            ).show(context);
                          }
                          setState(() {
                            isActive = v;
                          });
                        },
                      ),
                      Text((isAdmin) ? "Admin" : "Not admin"),
                      CupertinoSwitch(
                        // thumb color (round icon)
                        activeColor: ColorManager.primary,
                        thumbColor: Colors.white,
                        trackColor: isAdmin == true
                            ? ColorManager.primary
                            : Colors.grey,
                        value: isAdmin,
                        // changes the state of the switch
                        onChanged: (v) {
                          ControlPanelService.switchAdminAccess(
                            v,
                            widget.agent.id,
                          );
                          if (v) {
                            Utils.toastBar(
                              "Admin access added",
                              Colors.greenAccent,
                            ).show(context);
                          } else {
                            Utils.toastBar(
                              "Admin access removed",
                              Colors.redAccent,
                            ).show(context);
                          }
                          setState(() {
                            isAdmin = v;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color:
                            Colors.grey.withOpacity(0.2), // Color of the shadow
                        spreadRadius: 1, // Spread radius
                        blurRadius: 4, // Blur radius
                        // offset: const Offset(0, 1), // Shadow offset
                      ),
                    ],
                  ),
                  margin: const EdgeInsets.only(top: 15),
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Subscription details",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Divider(
                        color: Colors.grey,
                      ),
                      Text(
                        "From",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w400,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        widget.agent.start.toString(),
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Divider(
                        color: Colors.grey,
                      ),
                      Text(
                        "To",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w400,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        widget.agent.end.toString(),
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Divider(
                        color: Colors.grey,
                      ),
                    ]
                        .map((e) => Padding(
                              padding: e is Text
                                  ? const EdgeInsets.all(3)
                                  : const EdgeInsets.all(7),
                              child: e,
                            ))
                        .toList(),
                  ),
                )
              ],
            ),
          ),
        ),
      )),
    );
  }

  Widget _buildTile(
    String label,
    String value,
  ) {
    return Container(
      margin: const EdgeInsets.only(top: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5), // Color of the shadow
            spreadRadius: 2, // Spread radius
            blurRadius: 4, // Blur radius
            offset: const Offset(0, 3), // Shadow offset
          ),
        ],
      ),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              color: Colors.black,
              fontWeight: FontWeight.w500,
              fontSize: 15,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.poppins(
              color: Colors.black,
              fontSize: 15,
            ),
          )
        ],
      ),
    );
  }
}
