import 'package:flutter/material.dart';
import 'package:pbl_mobile_next/pages/tambah_tugas_dosen.dart';
import 'package:pbl_mobile_next/pages/tambah_tugas_2_dosen.dart';
import 'package:pbl_mobile_next/tambahTugas.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: TambahTugas(),
      // home: TambahTugasScreen(),
    );
  }
}

