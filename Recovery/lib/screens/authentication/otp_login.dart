import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recovery_app/bottom_navigation/bottom_navigation_page.dart';
import 'package:recovery_app/models/agency_details.dart';
import 'package:recovery_app/models/user_model.dart';
import 'package:recovery_app/resources/snack_bar.dart';
import 'package:recovery_app/resources/text_fiealds.dart';
import 'package:recovery_app/screens/HomePage/cubit/home_cubit.dart';
import 'package:recovery_app/screens/authentication/device_verify_screen.dart';
import 'package:recovery_app/screens/authentication/login.dart';
import 'package:recovery_app/screens/authentication/sign_up_screen_initial.dart';
import 'package:recovery_app/screens/common_widgets/count_down_ui.dart';
import 'package:recovery_app/services/auth_services.dart';
import 'package:recovery_app/services/home_service.dart';
import 'package:recovery_app/services/sim_services.dart';
import 'package:recovery_app/services/utils.dart';
import 'package:recovery_app/storage/user_storage.dart';

class OtpLogin extends StatefulWidget {
  const OtpLogin({super.key});

  @override
  State<OtpLogin> createState() => _OtpLoginState();
}

class _OtpLoginState extends State<OtpLogin> with TickerProviderStateMixin {
  final TextEditingController _emailController = TextEditingController();
  String? otp;
  UserModel? user;
  var isCountComplete = false;
  AnimationController? _controller;
  int levelClock = 120; // Set your countdown time here

