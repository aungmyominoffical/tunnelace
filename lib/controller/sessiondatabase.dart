

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tunnelace/controller/sessioncontroller.dart';

class SessionDatabase {

  static init ()async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final int? counter = prefs.getInt('sessions');
    if(counter == null){
      await prefs.setInt("sessions", 0);
    }
  }

  static Future<int?>? getSessions({required bool showUpdate})async{
    SessionsController sessionsController = Get.put(SessionsController());
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final int? counter = prefs.getInt('sessions');
    if(showUpdate == true){
      sessionsController.setSessions(sec: counter!);
    }
    return counter;
  }

  static setSessions({required int sec})async{
    SessionsController sessionsController = Get.put(SessionsController());
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('sessions',sec);
    sessionsController.setSessions(sec: sec);
    return;
  }

}