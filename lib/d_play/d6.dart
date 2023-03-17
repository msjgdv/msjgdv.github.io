import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:treasure_map/widgets/api.dart';
import 'package:treasure_map/widgets/calendar.dart';
import 'package:treasure_map/widgets/get_container_info.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:treasure_map/widgets/overtab.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../provider/app_management.dart';
import '../widgets/custom_container.dart';
import 'd3_1.dart';

class D6 extends StatefulWidget {
  const D6(
      {Key? key,
      required this.nextPage,
      required this.prePage,
      required this.nowPage,
      this.scaffoldKey,
      required this.scheduleYearData,
        this.pageTime,
      })
      : super(key: key);
  final Function nextPage;
  final Function prePage;
  final String nowPage;
  final GlobalKey<ScaffoldState>? scaffoldKey;
  final scheduleYearData;
  final DateTime? pageTime;

  @override
  State<D6> createState() => _D6State();
}

class _D6State extends State<D6> {
  bool dateOff = false;

  DateTime pageTime = DateTime.now();
  String pageTimeStr = '';

  int dateCategory = 0;
  int normalCategory = 0;

  double tableHeight = 0;
  List<Image?> signImage = [];
  var homeData;
  ApiUrl apiUrl = ApiUrl();
  addCategory(bool type){
    setState(() {
      if(type){
        dateCategory++;
      }else{
        normalCategory++;
      }
    });
  }

  getHomeData() async{
    http.Response homeRes = await api(apiUrl.home + '/' + pageTimeStr + '/' + Provider.of<UserInfo>(context, listen : false).value[0].toString(), 'get', 'signInToken', {}, context);
    if(homeRes.statusCode == 200){
      var homeRB = utf8.decode(homeRes.bodyBytes);
      setState(() {
        homeData = jsonDecode(homeRB);
      });
      double height = 0;
      height = (homeData['memos'].length * 60).toDouble();
      height = height + homeData['days'].length * 82;
      setState(() {
        tableHeight = height;
      });
      signImage.clear();

      if(homeData['teacherSign'] != null){
        signImage.add(await imageApi(homeData['teacherSign'], 'signInToken', context));
      }else{
        signImage.add(null);
      }
      if(homeData['viceDirectorSign'] != null){
        signImage.add(await imageApi(homeData['viceDirectorSign'], 'signInToken', context));
      }else{
        signImage.add(null);
      }
      if(homeData['directorSign'] != null){
        signImage.add(await imageApi(homeData['directorSign'], 'signInToken', context));
      }else{
        signImage.add(null);
      }
      setState(() {});
    }
  }

  patchSign() async {
    http.Response childRes =
    await api(apiUrl.homeSign, 'patch', 'signInToken', {
      'id': homeData['id'].toString(),
    }, context);
    if (childRes.statusCode == 200) {
      getHomeData();
    }
  }

  postHomeForm() async {
    http.Response weeklyRes = await api(apiUrl.home, 'post', 'signInToken', {
      'hid' : homeData['id'].toString(),
      'cid' : Provider.of<UserInfo>(context, listen : false).value[0].toString()
    }, context);
    if(weeklyRes.statusCode == 200){
      getHomeData();
    }
  }

  postMakeCategory(String type) async{
    http.Response? homeRes;
    if(type == 'day'){
      homeRes = await api(apiUrl.homeDay, 'post', 'signInToken', {
        'hid' : homeData['id'].toString(),
        'cid': Provider.of<UserInfo>(context, listen : false).value[0].toString(),
      }, context);
    }else{
      homeRes = await api(apiUrl.homeMemo, 'post', 'signInToken', {
        'hid' : homeData['id'].toString(),
        'cid': Provider.of<UserInfo>(context, listen : false).value[0].toString(),
      }, context);
    }


    if(homeRes!.statusCode == 200){
      getHomeData();
    }
  }



  receiveData(DateTime dateTime) async {
    pageTime = dateTime;
    var formatter = DateFormat('yyyyMMdd');
    pageTimeStr = formatter.format(pageTime);
    getHomeData();
    setState(() {});
  }

