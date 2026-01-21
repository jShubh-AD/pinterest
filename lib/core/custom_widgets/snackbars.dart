import 'package:flutter/material.dart';

SnackBar _baseSnackBar({
  required Widget content,
  SnackBarAction? action,
  Duration duration = const Duration(seconds: 3),
}) {
  return SnackBar(
    behavior: SnackBarBehavior.floating,
    backgroundColor: const Color(0xFF4A4A45),
    margin: const EdgeInsets.all(16),
    duration: duration,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(28),
    ),
    content: content,
    action: action,
  );
}


class ActionSnackBar {
  final BuildContext context;
  final String text;
  final String buttonText;
  final VoidCallback onPressed;

  ActionSnackBar({
    required this.context,
    required this.text,
    required this.buttonText,
    required this.onPressed,
  });

  void show() {
    ScaffoldMessenger.of(context).showSnackBar(
      _baseSnackBar(
        content: Text(
          text,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
        action: SnackBarAction(
          label: buttonText,
          textColor: Colors.black,
          backgroundColor: Colors.white,
          onPressed: onPressed,
        ),
      ),
    );
  }
}

class InfoSnackBar {
  final BuildContext context;
  final String text;
  final Duration duration;

  InfoSnackBar({
    required this.context,
    required this.text,
    this.duration = const Duration(seconds: 3),
  });

  void show() {
    ScaffoldMessenger.of(context).showSnackBar(
      _baseSnackBar(
        content: Text(
          text,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
        duration: duration,
      ),
    );
  }
}

