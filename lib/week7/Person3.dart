class Person3 {

  String? name;

  void hello(){
    print('hello, im xxx');
  }

}


class Student extends Person3{
  int? studentId;

  @override
  void hello(){
    print('hello, im ${name = 'kim'}, id is "${studentId = 2024001}"');
  }

  void study() {
    print('${name} learn now');

  }

}

void main(){

  var stu = Student();
  stu.hello();
  stu.study();

}