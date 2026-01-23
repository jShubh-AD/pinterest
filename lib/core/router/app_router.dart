import 'package:go_router/go_router.dart';
import 'package:pinterest/features/home/data/pin_response_model.dart';
import 'package:pinterest/features/inbox/presentation/views/inbox.dart';
import '../../features/home/presentation/views/dashboard.dart';
import '../../features/pin_page/presentations/views/pin_details.dart';
import 'package:flutter/cupertino.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const Dashboard(),
    ),
    GoRoute(
      path: '/pin_details',
      pageBuilder: (context, state) {
        final PinModel pin = state.extra! as PinModel;
        return CupertinoPage(child: PinDetails(pin: pin));
      },
    ),
    GoRoute(
      path: '/inbox',
      pageBuilder: (context, state) {
        return CupertinoPage(child: InboxPage());
      },
    ),
  ],
);
