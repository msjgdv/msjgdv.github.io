import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:treasure_map/d_play/d3_1.dart';
import 'package:treasure_map/provider/app_management.dart';
import 'package:treasure_map/widgets/api.dart';
import 'package:treasure_map/widgets/calendar.dart';
import 'package:treasure_map/widgets/get_container_info.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:treasure_map/widgets/image_container.dart';
import 'package:treasure_map/widgets/nuri.dart';
import 'package:treasure_map/widgets/overtab.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:treasure_map/widgets/sample_record.dart';
import '../widgets/custom_container.dart';

class D4 extends StatefulWidget {
  const D4({
    Key? key,
    required this.nextPage,
    required this.prePage,
    required this.nowPage,
    this.scaffoldKey,
    this.pageTime,
  }) : super(key: key);
  final Function nextPage;
  final Function prePage;
  final String nowPage;
  final GlobalKey<ScaffoldState>? scaffoldKey;
  final DateTime? pageTime;

  @override
  State<D4> createState() => _D4State();
}

class _D4State extends State<D4> {
  bool dateOff = false;

  DateTime pageTime = DateTime.now();
  String pageTimeStr = '';

  double totalHeight = 457;

  totalHeightSet(double value) {
    setState(() {
      totalHeight = value;
    });
  }

  receiveData(DateTime dateTime) async {
    pageTime = dateTime;
    var formatter = DateFormat('yyyyMMdd');
    pageTimeStr = formatter.format(pageTime);
    setState(() {});
  }

