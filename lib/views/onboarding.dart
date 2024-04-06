import 'package:flutter/material.dart';
import 'package:tugas1/utility/colors.dart';

List onboardingData = [
  {
    "image":"assets/images/onBoarding1.png",
    "title":"Kemudahan Akses\nBelajar Bahasa Isyarat",
    "description":"Selamat Datang di Signify!",
  },
  {
    "image":"assets/images/onBoarding2.png",
    "title":"Belajar Bahasa Isyarat\nyang Menyenangkan",
    "description":"Banyak materi dengan berbagai kategori!",
  },
  {
    "image":"assets/images/onBoarding3.png",
    "title":"Tidak Ada Batasan\nuntuk Berkomunikasi",
    "description":"Belajar BISINDO bersama Signify!",
  },
];

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
            Expanded(
              child: PageView.builder(
                itemCount: onboardingData.length,
                itemBuilder: (_,i){
                return Column(
                  children: [
                  Image.asset(onboardingData[i]['image']),
                  Column(
                    children: [
                       Text(
                        onboardingData[i]['title'],
                        textAlign: TextAlign.center,
                        style: TextStyle(fontFamily: "PoppinsBold", fontSize: 24),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 22.0),
                        child: Text(
                          onboardingData[i]['description'],
                          textAlign: TextAlign.center,
                          style: TextStyle(fontFamily: "PoppinsMedium", fontSize: 16, color: fontGrayColor),
                        ),
                      ),
                    ],
                  ),
                  ],
                );
              }),
            ),
           
            Column(
              children: [
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
            
            
          ],
        ),
      ),
    );
  }
}