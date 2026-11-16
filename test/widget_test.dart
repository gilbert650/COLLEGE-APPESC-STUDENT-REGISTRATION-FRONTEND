import 'package:flutter_test/flutter_test.dart';
import 'package:student_exam_app/main.dart';

void main() {
  testWidgets('App starts and shows college name', (WidgetTester tester) async {
    await tester.pumpWidget(const StudentExamApp());
    expect(find.textContaining('APPEC'), findsWidgets);
  });
}
