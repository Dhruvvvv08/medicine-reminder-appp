import 'package:flutter/material.dart';

class Demoooo extends StatefulWidget {
  const Demoooo({super.key});

  @override
  State<Demoooo> createState() => _DemooooState();
}

class _DemooooState extends State<Demoooo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body:Column(
      
      crossAxisAlignment:  CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [

        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 50),
          child: Container(
            child: TextField(
              
            ),
          ),
        ),
         ElevatedButton(onPressed: (){

         }, child: Text("click me"))
      
      ]));
  }
}