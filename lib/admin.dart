import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:treasure_map/b_admin/b7_2.dart';
import 'package:treasure_map/widgets/api.dart';
import 'package:treasure_map/widgets/login_route.dart';
import 'package:treasure_map/widgets/menu_bar.dart';
import 'b_admin/b4.dart';

import 'b_admin/b15.dart';
import 'b_admin/b15_1.dart';
import 'b_admin/b16.dart';

import 'b_admin/b2_1_basic.dart';
import 'b_admin/b3.dart';
import 'b_admin/b5_1.dart';
import 'b_admin/b6_1.dart';
import 'b_admin/b14.dart';
import 'b_admin/b7_1.dart';
import 'b_admin/b8_1.dart';
import 'b_admin/b9.dart';
import 'provider/app_management.dart';

import 'package:provider/provider.dart';

const autoLoginStorage = FlutterSecureStorage();

class AdminPage extends StatefulWidget {
  static int nowMenuNumber = 0;

  const AdminPage({Key? key}) : super(key: key);

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  FocusNode focusNode = FocusNode();
  FocusNode focusNode2 = FocusNode();
  FocusNode b16TextFocus = FocusNode();
  double boxHeight = 0;
  double boxYPosition = 0;
  String name = '';
  String address = '';
  String phoneNumber = '';
  String director = '';
  String directorPhoneNumber = '';

  int schoolYear = 0;
  ApiUrl apiUrl = ApiUrl();

  getKindergartenInfo() async {
    http.Response res = await api(apiUrl.kindergarten, 'get', 'adminToken', {}, context);
    if(res.statusCode == 200){
      var resRB = utf8.decode(res.bodyBytes);
      var data = jsonDecode(resRB);
      setState(() {
        name = data['name'];
        directorPhoneNumber = data['directorPhoneNumber'];
        address = data['address'];
        phoneNumber = data['phoneNumber'];
        director = data['director'];
      });
      adminTabMake();
    }
  }

  void changePage(int clickPage) {
    setState(() {
      AdminPage.nowMenuNumber = clickPage;
    });
  }

  void pageSizeUpdate(double _boxHeight, double _boxYPosition) {
    setState(() {

      boxHeight = _boxHeight;
      boxYPosition = _boxYPosition;
    });
  }

  schoolYearSetting(int _value) {
    setState(() {
      schoolYear = schoolYear + _value;
      adminTabMake();
    });
  }
  List<Widget> adminTabLinkList =[Container()];

  adminTabMake(){
    adminTabLinkList.clear();
    adminTabLinkList.add(B2_1_Basic(
      notifyParent: pageSizeUpdate,
      name: name,
      director: director,
      directorPhoneNumber: directorPhoneNumber,
      address: address,
      phoneNumber: phoneNumber,
    ));
    //아이좋아 서비스 구매
    if (Provider.of<UserInfo>(context, listen: false).auth.split('')[5] ==
        "1") {
      adminTabLinkList.add(B3(notifyParent: pageSizeUpdate));
    }
    //권한부여 및 삭제
    if (Provider.of<UserInfo>(context, listen: false).role == 'director') {
      adminTabLinkList.add(B4(notifyParent: pageSizeUpdate));
    }
    //학사정보
    adminTabLinkList
        .add(Provider.of<UserInfo>(context, listen: false).role == 'director'||
        Provider.of<UserInfo>(context, listen: false).auth.split('')[2] ==
            "1"
        ? B15(
      notifyParent: pageSizeUpdate,
      schoolYear: schoolYear,
      schoolYearSetting: schoolYearSetting,
    )
        : B15_1(
      notifyParent: pageSizeUpdate,
      schoolYear: schoolYear,
      schoolYearSetting: schoolYearSetting,
    ));
    //기관정보
    if (Provider.of<UserInfo>(context, listen: false).role == 'director' ||
        Provider.of<UserInfo>(context, listen: false).auth.split('')[2] ==
            "1") {
      adminTabLinkList.add(B16(
        notifyParent: pageSizeUpdate,
        b16TextFocus: b16TextFocus,
      ));
    }
    //학급정보
    if (Provider.of<UserInfo>(context, listen: false).auth.split('')[0] ==
        "1") {
      adminTabLinkList.add(B5_1(
        notifyParent: pageSizeUpdate,
        schoolYear: schoolYear,
        schoolYearSetting: schoolYearSetting,
      ));
    }
    //교사정보
    if (Provider.of<UserInfo>(context, listen: false).auth.split('')[3] ==
        "1") {
      adminTabLinkList.add(B6_1(
        notifyParent: pageSizeUpdate,
        schoolYear: schoolYear,
        schoolYearSetting: schoolYearSetting,
      ));
    }
    //영유아정보
    if (Provider.of<UserInfo>(context, listen: false).auth.split('')[4] ==
        "1") {
      adminTabLinkList.add(B7_1(
        notifyParent: pageSizeUpdate,
        schoolYear: schoolYear,
        schoolYearSetting: schoolYearSetting,
      ));
    }
    //우리반정보
    if (Provider.of<UserInfo>(context, listen: false).value[0] !=
        0 && Provider.of<UserInfo>(context, listen: false).role == 'teacher') {
      adminTabLinkList.add(B7_2(
        notifyParent: pageSizeUpdate,
        schoolYear: schoolYear,
        schoolYearSetting: schoolYearSetting,
      ));
    }
    //학부모정보
    if (Provider.of<UserInfo>(context, listen: false).auth.split('')[1] ==
        "1") {
      adminTabLinkList.add(B8_1(notifyParent: pageSizeUpdate));
    }
    //알림기록
    adminTabLinkList.add(B14(notifyParent: pageSizeUpdate)); //계정정보);
    //문의하기
    if (Provider.of<UserInfo>(context, listen: false).auth.split('')[6] ==
        "1") {
      adminTabLinkList.add(B9(
        notifyParent: pageSizeUpdate,
        textFieldFocusNode: focusNode,
        textFieldFocusNode2: focusNode2,
      ));
    }
  }

