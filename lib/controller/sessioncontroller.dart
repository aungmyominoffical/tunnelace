

import 'package:get/get.dart';

class SessionsController extends GetxController{
  int sessions = 0;


  setSessions({required int sec}){
    sessions = sec;
    update();
  }

}