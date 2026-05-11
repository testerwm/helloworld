class Persongou {

  String? name;

  Persongou(){
    print('Person unnamed Constructor Called');

  }
}


class Student extends Persongou{
  int? studentId;

  Student(){
    print('Student unnamed Constructor Called');

  }
}


void main(){
  var student =  Student();
  print(student.name = '111');
  print(student.studentId = 12);
}