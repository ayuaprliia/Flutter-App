import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tugas1/utility/colors.dart';
import 'package:tugas1/views/register.dart';

final _dio = Dio();
final _storage = GetStorage();
const _apiUrl = 'https://mobileapis.manpits.xyz/api';

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
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
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
                child: Row(
                  children: [
                    const Expanded(
                      child: Divider(
                        color: Colors.grey,
                        thickness: 1,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        "atau masuk dengan",
                        style: TextStyle(color: fontGrayColor),
                      ),
                    ),
                    const Expanded(
                      child: Divider(
                        color: Colors.grey,
                        thickness: 1,
                      ),
                    ),
                  ],
                ),
              ),
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

  void goLogin() async {
    if (!isValidEmail(emailController.text)) {
      setState(() {
        errorMessage = true;
        errMessage = 'Format email tidak valid!';
      });
      return;
    }

    try {
      final response = await _dio.post('$_apiUrl/login', data: {
        'email': emailController.text,
        'password': passwordController.text
      });
      if (response.statusCode == 200) {
        Navigator.pushReplacementNamed(context, '/home');
        _storage.write('token', response.data['data']['token']);
      } else {
        showErrorDialog(
            'Email atau password Anda salah! Mohon periksa kembali.');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        showErrorDialog(
            'Email atau password Anda salah! Mohon periksa kembali.');
      } else {
        showErrorDialog(
            'Email atau password Anda salah! Mohon periksa kembali');
      }
    }
  }

  bool isValidEmail(String email) {
    final regex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    return regex.hasMatch(email);
  }

  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Peringatan"),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }
}
