import 'package:flutter_test/flutter_test.dart';
import 'package:music_streaming_app_native/main.dart';

void main() {
  testWidgets('app builds root', (WidgetTester tester) async {
    await tester.pumpWidget(const HarmonyMusicApp());
    expect(find.text('Discover'), findsOneWidget);
  });
}
