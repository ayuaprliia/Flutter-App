import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tugas1/utility/colors.dart';

class ListSettingBungaView extends StatefulWidget {
  const ListSettingBungaView({super.key});

  @override
  State<ListSettingBungaView> createState() => _ListSettingBungaViewState();
}

class _ListSettingBungaViewState extends State<ListSettingBungaView> {
  final _storage = GetStorage();
  final _dio = Dio();
  final _apiUrl = 'https://mobileapis.manpits.xyz/api';

  List<dynamic> _settings = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchSettings();
  }

  void _fetchSettings() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await _dio.get(
        '$_apiUrl/settingbunga',
        options: Options(
          headers: {'Authorization': 'Bearer ${_storage.read('token')}'},
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data['data'];
        if (data != null &&
            data['settingbungas'] != null &&
            data['settingbungas'] is List) {
          setState(() {
            _settings = List<Map<String, dynamic>>.from(data['settingbungas']);
          });
        } else {
          print('Invalid data format');
        }
      } else {
        print('Failed to load settings bunga');
      }
    } catch (error) {
      print('Error: $error');
      _showErrorDialog('Gagal memuat data setting bunga');
    }

    await _disableAllActiveSettings();

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _disableAllActiveSettings() async {
    try {
      final response = await _dio.get(
        '$_apiUrl/settingbunga',
        options: Options(
          headers: {'Authorization': 'Bearer ${_storage.read('token')}'},
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data['data'];
        if (data != null &&
            data['settingbungas'] != null &&
            data['settingbungas'] is List) {
          final List<dynamic> settings = data['settingbungas'];
          for (var setting in settings) {
            if (setting['isaktif'] == 1) {
              await _dio.put(
                '$_apiUrl/updateSettingBunga/${setting['id']}',
                data: {'isaktif': 0},
                options: Options(
                  headers: {
                    'Authorization': 'Bearer ${_storage.read('token')}'
                  },
                ),
              );
            }
          }
        } else {
          print('Invalid data format');
        }
      } else {
        print('Failed to load settings bunga');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
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
                      onPressed: () async {
                        final result = await Navigator.pushNamed(
                            context, '/addSettingBunga');
                        if (result == true) {
                          _fetchSettings(); // Refresh the data
                        }
                      },
                      icon: const Icon(
                        Icons.add_circle,
                        size: 38,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Padding(
                  padding: EdgeInsets.only(bottom: 15),
                  child: Row(
                    children: [
                      Text(
                        "Selamat Datang di \nSignify Community! ",
                        style: TextStyle(
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
            padding: EdgeInsets.fromLTRB(15, 25, 15, 15),
            child: Row(
              children: [
                Text(
                  'Daftar Setting Bunga',
                  style: TextStyle(
                    fontFamily: "PoppinsSemiBold",
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          TextField(
            cursorColor: Colors.grey,
            decoration: InputDecoration(
              fillColor: Colors.white,
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              hintText: 'Cari Setting Bunga',
              hintStyle: const TextStyle(
                fontFamily: "PoppinsRegular",
                fontSize: 12,
                color: Colors.grey,
              ),
              prefixIcon: Container(
                padding: const EdgeInsets.all(15),
                width: 18,
                child: const Icon(Icons.search),
              ),
            ),
          ),
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _settings.isEmpty
                  ? const Center(child: Text('Tidak ada data setting bunga'))
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(30.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildSettingCategory(true), // Bunga Aktif
                          _buildSettingCategory(false), // Bunga Tidak Aktif
                        ],
                      ),
                    ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        showUnselectedLabels: true,
        iconSize: 32,
        selectedItemColor: Colors.grey,
        selectedFontSize: 18,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            icon: IconButton(
              icon: const Icon(Icons.home),
              onPressed: () {
                Navigator.pushNamed(context, '/home');
              },
            ),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: IconButton(
              icon: const Icon(Icons.groups),
              onPressed: () {
                Navigator.pushNamed(context, '/community');
              },
            ),
            label: 'Member',
          ),
          BottomNavigationBarItem(
            icon: IconButton(
              icon: const Icon(Icons.attach_money),
              onPressed: () {
                Navigator.pushNamed(context, '/settingBunga');
              },
            ),
            label: 'Bunga',
          ),
          BottomNavigationBarItem(
            icon: IconButton(
              icon: const Icon(Icons.person),
              onPressed: () {
                Navigator.pushNamed(context, '/profile');
              },
            ),
            label: 'Profil',
          ),
        ],
      ),
    );
  }

  Widget _buildSettingCategory(bool isActive) {
    final categorySettings = _settings
        .where((setting) => setting['isaktif'] == (isActive ? 1 : 0))
        .toList();
    return categorySettings.isNotEmpty
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  isActive ? 'Bunga Aktif' : 'Bunga Tidak Aktif',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: categorySettings.length,
                itemBuilder: (context, index) {
                  final setting = categorySettings[index];
                  return Padding(
                    padding: const EdgeInsets.all(10),
                    child: ListTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      tileColor: blueColor,
                      title: Text(
                        'Persen: ${setting['persen']}%',
                        style: const TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        'Status: ${setting['isaktif'] == 1 ? 'Aktif' : 'Tidak Aktif'}',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  );
                },
              ),
            ],
          )
        : const SizedBox.shrink(); // Kosongkan widget jika tidak ada data
  }
}
