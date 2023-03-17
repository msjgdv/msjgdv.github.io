import 'package:flutter/material.dart';

class Class with ChangeNotifier {
  String className;
  String classTeacher;
  String classChildAge;
  int classId;
  int classCount;
  int classTId;
  var classComment;


  Class({
    required this.className,
    required this.classTeacher,
    required this.classChildAge,
    required this.classId,
    required this.classCount,
    this.classComment,
    this.classTId = 0,

  });
}

class ClassDataManagement with ChangeNotifier{
  List<Class> classList = [];
}
