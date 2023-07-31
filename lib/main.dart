import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<void> main() async {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Flooperman 0.2.0'),
            backgroundColor: Colors.green[400],
            bottom: const TabBar(
              tabs: [
                Tab(
                  icon: Icon(Icons.loop),
                  text: "Loop",
                ),
                Tab(
                  icon: Icon(Icons.download),
                  text: "Downloads",
                ),
                Tab(
                  icon: Icon(Icons.favorite),
                  text: "Favourites",
                )
              ],
            ),
          ),
          body: const TabBarView(
            children: [
              Center(
                child: Text("Chats"),
              ),
              Center(
                child: Text("Calls"),
              ),
              Center(
                child: Text("Settings"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
