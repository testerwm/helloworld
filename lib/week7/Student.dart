class Student {
  // 成员변수
  late String name;
  late int grade;

  // 构造函数
  Student() {
    print('Student Created..');
  }

  // 自我介绍方法
  void introduce() {
    print('你好，我是${name}，是${grade}年级学生。');
  }
}

void main() {
  // ---------- 普通方式创建对象 ----------
  var student1 = Student();
  student1.name = '김철수';
  student1.grade = 2;
  student1.introduce();

  print('-----------------------------------------');

  // ---------- 级联运算符 .. 创建对象 ----------
  var student2 = Student()
    ..name = '이영희'
    ..grade = 3
    ..introduce();

  print('-----------------------------------------');

  // ---------- 可空对象 ----------
  Student? student3;
  student3?.introduce(); // student3 为 null，安全调用，不执行不报错

  print('student3 为 null，所以上面没有任何输出');
}