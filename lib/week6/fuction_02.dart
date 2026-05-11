void printNumber(Function func, int num) {
  func(num);
}

void printEvenNumber(int num) {
  print('$num is even number');
}

void printOddNumber(int num) {
  print('$num is odd number');
}

void main() {
  int num;
  Function func;

  num = 3;
  func = num.isEven ? printEvenNumber : printOddNumber;
  func(num);

  num = 4;
  func = num.isEven ? printEvenNumber : printOddNumber;
  printNumber(func, num);

  print('-----------------------------------------');


}