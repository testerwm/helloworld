
  /*
  类（class）
  构造函数
  方法（普通方法 / 静态方法）
  对象创建与调用
  getter / setter
  命名构造函数
  */

// 定义一个类
class Person {
  // 属性
  String name;
  int age;

  // 默认构造函数
  Person(this.name, this.age);

  // 命名构造函数
  Person.withNameOnly(String name) : this(name, 0);

  // getter
  String get info => "姓名: $name, 年龄: $age";

  // setter
  set updateAge(int newAge) {
    if (newAge >= 0) {
      age = newAge;
    }
  }

  // 普通方法
  void introduce() {
    print("你好，我叫 $name，今年 $age 岁。");
  }

  // 带返回值的方法
  int addAge(int years) {
    age += years;
    return age;
  }

  // 静态方法
  static void sayHello() {
    print("这是一个静态方法，可以不用创建对象调用");
  }
}

void main() {
  // 创建对象
  var p1 = Person("张三", 20);

  // 调用普通方法
  p1.introduce();

  // 调用带返回值的方法
  int newAge = p1.addAge(5);
  print("增加后的年龄: $newAge");

  // 使用 getter
  print(p1.info);

  // 使用 setter
  p1.updateAge = 30;
  print("更新后的年龄: ${p1.age}");

  // 使用命名构造函数
  var p2 = Person.withNameOnly("李四");
  p2.introduce();

  // 调用静态方法（不用实例化对象）
  Person.sayHello();
}