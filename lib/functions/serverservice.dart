import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:tunnelace/controller/servercontroller.dart';
import 'dart:convert' as convert;

import 'package:tunnelace/modal/servermodal.dart';

class ServerService {
  
  static getServers()async{
    ServerController serverController = Get.put(ServerController());
    http.Response api = await http.get(Uri.parse("https://api.npoint.io/0c614f9ceb5f459d3acc"));

    if(api.statusCode == 200){
      List response = convert.jsonDecode(api.body);
      List<ServerModal> servers = response.map((e) {
        return ServerModal.fromJson(e);
      }).toList();
      serverController.setServers(data: servers);
      serverController.setLoading(data: false);
    }
  }
  
}