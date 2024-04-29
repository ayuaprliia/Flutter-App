import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tugas1/utility/colors.dart';
import 'package:tugas1/views/greeting.dart';
import 'package:tugas1/views/home.dart';
import 'package:tugas1/views/login.dart';
import 'package:tugas1/views/onboarding.dart';
import 'package:tugas1/views/profile.dart';
import 'package:tugas1/views/register.dart';

void main() async {
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/home': (context) => const HomeView(),
        '/login': (context) => LoginView(),
        '/register': (context) => const RegisterView(),
        '/greeting': (context) => const GreetingView(),
        '/profile': (context) => const ProfileView(),
      },
      initialRoute: '/',
      debugShowCheckedModeBanner: false,
      title: 'tugas1',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: blueColor),
        useMaterial3: true,
      ),
      home:  const OnboardingView(),
    );
  }
}
