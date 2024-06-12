import 'package:easycook/screens/resep_screen.dart';
import 'package:easycook/screens/tampil_screen.dart';
import 'package:easycook/services/firebase_service.dart';
import 'package:flutter/material.dart';
import 'package:easycook/models/resep_model.dart';
import 'package:firebase_auth/firebase_auth.dart' as FirebaseAuth;

class LikedScreen extends StatelessWidget {
  final String resepId;
  const LikedScreen({Key? key, required this.resepId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.FirebaseAuth.instance.currentUser?.uid;
    final firebaseService = FirebaseService();

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
      body: userId == null
          ? const Center(child: Text('User not logged in'))
          : FutureBuilder<List<Recipe>>(
              future: firebaseService.ambilResepDisukai(userId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No liked recipes found'));
                }

                final likedRecipes = snapshot.data!;

                return SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: likedRecipes.map((recipe) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    Resep(resepId: recipe.id), // Corrected here
                              ),
                            );
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
                                  height:
                                      MediaQuery.of(context).size.height * 0.1,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12.0),
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage(
                                        recipe.imageURL ??
                                            'https://via.placeholder.com/150',
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        recipe.name,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        recipe.description,
                                        maxLines: 2,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 16),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
