import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:pinterest/features/search/presentation/riverpod/search_provider.dart';
import '../../../../core/custom_widgets/custom_pin.dart';
import '../../../../core/service/hive_service.dart';

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  final searchCtrl = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.requestFocus();
    _focusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    searchCtrl.dispose();
    _focusNode.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final searchAsync = ref.watch(searchProvider);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: searchCtrl,
                      focusNode: _focusNode,
                      style: GoogleFonts.roboto(
                        fontSize: 15,
                        color: Colors.black,
                      ),
                      textInputAction: TextInputAction.search,
                      cursorColor: Colors.red,
                      onSubmitted: (_) {
                        if (searchCtrl.text.isEmpty) return;
                        ref
                            .read(searchProvider.notifier)
                            .search(searchCtrl.text);
                      },
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 0,
                        ),
                        prefixIcon: _focusNode.hasFocus
                            ? null
                            : const Icon(
                                Icons.search,
                                size: 20,
                                color: Colors.black54,
                              ),
                        suffixIcon: const Icon(
                          Icons.camera_alt_outlined,
                          size: 20,
                          color: Colors.black54,
                        ),
                        hintText: "Search for ideas",
                        hintStyle: GoogleFonts.roboto(
                          fontSize: 15,
                          color: Colors.black54,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Colors.black,
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  /// Cancel
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: Text(
                      "Cancel",
                      style: GoogleFonts.roboto(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              searchAsync.when(
                error: (e, _) => Center(child: Text(e.toString())),
                loading: () => Center(
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: const BoxDecoration(
                      color: Colors.grey,
                      shape: BoxShape.circle,
                    ),
                    child: Lottie.asset(
                      'assets/lottie/refresh_loading.json',
                      height: 40,
                      repeat: true,
                      animate: true,
                    ),
                  ),
                ),
                data: (pins) => pins != null
                    ? pins.isNotEmpty
                          ? Expanded(
                            child: CustomRefreshIndicator(
                                offsetToArmed: 80,
                                onRefresh: () async {
                                  await Future.delayed(Duration(seconds: 2));
                                  final q = searchCtrl.text;
                                  if (q.isEmpty) return;
                                  await ref.read(searchProvider.notifier).search(q);
                                },
                                builder: (context, child, controller) {
                                  return Stack(
                                    alignment: Alignment.topCenter,
                                    children: [
                                      Positioned(
                                        top: controller.state == IndicatorState.armed ||
                                            controller.state == IndicatorState.dragging ||
                                            controller.state == IndicatorState.settling
                                            ? 40 * controller.value
                                            : 0,
                                        child: Container(
                                          height: 40 * controller.value,
                                          constraints: BoxConstraints(maxHeight: 40),
                                          decoration: BoxDecoration(
                                            color: Colors.grey,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Lottie.asset(
                                            'assets/lottie/refresh_loading.json',
                                            fit: BoxFit.cover,
                                            repeat: controller.isLoading,
                                            animate: controller.isLoading,
                                          ),
                                        ),
                                      ),
                                      Transform.translate(
                                        offset: Offset(0.0, 40 * controller.value),
                                        child: child,
                                      ),
                                    ],
                                  );
                                },
                                child: Stack(
                                  children: [
                                    MasonryGridView.count(
                                      key: const PageStorageKey("scroll"),
                                      controller: ref.watch(searchScrollCtrl),
                                      physics: const BouncingScrollPhysics(),
                                      padding: const EdgeInsets.symmetric(horizontal: 4),
                                      itemCount: pins.length + 1,
                                      crossAxisCount: 2,
                                      mainAxisSpacing: 4,
                                      crossAxisSpacing: 4,
                                      itemBuilder: (context, index) {
                                        if (index == pins.length) {
                                          return const Center(
                                            child: Padding(
                                              padding: EdgeInsets.all(16.0),
                                              child: CircularProgressIndicator(),
                                            ),
                                          );
                                        }
                                        final pin = pins[index];
                                        return CustomPin(
                                          pin: pin,
                                          isSaved: HiveService.isSaved(pin.id),
                                          isNetwork: true,
                                          onLongPress: () {},
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                          )
                          : Center(child: Text("No results found"))
                    : SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
