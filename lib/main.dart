import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app/router/app_router.dart';
import 'app/theme/app_theme.dart';
import 'app/providers/theme_provider.dart';
import 'app/services/local_notification_service.dart';
import 'features/auth/providers/auth_provider.dart';
import 'features/groups/providers/group_provider.dart';
import 'features/groups/providers/chat_provider.dart';
import 'features/sessions/providers/session_provider.dart';
import 'features/activity/providers/activity_provider.dart';
import 'features/notifications/providers/notification_provider.dart';
import 'features/profile/providers/profile_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Local Notifications
  await LocalNotificationService.init();
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => GroupProvider()),
        ChangeNotifierProvider(create: (_) => ChatProvider()),
        ChangeNotifierProvider(create: (_) => SessionProvider()),
        ChangeNotifierProvider(create: (_) => ActivityProvider()),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
      ],
      child: const NjangiApp(),
    ),
  );
}

class NjangiApp extends StatefulWidget {
  const NjangiApp({super.key});

  @override
  State<NjangiApp> createState() => _NjangiAppState();
}

class _NjangiAppState extends State<NjangiApp> {
  @override
  void initState() {
    super.initState();
    
    // Listen for notification payloads
    NotificationNavigation.payloadNotifier.addListener(_handleNotificationPayload);
  }

  @override
  void dispose() {
    NotificationNavigation.payloadNotifier.removeListener(_handleNotificationPayload);
    super.dispose();
  }

  void _handleNotificationPayload() {
    final payload = NotificationNavigation.consumePayload();
    if (payload != null) {
      // The router might not be ready yet if this happens at launch
      // but AppRouter.router is a static final, so it should be fine.
      AppRouter.router.push(payload);
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp.router(
      title: 'Njangi',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeProvider.themeMode,
      routerConfig: AppRouter.router,
    );
  }
}
