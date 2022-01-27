// @dart = 2.12

/// Parse the raw output of a LUCI buildbucket run.
///
/// For example https://logs.chromium.org/logs/flutter/buildbucket/cr-buildbucket/8824127510467410769/+/u/run_test.dart_for_tool_integration_tests_shard_and_subshard_1_6/test_stdout?format=raw
class TestOutputParser {
  TestOutputParser(this.rawLogs) {
    for (final String line in rawLogs.split('\n')) {
      final match = testPattern.firstMatch(line);
      if (match != null) {
        try {
          final groups = match.groups(<int>[1, 2, 3, 4]);
          final int minutes = int.tryParse(groups[0]!, radix: 10) ?? 0;
          final int seconds = int.tryParse(groups[1]!, radix: 10) ?? 0;
          final String fileName = groups[2]!.trim();
          final String testName = groups[3]!.trim();
          final String cacheKey = '$fileName - $testName';
          Test? testMaybe = _tests[cacheKey];
          if (testMaybe == null) {
            testMaybe = Test(fileName, testName, minutes, seconds);
            _tests[cacheKey] = testMaybe;
          } else {
            testMaybe.setFinish(minutes, seconds);
          }
        } on FormatException {
          print(match.group(2));
          print(line);
          rethrow;
        }
      }
    }
  }

  // 1 = minutes
  // 2 = seconds
  // 3 = file
  // 4 = test name
  static final testPattern = RegExp(r'^(\d{2}):(\d{2}) \+\d+.*: (.*): (.*)');

  final String rawLogs;

  // Key is '$fileName - $testName'
  final Map<String, Test> _tests = <String, Test>{};

  List<Test> get tests {
    final testList = _tests.values.toList();
    testList.sort((Test firstTest, Test secondTest) {
      return -firstTest.lapsedSeconds.compareTo(secondTest.lapsedSeconds);
    });
    return testList;
  }

  int get lapsedSecondsForAllTests {
    int lapsedSeconds = 0;
    for (final Test test in tests) {
      lapsedSeconds += test.lapsedSeconds;
    }
    return lapsedSeconds;
  }
}

class Test {
  Test(this.fileName, this.testName, int minutes, int seconds) : startingSeconds = minutes * 60 + seconds;

  final int startingSeconds;
  late int finishingSeconds;
  late final int lapsedSeconds = finishingSeconds - startingSeconds;

  void setFinish(int minutes, int seconds) {
    finishingSeconds = minutes * 60 + seconds;
  }

  final String fileName;
  final String testName;
}
