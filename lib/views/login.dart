import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tugas1/utility/colors.dart';
import 'package:tugas1/views/register.dart';

final _dio = Dio();
final _storage = GetStorage();
final _apiUrl = 'https://mobileapis.manpits.xyz/api';

class LoginView extends StatefulWidget {
  LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  bool isCheckBox = true;
  bool isPasswordHidden = true;
  bool isVerifiedHidden = true;
  bool errorMessage = false;
  String errMessage = "";
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  // void validityCheck() {
  //   if (passwordController.text.isEmpty) {
  //     setState(() {
  //       errorMessage = true;
  //     });
  //     errMessage = "password cant be empty";
  //   } else if (emailController.text.isEmpty) {
  //     setState(() {
  //       errorMessage = true;
  //       errMessage = "invalid phone number";
  //     });
  //   } else {
  //     goLogin();
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    void goLogin() async {
      try {
        final _response = await _dio.post('${_apiUrl}/login', data: {
          'email': emailController.text,
          'password': passwordController.text
        });
        if (_response.statusCode == 200) {
          Navigator.pushReplacementNamed(context, '/home');
        }
        print(_response.data);
        _storage.write('token', _response.data['data']['token']);
      } on DioException catch (e) {
        print('${e.response} - ${e.response?.statusCode}');
      }
    }

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
                  child: Text("Email",
                      style: TextStyle(
                          color: fontGrayColor, fontFamily: "PoppinsMedium")),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 30),
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
                        // validityCheck();
                        goLogin();
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
