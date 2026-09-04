// Basic smoke test: boots the app and verifies the login screen renders.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:pg_manager_owner/app.dart';
import 'package:pg_manager_owner/injection/service_locator.dart';

void main() {
  setUpAll(() {
    setupServiceLocator();
  });

  testWidgets('App boots to the login screen', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: PgOwnerApp()),
    );
    await tester.pumpAndSettle();

    // The login page shows the app title and portal label.
    expect(find.text('PG Manager'), findsOneWidget);
    expect(find.text('Owner Portal'), findsOneWidget);
    expect(find.widgetWithText(TextButton, 'Forgot Password?'), findsOneWidget);
  });
}
