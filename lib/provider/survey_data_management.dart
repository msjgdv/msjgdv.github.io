import 'package:flutter/material.dart';

class SurveyDataManagement with ChangeNotifier {
  bool sex = false;
  int inClassNumber = -1;
  int rid = 0;
  int cid = 0;
  List<int> positivePoint = [];
  List<int> threePoint = [];
  List<int> twoPoint = [];
  List<int> onePoint = [];
}
