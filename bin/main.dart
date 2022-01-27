import 'dart:io' as io;

import 'package:parse_flutter_test_output/parse_flutter_test_output.dart';

void main() {
  // must be called from root of package
  print(
      generateReport(
          'Passing Tests',
          // TODO make paths configurable via CLI args
          TestOutputParser(io.File('./logs/passing.txt').readAsStringSync()),
      ),
  );
  print(
      generateReport(
          'Failing Tests',
          TestOutputParser(io.File('./logs/timing_out.txt').readAsStringSync()),
      ),
  );
}
