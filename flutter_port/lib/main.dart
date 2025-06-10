import 'package:flutter/material.dart';
import 'package:portfolio_second/core/theme/app_theme.dart';
import 'package:portfolio_second/presentation/pages/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pranay Shah - Portfolio',
      //theme: AppTheme.darkTheme,
      //theme: AppTheme.lightTheme, // Use the light theme
      theme: AppTheme.portfolioLightTheme, // Use the light theme
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}