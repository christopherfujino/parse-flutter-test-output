import 'dart:io' as io;

import 'package:parse_flutter_test_output/parse_flutter_test_output.dart';

void main() {
  // must be called from root of package
  final passing = TestOutputParser(io.File('./logs/passing.txt').readAsStringSync());
  print('''

      Passing Tests:

''');
  passing.tests.forEach((Test test) {
    print('${test.fileName} - ${test.testName} -> ${(test.lapsedSeconds / 60).floor().toString().padLeft(2, '0')}:${(test.lapsedSeconds % 60).floor().toString().padLeft(2, '0')}');
  });
  int seconds = passing.lapsedSecondsForAllTests;
  print('lapsed time for all passing tests: ${(seconds / 60).floor().toString().padLeft(2, '0')}:${(seconds % 60).toString().padLeft(2, '0')}');
  print('''

      Failing Tests:

''');
  final timingOut = TestOutputParser(io.File('./logs/timing_out.txt').readAsStringSync());
  timingOut.tests.forEach((Test test) {
    print('${test.fileName} - ${test.testName} -> ${(test.lapsedSeconds / 60).floor().toString().padLeft(2, '0')}:${(test.lapsedSeconds % 60).floor().toString().padLeft(2, '0')}');
  });
  seconds = timingOut.lapsedSecondsForAllTests;
  print('lapsed time for all passing tests: ${(seconds / 60).floor().toString().padLeft(2, '0')}:${(seconds % 60).toString().padLeft(2, '0')}');
}
