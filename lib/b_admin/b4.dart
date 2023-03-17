import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:treasure_map/widgets/api.dart';
import 'package:http/http.dart' as http;

//===================권한부여 및 삭제===================\\
class B4 extends StatefulWidget {
  const B4({Key? key, required this.notifyParent}) : super(key: key);
  final Function(double, double)? notifyParent;

  @override
  State<B4> createState() => _B4State();
}

class _B4State extends State<B4> {
  double fontSize22 = 22.sp;
  double fontSize20 = 20.sp;
  Color fontHexColor = const Color(0xFF393838);

  double borderRadius = 10.w;
  double borderWidth = 2.w;
  Color borderHexColor = const Color(0x4DFDB43B);

  List<String> dropdownList = [
    '0',
    '1',
    '2',
    '3',
    '4'
  ]; //list for people who has possibility of having [the authority]
  List<int> dropdownIndex = [];
  int selectIndex = 0;
  List<int> teacherId = [];

  List<String> authorityList = [
    '학급정보',
    '학부모정보',
    '결재',
    '교사정보',
    '영유아정보',
    '구매페이지',
    'contact'
  ];
  List<bool> authorityCheckList = [
    false,
    false,
    false,
    false,
    false,
    false,
    false
  ];
  List<String> authCheckList = [];
  String authCheck = '0000000';

  authMaker(int _index, bool _auth){
    String authString = '';
    for(int i = 0; i<_index;i++){
      authString = authString + authCheck.split('')[i];
    }
    if(_auth){
      authString = authString + "1";
    }else{
      authString = authString + "0";
    }
    for(int i = _index + 1; i<7;i++){
      authString = authString + authCheck.split('')[i];
    }
    return authString;
  }

  postTeacherAuth(int _id, String _auth) async {
    ApiUrl apiUrl = ApiUrl();
    http.Response authRes =
        await api(apiUrl.auth, 'post', 'adminToken', {'id':_id.toString(),"auth":_auth}, context);
    if(authRes.statusCode == 200){
      getTeacherAuth();
    }
  }

  getTeacherAuth() async {
    ApiUrl apiUrl = ApiUrl();
    http.Response authRes =
        await api(apiUrl.auth, 'get', 'adminToken', {}, context);
    if (authRes.statusCode == 200) {
      var authRB = utf8.decode(authRes.bodyBytes);
      var authData = jsonDecode(authRB);
      dropdownList.clear();
      authCheckList.clear();
      dropdownIndex.clear();
      teacherId.clear();
      setState(() {
        for (int i = 0; i < authData.length; i++) {
          dropdownIndex.add(i);
          dropdownList.add(authData[i]["name"]);
          authCheckList.add(authData[i]["auth"]);
          teacherId.add(authData[i]["id"]);
        }
        authCheck = authData[selectIndex]["auth"];
        for(int i = 0; i<7;i++){
          authCheck.split('')[i] == '0' ? authorityCheckList[i] = false: authorityCheckList[i] = true;
        }
      });
    }
  }

