
printDayHeader(int day, String title) {
    print("");
    print('--- Day ${day.toString().padLeft(2, '0')}: $title ---');
    print("="*(16 + title.length));
    print("");
}

printPartHeader(int id, String title){
  print('\nPart $id: $title');
  print("-"*(8 + title.length));
}

