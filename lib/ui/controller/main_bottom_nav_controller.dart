import 'package:get/get.dart';

class MainBottomNavController extends GetxController{
  int _selectedIndex = 0;
  int get selectedIndex => _selectedIndex;
  receiveIndex (index){
    _selectedIndex = index;
    update();
  }

  void backToHome(){
    _selectedIndex = 0;
    update();
  }

}