  @override
  initState() {
    if(widget.pageTime != null){
      pageTime = widget.pageTime!;
    }
    receiveData(pageTime);
    // getHomeData();
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
                        height: (160+tableHeight).w,
                        decoration: BoxDecoration(
                          color: const Color(0xffFCFCFC),
                        ),
                      ),
                      NewsLetterTable(
                        normalCategory: normalCategory,
                        dateCategory: dateCategory,
                        addCategory: addCategory,
                        homeData: homeData,
                        scheduleYearData: widget.scheduleYearData,
                        pageTime: pageTime,
                        getHomeData: getHomeData,
                        receiveData:receiveData,
                        tableHeight: tableHeight,
                        signImage: signImage,
                        patchSign: patchSign,
                      ),
                    ],
                  ),
                  Container(
                    width: 850.w,
                    height: 40.w,
                    color: Color(0xffFCFCFC),
                  ),

                  Row(
                    children: [
                      Container(
                        width: 39.w,
                        height: 50.w,
                        decoration: BoxDecoration(
                          color: const Color(0xffFCFCFC),
                        ),
                      ),
                      SizedBox(
                        width: 470.w,
                      ),
                      GestureDetector(
                        onTap: (){
                          postHomeForm();
                        },
                        child: Container(
                          width: 200.w,
                          height: 40.w,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(10.w)),
                              color: Color(0xffC6A2FC),
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0x29000000),
                                  blurRadius: 6,
                                  offset: Offset(0, 3),
                                )
                              ]),
                          child: Center(child: Text('직전 문서 양식 가져오기',
                            style: TextStyle(
                                color: Color(0xff7649B7),
                                fontWeight: FontWeight.w700,
                                fontSize: 14.sp
                            ),),),
                        ),
                      ),
                      SizedBox(
                        width: 40.w,
                      ),
                      GestureDetector(
                        onTap: () {
                          postMakeCategory('memo');
                        },
                        child: Container(
                          width: 150.w,
                          height: 40.w,
                          decoration: BoxDecoration(
                              borderRadius:
                              BorderRadius.all(Radius.circular(10.w)),
                              color: Color(0xffC6A2FC),
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0x29000000),
                                  blurRadius: 6,
                                  offset: Offset(0, 3),
                                )
                              ]),
                          child: Center(
                            child: Text(
                              '기본카테고리',
                              style: TextStyle(
                                  color: Color(0xff7649B7),
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14.sp),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 40.w,
                      ),
                      GestureDetector(
                        onTap: () {
                          postMakeCategory('day');
                        },
                        child: Container(
                          width: 150.w,
                          height: 40.w,
                          decoration: BoxDecoration(
                              borderRadius:
                              BorderRadius.all(Radius.circular(10.w)),
                              color: Color(0xffC6A2FC),
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0x29000000),
                                  blurRadius: 6,
                                  offset: Offset(0, 3),
                                )
                              ]),
                          child: Center(
                            child: Text(
                              '날짜카테고리',
                              style: TextStyle(
                                  color: Color(0xff7649B7),
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14.sp),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
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

class NewsLetterTable extends StatefulWidget {
  const NewsLetterTable({Key? key,
    required this.dateCategory,
    required this.normalCategory,
    required this.addCategory,
    required this.homeData,
    required this.scheduleYearData,
    required this.pageTime,
    required this.getHomeData,
    required this.receiveData,
    required this.tableHeight,
    required this.signImage,
    required this.patchSign,
  }) : super(key: key);
  final int normalCategory;
  final int dateCategory;
  final Function(bool) addCategory;
  final homeData;
  final scheduleYearData;
  final DateTime pageTime;
  final Function() getHomeData;
  final Function(DateTime) receiveData;
  final double tableHeight;
  final List<Image?> signImage;
  final Function() patchSign;
  @override
  State<NewsLetterTable> createState() => _NewsLetterTableState();
}

class _NewsLetterTableState extends State<NewsLetterTable> {
  Color borderColor = const Color(0x9dC13BFD);
  List<DateTime> date = [];
  List<String> holidays = [];
  changeDate(DateTime _date){
    widget.receiveData(_date);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    for(int i = 1 ; i< 6;i++){
      date.add(widget.pageTime.subtract(Duration(days: widget.pageTime.weekday - i)));
    }
  }

  @override
  Widget build(BuildContext context) {
    holidays.clear();
    if(widget.homeData != null){
      for(int i = 0; i< widget.homeData['holidays'].length;i++){
        holidays.add(widget.homeData['holidays'][i]['day']);
      }
    }
    return widget.homeData != null ? Container(
        width: 1053.w,
        height: (150 + widget.tableHeight).w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20.w)),
          boxShadow: [
            BoxShadow(
              color: Color(0x29B1B1B1),
              blurRadius: 6,
              offset: Offset(-2, 2),
            )
          ],
        ),
        child: Column(children: [
          Row(children: [
            CustomContainer(
              cBorderColor: borderColor,
              cTotalHeight: 50.w,
              cTotalWidth: 553.w,
              cBorderRadius: BorderRadius.only(topLeft: Radius.circular(20.w)),
              cInsideColor: Color(0xffCAACF2),
              cTopBorderWidth: 1.w,
              cLeftBorderWidth: 1.w,
              childWidget: Center(
                child: RecordTableTextStyle(
                  text: widget.scheduleYearData['year'].toString() + "년도 " +
                      Provider.of<UserInfo>(context, listen: false).value[1]+ ' ' +
                      Provider.of<UserInfo>(context, listen: false).value[2] + " 가정통신문 " +
                      widget.homeData['turn'].toString() + "호 ",
                  title: true,
                ),
              ),
            ),
            CustomContainer(
              cBorderColor: borderColor,
              cTotalHeight: 50.w,
              cTotalWidth: 500.w,
              cBorderRadius: BorderRadius.only(topRight: Radius.circular(20.w)),
              cInsideColor: Color(0xffE5D0FE),
              cTopBorderWidth: 1.w,
              cLeftBorderWidth: 1.w,
              cRightBorderWidth: 1.w,
              childWidget: Center(
                child: RecordTableTextStyle(
                  text: "결재",
                  title: true,
                ),
              ),
            ),
          ]),

          Row(
            children: [
              CustomContainer(
                cBorderColor: borderColor,
                cTotalHeight: 60.w,
                cTotalWidth: 93.w,
                cInsideColor: Color(0xffCAACF2),
                cTopBorderWidth: 1.w,
                cLeftBorderWidth: 1.w,
                  childWidget: Center(
                    child: RecordTableTextStyle(
                      text: "기간",
                      title: true,
                    ),
                  ),
              ),
              GestureDetector(
                onTap: (){
                  showDialog(context: context, builder: (BuildContext context){
                    return AijoaCalendar(changeDate: changeDate, nowDate: DateTime.now());
                  });
                },
                child: CustomContainer(
                  cBorderColor: borderColor,
                  cTotalHeight: 60.w,
                  cTotalWidth: 460.w,
                  cInsideColor: Color(0xffffffff),
                  cTopBorderWidth: 1.w,
                  cLeftBorderWidth: 1.w,
                  childWidget: Center(
                    child: RecordTableTextStyle(
                      text: widget.homeData['period'],
                      title: true,
                    ),
                  ),
                ),
              ),
              CustomContainer(
                cBorderColor: borderColor,
                cTotalHeight: 60.w,
                cTotalWidth: 86.w,
                cInsideColor: Color(0xffCAACF2),
                cTopBorderWidth: 1.w,
                cLeftBorderWidth: 1.w,
                childWidget: Center(
                  child: RecordTableTextStyle(
                    text: "교사",
                    title: true,
                  ),
                ),
              ),
              GestureDetector(
                onTap: (){
                  widget.patchSign();
                },
                child: CustomContainer(
                  cBorderColor: borderColor,
                  cTotalHeight: 60.w,
                  cTotalWidth: 80.w,
                  cInsideColor: Color(0xffffffff),
                  cTopBorderWidth: 1.w,
                  cLeftBorderWidth: 1.w,
                  childWidget: Center(
                    child: widget.signImage.isNotEmpty  ? widget.signImage[0] ?? Container() : Container(),
                  ),
                ),
              ),
              CustomContainer(
                cBorderColor: borderColor,
                cTotalHeight: 60.w,
                cTotalWidth: 86.w,
                cInsideColor: Color(0xffCAACF2),
                cTopBorderWidth: 1.w,
                cLeftBorderWidth: 1.w,
                childWidget: Center(
                  child: RecordTableTextStyle(
                    text: "원감",
                    title: true,
                  ),
                ),
              ),
              GestureDetector(
                onTap: (){
                  widget.patchSign();
                },
                child: CustomContainer(
                  cBorderColor: borderColor,
                  cTotalHeight: 60.w,
                  cTotalWidth: 81.w,
                  cInsideColor: Color(0xffffffff),
                  cTopBorderWidth: 1.w,
                  cLeftBorderWidth: 1.w,
                  childWidget: Center(
                    child: widget.signImage.length > 1  ? widget.signImage[1] ?? Container() : Container(),
                  ),
                ),
              ),
              CustomContainer(
                cBorderColor: borderColor,
                cTotalHeight: 60.w,
                cTotalWidth: 86.w,
                cInsideColor: Color(0xffCAACF2),
                cTopBorderWidth: 1.w,
                cLeftBorderWidth: 1.w,
                childWidget: Center(
                  child: RecordTableTextStyle(
                    text: "원장",
                    title: true,
                  ),
                ),
              ),
              GestureDetector(
                onTap: (){
                  widget.patchSign();
                },
                child: CustomContainer(
                  cBorderColor: borderColor,
                  cTotalHeight: 60.w,
                  cTotalWidth: 81.w,
                  cInsideColor: Color(0xffffffff),
                  cTopBorderWidth: 1.w,
                  cLeftBorderWidth: 1.w,
                  cRightBorderWidth: 1.w,
                  childWidget: Center(
                    child: widget.signImage.length > 2  ? widget.signImage[2] ?? Container() : Container(),
                  ),
                ),
              ),
            ],
          ),

          for(int i = 0; i< widget.homeData['memos'].length;i++)...[
            Row(
              children: [
                CustomContainer(
                  cBorderColor: borderColor,
                  cTotalHeight: 60.w,
                  cTotalWidth: 93.w,
                  cInsideColor: Color(0xffCAACF2),
                  cTopBorderWidth: 1.w,
                  cLeftBorderWidth: 1.w,
                  childWidget: Center(
                    child: HomeTextFieldStyle(value: widget.homeData['memos'][i]['name'] ?? '', rid: widget.homeData['id'], getHomeData: widget.getHomeData, mid: widget.homeData['memos'][i]['id'], type : 'name', delete: true,
                    ),
                  ),
                ),
                CustomContainer(
                  cBorderColor: borderColor,
                  cTotalHeight: 60.w,
                  cTotalWidth: 960.w,
                  cInsideColor: Color(0xffffffff),
                  cTopBorderWidth: 1.w,
                  cLeftBorderWidth: 1.w,
                  cRightBorderWidth: 1.w,
                  childWidget: Center(
                    child: HomeTextFieldStyle(value: widget.homeData['memos'][i]['comment'] ?? '', rid: widget.homeData['id'], getHomeData: widget.getHomeData,mid: widget.homeData['memos'][i]['id'], type : 'comment',
                    ),
                  ),
                ),
              ],
            ),

          ],


          Row(
            children: [
              CustomContainer(
                cBorderColor: borderColor,
                cTotalHeight: 40.w,
                cTotalWidth: 93.w,
                cInsideColor: Color(0xffCAACF2),
                cTopBorderWidth: 1.w,
                cLeftBorderWidth: 1.w,
                cBorderRadius: widget.homeData['days'].length == 0 ? BorderRadius.only(bottomLeft: Radius.circular(20.w)): BorderRadius.zero,
                childWidget: Center(
                  child: RecordTableTextStyle(
                    text: "날짜/요일",
                    title: true,
                  ),
                ),
              ),

              CustomContainer(
                cBorderColor: borderColor,
                cTotalHeight: 40.w,
                cTotalWidth: 192.w,
                cInsideColor: Color(0xffCAACF2),
                cTopBorderWidth: 1.w,
                cLeftBorderWidth: 1.w,
                childWidget: Center(
                  child: RecordTableTextStyle(
                    text: date[0].day.toString() + '일 (월)',
                    title: true,
                    holiday: holidays.indexWhere((week) => week == '월요일') == -1 ? false : true,
                  ),
                ),
              ),
              CustomContainer(
                cBorderColor: borderColor,
                cTotalHeight: 40.w,
                cTotalWidth: 192.w,
                cInsideColor: Color(0xffCAACF2),
                cTopBorderWidth: 1.w,
                cLeftBorderWidth: 1.w,
                childWidget: Center(
                  child: RecordTableTextStyle(
                    text: date[1].day.toString() + '일 (화)',
                    title: true,
                    holiday: holidays.indexWhere((week) => week == '화요일') == -1 ? false : true,
                  ),
                ),
              ),
              CustomContainer(
                cBorderColor: borderColor,
                cTotalHeight: 40.w,
                cTotalWidth: 192.w,
                cInsideColor: Color(0xffCAACF2),
                cTopBorderWidth: 1.w,
                cLeftBorderWidth: 1.w,
                childWidget: Center(
                  child: RecordTableTextStyle(
                    text: date[2].day.toString() + '일 (수)',
                    title: true,
                    holiday: holidays.indexWhere((week) => week == '수요일') == -1 ? false : true,
                  ),
                ),
              ),
              CustomContainer(
                cBorderColor: borderColor,
                cTotalHeight: 40.w,
                cTotalWidth: 192.w,
                cInsideColor: Color(0xffCAACF2),
                cTopBorderWidth: 1.w,
                cLeftBorderWidth: 1.w,
                childWidget: Center(
                  child: RecordTableTextStyle(
                    text: date[3].day.toString() + '일 (목)',
                    title: true,
                    holiday: holidays.indexWhere((week) => week == '목요일') == -1 ? false : true,
                  ),
                ),
              ),
              CustomContainer(
                cBorderColor: borderColor,
                cTotalHeight: 40.w,
                cTotalWidth: 192.w,
                cInsideColor: Color(0xffCAACF2),
                cTopBorderWidth: 1.w,
                cLeftBorderWidth: 1.w,
                cRightBorderWidth: 1.w,
                cBorderRadius: widget.homeData['days'].length == 0 ? BorderRadius.only(bottomRight: Radius.circular(20.w)): BorderRadius.zero,
                childWidget: Center(
                  child: RecordTableTextStyle(
                    text: date[4].day.toString() + '일 (금)',
                    title: true,
                    holiday: holidays.indexWhere((week) => week == '금요일') == -1 ? false : true,
                  ),
                ),
              )
            ],
          ),



          for(int i = 0; i< widget.homeData['days'].length;i++)...[
            Row(
              children: [
                CustomContainer(
                  cBorderColor: borderColor,
                  cTotalHeight: 82.w,
                  cTotalWidth: 93.w,
                  cInsideColor: Color(0xffCAACF2),
                  cTopBorderWidth: 1.w,
                  cLeftBorderWidth: 1.w,
                  cBottomBorderWidth: widget.homeData['days'].length == i + 1 ? 1.w : 0,
                  cBorderRadius: widget.homeData['days'].length == i + 1 ? BorderRadius.only(bottomLeft: Radius.circular(20.w)): BorderRadius.zero,
                  childWidget: Center(
                    child: HomeTextFieldStyle(value: widget.homeData['days'][i]['name'] ?? '', rid: widget.homeData['id'], getHomeData: widget.getHomeData,did: widget.homeData['days'][i]['id'], type : 'name', delete: true,
                    ),
                  ),
                ),

                CustomContainer(
                  cBorderColor: borderColor,
                  cTotalHeight: 82.w,
                  cTotalWidth: 192.w,
                  cInsideColor: Color(0xffffffff),
                  cTopBorderWidth: 1.w,
                  cLeftBorderWidth: 1.w,
                  cBottomBorderWidth: widget.homeData['days'].length == i + 1 ? 1.w : 0,
                  childWidget: Center(
                    child: HomeTextFieldStyle(value: widget.homeData['days'][i]['comments'][0] ?? '', rid: widget.homeData['id'], getHomeData: widget.getHomeData,did: widget.homeData['days'][i]['id'], type : 'monday',
                    ),
                  ),
                ),
                CustomContainer(
                  cBorderColor: borderColor,
                  cTotalHeight: 82.w,
                  cTotalWidth: 192.w,
                  cInsideColor: Color(0xffffffff),
                  cTopBorderWidth: 1.w,
                  cLeftBorderWidth: 1.w,
                  cBottomBorderWidth: widget.homeData['days'].length == i + 1 ? 1.w : 0,
                  childWidget:  Center(
                    child: HomeTextFieldStyle(value: widget.homeData['days'][i]['comments'][1] ?? '', rid: widget.homeData['id'], getHomeData: widget.getHomeData,did: widget.homeData['days'][i]['id'], type : 'tuesday',
                    ),
                  ),
                ),
                CustomContainer(
                  cBorderColor: borderColor,
                  cTotalHeight: 82.w,
                  cTotalWidth: 192.w,
                  cInsideColor: Color(0xffffffff),
                  cTopBorderWidth: 1.w,
                  cLeftBorderWidth: 1.w,
                  cBottomBorderWidth: widget.homeData['days'].length == i + 1 ? 1.w : 0,
                  childWidget:  Center(
                    child: HomeTextFieldStyle(value: widget.homeData['days'][i]['comments'][2] ?? '', rid: widget.homeData['id'], getHomeData: widget.getHomeData,did: widget.homeData['days'][i]['id'], type : 'wednesday',
                    ),
                  ),
                ),
                CustomContainer(
                  cBorderColor: borderColor,
                  cTotalHeight: 82.w,
                  cTotalWidth: 192.w,
                  cInsideColor: Color(0xffffffff),
                  cTopBorderWidth: 1.w,
                  cLeftBorderWidth: 1.w,
                  cBottomBorderWidth: widget.homeData['days'].length == i + 1 ? 1.w : 0,
                  childWidget:  Center(
                    child: HomeTextFieldStyle(value: widget.homeData['days'][i]['comments'][3] ?? '', rid: widget.homeData['id'], getHomeData: widget.getHomeData,did: widget.homeData['days'][i]['id'], type : 'thursday',
                    ),
                  ),
                ),
                CustomContainer(
                  cBorderColor: borderColor,
                  cTotalHeight: 82.w,
                  cTotalWidth: 192.w,
                  cInsideColor: Color(0xffffffff),
                  cTopBorderWidth: 1.w,
                  cLeftBorderWidth: 1.w,
                  cRightBorderWidth: 1.w,
                  cBottomBorderWidth: widget.homeData['days'].length == i + 1 ? 1.w : 0,
                  cBorderRadius: widget.homeData['days'].length == i + 1 ? BorderRadius.only(bottomRight: Radius.circular(20.w)): BorderRadius.zero,
                  childWidget:  Center(
                    child: HomeTextFieldStyle(value: widget.homeData['days'][i]['comments'][4] ?? '', rid: widget.homeData['id'], getHomeData: widget.getHomeData, did: widget.homeData['days'][i]['id'], type : 'friday',
                    ),
                  ),
                )
              ],
            ),
          ],
        ]
      )
    ):Container();
  }
}


