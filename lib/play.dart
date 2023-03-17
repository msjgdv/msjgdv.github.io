import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;
import 'package:http/http.dart' as http;

import 'package:treasure_map/d_play/d1_1.dart';
import 'package:treasure_map/d_play/d1_2.dart';
import 'package:treasure_map/d_play/d2.dart';
import 'package:treasure_map/d_play/d3_1.dart';
import 'package:treasure_map/d_play/d3_2.dart';
import 'package:treasure_map/d_play/d3_7.dart';
import 'package:treasure_map/d_play/d4.dart';
import 'package:treasure_map/d_play/d5_1.dart';
import 'package:treasure_map/d_play/d5_2.dart';
import 'package:treasure_map/d_play/d5_3.dart';
import 'package:treasure_map/d_play/d5_4.dart';
import 'package:treasure_map/d_play/d6.dart';
import 'package:treasure_map/d_play/d7_1.dart';
import 'package:treasure_map/d_play/d7_2.dart';
import 'package:treasure_map/d_play/d8_1.dart';
import 'package:treasure_map/d_play/d8_2.dart';
import 'package:treasure_map/d_play/d9.dart';
import 'package:treasure_map/d_play/d10.dart';
import 'package:treasure_map/provider/app_management.dart';
import 'package:treasure_map/widgets/api.dart';
import 'package:treasure_map/widgets/menu_bar.dart';

import 'api/admin.dart';

class IPlay extends StatefulWidget {
  static int nowPageNumber = 0;

  const IPlay({
    Key? key,
    this.pageNumber = 0,
  }) : super(key: key);
  final int pageNumber;
  @override
  State<IPlay> createState() => _IPlayState();
}

class _IPlayState extends State<IPlay> {
  final autoLoginStorage = const FlutterSecureStorage();
  GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>(); //appbar없는 menubar용
  Widget rightPage = Container();

  var tabNameList = [
    "sign",
    "annualPlan",
    "record",
    "dayRecord",
    //"dayRecordExecutionAndPlanning",
    "weekRecord",
    //"weekRecordPlanning",
    "notices",
    "playFlow",
    "portfolioList",
    "nuri",
    "lifeRecord"
  ];
  @override
  void changePage(int clickPage) {
    setState(() {
      IPlay.nowPageNumber = clickPage;
      rightPage = playTabLink(IPlay.nowPageNumber);
    });
  }

  void routhPage(Widget routhPage){
    setState(() {
      rightPage = routhPage;
    });
  }

  @override
  void initState() {

    // TODO: implement initState
    super.initState();
    getDate();
    // IPlay.nowPageNumber = widget.pageNumber;
    // rightPage = playTabLink(IPlay.nowPageNumber);
  }

  void nextPage() {
    if (IPlay.nowPageNumber == 9) {
      return;
    }
    setState(() {
      IPlay.nowPageNumber++;
      rightPage = playTabLink(IPlay.nowPageNumber);
    });
  }

  void prePage() {
    if (IPlay.nowPageNumber == 0) {
      return;
    }
    setState(() {
      IPlay.nowPageNumber--;
      rightPage = playTabLink(IPlay.nowPageNumber);
    });
  }

  var scheduleYearData;
  getDate() async{
    ApiUrl apiUrl = ApiUrl();
    http.Response scheduleYearRes =
    await api(apiUrl.schedule + '/' + Provider.of<UserInfo>(context, listen: false).value[0].toString(), 'get', 'signInToken', {}, context);
    if (scheduleYearRes.statusCode == 200) {
      var scheduleYearRB = utf8.decode(scheduleYearRes.bodyBytes);
      setState(() {
        scheduleYearData = jsonDecode(scheduleYearRB);
        IPlay.nowPageNumber = widget.pageNumber;
        rightPage = playTabLink(IPlay.nowPageNumber);
      });
    }
  }




