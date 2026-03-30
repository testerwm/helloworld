
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: false, // 使用 Material 2
        primarySwatch: Colors.green,
      ),
      home: Scaffold(
        appBar: AppBar(
          actions: [
            Icon(Icons.shopping_cart),
            SizedBox(width: 10),
            Icon(Icons.search_rounded, color: Colors.redAccent),
            SizedBox(width: 10),
            Icon(Icons.settings, color: Colors.purple),
            SizedBox(width: 40)
          ],
          title: const Text('Welcome to Flutter-왕명',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white
              )
          ),
        ),
        body: Center(
          child: Text('Hello World', style: GoogleFonts.aladin(
            fontSize: 48,
            fontWeight: FontWeight.w700,
            fontStyle: FontStyle.italic,
              color: Colors.purple
          )),
        ),
      ),
    );
  }
}