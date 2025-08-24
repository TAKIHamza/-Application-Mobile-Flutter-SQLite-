import 'package:flutter/material.dart';
import 'package:ifsan/views/login_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IFSANE',
      debugShowCheckedModeBanner: false,
      
     theme: ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Color.fromARGB(255, 4, 171, 160),
      brightness: Brightness.light,
    ),
   
  ),
      home: LoginPage(), // Définir la page d'accueil de votre application
    );
  }
}
