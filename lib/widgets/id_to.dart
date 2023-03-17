
import 'package:flutter/material.dart';
import 'package:treasure_map/provider/atti_child_data_management.dart';
import 'package:provider/provider.dart';
import 'package:treasure_map/provider/report_data_management.dart';

class IdTo with ChangeNotifier {
  Image IdToImage(int identification, context) {
    return
      Provider
          .of<AttiChildDataManagement>(context, listen: false)
          .childList[Provider
          .of<AttiChildDataManagement>(context, listen: false)
          .childList
          .indexWhere((AttiChild) => AttiChild.identification == identification)].childFace;
  }

  String IdToName(int identification, context) {
    return
      Provider
          .of<AttiChildDataManagement>(context, listen: false)
          .childList[Provider
          .of<AttiChildDataManagement>(context, listen: false)
          .childList
          .indexWhere((AttiChild) => AttiChild.identification == identification)].name;
  }

  String IdToData(int identification, String type, int time, context,){
    int _id= Provider
        .of<ReportDataManagement>(context, listen: false)
        .reportData[time]['cid']
        .indexWhere((AttiChild) => AttiChild == identification);
    if(_id == -1){
      return 'ㆍ';
    }else{
      if(Provider.of<ReportDataManagement>(context, listen: false)
          .reportData[time][type][_id].runtimeType == double){
        return
          Provider.of<ReportDataManagement>(context, listen: false)
              .reportData[time][type][_id].toStringAsFixed(2);
      }else{
        return
          Provider.of<ReportDataManagement>(context, listen: false)
              .reportData[time][type][_id].toString();
      }

    }
  }

}

