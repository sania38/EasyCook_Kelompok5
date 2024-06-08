import 'package:flutter/material.dart';

class LikedScreen extends StatelessWidget {
  const LikedScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFFF99),
        centerTitle: true,
        title: const Text(
          "Liked & Saved",
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Color(0xff000000)),
        ),
        actions: const [],
        toolbarHeight: 70,
      ),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            const TabBar(
              tabs: [
                Tab(text: 'Liked'),
                Tab(text: 'Saved'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  // Content for Liked tab
                  SingleChildScrollView(
                    child: Container(
                      padding: const EdgeInsets.all(20.0),
                      child: const Column(
                        children: [
                          // Add your liked recipes content here
                          // Example:
                          ListTile(
                            title: Text('Liked Recipe 1'),
                            subtitle: Text('Description of Liked Recipe 1'),
                          ),
                          ListTile(
                            title: Text('Liked Recipe 2'),
                            subtitle: Text('Description of Liked Recipe 2'),
                          ),
                          // Add more ListTile widgets as needed
                        ],
                      ),
                    ),
                  ),
                  // Content for Saved tab
                  SingleChildScrollView(
                    child: Container(
                      padding: const EdgeInsets.all(20.0),
                      child: const Column(
                        children: [
                          // Add your saved recipes content here
                          // Example:
                          ListTile(
                            title: Text('Saved Recipe 1'),
                            subtitle: Text('Description of Saved Recipe 1'),
                          ),
                          ListTile(
                            title: Text('Saved Recipe 2'),
                            subtitle: Text('Description of Saved Recipe 2'),
                          ),
                          // Add more ListTile widgets as needed
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