  @override
  void initState() {
    getTeacherAuth();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 47.w,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 21.w,
            ),
            SizedBox(
              width: 172.w,
              height: 32.w,
              child: Text(
                '권한 설정할 관리자',
                style: TextStyle(
                    fontSize: fontSize22,
                    fontWeight: FontWeight.w400,
                    color: fontHexColor),
              ),
            ),
            Container(
              width: 400.w,
              height: 50.w,
              margin: EdgeInsets.only(top: 30.w),
              decoration: BoxDecoration(
                border: Border.all(color: borderHexColor, width: borderWidth),
                borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
                color: Colors.white,
              ),
              child: Container(
                margin: EdgeInsets.only(left: 20.w),
                child: DropdownButton(
                  iconEnabledColor: const Color(0xffFDB43B),
                  iconSize: 40.w,
                  underline: const SizedBox(),
                  //to eliminate an underline of DropdownButton
                  value: selectIndex,
                  items: dropdownIndex.map((int item) {
                    return DropdownMenuItem<int>(
                      child: Container(
                        width: 330.w,
                        child: Text(
                          dropdownList[item],
                          style: TextStyle(
                              fontSize: 20.sp, color: const Color(0xff393838)),
                        ),
                      ),
                      value: item,
                    );
                  }).toList(),
                  onChanged: (dynamic newValue) {
                    setState(() {
                      selectIndex = newValue;
                      authCheck = authCheckList[selectIndex];
                      for(int i = 0; i<7;i++){
                        authCheck.split('')[i] == '0' ? authorityCheckList[i] = false: authorityCheckList[i] = true;
                      }
                    });
                  },
                ),
              ),
            ),
            Container(
              width: 86.w,
              height: 32.w,
              margin: EdgeInsets.only(top: 80.w),
              child: Text(
                '권한 여부',
                style: TextStyle(
                    fontSize: fontSize22,
                    fontWeight: FontWeight.w400,
                    color: fontHexColor),
              ),
            ),
            Container(
                width: 825.w,
                height: 180.w,
                margin: EdgeInsets.only(top: 31.w),
                decoration: BoxDecoration(
                  border: Border.all(color: borderHexColor, width: borderWidth),
                  borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
                  color: Colors.white,
                ),
                child: Column(
                  //crossAxisAlignment: CrossAxisAlignment.start,
                  //mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 25.w,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 39.w,
                        ),
                        Container(
                            width: 155.w,
                            height: 29.w,
                            child: Text(
                              authorityList[0],
                              style: TextStyle(
                                  fontSize: fontSize20, color: fontHexColor),
                            )),
                        Container(
                          width: 30.w,
                          height: 30.w,
                          child: Checkbox(
                              fillColor: MaterialStateProperty.all(
                                  const Color(0xffFDB43B)),
                              value: authorityCheckList[0],
                              onChanged: (val) {
                                setState(() {
                                  postTeacherAuth(teacherId[selectIndex], authMaker(0, val!));
                                });
                              }),
                        ),
                        SizedBox(
                          width: 93.w,
                        ),
                        Container(
                            width: 155.w,
                            height: 29.w,
                            // margin: EdgeInsets.only(left: 93.w, top: 25.w),
                            child: Text(
                              authorityList[1],
                              style: TextStyle(
                                  fontSize: fontSize20, color: fontHexColor),
                            )),
                        Container(
                          width: 30.w,
                          height: 30.w,
                          // margin: EdgeInsets.only(left: 58.w, top: 25.w),
                          child: Checkbox(
                              fillColor: MaterialStateProperty.all(
                                  const Color(0xffFDB43B)),
                              value: authorityCheckList[1],
                              onChanged: (val) {
                                setState(() {
                                  postTeacherAuth(teacherId[selectIndex], authMaker(1, val!));
                                });
                              }),
                        ),
                        SizedBox(
                          width: 93.w,
                        ),
                        Container(
                            width: 155.w,
                            height: 29.w,
                            // margin: EdgeInsets.only(left: 116.w, top: 25.w),
                            child: Text(
                              authorityList[2],
                              style: TextStyle(
                                  fontSize: fontSize20, color: fontHexColor),
                            )),
                        Container(
                          width: 30.w,
                          height: 30.w,
                          // margin: EdgeInsets.only(left: 94.w, top: 25.w),
                          child: Checkbox(
                              fillColor: MaterialStateProperty.all(
                                  const Color(0xffFDB43B)),
                              value: authorityCheckList[2],
                              onChanged: (val) {
                                setState(() {
                                  postTeacherAuth(teacherId[selectIndex], authMaker(2, val!));
                                });
                              }),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20.w,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 39.w,
                        ),
                        Container(
                            width: 155.w,
                            height: 29.w,
                            child: Text(
                              authorityList[3],
                              style: TextStyle(
                                  fontSize: fontSize20, color: fontHexColor),
                            )),
                        Container(
                          width: 30.w,
                          height: 30.w,
                          child: Checkbox(
                              fillColor: MaterialStateProperty.all(
                                  const Color(0xffFDB43B)),
                              value: authorityCheckList[3],
                              onChanged: (val) {
                                setState(() {
                                  postTeacherAuth(teacherId[selectIndex], authMaker(3, val!));
                                });

                              }),
                        ),
                        SizedBox(
                          width: 93.w,
                        ),
                        Container(
                            width: 155.w,
                            height: 29.w,
                            child: Text(
                              authorityList[4],
                              style: TextStyle(
                                  fontSize: fontSize20, color: fontHexColor),
                            )),
                        Container(
                          width: 30.w,
                          height: 30.w,
                          child: Checkbox(
                              fillColor: MaterialStateProperty.all(
                                  const Color(0xffFDB43B)),
                              value: authorityCheckList[4],
                              onChanged: (val) {
                                setState(() {
                                  postTeacherAuth(teacherId[selectIndex], authMaker(4, val!));
                                });
                              }),
                        ),
                        SizedBox(
                          width: 93.w,
                        ),
                        Container(
                            width: 155.w,
                            height: 29.w,
                            child: Text(
                              authorityList[5],
                              style: TextStyle(
                                  fontSize: fontSize20, color: fontHexColor),
                            )),
                        Container(
                          width: 30.w,
                          height: 30.w,
                          child: Checkbox(
                              fillColor: MaterialStateProperty.all(
                                  const Color(0xffFDB43B)),
                              value: authorityCheckList[5],
                              onChanged: (val) {
                                setState(() {
                                  postTeacherAuth(teacherId[selectIndex], authMaker(5, val!));
                                });
                              }),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20.w,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 39.w,
                        ),
                        Container(
                            width: 155.w,
                            height: 29.w,
                            child: Text(
                              authorityList[6],
                              style: TextStyle(
                                  fontSize: fontSize20, color: fontHexColor),
                            )),
                        Container(
                          width: 30.w,
                          height: 30.w,
                          child: Checkbox(
                              fillColor: MaterialStateProperty.all(
                                  const Color(0xffFDB43B)),
                              value: authorityCheckList[6],
                              onChanged: (val) {
                                setState(() {
                                  postTeacherAuth(teacherId[selectIndex], authMaker(6, val!));
                                });
                              }),
                        ),
                      ],
                    )
                  ],
                ))
          ],
        )
      ],
    );
  }
}
