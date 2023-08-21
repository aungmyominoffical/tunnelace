import 'package:flutter/material.dart';




class SignalWidget extends StatefulWidget {
  final int rate;
  final Color backgroundColor;
  const SignalWidget({super.key,required this.rate,required this.backgroundColor});

  @override
  State<SignalWidget> createState() => _SignalWidgetState();
}

class _SignalWidgetState extends State<SignalWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 25,
      height: 150,
      alignment: Alignment.center,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [10,15,20,25].map((e) {
          int index = [10,15,20,25].indexOf(e);

          return Container(
            height: e.toDouble(),
            width: 4,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color:widget.rate > index ? Colors.green: widget.backgroundColor,
            ),
          );
        }).toList(),
      ),
    );
  }
}
