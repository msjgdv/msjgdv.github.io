import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:treasure_map/provider/app_management.dart';
import 'package:treasure_map/widgets/api.dart';
import 'package:treasure_map/widgets/calendar.dart';
import 'package:treasure_map/widgets/get_container_info.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:treasure_map/widgets/overtab.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../widgets/custom_container.dart';
import 'd3_1.dart';

class D5_2 extends StatefulWidget {
  const D5_2(
      {Key? key,
      required this.nextPage,
      required this.prePage,
      required this.nowPage,
      this.scaffoldKey,
        this.pageTime,
      })
      : super(key: key);
  final Function nextPage;
  final Function prePage;
  final String nowPage;
  final GlobalKey<ScaffoldState>? scaffoldKey;
  final DateTime? pageTime;

  @override
  State<D5_2> createState() => _D5_2State();
}

class _D5_2State extends State<D5_2> {
  bool dateOff = false;

  DateTime pageTime = DateTime.now();
  String pageTimeStr = '';

  List<int> category = [];
  double tablePlusHeight = 0;
  var weeklyData;

  addDataCategory(int index){
    setState(() {
      category[index]++;
      addHeight();
    });

  }
  addColumnCategory(){
    setState(() {
      category.add(0);
      addHeight();
    });

  }

  addHeight(){
    int count = 0;
    for(int i = 0; i< category.length;i++){
      count = count + category[i];
    }
    tablePlusHeight = count * 40 + category.length * 40;
  }

  tableHeight(double value){
    setState(() {
      tablePlusHeight = value;
    });
  }


  //
  // getWeeklyData() async{
  //   ApiUrl apiUrl = ApiUrl();
  //   http.Response weeklyRes = await api(apiUrl.weekly + '/' + pageTimeStr + '/' + Provider.of<UserInfo>(context, listen : false).value[0].toString(), 'get', 'signInToken', {}, context);
  //   if(weeklyRes.statusCode == 200){
  //     var weeklyRB = utf8.decode(weeklyRes.bodyBytes);
  //     setState(() {
  //       weeklyData = jsonDecode(weeklyRB);
  //     });
  //     print(weeklyData);
  //   }
  // }
  //
  //
  receiveData(DateTime dateTime) async {
    pageTime = dateTime;
    var formatter = DateFormat('yyyyMMdd');
    pageTimeStr = formatter.format(pageTime);
    setState(() {});
  }

