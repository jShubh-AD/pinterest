import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinterest/core/service/hive_service.dart';
import 'package:pinterest/features/profile/presentation/views/widgets/saved_pins.dart';
import '../../../home/data/pin_response_model.dart';
import '../../../home/presentation/riverpod/dashboard_provider.dart';

class Profile extends ConsumerWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<PinModel> pins = HiveService.getAllPins();
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            /// Top Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Row(
                children: [
                  /// Avatar
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: Colors.purple,
                    child: Text(
                      "S",
                      style: GoogleFonts.roboto(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  /// Tabs
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        _tab("Pins", true),
                        const SizedBox(width: 12),
                        _tab("Boards", false),
                        const SizedBox(width: 12),
                        _tab("Collages", false),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            /// Search + Add
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  /// Search
                  Expanded(
                    child: TextField(
                      onTap: (){
                        context.push("/search_page");
                      },
                      readOnly: true,
                      decoration: InputDecoration(
                        hintText: "Search more Pins",
                        prefixIcon: const Icon(Icons.search, size: 20),
                        isDense: true,
                        contentPadding:
                        const EdgeInsets.symmetric(vertical: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide:
                          const BorderSide(color: Colors.grey),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  /// Plus
                  GestureDetector(
                      onTap: (){ref.read(addPanelProvider.notifier).show(true);},
                      child: const Icon(Icons.add, size: 26)),
                ],
              ),
            ),

            const SizedBox(height: 12),

            /// Filter Chips
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  _chip(Icons.grid_view, null, null),
                  const SizedBox(width: 8),
                  _chip(Icons.star_border, "Favorites", null),
                  const SizedBox(width: 8),
                  _chip(null, "Created by you", null),
                ],
              ),
            ),

            const SizedBox(height: 12),

            /// Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Heading
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 8,
                      ),
                      child: Text(
                        "Your saved Pins",
                        style: GoogleFonts.roboto(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    /// Grid
                    pins.isEmpty
                        ? SizedBox(
                      height: MediaQuery.of(context).size.height * 0.5,
                      child: Center(
                        child: Text(
                          'No Saved Pins',
                          style: GoogleFonts.roboto(
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey.shade300,
                          ),
                        ),
                      ),
                    )
                        : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: MasonryGridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 2,
                        mainAxisSpacing: 6,
                        crossAxisSpacing: 6,
                        itemCount: pins.length,
                        itemBuilder: (_, i) {
                          return SavedPins(
                            pin: pins[i],
                            onLongPress: () {},
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Tab Widget
  Widget _tab(String text, bool active) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            text,
            style: GoogleFonts.roboto(
              fontSize: 15,
              fontWeight:
              active ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
          const SizedBox(height: 4),
          if (active)
            Container(
              height: 2,
              width: 20,
              color: Colors.black,
            )
        ],
      ),
    );
  }

  /// Chip
  Widget _chip(IconData? icon, String? text, VoidCallback? onTap) {
    return GestureDetector(
      onTap: onTap ,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 6,
          vertical: 6,
        ),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            if(icon != null)
            Icon(icon, size: 16),
            if(text != null) ...[
              const SizedBox(width: 6),
              Text(
                text,
                style: GoogleFonts.roboto(fontSize: 13),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
