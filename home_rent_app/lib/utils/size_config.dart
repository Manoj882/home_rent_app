
import 'package:flutter/material.dart';

class SizeConfig{
  static late double height;
  static late double width;

  init(BoxConstraints constraints){
    height = constraints.maxHeight / 100;
    width = constraints.maxWidth / 100;
  }
}