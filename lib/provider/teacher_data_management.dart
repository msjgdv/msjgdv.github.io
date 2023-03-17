import 'package:flutter/material.dart';

class Teacher with ChangeNotifier {
  String name;
  String className;
  String phoneNum;
  int id;
  String email;
  var approved;
  var denied;


  Teacher({
    required this.name,
    required this.className,
    required this.phoneNum,
    required this.id,
    required this.email,
    this.approved,
    this.denied
  });
}

class TeacherDataManagement with ChangeNotifier{
  List<Teacher> teacherList = [];
}
