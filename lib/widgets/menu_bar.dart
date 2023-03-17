import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:treasure_map/a_main/a7_2.dart';
import 'package:treasure_map/a_main/back_home.dart';
import 'package:treasure_map/environment.dart';
import 'package:treasure_map/play.dart';
import '../a_main/a1.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../a_main/a7_1.dart';
import '../activity.dart';
import '../admin.dart';
import '../b_admin/b1_4.dart';
import '../e_growth/atti/atti1.dart';
import '../grow.dart';
import '../provider/admin_info.dart';
import '../provider/app_management.dart';
import 'login_route.dart';

//Drawer
class MenuDrawer extends StatefulWidget {
  const MenuDrawer({Key? key}) : super(key: key);

  @override
  State<MenuDrawer> createState() => _MenuDrawerState();
}

class _MenuDrawerState extends State<MenuDrawer> {
  int nowPick = 0;

  menuBarPick(int _value){
    setState(() {
      nowPick = _value;
    });
  }

  List<String> tapNames = [
    "아이생활",
    "아이놀이",
    "아이발달",
    "아이교사",
    "아이부모",
    "아이환경",
    "계정관리",
  ];

  List<List<String>> subTitleName = [
    ['굿데이'],
    [],
    ['아띠맵'],
    ['굿노트'],
    [],
    ['보라보라'],
  ];

  List<List<String>> tapSubName = [
    [
      // '아이생활',
      '굿데이',
      // "출석",
      // "체온",
      // "감정",
      // "식사",
      // "낮잠",
      // "배변/구토",
      // "투약",
      // "안전구역",
      // "신장/체중",
      // "보고서",
    ],
    [
      // '아이놀이'
    ],
    [
      // "아이발달",
      "아띠맵",
    ],
    [
      '굿노트',
      // "문서결재",
      // "연간계획",
      // "관찰기록",
      // "하루일과",
      // "주간놀이",
      // "가정통신문",
      // "놀이흐름도",
      // "포트폴리오",
      // "누리과정분석",
      // "생활기록부",
    ],
    [
      // '아이부모'
    ],
    [
      // "아이환경"
    ],
    [
      // "계정관리"
    ]
  ];
  List<List<List<String>>> tapSubSubName = [
    [
      [
        "출석",
        "체온",
        "감정",
        "식사",
        "낮잠",
        "배변/구토",
        "투약",
        "안전구역",
        "신장/체중",
        "보고서",
      ],
    ],
    [[]],
    [[]],
    [
      [
        "문서결재",
        "연간계획",
        "관찰기록",
        "하루일과",
        "주간놀이",
        "가정통신문",
        "놀이흐름도",
        "포트폴리오",
        "누리과정분석",
        "생활기록부",
      ]
    ],
    [[]],
    [[]],
    [[]],
  ];
  List<List<Widget>> routh = [
    [
      IActivity(
        pageNumber: 0,
      ),
      IActivity(
        pageNumber: 1,
      ),
      IActivity(
        pageNumber: 2,
      ),
      IActivity(
        pageNumber: 3,
      ),
      IActivity(
        pageNumber: 4,
      ),
      IActivity(
        pageNumber: 5,
      ),
      IActivity(
        pageNumber: 6,
      ),
      IActivity(
        pageNumber: 7,
      ),
      IActivity(
        pageNumber: 8,
      ),
      IActivity(
        pageNumber: 9,
      ),
    ],
    [
      BackHome(),
    ],
    [
      IGrow(),
      Atti1(),
    ],
    [
      IPlay(
        pageNumber: 0,
      ),
      IPlay(
        pageNumber: 1,
      ),
      IPlay(
        pageNumber: 2,
      ),
      IPlay(
        pageNumber: 3,
      ),
      IPlay(
        pageNumber: 4,
      ),
      IPlay(
        pageNumber: 5,
      ),
      IPlay(
        pageNumber: 6,
      ),
      IPlay(
        pageNumber: 7,
      ),
      IPlay(
        pageNumber: 8,
      ),
      IPlay(
        pageNumber: 9,
      ),
    ],
    [
      BackHome(),
    ],
    [
      IEnvironment(),
    ],
    [
      AdminGateCheck(
        type: "PW",
      ),
    ]
  ];
  List<List<Widget>> expansionTileRoute = [
    [
      IActivity(
      pageNumber: 0,
    ),
    ],
    [],
    [Atti1(),],
    [   IPlay(
      pageNumber: 0,
    ),],
    [],
    [IEnvironment(),]
  ];