  @override
  initState() {
    category.add(0);
    addHeight();
    receiveData(pageTime);
    // getWeeklyData();
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
                        height: (420 + 80 + tablePlusHeight).w,
                        decoration: BoxDecoration(
                          color: const Color(0xffFCFCFC),
                          boxShadow: [
                            // BoxShadow(
                            //   color: const Color(0x29b1b1b1),
                            //   blurRadius: 6,
                            //   offset: Offset(2, 2),
                            // )
                          ]
                        ),
                      ),
                      WeeklyPlanTable(
                        tableHeight:tableHeight,
                        pageTime: widget.pageTime,
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

class WeeklyPlanTable extends StatefulWidget {
  const WeeklyPlanTable({Key? key,
    required this.tableHeight,
    this.pageTime,
  }) : super(key: key);
  final Function(double) tableHeight;
  final DateTime? pageTime;

  @override
  State<WeeklyPlanTable> createState() => _WeeklyPlanTableState();
}

class _WeeklyPlanTableState extends State<WeeklyPlanTable> {
  Color borderColor = const Color(0x9dC13BFD);
  List<DateTime> date = [];
  ApiUrl apiUrl = ApiUrl();
  var formatter = DateFormat('yyyyMMdd');
  double tableHeight = 0;
  List<Image?> signImage = [];
  bool dateOff = false;

  DateTime pageTime = DateTime.now();
  String pageTimeStr = '';

  List<String> holidays = [];

  var weeklyData;

  changeDate(DateTime _date) {
    setState(() {
      pageTime = _date;
      pageTimeStr = formatter.format(pageTime);
      getWeeklyData();
      date.clear();
      for(int i = 1 ; i< 6;i++){
        date.add(pageTime.subtract(Duration(days: pageTime.weekday - i)));
      }
    });
  }

  getWeeklyData() async{
    ApiUrl apiUrl = ApiUrl();
    http.Response weeklyRes = await api(apiUrl.weekly + '/' + pageTimeStr + '/' + Provider.of<UserInfo>(context, listen : false).value[0].toString(), 'get', 'signInToken', {}, context);
    if(weeklyRes.statusCode == 200){
      var weeklyRB = utf8.decode(weeklyRes.bodyBytes);
      setState(() {
        weeklyData = jsonDecode(weeklyRB);
      });

      double height = 0;
      height = (weeklyData['freeActivities'].length * 40).toDouble();
      height = height + weeklyData['categories'].length * 40;
      for(int i = 0; i< weeklyData['categories'].length ; i++){
        height = height + weeklyData['categories'][i]['datas'].length * 40;
      }
      height = height + weeklyData['addedActivities'].length * 40;
      setState(() {
        tableHeight = height;
        holidays.clear();
        for(int i = 0; i< weeklyData['holidays'].length;i++){
          holidays.add(weeklyData['holidays'][i]['day']);
        }
      });
      widget.tableHeight(height);
      signImage.clear();
      if(weeklyData['teacherSign'] != null){
        signImage.add(await imageApi(weeklyData['teacherSign'], 'signInToken', context));
      }else{
        signImage.add(null);
      }
      if(weeklyData['viceDirectorSign'] != null){
        signImage.add(await imageApi(weeklyData['viceDirectorSign'], 'signInToken', context));
      }else{
        signImage.add(null);
      }
      if(weeklyData['directorSign'] != null){
        signImage.add(await imageApi(weeklyData['directorSign'], 'signInToken', context));
      }else{
        signImage.add(null);
      }
      setState(() {});
    }
  }

  patchSign() async {
    http.Response childRes =
    await api(apiUrl.weeklySign, 'patch', 'signInToken', {
      'id': weeklyData['id'].toString(),
    }, context);
    if (childRes.statusCode == 200) {
      getWeeklyData();
    }
  }


  receiveData(DateTime dateTime) async {
    pageTime = dateTime;
    var formatter = DateFormat('yyyyMMdd');
    pageTimeStr = formatter.format(pageTime);
    setState(() {});
  }

  postMakeWeeklyFree() async{
    http.Response weeklyFreeRes = await api(apiUrl.weeklyFree, 'post', 'signInToken', {
      'wid' : weeklyData['id'].toString(),
      'cid' : Provider.of<UserInfo>(context, listen: false).value[0].toString()
    }, context);
    if(weeklyFreeRes.statusCode == 200){
      getWeeklyData();
    }
  }
  postMakeWeeklyCategory() async{
    http.Response weeklyFreeRes = await api(apiUrl.weeklyCategory, 'post', 'signInToken', {
      'wid' : weeklyData['id'].toString(),
      'cid' : Provider.of<UserInfo>(context, listen: false).value[0].toString()
    }, context);
    if(weeklyFreeRes.statusCode == 200){
      getWeeklyData();
    }
  }
  postMakeWeeklySubCategory(int categoryId) async{
    http.Response weeklyFreeRes = await api(apiUrl.weeklySubCategory, 'post', 'signInToken', {
      "categoryId": categoryId.toString(),
      'wid' : weeklyData['id'].toString(),
      'cid' : Provider.of<UserInfo>(context, listen: false).value[0].toString()
    }, context);
    if(weeklyFreeRes.statusCode == 200){
      getWeeklyData();
    }
  }
  postMakeWeeklyAdded() async{
    http.Response weeklyFreeRes = await api(apiUrl.weeklyAdded, 'post', 'signInToken', {
      'wid' : weeklyData['id'].toString(),
      'cid' : Provider.of<UserInfo>(context, listen: false).value[0].toString()
    }, context);
    if(weeklyFreeRes.statusCode == 200){
      getWeeklyData();
    }
  }

  postWeeklyForm() async {
    print(Provider.of<UserInfo>(context, listen : false).value[0].toString());
    ApiUrl apiUrl = ApiUrl();
    http.Response weeklyRes = await api(apiUrl.weekly, 'post', 'signInToken', {
      'wid' : weeklyData['id'].toString(),
      'cid' : Provider.of<UserInfo>(context, listen : false).value[0].toString()
    }, context);
    if(weeklyRes.statusCode == 200){
      getWeeklyData();
    }
  }

  @override
  void initState() {
    if(widget.pageTime != null){
      pageTime = widget.pageTime!;
    }
    for(int i = 1 ; i< 6;i++){
      date.add(pageTime.subtract(Duration(days: pageTime.weekday - i)));
    }
    receiveData(pageTime);
    getWeeklyData();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return weeklyData != null ? Column(
      children: [
        Container(
          width: 1053.w,
          height: (420 + tableHeight).w,
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
                      child: RecordTableTextStyle(
                        text: Provider.of<UserInfo>(context, listen: false).value[2] + "의 주간놀이 계획안",
                        title: true,
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
                      cTotalHeight: 50.w,
                      cTotalWidth: 413.w,
                      cBorderRadius:
                          BorderRadius.only(topRight: Radius.circular(20.w)),
                      cInsideColor: Color(0xffffffff),
                      cTopBorderWidth: 1.w,
                      cLeftBorderWidth: 1.w,
                      cRightBorderWidth: 1.w,
                      childWidget: Center(  child: RecordTableTextStyle(
                        text: weeklyData['period'],
                        title: false,
                      ),),
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
                      child: RecordTableTextStyle(
                        text: "생활주제",
                        title: true,
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
                      child: RecordTableTextStyle(
                        text: "주제",
                        title: true,
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
                      child: RecordTableTextStyle(
                        text: "결재",
                        title: true,
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
                      child: WeeklyTextFieldStyle(value: weeklyData['mainTheme'] ?? '', rid: weeklyData['id'], type: 'mainTheme', getWeeklyData: getWeeklyData,),
                    ),
                  ),
                  CustomContainer(
                    cBorderColor: borderColor,
                    cTotalHeight: 70.w,
                    cTotalWidth: 276.w,
                    cInsideColor: Color(0xffffffff),
                    cTopBorderWidth: 1.w,
                    cLeftBorderWidth: 1.w,
                    childWidget:  Center(
                      child: WeeklyTextFieldStyle(value: weeklyData['theme'] ?? '', rid: weeklyData['id'], type: 'theme', getWeeklyData: getWeeklyData,),
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
                      child: RecordTableTextStyle(
                        text: "교사",
                        title: true,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
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
                        child: signImage.isNotEmpty  ? signImage[0] ?? Container() : Container(),
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
                      child: RecordTableTextStyle(
                        text: "원감",
                        title: true,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
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
                        child: signImage.length > 1  ? signImage[1] ?? Container() : Container(),
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
                      child: RecordTableTextStyle(
                        text: "원장",
                        title: true,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
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
                        child: signImage.length > 2  ? signImage[2] ?? Container() : Container(),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  CustomContainer(
                    cBorderColor: borderColor,
                    cTotalHeight: 60.w,
                    cTotalWidth: 96.w,
                    cInsideColor: Color(0xffCAACF2),
                    cTopBorderWidth: 1.w,
                    cLeftBorderWidth: 1.w,
                    childWidget: Center(
                      child: RecordTableTextStyle(
                        text: "교육목표",
                        title: true,
                      ),
                    ),
                  ),
                  CustomContainer(
                    cBorderColor: borderColor,
                    cTotalHeight: 60.w,
                    cTotalWidth: 957.w,
                    cInsideColor: Color(0xffffffff),
                    cTopBorderWidth: 1.w,
                    cLeftBorderWidth: 1.w,
                    cRightBorderWidth: 1.w,
                    childWidget: Center(
                      child: WeeklyTextFieldStyle(value: weeklyData['educationPurpose'] ?? '', rid: weeklyData['id'], type: 'educationPurpose', getWeeklyData: getWeeklyData,),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  CustomContainer(
                    cBorderColor: borderColor,
                    cTotalHeight: 40.w,
                    cTotalWidth: 203.w,
                    cInsideColor: Color(0xffCAACF2),
                    cTopBorderWidth: 1.w,
                    cLeftBorderWidth: 1.w,
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
                    cTotalWidth: 170.w,
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
                    cTotalWidth: 170.w,
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
                    cTotalWidth: 170.w,
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
                    cTotalWidth: 170.w,
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
                    cTotalWidth: 170.w,
                    cInsideColor: Color(0xffCAACF2),
                    cTopBorderWidth: 1.w,
                    cLeftBorderWidth: 1.w,
                    cRightBorderWidth: 1.w,
                    childWidget: Center(
                      child: RecordTableTextStyle(
                        text: date[4].day.toString() + '일 (금)',
                        title: true,
                        holiday: holidays.indexWhere((week) => week == '금요일') == -1 ? false : true,
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
                    cTotalWidth: 203.w,
                    cInsideColor: Color(0xffCAACF2),
                    cTopBorderWidth: 1.w,
                    cLeftBorderWidth: 1.w,
                    childWidget: Center(
                      child: RecordTableTextStyle(
                        text: "소주제",
                        title: true,
                      ),
                    ),
                  ),
                  CustomContainer(
                    cBorderColor: borderColor,
                    cTotalHeight: 40.w,
                    cTotalWidth: 170.w,
                    cInsideColor: Color(0xffffffff),
                    cTopBorderWidth: 1.w,
                    cLeftBorderWidth: 1.w,
                    childWidget: Center(
                      child: WeeklyTextFieldStyle(value: weeklyData['subThemes'][0] ?? '', rid: weeklyData['id'], type: 'monday', getWeeklyData: getWeeklyData,),
                    ),
                  ),
                  CustomContainer(
                    cBorderColor: borderColor,
                    cTotalHeight: 40.w,
                    cTotalWidth: 170.w,
                    cInsideColor: Color(0xffffffff),
                    cTopBorderWidth: 1.w,
                    cLeftBorderWidth: 1.w,
                    childWidget: Center(
                      child: WeeklyTextFieldStyle(value: weeklyData['subThemes'][1] ?? '', rid: weeklyData['id'], type: 'tuesday', getWeeklyData: getWeeklyData,),
                    ),
                  ),
                  CustomContainer(
                    cBorderColor: borderColor,
                    cTotalHeight: 40.w,
                    cTotalWidth: 170.w,
                    cInsideColor: Color(0xffffffff),
                    cTopBorderWidth: 1.w,
                    cLeftBorderWidth: 1.w,
                    childWidget: Center(
                      child: WeeklyTextFieldStyle(value: weeklyData['subThemes'][2] ?? '', rid: weeklyData['id'], type: 'wednesday', getWeeklyData: getWeeklyData,),
                    ),
                  ),
                  CustomContainer(
                    cBorderColor: borderColor,
                    cTotalHeight: 40.w,
                    cTotalWidth: 170.w,
                    cInsideColor: Color(0xffffffff),
                    cTopBorderWidth: 1.w,
                    cLeftBorderWidth: 1.w,
                    childWidget: Center(
                      child: WeeklyTextFieldStyle(value: weeklyData['subThemes'][3] ?? '', rid: weeklyData['id'], type: 'thursday', getWeeklyData: getWeeklyData,),
                    ),
                  ),
                  CustomContainer(
                    cBorderColor: borderColor,
                    cTotalHeight: 40.w,
                    cTotalWidth: 170.w,
                    cInsideColor: Color(0xffffffff),
                    cTopBorderWidth: 1.w,
                    cLeftBorderWidth: 1.w,
                    cRightBorderWidth: 1.w,
                    childWidget: Center(
                      child: WeeklyTextFieldStyle(value: weeklyData['subThemes'][4] ?? '', rid: weeklyData['id'], type: 'friday', getWeeklyData: getWeeklyData,),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  CustomContainer(
                    cBorderColor: borderColor,
                    cTotalHeight: (40 + 40 * weeklyData['freeActivities'].length).w,
                    cTotalWidth: 103.w,
                    cInsideColor: Color(0xffE5D0FE),
                    cTopBorderWidth: 1.w,
                    cLeftBorderWidth: 1.w,
                    childWidget: Center(
                      child: RecordTableTextStyle(
                        text: "자유선택활동",
                        title: false,
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      for (int i = 0; i < weeklyData['freeActivities'].length; i++) ...[
                        CustomContainer(
                          cBorderColor: borderColor,
                          cTotalHeight: 40.w,
                          cTotalWidth: 100.w,
                          cInsideColor: Color(0xffCAACF2),
                          cTopBorderWidth: 1.w,
                          cLeftBorderWidth: 1.w,
                          childWidget:
                          Center(
                            child: WeeklyTextFieldStyle(value: weeklyData['freeActivities'][i]['name'] ?? '', rid: weeklyData['id'], type: 'name', getWeeklyData: getWeeklyData, fid: weeklyData['freeActivities'][i]['id'], delete: true),
                          ),
                        ),
                      ],
                      CustomContainer(
                        cBorderColor: borderColor,
                        cTotalHeight: 40.w,
                        cTotalWidth: 100.w,
                        cInsideColor: Color(0xffCAACF2),
                        cTopBorderWidth: 1.w,
                        cLeftBorderWidth: 1.w,
                        childWidget: Center(
                          child : GestureDetector(
                            onTap: () {
                              setState(() {
                                postMakeWeeklyFree();
                                getWeeklyData();
                                // widget.addDataCategory(i);
                                // widget.category[i]++;
                              });
                            },
                            child: Container(
                              width: 30.w,
                              height: 30.w,
                              decoration: BoxDecoration(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(10.w)),
                                  color: Color(0xffffffff),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color(0x29000000),
                                      blurRadius: 6,
                                      offset: Offset(0, 3),
                                    )
                                  ]),
                              child: Center(
                                  child: Icon(Icons.add,
                                    color: Color(0xff7649B7),
                                    size: 24.w,)
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      for (int i = 0; i < weeklyData['freeActivities'].length; i++) ...[
                        CustomContainer(
                          cBorderColor: borderColor,
                          cTotalHeight: 40.w,
                          cTotalWidth: 170.w,
                          cInsideColor: Color(0xffffffff),
                          cTopBorderWidth: 1.w,
                          cLeftBorderWidth: 1.w,
                          childWidget: Center(
                            child: WeeklyTextFieldStyle(value: weeklyData['freeActivities'][i]['activities'][0] ?? '', rid: weeklyData['id'], type: 'monday', getWeeklyData: getWeeklyData, fid: weeklyData['freeActivities'][i]['id'],),
                          ),
                        ),
                      ],
                      CustomContainer(
                        cBorderColor: borderColor,
                        cTotalHeight: 40.w,
                        cTotalWidth: 170.w,
                        cInsideColor: Color(0xffffffff),
                        cTopBorderWidth: 1.w,
                        cLeftBorderWidth: 1.w,
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      for (int i = 0; i < weeklyData['freeActivities'].length; i++) ...[
                        CustomContainer(
                          cBorderColor: borderColor,
                          cTotalHeight: 40.w,
                          cTotalWidth: 170.w,
                          cInsideColor: Color(0xffffffff),
                          cTopBorderWidth: 1.w,
                          cLeftBorderWidth: 1.w,
                          childWidget: Center(
                            child: WeeklyTextFieldStyle(value: weeklyData['freeActivities'][i]['activities'][1] ?? '', rid: weeklyData['id'], type: 'tuesday', getWeeklyData: getWeeklyData, fid: weeklyData['freeActivities'][i]['id'],),
                          ),
                        ),
                      ],
                      CustomContainer(
                        cBorderColor: borderColor,
                        cTotalHeight: 40.w,
                        cTotalWidth: 170.w,
                        cInsideColor: Color(0xffffffff),
                        cTopBorderWidth: 1.w,

                        childWidget: Center(),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      for (int i = 0; i < weeklyData['freeActivities'].length; i++) ...[
                        CustomContainer(
                          cBorderColor: borderColor,
                          cTotalHeight: 40.w,
                          cTotalWidth: 170.w,
                          cInsideColor: Color(0xffffffff),
                          cTopBorderWidth: 1.w,
                          cLeftBorderWidth: 1.w,
                          childWidget: Center(
                            child: WeeklyTextFieldStyle(value: weeklyData['freeActivities'][i]['activities'][2] ?? '', rid: weeklyData['id'], type: 'wednesday', getWeeklyData: getWeeklyData, fid: weeklyData['freeActivities'][i]['id'],),
                          ),
                        ),
                      ],
                      CustomContainer(
                        cBorderColor: borderColor,
                        cTotalHeight: 40.w,
                        cTotalWidth: 170.w,
                        cInsideColor: Color(0xffffffff),
                        cTopBorderWidth: 1.w,

                        childWidget: Center(),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      for (int i = 0; i < weeklyData['freeActivities'].length; i++) ...[
                        CustomContainer(
                          cBorderColor: borderColor,
                          cTotalHeight: 40.w,
                          cTotalWidth: 170.w,
                          cInsideColor: Color(0xffffffff),
                          cTopBorderWidth: 1.w,
                          cLeftBorderWidth: 1.w,
                          childWidget: Center(
                            child: WeeklyTextFieldStyle(value: weeklyData['freeActivities'][i]['activities'][3] ?? '', rid: weeklyData['id'], type: 'thursday', getWeeklyData: getWeeklyData, fid: weeklyData['freeActivities'][i]['id'],),
                          ),
                        ),
                      ],
                      CustomContainer(
                        cBorderColor: borderColor,
                        cTotalHeight: 40.w,
                        cTotalWidth: 170.w,
                        cInsideColor: Color(0xffffffff),
                        cTopBorderWidth: 1.w,

                        childWidget: Center(),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      for (int i = 0; i < weeklyData['freeActivities'].length; i++) ...[
                        CustomContainer(
                          cBorderColor: borderColor,
                          cTotalHeight: 40.w,
                          cTotalWidth: 170.w,
                          cInsideColor: Color(0xffffffff),
                          cTopBorderWidth: 1.w,
                          cLeftBorderWidth: 1.w,
                          cRightBorderWidth: 1.w,
                          childWidget: Center(
                            child: WeeklyTextFieldStyle(value: weeklyData['freeActivities'][i]['activities'][4] ?? '', rid: weeklyData['id'], type: 'friday', getWeeklyData: getWeeklyData, fid: weeklyData['freeActivities'][i]['id'],),
                          ),
                        ),
                      ],
                      CustomContainer(
                        cBorderColor: borderColor,
                        cTotalHeight: 40.w,
                        cTotalWidth: 170.w,
                        cInsideColor: Color(0xffffffff),
                        cTopBorderWidth: 1.w,
                        cRightBorderWidth: 1.w,
                        childWidget: Center(),
                      ),
                    ],
                  ),
                ],
              ),
              for (int i = 0; i < weeklyData['categories'].length; i++) ...[
                Row(
                  children: [
                    CustomContainer(
                      cBorderColor: borderColor,
                      cTotalHeight: (40 + 40 * weeklyData['categories'][i]['datas'].length).w,
                      cTotalWidth: 103.w,
                      cInsideColor: Color(0xffE5D0FE),
                      cTopBorderWidth: 1.w,
                      cLeftBorderWidth: 1.w,
                      childWidget: Center(
                        child: WeeklyTextFieldStyle(value: weeklyData['categories'][i]['name'] ?? '', rid: weeklyData['id'], getWeeklyData: getWeeklyData, categoryId: weeklyData['categories'][i]['id'], delete: true),
                      ),
                    ),
                    Column(
                      children: [
                        for (int j = 0; j < weeklyData['categories'][i]['datas'].length; j++) ...[
                          CustomContainer(
                            cBorderColor: borderColor,
                            cTotalHeight: 40.w,
                            cTotalWidth: 100.w,
                            cInsideColor: Color(0xffCAACF2),
                            cTopBorderWidth: 1.w,
                            cLeftBorderWidth: 1.w,
                            childWidget: Center(
                              child: WeeklyTextFieldStyle(value: weeklyData['categories'][i]['datas'][j]['subName'] ?? '', rid: weeklyData['id'], type: 'name', getWeeklyData: getWeeklyData, categoryId: weeklyData['categories'][i]['id'], subCategoryId: weeklyData['categories'][i]['datas'][j]['id'], delete: true),
                            ),
                          ),
                        ],
                        CustomContainer(
                          cBorderColor: borderColor,
                          cTotalHeight: 40.w,
                          cTotalWidth: 100.w,
                          cInsideColor: Color(0xffCAACF2),
                          cTopBorderWidth: 1.w,
                          cLeftBorderWidth: 1.w,
                          childWidget: Center(
                            child : GestureDetector(
                              onTap: () {
                                setState(() {
                                  postMakeWeeklySubCategory(weeklyData['categories'][i]['id']);
                                  // addDataCategory(i);
                                  // category[i]++;
                                });
                              },
                              child: Container(
                                width: 30.w,
                                height: 30.w,
                                decoration: BoxDecoration(
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(10.w)),
                                    color: Color(0xffffffff),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Color(0x29000000),
                                        blurRadius: 6,
                                        offset: Offset(0, 3),
                                      )
                                    ]),
                                child: Center(
                                    child: Icon(Icons.add,
                                      color: Color(0xff7649B7),
                                      size: 24.w,)
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        for (int j = 0; j < weeklyData['categories'][i]['datas'].length; j++) ...[
                          CustomContainer(
                            cBorderColor: borderColor,
                            cTotalHeight: 40.w,
                            cTotalWidth: 170.w,
                            cInsideColor: Color(0xffffffff),
                            cTopBorderWidth: 1.w,
                            cLeftBorderWidth: 1.w,
                            childWidget: Center(
                              child: WeeklyTextFieldStyle(value: weeklyData['categories'][i]['datas'][j]['activities'][0] ?? '', rid: weeklyData['id'], type: 'monday', getWeeklyData: getWeeklyData, categoryId: weeklyData['categories'][i]['id'], subCategoryId: weeklyData['categories'][i]['datas'][j]['id'],),
                            ),
                          ),
                        ],
                        CustomContainer(
                          cBorderColor: borderColor,
                          cTotalHeight: 40.w,
                          cTotalWidth: 170.w,
                          cInsideColor: Color(0xffffffff),
                          cTopBorderWidth: 1.w,
                          cLeftBorderWidth: 1.w,
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        for (int j = 0; j < weeklyData['categories'][i]['datas'].length; j++) ...[
                          CustomContainer(
                            cBorderColor: borderColor,
                            cTotalHeight: 40.w,
                            cTotalWidth: 170.w,
                            cInsideColor: Color(0xffffffff),
                            cTopBorderWidth: 1.w,
                            cLeftBorderWidth: 1.w,
                            childWidget: Center(
                              child: WeeklyTextFieldStyle(value: weeklyData['categories'][i]['datas'][j]['activities'][1] ?? '', rid: weeklyData['id'], type: 'tuesday', getWeeklyData: getWeeklyData, categoryId: weeklyData['categories'][i]['id'], subCategoryId: weeklyData['categories'][i]['datas'][j]['id'],),
                            ),
                          ),
                        ],
                        CustomContainer(
                          cBorderColor: borderColor,
                          cTotalHeight: 40.w,
                          cTotalWidth: 170.w,
                          cInsideColor: Color(0xffffffff),
                          cTopBorderWidth: 1.w,

                          childWidget: Center(),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        for (int j = 0; j < weeklyData['categories'][i]['datas'].length; j++) ...[
                          CustomContainer(
                            cBorderColor: borderColor,
                            cTotalHeight: 40.w,
                            cTotalWidth: 170.w,
                            cInsideColor: Color(0xffffffff),
                            cTopBorderWidth: 1.w,
                            cLeftBorderWidth: 1.w,
                            childWidget: Center(
                              child: WeeklyTextFieldStyle(value: weeklyData['categories'][i]['datas'][j]['activities'][2] ?? '', rid: weeklyData['id'], type: 'wednesday', getWeeklyData: getWeeklyData, categoryId: weeklyData['categories'][i]['id'], subCategoryId: weeklyData['categories'][i]['datas'][j]['id'],),
                            ),
                          ),
                        ],
                        CustomContainer(
                          cBorderColor: borderColor,
                          cTotalHeight: 40.w,
                          cTotalWidth: 170.w,
                          cInsideColor: Color(0xffffffff),
                          cTopBorderWidth: 1.w,

                          childWidget: Center(),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        for (int j = 0; j < weeklyData['categories'][i]['datas'].length; j++) ...[
                          CustomContainer(
                            cBorderColor: borderColor,
                            cTotalHeight: 40.w,
                            cTotalWidth: 170.w,
                            cInsideColor: Color(0xffffffff),
                            cTopBorderWidth: 1.w,
                            cLeftBorderWidth: 1.w,
                            childWidget: Center(
                              child: WeeklyTextFieldStyle(value: weeklyData['categories'][i]['datas'][j]['activities'][3] ?? '', rid: weeklyData['id'], type: 'thursday', getWeeklyData: getWeeklyData, categoryId: weeklyData['categories'][i]['id'], subCategoryId: weeklyData['categories'][i]['datas'][j]['id'],),
                            ),
                          ),
                        ],
                        CustomContainer(
                          cBorderColor: borderColor,
                          cTotalHeight: 40.w,
                          cTotalWidth: 170.w,
                          cInsideColor: Color(0xffffffff),
                          cTopBorderWidth: 1.w,

                          childWidget: Center(),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        for (int j = 0; j < weeklyData['categories'][i]['datas'].length; j++) ...[
                          CustomContainer(
                            cBorderColor: borderColor,
                            cTotalHeight: 40.w,
                            cTotalWidth: 170.w,
                            cInsideColor: Color(0xffffffff),
                            cTopBorderWidth: 1.w,
                            cLeftBorderWidth: 1.w,
                            cRightBorderWidth: 1.w,
                            childWidget: Center(
                              child: WeeklyTextFieldStyle(value: weeklyData['categories'][i]['datas'][j]['activities'][4] ?? '', rid: weeklyData['id'], type: 'friday', getWeeklyData: getWeeklyData, categoryId: weeklyData['categories'][i]['id'], subCategoryId: weeklyData['categories'][i]['datas'][j]['id'],),
                            ),
                          ),
                        ],
                        CustomContainer(
                          cBorderColor: borderColor,
                          cTotalHeight: 40.w,
                          cTotalWidth: 170.w,
                          cInsideColor: Color(0xffffffff),
                          cTopBorderWidth: 1.w,
                          cRightBorderWidth: 1.w,
                          childWidget: Center(),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
              Row(
                children: [
                  CustomContainer(
                    cBorderColor: borderColor,
                    cTotalHeight: 40.w,
                    cTotalWidth: 103.w,
                    cInsideColor: Color(0xffE5D0FE),
                    cTopBorderWidth: 1.w,
                    cLeftBorderWidth: 1.w,
                    childWidget: Center(
                      child : GestureDetector(
                        onTap: () {
                          setState(() {
                            postMakeWeeklyCategory();

                            // widget.category.add(0);
                          });
                        },
                        child: Container(
                          width: 30.w,
                          height: 30.w,
                          decoration: BoxDecoration(
                              borderRadius:
                              BorderRadius.all(Radius.circular(10.w)),
                              color: Color(0xffffffff),
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0x29000000),
                                  blurRadius: 6,
                                  offset: Offset(0, 3),
                                )
                              ]),
                          child: Center(
                              child: Icon(Icons.add,
                                color: Color(0xff7649B7),
                                size: 24.w,)
                          ),
                        ),
                      ),
                    ),
                  ),
                  CustomContainer(
                    cBorderColor: borderColor,
                    cTotalHeight: 40.w,
                    cTotalWidth: 100.w,
                    cInsideColor: Color(0xffCAACF2),
                    cTopBorderWidth: 1.w,
                    cLeftBorderWidth: 1.w,
                    childWidget: Center(

                    ),
                  ),
                  CustomContainer(
                    cBorderColor: borderColor,
                    cTotalHeight: 40.w,
                    cTotalWidth: 170.w,
                    cInsideColor: Color(0xffffffff),
                    cTopBorderWidth: 1.w,
                    cLeftBorderWidth: 1.w,
                    childWidget: Center(),
                  ),
                  CustomContainer(
                    cBorderColor: borderColor,
                    cTotalHeight: 40.w,
                    cTotalWidth: 170.w,
                    cInsideColor: Color(0xffffffff),
                    cTopBorderWidth: 1.w,

                    childWidget: Center(),
                  ),
                  CustomContainer(
                    cBorderColor: borderColor,
                    cTotalHeight: 40.w,
                    cTotalWidth: 170.w,
                    cInsideColor: Color(0xffffffff),
                    cTopBorderWidth: 1.w,

                    childWidget: Center(),
                  ),
                  CustomContainer(
                    cBorderColor: borderColor,
                    cTotalHeight: 40.w,
                    cTotalWidth: 170.w,
                    cInsideColor: Color(0xffffffff),
                    cTopBorderWidth: 1.w,

                    childWidget: Center(),
                  ),
                  CustomContainer(
                    cBorderColor: borderColor,
                    cTotalHeight: 40.w,
                    cTotalWidth: 170.w,
                    cInsideColor: Color(0xffffffff),
                    cTopBorderWidth: 1.w,

                    cRightBorderWidth: 1.w,
                    childWidget: Center(),
                  ),
                ],
              ),
              for(int i =0; i<weeklyData['addedActivities'].length;i++)...[
                Row(
                  children: [
                    CustomContainer(
                      cBorderColor: borderColor,
                      cTotalHeight: 40.w,
                      cTotalWidth: 203.w,
                      cInsideColor: Color(0xffCAACF2),
                      cTopBorderWidth: 1.w,
                      cLeftBorderWidth: 1.w,
                      childWidget: Center(
                        child: WeeklyTextFieldStyle(value: weeklyData['addedActivities'][i]['name'] ?? '', rid: weeklyData['id'], type: 'name', getWeeklyData: getWeeklyData, aid: weeklyData['addedActivities'][i]['id'], delete: true,),
                      ),
                    ),
                    CustomContainer(
                      cBorderColor: borderColor,
                      cTotalHeight: 40.w,
                      cTotalWidth: 170.w,
                      cInsideColor: Color(0xffffffff),
                      cTopBorderWidth: 1.w,
                      cLeftBorderWidth: 1.w,

                      childWidget: Center(
                        child: WeeklyTextFieldStyle(value: weeklyData['addedActivities'][i]['activities'][0] ?? '', rid: weeklyData['id'], type: 'monday', getWeeklyData: getWeeklyData, aid: weeklyData['addedActivities'][i]['id']),
                      ),
                    ),
                    CustomContainer(
                      cBorderColor: borderColor,
                      cTotalHeight: 40.w,
                      cTotalWidth: 170.w,
                      cInsideColor: Color(0xffffffff),
                      cTopBorderWidth: 1.w,
                      cLeftBorderWidth: 1.w,

                      childWidget: Center(
                        child: WeeklyTextFieldStyle(value: weeklyData['addedActivities'][i]['activities'][1] ?? '', rid: weeklyData['id'], type: 'tuesday', getWeeklyData: getWeeklyData, aid: weeklyData['addedActivities'][i]['id']),
                      ),
                    ),
                    CustomContainer(
                      cBorderColor: borderColor,
                      cTotalHeight: 40.w,
                      cTotalWidth: 170.w,
                      cInsideColor: Color(0xffffffff),
                      cTopBorderWidth: 1.w,
                      cLeftBorderWidth: 1.w,

                      childWidget: Center(
                        child: WeeklyTextFieldStyle(value: weeklyData['addedActivities'][i]['activities'][2] ?? '', rid: weeklyData['id'], type: 'wednesday', getWeeklyData: getWeeklyData, aid: weeklyData['addedActivities'][i]['id']),
                      ),
                    ),
                    CustomContainer(
                      cBorderColor: borderColor,
                      cTotalHeight: 40.w,
                      cTotalWidth: 170.w,
                      cInsideColor: Color(0xffffffff),
                      cTopBorderWidth: 1.w,
                      cLeftBorderWidth: 1.w,

                      childWidget: Center(
                        child: WeeklyTextFieldStyle(value: weeklyData['addedActivities'][i]['activities'][3] ?? '', rid: weeklyData['id'], type: 'thursday', getWeeklyData: getWeeklyData, aid: weeklyData['addedActivities'][i]['id']),
                      ),
                    ),
                    CustomContainer(
                      cBorderColor: borderColor,
                      cTotalHeight: 40.w,
                      cTotalWidth: 170.w,

                      cInsideColor: Color(0xffffffff),
                      cTopBorderWidth: 1.w,
                      cLeftBorderWidth: 1.w,
                      cRightBorderWidth: 1.w,

                      childWidget: Center(
                        child: WeeklyTextFieldStyle(value: weeklyData['addedActivities'][i]['activities'][4] ?? '', rid: weeklyData['id'], type: 'friday', getWeeklyData: getWeeklyData, aid: weeklyData['addedActivities'][i]['id']),
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
                    cTotalWidth: 203.w,
                    cBorderRadius: BorderRadius.only(bottomLeft: Radius.circular(20.w)),
                    cInsideColor: Color(0xffCAACF2),
                    cTopBorderWidth: 1.w,
                    cLeftBorderWidth: 1.w,
                    cBottomBorderWidth: 1.w,
                    childWidget: Center(
                      child : GestureDetector(
                        onTap: () {
                          setState(() {
                            postMakeWeeklyAdded();
                          });
                        },
                        child: Container(
                          width: 30.w,
                          height: 30.w,
                          decoration: BoxDecoration(
                              borderRadius:
                              BorderRadius.all(Radius.circular(10.w)),
                              color: Color(0xffffffff),
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0x29000000),
                                  blurRadius: 6,
                                  offset: Offset(0, 3),
                                )
                              ]),
                          child: Center(
                              child: Icon(Icons.add,
                                color: Color(0xff7649B7),
                                size: 24.w,)
                          ),
                        ),
                      ),
                    ),
                  ),
                  CustomContainer(
                    cBorderColor: borderColor,
                    cTotalHeight: 40.w,
                    cTotalWidth: 170.w,
                    cInsideColor: Color(0xffffffff),
                    cTopBorderWidth: 1.w,
                    cLeftBorderWidth: 1.w,
                    cBottomBorderWidth: 1.w,
                    childWidget: Center(),
                  ),
                  CustomContainer(
                    cBorderColor: borderColor,
                    cTotalHeight: 40.w,
                    cTotalWidth: 170.w,
                    cInsideColor: Color(0xffffffff),
                    cTopBorderWidth: 1.w,
                    cLeftBorderWidth: 1.w,
                    cBottomBorderWidth: 1.w,
                    childWidget: Center(),
                  ),
                  CustomContainer(
                    cBorderColor: borderColor,
                    cTotalHeight: 40.w,
                    cTotalWidth: 170.w,
                    cInsideColor: Color(0xffffffff),
                    cTopBorderWidth: 1.w,
                    cLeftBorderWidth: 1.w,
                    cBottomBorderWidth: 1.w,
                    childWidget: Center(),
                  ),
                  CustomContainer(
                    cBorderColor: borderColor,
                    cTotalHeight: 40.w,
                    cTotalWidth: 170.w,
                    cInsideColor: Color(0xffffffff),
                    cTopBorderWidth: 1.w,
                    cLeftBorderWidth: 1.w,
                    cBottomBorderWidth: 1.w,
                    childWidget: Center(),
                  ),
                  CustomContainer(
                    cBorderColor: borderColor,
                    cTotalHeight: 40.w,
                    cTotalWidth: 170.w,
                    cBorderRadius: BorderRadius.only(bottomRight: Radius.circular(20.w)),
                    cInsideColor: Color(0xffffffff),
                    cTopBorderWidth: 1.w,
                    cLeftBorderWidth: 1.w,
                    cRightBorderWidth: 1.w,
                    cBottomBorderWidth: 1.w,
                    childWidget: Center(),
                  ),
                ],
              ),

            ],
          ),
        ),
        SizedBox(
          height: 40.w,
        ),
        Row(
          children: [
            Container(
              width: 850.w,
              height: 40.w,
              color: Color(0xffFCFCFC),
            ),
            GestureDetector(
              onTap: (){
                postWeeklyForm();
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
            )
          ],
        ),


      ],
    ):Container();
  }
}

class WeeklyTextFieldStyle extends StatefulWidget {
  const WeeklyTextFieldStyle({Key? key,
    required this.value,
    required this.rid,
    this.type,
    required this.getWeeklyData,
    this.fid,
    this.categoryId,
    this.subCategoryId,
    this.aid,
    this.delete = false,
  }) : super(key: key);
  final String value;
  final int rid;
  final String? type;
  final Function() getWeeklyData;
  final int? fid;
  final int? categoryId;
  final int? subCategoryId;
  final int? aid;
  final bool delete;

  @override
  State<WeeklyTextFieldStyle> createState() => _WeeklyTextFieldStyleState();
}

class _WeeklyTextFieldStyleState extends State<WeeklyTextFieldStyle> {
  TextEditingController value = TextEditingController();
  FocusNode node = FocusNode();

  bool deleteBtn = false;

  patchWeeklyData() async{
    ApiUrl apiUrl = ApiUrl();
    http.Response? weeklyDataRes;
    if(widget.fid != null){
      weeklyDataRes = await api(apiUrl.weeklyFree, 'patch', 'signInToken', {
        'fid' : widget.fid.toString(),
        'wid' : widget.rid.toString(),
        'cid' : Provider.of<UserInfo>(context, listen: false).value[0].toString(),
        'type' : widget.type,
        'value' : value.text,
      }, context);
    }else if(widget.subCategoryId != null){
      weeklyDataRes = await api(apiUrl.weeklySubCategory, 'patch', 'signInToken', {
        'categoryId' : widget.categoryId.toString(),
        'subCategoryId' : widget.subCategoryId.toString(),
        'wid' : widget.rid.toString(),
        'cid' : Provider.of<UserInfo>(context, listen: false).value[0].toString(),
        'type' : widget.type,
        'value' : value.text,
      }, context);
    }else if(widget.categoryId != null){
      weeklyDataRes = await api(apiUrl.weeklyCategory, 'patch', 'signInToken', {
        'categoryId' : widget.categoryId.toString(),
        'wid' : widget.rid.toString(),
        'cid' : Provider.of<UserInfo>(context, listen: false).value[0].toString(),
        'name' : value.text,
      }, context);
    }else if(widget.aid != null){
      weeklyDataRes = await api(apiUrl.weeklyAdded, 'patch', 'signInToken', {
        'aid' : widget.aid.toString(),
        'wid' : widget.rid.toString(),
        'cid' : Provider.of<UserInfo>(context, listen: false).value[0].toString(),
        'type' : widget.type,
        'value' : value.text,
      }, context);
    }else{
      weeklyDataRes = await api(apiUrl.weekly, 'patch', 'signInToken', {
        'id' : widget.rid.toString(),
        'cid' : Provider.of<UserInfo>(context, listen: false).value[0].toString(),
        'type' : widget.type,
        'value' : value.text,
      }, context);
    }
    if(weeklyDataRes!.statusCode == 200){
      widget.getWeeklyData();
    }
  }

  deleteWeeklyData() async{
    ApiUrl apiUrl = ApiUrl();
    http.Response? weeklyDataRes;
    if(widget.fid != null){
      weeklyDataRes = await api(apiUrl.weeklyFree + '/' + widget.fid.toString(), 'delete', 'signInToken', {}, context);
    }else if(widget.subCategoryId != null){
      weeklyDataRes = await api(apiUrl.weeklySubCategory+ '/' + widget.subCategoryId.toString(), 'delete', 'signInToken', {}, context);
    }else if(widget.categoryId != null){
      weeklyDataRes = await api(apiUrl.weeklyCategory+ '/' + widget.categoryId.toString(), 'delete', 'signInToken', {}, context);
    }else if(widget.aid != null){
      weeklyDataRes = await api(apiUrl.weeklyAdded+ '/' + widget.aid.toString(), 'delete', 'signInToken', {}, context);
    }
    if(weeklyDataRes!.statusCode == 200){
      deleteBtn = false;
      widget.getWeeklyData();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // value.text = widget.value;
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
