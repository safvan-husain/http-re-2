// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// {@template hero_dialog_route}
/// Custom [PageRoute] that creates an overlay dialog (popup effect).
///
/// Best used with a [Hero] animation.
/// {@endtemplate}
class SuccessPopUp<T> extends PageRoute<T> {
  /// {@macro hero_dialog_route}
  SuccessPopUp()
      : super(
          // settings: settings,
          fullscreenDialog: false,
        );

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => true;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);

  @override
  bool get maintainState => true;

  @override
  Color get barrierColor => Colors.black54;

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return child;
  }

  GlobalKey _containerKey = GlobalKey();
  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    Timer(const Duration(seconds: 2), () {
      if (Navigator.canPop(context)) {
        Navigator.of(context).pop();
      }
    });
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Padding(
          key: _containerKey,
          padding: const EdgeInsets.all(32.0),
          child: Material(
            type: MaterialType.transparency,
            elevation: 2,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
            child: Container(
              padding: const EdgeInsets.all(10),
              width: MediaQuery.of(context).size.width * 0.70,
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: const BorderRadius.all(Radius.circular(15)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.green,
                      child: Icon(
                        Icons.done,
                        color: Colors.white,
                      )),
                  const SizedBox(height: 10),
                  Text(
                    "Subscription added",
                    style: GoogleFonts.poppins(),
                  ),
                  Divider(
                    color: Colors.black,
                    thickness: 0.5,
                  ),
                  Text(
                    "Done",
                    style: GoogleFonts.poppins(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  String get barrierLabel => 'Popup dialog open';
}
