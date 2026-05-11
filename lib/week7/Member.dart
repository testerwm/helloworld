// 定义 Member 类
class Member {
  // 成员变量（属性）
  String name;

  // 构造函数
  Member(this.name) {
    // 构造函数执行时输出
    print("会员对象已创建");
  }
}

// 程序入口（类似 main）
void main() {
  // 创建对象，并传入名字 "박지성"
  Member member = Member("박지성");

  // 输出姓名
  print("会员姓名是：${member.name}");
}
