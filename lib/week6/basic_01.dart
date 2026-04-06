import 'dart:io';

void main (){
  var name;
  print("Scan your name: ");
  name = stdin.readLineSync();
  if (name == null || name.trim().isEmpty){
    print("guest");
  }else{
    print("Name is $name");
  }

}

