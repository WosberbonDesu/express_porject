import 'package:flutter/material.dart';

SizedBox buildErrorMessage(
  String? text,
  double height,
) {
  return SizedBox(
    height: height,
    child: Center(
      child: Text(text ?? "Bir hata oluştu."),
    ),
  );
}
