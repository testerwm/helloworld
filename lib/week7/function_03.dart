import 'Person.dart';

void main() {
  var person1 = new Person();
  person1.name = 'Leo';
//person1._age = 19;
  person1.age = 19;
  person1.hello();
  print('${person1.name} : age : ${person1.age}' );
}