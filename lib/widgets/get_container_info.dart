import 'package:flutter/material.dart';

class GetContainerInfo{
  static getSize(GlobalKey<State<StatefulWidget>> key) {
    if (key.currentContext != null) {
      final RenderBox renderBox =
      key.currentContext!.findRenderObject() as RenderBox;
      Size size = renderBox.size;
      return size.height;
    }
    return 0.0;
  }

  static getPosition(GlobalKey<State<StatefulWidget>> key) {
    if (key.currentContext != null) {
      final RenderBox renderBox =
      key.currentContext!.findRenderObject() as RenderBox;
      final position = renderBox.localToGlobal(Offset.zero);
      return position.dy;
    }
    return 0.0;
  }
}