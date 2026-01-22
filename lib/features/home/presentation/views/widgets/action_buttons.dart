import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CreateAction {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const CreateAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });
}

class CreateActionButton extends StatelessWidget {
  final CreateAction action;

  const CreateActionButton({super.key, required this.action});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: action.onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              action.icon,
              size: 28,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            action.label,
            style: GoogleFonts.roboto(
              fontSize: 13,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}