  getScheduleYear() async{
    await getScheduleYears(context);
    setState(() {
      schoolYear = Provider.of<UserInfo>(context, listen: false)
          .schoolYears.last;
    });
  }


  @override
  initState() {
    getScheduleYear();

    AdminPage.nowMenuNumber = 0;
    focusNode.addListener(_onFocusChange);
    focusNode2.addListener(_onFocusChange);
    getKindergartenInfo();



    // DateTime schoolYearSet = DateTime.now();
    // if (DateTime.utc(schoolYearSet.year, 3, 1).compareTo(schoolYearSet) > 0) {
    //   schoolYear = schoolYearSet.year - 1;
    // } else {
    //   schoolYear = schoolYearSet.year;
    // }


    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    focusNode.removeListener(_onFocusChange);
    focusNode2.removeListener(_onFocusChange);
    focusNode.dispose();
    focusNode2.dispose();
    b16TextFocus.removeListener(_onFocusChange);
    b16TextFocus.dispose();
  }

  void _onFocusChange() {
    debugPrint("Focus: ${focusNode.hasFocus.toString()}");
  }

  // _afterLayout(_) {
  //   mediaHeight = MediaQuery.of(context).size.height;
  //   mediaPaddingTop = MediaQuery.of(context).padding.top;
  // }
  //
  // double mediaHeight = 0;
  // double mediaPaddingTop = 0;

