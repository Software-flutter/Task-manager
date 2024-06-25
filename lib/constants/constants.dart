import 'package:flutter/material.dart';

BoxDecoration boxDecorationWhite = BoxDecoration(
  color: Colors.grey[300],
  borderRadius: BorderRadius.circular(25),
  boxShadow: [
    BoxShadow(
      color: Colors.grey.withOpacity(0.5),
      spreadRadius: 2,
      blurRadius: 5,
      offset: const Offset(0, 3),
    ),
  ],
);
BoxDecoration boxDecoration=BoxDecoration(
        color: const Color(0xFF1976D2),
        borderRadius: BorderRadius.circular(25),
        boxShadow: const [
          BoxShadow(
            color: Colors.white,
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      );