
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:treasure_map/e_growth/atti/atti1.dart';
import 'package:treasure_map/e_growth/atti/report/atti_a.dart';
import 'package:treasure_map/e_growth/atti/report/atti_c.dart';
import 'package:treasure_map/e_growth/atti/report/atti_d.dart';
import 'package:treasure_map/e_growth/atti/report/atti_e.dart';
import 'package:treasure_map/e_growth/atti/report/atti_f.dart';
import 'package:treasure_map/e_growth/atti/report/atti_g.dart';
import 'package:treasure_map/e_growth/atti/report/atti_h.dart';
import 'package:treasure_map/e_growth/atti/report/home_1.dart';
import 'package:treasure_map/widgets/custom_page_route.dart';

class Atti5 extends StatefulWidget {
  const Atti5({Key? key,
    this.nowPage = 0,
  }) : super(key: key);
  final int nowPage;

  @override
  State<Atti5> createState() => _Atti5State();
}

class _Atti5State extends State<Atti5> {

  late AnimationController controller;
  int nowPage = 0;
  var tabNameList = [
    "홈",
    "또래관계 분석현황",
    "좋아하는 친구들",
    "연결 및 영향 수준",
    "우리반 또래관계도",
    "우리반 또래인기도",
    "사회적 지위 분포도",
    "싫어하는 네트워크"
  ];
  ani(Widget _widget){
    setState(() {
      AnimatedPositioned(
        duration : Duration( milliseconds: 1000),
        child: pageWidget = _widget,
      );
    });
  }

  changeScreen(Widget _widget){
    setState(() {
      pageWidget = _widget;
    });
  }
  changeScreen2(Widget _widget){
    setState(() {

      pageWidget = _widget;
      CustomPageRoute(child: pageWidget, direction: AxisDirection.left);

      // ani(_widget);
    });
  }

  Widget pageWidget = Home_1();


  reportTabLink(int _nowPage){
    var reportTabLinkList = [
      // Home_1(nowPage: nowPage, changeScreen: changeScreen,),
      // Home_2(nowPage: nowPage, changeScreen: changeScreen,),
      // Home_3(nowPage: nowPage),
      // Home_4(nowPage: nowPage, changeScreen: changeScreen,),
      // Home_5(nowPage: nowPage, changeScreen: changeScreen,),
      // Home_6(nowPage: nowPage, changeScreen: changeScreen,),
      // Home_7(nowPage: nowPage, changeScreen: changeScreen,),
      // Home_8(nowPage: nowPage, changeScreen: changeScreen,),
      // Home_9(nowPage: nowPage, changeScreen: changeScreen,),
      // Home_10(nowPage: nowPage, changeScreen: changeScreen,),
      // Home_11(nowPage: nowPage, changeScreen: changeScreen,)
      AttiA(changeScreen: changeScreen,),
      AttiC(changeScreen: changeScreen,),
      AttiD(changeScreen: changeScreen,),
      AttiE(changeScreen: changeScreen, ),
      AttiF(changeScreen: changeScreen, ),
      AttiG(changeScreen: changeScreen,),
      AttiH(changeScreen: changeScreen, )
    ];
    return(reportTabLinkList[_nowPage]);
  }

  void changePage(int clickPage) {
    setState(() {
      nowPage = clickPage;
      changeScreen(reportTabLink(nowPage));
    });
  }

  @override
  void initState() {
    // surveyedCheck();
    nowPage = widget.nowPage;

    pageWidget = reportTabLink(nowPage);

    // TODO: implement initState
    super.initState();
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
        backgroundColor: Colors.white,
        body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomLeft,
                colors: [
                  Color(0xffBDEBB7),
                  Color(0xff71D882),
                ],
              )),
          child: Row(
            children: [
              Flexible(
                flex: 1,
                child: AttiReportTabIcon(nowPage: nowPage, changePage: changePage,),
              ),
              Flexible(
                flex: 10,
                child: pageWidget,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class AttiReportTabIcon extends StatefulWidget {
  const AttiReportTabIcon({
    Key? key,
  required this.changePage,
  required this.nowPage,
  }) : super(key: key);
  final Function(int) changePage;
  final int nowPage;

  @override
  State<AttiReportTabIcon> createState() => _AttiReportTabIconState();
}

class _AttiReportTabIconState extends State<AttiReportTabIcon> {
  ListView AttiReportListView = ListView();

  var iconColorPathList = [
    // 'assets/icons/atti/atti_home_color_icon.svg',
    'assets/icons/atti/atti_find_color_icon.svg',
    'assets/icons/atti/atti_heart_color_icon.svg',
    'assets/icons/atti/atti_connect_color_icon.svg',
    'assets/icons/atti/atti_relationship_color_icon.svg',
    'assets/icons/atti/atti_popularity_color_icon.svg',
    'assets/icons/atti/atti_rank_color_icon.svg',
    'assets/icons/atti/atti_hate_color_icon.svg',
  ];
  var iconGrayPathList = [
    // 'assets/icons/atti/atti_home_icon.svg',
    'assets/icons/atti/atti_find_icon.svg',
    'assets/icons/atti/atti_heart_icon.svg',
    'assets/icons/atti/atti_connect_icon.svg',
    'assets/icons/atti/atti_relationship_icon.svg',
    'assets/icons/atti/atti_popularity_icon.svg',
    'assets/icons/atti/atti_rank_icon.svg',
    'assets/icons/atti/atti_hate_icon.svg',
  ];
  var iconNameList = [
    // "홈",
    "또래관계 분석현황",
    "좋아하는 친구들",
    "연결 및 영향 수준",
    "우리반 또래관계도",
    "우리반 또래인기도",
    "사회적 지위 분포도",
    "싫어하는 네트워크"
  ];

  @override
  Widget build(BuildContext context) {
    return
       ScrollConfiguration(
    behavior: const ScrollBehavior().copyWith(overscroll: false),
    child: ListView(
    physics: const RangeMaintainingScrollPhysics(),
        children: [
          Container(
            padding: EdgeInsets.only(top: 10.w, bottom: 10.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.only(top: 10.w, bottom: 10.w),
                  child: Column(
                    children: [
                      IconButton(onPressed: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Atti1()),
                        );
                        // widget.changePage(i);
                      },
                        icon: SvgPicture.asset('assets/icons/atti/atti_home_icon.svg'),
                        iconSize: 35.w,),
                      Text(
                        '홈',
                        style: TextStyle(
                          color: Color(0xff6E6E6E),
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    ],
                  ),
                ),
                for(int i = 0; i<iconColorPathList.length; i++)

                    Container(
                      padding: EdgeInsets.only(top: 10.w, bottom: 10.w),
                      child: Column(
                        children: [
                          widget.nowPage == i ?
                          IconButton(onPressed: (){
                            widget.changePage(i);
                          },
                              icon: SvgPicture.asset(iconColorPathList[i]),
                          iconSize: 35.w,):
                          IconButton(onPressed: (){
                            widget.changePage(i);
                          },
                            icon: SvgPicture.asset(iconGrayPathList[i]),
                            iconSize: 35.w,),
                          Text(
                            iconNameList[i],
                            style: TextStyle(
                              color: Color(0xff6E6E6E),
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          )

                        ],
                      ),
                    )

              ],
            ),
          )
        ],
    ),
      );
  }
}
