import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:siapaja_flutter_fe/main.dart';

void main() {
  testWidgets('App loads successfully', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: SiapAjaApp()));
    await tester.pumpAndSettle();
    
    // Verify the app loads with the feed
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