  @override
  Widget build(BuildContext context) {
    //MediaQuery 쓰지 말것 키보드가 올라오면서 재빌드를 하기 때문에 키보드가 다시 내려감

    // WidgetsBinding.instance.addPostFrameCallback(_afterLayout);
    GlobalKey<ScaffoldState> _scaffoldState =
        GlobalKey<ScaffoldState>(); //appbar없는 menubar용
    return GestureDetector(
      onTap: () {
        // FocusScopeNode currentFocus = FocusScope.of(context);
        // if (!currentFocus.hasPrimaryFocus) {
        //   currentFocus.unfocus();
        // }

        if (AdminPage.nowMenuNumber == 10) {
          focusNode.unfocus();
          focusNode2.unfocus();
        } else if (AdminPage.nowMenuNumber == 4) {
          b16TextFocus.unfocus();
        }
      },
      child: Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: const Color(0xFFFCF9F4),
          key: _scaffoldState,
          endDrawer: const MenuDrawer(),
          body: ScrollConfiguration(
            behavior: const ScrollBehavior().copyWith(overscroll: false),
            child: ListView(
              padding: EdgeInsets.zero,
              physics: const RangeMaintainingScrollPhysics(),
              children: [
                Row(
                  //전체 배경 Row
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 790.h,
                      child: Column(
                        //회사로고, 계정정보
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                width: 36.w,
                              ),
                              Column(
                                children: [
                                  SizedBox(
                                    height: 40.w,
                                  ),
                                  Container(
                                    //회사로고, 계정정보
                                    color: Colors.transparent,
                                    width: 177.51.w,
                                    child: Center(
                                        child: GestureDetector(
                                      onTap: () {
                                        loginRoute(
                                            context,
                                            Provider.of<UserInfo>(context,
                                                    listen: false)
                                                .role);
                                      },
                                      child: SvgPicture.asset(
                                        'assets/logo/full_orange.svg',
                                        height: 59.w,
                                      ),
                                    )),
                                  ),
                                  SizedBox(height: 27.w),
                                ],
                              ),
                            ],
                          ),
                          Expanded(
                            child: Container(
                                width: 250.w,
                                // height: 630.h,
                                //margin: EdgeInsets.only(top: 35.w),
                                // padding: EdgeInsets.only(bottom: 45.w),
                                decoration:  BoxDecoration(
                                  color: Color(0xFFFED796),
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(30.w),
                                      topRight: Radius.circular(30.w)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color(0x29aaaaaa),
                                      blurRadius: 6,
                                      offset: Offset(
                                          4, 2), // changes position of shadow
                                    ),
                                  ],
                                ),
                                child: Padding(
                                  padding: EdgeInsets.only(top: 15.w),
                                  child: ListViewInfo(notifyParent: changePage),
                                )),
                          )
                        ],
                      ),
                    ),
                    // Container(width: 47.w),
                    Column(
                      //우측 정보창
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          //메뉴바
                          //color: Colors.red,
                          margin: EdgeInsets.fromLTRB(
                              910.w, 40.w, 0.w, 0.w),
                          child: IconButton(
                              onPressed: () {
                                _scaffoldState.currentState?.openEndDrawer();
                              },
                              icon: SvgPicture.asset(
                                  './assets/icons/icon_menu.svg',
                                  width: 33.w,
                                  height: 27.8.w)),
                        ),
                        adminTabLinkList[AdminPage.nowMenuNumber],
                        // adminTabLink(pageSizeUpdate, AdminPage.nowMenuNumber),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          )),
    );
  }
}

//사용자에 따라 다른 listview
class ListViewInfo extends StatefulWidget {
  const ListViewInfo({Key? key, required this.notifyParent}) : super(key: key);
  final Function(int)? notifyParent;

  @override
  State<ListViewInfo> createState() => _ListViewInfoState();
}

class _ListViewInfoState extends State<ListViewInfo> {
  ListView infoListView = ListView();
  var menuListSuper = [];

  @override
  void initState() {
    //계정정보
    menuListSuper.add('계정정보');

    //아이좋아 서비스 구매
    if (Provider.of<UserInfo>(context, listen: false).auth.split('')[5] ==
        "1") {
      menuListSuper.add('아이좋아 서비스 구매');
    }
    //권한부여 및 삭제
    if (Provider.of<UserInfo>(context, listen: false).role == 'director') {
      menuListSuper.add('권한부여 및 삭제');
    }
    //학사정보
    menuListSuper.add('학사정보');

    //기관정보
    if (Provider.of<UserInfo>(context, listen: false).role == 'director' ||
        Provider.of<UserInfo>(context, listen: false).auth.split('')[2] ==
            "1") {
      menuListSuper.add('기관정보');
    }
    //학급정보
    if (Provider.of<UserInfo>(context, listen: false).auth.split('')[0] ==
        "1") {
      menuListSuper.add('학급정보');
    }
    //교사정보
    if (Provider.of<UserInfo>(context, listen: false).auth.split('')[3] ==
        "1") {
      menuListSuper.add('교사정보');
    }
    //영유아정보
    if (Provider.of<UserInfo>(context, listen: false).auth.split('')[4] ==
        "1") {
      menuListSuper.add('영유아정보');
    }
    //우리반정보
    if ( Provider.of<UserInfo>(context, listen: false).value[0] !=
        0 && Provider.of<UserInfo>(context, listen: false).role == 'teacher') {
      menuListSuper.add('우리반정보');
    }

    //학부모정보
    if (Provider.of<UserInfo>(context, listen: false).auth.split('')[1] ==
        "1") {
      menuListSuper.add('학부모정보');
    }
    //알림기록
    menuListSuper.add('알림기록');
    //문의하기
    if (Provider.of<UserInfo>(context, listen: false).auth.split('')[6] ==
        "1") {
      menuListSuper.add('문의하기');
    }
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext contextMenuList) {
    return ScrollConfiguration(
      behavior: const ScrollBehavior().copyWith(overscroll: false),
      child: ListView(
        padding: EdgeInsets.zero,
        physics: const RangeMaintainingScrollPhysics(),
        children: <Widget>[
          Container(
            //color: Colors.white,
            // padding: EdgeInsets.only(top: 30.w, bottom: 31.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                for (int i = 0; i < menuListSuper.length; i++) ...[
                  if (i == AdminPage.nowMenuNumber) ...[
                    TextButton(
                      style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 17.5.w)),
                      onPressed: () async {
                        widget.notifyParent!(i);
                      },
                      child: Text(menuListSuper[i],
                          style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w900,
                              color: const Color(0xFF5C5C5C))),
                    )
                  ] else if (i != AdminPage.nowMenuNumber) ...[
                    TextButton(
                      style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 17.5.w)),
                      onPressed: () async {
                        widget.notifyParent!(i);
                      },
                      child: Text(menuListSuper[i],
                          style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF5C5C5C))),
                    )
                  ]
                ]
              ],
            ),
          )
        ],
      ),
    );
  }
}

