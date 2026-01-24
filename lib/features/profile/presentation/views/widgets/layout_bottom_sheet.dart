import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/constants/grid_layout.dart';
import '../../riverpod/saved_pins_provider.dart';


class LayoutSheet extends ConsumerWidget {
  const LayoutSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final layout = ref.watch(savedPinsLayout);

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          /// Title
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Feed layout options",
              style: GoogleFonts.roboto(
                fontSize: 16,
                letterSpacing: 1.5,
                color: Colors.black54,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          const SizedBox(height: 16),

          /// Options
          _item(
            context,
            ref,
            title: "Wide",
            value: GridLayout.large,
            selected: layout == GridLayout.large,
          ),
          const SizedBox(height: 16),
          _item(
            context,
            ref,
            title: "Standard",
            value: GridLayout.standard,
            selected: layout == GridLayout.standard,
          ),
          const SizedBox(height: 16),
          _item(
            context,
            ref,
            title: "Compact",
            value: GridLayout.small,
            selected: layout == GridLayout.small,
          ),

          const SizedBox(height: 20),

          /// Close Button
          ElevatedButton(
            onPressed: () => context.pop(),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey.shade200,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              "Close",
              style: GoogleFonts.roboto(
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }

  /// Option Row
  Widget _item(
      BuildContext context,
      WidgetRef ref, {
        required String title,
        required GridLayout value,
        required bool selected,
      }) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        ref.read(savedPinsLayout.notifier).state = value;
        context.pop();
      },
      child: Row(
        children: [
          Text(
            title,
            style: GoogleFonts.roboto(
              fontSize: 18,
              letterSpacing: 2,
              fontWeight: FontWeight.w500,
            ),
          ),

          const Spacer(),

          if (selected)
            const Icon(
              Icons.check,
              size: 20,
              color: Colors.black,
            ),
        ],
      ),
    );
  }
}
