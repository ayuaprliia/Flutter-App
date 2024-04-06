import 'package:flutter/material.dart';

class GreetingView extends StatefulWidget {
  const GreetingView({super.key});

  @override
  State<GreetingView> createState() => _GreetingViewState();
}

class _GreetingViewState extends State<GreetingView> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child:Text(
          "halo"
          ) ,
        ),
    );
  }
}