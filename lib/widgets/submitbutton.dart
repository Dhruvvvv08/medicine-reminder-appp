import 'package:flutter/material.dart';

class SubmitButton extends StatelessWidget {
  final String Textt;
  final Color color;
  final Function ontap;
  const SubmitButton({super.key, required this.Textt, required this.color, required this.ontap});

  @override
  Widget build(BuildContext context) {
    return   GestureDetector(
      onTap: (){
        ontap();
      },
      child: Container(
                                    height: 49,
                                    width: MediaQuery.of(context).size.width,
                                    padding: const EdgeInsets.only(
                                        top: 15, bottom: 14),
                                    decoration: ShapeDecoration(
                                      color: color,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    child:  Text(
                                      Textt,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.w600,
                                        height: 0,
                                      ),
                                    ),
                                  ),
    );
  }
}