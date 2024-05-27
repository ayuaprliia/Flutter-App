import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tugas1/utility/colors.dart';

final _dio = Dio();
final _storage = GetStorage();
const _apiUrl = 'https://mobileapis.manpits.xyz/api';
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
                  _showLogoutConfirmation(context);
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
      final response = await _dio.get(
        "$_apiUrl/user",
        options: Options(
          headers: {'Authorization': 'Bearer ${_storage.read('token')}'},
        ),
      );

      setState(() {
        _userName = response.data['data']['user']['name'];
        _email = response.data['data']['user']['email'];
      });
    } on DioException catch (e) {
      print('${e.response} - ${e.response?.statusCode}');
    }
  }

  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: blueColor,
          title: const Text('Konfirmasi Logout', style: TextStyle(color: Colors.white),),
          content: const Text('Apakah Anda Yakin ingin Logout?', style: TextStyle(color: Colors.white),),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Batal', style: TextStyle(color: Colors.white, fontFamily: "PoppinsSemiBold"),),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                goLogout();
              },
              child: const Text('Logout', style: TextStyle(color: Colors.white, fontFamily: "PoppinsSemiBold"),),
            ),
          ],
        );
      },
    );
  }

  void goLogout() async {
    try {
      final response = await _dio.get(
        '$_apiUrl/logout',
        options: Options(
          headers: {'Authorization': 'Bearer ${_storage.read('token')}'},
        ),
      );
      await _storage.remove('token');
      if (response.statusCode == 200) {
        Navigator.pushReplacementNamed(context, '/greeting');
      }

      print(response.data);
    } on DioException catch (e) {
      print('${e.response} - ${e.response?.statusCode}');
    }
  }
}
