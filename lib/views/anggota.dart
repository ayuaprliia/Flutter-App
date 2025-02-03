import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:tugas1/utility/colors.dart';

// Model class for Anggota
class Anggota {
  final int id;
  final String nama;
  final String alamat;
  final String telepon;
  final String tanggalLahir;
  final int noInduk;
  final int status_aktif;
  int saldo;

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
  final GetStorage _storage = GetStorage();
  final Dio _dio = Dio();
  final String _apiUrl = 'https://mobileapis.manpits.xyz/api';

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
          _buildHeader(),
          _buildTitleSection(),
          _buildSearchBar(),
          isLoading ? _buildLoadingIndicator() : _buildAnggotaList(),
        ],
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  /// Builds the header section
  Widget _buildHeader() {
    return Container(
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
              const Image(image: AssetImage("assets/images/Logo.png")),
              IconButton(
                onPressed: () => Navigator.pushNamed(context, '/addAnggota'),
                icon: const Icon(Icons.person_add, size: 38, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            "Selamat Datang di \nSignify Community!",
            style: TextStyle(fontFamily: "PoppinsSemiBold", color: Colors.white, fontSize: 24),
          ),
        ],
      ),
    );
  }

  /// Builds the title section
  Widget _buildTitleSection() {
    return const Padding(
      padding: EdgeInsets.fromLTRB(15, 25, 15, 15),
      child: Text(
        'Daftar Anggota',
        style: TextStyle(fontFamily: "PoppinsSemiBold", fontSize: 18, color: Colors.black),
      ),
    );
  }

  /// Builds the search bar
  Widget _buildSearchBar() {
    return TextField(
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
        hintStyle: const TextStyle(fontFamily: "PoppinsRegular", fontSize: 12, color: Colors.grey),
        prefixIcon: const Icon(Icons.search),
      ),
    );
  }

  /// Builds the loading indicator
  Widget _buildLoadingIndicator() {
    return const Center(child: CircularProgressIndicator());
  }

  /// Builds the anggota list
  Widget _buildAnggotaList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: filteredAnggotaList.length,
      itemBuilder: (context, index) {
        final anggota = filteredAnggotaList[index];
        return Padding(
          padding: const EdgeInsets.all(10),
          child: Container(
            decoration: BoxDecoration(color: blueColor, borderRadius: BorderRadius.circular(20)),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              title: Text(anggota.nama, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              subtitle: Text('No Induk: ${anggota.noInduk}', style: const TextStyle(color: Colors.white)),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.paid, color: Colors.white, size: 20),
                  Text(' : Rp ${_formatCurrency(anggota.saldo)}', style: const TextStyle(color: Colors.white)),
                ],
              ),
              onTap: () => Navigator.pushNamed(context, '/community/${anggota.id}'),
            ),
          ),
        );
      },
    );
  }

  /// Builds the bottom navigation bar
  Widget _buildBottomNavBar() {
    return BottomNavigationBar(
      showUnselectedLabels: true,
      iconSize: 32,
      selectedItemColor: Colors.grey,
      selectedFontSize: 18,
      unselectedItemColor: Colors.grey,
      items: [
        _buildNavItem(Icons.home, 'Beranda', '/home'),
        _buildNavItem(Icons.groups, 'Member', '/community'),
        _buildNavItem(Icons.attach_money, 'Bunga', '/settingBunga'),
        _buildNavItem(Icons.person, 'Profil', '/profile'),
      ],
    );
  }

  BottomNavigationBarItem _buildNavItem(IconData icon, String label, String route) {
    return BottomNavigationBarItem(
      icon: IconButton(icon: Icon(icon), onPressed: () => Navigator.pushNamed(context, route)),
      label: label,
    );
  }

  String _formatCurrency(int amount) {
    return NumberFormat('#,###').format(amount);
  }
}
