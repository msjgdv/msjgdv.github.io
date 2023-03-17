import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:aligned_dialog/aligned_dialog.dart';


class ScheduleCalender extends StatefulWidget {
  const ScheduleCalender({
    Key? key,
    required this.changeDate,
    required this.nowDate,
    required this.events,
    required this.holiday,
    required this.getWeekData,
    required this.changeThisWeek,
    required this.getScheduleData,
    required this.getHolidayData,

  }) : super(key: key);
  final Function(DateTime) changeDate;
  final DateTime nowDate;
  final Map<DateTime, List<Event>> events;
  final Function(String) getScheduleData;
  final Function(String) getHolidayData;
  final Function(String) getWeekData;
  final Map<DateTime, bool> holiday;
  final Function() changeThisWeek;
  @override
  State<ScheduleCalender> createState() => _ScheduleCalenderState();
}

class _ScheduleCalenderState extends State<ScheduleCalender> {
  GlobalKey calenderSize = GlobalKey();
  GlobalKey inCalenderSize = GlobalKey();
  var _selectedDay;
  DateTime dateTime = DateTime.now();
  DateTime selectDate = DateTime.now();
  bool monthDialogOnOff = false;
  double pickDayBtn = 0.0;
  double calender = 424.w;
  var returnFormatter = DateFormat('yyyy-MM-dd');
  var formatter = DateFormat('yyyyMM');



  dialogOff(){
    setState(() {
      monthDialogOnOff = false;

    });
  }

  movePage(DateTime _dateTime) {
    setState(() {
      dateTime = _dateTime;
      selectDate = _dateTime;
    });
  }

  yearSet(int _year, int _month){
    setState(() {
      selectDate = DateTime(_year,_month,selectDate.day);
      dateTime = DateTime(_year,_month);
    });
  }
  _getSize(GlobalKey key, String xy) {
    if (key.currentContext != null) {
      final RenderBox renderBox =
      key.currentContext!.findRenderObject() as RenderBox;
      Size size = renderBox.size;
      if(xy == 'y'){
        return size.height;
      }else if(xy == 'x'){
        return size.width;
      }
    }
  }

  // Map<DateTime, List<Event>> events = {
  //   // DateTime.utc(2022,12,13) : [ Event('','',0) ],
  //   // DateTime.utc(2022,12,15) : [ Event('','',0) ],
  //   // DateTime.utc(2022,12,14) : [ Event('','',0) ],
  // };
  //
  // Map<DateTime, bool> holiday = {
  //   DateTime.utc(2023,1,14) : true,
  //   DateTime.utc(2023,1,15) : true,
  // };

  List<Event> _getEventsForDay(DateTime day) {
    return widget.events[day] ?? [];
  }
  bool _getHolidays(DateTime day){
    return widget.holiday[day] ?? false;
  }

