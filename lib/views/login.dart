import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tugas1/utility/colors.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Row(
            children: [
              Text(
                "Belum Punya Akun?  ",
                style: TextStyle(
                  fontFamily: "PoppinsMedium",
                  fontSize: 14,
                  color: fontGrayColor,
                  ),
                ),
                Text(
                "Daftar Sekarang",
                style: TextStyle(
                  fontFamily: "PoppinsBold",
                  fontSize: 14,
                  decoration: TextDecoration.underline,
                  decorationColor: skyblueColor,
                  color: skyblueColor,
                  ),
                )
            ],
          )
        ],
      ),
    );
    
  }
}