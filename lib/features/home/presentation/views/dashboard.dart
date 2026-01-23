import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinterest/features/home/presentation/riverpod/dashboard_provider.dart';
import 'package:pinterest/features/home/presentation/views/home.dart';
import 'package:pinterest/features/home/presentation/views/widgets/action_buttons.dart';
import 'package:pinterest/features/inbox/presentation/views/inbox.dart';
import 'package:pinterest/features/search/presentation/views/search.dart';
import '../../../../core/custom_widgets/snackbars.dart';

class Dashboard extends ConsumerWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(bottomNavIndexProvider);
    final show = ref.watch(addPanelProvider);

    InfoSnackBar onActionTap() => InfoSnackBar(context: context, text: 'This feature will be added soon');


    final actions = [
      CreateAction(
        icon: Icons.push_pin_outlined,
        label: 'Pin',
        onTap: () => onActionTap().show(),
      ),
      CreateAction(
        icon: Icons.dashboard_customize_outlined,
        label: 'Collage',
        onTap: () => onActionTap().show(),
      ),
      CreateAction(
        icon: Icons.view_quilt_outlined,
        label: 'Board',
        onTap: () => onActionTap().show(),
      ),
    ];
    return Scaffold(
      body: Stack(
        children: [
          IndexedStack(
            index: currentIndex,
            children: [
              const Home(),
              const Search(),
              const Placeholder(),
              const InboxPage(),
              const Placeholder(),
            ],
          ),
          if(show)
            Positioned.fill(
              child: GestureDetector(
                onTap: ()=>ref.read(addPanelProvider.notifier).show(false),
                child: Container(
                 color: Colors.grey.withOpacity(0.2),
                ),
              ),
            ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
            bottom: 0,
            left: 0,
            right: 0,
            height: show ? 210 : 0,
            child: Material(
              color: Colors.white,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            ref.read(addPanelProvider.notifier).show(false);
                          },
                          child: Icon(Icons.close, size: 34),
                        ),
                        Text(
                            "Start creating now",
                          style: GoogleFonts.roboto(
                            fontWeight: FontWeight.w600,
                            fontSize: 16
                          ),
                        ),
                        SizedBox(width: 20,)
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: actions
                          .map((e) => CreateActionButton(action: e))
                          .toList(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: PinterestBottomBar(
        height: show ? 0 : 50,
        currentIndex: currentIndex,
        onTap: (i) {
          if (i == 2) {
            ref.read(addPanelProvider.notifier).show(true);
          } else {
            ref.read(addPanelProvider.notifier).show(false);
            ref.read(bottomNavIndexProvider.notifier).setIndex(i);
          }
        },
      ),
    );
  }
}

class PinterestBottomBar extends StatelessWidget {
  final int currentIndex;
  final double height;
  final ValueChanged<int> onTap;

  const PinterestBottomBar({
    super.key,
    required this.height,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final labels = ["Home", "Search", "Create", "Inbox", "Profile"];

    // Add this check - if height is 0, don't render
    if (height == 0) return const SizedBox.shrink();

    return SafeArea(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: height,
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
                    onTap: () => onTap(i),
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
        return active ? Icons.notifications : Icons.notifications_outlined;
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
            child: Icon(widget.icon, size: 24),
          ),
          // Add spacing control
          const SizedBox(height: 2), // Small fixed gap
          Flexible( // Make text flexible
            child: Text(
              widget.label,
              style: GoogleFonts.roboto(
                fontSize: 10, // Reduced from 12
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.clip, // Prevent overflow
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }
}
