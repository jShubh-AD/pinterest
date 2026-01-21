import 'package:go_router/go_router.dart';
import 'package:pinterest/features/home/presentation/views/home.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const Home(),
    ),
    // GoRoute(
    //   path: '/pin/:id',
    //   builder: (context, state) {
    //     final id = state.pathParameters['id']!;
    //     return PinDetailPage(pinId: id);
    //   },
    // ),
  ],
);
