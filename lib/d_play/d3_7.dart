import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:treasure_map/d_play/d3_1.dart';
import 'package:treasure_map/provider/app_management.dart';
import 'package:treasure_map/widgets/get_container_info.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:treasure_map/widgets/overtab.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:http/http.dart' as http;
import '../widgets/api.dart';

///관찰기록 달력
///버그가 생겨서 일단 수정은 완료 하였지만 추후 추가작업이 필요함
///받아온 날짜만큼 탭이 생기도록 수정을 해야함(현재 탭의 갯수가 고정되어있음)

class D3_7 extends StatefulWidget {
  const D3_7({Key? key,
    required this.nextPage,
    required this.prePage,
    required this.nowPage,
    this.scaffoldKey,
    this.routhPage,
    required this.changePage,
    required this.scheduleYearData,
  })
      : super(key: key);
  final Function nextPage;
  final Function prePage;
  final String nowPage;
  final GlobalKey<ScaffoldState>? scaffoldKey;
  final Function(Widget)? routhPage;
  final scheduleYearData;
  final Function(int) changePage;


  @override
  State<D3_7> createState() => _D3_7State();
}

class _D3_7State extends State<D3_7> {
  bool dateOff = false;

  DateTime pageTime = DateTime.now();
  String pageTimeStr = '';

  receiveData(DateTime dateTime) async {
    pageTime = dateTime;
    var formatter = DateFormat('yyyyMMdd');
    pageTimeStr = formatter.format(pageTime);
    setState(() {

    });
  }

