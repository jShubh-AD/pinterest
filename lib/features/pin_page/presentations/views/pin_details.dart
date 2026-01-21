import 'package:flutter/material.dart';

class PinDetails extends StatelessWidget {
  final String pinId;
  const PinDetails({super.key, required this.pinId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
body: SafeArea(child: Text("Pin details with id : $pinId")),
    );
  }
}