  @override
  initState() {
    if (widget.pageTime != null) {
      receiveData(widget.pageTime!);
    }
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
        color: Color(0xffFCFCFC),
      ),
      child: Column(
        children: [
          OverTab(
            nextPage: widget.nextPage,
            prePage: widget.prePage,
            nowPage: widget.nowPage,
            dateOnOff: dateOff,
            receiveData: receiveData,
            scaffoldKey: widget.scaffoldKey,
          ),
          Expanded(
            child: ScrollConfiguration(
              behavior: const ScrollBehavior().copyWith(overscroll: false),
              child: ListView(
                padding: EdgeInsets.zero,
                physics: const RangeMaintainingScrollPhysics(),
                children: [
                  Row(
                    children: [
                      Container(
                        width: 39.w,
                        //여기도 높이가 계속 추가가 되야함
                        height: totalHeight.w,
                        decoration: BoxDecoration(
                          color: const Color(0xffFCFCFC),
                        ),
                      ),
                      DailyRoutineTable(
                        totalHeightSet: totalHeightSet,
                        pageTime: widget.pageTime,
                      ),
                    ],
                  ),
                  Container(
                    width: 39.w,
                    height: (41).w,
                    decoration: BoxDecoration(
                      color: const Color(0xffFCFCFC),
                    ),
                  ),
                  // Row(
                  //   children: [
                  //     Container(
                  //       width: 39.w,
                  //       height: 50.w,
                  //       decoration: BoxDecoration(
                  //         color: const Color(0xffFCFCFC),
                  //       ),
                  //     ),
                  //     SizedBox(
                  //       width: 501.w,
                  //     ),
                  //     GestureDetector(
                  //       onTap: () {
                  //       },
                  //       child: Container(
                  //         width: 50.w,
                  //         height: 50.w,
                  //         decoration: BoxDecoration(
                  //             borderRadius:
                  //             BorderRadius.all(Radius.circular(10.w)),
                  //             color: Color(0xffC6A2FC),
                  //             boxShadow: [
                  //               BoxShadow(
                  //                 color: Color(0x29000000),
                  //                 blurRadius: 6,
                  //                 offset: Offset(0, 3),
                  //               )
                  //             ]),
                  //         child: Center(
                  //           child: Icon(Icons.add,
                  //           color: Color(0xff7649B7),
                  //           size: 24.w,)
                  //         ),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  Row(
                    children: [
                      Container(
                        width: 50.w,
                        height: 50.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(50.w)),
                          color: const Color(0xffFCFCFC),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DailyRoutineTable extends StatefulWidget {
  const DailyRoutineTable({
    Key? key,
    required this.totalHeightSet,
    required this.pageTime,
  }) : super(key: key);
  final Function(double) totalHeightSet;
  final DateTime? pageTime;

  @override
  State<DailyRoutineTable> createState() => _DailyRoutineTableState();
}

class _DailyRoutineTableState extends State<DailyRoutineTable> {
  Color borderColor = const Color(0x9dC13BFD);
  ApiUrl apiUrl = ApiUrl();
  DateTime pageTime = DateTime.now();
  var formatter = DateFormat('yyyyMMdd');
  String pageTimeStr = '';
  List<String> weekDay = ["", "월요일", "화요일", "수요일", "목요일", "금요일", "토요일", "일요일"];
  var dailyData;
  List<Image?> signImage = [];
  TextEditingController subject = TextEditingController();
  TextEditingController purpose = TextEditingController();
  TextEditingController timeTable = TextEditingController();
  TextEditingController nuriEvaluation = TextEditingController();
  List<TextEditingController> plan = [];
  List<int> textHeight = [];
  double totalTextHeight = 0;

  getDailyData() async {
    http.Response dailyRes = await api(
        apiUrl.daily +
            '/' +
            pageTimeStr +
            '/' +
            Provider
                .of<UserInfo>(context, listen: false)
                .value[0].toString(),
        'get',
        'signInToken',
        {},
        context);
    if (dailyRes.statusCode == 200) {
      if (mounted) {
        setState(() {
          var dailyRB = utf8.decode(dailyRes.bodyBytes);
          dailyData = jsonDecode(dailyRB);
        });

        signImage.clear();
        if (dailyData['teacherSign'] != null) {
          signImage.add(
              await imageApi(dailyData['teacherSign'], 'signInToken', context));
        } else {
          signImage.add(null);
        }
        if (dailyData['viceDirectorSign'] != null) {
          signImage.add(await imageApi(
              dailyData['viceDirectorSign'], 'signInToken', context));
        } else {
          signImage.add(null);
        }
        if (dailyData['directorSign'] != null) {
          signImage.add(await imageApi(
              dailyData['directorSign'], 'signInToken', context));
        } else {
          signImage.add(null);
        }
        textHeight.clear();
        totalTextHeight = 0;
        for (int i = 0; i < dailyData['selectedRecords'].length; i++) {
          if (dailyData['selectedRecords'][i]['played'] != null) {
            textHeight.add(
                dailyData['selectedRecords'][i]['played']
                    .split('\n')
                    .length);
          } else {
            textHeight.add(1);
          }
          totalTextHeight = totalTextHeight +
              56 +
              (textHeight[i] > 2 ? ((textHeight[i] - 2) * 26) : 0);
        }
        widget.totalHeightSet(401 + totalTextHeight);
        setState(() {});
      }
    }
  }

  postDailyData(String type, String value) async {
    http.Response dailyRes = await api(
        apiUrl.daily,
        'post',
        'signInToken',
        {
          "cid":
          Provider
              .of<UserInfo>(context, listen: false)
              .value[0].toString(),
          "date": pageTimeStr,
          "type": type,
          "value": value,
        },
        context);
    if (dailyRes.statusCode == 200) {
      print("보내짐");
      getDailyData();
    }
  }

  postDailyPlanData(int rid, String value) async {
    http.Response dailyRes = await api(apiUrl.dailyPlan, 'post', 'signInToken',
        {"id": rid.toString(), "plan": value}, context);
    if (dailyRes.statusCode == 200) {
      getDailyData();
    }
  }

  patchSign() async {
    http.Response childRes = await api(
        apiUrl.dailySign,
        'patch',
        'signInToken',
        {
          'date': pageTimeStr,
          'cid':
          Provider
              .of<UserInfo>(context, listen: false)
              .value[0].toString(),
        },
        context);
    if (childRes.statusCode == 200) {
      getDailyData();
    }
  }

  changeDate(DateTime date) {
    setState(() {
      pageTime = date;
      pageTimeStr = formatter.format(pageTime);
      getDailyData();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.pageTime != null) {
      pageTime = widget.pageTime!;
    }
    pageTimeStr = formatter.format(pageTime);
    getDailyData();
  }

  @override
  Widget build(BuildContext context) {
    if (dailyData != null) {
      print("뭔가 뭔가임");
      subject.text = dailyData['subject'] ?? '';
      purpose.text = dailyData['purpose'] ?? '';
      timeTable.text = dailyData['timeTable'] ?? '';
      nuriEvaluation.text = dailyData['nuriEvaluation'] ?? '';
      plan.clear();
      for (int i = 0; i < dailyData['selectedRecords'].length; i++) {
        plan.add(TextEditingController(
            text: dailyData['selectedRecords'][i]['plan']));
      }
    }

    return Container(
      //한칸을 추가할때마다 높이가 추가 되도록
      width: 1053.w,
      height: (401 + totalTextHeight).w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(20.w), topLeft: Radius.circular(20.w)),
        boxShadow: [
          BoxShadow(
            color: Color(0x29B1B1B1),
            blurRadius: 6,
            offset: Offset(-2, 2),
          )
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              CustomContainer(
                cBorderColor: borderColor,
                cTotalHeight: 50.w,
                cTotalWidth: 553.w,
                cBorderRadius:
                BorderRadius.only(topLeft: Radius.circular(20.w)),
                cInsideColor: Color(0xffCAACF2),
                cTopBorderWidth: 1.w,
                cLeftBorderWidth: 1.w,
                childWidget: Center(
                  child: DailyRoutineTableTextStyle(
                    text: DateTime
                        .now()
                        .year
                        .toString() +
                        "년도 " +
                        Provider
                            .of<UserInfo>(context, listen: false)
                            .value[2] +
                        "의 하루일과 계획 및 평가",
                  ),
                ),
              ),
              CustomContainer(
                cBorderColor: borderColor,
                cTotalHeight: 50.w,
                cTotalWidth: 87.w,
                cInsideColor: Color(0xffCAACF2),
                cTopBorderWidth: 1.w,
                cLeftBorderWidth: 1.w,
                childWidget: Center(
                  child: DailyRoutineTableTextStyle(text: '날짜'),
                ),
              ),
              GestureDetector(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AijoaCalendar(
                            changeDate: changeDate, nowDate: DateTime.now());
                      });
                },
                child: CustomContainer(
                  cBorderColor: borderColor,
                  cTotalHeight: 50.w,
                  cTotalWidth: 163.w,
                  cInsideColor: Color(0xffffffff),
                  cTopBorderWidth: 1.w,
                  cLeftBorderWidth: 1.w,
                  childWidget: Center(
                    child: DailyRoutineTableTextStyle(
                      text: pageTime.year.toString() +
                          '년 ' +
                          pageTime.month.toString() +
                          '월 ' +
                          pageTime.day.toString() +
                          '일 ' +
                          weekDay[pageTime.weekday] +
                          ' ',
                    ),
                  ),
                ),
              ),
              CustomContainer(
                cBorderColor: borderColor,
                cTotalHeight: 50.w,
                cTotalWidth: 87.w,
                cInsideColor: Color(0xffCAACF2),
                cTopBorderWidth: 1.w,
                cLeftBorderWidth: 1.w,
                childWidget: Center(
                  child: DailyRoutineTableTextStyle(
                    text: "수업일수",
                  ),
                ),
              ),
              CustomContainer(
                cBorderColor: borderColor,
                cTotalHeight: 50.w,
                cTotalWidth: 163.w,
                cBorderRadius:
                BorderRadius.only(topRight: Radius.circular(20.w)),
                cInsideColor: Color(0xffffffff),
                cTopBorderWidth: 1.w,
                cLeftBorderWidth: 1.w,
                cRightBorderWidth: 1.w,
                childWidget: Center(
                  child: DailyRoutineTableTextStyle(
                    text: "수업일수",
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              CustomContainer(
                cBorderColor: borderColor,
                cTotalHeight: 40.w,
                cTotalWidth: 277.w,
                cInsideColor: Color(0xffCAACF2),
                cTopBorderWidth: 1.w,
                cLeftBorderWidth: 1.w,
                childWidget: Center(
                  child: DailyRoutineTableTextStyle(
                    text: "주제",
                  ),
                ),
              ),
              CustomContainer(
                cBorderColor: borderColor,
                cTotalHeight: 40.w,
                cTotalWidth: 276.w,
                cInsideColor: Color(0xffCAACF2),
                cTopBorderWidth: 1.w,
                cLeftBorderWidth: 1.w,
                childWidget: Center(
                  child: DailyRoutineTableTextStyle(
                    text: "목표",
                  ),
                ),
              ),
              CustomContainer(
                cBorderColor: borderColor,
                cTotalHeight: 40.w,
                cTotalWidth: 500.w,
                cInsideColor: Color(0xffE5D0FE),
                cTopBorderWidth: 1.w,
                cLeftBorderWidth: 1.w,
                cRightBorderWidth: 1.w,
                childWidget: Center(
                  child: DailyRoutineTableTextStyle(
                    text: "결재",
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              CustomContainer(
                cBorderColor: borderColor,
                cTotalHeight: 70.w,
                cTotalWidth: 277.w,
                cInsideColor: Color(0xffffffff),
                cTopBorderWidth: 1.w,
                cLeftBorderWidth: 1.w,
                childWidget: Center(
                  child: Focus(
                    onFocusChange: (hasFocus) async {
                      if (hasFocus) {} else {
                        // widget.selectWidgetOnOff(false);
                        if (dailyData["subject"] == subject.text) {} else {
                          print("체크");
                          await postDailyData('subject', subject.text);
                        }
                      }
                    },
                    child: TextField(
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        // contentPadding: EdgeInsets.symmetric(
                        //     horizontal: 10.w, vertical: 0),
                        isDense: true,
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                        ), //외곽선
                      ),
                      controller: subject,
                      style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xff393838)),
                      // maxLines: 20,
                    ),
                  ),
                ),
              ),
              CustomContainer(
                cBorderColor: borderColor,
                cTotalHeight: 70.w,
                cTotalWidth: 276.w,
                cInsideColor: Color(0xffffffff),
                cTopBorderWidth: 1.w,
                cLeftBorderWidth: 1.w,
                childWidget: Center(
                  child: Focus(
                    onFocusChange: (hasFocus) async {
                      if (hasFocus) {} else {
                        // widget.selectWidgetOnOff(false);
                        if (dailyData["purpose"] == purpose.text) {} else {
                          print("체크");
                          await postDailyData('purpose', purpose.text);
                        }
                      }
                    },
                    child: TextField(
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        // contentPadding: EdgeInsets.symmetric(
                        //     horizontal: 10.w, vertical: 0),
                        isDense: true,
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                        ), //외곽선
                      ),
                      controller: purpose,
                      style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xff393838)),
                      // maxLines: 20,
                    ),
                  ),
                ),
              ),
              CustomContainer(
                cBorderColor: borderColor,
                cTotalHeight: 70.w,
                cTotalWidth: 86.w,
                cInsideColor: Color(0xffCAACF2),
                cTopBorderWidth: 1.w,
                cLeftBorderWidth: 1.w,
                childWidget: Center(
                  child: DailyRoutineTableTextStyle(
                    text: "교사",
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  patchSign();
                },
                child: CustomContainer(
                  cBorderColor: borderColor,
                  cTotalHeight: 70.w,
                  cTotalWidth: 80.w,
                  cInsideColor: Color(0xffffffff),
                  cTopBorderWidth: 1.w,
                  cLeftBorderWidth: 1.w,
                  childWidget: Center(
                    child: signImage.isNotEmpty
                        ? signImage[0] ?? Container()
                        : Container(),
                  ),
                ),
              ),
              CustomContainer(
                cBorderColor: borderColor,
                cTotalHeight: 70.w,
                cTotalWidth: 86.w,
                cInsideColor: Color(0xffCAACF2),
                cTopBorderWidth: 1.w,
                cLeftBorderWidth: 1.w,
                childWidget: Center(
                  child: DailyRoutineTableTextStyle(
                    text: "원감",
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  patchSign();
                },
                child: CustomContainer(
                  cBorderColor: borderColor,
                  cTotalHeight: 70.w,
                  cTotalWidth: 81.w,
                  cInsideColor: Color(0xffffffff),
                  cTopBorderWidth: 1.w,
                  cLeftBorderWidth: 1.w,
                  childWidget: Center(
                    child: signImage.length > 1
                        ? signImage[1] ?? Container()
                        : Container(),
                  ),
                ),
              ),
              CustomContainer(
                cBorderColor: borderColor,
                cTotalHeight: 70.w,
                cTotalWidth: 86.w,
                cInsideColor: Color(0xffCAACF2),
                cTopBorderWidth: 1.w,
                cLeftBorderWidth: 1.w,
                childWidget: Center(
                  child: DailyRoutineTableTextStyle(
                    text: "원장",
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  patchSign();
                },
                child: CustomContainer(
                  cBorderColor: borderColor,
                  cTotalHeight: 70.w,
                  cTotalWidth: 81.w,
                  cInsideColor: Color(0xffffffff),
                  cTopBorderWidth: 1.w,
                  cLeftBorderWidth: 1.w,
                  cRightBorderWidth: 1.w,
                  childWidget: Center(
                    child: signImage.length > 2
                        ? signImage[2] ?? Container()
                        : Container(),
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              CustomContainer(
                cBorderColor: borderColor,
                cTotalHeight: 85.w,
                cTotalWidth: 96.w,
                cInsideColor: Color(0xffCAACF2),
                cTopBorderWidth: 1.w,
                cLeftBorderWidth: 1.w,
                childWidget: Center(
                  child: DailyRoutineTableTextStyle(
                    text: "일과 시간표",
                  ),
                ),
              ),
              CustomContainer(
                cBorderColor: borderColor,
                cTotalHeight: 85.w,
                cTotalWidth: 957.w,
                cInsideColor: Color(0xffffffff),
                cTopBorderWidth: 1.w,
                cLeftBorderWidth: 1.w,
                cRightBorderWidth: 1.w,
                childWidget: Center(
                  child: Focus(
                    onFocusChange: (hasFocus) async {
                      if (hasFocus) {} else {
                        // widget.selectWidgetOnOff(false);
                        if (dailyData["timeTable"] == timeTable.text) {} else {
                          print("체크");
                          await postDailyData('timeTable', timeTable.text);
                        }
                      }
                    },
                    child: TextField(
                      textAlign: TextAlign.start,
                      decoration: InputDecoration(
                        contentPadding:
                        EdgeInsets.symmetric(horizontal: 10.w, vertical: 0),
                        isDense: true,
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                        ), //외곽선
                      ),
                      controller: timeTable,
                      style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xff393838)),
                      maxLines: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              CustomContainer(
                cBorderColor: borderColor,
                cTotalHeight: 40.w,
                cTotalWidth: 96.w,
                cInsideColor: Color(0xffE5D0FE),
                cTopBorderWidth: 1.w,
                cLeftBorderWidth: 1.w,
                childWidget: Center(
                  child: DailyRoutineTableTextStyle(
                    text: "영역",
                  ),
                ),
              ),
              CustomContainer(
                cBorderColor: borderColor,
                cTotalHeight: 40.w,
                cTotalWidth: 457.w,
                cInsideColor: Color(0xffCAACF2),
                cTopBorderWidth: 1.w,
                cLeftBorderWidth: 1.w,
                childWidget: Center(
                  child: DailyRoutineTableTextStyle(
                    text: "실행내용",
                  ),
                ),
              ),
              CustomContainer(
                cBorderColor: borderColor,
                cTotalHeight: 40.w,
                cTotalWidth: 500.w,
                cInsideColor: Color(0xffCAACF2),
                cTopBorderWidth: 1.w,
                cLeftBorderWidth: 1.w,
                cRightBorderWidth: 1.w,
                childWidget: Center(
                  child: DailyRoutineTableTextStyle(
                    text: "계획내용",
                  ),
                ),
              ),
            ],
          ),
          //한줄한줄 추가 되는 공간
          if (dailyData != null) ...[
            for (int i = 0; i < dailyData['selectedRecords'].length; i++) ...[
              Row(
                children: [
                  CustomContainer(
                    cBorderColor: borderColor,
                    cTotalHeight: 56.w +
                        (textHeight[i] > 2 ? ((textHeight[i] - 2) * 26).w : 0),
                    cTotalWidth: 96.w,
                    cInsideColor: Color(0xffCAACF2),
                    cTopBorderWidth: 1.w,
                    cLeftBorderWidth: 1.w,
                    childWidget: Center(),
                  ),
                  CustomContainer(
                    cBorderColor: borderColor,
                    cTotalHeight: 56.w +
                        (textHeight[i] > 2 ? ((textHeight[i] - 2) * 26).w : 0),
                    cTotalWidth: 457.w,
                    cInsideColor: Color(0xffffffff),
                    cTopBorderWidth: 1.w,
                    cLeftBorderWidth: 1.w,
                    childWidget: Text(
                      dailyData['selectedRecords'][i]['played'] ?? '',
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14.sp,
                          color: Color(0xff393838)),
                      textAlign: TextAlign.start,
                      maxLines: 20,
                    ),
                  ),
                  CustomContainer(
                    cBorderColor: borderColor,
                    cTotalHeight: 56.w +
                        (textHeight[i] > 2 ? ((textHeight[i] - 2) * 26).w : 0),
                    cTotalWidth: 500.w,
                    cInsideColor: Color(0xffffffff),
                    cTopBorderWidth: 1.w,
                    cLeftBorderWidth: 1.w,
                    cRightBorderWidth: 1.w,
                    childWidget: Center(
                      child: Focus(
                        onFocusChange: (hasFocus) async {
                          if (hasFocus) {} else {
                            // widget.selectWidgetOnOff(false);
                            if (dailyData['selectedRecords'][i]['plan'] ==
                                plan[i].text) {} else {
                              print("체크");
                              await postDailyPlanData(
                                  dailyData['selectedRecords'][i]['id'],
                                  plan[i].text);
                            }
                          }
                        },
                        child: TextField(
                          textAlign: TextAlign.start,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 10.w, vertical: 0),
                            isDense: true,
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                            ), //외곽선
                          ),
                          controller: plan[i],
                          style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xff393838)),
                          maxLines: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],

          //이친구는 마지막줄에 무조건 있어야 할듯

          Row(
            children: [
              CustomContainer(
                cBorderColor: borderColor,
                cTotalHeight: 56.w,
                cTotalWidth: 96.w,
                cInsideColor: Color(0xffCAACF2),
                cTopBorderWidth: 1.w,
                cLeftBorderWidth: 1.w,
                childWidget: Center(),
              ),
              CustomContainer(
                  cBorderColor: borderColor,
                  cTotalHeight: 56.w,
                  cTotalWidth: 457.w,
                  cInsideColor: Color(0xffffffff),
                  cTopBorderWidth: 1.w,
                  cLeftBorderWidth: 1.w,
                  childWidget: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return RecordListDialog(
                                  date: pageTimeStr,
                                  getDailyData: getDailyData,
                                );
                              });
                        },
                        child: Stack(
                          children: [
                            Positioned(
                              top: 5.w,
                              left: 4.w,
                              child: Container(
                                width: 35.w,
                                height: 35.w,
                                decoration: BoxDecoration(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(10.w)),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color(0x29505050),
                                      blurRadius: 6,
                                      offset: Offset(
                                          1, 1), // changes position of shadow
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SvgPicture.asset(
                              'assets/icons/icon_download.svg',
                              width: 45.w,
                            ),
                          ],
                        ),
                      )
                    ],
                  )),
              CustomContainer(
                cBorderColor: borderColor,
                cTotalHeight: 56.w,
                cTotalWidth: 500.w,
                cInsideColor: Color(0xffffffff),
                cTopBorderWidth: 1.w,
                cLeftBorderWidth: 1.w,
                cRightBorderWidth: 1.w,
                childWidget: Center(),
              ),
            ],
          ),

          Row(
            children: [
              CustomContainer(
                cBorderColor: borderColor,
                cTotalHeight: 60.w,
                cTotalWidth: 96.w,
                cBorderRadius:
                BorderRadius.only(bottomLeft: Radius.circular(20.w)),
                cInsideColor: Color(0xffCAACF2),
                cTopBorderWidth: 1.w,
                cLeftBorderWidth: 1.w,
                cBottomBorderWidth: 1.w,
                childWidget: Center(
                  child: DailyRoutineTableTextStyle(
                    text: "누리과정\n운영평가",
                  ),
                ),
              ),
              CustomContainer(
                cBorderColor: borderColor,
                cTotalHeight: 60.w,
                cTotalWidth: 957.w,
                cBorderRadius:
                BorderRadius.only(bottomRight: Radius.circular(20.w)),
                cInsideColor: Color(0xffffffff),
                cTopBorderWidth: 1.w,
                cLeftBorderWidth: 1.w,
                cRightBorderWidth: 1.w,
                cBottomBorderWidth: 1.w,
                childWidget: Center(
                  child: Focus(
                    onFocusChange: (hasFocus) async {
                      if (hasFocus) {} else {
                        // widget.selectWidgetOnOff(false);
                        if (dailyData["nuriEvaluation"] ==
                            nuriEvaluation.text) {} else {
                          print("체크");
                          await postDailyData(
                              'nuriEvaluation', nuriEvaluation.text);
                        }
                      }
                    },
                    child: TextField(
                      textAlign: TextAlign.start,
                      decoration: InputDecoration(
                        contentPadding:
                        EdgeInsets.symmetric(horizontal: 10.w, vertical: 0),
                        isDense: true,
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                        ), //외곽선
                      ),
                      controller: nuriEvaluation,
                      style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xff393838)),
                      maxLines: 20,
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

class DailyRoutineTableTextStyle extends StatefulWidget {
  const DailyRoutineTableTextStyle({
    Key? key,
    required this.text,

  }) : super(key: key);
  final String text;


  @override
  State<DailyRoutineTableTextStyle> createState() =>
      _DailyRoutineTableTextStyleState();
}

class _DailyRoutineTableTextStyleState
    extends State<DailyRoutineTableTextStyle> {
  @override
  Widget build(BuildContext context) {
    return Text(
      widget.text,
      style: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 14.sp,
          color: Color(0xff393838)),
    );
  }
}

class RecordListDialog extends StatefulWidget {
  const RecordListDialog({
    Key? key,
    required this.date,
    required this.getDailyData,
  }) : super(key: key);
  final String date;
  final Function() getDailyData;

  @override
  State<RecordListDialog> createState() => _RecordListDialogState();
}

class _RecordListDialogState extends State<RecordListDialog> {
  ApiUrl apiUrl = ApiUrl();
  var recordData;

  getRecordDay() async {
    http.Response res = await api(
        '${apiUrl.record}/date/${widget.date}/${Provider
            .of<UserInfo>(context, listen: false)
            .value[0]}',
        'get',
        'signInToken',
        {},
        context);
    if (res.statusCode == 200) {
      var recordRB = utf8.decode(res.bodyBytes);
      setState(() {
        recordData = jsonDecode(recordRB);
      });
      print(recordData);
    }
  }

  postRecordToDaily(int rid) async {
    http.Response res = await api(
        apiUrl.recordToDaily,
        'post',
        'signInToken',
        {
          "id": rid,
          "cid": Provider
              .of<UserInfo>(context, listen: false)
              .value[0]
        },
        context);
    if (res.statusCode == 200) {
      getRecordDay();
      widget.getDailyData();
    }
  }

  deleteRecordFromDaily(int rid) async {
    http.Response res = await api(
        '${apiUrl.recordToDaily}/$rid', 'delete', 'signInToken', {}, context);
    if (res.statusCode == 200) {
      getRecordDay();
      widget.getDailyData();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getRecordDay();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
        elevation: 0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.w))),
        child: Container(
          width: 1100.w,
          height: 550.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20.w)),
            color: Color(0xffffffff),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 100.w,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomContainer(
                    cBorderColor: const Color(0x9dC13BFD),
                    cTotalHeight: 40.w,
                    cTotalWidth: 50.w,
                    cInsideColor: Color(0xffCAACF2),
                    cBorderRadius:
                    BorderRadius.only(topLeft: Radius.circular(10.w)),
                    cTopBorderWidth: 1.w,
                    cLeftBorderWidth: 1.w,
                    cRightBorderWidth: 1.w,
                    cBottomBorderWidth: 1.w,
                    childWidget: Center(
                      child: DailyRoutineTableTextStyle(
                        text: "",
                      ),
                    ),
                  ),
                  CustomContainer(
                    cBorderColor: const Color(0x9dC13BFD),
                    cTotalHeight: 40.w,
                    cTotalWidth: 60.w,
                    cInsideColor: Color(0xffCAACF2),
                    // cBorderRadius: BorderRadius.only(topLeft: Radius.circular(20.w)),
                    cTopBorderWidth: 1.w,
                    cRightBorderWidth: 1.w,
                    cBottomBorderWidth: 1.w,
                    childWidget: Center(
                      child: DailyRoutineTableTextStyle(
                        text: "번호",
                      ),
                    ),
                  ),
                  CustomContainer(
                    cBorderColor: const Color(0x9dC13BFD),
                    cTotalHeight: 40.w,
                    cTotalWidth: 203.w,
                    cInsideColor: Color(0xffCAACF2),
                    cTopBorderWidth: 1.w,
                    cRightBorderWidth: 1.w,
                    cBottomBorderWidth: 1.w,
                    childWidget: Center(
                      child: DailyRoutineTableTextStyle(
                        text: "놀이주제",
                      ),
                    ),
                  ),
                  CustomContainer(
                    cBorderColor: const Color(0x9dC13BFD),
                    cTotalHeight: 40.w,
                    cTotalWidth: 350.w,
                    cInsideColor: Color(0xffCAACF2),
                    cTopBorderWidth: 1.w,
                    cRightBorderWidth: 1.w,
                    cBottomBorderWidth: 1.w,
                    childWidget: Center(
                      child: DailyRoutineTableTextStyle(
                        text: "관찰유아",
                      ),
                    ),
                  ),
                  CustomContainer(
                    cBorderColor: const Color(0x9dC13BFD),
                    cTotalHeight: 40.w,
                    cTotalWidth: 290.w,
                    cInsideColor: Color(0xffCAACF2),
                    cTopBorderWidth: 1.w,
                    cRightBorderWidth: 1.w,
                    cBottomBorderWidth: 1.w,
                    childWidget: Center(
                      child: DailyRoutineTableTextStyle(
                        text: "유아관심",
                      ),
                    ),
                  ),
                  CustomContainer(
                    cBorderColor: const Color(0x9dC13BFD),
                    cTotalHeight: 40.w,
                    cTotalWidth: 100.w,
                    cInsideColor: Color(0xffCAACF2),
                    cBorderRadius:
                    BorderRadius.only(topRight: Radius.circular(10.w)),
                    cTopBorderWidth: 1.w,
                    cRightBorderWidth: 1.w,
                    cBottomBorderWidth: 1.w,
                    childWidget: Center(
                      child: DailyRoutineTableTextStyle(
                        text: "관찰자",
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                  child: ScrollConfiguration(
                      behavior: const ScrollBehavior()
                          .copyWith(overscroll: false),
                      child: ListView(
                        padding: EdgeInsets.zero,
                        physics: const RangeMaintainingScrollPhysics(),
                        children: [
                          if (recordData != null) ...[
                            for (int i = 0; i < recordData.length; i++) ...[
                              GestureDetector(
                                onTap: () {
                                  showDialog(context: context,
                                      builder: (BuildContext context) {
                                        return SampleRecord(
                                          recordId: recordData[i]['id'],);
                                      });
                                },
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        if (recordData[i]['daily']) {
                                          deleteRecordFromDaily(
                                              recordData[i]['id']);
                                        } else {
                                          postRecordToDaily(
                                              recordData[i]['id']);
                                        }
                                      },
                                      child: CustomContainer(
                                        cBorderColor:
                                        const Color(0x9dC13BFD),
                                        cTotalHeight: 40.w,
                                        cTotalWidth: 50.w,
                                        cInsideColor: Color(0xffffffff),
                                        cBorderRadius: i ==
                                            recordData.length - 1
                                            ? BorderRadius.only(
                                            bottomLeft:
                                            Radius.circular(10.w))
                                            : BorderRadius.zero,
                                        cLeftBorderWidth: 1.w,
                                        cRightBorderWidth: 1.w,
                                        cBottomBorderWidth: 1.w,
                                        childWidget: Center(
                                            child: Container(
                                              width: 30.w,
                                              height: 30.w,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(5.w)),
                                                border: Border.all(
                                                    color: Color(0xffFDB43B),
                                                    width: 1.w),
                                                color: recordData[i]['daily']
                                                    ? Color(0xffFDB43B)
                                                    : Colors.white,
                                              ),
                                            )),
                                      ),
                                    ),
                                    CustomContainer(
                                      cBorderColor: const Color(0x9dC13BFD),
                                      cTotalHeight: 40.w,
                                      cTotalWidth: 60.w,
                                      cInsideColor: Color(0xffffffff),
                                      cRightBorderWidth: 1.w,
                                      cBottomBorderWidth: 1.w,
                                      childWidget: Center(
                                        child: DailyRoutineTableTextStyle(
                                          text: (i + 1).toString(),
                                        ),
                                      ),
                                    ),
                                    CustomContainer(
                                      cBorderColor: const Color(0x9dC13BFD),
                                      cTotalHeight: 40.w,
                                      cTotalWidth: 203.w,
                                      cInsideColor: Color(0xffffffff),
                                      cRightBorderWidth: 1.w,
                                      cBottomBorderWidth: 1.w,
                                      childWidget: Center(
                                        child: DailyRoutineTableTextStyle(
                                          text: recordData[i]['subject'] ??
                                              '',
                                        ),
                                      ),
                                    ),
                                    CustomContainer(
                                      cBorderColor: const Color(0x9dC13BFD),
                                      cTotalHeight: 40.w,
                                      cTotalWidth: 350.w,
                                      cInsideColor: Color(0xffffffff),
                                      cRightBorderWidth: 1.w,
                                      cBottomBorderWidth: 1.w,
                                      childWidget: Center(
                                        child: DailyRoutineTableTextStyle(
                                          text: recordData[i]['children'] ??
                                              '',
                                        ),
                                      ),
                                    ),
                                    CustomContainer(
                                      cBorderColor: const Color(0x9dC13BFD),
                                      cTotalHeight: 40.w,
                                      cTotalWidth: 290.w,
                                      cInsideColor: Color(0xffffffff),
                                      cRightBorderWidth: 1.w,
                                      cBottomBorderWidth: 1.w,
                                      childWidget: Center(
                                        child: DailyRoutineTableTextStyle(
                                          text: recordData[i]['interest'] ??
                                              '',
                                        ),
                                      ),
                                    ),
                                    CustomContainer(
                                      cBorderColor: const Color(0x9dC13BFD),
                                      cTotalHeight: 40.w,
                                      cTotalWidth: 100.w,
                                      cInsideColor: Color(0xffffffff),
                                      cBorderRadius:
                                      i == recordData.length - 1
                                          ? BorderRadius.only(
                                          bottomRight:
                                          Radius.circular(10.w))
                                          : BorderRadius.zero,
                                      cRightBorderWidth: 1.w,
                                      cBottomBorderWidth: 1.w,
                                      childWidget: Center(
                                        child: DailyRoutineTableTextStyle(
                                          text:
                                          recordData[i]['writer'] ?? '',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ]
                          ]
                        ],
                      ))),
              SizedBox(
                height: 50.w,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // ElevatedButton(
                  //   onPressed: () {
                  //   },
                  //   child: Text('저장',
                  //       style: TextStyle(
                  //           fontSize: 18.sp, fontWeight: FontWeight.w400)),
                  //   style: ElevatedButton.styleFrom(
                  //       elevation: 1.0,
                  //       primary: const Color(0xFFFFFFFF),
                  //       onPrimary: const Color(0xFF393838),
                  //       shape: RoundedRectangleBorder(
                  //           borderRadius: BorderRadius.circular(10.w)),
                  //       side: const BorderSide(color: Color(0xFFA666FB)),
                  //       fixedSize: Size(120.w, 40.w)),
                  // ),
                  // SizedBox(
                  //   width: 50.w,
                  // ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); //result 반영 dialog 종료
                    },
                    child: Text('닫기',
                        style: TextStyle(
                            fontSize: 18.sp, fontWeight: FontWeight.w400)),
                    style: ElevatedButton.styleFrom(
                        elevation: 1.0,
                        primary: const Color(0xFFFFFFFF),
                        onPrimary: const Color(0xFF393838),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.w)),
                        side: const BorderSide(color: Color(0xFFA666FB)),
                        fixedSize: Size(120.w, 40.w)),
                  ),
                ],
              ),
              SizedBox(
                height: 50.w,
              ),
            ],
          ),
        ));
  }
}