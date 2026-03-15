import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/home/screens/home_screen.dart';
import '../../features/groups/screens/groups_screen.dart';
import '../../features/groups/screens/group_details_screen.dart';
import '../../features/groups/screens/create_group_screen.dart';
import '../../features/groups/screens/join_group_screen.dart';
import '../../features/groups/screens/start_circle_screen.dart';
import '../../features/sessions/screens/session_details_screen.dart';
import '../../features/activity/screens/activity_screen.dart';
import '../../features/notifications/screens/notifications_screen.dart';
import '../../features/profile/screens/profile_screen.dart';
import '../../features/onboarding/screens/splash_screen.dart';
import '../../features/onboarding/screens/onboarding_screen.dart';
import '../../features/onboarding/screens/welcome_screen.dart';
import '../../features/auth/screens/phone_login_screen.dart';
import '../../features/auth/screens/otp_verification_screen.dart';
import '../../features/auth/screens/profile_completion_screen.dart';
import '../shared/widgets/app_shell.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>();

class AppRouter {
  static final router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/splash',
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/welcome',
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const PhoneLoginScreen(),
      ),
      GoRoute(
        path: '/verify-otp',
        builder: (context, state) => const OtpVerificationScreen(),
      ),
      GoRoute(
        path: '/complete-profile',
        builder: (context, state) => const ProfileCompletionScreen(),
      ),
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          return AppShell(child: child);
        },
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: '/groups',
            builder: (context, state) => const GroupsScreen(),
            routes: [
              GoRoute(
                path: 'create',
                parentNavigatorKey: _rootNavigatorKey,
                builder: (context, state) => const CreateGroupScreen(),
              ),
              GoRoute(
                path: 'join',
                parentNavigatorKey: _rootNavigatorKey,
                builder: (context, state) => const JoinGroupScreen(),
              ),
              GoRoute(
                path: ':groupId',
                parentNavigatorKey: _rootNavigatorKey,
                builder: (context, state) {
                  final groupId = state.pathParameters['groupId']!;
                  return GroupDetailsScreen(groupId: groupId);
                },
                routes: [
                  GoRoute(
                    path: 'start-circle',
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) => StartCircleScreen(groupId: state.pathParameters['groupId']!),
                  ),
                  GoRoute(
                    path: 'sessions/:sessionId',
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) => SessionDetailsScreen(
                      groupId: state.pathParameters['groupId']!,
                      sessionId: state.pathParameters['sessionId']!,
                    ),
                  ),
                ],
              ),
            ],
          ),
          GoRoute(
            path: '/activity',
            builder: (context, state) => const ActivityScreen(),
          ),
          GoRoute(
            path: '/notifications',
            builder: (context, state) => const NotificationsScreen(),
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
      ),
    ],
  );
}
