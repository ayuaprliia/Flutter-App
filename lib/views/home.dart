// ignore_for_file: avoid_print

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tugas1/utility/colors.dart';

final _dio = Dio();
final _storage = GetStorage();
const _apiUrl = 'https://mobileapis.manpits.xyz/api';
String _userName = "";

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  // String _userName = "";

  @override
  void initState() {
    super.initState();
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(15, 15, 15, 10),
            decoration: BoxDecoration(
              color: blueColor,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Image(
                      image: AssetImage("assets/images/Logo.png"),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.notifications,
                        size: 38,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: Row(
                    children: [
                      const Text(
                        "HALO, ",
                        style: TextStyle(
                          fontFamily: "PoppinsSemiBold",
                          color: Colors.white,
                          fontSize: 24,
                        ),
                      ),
                      Text(
                        _userName,
                        style: const TextStyle(
                          fontFamily: "PoppinsSemiBold",
                          color: Colors.white,
                          fontSize: 24,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 100),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Align(
                  child:
                      Image(image: AssetImage("assets/images/NoActivity.png")),
                ),
                Text("Anda Belum Memiliki Aktivitas"),
              ],
            ),
          )
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        showUnselectedLabels: true,
        iconSize: 32,
        selectedItemColor: fontGrayColor,
        selectedFontSize: 18,
        unselectedItemColor: fontGrayColor,
        items: [
          BottomNavigationBarItem(
            icon: IconButton(
              icon: const Icon(Icons.home),
              onPressed: () {},
            ),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: IconButton(
              icon: const Icon(Icons.groups),
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/community');
              },
            ),
            label: 'Member',
          ),
          BottomNavigationBarItem(
            icon: IconButton(
              icon: const Icon(Icons.paid),
              onPressed: () {
                Navigator.pushNamed(context, '/transaksi');
              },
            ),
            label: 'Transaksi',
          ),
          BottomNavigationBarItem(
            icon: IconButton(
              icon: const Icon(Icons.quiz),
              onPressed: () {},
            ),
            label: 'FunQuiz',
          ),
          BottomNavigationBarItem(
            icon: IconButton(
              icon: const Icon(Icons.person),
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/profile');
              },
            ),
            label: 'Profil',
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
      });
    } on DioException catch (e) {
      print('${e.response} - ${e.response?.statusCode}');
    }
  }

  // void goLogout() async {
  //   try {
  //     final _response = await _dio.get(
  //       '${_apiUrl}/logout',
  //       options: Options(
  //         headers: {'Authorization': 'Bearer ${_storage.read('token')}'},
  //       ),
  //     );
  //     await _storage.remove('token');
  //     if (_response.statusCode == 200) {
  //       // ignore: use_build_context_synchronously
  //       Navigator.pushReplacementNamed(context, '/greeting');
  //     }

  //     print(_response.data);
  //   } on DioException catch (e) {
  //     print('${e.response} - ${e.response?.statusCode}');
  //   }
  // }
}
