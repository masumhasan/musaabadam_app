import 'package:flutter/material.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: DefaultTabController(
            length: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- Search Bar ---
                Container(
                  height: 45,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: const Color(0xFF1E90B0), // Teal-blue border
                      width: 1.5,
                    ),
                  ),
                  child: const TextField(
                    decoration: InputDecoration(
                      hintText: 'Search',
                      hintStyle: TextStyle(color: Colors.grey),
                      contentPadding: EdgeInsets.symmetric(horizontal: 15),
                      border: InputBorder.none,
                      suffixIcon: Icon(Icons.search, color: Colors.black54),
                    ),
                  ),
                ),
                const SizedBox(height: 15),

                // --- Tab Bar ---
                const TabBar(
                  isScrollable: true,
                  labelColor: Colors.black,
                  unselectedLabelColor: Colors.black,
                  labelStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  indicatorColor: Colors.black,
                  indicatorSize: TabBarIndicatorSize.label,
                  dividerColor: Colors.transparent, // Removes bottom line
                  tabAlignment: TabAlignment.start,
                  labelPadding: EdgeInsets.only(right: 20),
                  tabs: [
                    Tab(text: "Suggested"),
                    Tab(text: "Saved"),
                  ],
                ),

                // --- Content Area ---
                const Expanded(
                  child: TabBarView(
                    children: [
                      Center(child: Text("Suggested Content")),
                      Center(child: Text("Saved Content")),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}