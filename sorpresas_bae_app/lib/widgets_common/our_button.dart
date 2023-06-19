import 'package:flutter/material.dart';
import 'package:sorpresas_bae_app/consts/consts.dart';

Widget ourButton({onPress, color, textColor, title}) {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      // ignore: deprecated_member_use
      primary: color,
      padding: const EdgeInsets.all(12),
    ),
    onPressed: onPress,
    child: title.toString().text.color(textColor).fontFamily(bold).make(),
  );
}
