import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easycook/state%20management/provider/like_save.dart';

class LikedScreen extends StatelessWidget {
  const LikedScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFFF99),
        centerTitle: true,
        title: const Text(
          "Resep Disukai",
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Color(0xff000000)),
        ),
        actions: const [],
        toolbarHeight: 70,
      ),
      body: Consumer<ResepModel>(
        builder: (context, resepModel, child) {
          return SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  // Tampilkan resep yang sudah dilike
                  for (var resepId in resepModel.likes.keys)
                    GestureDetector(
                      onTap: () {
                        // Tambahkan logika untuk menavigasi ke halaman resep di sini
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.0),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 1,
                              blurRadius: 5,
                              offset: const Offset(3, 3),
                            ),
                          ],
                        ),
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        padding: const EdgeInsets.all(8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 80,
                              height: MediaQuery.of(context).size.height * 0.1,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.0),
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(
                                    // Ganti dengan URL gambar resep
                                    'https://via.placeholder.com/150',
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    // Ganti dengan nama resep dari data yang sesuai
                                    'Liked Recipe $resepId',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    // Ganti dengan deskripsi resep dari data yang sesuai
                                    'Description of Liked Recipe $resepId',
                                    maxLines: 2,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                // Tambahkan ikon untuk mengedit atau menghapus resep jika diperlukan
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
