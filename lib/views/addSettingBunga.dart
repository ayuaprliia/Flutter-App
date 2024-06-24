import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tugas1/utility/colors.dart';

class AddSettingBungaView extends StatefulWidget {
  const AddSettingBungaView({super.key});

  @override
  _AddSettingBungaViewState createState() => _AddSettingBungaViewState();
}

class _AddSettingBungaViewState extends State<AddSettingBungaView> {
  final Dio _dio = Dio();
  final GetStorage _storage = GetStorage();
  final String _apiUrl = 'https://mobileapis.manpits.xyz/api';

  final TextEditingController persenController = TextEditingController();
  String selectedStatus = '1'; // Default value, aktif
  bool isLoading = false;

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
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.arrow_back,
                        size: 30,
                        color: Colors.white,
                      ),
                    ),
                    const Text(
                      "Add Setting Bunga",
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
                  const Text(
                    'Persentase',
                    style:
                        TextStyle(fontFamily: "PoppinsRegular", fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: persenController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      hintText: 'Masukkan Persentase Bunga, misal (1.1)',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Status Bunga',
                    style:
                        TextStyle(fontFamily: "PoppinsRegular", fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    isExpanded: true,
                    value: selectedStatus,
                    items: const [
                      DropdownMenuItem(
                        value: '1',
                        child: Text('Aktif'),
                      ),
                      DropdownMenuItem(
                        value: '0',
                        child: Text('Tidak Aktif'),
                      ),
                    ],
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedStatus = newValue!;
                      });
                    },
                  ),
                  const SizedBox(height: 30, width: 100),
                  Center(
                    child: ElevatedButton(
                      onPressed: () => addSettingBunga(context),
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

  void addSettingBunga(BuildContext context) async {
    final persen = persenController.text;
    final status = selectedStatus;

    if (persen.isEmpty) {
      showErrorDialog(context, 'Masukkan Persen');
      return;
    }

    try {
      setState(() {
        isLoading = true;
      });

      final response = await _dio.post(
        '$_apiUrl/addsettingbunga',
        options: Options(
          headers: {'Authorization': 'Bearer ${_storage.read('token')}'},
        ),
        data: {
          'persen': double.parse(persen),
          'isaktif': int.parse(status),
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
              backgroundColor: blueColor,
              title: const Text(
                "Berhasil!",
                style: TextStyle(color: Colors.white),
              ),
              content: const Text(
                "Setting bunga berhasil ditambahkan",
                style: TextStyle(color: Colors.white),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                    Navigator.pop(context, true); // Go back with result
                  },
                  child: const Text(
                    "OK",
                    style: TextStyle(
                        color: Colors.white, fontFamily: "PoppinsSemiBold"),
                  ),
                ),
              ],
            );
          },
        );
      } else {
        showErrorDialog(context,
            "Gagal menambahkan setting bunga. Periksa kembali persen dan status bunga.");
      }
    } on DioException catch (e) {
      setState(() {
        isLoading = false;
      });
      showErrorDialog(context, 'Terjadi kesalahan: ${e.message}');
    }
  }

  void showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: blueColor,
          title: const Text(
            "Error",
            style: TextStyle(color: Colors.white),
          ),
          content: Text(
            message,
            style: const TextStyle(color: Colors.white),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                "OK",
                style: TextStyle(
                    color: Colors.white, fontFamily: "PoppinsSemiBold"),
              ),
            ),
          ],
        );
      },
    );
  }
}
