import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/auth/presentation/pages/login_page.dart';
import '../features/auth/presentation/pages/forgot_password_page.dart';
import '../features/auth/presentation/providers/auth_provider.dart';
import '../features/navigation/navigation_shell.dart';
import '../features/dashboard/presentation/pages/dashboard_page.dart';
import '../features/rooms/presentation/pages/rooms_page.dart';
import '../features/tenants/presentation/pages/tenants_page.dart';
import '../features/payments/presentation/pages/payments_page.dart';
import '../features/settings/presentation/pages/settings_page.dart';
import '../features/invitations/presentation/pages/invitations_page.dart';
import '../features/notices/presentation/pages/notices_page.dart';
import '../features/complaints/presentation/pages/complaints_page.dart';
import '../features/menu/presentation/pages/menu_page.dart';
import '../features/staff/presentation/pages/staff_page.dart';
import '../features/pg_management/presentation/pages/pg_management_page.dart';
import '../features/dashboard/presentation/pages/recent_activity_page.dart';

// Provide the GoRouter instance using Riverpod
final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: '/login',
    redirect: (context, state) {
      final isLoggingIn = state.uri.path == '/login' || state.uri.path == '/forgot-password';
      final isLoggedIn = authState.hasValue && authState.value != null;

      if (!isLoggedIn && !isLoggingIn) return '/login';
      if (isLoggedIn && isLoggingIn) return '/dashboard';

      return null;
    },
    routes: [
      // Auth Routes
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/forgot-password',
        builder: (context, state) => const ForgotPasswordPage(),
      ),

      // Main App Routes with Bottom Navigation
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return NavigationShell(navigationShell: navigationShell);
        },
        branches: [
          // Branch 0: Dashboard
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/dashboard',
                builder: (context, state) => const DashboardPage(),
              ),
            ],
          ),

          // Branch 1: Rooms
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/rooms',
                builder: (context, state) => const RoomsPage(),
              ),
            ],
          ),

          // Branch 2: Tenants
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/tenants',
                builder: (context, state) => const TenantsPage(),
              ),
            ],
          ),

          // Branch 3: Payments
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/payments',
                builder: (context, state) => const PaymentsPage(),
              ),
            ],
          ),

          // Branch 4: More (Settings)
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/settings',
                builder: (context, state) => const SettingsPage(),
              ),
            ],
          ),
        ],
      ),

      // Other top-level routes (Quick actions)
      GoRoute(
        path: '/invitations',
        builder: (context, state) => const InvitationsPage(),
      ),
      GoRoute(
        path: '/notices',
        builder: (context, state) => const NoticesPage(),
      ),
      GoRoute(
        path: '/complaints',
        builder: (context, state) => const ComplaintsPage(),
      ),
      GoRoute(
        path: '/menu',
        builder: (context, state) => const MenuPage(),
      ),
      GoRoute(
        path: '/staff',
        builder: (context, state) => const StaffPage(),
      ),
      GoRoute(
        path: '/pg-management',
        builder: (context, state) => const PgManagementPage(),
      ),
      GoRoute(
        path: '/recent-activity',
        builder: (context, state) => const RecentActivityPage(),
      ),
    ],
  );
});
