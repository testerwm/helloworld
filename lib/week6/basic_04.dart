import 'dart:io';

void main (){
  // 类型相关的运算符
  // as is is!
  Object a = 'hello';
  print(a is String);

  print(a is! num);
  print(a is num);

  String b = a as String;
  print(b);
  print(b.toUpperCase());

}

