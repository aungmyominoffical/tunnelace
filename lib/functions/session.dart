import 'package:get/get.dart';
import 'package:tunnelace/controller/sessioncontroller.dart';
import 'package:tunnelace/controller/sessiondatabase.dart';

class SessionService {

  static addSessions({required int sec})async{
    int? session = await SessionDatabase.getSessions(showUpdate: false);
    session = session! + sec;
    SessionDatabase.setSessions(sec: session);
  }

  static countSessions()async{
    SessionsController sessionsController = Get.put(SessionsController());
    int? session = await SessionDatabase.getSessions(showUpdate: false);
    if(session! > 0){
      session = session - 1;
      SessionDatabase.setSessions(sec: session);
      sessionsController.setSessions(sec: session);
    }
  }
}