import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;
import 'package:intl/intl.dart';

import 'package:treasure_map/c_activity/c1.dart';
import 'package:treasure_map/c_activity/c10.dart';
import 'package:treasure_map/c_activity/c2.dart';
import 'package:treasure_map/c_activity/c3.dart';
import 'package:treasure_map/c_activity/c4.dart';
import 'package:treasure_map/c_activity/c5.dart';
import 'package:treasure_map/c_activity/c6.dart';
import 'package:treasure_map/c_activity/c7.dart';
import 'package:treasure_map/c_activity/c8.dart';
import 'package:treasure_map/c_activity/c9.dart';
import 'package:treasure_map/provider/app_management.dart';
import 'package:treasure_map/widgets/menu_bar.dart';

import 'api/admin.dart';


class IActivity extends StatefulWidget {
  const IActivity({Key? key,
  this.pageNumber = 0,
  }) : super(key: key);
  final int pageNumber;
  static int nowPageNumber = 0;

  @override
  State<IActivity> createState() => _IActivityState();
}

class _IActivityState extends State<IActivity> {
  final autoLoginStorage = const FlutterSecureStorage();

  var tabNameList = [
    "attendance",
    "temperature",
    "emotion",
    "meal",
    "nap",
    "toilet",
    "dosage",
    "safetyAccident",
    "weight",
    "monthReport",
  ];

  @override
  void initState() {
    IActivity.nowPageNumber = widget.pageNumber;
    // TODO: implement initState
    super.initState();
  }

  void changePage(int clickPage) {
    setState(() {
      IActivity.nowPageNumber = clickPage;
    });
  }

  void nextPage() {
    if (IActivity.nowPageNumber == 9) {
      return;
    }
    setState(() {
      IActivity.nowPageNumber++;
    });
  }

  void prePage() {
    if (IActivity.nowPageNumber == 0) {
      return;
    }
    setState(() {
      IActivity.nowPageNumber--;
    });
  }

