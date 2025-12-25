import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';
import 'package:sizer/sizer.dart';
import 'package:chat_module/screens/home_screen.dart';

void main() {
  setUpAll(() async {
    Hive.init('./test_widget_data');
    await Hive.openBox('users');
    await Hive.openBox('chats');
  });

  setUp(() async {
    await Hive.box('users').clear();
    await Hive.box('chats').clear();
  });

  tearDownAll(() async {
    await Hive.box('users').close();
    await Hive.box('chats').close();
    await Hive.deleteFromDisk();
  });

  testWidgets('HomeScreen displays correctly', (tester) async {
    await tester.pumpWidget(
      Sizer(
        builder: (context, orientation, deviceType) {
          return const MaterialApp(home: HomeScreen());
        },
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(HomeScreen), findsOneWidget);
  });

  testWidgets('HomeScreen shows FAB on Users tab', (tester) async {
    await tester.pumpWidget(
      Sizer(
        builder: (context, orientation, deviceType) {
          return const MaterialApp(home: HomeScreen());
        },
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(FloatingActionButton), findsOneWidget);
  });

  testWidgets('HomeScreen can switch tabs', (tester) async {
    await tester.pumpWidget(
      Sizer(
        builder: (context, orientation, deviceType) {
          return const MaterialApp(home: HomeScreen());
        },
      ),
    );
    await tester.pumpAndSettle();

    final chatHistoryButton = find.text('Chat History');
    expect(chatHistoryButton, findsOneWidget);

    await tester.tap(chatHistoryButton);
    await tester.pumpAndSettle();

    expect(find.byType(FloatingActionButton), findsNothing);
  });

  testWidgets('HomeScreen shows empty state when no users', (tester) async {
    await tester.pumpWidget(
      Sizer(
        builder: (context, orientation, deviceType) {
          return const MaterialApp(home: HomeScreen());
        },
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('No users yet'), findsOneWidget);
  });

  testWidgets('HomeScreen has two tabs', (tester) async {
    await tester.pumpWidget(
      Sizer(
        builder: (context, orientation, deviceType) {
          return const MaterialApp(home: HomeScreen());
        },
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Users'), findsOneWidget);
    expect(find.text('Chat History'), findsOneWidget);
  });
}
