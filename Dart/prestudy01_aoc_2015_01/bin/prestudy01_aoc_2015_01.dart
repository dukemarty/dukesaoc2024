import 'package:prestudy01_aoc_2015_01/prestudy01_aoc_2015_01.dart' as prestudy01_aoc_2015_01;
import 'package:prestudy01_aoc_2015_01/aoc.dart' as aoc;
import 'package:prestudy01_aoc_2015_01/io_utils.dart' as io;

void main(List<String> arguments) async {
  print('Hello world: ${prestudy01_aoc_2015_01.calculate()}!');
  aoc.printDayHeader(1, "Not Quite Lisp");

  var data = await io.readSingleLine("puzzle.txt");

  part1(data);

  print("");

  part2(data);
}

part1(String data){

  aoc.printPartHeader(1, "Finally reached floor");

  var level = 0;
  data.runes.forEach((rune) {
    if (String.fromCharCode(rune) == ')'){
      level = level - 1;
    } else if (String.fromCharCode(rune) == "(") {
      level = level + 1;
    }
   });

   print('Final floor: $level');
}

part2(String data){

  aoc.printPartHeader(2, "First time basement");

  var level = 0;
  var pos = 1;
  data.runes.forEach((rune) {
    if (String.fromCharCode(rune) == ')'){
      level = level - 1;
    } else if (String.fromCharCode(rune) == "(") {
      level = level + 1;
    }

    if (level == -1){
      print('First time reached basement in pos: $pos');
      break;
    }

    pos = pos + 1;
   });
}

