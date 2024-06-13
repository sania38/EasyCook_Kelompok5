import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:easycook/services/user_auth.dart';
import 'package:easycook/state%20management/provider/like_save.dart';

import 'package:flutter/material.dart';
import 'package:easycook/models/resep_model.dart';
import 'package:easycook/services/firebase_service.dart';
import 'package:firebase_auth/firebase_auth.dart' as FirebaseAuth;
import 'package:provider/provider.dart';

class Resep extends StatefulWidget {
  final String resepId;

  const Resep({Key? key, required this.resepId}) : super(key: key);

  @override
  State<Resep> createState() => _ResepState();
}

class _ResepState extends State<Resep> {
  late Future<Recipe?> _resepFuture;
  int likes = 0;
  late ResepModel _resepModel;

  @override
  @override
  void initState() {
    super.initState();
    _resepFuture = FirebaseService().ambilResepId(widget.resepId);
    _resepModel = Provider.of<ResepModel>(context, listen: false);
    _resepModel.initData(widget.resepId);
  }

  Future<void> loadLikes() async {
    try {
      // Load likes from Firebase
      Map<String, dynamic> likesAndBookmarks =
          await FirebaseService().getLikesAndBookmarks(widget.resepId);
      setState(() {
        likes = likesAndBookmarks['likes'] ?? 0;
      });
    } catch (e) {
      print('Error loading likes: $e');
    }
  }

  final UserRepository _userRepository =
      UserRepository(FirebaseFirestore.instance);

  @override
  Widget build(BuildContext context) {
    final resepModel = Provider.of<ResepModel>(context);
    final likes = resepModel.likes[widget.resepId] ?? 0;

    return Scaffold(
      body: FutureBuilder<Recipe?>(
        future: _resepFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data != null) {
            final Recipe resep = snapshot.data!;

            return SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(30.0),
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(30),
                            bottomRight: Radius.circular(30),
                          ),
                          child: Image.network(
                            resep.imageURL,
                            width: double.infinity,
                            height: 300.0,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 16.0, // Atur posisi tombol di bagian atas
                        left: 16.0, // Atur posisi tombol di sebelah kiri
                        child: IconButton(
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: 30,
                          ), // Ikon tombol kembali
                          onPressed: () {
                            Navigator.pop(
                                context); // Fungsi untuk kembali ke halaman sebelumnya
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                resep.name,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 30),
                              ),
                              Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.grey.withOpacity(0.5),
                                            spreadRadius: 2,
                                            blurRadius: 2,
                                            offset: const Offset(0, 1),
                                            blurStyle: BlurStyle.outer),
                                      ],
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(8.0),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        IconButton(
                                          icon: Icon(
                                            resepModel.isLikedByCurrentUser(
                                                    widget.resepId)
                                                ? Icons.favorite
                                                : Icons.favorite_border,
                                            color:
                                                resepModel.isLikedByCurrentUser(
                                                        widget.resepId)
                                                    ? Colors.red
                                                    : Colors.black,
                                          ),
                                          onPressed: () async {
                                            String? userId =
                                                await getUserId(); // Obtain the userId somehow
                                            if (userId != null) {
                                              if (resepModel
                                                  .isLikedByCurrentUser(
                                                      widget.resepId)) {
                                                await resepModel.unlikeResep(
                                                    widget.resepId, userId);
                                              } else {
                                                await resepModel.likeResep(
                                                    widget.resepId, userId);
                                              }
                                              setState(() {});
                                            } else {
                                              // Handle the case where userId is null
                                            }
                                          },
                                        ),
                                        Text(
                                          '$likes   ',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // IconButton(
                                  //   icon: Icon(
                                  //     isBookmarked
                                  //         ? Icons.bookmark
                                  //         : Icons.bookmark_border,
                                  //     color: isBookmarked
                                  //         ? Colors.amber
                                  //         : Colors.black,
                                  //   ),
                                  //   onPressed: () {
                                  //     resepModel.toggleBookmark(widget.resepId);
                                  //   },
                                  // ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          RichText(
                            textAlign: TextAlign.justify,
                            text: TextSpan(
                              style: const TextStyle(
                                  fontSize: 15,
                                  color: Colors.black,
                                  height: 1.5,
                                  fontWeight: FontWeight.w400),
                              text: resep
                                  .description, // Menggunakan deskripsi dari resep
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Dipublikasikan Oleh : ",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ],
                          ),
                          Container(
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                children: [
                                  const CircleAvatar(
                                    backgroundImage: AssetImage(
                                      "assets/exProf.jpg",
                                    ),
                                    radius: 34,
                                  ),
                                  const SizedBox(width: 16),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      FutureBuilder<Map<String, dynamic>?>(
                                        future: _userRepository
                                            .getUserData(resep.userId),
                                        builder: (context, userSnapshot) {
                                          return Text(
                                            userSnapshot.data!['username'],
                                            style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600),
                                          );
                                        },
                                      ),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      FutureBuilder<int>(
                                        future: FirebaseService()
                                            .countResepByUser(resep.userId),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return const CircularProgressIndicator();
                                          } else if (snapshot.hasError) {
                                            return Text(
                                                'Error: ${snapshot.error}');
                                          } else {
                                            int totalResep = snapshot.data!;
                                            return Text(
                                              "Total Resep $totalResep",
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            );
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                  const Spacer(),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 14),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Bahan-Bahan",
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w500),
                                ),
                                const SizedBox(
                                  height: 12,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 2,
                                        blurRadius: 5,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  padding: const EdgeInsets.only(
                                      left: 14, right: 14, bottom: 20),
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: resep.ingredients.length,
                                    itemBuilder: (context, index) {
                                      final ingredient =
                                          resep.ingredients[index];
                                      return Text(
                                        ingredient,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          height: 2,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(height: 24),
                                const Text(
                                  "Cara memasak",
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w500),
                                ),
                                const SizedBox(
                                  height: 12,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 2,
                                        blurRadius: 5,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  padding: const EdgeInsets.only(
                                      left: 14, right: 14, bottom: 20),
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: resep.cookingSteps.length,
                                    itemBuilder: (context, index) {
                                      final step = resep.cookingSteps[index];
                                      if (step != null) {
                                        return Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              '\u2022',
                                              style: TextStyle(fontSize: 24),
                                            ),
                                            const SizedBox(width: 8.0),
                                            Expanded(
                                              child: ListBody(
                                                children: [
                                                  Text(
                                                    step,
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      height: 2,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 12,
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        );
                                      } else {
                                        return Container();
                                      }
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  height: 14,
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const Center(child: Text('No Data'));
          }
        },
      ),
    );
  }

  Future<String?> getUserId() async {
    // Cek apakah ada pengguna yang sedang login
    FirebaseAuth.User? user = FirebaseAuth.FirebaseAuth.instance.currentUser;
    // Use 'FirebaseAuth.User' to refer to the User class from 'firebase_auth' library

    // If there's a logged-in user, return the user's ID
    if (user != null) {
      return user.uid;
    } else {
      // If no user is logged in, return null
      return null;
    }
  }
}
