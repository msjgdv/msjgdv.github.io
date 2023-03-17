import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:treasure_map/a_main/a6_2.dart';
import 'package:treasure_map/a_main/a7_1.dart';
import 'package:treasure_map/widgets/api.dart';
import '../a_main/a6_1.dart';
import '../a_main/a6_5.dart';


loginRoute(context, String _position) async{
  ApiUrl apiUrl = ApiUrl();
  switch (_position){
    case 'director' :
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => A7_1()),
      );
      break;
    case 'viceDirector' :
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => A7_1()),
      );
      break;
    case 'teacher' :
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => A6_1()),
      );
      break;
    case 'parent' :
      break;
    case 'none':
      http.Response res = await api(apiUrl.applyNone, 'get', 'signInToken', {}, context);
      if(res.statusCode == 200){
        var resRB = utf8.decode(res.bodyBytes);
        var applyData = jsonDecode(resRB);
        if(applyData['name'] != ''){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => A6_5(selected: true, SelectedKindergartenName: applyData['name'],)),
          );
        }else{
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => A6_2()),
          );
        }
      }
  }
}