  void _startCountDown() {
    _controller = AnimationController(
        vsync: this, duration: Duration(seconds: levelClock));
    _controller!.forward();
    _controller!.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (mounted) {
          setState(() {
            isCountComplete = true;
          });
        }
      }
    });
  }

  void _restartCountdown() {
    setState(() {
      isCountComplete = false;
    });
    _controller!.reset();
    _controller!.forward();
  }

  @override
  void dispose() {
    if (_controller != null) _controller!.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // _startCountDown();
    super.initState();
  }

  bool isClicked = false;

  var value2 = true;
  @override
  Widget build(BuildContext context) {
    var isOtpGenerated = otp != null;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color.fromARGB(255, 242, 244, 255),
      body: Stack(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                      minHeight: MediaQuery.of(context).size.height - 100),
                  child: Column(
                    mainAxisAlignment: isOtpGenerated
                        ? MainAxisAlignment.start
                        : MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Image.asset(isOtpGenerated
                            ? 'assets/images/otp.png'
                            : 'assets/images/phone-verify.png'),
                      ),
                      if (!isOtpGenerated) ...[
                        Text(
                          'Verify your phone number',
                          style: GoogleFonts.outfit(
                            textStyle: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Color(0xff23202a),
                            ),
                          ),
                        ),
                        Column(
                          children: [
                            buildPhoneInputField(
                              controller: _emailController,
                            ),
                            // Row(
                            //   children: [
                            //     Checkbox(
                            //       value: value2,
                            //       onChanged: (value) {
                            //         setState(() {
                            //           value2 = value ?? false;
                            //         });
                            //       },
                            //     ),
                            //     const Text('Remember'),
                            //   ],
                            // ),
                          ],
                        ),
                        const SizedBox(height: 30),
                        ElevatedButton(
                          onPressed: () async {
                            if (_emailController.text.isEmpty ||
                                _emailController.text.length < 10) {
                              showSnackbar(
                                "Phone number is required",
                                context,
                                Icons.warning,
                              );
                              return;
                            }
                            try {
                              setState(() {
                                isClicked = true;
                              });
                              if (context.mounted) {
                                var result = await AuthServices.verifyPhone(
                                  phone: _emailController.text,
                                  context: context,
                                );
                                setState(() {
                                  isClicked = false;
                                });
                                otp = result.$1;
                                user = result.$2;
                                setState(() {});
                                _startCountDown();
                              }
                            } catch (e) {
                              if (context.mounted) {
                                showSnackbar(
                                  "Authentication failed",
                                  context,
                                  Icons.warning,
                                );
                              }
                              setState(() {
                                isClicked = false;
                              });
                            }
                          },
                          style: ButtonStyle(
                            textStyle: MaterialStateProperty.all<TextStyle>(
                              const TextStyle(color: Colors.white),
                            ),
                            padding:
                                MaterialStateProperty.all<EdgeInsetsGeometry>(
                              const EdgeInsets.symmetric(
                                  vertical: 16,
                                  horizontal: 100), // Adjust the padding here
                            ),
                            backgroundColor: MaterialStateProperty.all<Color>(
                                const Color(0xff2c65d8)),
                            shape: MaterialStateProperty.all<OutlinedBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                          ),
                          child: Text(
                            'Get OTP',
                            maxLines: 1,
                            style: GoogleFonts.outfit(
                              textStyle: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "OR",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontSize: 16,
                              // fontWeight: FontWeight.bold, // Makes the text bold
                              letterSpacing:
                                  1.2, // Increases spacing between letters
                            ),
                          ),
                        ),
                        InkWell(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 5),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.blue),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Text(
                              "Login With Password",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                color: Colors.blue,
                                fontSize: 16,
                                fontWeight:
                                    FontWeight.w400, // Makes the text bold
                                letterSpacing:
                                    1.2, // Increases spacing between letters
                              ),
                            ),
                          ),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (c) => const Login()),
                            );
                          },
                        ),
                        const SizedBox(height: 40),
                      ] else
                        ..._enterPinScreen,
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (isClicked)
            Stack(
              children: [
                ModalBarrier(
                    dismissible: false, color: Colors.grey.withOpacity(0.3)),
                const Center(child: CircularProgressIndicator()),
              ],
            ),
        ],
      ),
    );
  }

  List<Widget> get _enterPinScreen {
    return [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          "OTP verification",
          style: GoogleFonts.poppins(
            color: Colors.blue,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Text(
          'Enter the otp send to +91 ${_emailController.text}',
          style: GoogleFonts.outfit(
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Color(0xff23202a),
            ),
          ),
          textAlign: TextAlign.center,
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: InkWell(
          onTap: () {
            setState(() {
              otp = null;
            });
          },
          child: Text(
            'Wrong Number?',
            style: GoogleFonts.outfit(
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Colors.red,
              ),
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
      const SizedBox(height: 20),
      OtpTextField(
        clearText: true,
        numberOfFields: 4,
        borderColor: const Color(0xFF512DA8),
        enabledBorderColor: const Color.fromARGB(255, 182, 152, 251),
        //set to true to show as box or false to show as dash
        showFieldAsBox: true,
        //runs when a code is typed in
        onCodeChanged: (String code) {
          //handle validation or checks here
        },
        //runs when every textfield is filled
        onSubmit: (v) async {
          if (v == otp) {
            if (user != null) {
              if (await user!.verifyDevice()) {
                await Storage.storeUser(user!);
                if (mounted) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const BottomNavigation()),
                    (s) => false,
                  );
                  showSnackbar("Welcome back ${user!.agent_name}", context,
                      Icons.warning);
                }
              } else {
                if (context.mounted) {
                  context.read<HomeCubit>().setUser(user!);
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (c) => const DeviceVerifyScreen()),
                    (p) => false,
                  );
                }
              }
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SignUpScreenInitial(
                    agencyId: AgencyDetails().id,
                    agencyName: AgencyDetails().agencyName,
                    phoneNumber: _emailController.text,
                  ),
                ),
              );
            }
          } else {
            showSnackbar("OTP is incorrect", context, Icons.warning);
          }
        }, // end onSubmit
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
        child: GestureDetector(
          onTap: () async {
            if (_emailController.text.isEmpty) {
              showSnackbar(
                "Phone number is required",
                context,
                Icons.warning,
              );
              Navigator.of(context).pop();
              return;
            }
            var result = await AuthServices.verifyPhone(
              phone: _emailController.text,
              context: context,
            );
            otp = result.$1;
            user = result.$2;
            setState(() {});
            _restartCountdown();
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Resend OTP?',
                style: TextStyle(
                  color:
                      isCountComplete ? const Color(0xff2c65d8) : Colors.grey,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Countdown(
                animation: StepTween(
                  begin: levelClock,
                  end: 0,
                ).animate(_controller!),
              ),
            ],
          ),
        ),
      ),
      const SizedBox(height: 20),
    ];
  }
}
