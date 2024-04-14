import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:tugas1/utility/colors.dart';
import 'package:tugas1/views/greeting.dart';
import 'package:tugas1/views/home.dart';
import 'package:tugas1/views/login.dart';
import 'package:tugas1/views/onboarding.dart';
import 'package:tugas1/views/register.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  bool isCheckBox = true;
  bool isPasswordHidden = true;
  bool isVerifiedHidden = true;
  bool errorMessage = false;
  String errMessage = "";
  TextEditingController phoneNumController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void validityCheck() {
    if (passwordController.text.isEmpty) {
      setState(() {
        errorMessage = true;
      });
      errMessage = "password cant be empty";
    } else if (phoneNumController.text.isEmpty) {
      setState(() {
        errorMessage = true;
        errMessage = "invalid phone number";
      });
    } else {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return const HomeView();
      }));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: AppBar(
          flexibleSpace: Container(
            color: grayColor,
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Text(
                    "Masuk",
                    style: TextStyle(fontFamily: "PoppinsBold"),
                  ),
                ],
              ),
              Container(
                  margin: const EdgeInsets.only(top: 4),
                  child: Text(
                    "Masukan informasi akun yang sudah Anda\nDaftarkan!",
                    style: TextStyle(
                        fontFamily: "PoppinsRegular",
                        fontSize: 12,
                        color: fontGrayColor),
                  ))
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  margin: const EdgeInsets.only(left: 24),
                  child: Text("No Telepon",
                      style: TextStyle(
                          color: fontGrayColor, fontFamily: "PoppinsMedium")),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: SizedBox(
                  width: 327,
                  child: TextField(
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    controller: phoneNumController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  margin: const EdgeInsets.only(left: 24),
                  child: Text("Password",
                      style: TextStyle(
                          color: fontGrayColor, fontFamily: "PoppinsMedium")),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 1),
                child: SizedBox(
                  width: 327,
                  child: TextField(
                    controller: passwordController,
                    obscureText: isPasswordHidden,
                    decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(isPasswordHidden
                              ? Icons.visibility_off
                              : Icons.visibility),
                          onPressed: () {
                            setState(() {
                              isPasswordHidden = !isPasswordHidden;
                            });
                          },
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                ),
              ),
              Container(
                  margin: const EdgeInsets.only(left: 24),
                  child: Align(
                      alignment: Alignment.topLeft,
                      child: Row(
                        children: [
                          Text(
                            "Lupa Password? ",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontFamily: "PoppinsRegular",
                                color: fontGrayColor,
                                fontSize: 12),
                          ),
                          Text(
                            "Reset Password",
                            style: TextStyle(
                                color: blueColor,
                                fontFamily: "PoppinsMedium",
                                fontSize: 12),
                          )
                        ],
                      ))),
              Visibility(
                visible: errorMessage,
                child: Container(
                    margin: const EdgeInsets.only(left: 24),
                    child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          errMessage,
                          style: const TextStyle(
                              fontFamily: "PoppinsRegular", color: Colors.red),
                        ))),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: SizedBox(
                    width: 327,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        validityCheck();
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2C599D),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10))),
                      child: const Text("Masuk",
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: "PoppinsMedium")),
                    )),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Belum Punya Akun? ",
                        style: TextStyle(
                            color: fontGrayColor, fontFamily: "PoppinsMedium")),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return const RegisterView();
                        }));
                      },
                      child: Text(
                        "Daftar",
                        style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: blueColor,
                            fontFamily: "PoppinsBold"),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: Stack(children: [
                    const Divider(),
                    Align(
                        alignment: Alignment.center,
                        child: Text(
                          "atau masuk dengan",
                          style: TextStyle(color: fontGrayColor),
                        ))
                  ])),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        margin: const EdgeInsets.only(right: 40),
                        child: const Image(
                            image: AssetImage("assets/images/google.png"))),
                    const Image(image: AssetImage("assets/images/facebook.png"))
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