  playTabLink(int _nowPage) {
    var playTabLinkList = [
      Provider.of<UserInfo>(context,listen : false).role == 'teacher'?
      D1_2(nextPage: nextPage, prePage: prePage, nowPage : tabNameList[IPlay.nowPageNumber],scaffoldKey: _scaffoldState, scheduleYearData: scheduleYearData, routhPage: routhPage, changePage: changePage):
      D1_1(nextPage: nextPage, prePage: prePage, nowPage : tabNameList[IPlay.nowPageNumber],scaffoldKey: _scaffoldState, scheduleYearData: scheduleYearData, routhPage: routhPage, changePage: changePage),
      D2(nextPage: nextPage, prePage: prePage, nowPage : tabNameList[IPlay.nowPageNumber],scaffoldKey: _scaffoldState,),
      D3_7(nextPage: nextPage, prePage: prePage, nowPage : tabNameList[IPlay.nowPageNumber], routhPage: routhPage,scaffoldKey: _scaffoldState, scheduleYearData: scheduleYearData, changePage: changePage),
      // D3_1(nextPage: nextPage, prePage: prePage, nowPage : tabNameList[IPlay.nowPageNumber],scaffoldKey: _scaffoldState,),
      // D3_2(nextPage: nextPage, prePage: prePage, nowPage : tabNameList[IPlay.nowPageNumber],scaffoldKey: _scaffoldState,),
      D4(nextPage: nextPage, prePage: prePage, nowPage : tabNameList[IPlay.nowPageNumber],scaffoldKey: _scaffoldState,),
      D5_2(nextPage: nextPage, prePage: prePage, nowPage : tabNameList[IPlay.nowPageNumber],scaffoldKey: _scaffoldState,),
      // D5_2(nextPage: nextPage, prePage: prePage, nowPage : tabNameList[IPlay.nowPageNumber],scaffoldKey: _scaffoldState,),
      // D5_3(nextPage: nextPage, prePage: prePage, nowPage : tabNameList[IPlay.nowPageNumber],scaffoldKey: _scaffoldState,),
      // D5_4(nextPage: nextPage, prePage: prePage, nowPage : tabNameList[IPlay.nowPageNumber],scaffoldKey: _scaffoldState,),
      D6(nextPage: nextPage, prePage: prePage, nowPage : tabNameList[IPlay.nowPageNumber],scaffoldKey: _scaffoldState, scheduleYearData: scheduleYearData,),
      D7_1(nextPage: nextPage, prePage: prePage, nowPage : tabNameList[IPlay.nowPageNumber],scaffoldKey: _scaffoldState,routhPage: routhPage,),
      // D7_2(nextPage: nextPage, prePage: prePage, nowPage : tabNameList[IPlay.nowPageNumber],scaffoldKey: _scaffoldState,),
      D8_1(nextPage: nextPage, prePage: prePage, nowPage : tabNameList[IPlay.nowPageNumber],scaffoldKey: _scaffoldState,routhPage: routhPage,),
      // D8_2(nextPage: nextPage, prePage: prePage, nowPage : tabNameList[IPlay.nowPageNumber],scaffoldKey: _scaffoldState,),
      D9(nextPage: nextPage, prePage: prePage, nowPage : tabNameList[IPlay.nowPageNumber],scaffoldKey: _scaffoldState, scheduleYearData: scheduleYearData),
      D10(nextPage: nextPage, prePage: prePage, nowPage : tabNameList[IPlay.nowPageNumber],scaffoldKey: _scaffoldState,)
    ];
    return (playTabLinkList[_nowPage]);
  }

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
        key: _scaffoldState,
        backgroundColor: Colors.blue,
        endDrawer: MenuDrawer(),
        body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomLeft,
            colors: [
              Color(0xffA665FB),
              Color(0xff7744BA),
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
                  child: rightPage)
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
  ListView iPlayListView = ListView();
  var iconColorPathList = [
    'assets/icons/icon_sign_color.svg',
    'assets/icons/icon_annual_plan_color.svg',
    'assets/icons/icon_record_color.svg',
    'assets/icons/icon_day_record_color.svg',
    'assets/icons/icon_week_record_color.svg',
    'assets/icons/icon_notices_color.svg',
    'assets/icons/icon_play_flow_color.svg',
    'assets/icons/icon_portfolio_color.svg',
    'assets/icons/icon_nuri_color.svg',
    'assets/icons/icon_life_record.svg'
  ];
  var iconGrayPathList = [
    'assets/icons/icon_sign_gray.svg',
    'assets/icons/icon_annual_plan_gray.svg',
    'assets/icons/icon_record_gray.svg',
    'assets/icons/icon_day_record_gray.svg',
    'assets/icons/icon_week_record_gray.svg',
    'assets/icons/icon_notices_gray.svg',
    'assets/icons/icon_play_flow_gray.svg',
    'assets/icons/icon_portfolio_gray.svg',
    'assets/icons/icon_nuri_gray.svg',
    'assets/icons/icon_life_record_gray.svg'
  ];
  var iconNameList = [
    "sign",
    "annualPlan",
    "record",
    "dayRecord",
    "weekRecord",
    "notices",
    "playFlow",
    "portfolio",
    "nuri",
    "lifeRecord"
  ];

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
    behavior: const ScrollBehavior().copyWith(overscroll: false),
    child: ListView(
      padding: EdgeInsets.zero,
    physics: const RangeMaintainingScrollPhysics(),
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 10.w, bottom: 10.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                for (int i = 0; i < iconColorPathList.length; i++)
                  if (i == IPlay.nowPageNumber) ...[
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
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: 12.w),
                          ).tr(),
                        ],
                      ),
                    ),
                  ] else if (i != IPlay.nowPageNumber) ...[
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
                                color: Colors.white,
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
