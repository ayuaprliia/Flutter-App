import 'package:flutter/material.dart';
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
          children: [
            PageView.builder(itemBuilder: (_, i) {
              return Column(
                children: [
                Image.asset('assets/images/onBoarding_1.png'),
                Column(
                  children: [
                    const Text(
                      "Kemudahan Akses\nBelajar Bahasa Isyarat",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontFamily: "PoppinsBold", fontSize: 24),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 22.0),
                      child: Text(
                        "Selamat Datang di Signify!",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontFamily: "PoppinsMedium", fontSize: 16, color: fontGrayColor),
                      ),
                    ),
                  ],
                ),
                ],
              );
            }),
           
           Padding(
              padding: const EdgeInsets.symmetric(horizontal:16),
              child: GestureDetector(
                onTap: (){
                  print("Lanjutkan");
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical:13.5),
                  decoration: BoxDecoration(color: blueColor, borderRadius: BorderRadius.circular(4)),
                  child: const Text("Lanjutkan", 
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: "PoppinsMedium", fontSize: 16, color: Colors.white),
                    ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal:16),
              child: GestureDetector(
                onTap: (){
                  print("Lewati");
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical:13.5),
                  decoration: BoxDecoration(color:Colors.white, borderRadius: BorderRadius.circular(4)),
                  child: Text("Lewati", 
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: "PoppinsMedium", fontSize: 16, color: blueColor),
                    ),
                ),
              ),
            )
            
          ],
        ),
      ),
    );
  }
}