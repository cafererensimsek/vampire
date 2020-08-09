import 'package:flutter_test/flutter_test.dart';
import 'package:vampir/Classes/end_night.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('end_night.dart', () {
    test('a non-null value should be returned', () {
      String villagerChoice;
      EndNight().findVillagerChoice('562823');
      expect(villagerChoice, 'caferen');
    });
    test('a non-null value should be returned', () {
      var result = EndNight().findKey({'caferen': 3}, 3);
      expect(result, 'caferen');
    });
  });
}
