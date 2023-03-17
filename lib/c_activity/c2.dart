// ignore_for_file: must_be_immutable

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:treasure_map/widgets/api.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../api/activity.dart';

import '../provider/app_management.dart';
import '../widgets/overtab.dart';
import 'package:aligned_dialog/aligned_dialog.dart';
import 'package:provider/provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../widgets/select_number.dart';

//---------------------------------------------------체온---------------------------------------------------\\
class C2 extends StatefulWidget {
  const C2({
    Key? key,
    required this.nextPage,
    required this.prePage,
    required this.nowPage,
    this.scaffoldKey,
  }) : super(key: key);
  final Function nextPage;
  final Function prePage;
  final String nowPage;
  final GlobalKey<ScaffoldState>? scaffoldKey;

  @override
  State<C2> createState() => _C2State();
}

class _C2State extends State<C2> {
  static final autoLoginStorage = FlutterSecureStorage();

  int rowNum = 0; //꽉채운 한줄
  int rowRestNum = 0; //그러지못한 한줄
  bool dateOn = true;

  List<String> testchildnamelist = [];

  List<GetTemperatureData> childTemperatureData = [];

  late PostTemperatureData postTemperatureData;

  DateTime pageTime = DateTime.now();
  String pageTimeStr = '';
  ApiUrl apiUrl = ApiUrl();

  receiveData(DateTime dateTime) async {
    pageTime = dateTime;
    var formatter = DateFormat('yyyyMMdd');
    pageTimeStr = formatter.format(pageTime);
    setState(() {
      getTemperatureData();
    });
  }

  getTemperatureData() async {
    http.Response temperatureRes = await api(apiUrl.temperature + '/' + Provider.of<UserInfo>(context, listen: false).value[0].toString() + '/' +pageTimeStr, 'get', 'signInToken', {}, context);
    if(temperatureRes.statusCode == 200){
      var temperatureRB = utf8.decode(temperatureRes.bodyBytes);
      var temperatureData = jsonDecode(temperatureRB);
      childTemperatureData.clear();
      setState(() {
        for (int i = 0; i < temperatureData.length; i++) {
          childTemperatureData.add(GetTemperatureData(
              id: temperatureData[i]['id'],
              name: temperatureData[i]['name'],
              afternoon: temperatureData[i]['afternoon'].toDouble(),
              isReported: temperatureData[i]['isReported'],
              morning: temperatureData[i]['morning'].toDouble(),
              isSickedAfternoon: temperatureData[i]['isSickedAfternoon'],
              isSickedMorning: temperatureData[i]['isSickedMorning']));
        }
        rowNum = childTemperatureData.length ~/ 3;
        rowRestNum = childTemperatureData.length % 3;
      });
    }
  }

  postTemperature(bool time, double value, int id) async {
    http.Response temperatureRes = await api(apiUrl.temperature, 'post', 'signInToken', {
      'type': time ? 'morning':'afternoon',
      'value': value.toString(),
      'id': id.toString(),
      'date': pageTimeStr,
      'cid': Provider.of<UserInfo>(context, listen: false).role == "teacher"
          ? 0
          : Provider.of<UserInfo>(context, listen: false).value[0].toString()
    }, context);
    if(temperatureRes.statusCode == 200){
      getTemperatureData();
    }
  }

