import 'package:flutter/material.dart';
import 'package:sorpresas_bae_app/consts/colors.dart';

Widget loadingIndicator() {
  return const CircularProgressIndicator(
    valueColor: AlwaysStoppedAnimation(redColor),
  );
}