class HomeTextFieldStyle extends StatefulWidget {
  const HomeTextFieldStyle({Key? key,
    required this.value,
    required this.rid,
    this.type,
    required this.getHomeData,
    this.mid,
    // this.categoryId,
    // this.subCategoryId,
    this.did,
    this.delete = false,
  }) : super(key: key);
  final String value;
  final int rid;
  final String? type;
  final Function() getHomeData;
  final int? mid;
  // final int? categoryId;
  // final int? subCategoryId;
  final int? did;
  final bool delete;

  @override
  State<HomeTextFieldStyle> createState() => _HomeTextFieldStyleState();
}

class _HomeTextFieldStyleState extends State<HomeTextFieldStyle> {
  TextEditingController value = TextEditingController();
  FocusNode node = FocusNode();

  bool deleteBtn = false;

  patchWeeklyData() async{
    ApiUrl apiUrl = ApiUrl();
    http.Response? weeklyDataRes;
    if(widget.mid != null){
      weeklyDataRes = await api(apiUrl.homeMemo, 'patch', 'signInToken', {
        'mid' : widget.mid.toString(),
        'hid' : widget.rid.toString(),
        'cid' : Provider.of<UserInfo>(context, listen: false).value[0].toString(),
        'type' : widget.type,
        'value' : value.text,
      }, context);
    }else if(widget.did != null){
      weeklyDataRes = await api(apiUrl.homeDay, 'patch', 'signInToken', {
        'did' : widget.did.toString(),
        'hid' : widget.rid.toString(),
        'cid' : Provider.of<UserInfo>(context, listen: false).value[0].toString(),
        'type' : widget.type,
        'value' : value.text,
      }, context);
    }
    if(weeklyDataRes!.statusCode == 200){
      widget.getHomeData();
    }
  }