  @override
  initState() {
    receiveData(pageTime);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(50.w),
          bottomLeft: Radius.circular(50.w),
        ),
        color: const Color(0xffFCFCFC),
      ),
      child: Column(
        children: [
          OverTab(
            nextPage: widget.nextPage,
            prePage: widget.prePage,
            nowPage: widget.nowPage,
            dateOnOff: dateOn,
            receiveData: receiveData,
            scaffoldKey: widget.scaffoldKey,
          ),
          Expanded(
            child: ScrollConfiguration(
              behavior: const ScrollBehavior().copyWith(overscroll: false),
              child: ListView(
                physics: const RangeMaintainingScrollPhysics(),
                children: [
                  for (int i = 0; i < rowNum + 1; i++) ...[
                    if (i == rowNum) ...[
                      //겉절이 row있으면 저절로 채워짐
                      Row(
                        children: [
                          for (int j = 0; j < rowRestNum; j++) ...[
                            Container(
                              width: 39.w,
                              height: 222.w,
                              color: const Color(0xffFCFCFC),
                            ),
                            ChildTemperatureWidget(
                              getTemperatureData: childTemperatureData[i * 3 + j],
                              postTemperature: postTemperature,
                            ),
                            SizedBox(
                              width: 11.w,
                            ),
                          ]
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            width: 39.w,
                            height: 50.w,
                            decoration: BoxDecoration(
                              //color: Colors.black,
                              color: const Color(0xffFCFCFC),
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(50.w)),
                            ),
                          ),
                        ],
                      )
                    ] else ...[
                      //꽉찬 row
                      Row(
                        children: [
                          Container(
                            width: 39.w,
                            height: 222.w,
                            color: const Color(0xffFCFCFC),
                          ),
                          ChildTemperatureWidget(
                            getTemperatureData: childTemperatureData[i * 3 + 0],
                            postTemperature: postTemperature,
                          ),
                          SizedBox(
                            width: 50.w,
                          ),
                          ChildTemperatureWidget(
                            getTemperatureData: childTemperatureData[i * 3 + 1],
                            postTemperature: postTemperature,
                          ),
                          SizedBox(
                            width: 50.w,
                          ),
                          ChildTemperatureWidget(
                            getTemperatureData: childTemperatureData[i * 3 + 2],
                            postTemperature: postTemperature,
                            rowLast: true,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            width: 39.w,
                            height: 50.w,
                            color: const Color(0xffFCFCFC),
                          ),
                        ],
                      )
                    ],
                  ]
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ChildTemperatureWidget extends StatefulWidget {
  ChildTemperatureWidget({
    Key? key,
    required this.getTemperatureData,
    required this.postTemperature,
    this.rowLast = false,
  }) : super(key: key);
  final GetTemperatureData getTemperatureData;
  final bool rowLast;
  final Function(bool, double, int) postTemperature;

  @override
  State<ChildTemperatureWidget> createState() => _ChildTemperatureWidgetState();
}

class _ChildTemperatureWidgetState extends State<ChildTemperatureWidget> {
  Color columnhexcolor = const Color(0xFFFFEFD3);
  Color columnhexcolor2 = const Color(0xFFFFFDF8);
  Color rowhexcolor = const Color(0xFFFFFFFF);

  double borderradius = 20.w;
  double borderwidth = 1.w;
  Color borderhexcolor = const Color(0x4DFDB43B);

  double fontsize14 = 14.sp;
  Color fonthexcolor = const Color(0xFF393838);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 312.w,
      height: 192.w,
      decoration: BoxDecoration(
        color: columnhexcolor,
        border: Border.all(color: borderhexcolor, width: borderwidth),
        borderRadius: BorderRadius.all(Radius.circular(borderradius)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x29B1B1B1),
            blurRadius: 6,
            offset: Offset(-2, 2),
          )
        ],
      ),
      child: Row(
        children: [
          Column(
            children: [
              Container(
                width: 90.w,
                height: 70.w,
                decoration: BoxDecoration(
                    color: columnhexcolor,
                    border:
                        Border.all(color: borderhexcolor, width: borderwidth),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(borderradius))),
                child: Center(
                  child: Text(
                    '유아명',
                    style: TextStyle(fontSize: fontsize14, color: fonthexcolor),
                  ),
                ),
              ),
              Container(
                width: 90.w,
                height: 120.w,
                decoration: BoxDecoration(
                    color: rowhexcolor,
                    border:
                        Border.all(color: borderhexcolor, width: borderwidth),
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(borderradius))),
                child: Center(child: Text(widget.getTemperatureData.name,style: TextStyle(fontSize: fontsize14, color: fonthexcolor),)),
              )
            ],
          ),
          Column(
            children: [
              Container(
                width: 219.w,
                height: 30.w,
                decoration: BoxDecoration(
                    color: columnhexcolor2,
                    border:
                        Border.all(color: borderhexcolor, width: borderwidth),
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(borderradius))),
                child: Center(
                  child: Text(
                    '체온',
                    style: TextStyle(fontSize: fontsize14, color: fonthexcolor),
                  ),
                ),
              ),
              Row(
                children: [
                  Container(
                    width: 110.w,
                    height: 40.w,
                    decoration: BoxDecoration(
                      color: columnhexcolor,
                      border:
                          Border.all(color: borderhexcolor, width: borderwidth),
                    ),
                    child: Center(
                      child: Text(
                        '오전',
                        style: TextStyle(
                            fontSize: fontsize14, color: fonthexcolor),
                      ),
                    ),
                  ),
                  Container(
                      width: 110.w,
                      height: 40.w,
                      decoration: BoxDecoration(
                        color: columnhexcolor,
                        border: Border.all(
                            color: borderhexcolor, width: borderwidth),
                      ),
                      child: Center(
                        child: Text(
                          '오후',
                          style: TextStyle(
                              fontSize: fontsize14, color: fonthexcolor),
                        ),
                      ))
                ],
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      showAlignedDialog(
                          offset: Offset(0, 50.w),
                          barrierColor: Colors.transparent,
                          context: context,
                          builder: (BuildContext context) {
                            return TakeNumber(
                              id: widget.getTemperatureData.id,
                              time: true,
                              postTemperature: widget.postTemperature,

                            );
                          });
                    },
                    child: Container(
                      width: 110.w,
                      height: 40.w,
                      decoration: BoxDecoration(
                        color: rowhexcolor,
                        border: Border.all(
                            color: borderhexcolor, width: borderwidth),
                      ),
                      child: Center(
                          child: Text(widget.getTemperatureData.morning
                                      .toString() ==
                                  "-1.0"
                              ? ''
                              : widget.getTemperatureData.morning.toString(),style: TextStyle(fontSize: fontsize14, color: widget.getTemperatureData.isSickedMorning ? Colors.red : fonthexcolor),)),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      showAlignedDialog(
                          offset: Offset(!widget.rowLast ? 100.w : 55.w, 50.w),
                          barrierColor: Colors.transparent,
                          context: context,
                          builder: (BuildContext context) {
                            return TakeNumber(
                              id: widget.getTemperatureData.id,
                              time: false,
                              postTemperature: widget.postTemperature,
                            );
                          });
                    },
                    child: Container(
                      width: 110.w,
                      height: 40.w,
                      decoration: BoxDecoration(
                        color: rowhexcolor,
                        border: Border.all(
                            color: borderhexcolor, width: borderwidth),
                      ),
                      child: Center(
                          child: Text(
                              widget.getTemperatureData.afternoon.toString() ==
                                      "-1.0"
                                  ? ''
                                  : widget.getTemperatureData.afternoon
                                      .toString(),style: TextStyle(fontSize: fontsize14, color: widget.getTemperatureData.isSickedAfternoon ? Colors.red : fonthexcolor),)),
                    ),
                  )
                ],
              ),
              Container(
                width: 219.w,
                height: 40.w,
                decoration: BoxDecoration(
                  color: columnhexcolor,
                  border: Border.all(color: borderhexcolor, width: borderwidth),
                ),
                child: Center(
                  child: Text(
                    '학부모 알림',
                    style: TextStyle(fontSize: fontsize14, color: fonthexcolor),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return MessageToParent();
                      });
                },
                child: Container(
                  width: 219.w,
                  height: 40.w,
                  decoration: BoxDecoration(
                      color: rowhexcolor,
                      border:
                          Border.all(color: borderhexcolor, width: borderwidth),
                      borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(borderradius))),
                  child: Center(
                    child: Text(
                      widget.getTemperatureData.isReported == true ? 'Y' : 'N',
                      style:
                          TextStyle(fontSize: fontsize14, color: fonthexcolor),
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class TakeNumber extends StatefulWidget {
  const TakeNumber({
    Key? key,
    required this.id,
    required this.time,
    required this.postTemperature,
  }) : super(key: key);
  final int id;
  final bool time;
  final Function(bool, double, int) postTemperature;


  @override
  State<TakeNumber> createState() => _TakeNumberState();
}

class _TakeNumberState extends State<TakeNumber> {
  int temperatureFront = 0;
  int temperatureBack = 0;
  double temperature = 0;
  late PostTemperatureData postTemperatureData;

  setTemperatureFront(int _number) {
    temperatureFront = _number;
  }

  setTemperatureBack(int _number) {
    temperatureBack = _number;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300.w,
      height: 80.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20.w)),
        border: Border.all(width: 1.w, color: Color(0xFFA666FB)),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x294D4D4D),
            blurRadius: 4,
            offset: Offset(2, 2), // changes position of shadow
          ),
        ],
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SelectNumber(
              startNumber: 30,
              finalNumber: 45,
              defaultNumber: 6,
              stringLength: 2,
              setNumber: setTemperatureFront,
            ),
            Container(
              width: 30.w,
              child: Text(
                " .",
                style: TextStyle(fontSize: 40.w, color: Color(0xff393838)),
              ),
            ),
            SelectNumber(
              startNumber: 0,
              finalNumber: 10,
              defaultNumber: 5,
              stringLength: 1,
              setNumber: setTemperatureBack,
            ),
            SizedBox(
              width: 20.w,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 70.w,
                  height: 50.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10.w)),
                    color: Colors.white,
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      temperature = temperatureFront + temperatureBack / 10;
                      setState(() {
                        widget.postTemperature(widget.time, temperature, widget.id);
                      });

                      print(temperature);
                      Navigator.pop(context);
                    },
                    child: Text('확인',
                        style: TextStyle(
                            fontSize: 18.sp, fontWeight: FontWeight.w400)),
                    style: ElevatedButton.styleFrom(
                        elevation: 1.0,
                        primary: const Color(0xFFFFEFD3),
                        onPrimary: const Color(0xFF393838),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.w)),
                        side: const BorderSide(color: Color(0xFFffffff)),
                        fixedSize: Size(70.w, 50.w)),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class MessageToParent extends StatefulWidget {
  const MessageToParent({Key? key}) : super(key: key);

  @override
  State<MessageToParent> createState() => _MessageToParentState();
}

