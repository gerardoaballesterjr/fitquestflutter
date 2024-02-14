import 'package:flutter/material.dart';

class CustomAlert {
  static void show({
    required BuildContext context,
    required String title,
    required String message,
    required Color backgroundColor,
    required Color fontColor,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Container(
          padding: const EdgeInsets.all(16),
          height: 90,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: const BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          child: Column(
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  color: fontColor,
                ),
              ),
              Text(
                message,
                style: TextStyle(
                  fontSize: 12,
                  color: fontColor,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
    );
  }
}
