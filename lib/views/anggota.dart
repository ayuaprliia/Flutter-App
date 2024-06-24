import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tugas1/utility/colors.dart';

class Anggota {
  final int id;
  final String nama;
  final String alamat;
  final String telepon;
  final String tanggalLahir;
  final int noInduk;
  Anggota({
    required this.id,
    required this.nama,
    required this.alamat,
    required this.telepon,
    required this.tanggalLahir,
    required this.noInduk,
  });

  factory Anggota.fromJson(Map<String, dynamic> json) {
    return Anggota(
      id: json['id'] ?? 0,
      nama: json['nama'] ?? '',
      alamat: json['alamat'] ?? '',
      telepon: json['telepon'] ?? '',
      tanggalLahir: json['tgl_lahir'] ?? '',
      noInduk: json['nomor_induk'] ?? '',
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
                  itemCount: AnggotaList.length,
                  itemBuilder: (context, index) {
                    final anggota = AnggotaList[index];
                    return Padding(
                      padding: const EdgeInsets.all(10),
                      child: ListTile(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        tileColor: blueColor,
                        title: Text(
                          anggota.nama ?? '',
                          style: const TextStyle(color: Colors.white),
                        ),
                        subtitle: Text(
                          anggota.alamat ?? '',
                          style: const TextStyle(color: Colors.white),
                        ),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return Dialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Container(
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color: blueColor,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Center(
                                        child: Text(
                                          anggota.nama ?? '',
                                          style: const TextStyle(
                                            fontSize: 22,
                                            fontFamily: "PoppinsBold",
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      const Divider(color: Colors.grey),
                                      const SizedBox(height: 10),

                                      // Nomor Induk
                                      const Padding(
                                        padding: EdgeInsets.only(top: 10),
                                        child: Text(
                                          "Nomor Induk :",
                                          style: TextStyle(
                                            fontFamily: "PoppinsSemiBold",
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 8),
                                        child: Text(
                                          "${anggota.noInduk}",
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontFamily: "PoppinsRegular",
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),

                                      // Tanggal Lahir
                                      const Padding(
                                        padding: EdgeInsets.only(top: 10),
                                        child: Text(
                                          "Tanggal Lahir :",
                                          style: TextStyle(
                                            fontFamily: "PoppinsSemiBold",
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 8),
                                        child: Text(
                                          anggota.tanggalLahir ?? '',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontFamily: "PoppinsRegular",
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),

                                      // Alamat
                                      const Padding(
                                        padding: EdgeInsets.only(top: 10),
                                        child: Text(
                                          "Alamat :",
                                          style: TextStyle(
                                            fontFamily: "PoppinsSemiBold",
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 8),
                                        child: Text(
                                          anggota.alamat ?? '',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontFamily: "PoppinsRegular",
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),

                                      // Telepon
                                      const Padding(
                                        padding: EdgeInsets.only(top: 10),
                                        child: Text(
                                          "Nomor Telepon :",
                                          style: TextStyle(
                                            fontFamily: "PoppinsSemiBold",
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 8),
                                        child: Text(
                                          anggota.telepon ?? '',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontFamily: "PoppinsRegular",
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      const Divider(color: Colors.grey),
                                      const SizedBox(height: 10),

                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(10),
                                            child: Center(
                                              child: ElevatedButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: const Text("Tutup"),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              color: Colors.white,
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    final noIndukController =
                                        TextEditingController(
                                            text: anggota.noInduk.toString());
                                    final namaController =
                                        TextEditingController(
                                            text: anggota.nama);
                                    final tanggalLahirController =
                                        TextEditingController(
                                            text: anggota.tanggalLahir);
                                    final alamatController =
                                        TextEditingController(
                                            text: anggota.alamat);
                                    final phoneController =
                                        TextEditingController(
                                            text: anggota.telepon);
                                    return Dialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Container(
                                        padding: const EdgeInsets.all(20),
                                        decoration: BoxDecoration(
                                          color: blueColor,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Text(
                                              "Edit Anggota",
                                              style: TextStyle(
                                                  fontSize: 22,
                                                  fontFamily: "PoppinsBold",
                                                  color: Colors.white),
                                            ),
                                            const SizedBox(height: 10),
                                            TextField(
                                              controller: noIndukController,
                                              decoration: const InputDecoration(
                                                labelText: 'Nomor Induk',
                                                labelStyle: TextStyle(
                                                    color: Colors.white),
                                                border: OutlineInputBorder(),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.white),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.white),
                                                ),
                                              ),
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            ),
                                            const SizedBox(height: 10),
                                            TextField(
                                              controller: namaController,
                                              decoration: const InputDecoration(
                                                labelText: 'Nama',
                                                labelStyle: TextStyle(
                                                    color: Colors.white),
                                                border: OutlineInputBorder(),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.white),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.white),
                                                ),
                                              ),
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            ),
                                            const SizedBox(height: 10),
                                            TextField(
                                              controller:
                                                  tanggalLahirController,
                                              decoration: const InputDecoration(
                                                labelText: 'Tanggal Lahir',
                                                labelStyle: TextStyle(
                                                    color: Colors.white),
                                                border: OutlineInputBorder(),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.white),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.white),
                                                ),
                                              ),
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            ),
                                            const SizedBox(height: 10),
                                            TextField(
                                              controller: alamatController,
                                              decoration: const InputDecoration(
                                                labelText: 'Alamat',
                                                labelStyle: TextStyle(
                                                    color: Colors.white),
                                                border: OutlineInputBorder(),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.white),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.white),
                                                ),
                                              ),
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            ),
                                            const SizedBox(height: 10),
                                            TextField(
                                              controller: phoneController,
                                              decoration: const InputDecoration(
                                                labelText: 'Telepon',
                                                labelStyle: TextStyle(
                                                    color: Colors.white),
                                                border: OutlineInputBorder(),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.white),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.white),
                                                ),
                                              ),
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            ),
                                            const SizedBox(height: 20),
                                            ElevatedButton(
                                              onPressed: () {
                                                goEditAnggota(
                                                  context,
                                                  noIndukController.text,
                                                  namaController.text,
                                                  tanggalLahirController.text,
                                                  alamatController.text,
                                                  phoneController.text,
                                                  anggota.id,
                                                );
                                              },
                                              child: const Text("Perbarui"),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              color: Colors.white,
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      content: const Text(
                                          "Apakah Anda Yakin Untuk Menghapus Anggota ini?"),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('Batal'),
                                        ),
                                        TextButton(
                                          onPressed: () async {
                                            deleteAnggota(anggota.id);
                                            getAnggotaList();
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('Hapus'),
                                        ),
                                      ],
                                    );
                                  },
                                );
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
              icon: const Icon(Icons.groups),
              onPressed: () {
                Navigator.pushNamed(context, '/community');
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
                      "tgl_lahir": AnggotaJson["tgl_lahir"],
                      "telepon": AnggotaJson["telepon"],
                      "nomor_induk": AnggotaJson["nomor_induk"],
                    }))
                .toList();
          });
        }
      } else {
        print('Error: API request failed: ${response.statusCode}');
      }
    } on DioException catch (e) {
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

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Detail Anggota"),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("No Induk: ${selectedAnggota.noInduk}"),
                  Text("Nama: ${selectedAnggota.nama}"),
                  Text("Alamat: ${selectedAnggota.alamat}"),
                  Text("No Telepon: ${selectedAnggota.telepon}"),
                  Text("Tanggal Lahir: ${selectedAnggota.tanggalLahir}"),
                ],
              ),
              actions: [
                Column(
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Tutup"),
                    ),
                  ],
                ),
              ],
            );
          },
        );
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

      if (response.statusCode != 200) {
        print('Error deleting Anggota: ${response.statusCode}');
      }
    } on DioError catch (e) {
      print('Terjadi kesalahan: ${e.message}');
    }
  }

  void goEditAnggota(BuildContext context, noInduk, nama, tanggalLahir, alamat,
      phone, id) async {
    try {
      final response = await _dio.put(
        '$_apiUrl/anggota/$id',
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
      _storage.write('data', response.data['data']);
      if (response.statusCode == 200) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Berhasil"),
              content: const Text("Data Anggota Berhasil DIperbarui!"),
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
              content: const Text("Data Anggota Gagal Diperbarui. Coba Lagi!"),
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
            content: const Text("Data Anggota Gagal Diperbarui. Coba Lagi!"),
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
