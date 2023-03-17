import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:treasure_map/api/activity.dart';
import '../provider/app_management.dart';
import '../widgets/api.dart';
import '../widgets/overtab.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:widget_mask/widget_mask.dart';
import 'dart:io';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

//---------------------------------------------------출석---------------------------------------------------\\
class C1 extends StatefulWidget {
  const C1(
      {Key? key,
      required this.nextPage,
      required this.prePage,
      required this.nowPage,
      this.scaffoldKey})
      : super(key: key);
  final Function nextPage;
  final Function prePage;
  final String nowPage;
  final GlobalKey<ScaffoldState>? scaffoldKey;

  @override
  State<C1> createState() => _C1State();
}

class _C1State extends State<C1> {
  bool dateOn = true;
  int rowNum = 0; //꽉채운 한줄
  int rowRestNum = 0; //아이 한명있는 한줄

  List<GetAttendanceData> childAttendanceData = [];
  List<Image?> childFace = [];

  int hour = 0;
  int minute = 0;

  ApiUrl apiUrl = ApiUrl();

  setTime(int _hour, int _minute) {
    setState(() {
      hour = _hour;
      minute = _minute;
    });
  }

  Future<void> pickTime(int id, bool type) async {
    http.Response attendanceRes = await api(
        apiUrl.attendance, 'post', 'signInToken', {
      'type': type ? "enteringTime" : "quittingTime",
      'value': "$hour:$minute",
      'id': id,
      'date': pageTimeStr,
      'cid': Provider
          .of<UserInfo>(context, listen: false)
          .value[0]
    }, context);
    print(attendanceRes.statusCode);
    if (attendanceRes.statusCode == 200) {
      print("asdfadf");
      getChildAttendanceData();
    }
  }

  DateTime pageTime = DateTime.now();
  String pageTimeStr = '';

  receiveData(DateTime dateTime) async {
    pageTime = dateTime;
    var formatter = DateFormat('yyyyMMdd');
    pageTimeStr = formatter.format(pageTime);

      getChildAttendanceData();

  }

  getChildAttendanceData() async {
    http.Response attendanceRes = await api(
        apiUrl.attendance +
            '/' +
            Provider.of<UserInfo>(context, listen: false).value[0].toString() +
            '/' +
            pageTimeStr,
        'get',
        'signInToken',
        {},
        context);

    if (attendanceRes.statusCode == 200) {
      var attendanceRB = utf8.decode(attendanceRes.bodyBytes);
      var attendanceData = jsonDecode(attendanceRB);
      childAttendanceData.clear();
      childFace.clear();
      for (int i = 0; i < attendanceData.length; i++) {
        setState(() {
          String enteringTimeText = '';
          String quittingTimeText = '';
          String estimatedQuittingTimeText = '';
          for (int j = 0;
              j < attendanceData[i]['enteringTime'].split(':').length - 1;
              j++) {
            enteringTimeText = enteringTimeText +
                attendanceData[i]['enteringTime'].split(':')[j] +
                (j == 0 ? ":" : "");
          }
          for (int j = 0;
              j < attendanceData[i]['quittingTime'].split(':').length - 1;
              j++) {
            quittingTimeText = quittingTimeText +
                attendanceData[i]['quittingTime'].split(':')[j] +
                (j == 0 ? ":" : "");
          }

          for (int j = 0;
              j <
                  attendanceData[i]['estimatedQuittingTime'].split(':').length -
                      1;
              j++) {
            estimatedQuittingTimeText = estimatedQuittingTimeText +
                attendanceData[i]['estimatedQuittingTime'].split(':')[j] +
                (j == 0 ? ":" : "");
          }
          childAttendanceData.add(GetAttendanceData(
              id: attendanceData[i]['id'],
              name: attendanceData[i]['name'],
              enteringImagePath: attendanceData[i]['enteringImagePath'],
              enteringTime: enteringTimeText,
              estimatedQuittingTime: estimatedQuittingTimeText,
              isAttendanced: attendanceData[i]['isAttendanced'],
              quittingTime: quittingTimeText));
        });
        Image? image = childAttendanceData[i].enteringImagePath == ''
            ? null
            : await imageApi(childAttendanceData[i].enteringImagePath,
                'signInToken', context);
        setState(() {
          childFace.add(image);
        });
      }
      setState(() {
        rowNum = childAttendanceData.length ~/ 2;
        rowRestNum = childAttendanceData.length % 2;
      });
    }
  }

