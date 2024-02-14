import 'package:flutter/material.dart';

class CustomLogoTile extends StatelessWidget {
  final String path;
  const CustomLogoTile({
    super.key,
    required this.path,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      path,
      height: 30,
    );
  }
}
