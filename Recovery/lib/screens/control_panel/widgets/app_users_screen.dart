import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recovery_app/resources/color_manager.dart';
import 'package:recovery_app/screens/HomePage/cubit/home_cubit.dart';
import 'package:recovery_app/screens/control_panel/widgets/user_view.dart';
import 'package:recovery_app/services/control_panel_services.dart';

class AppUsersScreen extends StatefulWidget {
  const AppUsersScreen({super.key});

  @override
  State<AppUsersScreen> createState() => _AppUsersScreenState();
}

class _AppUsersScreenState extends State<AppUsersScreen> {
  late Future<List<Agent>> futureAgents;

  @override
  Widget build(BuildContext context) {
    futureAgents = ControlPanelService.getAllUsers(
        context.read<HomeCubit>().state.user!.agencyId);
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
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 20),
        child: FutureBuilder(
          future: futureAgents,
          builder: (context, snp) {
            if (snp.connectionState != ConnectionState.done || !snp.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            List<Agent> agencts = snp.data!;
            agencts = agencts
                .where((e) =>
                    e.id.toString() !=
                    context.read<HomeCubit>().state.user!.agentId)
                .toList();
            return ListView.separated(
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (c) => UserView(
                          agent: agencts[index],
                          onChange: () {
                            setState(() {});
                          },
                        ),
                      ),
                    );
                  },
                  child: ListTile(
                    leading: Image.asset('assets/icons/user.png'),
                    title: Text(
                      agencts[index].agentName,
                    ),
                    subtitle: Text(agencts[index].email),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (agencts[index].staff) ...[
                          const Icon(FontAwesomeIcons.shield),
                          const SizedBox(width: 10)
                        ],
                        if (agencts[index].status) const Icon(Icons.done),
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return Divider(
                  color: Colors.grey[300],
                );
              },
              itemCount: agencts.length,
            );
          },
        ),
      )),
    );
  }
}
