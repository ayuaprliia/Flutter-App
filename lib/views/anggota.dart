import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart'; // Import paket intl untuk NumberFormat
import 'package:tugas1/utility/colors.dart';
import 'package:tugas1/views/detailAnggota.dart';

class Anggota {
  final int id;
  final String nama;
  final String alamat;
  final String telepon;
  final String tanggalLahir;
  final int noInduk;
  final int status_aktif;
  int saldo; // Changed to mutable to update with API data

  Anggota({
    required this.id,
    required this.nama,
    required this.alamat,
    required this.telepon,
    required this.tanggalLahir,
    required this.noInduk,
    required this.status_aktif,
    required this.saldo,
  });

  factory Anggota.fromJson(Map<String, dynamic> json) {
    return Anggota(
      id: json['id'] ?? 0,
      nama: json['nama'] ?? '',
      alamat: json['alamat'] ?? '',
      telepon: json['telepon'] ?? '',
      tanggalLahir: json['tgl_lahir'] ?? '',
      noInduk: json['nomor_induk'] ?? 0,
      status_aktif: json['status_aktif'] ?? 0,
      saldo: json['saldo'] ?? 0,
    );
  }
}

class AnggotaView extends StatefulWidget {
  const AnggotaView({super.key});

  @override
  State<AnggotaView> createState() => _AnggotaViewState();
}

class _AnggotaViewState extends State<AnggotaView> {
  final _storage = GetStorage();
  final _dio = Dio();
  final _apiUrl = 'https://mobileapis.manpits.xyz/api';

  List<Anggota> anggotaList = [];
  List<Anggota> filteredAnggotaList = [];
  bool isLoading = true;
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    getAnggotaList();
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
                      onPressed: () {
                        Navigator.pushNamed(context, '/addAnggota');
                      },
                      icon: const Icon(
                        Icons.person_add,
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
                  'Daftar Anggota',
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
            onChanged: (query) {
              setState(() {
                searchQuery = query;
                filterAnggotaList();
              });
            },
            decoration: InputDecoration(
              fillColor: Colors.white,
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              hintText: 'Cari Anggota',
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
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: filteredAnggotaList.length,
                  itemBuilder: (context, index) {
                    final anggota = filteredAnggotaList[index];
                    return Padding(
                      padding: const EdgeInsets.all(10),
                      child: Container(
                        decoration: BoxDecoration(
                          color: blueColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    anggota.nama,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'No Induk: ${anggota.noInduk}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.paid,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                  Text(
                                    ' : Rp ${_formatCurrency(anggota.saldo)}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          onTap: ()  {
                            // final result = await Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) =>
                            //         DetailAnggotaView(id: anggota.id),
                            //   ),
                            // );

                            // if (result == true) {
                            //   getAnggotaList();
                            // }
                            Navigator.pushNamed(context, '/community/${anggota.id}');
                          },
                        ),
                      ),
                    );
                  },
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

  String _formatCurrency(int amount) {
    final formatter = NumberFormat('#,###');
    return formatter.format(amount);
  }

  void getAnggotaList() async {
    setState(() {
      isLoading = true;
    });
    try {
      final response = await _dio.get(
        '$_apiUrl/anggota',
        options: Options(
          headers: {'Authorization': 'Bearer ${_storage.read('token')}'},
        ),
      );

      if (response.statusCode == 200) {
        final responseData = response.data;
        final userData = responseData['data']['anggotas'];
        if (userData is List) {
          List<Anggota> loadedAnggotaList = [];
          for (var anggotaJson in userData) {
            int saldo = await _getSaldo(anggotaJson["id"]);
            loadedAnggotaList.add(Anggota.fromJson({
              "id": anggotaJson["id"],
              "nama": anggotaJson["nama"],
              "alamat": anggotaJson["alamat"],
              "tgl_lahir": anggotaJson["tgl_lahir"],
              "telepon": anggotaJson["telepon"],
              "nomor_induk": anggotaJson["nomor_induk"],
              "status_aktif": anggotaJson["status_aktif"],
              "saldo": saldo,
            }));
          }

          setState(() {
            anggotaList = loadedAnggotaList;
            filterAnggotaList();
            isLoading = false; // Set loading to false when data is loaded
          });
        }
      } else {
        print('Error: API request failed: ${response.statusCode}');
      }
    } on DioError catch (e) {
      print('Terjadi kesalahan: ${e.message}');
      setState(() {
        isLoading = false; // Ensure loading is set to false on error
      });
    }
  }

  Future<int> _getSaldo(int anggotaId) async {
    try {
      final response = await _dio.get(
        '$_apiUrl/saldo/$anggotaId',
        options: Options(
          headers: {'Authorization': 'Bearer ${_storage.read('token')}'},
        ),
      );

      if (response.statusCode == 200) {
        final responseData = response.data;
        return responseData['data']['saldo'];
      } else {
        throw Exception('Failed to load saldo');
      }
    } catch (e) {
      print('Failed to load saldo: $e');
      throw Exception('Failed to load saldo: $e');
    }
  }

  void filterAnggotaList() {
    setState(() {
      filteredAnggotaList = anggotaList
          .where((anggota) =>
              anggota.nama.toLowerCase().contains(searchQuery.toLowerCase()) ||
              anggota.alamat
                  .toLowerCase()
                  .contains(searchQuery.toLowerCase()) ||
              anggota.noInduk.toString().contains(searchQuery.toLowerCase()))
          .toList();
    });
  }
}
