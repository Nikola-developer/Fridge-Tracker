import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hylastix_fridge/pages/items_list_page.dart';
import 'package:hylastix_fridge/theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late Timer timer;

  @override
  void initState() {
    super.initState();

    // Load data before starting app
    timer = Timer(Duration(seconds: 1), () {
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (context) => ItemsPage()));
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/logo.png'),
            Text(
              'Hylastix Fridge',
              style: Theme.of(
                context,
              ).textTheme.headlineLarge?.copyWith(color: colorWhite),
            ),
          ],
        ),
      ),
    );
  }
}
