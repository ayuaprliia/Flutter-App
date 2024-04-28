import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tugas1/utility/colors.dart';
import 'package:tugas1/views/onboarding.dart';

final _dio = Dio();
final _storage = GetStorage();
final _apiUrl = 'https://mobileapis.manpits.xyz/api';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  bool isCheckBox = true;
  bool isPasswordHidden = true;
  bool isVerifiedHidden = true;
  bool errorMessage = false;
  String errMessage = "";
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController verifyPassController = TextEditingController();

  void validityCheck() {
    if (passwordController.text.isEmpty) {
      setState(() {
        errorMessage = true;
      });
      errMessage = "password cant be empty";
    } else if (passwordController.text != verifyPassController.text) {
      setState(() {
        errorMessage = true;
      });
      errMessage = "password must be the same";
    } else {
      goRegister();
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
              const Text(
                "Daftar",
                style: TextStyle(fontFamily: "PoppinsBold"),
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
                  child: Text("Nama",
                      style: TextStyle(
                          color: fontGrayColor, fontFamily: "PoppinsMedium")),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: SizedBox(
                  width: 327,
                  child: TextField(
                    controller: nameController,
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
                  child: Text("Email",
                      style: TextStyle(
                          color: fontGrayColor, fontFamily: "PoppinsMedium")),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: SizedBox(
                  width: 327,
                  child: TextField(
                    controller: emailController,
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
                padding: const EdgeInsets.only(bottom: 8.0),
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
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  margin: const EdgeInsets.only(left: 24),
                  child: Text("Konfirmasi Password",
                      style: TextStyle(
                          color: fontGrayColor, fontFamily: "PoppinsMedium")),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: SizedBox(
                  width: 327,
                  child: TextField(
                    controller: verifyPassController,
                    obscureText: isVerifiedHidden,
                    decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(isVerifiedHidden
                              ? Icons.visibility_off
                              : Icons.visibility),
                          onPressed: () {
                            setState(() {
                              isVerifiedHidden = !isVerifiedHidden;
                            });
                          },
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                ),
              ),
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
                        setState(() {
                          validityCheck();
                        });
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2C599D),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10))),
                      child: const Text("Buat Akun",
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
                    Container(
                      child: IconButton(
                        icon: Icon(isCheckBox
                            ? Icons.check_box_outline_blank
                            : Icons.check_box),
                        onPressed: () {
                          setState(() {
                            isCheckBox = !isCheckBox;
                          });
                        },
                      ),
                    ),
                    Text(
                        "Dengan membuat akun, Anda telah\nsetuju dengan syarat dan ketentuan\nyang berlaku.",
                        style: TextStyle(
                            color: fontGrayColor, fontFamily: "PoppinsMedium")),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Sudah punya akun? ",
                      style: TextStyle(
                          color: fontGrayColor, fontFamily: "PoppinsMedium"),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return const OnboardingView();
                        }));
                      },
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/home');
                        },
                        child: Text("Masuk",
                            style: TextStyle(
                                color: blueColor,
                                decoration: TextDecoration.underline,
                                fontFamily: "PoppinsMedium")),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void goRegister() async {
    try {
      final _response = await _dio.post(
        '${_apiUrl}/register',
        data: {
          'name': nameController.text,
          'email': emailController.text,
          'password': passwordController.text,
        },
      );
      if (_response.statusCode == 200) {
        Navigator.pushReplacementNamed(context, '/home');
      }

      print(_response.data);
      _storage.write('token', _response.data['data']['token']);
    } on DioException catch (e) {
      print('${e.response} - ${e.response?.statusCode}');
    }
  }
}
