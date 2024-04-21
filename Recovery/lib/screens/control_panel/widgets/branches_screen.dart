import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recovery_app/resources/color_manager.dart';
import 'package:recovery_app/screens/HomePage/cubit/home_cubit.dart';
import 'package:recovery_app/services/control_panel_services.dart';

class BranchesScreen extends StatefulWidget {
  final List<String> branches;
  const BranchesScreen(this.branches, {super.key});

  @override
  State<BranchesScreen> createState() => _BranchesScreenState();
}

class _BranchesScreenState extends State<BranchesScreen> {
  @override
  void initState() {
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
          "Branches",
          style: GoogleFonts.poppins(
              color: Colors.white, fontWeight: FontWeight.w500, fontSize: 25),
        ),
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 8.0,
          vertical: 20,
        ),
        child: widget.branches.isEmpty
            ? const Center(
                child: Text("No branches"),
              )
            : ListView.separated(
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {},
                    child: ListTile(
                      leading: const Icon(FontAwesomeIcons.buildingColumns),
                      title: Text(
                        widget.branches[index],
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return Divider(
                    color: Colors.grey[300],
                  );
                },
                itemCount: widget.branches.length,
              ),
      )),
    );
  }
}
