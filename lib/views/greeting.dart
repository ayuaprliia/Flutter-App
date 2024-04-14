import 'package:flutter/material.dart';
import 'package:tugas1/views/login.dart';
import 'package:tugas1/views/login.dart';
import 'package:tugas1/views/register.dart';
import '../utility/colors.dart';

class GreetingView extends StatefulWidget {
  const GreetingView({super.key});

  @override
  State<GreetingView> createState() => _GreetingViewState();
}

class _GreetingViewState extends State<GreetingView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
              8, 55, 8, 55), //mengatur posisi dan jarak text dengan gambar
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.only(bottom: 16.0),
                child: Text(
                  "Hilangkan Batasan Berkomunikasi\ndengan Signify!",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontFamily: "PoppinsBold", fontSize: 24),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  "Belajar BISINDO itu mudah dan menyenangkan!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: "PoppinsMedium",
                      fontSize: 16,
                      color: fontGrayColor),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(55, 60, 55, 90),
                child: Image.asset('assets/images/greeting.png'),
              ),

              //membuat button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginView()));
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 13.5),
                    decoration: BoxDecoration(
                        color: blueColor,
                        borderRadius: BorderRadius.circular(100)),
                    child: const Text(
                      "Masuk",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: "PoppinsMedium",
                          fontSize: 16,
                          color: Colors.white),
                    ),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GestureDetector(
                  onTap: () {
                    print("daftar");
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return const RegisterView();
                    }));
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 13.5),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(100)),
                    child: Text(
                      "Daftar",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: "PoppinsMedium",
                          fontSize: 16,
                          color: blueColor),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
