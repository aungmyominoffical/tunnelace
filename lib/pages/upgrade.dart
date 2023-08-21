import 'package:flutter/material.dart';

import '../constant/constants.dart';



class UpgradePage extends StatefulWidget {
  const UpgradePage({super.key});

  @override
  State<UpgradePage> createState() => _UpgradePageState();
}

class _UpgradePageState extends State<UpgradePage> {

  int selectIndex = 0;

  List pricing = [
    {
      "month":"6",
      "save":39,
      "price":89.99
    },
    {
      "month":"3",
      "save": 30,
      "price":51.99
    },
    {
      "month":"1",
      "save": 0,
      "price":24.99
    },

  ];


  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

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
        title: const Text("Premium",style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),),
      ),
      body: Center(
        child: Container(
          height: 200,
          width: width,
          padding: const EdgeInsets.only(
            left: 10,
            right: 10
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,

            children: pricing.map((e) {
              int index = pricing.indexOf(e);

              return GestureDetector(
                onTap: (){
                  setState(() {
                    selectIndex = index;
                  });
                },
                child:  Stack(
                  children: [
                    Container(
                      width: width * 0.3,
                      height: 300,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white,
                          border: Border.all(
                              color: selectIndex == index ? Colors.black : Colors.white,
                              width: 5
                          )
                      ),
                      padding: const EdgeInsets.only(
                          top: 10,
                          bottom: 10
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              Text(e["month"],style: TextStyle(
                                  color: AppConstants.mainColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 30
                              ),),
                              Text(index == 2 ? "month" : "months",style: TextStyle(
                                  color: AppConstants.mainColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18
                              ),)
                            ],
                          ),
                          if(e["save"] != 0)
                            Container(
                              width: width * 0.3,
                              height: 30,
                              alignment: Alignment.center,
                              color: selectIndex == index ? AppConstants.mainColor : Colors.white70,
                              child: Text("SAVE ${e["save"].toString()}%",style: TextStyle(
                                  color:selectIndex == index ? Colors.white : Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20
                              ),),
                            ),
                          Text("\$${e["price"]}",style: const TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold
                          ),)
                        ],
                      ),
                    ),
                    if(index == 1)
                    const Positioned(
                      top: 0,
                      right: 0,
                      child: Image(
                        width: 30,
                        height: 30,
                        image: AssetImage("assets/logos/flame.png"),
                      ),
                    )
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
