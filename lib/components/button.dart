import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String label;
  final Function()? onTap;

  const CustomButton({
    super.key,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(
          15.0,
        ),
        decoration: BoxDecoration(
          color: Colors.orange,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
