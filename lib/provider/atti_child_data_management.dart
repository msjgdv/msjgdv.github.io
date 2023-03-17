import 'package:flutter/material.dart';

class AttiChild with ChangeNotifier {
  int identification;
  String name;
  String childFaceUrl;
  Image childFace;
  bool sex;
  bool attiSurveyed;

  AttiChild({
    required this.identification,
    required this.name,
    required this.sex,
    required this.childFaceUrl,
    required this.childFace,
    this.attiSurveyed = false,
  });
}

class AttiChildDataManagement with ChangeNotifier{
  List<AttiChild> childList = [];
}