import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recovery_app/resources/color_manager.dart';
import 'package:recovery_app/screens/HomePage/cubit/home_cubit.dart';
import 'package:recovery_app/screens/control_panel/widgets/branches_screen.dart';
import 'package:recovery_app/services/control_panel_services.dart';

class FinancesScreen extends StatefulWidget {
  const FinancesScreen({super.key});

  @override
  State<FinancesScreen> createState() => _FinancesScreenState();
}

class _FinancesScreenState extends State<FinancesScreen> {
  late Future<Map<String, List<String>>> futureBanks;
  @override
  void initState() {
    futureBanks = ControlPanelService.getAllFinances(
        context.read<HomeCubit>().state.user!.agencyId);
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
          "Finances",
          style: GoogleFonts.poppins(
              color: Colors.white, fontWeight: FontWeight.w500, fontSize: 25),
        ),
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 20),
        child: FutureBuilder(
          future: futureBanks,
          builder: (context, snp) {
            if (snp.connectionState != ConnectionState.done || !snp.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            List<MapEntry<String, List<String>>> banks =
                snp.data!.entries.toList();
            return ListView.separated(
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (c) => BranchesScreen(
                          banks[index].value,
                        ),
                      ),
                    );
                  },
                  child: ListTile(
                    leading: const Icon(FontAwesomeIcons.buildingColumns),
                    title: Text(
                      banks[index].key,
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return Divider(
                  color: Colors.grey[300],
                );
              },
              itemCount: banks.length,
            );
          },
        ),
      )),
    );
  }
}
