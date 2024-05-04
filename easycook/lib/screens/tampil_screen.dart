import 'package:flutter/material.dart';

class TampilScreen extends StatelessWidget {
  const TampilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController _searchController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: Text("Resep Masakan"),
        backgroundColor: const Color(0xFFFFFF99),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              TextFormField(
                controller: _searchController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(20.0),
                    ),
                  ),
                  suffixIcon: Icon(
                    Icons.search,
                    size: 24.0,
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 12.0, horizontal: 5.0),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              GridView.builder(
                padding: EdgeInsets.zero,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: 1.0,
                  crossAxisCount: 2,
                  mainAxisSpacing: 6,
                  crossAxisSpacing: 6,
                ),
                itemCount: 4,
                shrinkWrap: true,
                physics: const ScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    color: Colors.purple,
                    child: const Column(
                      children: [],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