  goSelectRecord(DateTime date){
    widget.routhPage!(D3_1(nextPage: widget.nextPage, prePage: widget.prePage, nowPage: widget.nowPage, nowDate: date, routhPage: widget.routhPage,scaffoldKey: widget.scaffoldKey, changePage: widget.changePage));
  }
  // var scheduleYearData;
  // getDate() async{
  //   ApiUrl apiUrl = ApiUrl();
  //   http.Response scheduleYearRes =
  //   await api(apiUrl.schedule + '/' + Provider.of<UserInfo>(context, listen: false).value[0].toString(), 'get', 'signInToken', {}, context);
  //   if (scheduleYearRes.statusCode == 200) {
  //     var scheduleYearRB = utf8.decode(scheduleYearRes.bodyBytes);
  //     setState(() {
  //       scheduleYearData = jsonDecode(scheduleYearRB);
  //     });
  //   }
  // }

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
        color: Color(0xffFCFCFC),
      ),
      child: Column(
        children: [
          OverTab(nextPage: widget.nextPage, prePage: widget.prePage, nowPage: widget.nowPage,dateOnOff: dateOff, receiveData: receiveData,scaffoldKey: widget.scaffoldKey,),
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
                        height: 530.w,
                        decoration: BoxDecoration(
                          color: const Color(0xffFCFCFC),
                        ),

                      ),
                      CalenderMonth(date: pageTime, goSelectPage: goSelectRecord, dates: widget.scheduleYearData,),
                    ],
                  ),

                  Row(
                    children: [
                      Container(
                        width: 50.w,
                        height: 50.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(50.w)),
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

class CalenderMonth extends StatefulWidget {
  const CalenderMonth({Key? key,
    required this.date,
    required this.goSelectPage,
    required this.dates,
  }) : super(key: key);
  final DateTime date;
  final Function goSelectPage;
  final dates;

  @override
  State<CalenderMonth> createState() => _CalenderMonthState();
}

class _CalenderMonthState extends State<CalenderMonth> {
  DateTime onBtn = DateTime.now();
  DateTime nowMonth = DateTime.now();
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();
  int monthCount = 0;

  changeBtn(int month, int year){
    setState(() {
      if(startDate.year == year && startDate.month == month){
        nowMonth = DateTime.utc(year, month, startDate.day+1);
        onBtn = DateTime.utc(year, month, startDate.day+1);
      }else if(endDate.year == year && endDate.month == month){
        nowMonth = DateTime.utc(year, month, endDate.day-2);
        onBtn = DateTime.utc(year, month, endDate.day-2);
      }else{
        nowMonth = DateTime.utc(year, month, 15);
        onBtn = DateTime.utc(year, month, 15);
      }

    });
  }

  @override
  void initState() {
    // onBtn = widget.date;
    // changeBtn(widget.date.month);
    startDate = DateTime.parse(widget.dates["startDate"]);
    endDate = DateTime.parse(widget.dates["endDate"]);
    if(endDate.year - startDate.year > 0){
      monthCount = endDate.month + 12 - startDate.month + 1;
    }else{
      monthCount = endDate.month - startDate.month + 1;
    }
    if(int.parse(endDate.difference(nowMonth).inDays.toString()) < 0){
      nowMonth = endDate;
      onBtn = endDate;

    }else if(int.parse(startDate.difference(nowMonth).inDays.toString()) > 0){
      nowMonth = startDate;
      onBtn = startDate;
    }
    // onBtn = widget.date.month;
    print(nowMonth);
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        Container(
          width: 1052.w,
          height: 30.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(topRight: Radius.circular(20.w),
                topLeft: Radius.circular(20.w)),
            color: Color(0xffE5D0FF),
            boxShadow: [
              BoxShadow(
                color: Color(0x29B1B1B1),
                offset: Offset(2, 2),
                blurRadius: 6,
              )
            ],
          ),
          child: Center(child: Text(widget.dates == null ? '' : widget.dates['year'].toString() + "학년도 관찰기록",
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            color: Color(0xff393838)
          ),),),
        ),
        Container(
          height: 500.w,
          width: 1052.w,
          decoration: BoxDecoration(
            border: Border.all(color: Color(0x66C13BFD), width: 1),
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20.w),bottomRight: Radius.circular(20.w)),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Color(0x29B1B1B1),
                offset: Offset(2, 2),
                blurRadius: 6,
              )
            ],
          ),
          child: Column(
            children: [
              Row(
                children: [
                  for(int i = startDate.month; i< startDate.month+monthCount;i++)...[
                    if(i>12)...[
                      MonthBtn(btn: onBtn, btnOnOff: changeBtn, index: i - 12, width: 1050/monthCount, year: startDate.year+1),
                    ]else...[
                      MonthBtn(btn: onBtn, btnOnOff: changeBtn, index: i,width: 1050/monthCount, year: startDate.year),
                    ]
                  ]
                  // for(int i = 0;i<10;i++)...[
                  //   MonthBtn(btn: onBtn, btnOnOff: changeBtn, index: i+3,),
                  // ],
                  // for(int i = 0;i<2;i++)...[
                  //   MonthBtn(btn: onBtn, btnOnOff: changeBtn, index: i+1,),
                  // ]
                ],
              ),
              TableCalendar(
                onPageChanged: (change){
                  setState(() {
                    // onBtn = change.month;
                    nowMonth = change;
                  });
                },

                onDaySelected: (month, day){
                  widget.goSelectPage(day);
                },

                weekendDays: [],
                rowHeight: 65.w,
                firstDay: startDate,
                lastDay: endDate,
                focusedDay: nowMonth,
                startingDayOfWeek: StartingDayOfWeek.sunday,
                headerVisible: false,
                daysOfWeekHeight: 45.w,
                daysOfWeekStyle: DaysOfWeekStyle(
                  weekdayStyle: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 16.sp,
                    color: Color(0xff393838),
                  ),
                  weekendStyle: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 16.sp,
                    color: Color(0xff393838),
                  ),
                ),
                calendarStyle: CalendarStyle(
                  isTodayHighlighted: true,
                  outsideDaysVisible: false,
                  weekendDecoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xffE5E5E5),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x29646464),
                        offset: Offset(2, 2),
                        blurRadius: 3,
                      )
                    ],
                  ),
                  weekendTextStyle: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 16.sp,
                    color: Color(0xff393838),
                  ),
                  todayTextStyle: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 16.sp,
                    color: Color(0xff393838),
                  ),
                  todayDecoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xffE5D0FF),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x29646464),
                        offset: Offset(2, 2),
                        blurRadius: 3,
                      )
                    ],
                  ),

                  defaultDecoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xffE5E5E5),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x29646464),
                        offset: Offset(2, 2),
                        blurRadius: 3,
                      )
                    ],
                  ),
                  defaultTextStyle: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 16.sp,
                    color: Color(0xff393838),
                  )
                ),



              ),
            ],
          ),
        ),
      ],
    );
  }
}

class MonthBtn extends StatefulWidget {
  const MonthBtn({Key? key,
    required this.index,
    required this.btnOnOff,
    required this.btn,
    required this.width,
    required this.year,
  }) : super(key: key);
  final DateTime btn;
  final Function(int, int) btnOnOff;
  final int index;
  final double width;
  final int year;

  @override
  State<MonthBtn> createState() => _MonthBtnState();
}

class _MonthBtnState extends State<MonthBtn> {
  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: (){
        widget.btnOnOff(widget.index, widget.year);
      },
      child: Container(
        width: widget.width.w,
        height: 40.w,
        decoration: !(widget.btn.month == widget.index && widget.btn.year == widget.year) ? BoxDecoration(
          border: Border.all(width: 1, color: Color(0x4DC13BFD)),
          color: Color(0xffCAACF2),
        ):BoxDecoration(
            color: Color(0xffffffff)),
        child: Center(child: Text(widget.index.toString() + '월',
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 14.sp,
            color: Color(0xff393838),
          ),
        ),),
      ),
    );
  }
}
