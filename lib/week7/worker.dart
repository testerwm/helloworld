abstract class worker{
  worker(){
    print("developer dev now");
  }
}

class Developer {

   worker(){
    print("developer dev now");
  }
}

class Designer{
  void worker(){
    print('Designer worker now');
  }
}


void main(){
  Developer dev = Developer();
  dev.worker();
  Designer designer = Designer();
  designer.worker();

}