import 'package:go_router/go_router.dart';
import 'package:kitap/presentation/features/auth/views/login_screen.dart';
import 'package:kitap/presentation/features/auth/views/register_screen.dart';
import 'package:kitap/presentation/features/book/views/book_detail_screen.dart';
import 'package:kitap/presentation/features/dashboard/views/dashboard_screen.dart';
import 'package:kitap/presentation/features/splash/views/splash_screen.dart';
import 'package:kitap/presentation/features/book/views/isbn_screen.dart';
import 'package:kitap/presentation/features/summary/summary_detail_screen.dart';
import 'package:kitap/presentation/features/summary/summary_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const SplashScreen()),
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      name: 'register',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: '/dashboard',
      name: 'dashboard',
      builder: (context, state) => const DashboardScreen(),
    ),
    GoRoute(
      path: '/isbn',
      name: 'isbn',
      builder: (context, state) => const IsbnScreen(),
    ),
    GoRoute(
      path: '/bookdetail',
      name: 'bookdetail',
      builder: (context, state) => const BookDetailScreen(),
    ),
    GoRoute(
      path: '/summary',
      name: 'summary',
      builder: (context, state) => const BookSummaryScreen(),
    ),
    GoRoute(
      path: '/summarydetail',
      name: 'summarydetail',
      builder: (context, state) => const SummaryDetailScreen(summary: ''),
    ),
    GoRoute(
      path: '/settings',
      name: 'settings',
      builder: (context, state) => const RegisterScreen(),
    ),
  ],
);
