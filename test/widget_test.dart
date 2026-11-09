import 'package:flutter_test/flutter_test.dart';
import 'package:studymate/main.dart';

void main() {
  testWidgets('StudyMate welcome screen loads',
          (WidgetTester tester) async {
        await tester.pumpWidget(const StudyMateApp());

        expect(find.text('StudyMate'), findsOneWidget);
        expect(find.text('Get Started'), findsOneWidget);
      });
}