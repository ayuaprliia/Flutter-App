import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tugas1/utility/colors.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
   State<OnboardingView> createState() => OnboardingViewState();
}

class OnboardingViewState extends State<OnboardingView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset('assets/images/onBoarding_1.png'),
                Column(
                  children: [
                    const Text(
                      "Kemudahan Akses\nBelajar Bahasa Isyarat",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontFamily: "PoppinsBold", fontSize: 24),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Text(
                        "Selamat Datang di Signify!",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontFamily: "PoppinsMedium", fontSize: 16, color: fontGrayColor),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}