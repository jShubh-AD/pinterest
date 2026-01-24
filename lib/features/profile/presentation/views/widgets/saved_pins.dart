import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pinterest/features/home/data/pin_response_model.dart';
import '../../../../../core/custom_widgets/custom_pin.dart';

class SavedPins extends ConsumerWidget {
  final PinModel pin;
  final VoidCallback? onLongPress;

  const SavedPins({
    super.key,
    required this.pin,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final aspectRatio = pin.width / pin.height;
    return GestureDetector(
      onTap: () {}, // add going to saved details
      onLongPress: onLongPress,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
            AspectRatio(
              aspectRatio: aspectRatio,
              child: BuildImage(
                isNetwork: true,
                image: pin.urls.small,
                borderRadius: 20,
              ),
            ),
        ],
      ),
    );
  }
}


