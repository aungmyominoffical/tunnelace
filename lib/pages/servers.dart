import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tunnelace/components/signal.dart';
import 'package:tunnelace/constant/constants.dart';
import 'package:tunnelace/controller/servercontroller.dart';


class ServersPages extends StatefulWidget {
  const ServersPages({super.key});

  @override
  State<ServersPages> createState() => _ServersPagesState();
}

class _ServersPagesState extends State<ServersPages> {

  ServerController serverController = Get.put(ServerController());

  String serverType({required String type}){
    if(type == "tcp"){
      return "TCP";
    }else{
      return "UDP";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.mainColor,
      appBar: AppBar(
        backgroundColor: AppConstants.mainColor,
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios_new,color: Colors.white,),
        ),
        title: const Text("Server Location",style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Colors.white,
            ),
            child: GetBuilder<ServerController>(
              builder: (serverController){
                return Column(
                  children: serverController.servers.map((e) {
                    return ListTile(
                      onTap: (){
                        serverController.setSelectedServer(data: e);
                      },
                      leading:  CircleAvatar(
                        backgroundImage: AssetImage("assets/flags/${e.flag}.png"),
                      ),
                      title:  Text("${e.country}",style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 17
                      ),),
                      subtitle: Text("${serverType(type: e.type!)}"),
                      trailing: Container(
                        width: 60,
                        child: Row(
                          children: [
                            Container(
                              child: Icon(Icons.circle,color: e.id == serverController.selectedServer.id ? Colors.green : Colors.white,size: 20,),
                              width: 35,
                            ),
                            SignalWidget(rate: e.speed!, backgroundColor: Colors.black38)
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
