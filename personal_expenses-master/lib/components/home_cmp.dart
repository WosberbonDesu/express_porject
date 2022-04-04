import 'package:flutter/material.dart';
import '../constants/styles/text_styles.dart';

buildColButton({
  required Color color,
  required String title,
  required IconData icon,
  required VoidCallback onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Column(
      children: [
        Container(
          height: 40,
          width: 40,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8), color: color),
          child: Container(
              height: 20,
              width: 20,
              decoration: const BoxDecoration(
                  shape: BoxShape.circle, color: Colors.white),
              child: Icon(
                icon,
                color: color,
                size: 12,
              )),
        ),
        const SizedBox(height: 5),
        Text(
          title,
          style: PersonalTStyles.w500s14B,
        ),
      ],
    ),
  );
}
