import 'package:flutter/material.dart';

class TambahScreen extends StatelessWidget {
  const TambahScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tambah Resep"),
        actions: const [],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20.0),
          child: const Column(
            children: [
              Text("From Tambah"),
            ],
          ),
        ),
      ),
    );
  }
}
