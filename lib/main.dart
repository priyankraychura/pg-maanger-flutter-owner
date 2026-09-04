import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'injection/service_locator.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Setup dependency injection
  setupServiceLocator();

  runApp(
    const ProviderScope(
      child: PgOwnerApp(),
    ),
  );
}
