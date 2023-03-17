
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:dio/dio.dart';
import 'package:treasure_map/widgets/api.dart';
import 'package:treasure_map/widgets/token_time_over.dart';
import '../api/admin.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../provider/admin_info.dart';
import '../provider/app_management.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'access_token_time_over.dart';


setAdminInfo(String url, Function(String,String,String, Image, String) infoUpdate, context) async {
  ApiUrl apiUrl = ApiUrl();
  http.Response adminRes = await api(apiUrl.loginIn, 'get', 'signInToken', {}, context);
  if(adminRes.statusCode == 200){
    var adminRB = utf8.decode(adminRes.bodyBytes);
    var adminData = jsonDecode(adminRB);
    Image childImage = await imageApi(adminData['imagePath'], 'signInToken', context);
    infoUpdate(adminData["email"], adminData["name"], adminData["phoneNumber"], childImage, adminData["comment"] ?? '');
  }
}