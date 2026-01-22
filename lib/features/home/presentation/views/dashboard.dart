import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinterest/features/home/presentation/views/home.dart';


import 'package:flutter/material.dart';
import 'package:pinterest/features/home/presentation/views/home.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: const [
          Home(),
          Placeholder(),
          Placeholder(),
          Placeholder(),
          Placeholder(),
        ],
      ),
      bottomNavigationBar: PinterestBottomBar(
        currentIndex: currentIndex,
        onTap: (i) => setState(() => currentIndex = i),
      ),
    );
  }
}


class PinterestBottomBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const PinterestBottomBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final labels = ["Home","Search","Create","Inbox","Profile"];

    return SafeArea(
      child: SizedBox(
        height: 50,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: List.generate(5, (i) {
              final isActive = i == currentIndex;

              return Expanded(
                child: Center(
                  child: PressIcon(
                    icon: _iconFor(i, isActive),
                    label: labels[i],
                    onTap: () => onTap(i)
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  IconData _iconFor(int i, bool active) {
    switch (i) {
      case 0:
        return active ? Icons.home : Icons.home_outlined;
      case 1:
        return active ? Icons.search : Icons.search_outlined;
      case 2:
        return Icons.add;
      case 3:
        return active
            ? Icons.notifications : Icons.notifications_outlined;
      case 4:
        return active ? Icons.person : Icons.person_outline;
      default:
        return Icons.circle;
    }
  }
}

class PressIcon extends StatefulWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const PressIcon({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  State<PressIcon> createState() => _PressIconState();
}

class _PressIconState extends State<PressIcon> {
  bool pressed = false;

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      splashFactory: NoSplash.splashFactory,
      highlightColor: Colors.transparent,
      onTapDown: (_) => setState(() => pressed = true),
      onTapCancel: () => setState(() => pressed = false),
      onTap: () {
        widget.onTap();
        setState(() => pressed = false);
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedScale(
            scale: pressed ? 0.80 : 1.0,
            duration: const Duration(milliseconds: 100),
            curve: Curves.linear,
            child: Icon(
              widget.icon,
              size: 24,
            ),
          ),
          Text(widget.label,
          style: GoogleFonts.roboto(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          )),
        ],
      ),
    );
  }
}



