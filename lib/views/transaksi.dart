import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tugas1/utility/colors.dart';

import 'insertTransaksi.dart';

class AnggotaList {
  final int id;
  final String nama;

  AnggotaList({
    required this.id,
    required this.nama,
  });

  factory AnggotaList.fromJson(Map<String, dynamic> json) {
    return AnggotaList(
      id: json['id'] ?? 0,
      nama: json['nama'] ?? '',
    );
  }
}

class Tabungan {
  final int id;
  final String trxTanggal;
  final int trxId;
  final int trxNominal;

  Tabungan({
    required this.id,
    required this.trxTanggal,
    required this.trxId,
    required this.trxNominal,
  });

  factory Tabungan.fromJson(Map<String, dynamic> json) {
    return Tabungan(
      id: json['id'] ?? 0,
      trxTanggal: json['trx_tanggal'] ?? '',
      trxId: json['trx_id'] ?? 0,
      trxNominal: json['trx_nominal'] ?? 0,
    );
  }
}

class TransaksiView extends StatefulWidget {
  const TransaksiView({super.key});

  @override
  State<TransaksiView> createState() => _TransaksiViewState();
}

class _TransaksiViewState extends State<TransaksiView> {
  final _storage = GetStorage();
  final _dio = Dio();
  final _apiUrl = 'https://mobileapis.manpits.xyz/api';

