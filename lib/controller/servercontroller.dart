

import 'package:get/get.dart';

import '../modal/servermodal.dart';

class ServerController extends GetxController{
  List<ServerModal> servers = [];
  ServerModal selectedServer = ServerModal();
  bool loading = true;


  setLoading({required bool data}){
    loading = data;
    update();
  }

  setServers({required List<ServerModal> data}){
    servers = data;
    update();
  }

  setSelectedServer({required ServerModal data}){
    selectedServer = data;
    update();
  }

}