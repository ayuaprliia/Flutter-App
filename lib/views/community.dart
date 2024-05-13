import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tugas1/utility/colors.dart';

class Anggota {
  final int id;
  final String nama;
  final String alamat;
  String? telepon;
  String? tanggalLahir;

  Anggota({
    required this.id,
    required this.nama,
    required this.alamat,
    this.telepon,
    this.tanggalLahir,
  });

  factory Anggota.fromJson(Map<String, dynamic> json) {
    return Anggota(
      id: json['id'] ?? 0,
      nama: json['nama'] ?? '',
      alamat: json['alamat'] ?? '',
    );
  }
}

class CommunityView extends StatefulWidget {
  const CommunityView({Key? key}) : super(key: key);

  @override
  State<CommunityView> createState() => _CommunityViewState();
}

class _CommunityViewState extends State<CommunityView> {
  final _storage = GetStorage();
  final _dio = Dio();
  final _apiUrl = 'https://mobileapis.manpits.xyz/api';

  List<Anggota> AnggotaList = [];
  bool isLoading = true;

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
                child: Icon(Icons.search),
                width: 18,
              ),
            ),
          ),
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: AnggotaList.length,
                  itemBuilder: (context, index) {
                    final Anggota = AnggotaList[index];
                    return Padding(
                      padding: EdgeInsets.all(10),
                      child: ListTile(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        tileColor: blueColor,
                        title: Text(
                          Anggota.nama ?? '',
                          style: TextStyle(color: Colors.white),
                        ),
                        subtitle: Text(
                          Anggota.alamat ?? '',
                          style: TextStyle(color: Colors.white),
                        ),
                        onTap: () {
                          goAnggotaDetail(Anggota.id);
                        },
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit),
                              color: Colors.white,
                              onPressed: () {

                                   showDialog(
            context: context,
            builder: (BuildContext context) {
              final noIndukController = TextEditingController(text: Anggota.id.toString());
    final namaController = TextEditingController(text: Anggota.nama);
    final tanggalLahirController = TextEditingController(text: Anggota.tanggalLahir);
    final alamatController = TextEditingController(text: Anggota.alamat);
    final phoneController = TextEditingController(text: Anggota.telepon);
              return AlertDialog(
                title: Text("Detail Anggota"),
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                     TextField(
        controller: noIndukController,
        decoration: InputDecoration(labelText: 'Nomor Induk'),
      ),
      TextField(
        controller: namaController,
        decoration: InputDecoration(labelText: 'Nama'),
      ),
      TextField(
        controller: tanggalLahirController,
        decoration: InputDecoration(labelText: 'Tanggal Lahir'),
      ),
      TextField(
        controller: alamatController,
        decoration: InputDecoration(labelText: 'Alamat'),
      ),
      TextField(
        controller: phoneController,
        decoration: InputDecoration(labelText: 'Telepon'),
      ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Tutup"),
                  ),
                ],
              );
            },
          );

                                // goEditAnggota(
                                //   context,
                                //   Anggota.id,
                                //   Anggota.nama,
                                //   Anggota.tanggalLahir,
                                //   Anggota.alamat,
                                //   Anggota.telepon,
                                // );
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              color: Colors.white,
                              onPressed: () {
                                deleteAnggota(Anggota.id);
                              },
                            ),
                          ],
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
              icon: const Icon(Icons.menu_book),
              onPressed: () {},
            ),
            label: 'Modul',
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
              icon: const Icon(Icons.groups),
              onPressed: () {},
            ),
            label: 'Komunitas',
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
          setState(() {
            AnggotaList = userData
                .map((AnggotaJson) => Anggota.fromJson({
                      "id": AnggotaJson["id"],
                      "nama": AnggotaJson["nama"],
                      "alamat": AnggotaJson["alamat"],
                    }))
                .toList();
          });
        }
      } else {
        print('Error: API request failed: ${response.statusCode}');
      }
    } on DioError catch (e) {
      print('Terjadi kesalahan: ${e.message}');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void goAnggotaDetail(int id) async {
    try {
      final response = await _dio.get(
        '$_apiUrl/anggota/$id',
        options: Options(
          headers: {'Authorization': 'Bearer ${_storage.read('token')}'},
        ),
      );

      if (response.statusCode == 200) {
        final responseData = response.data;
        final AnggotaData = responseData['data']['anggota'];
        Anggota? selectedAnggota = Anggota.fromJson(AnggotaData);

        if (selectedAnggota != null) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Detail Anggota"),
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("ID: ${selectedAnggota.id}"),
                    Text("Nama: ${selectedAnggota.nama}"),
                    Text("Alamat: ${selectedAnggota.alamat}"),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Tutup"),
                  ),
                ],
              );
            },
          );
        } else {
          print("Data Anggotatidak ditemukan.");
        }
      } else {
        print('Terjadi kesalahan: ${response.statusCode}');
      }
    } on DioException catch (e) {
      print('Terjadi kesalahan: ${e.message}');
    }
  }

  void deleteAnggota(int id) async {
    try {
      final response = await _dio.delete(
        '$_apiUrl/anggota/$id',
        options: Options(
          headers: {'Authorization': 'Bearer ${_storage.read('token')}'},
        ),
      );

      if (response.statusCode == 200) {
        getAnggotaList();
        print('Anggotawith ID $id deleted successfully.');
      } else {
        print('Error deleting Anggota: ${response.statusCode}');
      }
    } on DioException catch (e) {
      print('Terjadi kesalahan: ${e.message}');
    }
  }

  void goEditAnggota(
      BuildContext context, noInduk, nama, tanggalLahir, alamat, phone) async {
   
    try {
      final _response = await _dio.put(
        '$_apiUrl/anggota',
        options: Options(
          headers: {'Authorization': 'Bearer ${_storage.read('token')}'},
        ),
        data: {
          'nomor_induk': noInduk,
          'nama': nama,
          'alamat': alamat,
          'tgl_lahir': tanggalLahir,
          'telepon': phone,
          'status_aktif': 1,
        },
      );
      _storage.write('data', _response.data['data']);
      if (_response.statusCode == 200) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Berhasil"),
              content: const Text("Anggota Baru Berhasil Ditambahkan!"),
              actions: <Widget>[
                MaterialButton(
                  child: const Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.pushNamed(context, '/community');
                  },
                ),
              ],
            );
          },
        );
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Error"),
              content: const Text("Anggota Baru Gagal Ditambahkan. Coba Lagi!"),
              actions: <Widget>[
                MaterialButton(
                  child: const Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
        
      }
    } on DioException catch (e) {
      print('${e.response} - ${e.response?.statusCode}');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Error"),
            content: const Text("Anggota Baru Gagal Ditambahkan. Coba Lagi!"),
            actions: <Widget>[
              MaterialButton(
                child: const Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }
}
