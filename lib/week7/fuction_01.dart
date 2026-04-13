
/*
void main(){
   const list = ['apple', 'bananas', 'oranges'];

    list.forEach((item){
    print('$list.indexof(item): $item');
  }
});
*/

  void main() {
  const list = ['apple', 'bananas', 'oranges'];

  list.forEach((item) {
    print('${list.indexOf(item)}: $item');
  });

  print("_________________________________________");

  const list_item = ['Laptop', 'Mouse', 'Keyboard'];

  list_item.forEach((item) {
    print('${list_item.indexOf(item)}: $item');
  });
  print("_________________________________________");


  const list_item2 = ['Laptop', 'Mouse', 'Keyboard'];
  list_item2.forEach((item) => print('${list_item2.indexOf(item)}: $item'));


  print("_________________________________________");


/*
   calculatePrice( price, [sale_code]){
    if(sale_code == null){
      print(price+ "无折扣");
    }else{
      print(price * sale_code + "zhekou 50%");
    }
  }

  calculatePrice(100);


  }
*/

  void calculatePrice(double price, [double? saleCode]) {
    if (saleCode == null) {
      print('$price 无折扣');
    } else {
      print('${price * saleCode} 折扣50%');
    }
  }


  calculatePrice(100);
  calculatePrice(100, 0.5);

    print("_________________________________________");

  void printStudentInfo(String name,{required int age, String professional = 'unknown'}){
    print('name: $name, age: $age, professional: $professional');
  }

  printStudentInfo("김민수", age: 21, professional: 'computer');
  printStudentInfo("이지은", age: 19);


    print("_________________________________________");





  }
