import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tugas1/utility/colors.dart';
import 'package:tugas1/views/addAnggota.dart';
import 'package:tugas1/views/addSettingBunga.dart';
import 'package:tugas1/views/anggota.dart';
import 'package:tugas1/views/greeting.dart';
import 'package:tugas1/views/home.dart';
import 'package:tugas1/views/login.dart';
import 'package:tugas1/views/onboarding.dart';
import 'package:tugas1/views/profile.dart';
import 'package:tugas1/views/register.dart';
import 'package:tugas1/views/settingBunga.dart';
import 'package:tugas1/views/transaksi.dart';

void main() async {
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/home': (context) => const HomeView(),
        '/login': (context) => const LoginView(),
        '/register': (context) => const RegisterView(),
        '/greeting': (context) => const GreetingView(),
        '/profile': (context) => const ProfileView(),
        '/community': (context) => const AnggotaView(),
        '/addAnggota': (context) => const AddAnggotaView(),
        '/onboarding': (context) => const OnboardingView(),
        '/transaksi': (context) => const TransaksiView(),
        '/settingBunga': (context) => const ListSettingBungaView(),
        '/addSettingBunga': (context) => const AddSettingBungaView(),
      },
      initialRoute: '/onboarding',
      debugShowCheckedModeBanner: false,
      title: 'tugas1',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: blueColor),
        useMaterial3: true,
      ),
      home: const OnboardingView(),
    );
  }
}
