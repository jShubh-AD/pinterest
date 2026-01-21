import 'package:go_router/go_router.dart';
import 'package:pinterest/features/home/presentation/views/home.dart';
import 'package:pinterest/features/pin_page/presentations/views/pin_details.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const Home(),
    ),
    GoRoute(
      path: '/pin_details/:id',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return PinDetails(pinId: id);
      },
    ),
  ],
);