  List<List<DrawerExpansionTile>> subExpansionTile = [];
  List<List<List<ExpansionTileChild>>> expansionTileChild = [
    [
      [
        ExpansionTileChild(
          text: '출석',
          route: IActivity(
          pageNumber: 0,
        ),
          needClassId: true,
        ),
        ExpansionTileChild(text: '체온', route: IActivity(
          pageNumber: 1,
        ),
          needClassId: true,),
        ExpansionTileChild(text: '감정', route: IActivity(
          pageNumber: 2,
        ),
          needClassId: true,),
        ExpansionTileChild(text: '식사', route: IActivity(
          pageNumber: 3,
        ),
          needClassId: true,),
        ExpansionTileChild(text: '낮잠', route: IActivity(
          pageNumber: 4,
        ),
          needClassId: true,),
        ExpansionTileChild(text: '배변/구토', route: IActivity(
          pageNumber: 5,
        ),
          needClassId: true,),
        ExpansionTileChild(text: '투약', route: IActivity(
          pageNumber: 6,
        ),
          needClassId: true,),
        ExpansionTileChild(text: '안전구역', route: IActivity(
          pageNumber: 7,
        ),
          needClassId: true,),
        ExpansionTileChild(text: '신장/체중', route: IActivity(
          pageNumber: 8,
        ),
          needClassId: true,),
        ExpansionTileChild(text: '보고서', route: IActivity(
          pageNumber: 9,
        ),
          needClassId: true,),
      ]
    ],
    [[]],
    [[]],
    [[
      ExpansionTileChild(text: '문서결재', route:   IPlay(
        pageNumber: 0,
      ),
        needClassId: true,),
      ExpansionTileChild(text: '연간계획', route:   IPlay(
        pageNumber: 1,
      ),
        needClassId: true,),
      ExpansionTileChild(text: '관찰기록', route:   IPlay(
        pageNumber: 2,
      ),
        needClassId: true,),
      ExpansionTileChild(text: '하루일과', route:   IPlay(
        pageNumber: 3,
      ),
        needClassId: true,),
      ExpansionTileChild(text: '주간놀이', route:   IPlay(
        pageNumber: 4,
      ),
        needClassId: true,),
      ExpansionTileChild(text: '가정통신문', route:   IPlay(
        pageNumber: 5,
      ),
        needClassId: true,),
      ExpansionTileChild(text: '놀이흐름도', route:   IPlay(
        pageNumber: 6,
      ),
        needClassId: true,),
      ExpansionTileChild(text: '포트폴리오', route:   IPlay(
        pageNumber: 7,
      ),
        needClassId: true,),
      ExpansionTileChild(text: '누리과정분석', route:   IPlay(
        pageNumber: 8,
      ),
        needClassId: true,),
      ExpansionTileChild(text: '생활기록부', route:   IPlay(
        pageNumber: 9,
      ),
        needClassId: true,),
    ]],
    [[]],
    [[]],
  ];

