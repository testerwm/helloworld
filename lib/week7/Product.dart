class Product {
  String name;

  Product(this.name){
    print("run this ");
  }

  Product.init(this.name){
    print("run this init");
  }
}


void main(){
  Product product = new Product("shop");

  print(product.name);

  print(Product.init("sss"));

  Product product1= Product.init("sss");
  print(product1.name);
}