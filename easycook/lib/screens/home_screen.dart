import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easycook/screens/main_screen.dart';
import 'package:easycook/state%20management/provider/profile_pict.dart';
import 'package:easycook/components/popular_card.dart';
import 'package:easycook/models/resep_model.dart';
import 'package:easycook/screens/ai_chat.dart';
import 'package:easycook/screens/resep_screen.dart';
import 'package:easycook/services/firebase_service.dart';
import 'package:easycook/services/user_auth.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseService _firebaseService = FirebaseService();
  firebase_auth.User? _user;
  late Future<List<Recipe>> _resepFuture;

  String _searchKeyword = '';
  final UserRepository _userRepository =
      UserRepository(FirebaseFirestore.instance);

  @override
  void initState() {
    super.initState();
    _resepFuture = FirebaseService().ambilResep();

    // Fetch the current user
    _user = FirebaseAuth.instance.currentUser;

    // Fetch the user's profile picture URL
    if (_user != null) {
      Provider.of<ProfilePictureUrlProvider>(context, listen: false)
          .fetchProfilePictureUrl(_user!.uid);
    }
  }

  @override
  Widget build(BuildContext context) {
    int maxItems = 2;
    TextEditingController searchController = TextEditingController();
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.2,
              decoration: const BoxDecoration(
                color: Color(0xFFFFFF99),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30.0),
                  bottomRight: Radius.circular(30.0),
                ),
              ),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                child: Column(
                  children: [
                    const SizedBox(height: 15),
                    SafeArea(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CircleAvatar(
                            backgroundImage:
                                Provider.of<ProfilePictureUrlProvider>(context)
                                            .profilePictureUrl !=
                                        null
                                    ? NetworkImage(Provider
                                                .of<ProfilePictureUrlProvider>(
                                                    context)
                                            .profilePictureUrl!)
                                        as ImageProvider<Object>
                                    : const AssetImage('assets/exProf.jpg'),
                            radius: 40,
                          ),
                          FutureBuilder<String>(
                            future: _firebaseService.getUserName(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const CircularProgressIndicator();
                              } else if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              } else {
                                final userName = snapshot.data;
                                return Text(
                                  'Hallo, $userName',
                                  style: const TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold),
                                );
                              }
                            },
                          ),
                          IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const AiChat()),
                              );
                            },
                            icon: const Icon(
                              Icons.chat,
                              size: 30.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 35),
                    SizedBox(
                      height: 200,
                      child: SizedBox(
                        height: 200,
                        child: CarouselSlider(
                          options: CarouselOptions(
                            autoPlay: true,
                            aspectRatio: 2.0,
                            enlargeCenterPage: true,
                          ),
                          items: [
                            Container(
                              width: 300,
                              margin: const EdgeInsets.only(right: 10),
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(12.0),
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12.0),
                                child: Image.asset(
                                  "assets/banner1.jpg",
                                  width: 120.0,
                                  height: 120.0,
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            Container(
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(12.0),
                                ),
                              ),
                              width: 300,
                              margin: const EdgeInsets.only(right: 10),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12.0),
                                child: Image.asset(
                                  "assets/banner2.jpg",
                                  width: 120.0,
                                  height: 120.0,
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            Container(
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(12.0),
                                ),
                              ),
                              width: 300,
                              margin: const EdgeInsets.only(right: 10),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12.0),
                                child: Image.asset(
                                  "assets/banner3.jpg",
                                  width: 120.0,
                                  height: 120.0,
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: const [
                          Text(
                            'Resep Terbaru',
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                    FutureBuilder<List<Recipe>>(
                      future: _resepFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator(); //loading indicator
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          //Filter resep
                          List<Recipe> filteredResep =
                              snapshot.data!.where((resep) {
                            return resep.name
                                .toLowerCase()
                                .contains(_searchKeyword);
                          }).toList();

                          //Data resep menggunakan GridView.builder
                          filteredResep.sort(
                              (a, b) => b.createdAt.compareTo(a.createdAt));

                          return GridView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: (.6 / 1),
                              crossAxisSpacing: 15.0,
                              mainAxisSpacing: 20.0,
                            ),
                            shrinkWrap: true,
                            itemCount: filteredResep.length < maxItems
                                ? filteredResep.length
                                : maxItems,
                            itemBuilder: (context, index) {
                              Recipe resep = filteredResep[index];
                              return FutureBuilder<Map<String, dynamic>?>(
                                future:
                                    _userRepository.getUserData(resep.userId),
                                builder: (context, userSnapshot) {
                                  if (userSnapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const CircularProgressIndicator(); //loading indicator
                                  } else if (userSnapshot.hasError) {
                                    return Text('Error: ${userSnapshot.error}');
                                  } else {
                                    //Data resep
                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                Resep(resepId: resep.id),
                                          ),
                                        );
                                      },
                                      child: PopularCard(
                                        recipe: resep,
                                        profilePictureUrl: '',
                                      ),
                                    );
                                  }
                                },
                              );
                            },
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