  deleteWeeklyData() async{
    ApiUrl apiUrl = ApiUrl();
    http.Response? weeklyDataRes;
    if(widget.mid != null){
      weeklyDataRes = await api(apiUrl.homeMemo + '/' + widget.mid.toString(), 'delete', 'signInToken', {}, context);
    }else if(widget.did != null){
      weeklyDataRes = await api(apiUrl.homeDay+ '/' + widget.did.toString(), 'delete', 'signInToken', {}, context);
    }
    if(weeklyDataRes!.statusCode == 200){
      deleteBtn = false;
      widget.getHomeData();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    value.text = widget.value;
    return GestureDetector(
      onLongPress: (){
        setState(() {
          deleteBtn = !deleteBtn;
        });
      },
      onTap: (){
        node.requestFocus();
      },
      child: Stack(
        children: [
          AbsorbPointer(
            child: Center(
              child: Focus(
                onFocusChange: (hasFocus) {
                  if (hasFocus) {
                  } else {
                    if (widget.value == value.text) {
                    } else {
                      patchWeeklyData();
                    }
                  }
                },
                child: TextField(
                  focusNode: node,
                  textAlignVertical: TextAlignVertical.center,
                  style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xff393838)),
                  controller: value,
                  // focusNode: widget.b16TextFocus,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(8.0.w),
                    // hintText: widget.getEmotionData.comment,
                    border: const OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ), //외곽선
                  ),
                ),
              ),
            ),
          ),
          if(widget.delete)...[
            DeleteCategory(onOff: deleteBtn, delete: deleteWeeklyData,),
          ]
        ],
      ),
    );
  }
}


class DeleteCategory extends StatefulWidget {
  const DeleteCategory({Key? key,
    required this.onOff,
    required this.delete,
  }) : super(key: key);
  final bool onOff;
  final Function() delete;

  @override
  State<DeleteCategory> createState() => _DeleteCategoryState();
}

class _DeleteCategoryState extends State<DeleteCategory> {
  @override
  Widget build(BuildContext context) {
    return widget.onOff ? Positioned(
        top: 2.w,
        right: 2.w,
        child: GestureDetector(
          onTap: () {
            widget.delete();
          },
          child: Container(
              width: 25.w,
              height: 25.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                      color: Color(0x29505050),
                      offset: Offset(2, 2),
                      blurRadius: 6)
                ],
                color: Color(0x887649B7),
              ),
              child: Center(
                child: Icon(Icons.do_not_disturb_on_sharp,
                    size: 25.w, color: Colors.white),
              )),
        )):Container();
  }
}
