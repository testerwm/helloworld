import 'dart:io';

void main(){

  //q9
  var statusCodes = [100, 200, 301, 302, 999];
  for(var i =0; i<=statusCodes.length-1 ;i++){
    switch (statusCodes[i]){
      case 100 :
        print('100 : OPEN');
      case 200 :
        print('200 : APPROVED');
      case 301 :
        print('301 : DENIED with Error');
      case 302 :
        print('302 : DENIED with Error');
      case 999 :
        print('999 : unknown status');
    }
  }



    /*
    * q10-1
    * */
  for(int i = 1; i <= 5; i++){
    print(i);
  }

  /*
  * q10-2
  * */
  for(int i = 0;i <= 10; i++){
    if(i%2 !=0){
      print(i);
    }
  }

  print("___________________");

  for(int i = 0;i <= 10; i++){
    if(i%2 ==1){
      print(i);
    }
  }
print("___________________");
  // q10-3
  for(int i = 1; i <=10; i++){
    if(i%3 != 0 && i <= 8){
      print(i);
    }
  }

}

