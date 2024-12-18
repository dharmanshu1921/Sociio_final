import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SwitchChatView extends StatefulWidget {
  const SwitchChatView({super.key});

  @override
  State<SwitchChatView> createState() => _SwitchChatViewState();
}

class _SwitchChatViewState extends State<SwitchChatView> {
  bool isSelectedMsg=true;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(

          color: Color(0xFF4b4b4b),
          borderRadius: BorderRadius.circular(20)
        ),
        child: Row(
          children: [
            GestureDetector(
                onTap: (){
                  setState(() {
                    isSelectedMsg=true;
                  });
                },
                child: Container(
                  padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: isSelectedMsg?Colors.red:Colors.grey
                    ),
                    child: Text("Messages", style: TextStyle(color: Colors.white),))),
            GestureDetector(
                onTap: (){
                  setState(() {
                    isSelectedMsg=false;
                  });
                },
                child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color:!isSelectedMsg?Colors.red:Colors.grey
                    ),
                    child: Text("Groups", style: TextStyle(color: Colors.white),)))
          ],
        ),
      ),
    );
  }
}