class _MessageToParentState extends State<MessageToParent> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
        elevation: 8,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.w))),
        child: Container(
          width: 550.w,
          height: 285.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20.w)),
            border: Border.all(width: 1.w, color: Color(0xFF7649B7)),
            color: Color(0xffE2D3FE),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "현재 학부모 어플과 함께\n개발 중인 기능입니다.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22.w,
                  fontWeight: FontWeight.w500,
                  color: Color(0xff393838),
                ),
              ),
              SizedBox(
                height: 60.w,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // SizedBox(width: 80.w),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('확인',
                        style: TextStyle(
                            fontSize: 20.sp, fontWeight: FontWeight.w400)),
                    style: ElevatedButton.styleFrom(
                        elevation: 1.0,
                        primary: const Color(0xFFFFFFFF),
                        onPrimary: const Color(0xFF393838),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.w)),
                        side: const BorderSide(color: Color(0xFFA666FB)),
                        fixedSize: Size(150.w, 50.w)),
                  ),
                  SizedBox(width: 50.w),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('취소',
                        style: TextStyle(
                            fontSize: 20.sp, fontWeight: FontWeight.w400)),
                    style: ElevatedButton.styleFrom(
                        elevation: 1.0,
                        primary: const Color(0xFFFFFFFF),
                        onPrimary: const Color(0xFF393838),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.w)),
                        side: const BorderSide(color: Color(0xFFA666FB)),
                        fixedSize: Size(150.w, 50.w)),
                  ),
                ],
              ),
              SizedBox(
                height: 35.w,
              )
            ],
          ),
        ));
  }
}
