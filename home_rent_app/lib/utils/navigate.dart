import 'package:flutter/material.dart';

Navigate(BuildContext context, Widget screen) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => screen,
    ),
  );
}
