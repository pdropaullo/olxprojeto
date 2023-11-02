import 'package:flutter/material.dart';
import 'package:olxprojeto/pages/AnuncioPage.dart';
import 'package:olxprojeto/pages/LoginPage.dart';

void main() {
  runApp(
    MaterialApp(
      theme: ThemeData(
        primarySwatch: MaterialColor(0xFF9400D3, {
          50: Color(0xFFF5E3FF),
          100: Color(0xFFD3A8FF),
          200: Color(0xFFB97AFF),
          300: Color(0xFF9D4CFF),
          400: Color(0xFF981FFF),
          500: Color(0xFF9400D3),
          600: Color(0xFF8E00C1),
          700: Color(0xFF8800B0),
          800: Color(0xFF82009E),
          900: Color(0xFF760081),
        }),
      ),
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    ),
  );
}