  @override
  void initState() {
    // TODO: implement initState
    List<int> serviceList = [1,1,0,2,1,3];
    for(int i = 0; i< 6;i++){
      subExpansionTile.add([]);
      for(int j = 0; j< subTitleName[i].length;j++){
        if(Provider.of<UserInfo>(context, listen: false).service.split('')[serviceList[i]] == '0'){
          subExpansionTile[i].add(DrawerExpansionTile(title: subTitleName[i][j], childList: expansionTileChild[i][j], service: false,route: expansionTileRoute[i][j]), );
        }else{
          subExpansionTile[i].add(DrawerExpansionTile(title: subTitleName[i][j], childList: expansionTileChild[i][j], service: true, route: expansionTileRoute[i][j]));
        }
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // width: 305.w,
      child: Drawer(
        // width: 305.w,
        backgroundColor: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.w),
                  bottomLeft: Radius.circular(30.w)),
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: <Color>[
                    Color(0xFFFAE19F),
                    Color(0xFFFFC565),
                  ])),
          child: ScrollConfiguration(
            behavior: const ScrollBehavior().copyWith(overscroll: false),
            child: ListView(
              physics: const RangeMaintainingScrollPhysics(),
              padding: EdgeInsets.zero,
              children: <Widget>[
                Row(children: [
                  Container(
                    width: 70.w,
                    height: 90.w,
                    //profile
                    color: Colors.transparent,
                    // 사이즈확인용
                    margin: EdgeInsets.fromLTRB(34.w, 37.w, 0, 0),
                    child: context.read<AdminInfo>().adminFace,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        //email
                        margin: EdgeInsets.fromLTRB(20.w, 77.w, 0, 0),
                        child: Text(context.watch<AdminInfo>().email,
                            style: TextStyle(fontSize: 14.w)),
                      ),
                      Container(
                        //name
                        margin: EdgeInsets.fromLTRB(20.w, 10.w, 0, 0),
                        child: Text(context.watch<AdminInfo>().name,
                            style: TextStyle(fontSize: 14.w)),
                      )
                    ],
                  )
                ]),
                Container(
                  margin: EdgeInsets.fromLTRB(31.5.w, 37.98.w, 0, 0),
                  child: Row(
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          IconButton(
                              onPressed: () => debugPrint('find'), //검색
                              icon: SvgPicture.asset(
                                  './assets/icons/icon_find_mobile.svg',
                                  width: 150.w,
                                  height: 150.w)),
                          Container(
                              margin: EdgeInsets.only(top: 8.77.w),
                              child: Text('검색', style: TextStyle(fontSize: 16.w)))
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 45.03.w),
                        child: Column(
                          children: [
                            IconButton(
                                padding: const EdgeInsets.all(0.0),
                                onPressed: () => debugPrint('setting'),
                                icon: SvgPicture.asset(
                                    './assets/icons/icon_setting.svg',
                                    width: 40.w,
                                    height: 40.w)),
                            Container(
                                margin: EdgeInsets.only(top: 8.77.w),
                                child:
                                    Text('설정', style: TextStyle(fontSize: 16.w)))
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 45.w),
                        child: Column(
                          children: [
                            IconButton(
                                padding: const EdgeInsets.all(0.0),
                                onPressed: () {
                                  autoLoginStorage.delete(key: "id");
                                  autoLoginStorage.delete(key: "password");
                                  autoLoginStorage.delete(key: "signInToken");
                                  autoLoginStorage.delete(key: "adminToken");
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => const A1()),
                                      (route) => false);
                                },
                                icon: SvgPicture.asset(
                                    './assets/icons/icon_logout_mobile.svg',
                                    width: 38.61.w,
                                    height: 40.w)),
                            Container(
                                margin: EdgeInsets.only(top: 8.77.w),
                                child: Text('로그아웃',
                                    style: TextStyle(fontSize: 16.w)))
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 36.0.w,
                ),

                Row(
                  children: [
                    Container(
                      width: 138.w,
                      height: 440.w,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap:(){
                              loginRoute(context, Provider.of<UserInfo>(context, listen: false).role);
                            },
                            child: Text('홈',
                              style: TextStyle(
                              fontSize: 20.w,
                              fontWeight: FontWeight.w500,
                              color: Color(0xff9B9B9A),
                            ),),
                          ),
                          for(int i = 0; i< 6;i++)...[
                            GestureDetector(
                              onTap: (){
                                menuBarPick(i);
                              },
                              child: Text(tapNames[i],
                                style: TextStyle(
                                  fontSize: 20.w,
                                  fontWeight: FontWeight.w500,
                                  color: nowPick == i ? Color(0xff46423C) :Color(0xff9B9B9A),
                                ),),
                            ),
                          ],
                          GestureDetector(
                            onTap: (){
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>   AdminGateCheck(
                                        type: "PW",
                                      ),));

                            },
                            child: Text('계정관리',
                              style: TextStyle(
                                fontSize: 20.w,
                                fontWeight: FontWeight.w500,
                                color: Color(0xff9B9B9A),
                              ),),
                          ),

                        ],
                      ),
                    ),
                    Column(
                      children: [
                        SizedBox(
                          height: 44.w,
                        ),
                        Container(
                          width: 150.w,
                          height: 396.w,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(20.w)),
                          ),
                          child:   ScrollConfiguration(
                            behavior: const ScrollBehavior().copyWith(overscroll: false),
                            child: ListView(
                              padding: EdgeInsets.zero,
                                physics: const RangeMaintainingScrollPhysics(),
                            children: [
                              for(int i = 0; i< subExpansionTile[nowPick].length;i++)...[
                                subExpansionTile[nowPick][i],
                              ],
                              // SizedBox(height: 30.w,)
                            ],),),
                        )
                      ],
                    )
                  ],
                )

              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DrawerExpansionTile extends StatefulWidget {
  const DrawerExpansionTile({Key? key,
    required this.title,
    required this.childList,
    required this.service,
    this.route,
  }) : super(key: key);
  final String title;
  final List<ExpansionTileChild> childList;
  final bool service;
  final Widget? route;

  @override
  State<DrawerExpansionTile> createState() => _DrawerExpansionTileState();
}