  @override
  initState() {
    receiveData(pageTime);
    super.initState();
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
                  for (int i = 0; i <= rowNum; i++) ...[
                    if (i == rowNum) ...[
                      Row(
                        children: [
                          for (int j = 0; j < rowRestNum; j++) ...[
                            Container(
                              //맨마지막 좌측
                              width: 39.w,
                              height: 222.w,
                              color: const Color(0xffFCFCFC),
                            ),
                            ChildAttendanceWidget(
                              dateStr: pageTimeStr,

                              date: pageTime,
                              timePicker: pickTime,
                              getAttendanceData: childAttendanceData[i * 2 + 0],
                              getAttendance : getChildAttendanceData,
                              childFace: childFace[i * 2 + 0],
                            ),
                          ]
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            //리스트 맨 마지막 좌측 하단
                            width: 39.w,
                            height: 50.w,
                            decoration: BoxDecoration(
                              color: const Color(0xffFCFCFC),
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(50.w)),
                            ),
                          ),
                        ],
                      )
                    ] else ...[
                      Row(
                        children: [
                          Container(
                            width: 39.w,
                            height: 222.w,
                            color: const Color(0xffFCFCFC),
                          ),
                          ChildAttendanceWidget(
                            dateStr: pageTimeStr,
                            date: pageTime,
                            timePicker: pickTime,
                            getAttendanceData: childAttendanceData[i * 2 + 0],
                            childFace: childFace[i * 2 + 0],
                              getAttendance:getChildAttendanceData,
                          ),
                          ChildAttendanceWidget(
                            dateStr: pageTimeStr,
                            date: pageTime,
                            timePicker: pickTime,
                            getAttendanceData: childAttendanceData[i * 2 + 1],
                            childFace: childFace[i * 2 + 1],
                              getAttendance: getChildAttendanceData,
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
                  ] //for
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class ChildAttendanceWidget extends StatefulWidget {
  ChildAttendanceWidget(
      {required this.timePicker,
      required this.getAttendanceData,
      required this.date,
        required this.getAttendance,
      required this.dateStr,
      this.childFace = null,
      Key? key})
      : super(key: key);
  final DateTime date;
  final String dateStr;
  Function(int, bool) timePicker;
  final GetAttendanceData getAttendanceData;
  final Function() getAttendance;
  final Image? childFace;

  @override
  State<ChildAttendanceWidget> createState() => _ChildAttendanceWidgetState();
}

class _ChildAttendanceWidgetState extends State<ChildAttendanceWidget> {
  final autoLoginStorage = FlutterSecureStorage();
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
    return Row(
      children: [
        Container(
          width: 531.w,
          height: 222.w,
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
                    height: 69.w,
                    decoration: BoxDecoration(
                        color: columnhexcolor,
                        border: Border.all(
                            color: borderhexcolor, width: borderwidth),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(borderradius))),
                    child: Center(
                      child: Text(
                        '유아명',
                        style: TextStyle(
                            fontSize: fontsize14, color: fonthexcolor),
                      ),
                    ),
                  ),
                  Container(
                    width: 90.w,
                    height: 151.w,
                    decoration: BoxDecoration(
                        color: rowhexcolor,
                        border: Border.all(
                            color: borderhexcolor, width: borderwidth),
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(borderradius))),
                    child: Center(
                        child: C1CustomTextStyle(
                            text: widget.getAttendanceData.name)),
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
                    ),
                    child: Center(
                      child: Text(
                        Provider.of<UserInfo>(context, listen: false)
                            .kindergartenState,
                        style: TextStyle(
                            fontSize: fontsize14, color: fonthexcolor),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        width: 110.w,
                        height: 39.w,
                        decoration: BoxDecoration(
                          color: columnhexcolor,
                          border: Border.all(
                              color: borderhexcolor, width: borderwidth),
                        ),
                        child: Center(
                            child: Text(
                          '등원시간',
                          style: TextStyle(
                              fontSize: fontsize14, color: fonthexcolor),
                        )),
                      ),
                      Container(
                        width: 110.w,
                        height: 39.w,
                        decoration: BoxDecoration(
                          color: columnhexcolor,
                          border: Border.all(
                              color: borderhexcolor, width: borderwidth),
                        ),
                        child: Center(
                            child: Text(
                          '하원시간',
                          style: TextStyle(
                              fontSize: fontsize14, color: fonthexcolor),
                        )),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      ///등원시간
                      GestureDetector(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AijoaTimePicker(
                                    pageTimeStr: widget.dateStr,
                                    id: widget.getAttendanceData.id,
                                    type: true,
                                    getAttendanceData:widget.getAttendance,
                                );
                              });
                          // widget.timePicker(widget.getAttendanceData.id, true);
                        },
                        child: Container(
                          width: 110.w,
                          height: 41.w,
                          decoration: BoxDecoration(
                            color: rowhexcolor,
                            border: Border.all(
                                color: borderhexcolor, width: borderwidth),
                          ),
                          child: Center(
                            child: C1CustomTextStyle(
                                text: widget.getAttendanceData.enteringTime),
                          ),
                        ),
                      ),

                      ///하원시간
                      GestureDetector(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AijoaTimePicker(
                                    pageTimeStr: widget.dateStr,
                                    id: widget.getAttendanceData.id,
                                    type: false,
                                    getAttendanceData: widget.getAttendance,);
                              });
                          // widget.timePicker(widget.getAttendanceData.id, false);
                        },
                        child: Container(
                          width: 110.w,
                          height: 41.w,
                          decoration: BoxDecoration(
                            color: rowhexcolor,
                            border: Border.all(
                                color: borderhexcolor, width: borderwidth),
                          ),
                          child: Center(
                            child: C1CustomTextStyle(
                                text: widget.getAttendanceData.quittingTime),
                          ),
                        ),
                      )
                    ],
                  ),
                  Container(
                    width: 219.w,
                    height: 30.w,
                    decoration: BoxDecoration(
                      color: columnhexcolor2,
                      border:
                          Border.all(color: borderhexcolor, width: borderwidth),
                    ),
                    child: Center(
                      child: Text(
                        '가정',
                        style: TextStyle(
                            fontSize: fontsize14, color: fonthexcolor),
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
                          border: Border.all(
                              color: borderhexcolor, width: borderwidth),
                        ),
                        child: Center(
                            child: Text(
                          '등원여부',
                          style: TextStyle(
                              fontSize: fontsize14, color: fonthexcolor),
                        )),
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
                          '하원예정시간',
                          style: TextStyle(
                              fontSize: fontsize14, color: fonthexcolor),
                        )),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      ///등원여부
                      Container(
                        width: 110.w,
                        height: 40.w,
                        decoration: BoxDecoration(
                          color: rowhexcolor,
                          border: Border.all(
                              color: borderhexcolor, width: borderwidth),
                        ),
                        child: Center(
                          child: C1CustomTextStyle(
                              text:
                                  widget.getAttendanceData.isAttendanced == true
                                      ? 'Y'
                                      : 'N'),
                        ),
                      ),

                      ///하원예정시간
                      Container(
                        width: 110.w,
                        height: 40.w,
                        decoration: BoxDecoration(
                          color: rowhexcolor,
                          border: Border.all(
                              color: borderhexcolor, width: borderwidth),
                        ),
                        child: Center(
                          child: C1CustomTextStyle(
                              text: widget
                                  .getAttendanceData.estimatedQuittingTime),
                        ),
                      )
                    ],
                  ),
                ],
              ),
              Column(
                children: [
                  Container(
                    width: 219.w,
                    height: 30.w,
                    decoration: BoxDecoration(
                        color: columnhexcolor,
                        border: Border.all(
                            color: borderhexcolor, width: borderwidth),
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(borderradius))),
                    child: Center(
                      child: Text(
                        '유아 등원사진',
                        style: TextStyle(
                            fontSize: fontsize14, color: fonthexcolor),
                      ),
                    ),
                  ),

                  ///유아 등원사진
                  GestureDetector(
                    onTap: () async {
                      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
                      if (image == null) return;
                      final imageTemp = File(image.path);
                      ApiUrl apiUrl = ApiUrl();
                      await imagePostApi(apiUrl.attendanceImage, 'signInToken', {
                        'id': widget.getAttendanceData.id.toString(),
                        // 'image': multi,
                        'date': widget.dateStr,
                      }, imageTemp, 'post', context, widget.getAttendance);
                    },
                    child: Container(
                      width: 219.w,
                      height: 190.w,
                      decoration: BoxDecoration(
                          color: rowhexcolor,
                          border: Border.all(
                              color: borderhexcolor, width: borderwidth),
                          borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(borderradius))),
                      child: Center(
                        child: widget.childFace != null
                            ? WidgetMask(
                                blendMode: BlendMode.srcATop,
                                childSaveLayer: true,
                                mask: widget.childFace!,
                                child: Container(
                                  width: 217.w,
                                  height: 188.w,
                                  decoration: BoxDecoration(
                                      color: rowhexcolor,
                                      borderRadius: BorderRadius.only(
                                          bottomRight:
                                              Radius.circular(borderradius))),
                                ),
                              )
                            : SvgPicture.asset(
                                'assets/icons/icon_galery.svg',
                                width: 52.w,
                              ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}


class C1CustomTextStyle extends StatefulWidget {
  const C1CustomTextStyle({
    Key? key,
    required this.text,
  }) : super(key: key);
  final String text;

  @override
  State<C1CustomTextStyle> createState() => _C1CustomTextStyleState();
}

class _C1CustomTextStyleState extends State<C1CustomTextStyle> {
  @override
  Widget build(BuildContext context) {
    return Text(
      widget.text,
      style: TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: 14.sp,
        color: Color(0xff393838),
      ),
    );
  }
}

class AijoaTimePicker extends StatefulWidget {
  const AijoaTimePicker({
    Key? key,
    required this.getAttendanceData,
    required this.pageTimeStr,
    required this.id,
    required this.type,

  }) : super(key: key);
  final Function() getAttendanceData;
  final int id;
  final bool type;
  final String pageTimeStr;


  @override
  State<AijoaTimePicker> createState() => _AijoaTimePickerState();
}

class _AijoaTimePickerState extends State<AijoaTimePicker> {
  final autoLoginStorage = FlutterSecureStorage();
  TextEditingController hour = TextEditingController();
  TextEditingController minute = TextEditingController();
  bool noon = true;

  Future<void> pickTime(int id, bool type) async {
    ApiUrl apiUrl = ApiUrl();
    http.Response attendanceRes = await api(
        apiUrl.attendance, 'post', 'signInToken', {
      'type': type ? "enteringTime" : "quittingTime",
      'value': hour.text + ':' + minute.text,
      'id': id.toString(),
      'date': widget.pageTimeStr,
      'cid': Provider
          .of<UserInfo>(context, listen: false)
          .value[0].toString()
    }, context);
    if (attendanceRes.statusCode == 200) {
      widget.getAttendanceData();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (DateTime.now().hour > 13) {
      hour.text = (DateTime.now().hour - 12).toString();
      noon = false;
    } else {
      hour.text = DateTime.now().hour.toString();
    }
    minute.text = DateTime.now().minute.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
              child: Container(
                  width: 340.w,
                  height: 180.w,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.w),
                      color: const Color(0xFFFCF9F4)),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 30.w,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 30.w,
                          ),
                          Container(
                            width: 90.w,
                            height: 70.w,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.w)),
                            ),
                            child: Center(
                              child: TextField(
                                controller: hour,
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 40.sp,
                                    color: Color(0xff393838)),
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                textAlignVertical: TextAlignVertical(y: -1.w),
                                maxLength: 2,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                  ),
                                  counterText: '',
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10.w,
                          ),
                          Column(
                            children: [
                              Container(
                                width: 8.w,
                                height: 8.w,
                                decoration: BoxDecoration(
                                  color: Color(0xff393838),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              SizedBox(
                                height: 18.w,
                              ),
                              Container(
                                width: 8.w,
                                height: 8.w,
                                decoration: BoxDecoration(
                                  color: Color(0xff393838),
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: 10.w,
                          ),
                          Container(
                            width: 90.w,
                            height: 70.w,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.w)),
                            ),
                            child: Center(
                              child: TextField(
                                controller: minute,
                                keyboardType: TextInputType.number,
                                textAlignVertical: TextAlignVertical(y: -1.w),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 40.sp,
                                    color: Color(0xff393838)),
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                maxLength: 2,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                  ),
                                  counterText: '',
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 20.w,
                          ),
                          Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    noon = true;
                                  });
                                },
                                child: Container(
                                  width: 50.w,
                                  height: 32.5.w,
                                  decoration: BoxDecoration(
                                    color:
                                        noon ? Color(0xffC6A2FC) : Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10.w)),
                                    border: Border.all(
                                      width: 1.w,
                                      color: Color(0xffC6A2FC),
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "AM",
                                      style: TextStyle(
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xff393838),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 5.w,
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    noon = false;
                                  });
                                },
                                child: Container(
                                  width: 50.w,
                                  height: 32.5.w,
                                  decoration: BoxDecoration(
                                    color:
                                        noon ? Colors.white : Color(0xffC6A2FC),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10.w)),
                                    border: Border.all(
                                      width: 1.w,
                                      color: Color(0xffC6A2FC),
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "PM",
                                      style: TextStyle(
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xff393838),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 15.w,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 180.w,
                          ),
                          GestureDetector(
                            onTap: () async {
                              if (int.parse(hour.text) < 13 &&
                                  int.parse(minute.text) < 60) {
                                if (int.parse(hour.text) == 12 &&
                                    int.parse(minute.text) > 0) {
                                  if(noon){
                                    pickTime(widget.id, widget.type);
                                  }else{
                                    hour.text = (int.parse(hour.text) - 12)
                                        .toString();
                                    pickTime(widget.id, widget.type);
                                  }
                                  Navigator.pop(context);
                                } else {
                                  if (noon) {
                                    pickTime(widget.id, widget.type);
                                  } else {
                                    setState(() {
                                      hour.text = (int.parse(hour.text) + 12)
                                          .toString();
                                      pickTime(widget.id, widget.type);
                                    });
                                  }
                                  Navigator.pop(context);
                                }
                              } else {
                                showToast("시간을 올바르게 설정해주세요.");
                              }
                            },
                            child: Container(
                              width: 60.w,
                              height: 40.w,
                              decoration: BoxDecoration(
                                color: Color(0xffC6A2FC),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0x29000000),
                                    blurRadius: 6,
                                    offset: Offset(0, 3),
                                  )
                                ],
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.w)),
                              ),
                              child: Center(
                                child: Text(
                                  "확인",
                                  style: TextStyle(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xff7649B7),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 8.w,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              width: 60.w,
                              height: 40.w,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0x29000000),
                                    blurRadius: 6,
                                    offset: Offset(0, 3),
                                  )
                                ],
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.w)),
                                border: Border.all(
                                    width: 1.w, color: Color(0xffC6A2FC)),
                              ),
                              child: Center(
                                child: Text(
                                  "취소",
                                  style: TextStyle(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xff7649B7),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  )))),
    );
  }
}
