class User{
  String name;

  //默认构造函数
  User(this.name);

  //命名构造函数

  User.guest() : name = "Guest";
}

void main(){
  var user1 = User("Tom");
  print(user1.name);

  var user2 = User.guest();
  print(user2.name);


}