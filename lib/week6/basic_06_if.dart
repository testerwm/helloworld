import 'dart:io';

void main(){
/*

  print(" Scan num,Please :");
  var scan = stdin.readLineSync();
  num intScan = num.parse('$scan');
  if( intScan >= 0){
    print('>0');
  }else {
    print('<0');
  }
*/


  //q2
    //for
  List<String> colors = ['Yello', 'Red', "Blue"];

  for(var i = 0;i < colors.length;i++){
    print(colors[i]);
  }

  print("_________________________");

    //while
  var i = 0;
  while( i < colors.length){
    print(colors[i]);
    i++;
  }

  print("_________________________");

  var j = 3;
  do {
    print(j);
    j--;
  }while(j > 0);




}