//메뉴가 여러개 있을때를 테스트를 안함 추후에 추가해보고 크기 조절요망
class _DrawerExpansionTileState extends State<DrawerExpansionTile> {
  bool _customTileExpanded = false;
  @override
  Widget build(BuildContext context) {
    return widget.service ? widget.childList.isEmpty ?
    GestureDetector(
      onTap: (){
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => widget.route!));
      },
      child: Container(
        width: 150.w,
        height: 50.w,
        child: Padding(
          padding: EdgeInsets.only(left: 30.5.w, top: 18.w),
          child: Text(widget.title, style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 16.sp,
            color: const Color(0xffA666FB),
          ),),
        ),
      ),
    ):
    Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        title:
        Text(widget.title, style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 16.sp,
          color: const Color(0xffA666FB),
        ),),
        children: [
          for(int i = 0; i< widget.childList.length;i++)...[
            widget.childList[i],
          ]
        ],
          tilePadding: EdgeInsets.only(left: 30.5.w,right: 10.w),
          childrenPadding:EdgeInsets.only(bottom: 20.w),
          // expandedAlignment: Alignment.centerLeft
        trailing: Icon(
      _customTileExpanded
      ? Icons.arrow_drop_up
          : Icons.arrow_drop_down,
          color: const Color(0xffA666FB),
      ),
        onExpansionChanged: (bool expanded) {
          setState(() => _customTileExpanded = expanded);
        },
          // iconColor: Color(0xffA666FB),
          collapsedTextColor:const Color(0xffA666FB),
        // textColor: const Color(0xffA666FB),
          collapsedIconColor:const Color(0xffA666FB),
      ),

    ):Container(
      width: 150.w,
      height: 50.w,
      child: Padding(
        padding: EdgeInsets.only(left: 30.5.w, top: 18.w),
        child: Text(widget.title, style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 16.sp,
          color: const Color(0xff9B9B9A),
        ),),
      ),
    );
  }
}

class ExpansionTileChild extends StatefulWidget {
  const ExpansionTileChild({Key? key,
    required this.text,
    required this.route,
    this.needClassId = false,
  }) : super(key: key);
  final String text;
  final Widget route;
  final bool needClassId;

  @override
  State<ExpansionTileChild> createState() => _ExpansionTileChildState();
}

class _ExpansionTileChildState extends State<ExpansionTileChild> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32.w,
      child: ListTile(

        onTap:(){
          if (Provider.of<UserInfo>(context, listen: false).role ==
              'director') {
            if(widget.needClassId){
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          A7_2(nextPage: widget.route)));
            }else{
              Navigator.push(
              context,
              MaterialPageRoute(
              builder: (context) => widget.route));
              }
          }else if (Provider.of<UserInfo>(context, listen: false).role ==
              'viceDirector') {
            if(widget.needClassId){
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          A7_2(nextPage: widget.route)));
            }else{
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => widget.route));
            }
          }else{
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => widget.route));
          }
        },
        title: Row(
          children: [
            SizedBox(
              width: 16.w,
            ),
            Text(
              widget.text,
              style: TextStyle(
              fontSize: 12.sp,
              color: Color(0xff46423C),
            ),
              textAlign: TextAlign.start,
            ),
          ],
        ),
      ),
    );
  }
}


class ListTileTextStyle extends StatefulWidget {
  const ListTileTextStyle({
    Key? key,
    required this.text,
  }) : super(key: key);
  final String text;

  @override
  State<ListTileTextStyle> createState() => _ListTileTextStyleState();
}

class _ListTileTextStyleState extends State<ListTileTextStyle> {
  @override
  Widget build(BuildContext context) {
    return Text(
      widget.text,
      style: TextStyle(
          fontSize: 14.w,
          fontWeight: FontWeight.w400,
          color: Color(0xff46423C)),
    );
  }
}
