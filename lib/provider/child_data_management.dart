import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';

import '../api/admin.dart';

class Child with ChangeNotifier {
  int identification;
  String name;
  String childFaceUrl;
  Image childFace;
  bool sex;
  String birthday;
  String comment;
  String relation;
  String className;
  String phoneNumber;
  String parentName;
  bool attiSurveyed;

  Child({
    required this.identification,
    required this.name,
    required this.sex,
    required this.childFaceUrl,
    required this.childFace,
    required this.comment,
    required this.birthday,
    required this.relation,
    required this.className,
    required this.phoneNumber,
    required this.parentName,
    this.attiSurveyed = false,
});
}

class ChildDataManagement with ChangeNotifier{
  List<Child> childList = [];
}