  activityTabLink(int _nowPage){
    var activityTabLinkList = [
      C1(nextPage: nextPage, prePage: prePage, nowPage : tabNameList[IActivity.nowPageNumber], scaffoldKey: _scaffoldState,),
      C2(nextPage: nextPage, prePage: prePage, nowPage : tabNameList[IActivity.nowPageNumber], scaffoldKey: _scaffoldState,),

      //C3 탭에서는 메뉴바가 열립니다.
      //scaffoldKey: _scaffoldState 를 추가하면 activity안에 있는 scaffold의 key를 얻어와 넘기는 겁니다.
      //C3와 같이 위젯 매개변수에
      //final GlobalKey<ScaffoldState> scaffoldKey; 를 추가해준다
      C3(nextPage: nextPage, prePage: prePage, nowPage : tabNameList[IActivity.nowPageNumber], scaffoldKey: _scaffoldState,),
      C4(nextPage: nextPage, prePage: prePage, nowPage : tabNameList[IActivity.nowPageNumber], scaffoldKey: _scaffoldState,),
      C5(nextPage: nextPage, prePage: prePage, nowPage : tabNameList[IActivity.nowPageNumber], scaffoldKey: _scaffoldState,),
      C6(nextPage: nextPage, prePage: prePage, nowPage : tabNameList[IActivity.nowPageNumber], scaffoldKey: _scaffoldState,),
      C7(nextPage: nextPage, prePage: prePage, nowPage : tabNameList[IActivity.nowPageNumber], scaffoldKey: _scaffoldState,),
      C8(nextPage: nextPage, prePage: prePage, nowPage : tabNameList[IActivity.nowPageNumber], scaffoldKey: _scaffoldState,),
      C9(nextPage: nextPage, prePage: prePage, nowPage : tabNameList[IActivity.nowPageNumber], scaffoldKey: _scaffoldState,),
      C10(nextPage: nextPage, prePage: prePage, nowPage : tabNameList[IActivity.nowPageNumber], scaffoldKey: _scaffoldState,)
    ];
    return(activityTabLinkList[_nowPage]);
  }
  GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>(); //appbar없는 menubar용

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.blue,
        key: _scaffoldState,
        endDrawer: MenuDrawer(),
        body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomLeft,
                colors: [
                  Color(0xffFFD288),
                  Color(0xffFDB43B),
                ],
              )),
          child: Row(
            children: [
              Flexible(
                flex: 1,
                child: Container(
                  child: PlayTabIcons(notifyParent: changePage),
                ),
              ),
              Flexible(
                flex: 10,
                child: activityTabLink(IActivity.nowPageNumber),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class PlayTabIcons extends StatefulWidget {
  const PlayTabIcons({Key? key, required this.notifyParent}) : super(key: key);
  final Function(int)? notifyParent;

  @override
  State<PlayTabIcons> createState() => _PlayTabIconsState();
}

class _PlayTabIconsState extends State<PlayTabIcons> {
  ListView IActivityListView = ListView();
  var iconColorPathList = [
    'assets/icons/icon_attendance_color.svg',
    'assets/icons/icon_temperature_color.svg',
    'assets/icons/icon_emotion_color.svg',
    'assets/icons/icon_meal_color.svg',
    'assets/icons/icon_nap_color.svg',
    'assets/icons/icon_toilet_color.svg',
    'assets/icons/icon_dosage_color.svg',
    'assets/icons/icon_safety_accident_color.svg',
    'assets/icons/icon_weight_color.svg',
    'assets/icons/icon_report_color.svg'
  ];
  var iconGrayPathList = [
    'assets/icons/icon_attendance_gray.svg',
    'assets/icons/icon_temperature_gray.svg',
    'assets/icons/icon_emotion_gray.svg',
    'assets/icons/icon_meal_gray.svg',
    'assets/icons/icon_nap_gray.svg',
    'assets/icons/icon_toilet_gray.svg',
    'assets/icons/icon_dosage_gray.svg',
    'assets/icons/icon_safety_accident_gray.svg',
    'assets/icons/icon_weight_gray.svg',
    'assets/icons/icon_report_gray.svg'
  ];
  var iconNameList = [
    "attendance",
    "temperature",
    "emotion",
    "meal",
    "nap",
    "toilet",
    "dosage",
    "safetyAccident",
    "weight",
    "report",

  ];

  @override
  Widget build(BuildContext context) {
    return
      ScrollConfiguration(
    behavior: const ScrollBehavior().copyWith(overscroll: false),
    child: ListView(
    physics: const RangeMaintainingScrollPhysics(),
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 10.w, bottom: 10.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                for (int i = 0; i < iconColorPathList.length; i++)
                  if (i == IActivity.nowPageNumber) ...[
                    Container(
                      padding: EdgeInsets.only(top: 10.w, bottom: 10.w),
                      child: Column(
                        children: [
                          IconButton(
                            icon: SvgPicture.asset(iconColorPathList[i]),
                            iconSize: 44.w,
                            onPressed: () {
                              widget.notifyParent!(i);
                            },
                          ),
                          Text(
                            iconNameList[i],
                            style: TextStyle(
                                color: Color(0xff393838),
                                fontWeight: FontWeight.w500,
                                fontSize: 12.w),
                          ).tr(),
                        ],
                      ),
                    ),
                  ] else
                    if (i != IActivity.nowPageNumber) ...[
                      Container(
                        padding: EdgeInsets.only(top: 10.w, bottom: 10.w),
                        child: Column(
                          children: [
                            IconButton(
                              icon: SvgPicture.asset(iconGrayPathList[i]),
                              iconSize: 44.w,
                              onPressed: () {
                                widget.notifyParent!(i);
                              },
                            ),
                            Text(
                              iconNameList[i],
                              style: TextStyle(
                                  color: Color(0xff393838),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12.w),
                            ).tr(),
                          ],
                        ),
                      ),
                    ],
                SizedBox(
                  height: 25.w,
                )
              ],
            ),
          )
        ],
    ),
      );
  }
}