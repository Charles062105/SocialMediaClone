import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:social_media/auth/login.dart';
import 'package:social_media/views/profile_view.dart';

Future<void> logIn(WidgetTester tester) async {
  await tester.enterText(find.byType(TextField).at(0), 'michael');
  await tester.enterText(find.byType(TextField).at(1), 'password');
  await tester.tap(find.text('LOGIN'));
  await tester.pumpAndSettle();
}

Future<void> openFirstPost(WidgetTester tester) async {
  await logIn(tester);
  final postCaption = find.text('Taking in a peaceful sunrise.');
  await tester.scrollUntilVisible(
    postCaption,
    300,
    scrollable: find.byType(Scrollable).first,
  );
  await tester.pumpAndSettle();
  await tester.tap(postCaption);
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('login opens the profile with friends and posts', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: LoginForm()));

    await logIn(tester);

    expect(find.text('Charles Mike L. Quimado'), findsWidgets);
    expect(find.text('Friends'), findsOneWidget);
    expect(find.text('Followers'), findsOneWidget);
    expect(find.text('1B'), findsOneWidget);
    expect(find.text('12.8K'), findsOneWidget);
    expect(find.text('Posts'), findsOneWidget);

    final postCaption = find.text('Taking in a peaceful sunrise.');
    await tester.scrollUntilVisible(
      postCaption,
      300,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Taking in a peaceful sunrise.'), findsOneWidget);
  });

  testWidgets('login reports missing username and password', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: LoginForm()));

    await tester.tap(find.text('LOGIN'));
    await tester.pumpAndSettle();
    expect(find.text('Please input your username'), findsOneWidget);

    await tester.enterText(find.byType(TextField).at(0), 'michael');
    await tester.tap(find.text('LOGIN'));
    await tester.pumpAndSettle();
    expect(find.text('Please input your password'), findsOneWidget);
  });

  testWidgets('tapping a post opens its comments and back returns', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: LoginForm()));

    await openFirstPost(tester);

    expect(find.byType(ProfileView), findsOneWidget);
    expect(find.text('Taking in a peaceful sunrise.'), findsOneWidget);
    final comment = find.text('This is a sample comment.');
    await tester.scrollUntilVisible(
      comment,
      300,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Ethan'), findsOneWidget);
    expect(comment, findsOneWidget);

    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();

    expect(find.byType(ProfileView), findsNothing);
    expect(find.text('TIKTOKTOK'), findsOneWidget);
  });

  testWidgets('comments can be liked and replied to', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: LoginForm()));

    await openFirstPost(tester);
    await tester.scrollUntilVisible(
      find.text('This is a sample comment.'),
      300,
      scrollable: find.byType(Scrollable).first,
    );

    final commentLike = find.text('Like').last;
    await tester.ensureVisible(commentLike);
    await tester.pumpAndSettle();
    await tester.tap(commentLike);
    await tester.pumpAndSettle();
    expect(find.text('Liked'), findsOneWidget);

    final replyButton = find.text('Reply').first;
    await tester.ensureVisible(replyButton);
    await tester.pumpAndSettle();
    await tester.tap(replyButton);
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'Nice photo');
    await tester.tap(find.widgetWithText(TextButton, 'Reply').last);
    await tester.pumpAndSettle();

    expect(find.text('You: Nice photo'), findsOneWidget);
  });
}