  Future<List<AnggotaList>> getAnggotaList() async {
    try {
      final response = await _dio.get(
        '$_apiUrl/anggota',
        options: Options(
          headers: {'Authorization': 'Bearer ${_storage.read('token')}'},
        ),
      );

      if (response.statusCode == 200) {
        final responseData = response.data;
        final AnggotaData = responseData['data']['anggotas'];
        if (AnggotaData is List) {
          return AnggotaData.map((AnggotaJson) => AnggotaList.fromJson({
                "id": AnggotaJson["id"],
                "nama": AnggotaJson["nama"],
              })).toList();
        } else {
          throw Exception('Jenis Transaksi Tidak Ditemukan');
        }
      } else {
        throw Exception(
            'Error: API request failed with status: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Terjadi kesalahan: ${e.message}');
    }
  }

  Future<List<Tabungan>> getListTabungan(int anggotaId) async {
    try {
      final response = await _dio.get(
        '$_apiUrl/tabungan/$anggotaId',
        options: Options(
          headers: {'Authorization': 'Bearer ${_storage.read('token')}'},
        ),
      );

      if (response.statusCode == 200) {
        final responseData = response.data;
        final TabunganData = responseData['data']['tabungan'];
        if (TabunganData is List) {
          return TabunganData.map((TabunganJson) => Tabungan.fromJson({
                "id": TabunganJson["id"],
                "trx_tanggal": TabunganJson["trx_tanggal"],
                "trx_id": TabunganJson["trx_id"],
                "trx_nominal": TabunganJson["trx_nominal"],
                "trx_name": TabunganJson["trx_name"],
              })).toList();
        } else {
          throw Exception('Tabungan Tidak Ditemukan');
        }
      } else {
        throw Exception(
            'Error: API request failed with status: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Terjadi kesalahan: ${e.message}');
    }
  }

  void showMenuDialog(BuildContext context, AnggotaList anggota) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: blueColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  anggota.nama,
                  style: const TextStyle(color: Colors.white, fontSize: 20),
                ),
                const SizedBox(height: 10),
                const Divider(color: Colors.grey),
                const SizedBox(height: 20),
                ListTile(
                  leading: const Icon(Icons.add_card, color: Colors.white),
                  title: const Text(
                    'Insert transaksi',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => InsertTransaksiView(
                          anggotaId: anggota.id,
                          anggotaNama: anggota.nama,
                        ),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.account_balance_wallet,
                      color: Colors.white),
                  title: const Text(
                    'Lihat saldo',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    _showSaldoDialog(context, anggota);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.wallet, color: Colors.white),
                  title: const Text(
                    'Lihat Semua Tabungan',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    _showTabunganDialog(context, anggota);
                  },
                ),
                const SizedBox(height: 20),
                TextButton(
                  child: const Text('Close',
                      style: TextStyle(
                          color: Colors.white, fontFamily: "PoppinsSemiBold")),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showSaldoDialog(BuildContext context, AnggotaList anggota) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: blueColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Saldo Anggota',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontFamily: "PoppinsSemiBold"),
                ),
                const SizedBox(height: 10),
                const Divider(color: Colors.grey),
                const SizedBox(height: 20),
                Text(
                  'Nama Anggota: ${anggota.nama}',
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 10),
                Text(
                  'ID Anggota: ${anggota.id}',
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 10),
                FutureBuilder<int>(
                  future: _getSaldo(anggota.id),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text(
                        'Error: ${snapshot.error}',
                        style: const TextStyle(color: Colors.red),
                      );
                    } else if (snapshot.hasData) {
                      return Text(
                        'Saldo: Rp ${snapshot.data}',
                        style: const TextStyle(
                            color: Colors.white, fontFamily: "PoppinsSemiBold"),
                      );
                    } else {
                      return const Text(
                        'Tidak ada data',
                        style: TextStyle(color: Colors.white),
                      );
                    }
                  },
                ),
                const SizedBox(height: 20),
                TextButton(
                  child: const Text('Close',
                      style: TextStyle(
                          color: Colors.white, fontFamily: "PoppinsSemiBold")),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<int> _getSaldo(int anggotaId) async {
    final Dio dio = Dio();
    final GetStorage storage = GetStorage();
    const String apiUrl = 'https://mobileapis.manpits.xyz/api';
    try {
      final response = await dio.get(
        '$apiUrl/saldo/$anggotaId',
        options: Options(
          headers: {'Authorization': 'Bearer ${storage.read('token')}'},
        ),
      );

      if (response.statusCode == 200) {
        final responseData = response.data;
        return responseData['data']['saldo'];
      } else {
        throw Exception('Failed to load saldo');
      }
    } catch (e) {
      throw Exception('Failed to load saldo: $e');
    }
  }

  void _showTabunganDialog(BuildContext context, AnggotaList anggota) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: blueColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'List Tabungan',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontFamily: "PoppinsSemiBold"),
                ),
                const SizedBox(height: 10),
                const Divider(color: Colors.grey),
                const SizedBox(height: 20),
                Text(
                  'Nama Anggota: ${anggota.nama}',
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 10),
                Text(
                  'ID Anggota: ${anggota.id}',
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 10),
                FutureBuilder<List<Tabungan>>(
                  future: getListTabungan(anggota.id),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text(
                        'Error: ${snapshot.error}',
                        style: const TextStyle(color: Colors.red),
                      );
                    } else if (snapshot.hasData) {
                      final tabunganList = snapshot.data!;
                      if (tabunganList.isEmpty) {
                        return const Text(
                          'Tidak Ada List Tabungan',
                          style: TextStyle(color: Colors.white),
                        );
                      } else {
                        return Expanded(
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: tabunganList.length,
                            itemBuilder: (context, index) {
                              final tabungan = tabunganList[index];
                              return Container(
                                margin: const EdgeInsets.symmetric(vertical: 5),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.white),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: ListTile(
                                  title: Text(
                                    'Tanggal: ${tabungan.trxTanggal}',
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'ID Transaksi: ${tabungan.trxId}',
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                      Text(
                                        'Nominal: Rp ${tabungan.trxNominal}',
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      }
                    } else {
                      return const Text(
                        'Tidak Ada List Tabungan',
                        style: TextStyle(color: Colors.white),
                      );
                    }
                  },
                ),
                const SizedBox(height: 20),
                TextButton(
                  child: const Text('Close',
                      style: TextStyle(
                          color: Colors.white, fontFamily: "PoppinsSemiBold")),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
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
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                Padding(
                  padding: EdgeInsets.only(bottom: 15),
                  child: Row(
                    children: [
                      Text(
                        "Selamat Datang di \nMenu Transaksi!",
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
                  'Silahkan Pilih Satu Member untuk\n Melakukan Transaksi',
                  style: TextStyle(
                    fontFamily: "PoppinsSemiBold",
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<AnggotaList>>(
              future: getAnggotaList(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  final JenisTransaksiList = snapshot.data!;
                  return ListView.builder(
                    itemCount: JenisTransaksiList.length,
                    itemBuilder: (context, index) {
                      final Anggota = JenisTransaksiList[index];
                      return Padding(
                        padding: const EdgeInsets.all(10),
                        child: ListTile(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          tileColor: blueColor,
                          title: Text(
                            Anggota.nama,
                            style: const TextStyle(color: Colors.white),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.menu, color: Colors.white),
                            onPressed: () {
                              showMenuDialog(context, Anggota);
                            },
                          ),
                          onTap: () {},
                        ),
                      );
                    },
                  );
                } else {
                  return const Center(child: Text('Tidak ada data'));
                }
              },
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
                Navigator.pushNamed(context, '/profile');
              },
            ),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}
