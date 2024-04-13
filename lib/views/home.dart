import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tugas1/utility/colors.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
        children: [
         const Align(
              child: Image(
            image: AssetImage("assets/images/onBoarding2.png"),
          )),
         const Text(
            "Welcome",
            style: TextStyle(fontFamily: "PoppinsBold", fontSize: 30),
          ),
          Text("insert text here", style: TextStyle(fontFamily: "PoppinsRegular", fontSize: 12, color: fontGrayColor, ),)
        ],
      ),
    );
  }
}
