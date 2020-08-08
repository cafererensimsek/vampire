import 'package:flutter_test/flutter_test.dart';
import 'package:vampir/Classes/end_night.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('end_night.dart', () {
    test('a non-null value should be returned', () {
      final String result = EndNight('562823').findVillagerChoice();
      expect(result, 'caferen');
    });
    test('firestore data change is expected', () {
      EndNight('562823').killVillagerChoice('562823', 'caferen');
      expect('test', 'test');
    });
  });
}
