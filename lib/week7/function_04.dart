import 'Person.dart';

void main() {
  var person2 = Person()
    ..name = 'Jane'
    ..hello();
  print('${person2.name} : age : ${person2.age}');

}