class SchoolYearSettingWidget extends StatefulWidget {
  const SchoolYearSettingWidget({
    Key? key,
    required this.schoolYear,
    required this.schoolYearSetting,
    required this.getFunction,
  }) : super(key: key);
  final int schoolYear;
  final Function(int) schoolYearSetting;
  final dynamic getFunction;

  @override
  State<SchoolYearSettingWidget> createState() =>
      _SchoolYearSettingWidgetState();
}

class _SchoolYearSettingWidgetState extends State<SchoolYearSettingWidget> {
  var format = DateFormat('yyyy-MM-dd');

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 180.w,
        height: 40.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20.w)),
          color: Color(0xFFFED796),
        ),
        child: Row(
          children: [
            GestureDetector(
              onTap: () {
                widget.schoolYearSetting(-1);
                // getScheduleInfo(format.format(selectedDate));
                widget.getFunction;
              },
              child: Icon(
                Icons.arrow_left_outlined,
                size: 30.w,
              ),
            ),
            Spacer(),
            Container(
              color: Colors.white,
              child: Text(
                " " + widget.schoolYear.toString() + " 학년도 ",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 18.sp,
                  color: Color(0xff393838),
                ),
              ),
            ),
            Spacer(),
            GestureDetector(
              onTap: () {
                widget.schoolYearSetting(1);
                // getScheduleInfo(format.format(selectedDate));
                widget.getFunction;
              },
              child: Icon(
                Icons.arrow_right_outlined,
                size: 30.w,
              ),
            ),
          ],
        ));
  }
}

getScheduleYears(context) async {
  ApiUrl apiUrl = ApiUrl();
  http.Response res = await api(apiUrl.schedule, 'get', 'signInToken', {}, context);
  if(res.statusCode == 200){
      var responseBody = utf8.decode(res.bodyBytes);
      var list = jsonDecode(responseBody);
      Provider.of<UserInfo>(context, listen: false).schoolYears.clear();
      for (int i = 0; i < list['years'].length; i++) {
        Provider.of<UserInfo>(context, listen: false)
            .schoolYears
            .add(list['years'][i]);
      }
  }
  //
  // final url = Uri.parse(apiUrl.baseUrl + "/api/schedule");
  // Map<String, String> headers = Map();
  // final token = await autoLoginStorage.read(key: "signInToken");
  // headers['authorization'] = token!;
  // final response = await http.get(url, headers: headers);
  // if (response.statusCode != 200) {
  //   if (kReleaseMode) {
  //     if (response.statusCode == 409) {
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(builder: (context) => const SplashScreen()),
  //       );
  //     } else if (response.statusCode == 419) {
  //       tokenTimeOverPopUP(context);
  //     } else {}
  //   } else if (kDebugMode) {
  //     switch (response.statusCode) {
  //       case 409:
  //         Navigator.push(
  //           context,
  //           MaterialPageRoute(builder: (context) => const SplashScreen()),
  //         );
  //         break;
  //       case 419:
  //         tokenTimeOverPopUP(context);
  //         break;
  //       default:
  //         debugPrint(response.statusCode.toString());
  //         break;
  //     }
  //   }
  // } else {
  //   var responseBody = utf8.decode(response.bodyBytes);
  //   var list = jsonDecode(responseBody);
  //   Provider.of<UserInfo>(context, listen: false).schoolYears.clear();
  //   for (int i = 0; i < list['years'].length; i++) {
  //     Provider.of<UserInfo>(context, listen: false)
  //         .schoolYears
  //         .add(list['years'][i]);
  //   }
  // }
}
