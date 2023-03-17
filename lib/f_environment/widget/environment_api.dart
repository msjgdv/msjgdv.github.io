import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:treasure_map/widgets/api.dart';
import 'package:http/http.dart' as http;

callEnvApi(context, int index) async {
  ApiUrl apiUrl = ApiUrl();
  DateTime pageTime = DateTime.now();
  var formatter = DateFormat('yyyyMMdd');
  String pageTimeStr = formatter.format(pageTime);
  http.Response res;
  if (index == 0) {
    res = await api(
        apiUrl.infoPanelEnvironment, 'get', 'signInToken', {}, context);
  } else if (index == 1) {
    res = await api(apiUrl.infoPanelAttend, 'get', 'signInToken', {}, context);
  } else if (index == 2) {
    res = await api(
        '${apiUrl.infoPanel}/$pageTimeStr', 'get', 'signInToken', {}, context);
  } else {
    res = await api(apiUrl.infoPanelImage, 'get', 'signInToken', {}, context);
  }
  if (res.statusCode == 200) {
    var resRB = utf8.decode(res.bodyBytes);
    var resData = jsonDecode(resRB);
    return resData;
  }
}
