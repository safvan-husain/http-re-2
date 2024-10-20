import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recovery_app/bottom_navigation/bottom_navigation_page.dart';
import 'package:recovery_app/screens/HomePage/cubit/home_cubit.dart';
import 'package:recovery_app/screens/authentication/device_verify_screen.dart';
import 'package:recovery_app/screens/authentication/login.dart';
import 'package:recovery_app/storage/user_storage.dart';

class InitialScreen extends StatefulWidget {
  const InitialScreen({super.key});

  @override
  State<InitialScreen> createState() => _InitialScreenState();
}

class _InitialScreenState extends State<InitialScreen> {
  @override
  void initState() {
    super.initState();
    checkUserExists();
  }

  void checkUserExists() async {
    var user = await Storage.getUser();

    if (user != null) {
      if (await user.verifyDevice()) {
        if (context.mounted) {
          context.read<HomeCubit>().setUser(user);
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (c) => const BottomNavigation()),
            (p) => false,
          );
        }
      } else {
        if (context.mounted) {
          context.read<HomeCubit>().setUser(user);
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (c) => const DeviceVerifyScreen()),
            (p) => false,
          );
        }
      }
    } else {
      if (context.mounted) {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (c) => const Login()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 242, 244, 255),
      body: Center(
        child: Image.asset('assets/icons/logo.png'),
      ),
    );
  }
}