  @override
  void initState() {
    dateTime = widget.nowDate;
    _selectedDay = widget.nowDate;
    selectDate = widget.nowDate;


    //추후 확인 요망
    Future.delayed(const Duration(milliseconds: 10), (){
      setState(() {
        pickDayBtn = (_getSize(calenderSize, 'x')! - 242.w)/2;
      });
    });

    // TODO: implement initState
    super.initState();
  }
  DateTime? rangeStartDay;
  DateTime? rangeEndDay;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: calenderSize,
      width: 364.w,
      height: 400.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20.w)),
        border: Border.all(color: Color(0xffFBB348), width: 1.w),
        color: Color(0xffFFEFD3),
      ),
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.only(left: 10.w, right: 10.w),
            child: TableCalendar(
              holidayPredicate: _getHolidays,
              eventLoader: _getEventsForDay,
              sixWeekMonthsEnforced: true,
              key: inCalenderSize,

              onPageChanged: (_dateTime) {

                widget.getScheduleData(formatter.format(_dateTime));
                widget.getHolidayData(formatter.format(_dateTime));
                widget.getWeekData(formatter.format(_dateTime));
                widget.changeThisWeek();
                // print(_dateTime);
                movePage(_dateTime);
              },
              daysOfWeekStyle: DaysOfWeekStyle(
                weekdayStyle: TextStyle(
                  fontSize: 15.sp,
                  color: Color(0xff393838),
                ),
                weekendStyle: TextStyle(
                  fontSize: 15.sp,
                  color: Color(0xff393838),
                ),
              ),
              startingDayOfWeek: StartingDayOfWeek.sunday,
              rowHeight: 50.w,
              daysOfWeekHeight: 24.w,
              focusedDay: dateTime,
              firstDay: DateTime(2000, 1, 1),
              lastDay: DateTime(2048, 5, 5),
              // headerVisible: false,
              headerStyle: HeaderStyle(
                  titleTextStyle: TextStyle(fontSize: 0.w),
                  formatButtonVisible: false,
                  titleCentered: true,
                  leftChevronVisible: true,
                  rightChevronVisible: true,
                  leftChevronIcon: Icon(
                    Icons.chevron_left,
                    size: 30.w,
                    color: Color(0xffFDB43B),
                  ),
                  rightChevronIcon: Icon(
                    Icons.chevron_right,
                    size: 30.w,
                    color: Color(0xffFDB43B),
                  ),
                  leftChevronPadding: EdgeInsets.only(
                      right: 0.w, left: 0.w, top: 10.w, bottom: 8.w),
                  rightChevronPadding: EdgeInsets.only(
                      right: 0.w, left: 0.w, top: 10.w, bottom: 8.w),
                  leftChevronMargin: EdgeInsets.only(left: 270.w, right: 0.w),
                  rightChevronMargin: EdgeInsets.only(right: 0.w, left: 0.w)),
              calendarStyle: CalendarStyle(
                markersMaxCount: 1,
                markersAutoAligned: true,
                  markerMargin: EdgeInsets.only(top: 0.w),
                  markerDecoration: BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle
                  ),
                  selectedTextStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 15.sp
                  ),
                  holidayDecoration: BoxDecoration(
                      shape: BoxShape.circle
                  ),
                  holidayTextStyle: TextStyle(
                      color: Colors.red,
                      fontSize: 15.sp
                  ),
                  defaultDecoration: BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  defaultTextStyle: TextStyle(
                    color: Color(0xff393838),
                    fontSize: 15.sp
                  ),
                  weekendTextStyle: TextStyle(
                    color: Color(0xff393838),
                      fontSize: 15.sp
                  ),
                  outsideDaysVisible: false,
                  todayDecoration: BoxDecoration(
                    color: Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                  todayTextStyle: TextStyle(
                      fontWeight: FontWeight.w400, color: Color(0xff393838),
                  fontSize: 15.sp)),
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {

                widget.changeDate(focusedDay);
                // dateTime = focusedDay;
                setState(() {
                  _selectedDay = selectedDay;
                  rangeStartDay =null;
                  rangeEndDay = null;
                });
              },

            ),
          ),
          Positioned(
            top: 10.w,
            left: 17.w,
            child: TextButton(
              onPressed: () {
                setState(() {
                  monthDialogOnOff = true;
                });

                showAlignedDialog(
                    offset: Offset(0.w, -60.w),
                    barrierColor: Colors.transparent,
                    context: context,
                    builder: (BuildContext context) {
                      return StatefulBuilder(
                        builder: (BuildContext context, StateSetter setState) {
                          return MonthDialog(dateTime: dateTime, nowYear: selectDate.year, yearSet: yearSet, monthOff: dialogOff,);
                        },
                      );
                    });
              },
              child: Row(
                children: [
                  Text(
                    getToday(selectDate),
                    style: TextStyle(
                      color: Color(0xff393838),
                      fontSize: 15.w,
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    width: 8.w,
                  ),
                  monthDialogOnOff == false ? Icon(
                    Icons.arrow_drop_down,
                    color: Color(0xffFDB43B),
                  ):Icon(
                    Icons.arrow_drop_up,
                    color: Color(0xffFDB43B),
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

class Event {
  int id;
  String type;
  String title;
  DateTime endDate;
  DateTime startDate;

  Event(this.title, this.type, this.id, this.endDate, this.startDate,);
}

String getToday(DateTime _dateTime) {
  var formatter = DateFormat('yyyy년 MM월');
  var strToday = formatter.format(_dateTime);
  return strToday;
}



class MonthDialog extends StatefulWidget {
  const MonthDialog({
    Key? key,
    required this.yearSet,
    required this.nowYear,
    required this.dateTime,
    required this.monthOff,
  }) : super(key: key);
  final Function(int, int) yearSet;
  final int nowYear;
  final DateTime dateTime;
  final Function monthOff;

  @override
  State<MonthDialog> createState() => _MonthDialogState();
}

class _MonthDialogState extends State<MonthDialog> {
  int year = 0;

  @override
  void initState() {
    year = widget.nowYear;
    // TODO: implement initState
    super.initState();
  }

  @override
  void deactivate() {
    widget.monthOff();
    // TODO: implement deactivate
    super.deactivate();
  }


  @override
  Widget build(BuildContext context) {
    return Dialog(
        elevation: 0.0,
        shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.all(Radius.circular(20.w))),
        child: Container(
          width: 327.w,
          height: 196.w,
          decoration: BoxDecoration(
            borderRadius:
            BorderRadius.all(Radius.circular(20.w)),
            color: Color(0xffffffff),
          ),
          child: Column(
            children: [
              SizedBox(
                height: 2.w,
              ),
              Row(
                children: [
                  SizedBox(
                    width: 2.w,
                  ),
                  IconButton(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onPressed: (){
                      setState(() {
                        year--;
                        // widget.yearSet(widget.nowYear - 1);
                      });
                    },
                    icon : Icon(Icons.chevron_left,
                      color: Color(0xffFDB43B),
                      size: 30.w,
                    ),
                  ),
                  Spacer(),
                  Text(year.toString(),
                    style: TextStyle(
                      color: Color(0xff393838),
                      fontSize: 12.w,
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Spacer(),
                  IconButton(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onPressed: (){
                      setState(() {
                        year++;
                        // widget.yearSet(widget.nowYear + 1);
                      });
                    },
                    icon: Icon(Icons.chevron_right,
                      color: Color(0xffFDB43B),
                      size: 30.w,),
                  ),
                  SizedBox(
                    width: 2.w,
                  )
                ],
              ),
              for(int i = 0; i<3; i++)...[
                Row(
                  children: [
                    for(int j = 0; j<4; j++)...[
                      ChoiceMonth(buttonOnOff: widget.dateTime, buttonNumber: (j * 1 + i * 4) + 1, year: widget.nowYear, yearSet: widget.yearSet, changeYear: year,),
                      if(j != 3)...[
                        Spacer(),
                      ]
                    ]
                  ],
                )

              ]
            ],
          ),
        )
    );
  }
}


class ChoiceMonth extends StatefulWidget {
  const ChoiceMonth({
    Key? key,
    required this.buttonOnOff,
    required this.buttonNumber,
    required this.year,
    required this.yearSet,
    required this.changeYear,

  }) : super(key: key);
  final DateTime buttonOnOff;
  final int buttonNumber;
  final int year;
  final int changeYear;
  final Function(int, int) yearSet;


  @override
  State<ChoiceMonth> createState() => _ChoiceMonthState();
}

class _ChoiceMonthState extends State<ChoiceMonth> {
  bool buttonOnOff = false;
  @override
  void initState() {
    if(widget.buttonOnOff.year == widget.year && widget.buttonOnOff.month == widget.buttonNumber){
      buttonOnOff = true;
    }else{
      buttonOnOff = false;
    }
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(12.w),
        child: buttonOnOff == false ? GestureDetector(
          onTap: (){
            widget.yearSet(widget.changeYear, widget.buttonNumber);
            Navigator.of(context).pop();
          },
          child: Text(
            widget.buttonNumber.toString()+'월',
            style: TextStyle(
              color: Color(0xff393838),
              fontSize: 12.w,
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),
        ):
        GestureDetector(
          onTap: (){

          },
          child: Container(
            width: 30.w,
            height: 30.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xffA666FB),
            ),
            child: Center(
              child: Text(
                widget.buttonNumber.toString()+'월',
                style: TextStyle(
                  color: Color(0xffffffff),
                  fontSize: 12.w,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        )
    );
  }
}
