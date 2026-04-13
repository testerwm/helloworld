import 'Person.dart';

void main() {
  Person? person3;
  person3?.hello();
  person3 = person2;
  if (identical(person2, person3)) {
// 하나의같은객체에대한참조를가짐
    print('same object');
    person3.hello();
  }
}