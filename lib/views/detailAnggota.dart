import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:tugas1/utility/colors.dart';
import 'package:tugas1/views/anggota.dart';
import 'package:tugas1/views/insertTransaksi.dart';
import 'package:tugas1/views/transaksi.dart';

class DetailAnggotaView extends StatefulWidget {
  final int id;

  const DetailAnggotaView({super.key, required this.id});

  @override
  _DetailAnggotaViewState createState() => _DetailAnggotaViewState();
}

class _DetailAnggotaViewState extends State<DetailAnggotaView> {
  final _storage = GetStorage();
  final _dio = Dio();
  final _apiUrl = 'https://mobileapis.manpits.xyz/api';
  Anggota? anggota; // Initialize anggota as nullable
  bool _statusAktif = true; // Default anggota's status
  int _saldo = 0; // Variable to hold saldo value

  @override
  void initState() {
    super.initState();
    getAnggotaDetailById(
        widget.id); // Fetch anggota details when the widget initializes
    fetchSaldo(); // Fetch saldo when the widget initializes
  }

  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    if (anggota == null) {
      return const Scaffold(
        body: Center(
          child:
              CircularProgressIndicator(), // Show loading indicator while data is being fetched
        ),
      );
    }

    String statusAktifText =
        _statusAktif ? 'Anggota Aktif' : 'Anggota Non-Aktif';
    Color statusColor = _statusAktif ? Colors.green : Colors.red;

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
                    IconButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, "/community");
                      },
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                final noIndukController = TextEditingController(
                                    text: anggota!.noInduk.toString());
                                final namaController =
                                    TextEditingController(text: anggota!.nama);
                                final tanggalLahirController =
                                    TextEditingController(
                                        text: anggota!.tanggalLahir);
                                final alamatController = TextEditingController(
                                    text: anggota!.alamat);
                                final phoneController = TextEditingController(
                                    text: anggota!.telepon);
                                return Dialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: StatefulBuilder(
                                    builder: (BuildContext context,
                                        StateSetter setState) {
                                      return Container(
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
                                                color: Colors.white,
                                              ),
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
                                            TextFormField(
                                              controller:
                                                  tanggalLahirController,
                                              readOnly: true,
                                              decoration: InputDecoration(
                                                labelText: 'Tanggal Lahir',
                                                labelStyle: const TextStyle(
                                                    color: Colors.white),
                                                border:
                                                    const OutlineInputBorder(),
                                                enabledBorder:
                                                    const OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.white),
                                                ),
                                                focusedBorder:
                                                    const OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.white),
                                                ),
                                                suffixIcon: IconButton(
                                                  icon: const Icon(
                                                    Icons.calendar_today,
                                                    color: Colors.white,
                                                  ),
                                                  onPressed: () async {
                                                    final DateTime? pickedDate =
                                                        await showDatePicker(
                                                      context: context,
                                                      initialDate: selectedDate,
                                                      firstDate: DateTime(1900),
                                                      lastDate: DateTime.now(),
                                                    );
                                                    if (pickedDate != null &&
                                                        pickedDate !=
                                                            selectedDate) {
                                                      setState(() {
                                                        selectedDate =
                                                            pickedDate;
                                                        tanggalLahirController
                                                            .text = DateFormat(
                                                                'yyyy-MM-dd')
                                                            .format(
                                                                selectedDate);
                                                      });
                                                    }
                                                  },
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
                                            const SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context)
                                                        .pop(); // Close the dialog
                                                  },
                                                  child: const Text(
                                                    "Batal",
                                                    style: TextStyle(
                                                      fontFamily:
                                                          "PoppinsSemiBold",
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 20),
                                                  child: ElevatedButton(
                                                    onPressed: () {
                                                      showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return AlertDialog(
                                                            content: const Text(
                                                                "Apakah Anda yakin ingin memperbarui data anggota ini?"),
                                                            actions: <Widget>[
                                                              TextButton(
                                                                onPressed: () {
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop(); // Close the dialog
                                                                },
                                                                child:
                                                                    const Text(
                                                                        'Batal'),
                                                              ),
                                                              ElevatedButton(
                                                                onPressed: () {
                                                                  goEditAnggota(
                                                                    context,
                                                                    noIndukController
                                                                        .text,
                                                                    namaController
                                                                        .text,
                                                                    tanggalLahirController
                                                                        .text,
                                                                    alamatController
                                                                        .text,
                                                                    phoneController
                                                                        .text,
                                                                    anggota!.id,
                                                                  );
                                                                  getAnggotaDetailById(
                                                                      widget
                                                                          .id);
                                                                },
                                                                child:
                                                                    const Text(
                                                                        'Yakin'),
                                                              ),
                                                            ],
                                                          );
                                                        },
                                                      );
                                                    },
                                                    child:
                                                        const Text("Perbarui"),
                                                  ),
                                                )
                                              ],
                                            ),
                                            const SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                const Text(
                                                  "Status Aktif:",
                                                  style: TextStyle(
                                                    fontFamily:
                                                        "PoppinsSemiBold",
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                Switch(
                                                  value: _statusAktif,
                                                  activeColor: Colors.green,
                                                  inactiveTrackColor:
                                                      Colors.red,
                                                  onChanged: (newValue) {
                                                    setState(() {
                                                      _statusAktif = newValue;
                                                    });
                                                  },
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                );
                              },
                            );
                          },
                          icon: const Icon(
                            Icons.edit,
                            size: 38,
                            color: Colors.white,
                          ),
                        ),
                        IconButton(
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
                                        await deleteAnggota(anggota!.id);
                                        Navigator.of(context)
                                            .pop(); // Close the dialog
                                        Navigator.pushReplacementNamed(context,
                                            '/community'); // Navigate to /community page
                                      },
                                      child: const Text('Hapus'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          icon: const Icon(
                            Icons.delete,
                            size: 38,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 15),
                      child: Text(
                        anggota!.nama,
                        style: const TextStyle(
                          fontFamily: "PoppinsSemiBold",
                          color: Colors.white,
                          fontSize: 24,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          //show saldo
          const SizedBox(height: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          const Icon(Icons.paid,
                              color: Color.fromARGB(243, 255, 199, 59)),
                          const SizedBox(width: 5),
                          Text(
                            NumberFormat.currency(
                                    locale: 'id_ID', symbol: 'Rp ')
                                .format(_saldo),
                            style: const TextStyle(
                              fontFamily: "PoppinsSemiBold",
                              color: Colors.black,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Visibility(
                    visible: _statusAktif,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => InsertTransaksiView(
                                anggotaId: anggota!.id,
                                anggotaNama: anggota!.nama,
                              ),
                            ),
                          );
                        },
                        child: const Text("Tambah Transaksi"),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: statusColor,
                  ),
                  child: Text(
                    statusAktifText,
                    style: const TextStyle(
                      color: Colors.white,
                      fontFamily: 'PoppinsRegular',
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Card(
              elevation: 5,
              color: blueColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      title: const Text(
                        'Nomor Induk',
                        style: TextStyle(
                          fontFamily: "PoppinsSemiBold",
                          color: Colors.white,
                        ),
                      ),
                      subtitle: Text(
                        anggota!.noInduk.toString(),
                        style: const TextStyle(
                          fontFamily: "PoppinsRegular",
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const Divider(
                      height: 4,
                      color: Colors.transparent,
                    ),
                    ListTile(
                      title: const Text(
                        'Alamat',
                        style: TextStyle(
                          fontFamily: "PoppinsSemiBold",
                          color: Colors.white,
                        ),
                      ),
                      subtitle: Text(
                        anggota!.alamat,
                        style: const TextStyle(
                          fontFamily: "PoppinsRegular",
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const Divider(
                      height: 4,
                      color: Colors.transparent,
                    ),
                    ListTile(
                      title: const Text(
                        'Nomor Telepon',
                        style: TextStyle(
                          fontFamily: "PoppinsSemiBold",
                          color: Colors.white,
                        ),
                      ),
                      subtitle: Text(
                        anggota!.telepon,
                        style: const TextStyle(
                          fontFamily: "PoppinsRegular",
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const Divider(
                      height: 4,
                      color: Colors.transparent,
                    ),
                    ListTile(
                      title: const Text(
                        'Tanggal Lahir',
                        style: TextStyle(
                          fontFamily: "PoppinsSemiBold",
                          color: Colors.white,
                        ),
                      ),
                      subtitle: Text(
                        anggota!.tanggalLahir,
                        style: const TextStyle(
                          fontFamily: "PoppinsRegular",
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Riwayat Transaksi",
                  style: TextStyle(
                    fontFamily: "PoppinsSemiBold",
                    color: Colors.black,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Tabungan>>(
              future: getListTabungan(anggota!.id),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                      child: Text('Error: ${snapshot.error.toString()}'));
                } else if (snapshot.hasData) {
                  List<Tabungan> tabunganList = snapshot.data!;
                  return ListView.builder(
                    itemCount: tabunganList.length,
                    itemBuilder: (context, index) {
                      Tabungan tabungan = tabunganList[index];
                      // adding the Rp format
                      String formattedNominal = NumberFormat.currency(
                        locale: 'id_ID',
                        symbol: 'Rp ',
                      ).format(tabungan.trxNominal);

                      return Card(
                        elevation: 3,
                        margin: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 10),
                        child: ListTile(
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Jenis transaksi: ${_trxName(tabungan.trxId)}',
                                style: const TextStyle(
                                  fontFamily: "PoppinsRegular",
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Tanggal transaksi: ${tabungan.trxTanggal}',
                                style: const TextStyle(
                                  fontFamily: "PoppinsRegular",
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Nominal transaksi: $formattedNominal',
                                style: const TextStyle(
                                  fontFamily: "PoppinsRegular",
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return const Center(child: Text('Tidak ada data transaksi'));
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> getAnggotaDetailById(int id) async {
    try {
      final response = await _dio.get(
        '$_apiUrl/anggota/$id',
        options: Options(
          headers: {'Authorization': 'Bearer ${_storage.read('token')}'},
        ),
      );

      if (response.statusCode == 200) {
        final responseData = response.data;
        final userData = responseData['data']['anggota'];
        if (userData != null) {
          setState(() {
            anggota = Anggota.fromJson(userData);
            _statusAktif = anggota!.status_aktif == 1;
          });
        }
      } else {
        print('Error: API request failed: ${response.statusCode}');
      }
    } on DioError catch (e) {
      print('Terjadi kesalahan: ${e.message}');
    }
  }

  Future<void> fetchSaldo() async {
    try {
      final response = await _dio.get(
        '$_apiUrl/saldo/${widget.id}',
        options: Options(
          headers: {'Authorization': 'Bearer ${_storage.read('token')}'},
        ),
      );

      if (response.statusCode == 200) {
        final responseData = response.data;
        setState(() {
          _saldo = responseData['data']['saldo'];
        });
      } else {
        throw Exception('Failed to load saldo');
      }
    } catch (e) {
      throw Exception('Failed to load saldo: $e');
    }
  }

  void goEditAnggota(BuildContext context, String noInduk, String nama,
      String tanggalLahir, String alamat, String phone, int id) async {
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
          'status_aktif': _statusAktif,
        },
      );

      if (response.statusCode == 200) {
        Navigator.pop(context);
        Navigator.pop(context);
        final responseData = response.data;
        final message = responseData['message'];
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        print('Error: API request failed: ${response.statusCode}');
      }
    } on DioError catch (e) {
      print('Terjadi kesalahan: ${e.message}');
    }
  }

  Future<void> deleteAnggota(int id) async {
    try {
      final response = await _dio.delete(
        '$_apiUrl/anggota/$id',
        options: Options(
          headers: {'Authorization': 'Bearer ${_storage.read('token')}'},
        ),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Anggota berhasil dihapus'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        print('Error deleting Anggota: ${response.statusCode}');
      }
    } on DioError catch (e) {
      print('Terjadi kesalahan: ${e.message}');
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
        final tabunganData = responseData['data']['tabungan'];
        if (tabunganData is List) {
          return tabunganData
              .map((tabunganJson) => Tabungan.fromJson({
                    "id": tabunganJson["id"],
                    "trx_tanggal": tabunganJson["trx_tanggal"],
                    "trx_id": tabunganJson["trx_id"],
                    "trx_nominal": tabunganJson["trx_nominal"],
                    "trx_name": tabunganJson["trx_name"],
                  }))
              .toList();
        } else {
          throw Exception('Tabungan Tidak Ditemukan');
        }
      } else {
        throw Exception(
            'Error: API request failed with status: ${response.statusCode}');
      }
    } on DioError catch (e) {
      throw Exception('Terjadi kesalahan: ${e.message}');
    }
  }
}

String _trxName(int trxId) {
  String name = "";
  switch (trxId) {
    case 1:
      name = "Saldo Awal";
      break;
    case 2:
      name = "Simpanan";
    case 3:
      name = "Penarikan";
      break;
    case 4:
      name = "Bunga Simpanan";
      break;
    case 5:
      name = "Koreksi Penambahan";
      break;
    case 6:
      name = "Koreksi Pengurangan";
      break;
  }
  return name;
}
