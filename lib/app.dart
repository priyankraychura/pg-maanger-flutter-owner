import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme/app_theme.dart';
import 'features/settings/presentation/providers/settings_provider.dart';
import 'routes/app_router.dart';

class PgOwnerApp extends ConsumerWidget {
  const PgOwnerApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final isDarkTheme = ref.watch(themeProvider);

    return MaterialApp.router(
      title: 'PG Manager Owner',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: isDarkTheme ? ThemeMode.dark : ThemeMode.light,
      routerConfig: router,
    );
  }
}
