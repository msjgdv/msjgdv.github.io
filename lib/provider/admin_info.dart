import 'dart:io';

import 'package:flutter/material.dart';

//admin 정보
class AdminInfo with ChangeNotifier {
  String _email = "";
  String _name = '';
  String _phoneNumber = '';
  String _comment = '';
  Image? _adminFace;

  var _imageGallery;


  String get email => _email;
  String get name => _name;
  String get phoneNumber => _phoneNumber;
  String get comment => _comment;
  Image? get adminFace => _adminFace;
  File get imageGallery => _imageGallery;

  void infoUpdate(String em, String na, String pN, Image fI, String comment) {
    _email = em;
    _name = na;
    _phoneNumber = pN;
    _adminFace = fI;
    _comment = comment;
    notifyListeners();
  }

  void galleryImgUpdate(var img) {
    _imageGallery = img;
    notifyListeners();
  }
}