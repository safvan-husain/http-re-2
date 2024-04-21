import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:recovery_app/resources/color_manager.dart';
import 'package:recovery_app/screens/HomePage/cubit/home_cubit.dart';
import 'package:recovery_app/screens/HomePage/home_page.dart';
import 'package:recovery_app/screens/control_panel/control_panel.dart';
import 'package:recovery_app/screens/profile_sc/profile_sc.dart';
import 'package:recovery_app/screens/settings_sc/settings_sc.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({super.key});

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int _currentPageIndex = 0;
  Widget home = const HomePage();
  List<Widget> pages = [];
  Map<String, IconData> navBarItems = {
    "Home": FontAwesomeIcons.house,
    "Settings": Icons.settings,
    "Account": FontAwesomeIcons.user,
  };
  void initializePages() {
    if (context.read<HomeCubit>().state.user!.isStaff) {
      navBarItems = {
        "Home": FontAwesomeIcons.house,
        "Settings": Icons.settings,
        "Controll": FontAwesomeIcons.shield,
        "Account": FontAwesomeIcons.user,
      };
      pages = [
        home,
        const SettingsScView(),
        const ControlPanelScreen(),
        const ProfileScView(),
      ];
    } else {
      pages = [
        home,
        const SettingsScView(),
        const ProfileScView(),
      ];
    }
    setState(() {});
  }

  @override
  void initState() {
    initializePages();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 242, 244, 255),
      // body: pages.elementAt(_currentPageIndex),
      body: IndexedStack(
        index: _currentPageIndex,
        children: pages,
      ),
      bottomNavigationBar: Container(
        height: 60,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5), // Color of the shadow
              spreadRadius: 3, // Spread radius
              blurRadius: 7, // Blur radius
              offset: const Offset(0, 3), // Shadow offset
            ),
          ],
        ),
        alignment: Alignment.center,
        margin: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: navBarItems.entries
              .toList()
              .asMap()
              .map((index, e) => MapEntry(
                    index,
                    InkWell(
                      onTap: () {
                        setState(() {
                          _currentPageIndex = index;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: index == _currentPageIndex
                              ? ColorManager.primary
                              : Colors.white,
                        ),
                        padding: const EdgeInsets.all(10),
                        child: Icon(
                          e.value,
                          color: index == _currentPageIndex
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ),
                  ))
              .values
              .toList(),
        ),
      ),
    );
  }
}
