import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pinterest/core/custom_widgets/snackbars.dart';
import '../../features/home/data/pin_response_model.dart';
import '../../features/profile/presentation/riverpod/saved_pins_provider.dart';
import '../service/hive_service.dart';
import 'custom_pin.dart';

class ShowMoreSheet extends ConsumerWidget {
  final PinModel pin;

  const ShowMoreSheet({super.key, required this.pin});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        /// Sheet
        Container(
          margin: const EdgeInsets.only(top: 100),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(28),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 80),

              // Message text
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "This Pin is inspired by your recent activity",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                    height: 1.3,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 24),

              // Menu items
              _MenuItem(
                icon: Icons.push_pin_outlined,
                label: "Save",
                onTap: () async{
                  final success = await ref.read(savedPinsProvider.notifier).addPin(pin);
                  final msg = success
                      ? "Pin saved in quick save!"
                      : "Psst! you already saved this Pin in quick saves";
                  InfoSnackBar(context: context, text: msg).show();
                  context.pop();
                },
              ),
              _MenuItem(
                icon: Icons.share_outlined,
                label: "Share",
                onTap: () {
                  commonOnTap(context);
                },
              ),
              _MenuItem(
                icon: Icons.download_outlined,
                label: "Download image",
                onTap: () {commonOnTap(context);},
              ),
              _MenuItem(
                icon: Icons.visibility_outlined,
                label: "See more like this",
                onTap: () {commonOnTap(context);},
              ),
              _MenuItem(
                icon: Icons.visibility_off_outlined,
                label: "See less like this",
                onTap: () {commonOnTap(context);},
              ),
              _MenuItem(
                icon: Icons.report_outlined,
                label: "Report Pin",
                subtitle: "This goes against Pinterest's\ncommunity guidelines",
                onTap: () {commonOnTap(context);},
                isLast: true,
              ),

              const SizedBox(height: 8),
            ],
          ),
        ),

        /// Floating Image
        Positioned(
          top: -80,
          left: 0,
          right: 0,
          child: Center(
            child: Container(
              width: 120,
              height: 240,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: BuildImage(
                  isNetwork: true,
                  image: pin.urls.regular,
                  borderRadius: 16,
                ),
              ),
            ),
          ),
        ),

        /// Close Button
        Positioned(
          top: 110,
          left: 16,
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(
              Icons.close,
              size: 34,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }

  void commonOnTap(BuildContext context){
    InfoSnackBar(context: context, text: "A premium feature discovered!").show();
    context.pop();
  }

}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? subtitle;
  final VoidCallback onTap;
  final bool isLast;

  const _MenuItem({
    required this.icon,
    required this.label,
    this.subtitle,
    required this.onTap,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Row(
          children: [
            Icon(
              icon,
              size: 24,
              color: Colors.black87,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Colors.black87,
                      height: 1.2,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle!,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                        height: 1.3,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}