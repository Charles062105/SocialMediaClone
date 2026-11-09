import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:social_media/main.dart';
import 'package:social_media/models/demo_data.dart';
import 'package:social_media/features/posts/controllers/comments_controller.dart';
import 'package:social_media/services/comment_storage_service.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('login opens the TIKTOKTOK profile', (tester) async {
    await tester.pumpWidget(const TikTokTokApp());

    await tester.enterText(
      find.byKey(const ValueKey('username-field')),
      'michael',
    );
    await tester.enterText(
      find.byKey(const ValueKey('password-field')),
      'password',
    );
    await tester.tap(find.text('LOGIN'));
    await tester.pumpAndSettle();

    expect(find.text('Charles Mike L. Quimado'), findsOneWidget);
    expect(find.text('Friends'), findsOneWidget);
    expect(find.text('6'), findsOneWidget);
    expect(find.text('Followers'), findsOneWidget);
    expect(find.text('1B'), findsOneWidget);
    expect(find.text('12.8K'), findsOneWidget);
  });

  testWidgets('login rejects empty credentials', (tester) async {
    await tester.pumpWidget(const TikTokTokApp());

    await tester.tap(find.text('LOGIN'));
    await tester.pumpAndSettle();

    expect(find.text('Enter your username.'), findsOneWidget);
    expect(find.text('Enter your password.'), findsOneWidget);
  });

  testWidgets('login shows loading and disables the button', (tester) async {
    await tester.pumpWidget(const TikTokTokApp());
    await tester.enterText(
      find.byKey(const ValueKey('username-field')),
      'charles',
    );
    await tester.enterText(
      find.byKey(const ValueKey('password-field')),
      'password',
    );
    await tester.tap(find.text('LOGIN'));
    await tester.pump();

    expect(find.byKey(const ValueKey('login-progress')), findsOneWidget);
    expect(
      tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
      isNull,
    );

    await tester.pump(const Duration(milliseconds: 400));
    await tester.pumpAndSettle();
    expect(find.text('Charles Mike L. Quimado'), findsOneWidget);
  });

  testWidgets('comments persist when leaving and reopening a post', (
    tester,
  ) async {
    await tester.pumpWidget(const TikTokTokApp());
    await tester.enterText(
      find.byKey(const ValueKey('username-field')),
      'michael',
    );
    await tester.enterText(
      find.byKey(const ValueKey('password-field')),
      'password',
    );
    await tester.tap(find.text('LOGIN'));
    await tester.pumpAndSettle();

    final postCaption = find.text('A quiet morning, thoughtfully spent.');
    await tester.scrollUntilVisible(
      postCaption,
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.ensureVisible(postCaption);
    await tester.pumpAndSettle();
    await tester.tap(postCaption);
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('2 Comments'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('2 Comments'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'A new saved comment');
    await tester.tap(find.byTooltip('Send comment'));
    await tester.pumpAndSettle();
    expect(find.text('3 Comments'), findsOneWidget);

    await tester.tap(find.byTooltip('Back to profile'));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      postCaption,
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.ensureVisible(postCaption);
    await tester.pumpAndSettle();
    await tester.tap(postCaption);
    await tester.pumpAndSettle();
    await tester.drag(
      find.byType(CustomScrollView).last,
      const Offset(0, 1000),
    );
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('3 Comments'),
      300,
      scrollable: find.byType(Scrollable).first,
    );

    expect(find.text('3 Comments'), findsOneWidget);
  });

  test('every post has at least one million likes', () {
    expect(DemoData.posts, isNotEmpty);
    expect(DemoData.posts.every((post) => post.likes >= 1000000), isTrue);
  });

  test(
    'saved comments survive a controller and storage adapter restart',
    () async {
      final post = DemoData.posts.first;
      final firstSession = CommentsController(
        post: post,
        account: DemoData.account,
        storage: CommentStorageService(),
      );
      await firstSession.load();
      expect(await firstSession.addComment('Saved across launch'), isTrue);
      firstSession.dispose();

      final nextSession = CommentsController(
        post: post,
        account: DemoData.account,
        storage: CommentStorageService(),
      );
      await nextSession.load();
      expect(
        nextSession.comments.any(
          (comment) => comment.text == 'Saved across launch',
        ),
        isTrue,
      );
      nextSession.dispose();
    },
  );

  test('friend portraits and profile photo follow the supplied order', () {
    expect(DemoData.friends.map((friend) => friend.name).toList(), [
      'Johnny Sins',
      'Manny Pacquiao',
      'Mia Khalifa',
      'Jeo Ong',
      'Peter Parker',
      'Ethan Mafia',
    ]);
    expect(DemoData.account.avatarPath, 'assets/profile_charles.png');
  });

  testWidgets('brand uses black and white with red likes', (tester) async {
    await tester.pumpWidget(const TikTokTokApp());
    final theme = Theme.of(tester.element(find.text('TIKTOKTOK')));

    expect(theme.colorScheme.primary, const Color(0xFF111111));
    expect(theme.colorScheme.secondary, const Color(0xFFE53935));
    expect(find.text('TIKTOKTOK'), findsOneWidget);
  });

  test('all seven supplied portraits are bundled app assets', () async {
    final paths = [
      DemoData.account.avatarPath,
      ...DemoData.friends.map((friend) => friend.imagePath),
    ];
    for (final path in paths) {
      await rootBundle.load(path);
    }
  });

  testWidgets('corrupt saved comments show an error and keep defaults', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({
      'comments_charles-post-1': '{invalid json',
    });
    await tester.pumpWidget(const TikTokTokApp());
    await tester.enterText(
      find.byKey(const ValueKey('username-field')),
      'charles',
    );
    await tester.enterText(
      find.byKey(const ValueKey('password-field')),
      'password',
    );
    await tester.tap(find.text('LOGIN'));
    await tester.pumpAndSettle();

    final postCaption = find.text('A quiet morning, thoughtfully spent.');
    await tester.scrollUntilVisible(
      postCaption,
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.ensureVisible(postCaption);
    await tester.pumpAndSettle();
    await tester.tap(postCaption);
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('Saved comments were damaged. Default comments are shown.'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.scrollUntilVisible(
      find.text('2 Comments'),
      300,
      scrollable: find.byType(Scrollable).first,
    );

    expect(
      find.text('Saved comments were damaged. Default comments are shown.'),
      findsOneWidget,
    );
    expect(find.text('2 Comments'), findsOneWidget);
    expect(
      (await SharedPreferences.getInstance()).getString(
        'comments_charles-post-1',
      ),
      isNull,
    );
  });

  testWidgets(
    'comments reject blanks, cap length and can be restored after delete',
    (tester) async {
      await tester.pumpWidget(const TikTokTokApp());
      await tester.enterText(
        find.byKey(const ValueKey('username-field')),
        'charles',
      );
      await tester.enterText(
        find.byKey(const ValueKey('password-field')),
        'password',
      );
      await tester.tap(find.text('LOGIN'));
      await tester.pumpAndSettle();

      final postCaption = find.text('A quiet morning, thoughtfully spent.');
      await tester.scrollUntilVisible(
        postCaption,
        300,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.ensureVisible(postCaption);
      await tester.pumpAndSettle();
      await tester.tap(postCaption);
      await tester.pumpAndSettle();

      await tester.scrollUntilVisible(
        find.text('2 Comments'),
        300,
        scrollable: find.byType(Scrollable).first,
      );
      final field = find.byType(TextField);
      await tester.enterText(field, '   ');
      await tester.tap(find.byTooltip('Send comment'));
      await tester.pumpAndSettle();
      expect(find.text('Enter a comment before sending.'), findsOneWidget);

      await tester.enterText(field, 'x' * 340);
      await tester.pump();
      expect(tester.widget<TextField>(field).controller!.text.length, 300);
      expect(find.text('300/300'), findsOneWidget);

      await tester.testTextInput.receiveAction(TextInputAction.send);
      await tester.pumpAndSettle();
      tester.testTextInput.hide();
      await tester.pumpAndSettle();
      await tester.scrollUntilVisible(
        find.text('Love this shot.'),
        300,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.byTooltip('Delete comment').first);
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('Delete comment').first);
      await tester.pumpAndSettle();
      expect(find.text('Delete comment?'), findsOneWidget);
      await tester.tap(find.text('Delete'));
      await tester.pumpAndSettle();
      expect(find.text('Comment deleted.'), findsOneWidget);
      await tester.tap(find.text('Undo'));
      await tester.pumpAndSettle();
      expect(find.text('Comment restored.'), findsOneWidget);

      await tester.tap(find.byTooltip('Back to profile'));
      await tester.pumpAndSettle();
      await tester.scrollUntilVisible(
        postCaption,
        300,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.ensureVisible(postCaption);
      await tester.pumpAndSettle();
      await tester.tap(postCaption);
      await tester.pumpAndSettle();
      await tester.scrollUntilVisible(
        find.text('3 Comments'),
        300,
        scrollable: find.byType(Scrollable).first,
      );
      expect(find.text('3 Comments'), findsOneWidget);
    },
  );
}
