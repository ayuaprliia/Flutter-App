import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tugas1/utility/colors.dart';

final _dio = Dio();
final _storage = GetStorage();
final _apiUrl = 'https://mobileapis.manpits.xyz/api';
String _userName = "";
String _email = "";

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  void initState() {
    super.initState();
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: blueColor,
        title: const Text(
          'Profile',
          style: TextStyle(fontFamily: "PoppinsMedium", color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pushNamed(context, "/home"),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(200, 10, 200, 0),
            child: SizedBox(
              height: 115,
              width: 115,
              child: CircleAvatar(
                backgroundImage: AssetImage("assets/images/profile.png"),
              ),
            ),
          ),
          Text(
            _userName,
            style: const TextStyle(
                fontFamily: "PoppinsSemiBold",
                fontSize: 24,
                color: Colors.black),
          ),
          Text(
            _email,
            style: TextStyle(
              fontFamily: "PoppinsRegular",
              fontSize: 16,
              color: fontGrayColor,
            ),
          ),
          SizedBox(
            width: 200,
            child: Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: ElevatedButton(
                onPressed: () {
                  const Text('editprofil');
                },
                style: ElevatedButton.styleFrom(backgroundColor: blueColor),
                child: const Text(
                  "Edit Profil",
                  style: TextStyle(
                      fontFamily: "PoppinsRegular",
                      fontSize: 14,
                      color: Colors.white),
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(28, 50, 300, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Pengaturan",
                  style: TextStyle(fontFamily: "PoppinsBold", fontSize: 20),
                )
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
          ),
          ListTile(
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: fontGrayColor.withOpacity(0.1),
              ),
              child: Icon(Icons.newspaper, color: blueColor),
            ),
            title: const Text("Ketentuan Layanan"),
            trailing: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: fontGrayColor.withOpacity(0.1),
              ),
              child: Icon(
                Icons.navigate_next,
                color: blueColor,
              ),
            ),
          ),
          ListTile(
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: fontGrayColor.withOpacity(0.1),
              ),
              child: Icon(Icons.lock, color: blueColor),
            ),
            title: const Text("Kebijakan Privasi"),
            trailing: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: fontGrayColor.withOpacity(0.1),
              ),
              child: Icon(
                Icons.navigate_next,
                color: blueColor,
              ),
            ),
          ),
          ListTile(
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: fontGrayColor.withOpacity(0.1),
              ),
              child: Icon(Icons.help_outline, color: blueColor),
            ),
            title: const Text("Pusat Bantuan"),
            trailing: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: fontGrayColor.withOpacity(0.1),
              ),
              child: Icon(
                Icons.navigate_next,
                color: blueColor,
              ),
            ),
          ),
          SizedBox(
            width: 200,
            child: Padding(
              padding: const EdgeInsets.only(top: 30.0),
              child: ElevatedButton(
                onPressed: () {
                  goLogout();
                },
                style: ElevatedButton.styleFrom(backgroundColor: blueColor),
                child: const Text(
                  "Keluar",
                  style: TextStyle(
                      fontFamily: "PoppinsRegular",
                      fontSize: 14,
                      color: Colors.white),
                ),
              ),
            ),
          ),
          SizedBox(
            width: 200,
            child: Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: ElevatedButton(
                onPressed: () {
                  print('hapus akun');
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                child: const Text(
                  "Hapus Akun",
                  style: TextStyle(
                      fontFamily: "PoppinsRegular",
                      fontSize: 14,
                      color: Colors.red),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void getUser() async {
    try {
      final _response = await _dio.get(
        "$_apiUrl/user",
        options: Options(
          headers: {'Authorization': 'Bearer ${_storage.read('token')}'},
        ),
      );

      setState(() {
        _userName = _response.data['data']['user']['name'];
        _email = _response.data['data']['user']['email'];
      });
    } on DioException catch (e) {
      print('${e.response} - ${e.response?.statusCode}');
    }
  }

  void goLogout() async {
    try {
      final _response = await _dio.get(
        '${_apiUrl}/logout',
        options: Options(
          headers: {'Authorization': 'Bearer ${_storage.read('token')}'},
        ),
      );
      await _storage.remove('token');
      if (_response.statusCode == 200) {
        // ignore: use_build_context_synchronously
        Navigator.pushReplacementNamed(context, '/greeting');
      }

      print(_response.data);
    } on DioException catch (e) {
      print('${e.response} - ${e.response?.statusCode}');
    }
  }
}
