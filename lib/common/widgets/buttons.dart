import 'package:flutter/material.dart';
import '../utils/colors.dart';

/// Elevated Button
class ElevatedButtonShow extends StatelessWidget {
  final String buttonName;
  final Function onPressedFunction;
  const ElevatedButtonShow({Key? key,required this.buttonName,required this.onPressedFunction}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: 100,
      height: 40,
      child: ElevatedButton(style: ElevatedButton.styleFrom(
        backgroundColor: COLORS.buttonBlueColor,
        elevation: 1,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5)),
      ),
          onPressed: () => onPressedFunction(), child: Text(buttonName,style: const TextStyle(fontSize: 16,color: Colors.white,fontWeight: FontWeight.normal),)),
    );
  }
}

/// Outlined Button
class OutlinedButtonShow extends StatelessWidget {
  final String buttonName;
  final Function onPressedFunction;
  const OutlinedButtonShow({Key? key,required this.buttonName,required this.onPressedFunction}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      height: 40,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Color(0xFF364DF7), width: 1),
        ),
        onPressed: () => onPressedFunction(),
        child: Text(
          buttonName,
          style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF364DF7),
              fontWeight: FontWeight.normal),
        ),
      ),
    );
  }
}