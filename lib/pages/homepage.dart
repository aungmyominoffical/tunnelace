import 'dart:async';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:openvpn_flutter_update/openvpn_flutter.dart';
import 'package:tunnelace/components/signal.dart';
import 'package:tunnelace/constant/constants.dart';
import 'package:tunnelace/controller/servercontroller.dart';
import 'package:tunnelace/controller/sessioncontroller.dart';
import 'package:tunnelace/controller/sessiondatabase.dart';
import 'package:tunnelace/functions/serverservice.dart';
import 'package:tunnelace/functions/session.dart';
import 'package:tunnelace/pages/servers.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  SessionsController sessionsController = Get.put(SessionsController());
  ServerController serverController = Get.put(ServerController());
  bool positive = false;
  late OpenVPN engine;
  VpnStatus? status;
  VPNStage? stage;
  Timer? timer;
  bool running  = false;



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ServerService.getServers();
    WidgetsBinding.instance.addObserver(this);

    engine = OpenVPN(
      onVpnStatusChanged: (data) {
        setState(() {
          status = data;
        });
      },
      onVpnStageChanged: (data, raw) {
        setState(() {
          stage = data;
        });
        if(stage == VPNStage.connected){
          setState(() {
            positive = true;
          });
          countDown();
        }
        if(stage == VPNStage.disconnected){
          setState(() {
            positive = false;
          });
          cancelCount();
        }
      },
    );

    engine.initialize(
      groupIdentifier: "group.com.laskarmedia.vpn",
      providerBundleIdentifier:
      "id.laskarmedia.openvpnFlutterExample.VPNExtension",
      localizedDescription: "VPN by Nizwar",
      lastStage: (stage) {
        setState(() {
          this.stage = stage;
        });
        if(this.stage == VPNStage.connected){
          setState(() {
            positive = true;
          });

        }
        if(this.stage == VPNStage.disconnected){
          setState(() {
            positive = false;
          });
          cancelCount();
        }
      },
      lastStatus: (status) {
        setState(() {
          this.status = status;
        });
      },
    );
    initiateFun();
  }


  initiateFun()async{
    await SessionDatabase.init();
    await SessionDatabase.getSessions(showUpdate: true);
  }

 connectVpn()async{
    http.Response api = await http.get(Uri.parse(serverController.selectedServer.config!));
    if(api.statusCode == 200){
      engine.connect(api.body, "${serverController.selectedServer.country}",
          certIsRequired: true);
      if (!mounted) return;
    }else{
      Fluttertoast.showToast(
          msg: "Ohh , somethings was wrong!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
    }
   // engine.connect(AppConstants.config, "USA",
   //     certIsRequired: true);
   // if (!mounted) return;
 }

 disconnetctVpn()async{
    engine.disconnect();
 }


 countDown(){
    if(running == false){
      timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        SessionService.countSessions();
        if(sessionsController.sessions <= 0){
          timer.cancel();
          disconnetctVpn();
        }
      });
      setState(() {
        running = true;
      });
    }
 }

 cancelCount(){
    if(timer != null){
      timer!.cancel();
      setState(() {
        running = false;
      });
    }
 }

 String getStage({required VPNStage data}) {
    if(data == VPNStage.connected){
      return "CONNECTED";
    }else
    if(data == VPNStage.disconnected){
      cancelCount();
      return "DISCONNECTED";
    }else
    if(data == VPNStage.connecting){
      return "CONNECTING";
    }else
    if(data == VPNStage.disconnecting){
      return "DISCONNECTING";
    }else
    if(data == VPNStage.authenticating){
      return "AUTHEBTICATING";
    }else
    if(data == VPNStage.authentication){
      return "AUTHEBTICATION";
    }else
    if(data == VPNStage.denied){
      return "DENIED";
    }else
    if(data == VPNStage.prepare){
      return "PREPARE";
    }else
    if(data == VPNStage.error){
      return "ERROR";
    }else
    if(data == VPNStage.exiting){
      return "EXITING";
    }else
    if(data == VPNStage.get_config){
      return "GET CONFIG";
    }else{
      return "UNKNOWN";
    }

 }

  getBytes({required String bytes}){
    print("GG ${bytes}");
    if(bytes != "0"){
      String data = bytes.split("-")[1];
      return data;
    }
    return "";
  }

  String intToTimeLeft(int value) {
    int h, m, s;

    h = value ~/ 3600;

    m = ((value - h * 3600)) ~/ 60;

    s = value - (h * 3600) - (m * 60);

    String hourLeft = h.toString().length < 2 ? "0" + h.toString() : h.toString();

    String minuteLeft =
    m.toString().length < 2 ? "0" + m.toString() : m.toString();

    String secondsLeft =
    s.toString().length < 2 ? "0" + s.toString() : s.toString();

    String result = "$hourLeft:$minuteLeft:$secondsLeft";

    return result;
  }


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    disconnetctVpn();
    WidgetsBinding.instance.removeObserver(this);
  }


  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.detached) return;

    if(state == AppLifecycleState.detached){
      disconnetctVpn();
    }

    /* if (isBackground) {
      // service.stop();
    } else {
      // service.start();
    }*/
  }

  String serverType({required String type}){
    if(type == "tcp"){
      return "TCP";
    }else{
      return "UDP";
    }
  }


  showServers(){
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            padding: EdgeInsets.only(
              top: 10
            ),
            child: GetBuilder<ServerController>(
              builder: (serverController){
                return Column(
                  children: serverController.servers.map((e) {
                    return ListTile(
                      onTap: (){
                        serverController.setSelectedServer(data: e);
                        Navigator.pop(context);
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
                              child: Icon(Icons.circle,color: e.id == serverController.selectedServer.id ? Colors.green : Colors.transparent,size: 20,),
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
          );
        });
  }

  @override
  Widget build(BuildContext context) {

    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppConstants.mainColor,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: const Image(
                image: AssetImage("assets/logos/logo.png"),
                width: 50,
                height: 50,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(
                left: 20
              ),
              child: Text(AppConstants.appName,style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                fontFamily: "Adl"
              ),),
            )
          ],
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          ClipPath(
            clipper: WaveClipperTwo(),
            child: Container(
              height: height * 0.6,
              width: width,
              color: AppConstants.mainColor,
              padding: const EdgeInsets.only(
                top: 10,
                bottom: 70,
                left: 10,
                right: 10
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Secured Time",style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold

                  ),),
                   GetBuilder<SessionsController>(
                       builder: (sessionsController){
                         return Text("${intToTimeLeft(sessionsController.sessions)}",style: const TextStyle(
                             color: Colors.white,
                             fontWeight: FontWeight.bold,
                             fontSize: 30
                         ),);
                       }
                   ),
                  AnimatedToggleSwitch<bool>.dual(
                    current: positive,
                    first: false,
                    second: true,
                    dif: 60.0,
                    borderColor: Colors.transparent,
                    borderWidth: 5.0,
                    height: 55,
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        spreadRadius: 1,
                        blurRadius: 2,
                        offset: Offset(0, 1.5),
                      ),
                    ],
                    loadingIconBuilder: (context, global) {
                      double pos = global.position;
                      double transitionValue = pos - pos.floorToDouble();
                      return Transform.rotate(
                        angle: 2.0 * pi * transitionValue,
                        child: Stack(children: [
                          Opacity(
                              opacity: 1 - transitionValue,
                              child: iconBuilder(pos.floor(), global.indicatorSize)),
                          Opacity(
                              opacity: transitionValue,
                              child: iconBuilder(pos.ceil(), global.indicatorSize))
                        ]),
                      );
                    },
                    onChanged: (b) async{
                      if(sessionsController.sessions <= 0){
                        Fluttertoast.showToast(
                            msg: "Get Session Times",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0
                        );
                      }else if(serverController.selectedServer.type == null){
                        Fluttertoast.showToast(
                            msg: "Select Server",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0
                        );
                      }else{
                        if(await engine.isConnected() == true){
                          await disconnetctVpn();
                        }else{
                          await connectVpn();
                        }
                        setState(() {
                          positive = !positive;
                        });
                      }

                      return Future.delayed(const Duration(seconds: 2));
                    },
                    colorBuilder: (b) => b ? Colors.green : Colors.red,
                    iconBuilder: (value) => value
                        ? const Icon(Icons.lock,color: Colors.white,size: 30,)
                        : const Icon(Icons.cloud_off,color: Colors.white,size: 30,),
                    textBuilder: (value) => value
                        ? const Center(child: Text('On',style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20
                    ),))
                        : const Center(child: Text('Off',style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20
                    ),)),
                  ),
                  if(stage != null)
                  Text(getStage(data: stage!,),style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18
                  ),),
                  Container(
                    margin: const EdgeInsets.all(10),
                    padding: const EdgeInsets.only(
                      top: 10,
                      bottom: 20,
                      left: 5,
                      right: 5
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white,
                        width: 1
                      ),
                      color: Colors.white30
                    ),
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(
                            top: 5,
                            bottom: 5
                          ),
                          child: GetBuilder<ServerController>(
                            builder: (serverController){
                              if(serverController.selectedServer.type == null){
                                return ListTile(
                                  onTap: (){
                                    showServers();
                                    //Navigator.push(context, MaterialPageRoute(builder: (context) =>const  ServersPages()));
                                  },
                                  leading: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      color: Colors.red
                                    ),
                                    padding: const EdgeInsets.all(5),
                                    child: const Icon(Icons.cloud_off,color: Colors.white,),
                                  ),
                                  title: const Text("Select Server",style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17
                                  ),),
                                  trailing: const Icon(Icons.arrow_forward_ios,color: Colors.white,),
                                );
                              }else{
                                return ListTile(
                                  onTap: (){
                                    showServers();
                                    //Navigator.push(context, MaterialPageRoute(builder: (context) =>const  ServersPages()));
                                  },
                                  leading: ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child:  Image(
                                      image: AssetImage("assets/flags/${serverController.selectedServer.flag}.png"),
                                      width: 40,
                                      height: 40,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  title:  Text("${serverController.selectedServer.country}",style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),),
                                  subtitle: Text(serverType(type: serverController.selectedServer.type!),style: const  TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold
                                  ),),
                                  trailing: Container(
                                    width: 82,
                                    child: Row(
                                      children: [
                                        SignalWidget(rate: serverController.selectedServer.speed!,backgroundColor: Colors.white30,),
                                        IconButton(
                                          onPressed: (){},
                                          icon: const Icon(Icons.keyboard_arrow_down,color: Colors.white,size: 40,),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                        const Divider(
                          height: 1,
                          color: Colors.white,
                        ),
                        Container(
                          margin: const EdgeInsets.only(
                            top: 5,
                            bottom: 5
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(
                                  top: 5,
                                  bottom: 5,
                                  left: 10,
                                  right: 10
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.cloud_download_rounded,color: Colors.white,),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Text("${getBytes(bytes: status!.packetsIn.toString())}",style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold
                                    ),)
                                  ],
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(
                                    top: 5,
                                    bottom: 5,
                                    left: 10,
                                    right: 10
                                ),
                                child:  Row(
                                  children: [
                                    const Icon(Icons.cloud_upload_rounded,color: Colors.white,),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Text("${getBytes(bytes: status!.packetsOut.toString())}",style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold
                                    ),)
                                  ],
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: (){
              SessionService.addSessions(sec: 5);
            },
            child: Container(
              margin: const EdgeInsets.only(
                left: 10,
                right: 10,
                top: 30
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: AppConstants.mainColor
              ),
              width: width,
              height:45,
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.more_time_outlined,color: Colors.white,size: 30,),
                  Container(
                    margin: const EdgeInsets.only(
                      left: 10
                    ),
                    child: const Text("Session Times",style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18
                    ),),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}


Widget iconBuilder(int value, Size iconSize) {
  return rollingIconBuilder(value, iconSize, false);
}

Widget rollingIconBuilder(int? value, Size iconSize, bool foreground) {
  return const CupertinoActivityIndicator(
    animating: true,
    color: Colors.white,
  );
}