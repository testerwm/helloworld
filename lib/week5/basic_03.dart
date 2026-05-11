import 'dart:io';

void main (){
  // question 1
  var a = 10;
  var b = 3;
  print(a + b );
  print(a / b );


  // q2
  print(a+=5);

  //q3
  var c = 5;
  print(c++);
  print(c);
  print(++c);


  //q4

  var x =7;
  var y = 10;
  print(x>y);
  print(x<=y);
  print(x == y);

  //q5
/*

  var run;
  var isRaining = false;
  var hasUmbrella = true;
  print("Scan your weather: ");
  run = stdin.readLineSync();
  if(run == "0" ){
   print(isRaining);
  } else{
    print(hasUmbrella);
  }

*/

  //q6
  var p = 6;
  var q = 3;
  print(p & q);
  print(p | q);

  //q7

  print(p << 1);
  print(p >> 1);

  //q8
  var age;
  String visibility = age ? '18' : '20';
  print(visibility);







}

