import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tugas1/utility/colors.dart';

class InsertTransaksiView extends StatefulWidget {
  final int anggotaId;
  final String anggotaNama;
  const InsertTransaksiView(
      {super.key, required this.anggotaId, required this.anggotaNama});

  @override
  _InsertTransaksiViewState createState() => _InsertTransaksiViewState();
}

class _InsertTransaksiViewState extends State<InsertTransaksiView> {
  final Dio _dio = Dio();
  final GetStorage _storage = GetStorage();
  final String _apiUrl = 'https://mobileapis.manpits.xyz/api';

  final TextEditingController trxNominalController = TextEditingController();
  bool isLoading = false;
  int? selectedTrxId;
  List<Map<String, dynamic>> trxList = [];

  @override
  void initState() {
    super.initState();
    fetchTrxList();
  }

  Future<void> fetchTrxList() async {
    try {
      final response = await _dio.get(
        '$_apiUrl/jenistransaksi', // Sesuaikan dengan endpoint API Anda
        options: Options(
          headers: {'Authorization': 'Bearer ${_storage.read('token')}'},
        ),
      );

      if (response.statusCode == 200) {
        setState(() {
          trxList = List<Map<String, dynamic>>.from(
              response.data['data']['jenistransaksi']);
          selectedTrxId = trxList.isNotEmpty ? trxList[0]['id'] : null;
        });
      } else {
        throw Exception('Failed to load transaction types');
      }
    } catch (e) {
      showErrorDialog(context, 'Failed to load transaction types: $e');
    }
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/transaksi');
                      },
                      icon: const Icon(
                        Icons.arrow_back,
                        size: 30,
                        color: Colors.white,
                      ),
                    ),
                    const Text(
                      "Insert Transaksi ",
                      style: TextStyle(
                        fontFamily: "PoppinsSemiBold",
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Center(
                    child: Text(
                      widget.anggotaNama,
                      style: TextStyle(
                          fontFamily: "PoppinsSemiBold",
                          fontSize: 26,
                          color: blueColor),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: Text(
                      'ID : ${widget.anggotaId}',
                      style: TextStyle(
                          fontSize: 16,
                          fontFamily: "PoppinsSemiBold",
                          color: blueColor),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Divider(color: Colors.grey),
                  const SizedBox(height: 20),
                  const Text(
                    'Jenis Transaksi',
                    style:
                        TextStyle(fontFamily: "PoppinsRegular", fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  DropdownButton<int>(
                    isExpanded: true,
                    value: selectedTrxId,
                    hint: const Text('Pilih Jenis Transaksi'),
                    items: trxList.map((Map<String, dynamic> trx) {
                      return DropdownMenuItem<int>(
                        value: trx['id'],
                        child: Text('${trx['id']} - ${trx['trx_name']}'),
                      );
                    }).toList(),
                    onChanged: (int? newValue) {
                      setState(() {
                        selectedTrxId = newValue;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Nominal Transaksi',
                    style:
                        TextStyle(fontFamily: "PoppinsRegular", fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: trxNominalController,
                    decoration: InputDecoration(
                      hintText: 'Masukkan Nominal Transaksi',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30, width: 100),
                  Center(
                    child: ElevatedButton(
                      onPressed: () => insertTransaksiTabungan(context),
                      child: const Text('Submit'),
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (isLoading)
                    Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(blueColor),
                        strokeWidth: 3,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void insertTransaksiTabungan(BuildContext context) async {
    final trxId = selectedTrxId;
    final trxNominal = trxNominalController.text;

    if (trxId == null) {
      showErrorDialog(context, 'Pilih Jenis Transaksi');
      return;
    }

    try {
      setState(() {
        isLoading = true;
      });

      final response = await _dio.post(
        '$_apiUrl/tabungan',
        options: Options(
          headers: {'Authorization': 'Bearer ${_storage.read('token')}'},
        ),
        data: {
          'anggota_id': widget.anggotaId,
          'trx_id': trxId,
          'trx_nominal': trxNominal,
        },
      );

      setState(() {
        isLoading = false;
      });

      if (response.statusCode == 200) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Berhasil!"),
              content: const Text("Transaksi Berhasil Ditambahkan"),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                  child: const Text("OK"),
                ),
              ],
            );
          },
        );
      } else {
        showErrorDialog(context,
            "Transaksi Gagal, Mohon Periksa Kembali Jenis Transaksi dan Nominal Transaksi");
      }
    } on DioError catch (e) {
      setState(() {
        isLoading = false;
      });
      String errorMessage =
          'Transaksi Gagal, Mohon Periksa Kembali Jenis Transaksi dan Nominal Transaksi';
      if (e.response?.statusCode == 409) {
        errorMessage = 'Transaction already exists.';
      }
      showErrorDialog(context, errorMessage);
    }
  }

  void showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Error"),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }
}
