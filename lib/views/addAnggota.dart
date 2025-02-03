import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:tugas1/utility/colors.dart';

class AddAnggotaView extends StatefulWidget {
  const AddAnggotaView({super.key});

  @override
  State<AddAnggotaView> createState() => _AddAnggotaViewState();
}

class _AddAnggotaViewState extends State<AddAnggotaView> {
  final Dio _dio = Dio();
  final GetStorage _storage = GetStorage();
  final String _apiUrl = 'https://mobileapis.manpits.xyz/api';

  // Controllers for input fields
  final TextEditingController noIndukController = TextEditingController();
  final TextEditingController namaController = TextEditingController();
  final TextEditingController tanggalLahirController = TextEditingController();
  final TextEditingController alamatController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: blueColor),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 30),
            _buildTextField('Nomor Induk', 'Nomor Induk', noIndukController),
            _buildTextField('Nama Lengkap', 'Nama Lengkap', namaController),
            _buildTextField('Alamat', 'Alamat', alamatController),
            _buildDateField(context),
            _buildTextField('No HP', 'No HP', phoneController),
            const SizedBox(height: 40),
            _buildSubmitButton(context),
          ],
        ),
      ),
      backgroundColor: Colors.white,
    );
  }

  /// Builds the header text
  Widget _buildHeader() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tambahkan Anggota pada Komunitas',
          style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        Text(
          'Masukkan Data Pribadi!',
          style: TextStyle(fontSize: 16, color: Colors.black),
        ),
      ],
    );
  }

  /// Builds standard text field
  Widget _buildTextField(String label, String hint, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 13, color: Colors.black)),
          SizedBox(
            width: double.infinity,
            height: 40,
            child: TextField(
              controller: controller,
              decoration: InputDecoration(hintText: hint, border: const OutlineInputBorder()),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the date picker field
  Widget _buildDateField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Tanggal Lahir', style: TextStyle(fontSize: 13, color: Colors.black)),
          SizedBox(
            width: double.infinity,
            height: 40,
            child: TextFormField(
              controller: tanggalLahirController,
              readOnly: true,
              decoration: InputDecoration(
                hintText: 'TTTT-BB-HH',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () => _selectDate(context),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Displays the date picker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
        tanggalLahirController.text = DateFormat('yyyy-MM-dd').format(selectedDate);
      });
    }
  }

  /// Builds the submit button
  Widget _buildSubmitButton(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 270,
        height: 50,
        child: ElevatedButton(
          onPressed: () => _goAddAnggota(context),
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            backgroundColor: blueColor,
          ),
          child: const Text('Tambahkan Sebagai Anggota', style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }

  /// Handles adding a new member
  Future<void> _goAddAnggota(BuildContext context) async {
    bool confirm = await _showConfirmationDialog(context);
    if (!confirm) return;

    try {
      final response = await _dio.post(
        '$_apiUrl/anggota',
        options: Options(headers: {'Authorization': 'Bearer ${_storage.read('token')}'}),
        data: {
          'nomor_induk': noIndukController.text,
          'nama': namaController.text,
          'alamat': alamatController.text,
          'tgl_lahir': tanggalLahirController.text,
          'telepon': phoneController.text,
          'status_aktif': 1,
        },
      );
      
      _storage.write('data', response.data['data']);
      _showResultDialog(context, response.statusCode == 200);
    } catch (e) {
      _showResultDialog(context, false);
    }
  }

  /// Displays a confirmation dialog
  Future<bool> _showConfirmationDialog(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Konfirmasi"),
        content: const Text("Apakah Anda yakin ingin menambahkan anggota ini?"),
        actions: [
          TextButton(child: const Text("Cancel"), onPressed: () => Navigator.of(context).pop(false)),
          TextButton(child: const Text("OK"), onPressed: () => Navigator.of(context).pop(true)),
        ],
      ),
    ) ?? false;
  }

  /// Displays a result dialog
  void _showResultDialog(BuildContext context, bool success) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(success ? "Berhasil" : "Error"),
        content: Text(success ? "Anggota Baru Berhasil Ditambahkan!" : "Anggota Baru Gagal Ditambahkan. Coba Lagi!"),
        actions: [
          TextButton(
            child: const Text("OK"),
            onPressed: () {
              Navigator.of(context).pop();
              if (success) Navigator.pushNamed(context, '/community');
            },
          ),
        ],
      ),
    );
  }
}
