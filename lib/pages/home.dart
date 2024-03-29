import 'package:flutter/material.dart';
import '/components/appbar.dart';
import '/components/drawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          title: 'Fit Quest',
        ),
        drawer: CustomDrawer(),
      ),
    );
  }
}
