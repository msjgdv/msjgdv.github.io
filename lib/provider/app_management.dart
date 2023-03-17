import 'package:flutter/material.dart';

class UserInfo with ChangeNotifier{
  String role = "";
  String service = '';
  String auth = '';
  List value = [];
  int nowClassId = 0;
  String kindergartenName = '';
  String kindergartenState = '';
  List<int> schoolYears = [];
}