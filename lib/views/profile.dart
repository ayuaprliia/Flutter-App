import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
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
        title: const Text('Profile'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(200, 61, 200, 0),
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
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          )
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
}
