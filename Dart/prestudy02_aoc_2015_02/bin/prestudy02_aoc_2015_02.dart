import 'dart:math';

import 'package:args/args.dart';
import 'package:prestudy02_aoc_2015_02/aoc.dart' as aoc;
import 'package:prestudy02_aoc_2015_02/io_utils.dart' as io;
// import 'package:test/expect.dart';

const String version = '0.0.1';

ArgParser buildParser() {
  return ArgParser()
    ..addFlag(
      'help',
      abbr: 'h',
      negatable: false,
      help: 'Print this usage information.',
    )
    ..addFlag(
      'verbose',
      abbr: 'v',
      negatable: false,
      help: 'Show additional command output.',
    )
    ..addFlag(
      'version',
      negatable: false,
      help: 'Print the tool version.',
    );
}

void printUsage(ArgParser argParser) {
  print('Usage: dart prestudy02_aoc_2015_02.dart <flags> [arguments]');
  print(argParser.usage);
}

void main(List<String> arguments) async {
  final ArgParser argParser = buildParser();
  try {
    final ArgResults results = argParser.parse(arguments);
    bool verbose = false;

    // Process the parsed arguments.
    if (results.wasParsed('help')) {
      printUsage(argParser);
      return;
    }
    if (results.wasParsed('version')) {
      print('prestudy02_aoc_2015_02 version: $version');
      return;
    }
    if (results.wasParsed('verbose')) {
      verbose = true;
    }

    // Act on the arguments provided.
    print('Positional arguments: ${results.rest}');
    if (verbose) {
      print('[VERBOSE] All arguments: ${results.arguments}');
    }
  } on FormatException catch (e) {
    // Print usage information if an invalid argument was provided.
    print(e.message);
    print('');
    printUsage(argParser);
  }

  aoc.printDayHeader(2, "I Was Told There Would Be No Math");

  var data = await io.readLines("puzzle.txt");

  part1(data);

  print("");

  part2(data);
}

part1(List<String> data){
  aoc.printPartHeader(1, "Required wrapping paper");

  var res = 0;
  for (var line in data) {
    final parts = line.split("x");

    final l = int.parse(parts[0]);
    final w = int.parse(parts[1]);
    final h = int.parse(parts[2]);

    final s1 = l*w;
    final s2 = l*h;
    final s3 = w*h;

    final reqPaper = 2*(s1 + s2 + s3) + min(min(s1, s2), s3).round();
    // print('Processed sizes: $l $w $h  ->  Required wrapping: $reqPaper');

    res = res + reqPaper;
  }

  print('Required wrapping paper (square feet): $res');
}

part2(List<String> data){
  aoc.printPartHeader(2, "Required ribbon");

  var res = 0;
  for (var line in data){
    final parts = line.split("x");
    var dims = parts.map((e) => int.parse(e)).toList();
    dims.sort();
    // print('${dims[0]} ${dims[1]} ${dims[2]}');

    final reqRibbon = 2*dims[0] + 2* dims[1] + dims[0]*dims[1]*dims[2];
    // print('Dimensions: ${dims}  ->  Required ribbons: $reqRibbon');

    res = res + reqRibbon;
  }

  print('Required ribbon: $res');

}