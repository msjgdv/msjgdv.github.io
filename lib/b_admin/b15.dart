import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:treasure_map/provider/record_management.dart';
import 'package:treasure_map/widgets/api.dart';
import 'package:treasure_map/widgets/calendar.dart';
import 'package:treasure_map/widgets/custom_container.dart';
import 'package:treasure_map/widgets/schedule_calender.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../admin.dart';
import '../provider/app_management.dart';

//------------------------학사정보------------------------\\

class B15 extends StatefulWidget {
  const B15({
    Key? key,
    required this.notifyParent,
    required this.schoolYear,
    required this.schoolYearSetting,
  }) : super(key: key);
  final Function(double, double)? notifyParent;
  final int schoolYear;
  final Function(int) schoolYearSetting;

  @override
  State<B15> createState() => _B15State();
}

class _B15State extends State<B15> {
  GlobalKey globalkeyCK = GlobalKey();
  bool tap = true;
  int containerNumber = 0;

  // Timer timer = Timer.periodic(Duration(milliseconds: 1000), (timer) {});
  String calenderMonth = '';
  var format = DateFormat('yyyy-MM-dd');
  var dayFormat = DateFormat('yyyyMMdd');
  var monthFormat = DateFormat('yyyyMM');

  DateTime selectedDate = DateTime.now();

  int maxWeek = 0;

  List<List<TextEditingController>> newsController = [
    [
      TextEditingController(text: ''),
      TextEditingController(text: ''),
      TextEditingController(text: ''),
      TextEditingController(text: ''),
    ]
  ];
  List<List<TextEditingController>> commentController = [
    [
      TextEditingController(text: ''),
      TextEditingController(text: ''),
      TextEditingController(text: ''),
      TextEditingController(text: ''),
    ]
  ];

  changeDate(DateTime date) {
    setState(() {
      selectedDate = date;
      setContainer();
    });
  }

  changeThisWeek() {
    setState(() {
      newsController.clear();
      commentController.clear();
      thisWeek = 0;
      setContainer();
    });
  }

  bool check = false;
  List<bool> checkList = [];

  DateTime getSelectedDay() {
    return selectedDate;
  }

  void checkOnOff(int index, bool checked) {
    setState(() {
      checkList[index] = checked;
    });
  }

  tapTapBtn(bool onOff) {
    setState(() {
      tap = !onOff;
    });
  }

  containerNumberSet(int index) {
    setState(() {
      containerNumber = index;
    });
  }

  weekBtnTap(int index) {
    setState(() {
      thisWeek = index;
      for (int i = 0; i < maxWeek; i++) {
        weekTapBtn[i] = false;
      }
      weekTapBtn[index] = true;
      setContainer();
    });
  }

  Map<DateTime, List<Event>> events = {};
  Map<DateTime, List<Event>> legalEvents = {};
  Map<DateTime, List<Event>> kindergartenEvents = {};
  Map<DateTime, bool> holiday = {};
  List<List<WeekNews>> weekNews = [];
  List<bool> weekTapBtn = [];
  int thisWeek = 0;
  dynamic statisticsData;

  DateTime? scheduleStartDate;
  DateTime? scheduleEndDate;

  changeScheduleStartDate(DateTime _date){
    setState(() {
      scheduleStartDate = _date;
    });
  }

  changeScheduleEndDate(DateTime _date){
    setState(() {
      scheduleEndDate = _date;
    });
  }

  ApiUrl apiUrl = ApiUrl();

  getScheduleInfo(String yearMonth) async {
    http.Response res = await api('${apiUrl.scheduleKindergarten}/${widget.schoolYear}/$yearMonth', 'get', 'adminToken', {}, context);
    if(res.statusCode == 200){
      kindergartenEvents.clear();
      legalEvents.clear();
      events.clear();

      if (mounted) {
        setState(() {
          var responseBody = utf8.decode(res.bodyBytes);
          var list = jsonDecode(responseBody);
          print(list['kindergartenEvents']);

          for (int i = 0; i < list["events"].length; i++) {
            DateTime _startDate = DateTime.parse(
                list["events"][i]["startDate"] + " 00:00:00.000Z");
            int difference = int.parse(
                (DateTime.parse(list["events"][i]["endDate"]))
                    .difference(_startDate)
                    .inDays
                    .toString());
            for (int j = 0; j < difference + 1; j++) {
              if (legalEvents[_startDate] == null) {
                legalEvents[_startDate] = [
                  Event(
                      list["events"][i]["comment"],
                      list["events"][i]["type"],
                      0,
                      DateTime.parse(list["events"][i]["endDate"]),
                      DateTime.parse(list["events"][i]["startDate"]))
                ];
              } else {
                legalEvents[_startDate]!.add(Event(
                    list["events"][i]["comment"],
                    list["events"][i]["type"],
                    0,
                    DateTime.parse(list["events"][i]["endDate"]),
                    DateTime.parse(list["events"][i]["startDate"])));
              }
              if (events[_startDate] == null) {
                events[_startDate] = [
                  Event(
                      list["events"][i]["comment"],
                      list["events"][i]["type"],
                      0,
                      DateTime.parse(list["events"][i]["endDate"]),
                      DateTime.parse(list["events"][i]["startDate"]))
                ];
              } else {
                events[_startDate]!.add(Event(
                    list["events"][i]["comment"],
                    list["events"][i]["type"],
                    0,
                    DateTime.parse(list["events"][i]["endDate"]),
                    DateTime.parse(list["events"][i]["startDate"])));
              }
              _startDate = _startDate.add(const Duration(days: 1));
            }
          }
          for (int i = 0; i < list["kindergartenEvents"].length; i++) {
            DateTime _startDate = DateTime.parse(
                list["kindergartenEvents"][i]["startDate"] + " 00:00:00.000Z");
            int difference = int.parse(
                (DateTime.parse(list["kindergartenEvents"][i]["endDate"]))
                    .difference(_startDate)
                    .inDays
                    .toString());
            for (int j = 0; j < difference + 1; j++) {
              if (kindergartenEvents[_startDate] == null) {
                kindergartenEvents[_startDate] = [
                  Event(
                      list["kindergartenEvents"][i]["comment"],
                      list["kindergartenEvents"][i]["type"],
                      list["kindergartenEvents"][i]["id"],
                      DateTime.parse(list["kindergartenEvents"][i]["endDate"]),
                      DateTime.parse(
                          list["kindergartenEvents"][i]["startDate"]))
                ];
              } else {
                kindergartenEvents[_startDate]!.add(Event(
                    list["kindergartenEvents"][i]["comment"],
                    list["kindergartenEvents"][i]["type"],
                    list["kindergartenEvents"][i]["id"],
                    DateTime.parse(list["kindergartenEvents"][i]["endDate"]),
                    DateTime.parse(
                        list["kindergartenEvents"][i]["startDate"])));
              }
              if (events[_startDate] == null) {
                events[_startDate] = [
                  Event(
                      list["kindergartenEvents"][i]["comment"],
                      list["kindergartenEvents"][i]["type"],
                      list["kindergartenEvents"][i]["id"],
                      DateTime.parse(list["kindergartenEvents"][i]["endDate"]),
                      DateTime.parse(
                          list["kindergartenEvents"][i]["startDate"]))
                ];
              } else {
                events[_startDate]!.add(Event(
                    list["kindergartenEvents"][i]["comment"],
                    list["kindergartenEvents"][i]["type"],
                    list["kindergartenEvents"][i]["id"],
                    DateTime.parse(list["kindergartenEvents"][i]["endDate"]),
                    DateTime.parse(
                        list["kindergartenEvents"][i]["startDate"])));
              }
              _startDate = _startDate.add(const Duration(days: 1));
            }
          }

          setContainer();
        });
      }
    }
  }

  getWeekScheduleInfo(String yearMonth) async {
    http.Response res = await api('${apiUrl.scheduleWeek}/${widget.schoolYear}/$yearMonth', 'get', 'adminToken', {}, context);
    if(res.statusCode == 200){
      weekNews.clear();
      weekTapBtn.clear();
      newsController.clear();
      commentController.clear();
      if(mounted){
        setState(() {
          var responseBody = utf8.decode(res.bodyBytes);
          var list = jsonDecode(responseBody);
          maxWeek = list["maxWeek"];
          for (int i = 0; i < maxWeek; i++) {
            weekNews.add([]);
          }
          for (int i = 0; i < list['weekNews'].length; i++) {
            weekNews[list["weekNews"][i]["week"] - 1].add(WeekNews(
                list["weekNews"][i]["id"],
                list["weekNews"][i]["news"],
                list["weekNews"][i]["comment"]));
          }

          for (int i = 0; i < maxWeek; i++) {
            newsController.add([]);
            commentController.add([]);
            for (int j = 0; j < 4; j++) {
              if (weekNews[i].length >= 4) {
              } else {
                weekNews[i].add(WeekNews(0, "", ""));
              }
              newsController[i]
                  .add(TextEditingController(text: weekNews[i][j].news));
              commentController[i]
                  .add(TextEditingController(text: weekNews[i][j].comment));
            }
            if (i == thisWeek) {
              weekTapBtn.add(true);
            } else {
              weekTapBtn.add(false);
            }
          }
          setContainer();
        });
      }
    }
  }

  getHolidayInfo(String yearMonth) async {
    http.Response res = await api('${apiUrl.restday}/${widget.schoolYear}/$yearMonth', 'get', 'adminToken', {}, context);
    if(res.statusCode == 200){
      holiday.clear();
      if (mounted) {
        setState(() {
          var responseBody = utf8.decode(res.bodyBytes);
          var list = jsonDecode(responseBody);
          print(list);
          for (int i = 0; i < list['holidays'].length; i++) {
            holiday[DateTime.parse(list['holidays'][i] + " 00:00:00.000Z")] =
            true;
          }
          setContainer();
        });
      }
    }
  }

  postWeekSchedule(int id, String news, String comment, bool type) async {
    http.Response? res;
    if (id == 0) {
      if (type) {
        res = await api(apiUrl.scheduleWeek, 'post', 'adminToken', {
          "year": widget.schoolYear.toString(),
          "yearMonth": monthFormat.format(selectedDate),
          "week": (thisWeek + 1).toString(),
          "news": news,
        }, context);
      } else {
        res = await api(apiUrl.scheduleWeek, 'post', 'adminToken', {
          "year": widget.schoolYear.toString(),
          "yearMonth": monthFormat.format(selectedDate),
          "week": (thisWeek + 1).toString(),
          "comment": comment,
        }, context);
      }
    }else {
      if (news == '' && comment == '') {
        res = await api('${apiUrl.scheduleWeek}/$id', 'delete', 'adminToken', {}, context);
      } else {
        if (type) {
          res = await api(apiUrl.scheduleWeek, 'patch', 'adminToken', {
            "id": id.toString(),
            "news": news,
          }, context);

        } else {
          res = await api(apiUrl.scheduleWeek, 'patch', 'adminToken', {
            "id": id.toString(),
            "comment": comment,
          }, context);
        }
      }
    }

    if(res!.statusCode == 200){
      getWeekScheduleInfo(monthFormat.format(selectedDate));
      getHolidayInfo(monthFormat.format(selectedDate));
    }
  }

  getStatistics(int year) async {
    http.Response res = await api('${apiUrl.statistics}/$year', 'get', 'adminToken', {}, context);
    if(res.statusCode == 200){
      setState(() {
        var responseBody = utf8.decode(res.bodyBytes);
        var list = jsonDecode(responseBody);
        statisticsData = list;
        setContainer();
      });
    }

  }

  startSchedule(String _year, String _startDate, String _endDate) async{
    http.Response res = await api(apiUrl.schedule, 'post', 'adminToken', {
    "year" : _year,
    "startDate" : _startDate,
    "endDate" : _endDate
    }, context);
    if(res.statusCode == 200){
      setState(() {
        getWeekScheduleInfo(monthFormat.format(selectedDate));
        getHolidayInfo(monthFormat.format(selectedDate));
        getScheduleInfo(monthFormat.format(selectedDate));
        getStatistics(widget.schoolYear);
        getScheduleYears(context);

        setContainer();
      });
    }
  }

  setContainer() {
    setState(() {
      checkBtnContainer = [
        MonthSchedule(
          changeDate: changeDate,
          selectedDay: getSelectedDay,
          events: events,
          getScheduleData: getScheduleInfo,
          getHolidayData: getHolidayInfo,
          selectDay: selectedDate,
          holiday: holiday,
          weekNews: weekNews,
          maxWeek: maxWeek,
          weekBtnTap: weekBtnTap,
          weekTapBtn: weekTapBtn,
          thisWeek: thisWeek,
          commentsController: commentController,
          newsController: newsController,
          postWeekSchedule: postWeekSchedule,
          getWeekData: getWeekScheduleInfo,
          changeThisWeek: changeThisWeek,
          legalEvents: legalEvents,
          kindergartenEvents: kindergartenEvents,
          schoolYear: widget.schoolYear,
        ),
        YearSchedule(
          statisticsData: statisticsData,
        ),
      ];
    });
  }

  List<Widget> checkBtnContainer = [Container()];

  updateEvent() {
    return events;
  }

  @override
  initState() {
    if(Provider.of<UserInfo>(context, listen: false).schoolYears.contains(widget.schoolYear)){
      getWeekScheduleInfo(monthFormat.format(selectedDate));
      getHolidayInfo(monthFormat.format(selectedDate));
      getScheduleInfo(monthFormat.format(selectedDate));
      getStatistics(widget.schoolYear);
    }

    setContainer();

    String selectDate = format.format(selectedDate);
    selectedDate = DateTime.parse(selectDate + " 00:00:00.000Z");
    super.initState();
  }

  @override
  void dispose() {
    // timer.cancel();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 43.w,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 22.w,
              // child: Text(selectedDate.toString()),
            ),
            Container(
              width: 900.w,
              child: Row(
                children: [
                  if (Provider.of<UserInfo>(context, listen: false)
                      .schoolYears
                      .contains(widget.schoolYear)) ...[
                  Container(
                    width: 400.w,
                    height: 54.w,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.w),
                    ),
                    child: Stack(
                      children: [
                        AnimatedPositioned(
                            curve: Curves.fastOutSlowIn,
                            left: tap ? 0 : 200.w,
                            child: GestureDetector(
                              onTap: () {
                                tapTapBtn(tap);
                              },
                              child: Container(
                                width: 200.w,
                                height: 54.w,
                                decoration: BoxDecoration(
                                  color: Color(0xFFFED796),
                                  borderRadius: BorderRadius.circular(20.w),
                                ),
                              ),
                            ),
                            duration: Duration(milliseconds: 500)),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                if (!tap) {
                                  tapTapBtn(tap);
                                }
                                // timer.cancel();
                                // timer = Timer.periodic(
                                //     Duration(milliseconds: 500), (timer) {
                                //   containerNumberSet(0);
                                // });
                                containerNumberSet(0);
                                // containerNumber = 0;
                              },
                              child: Container(
                                width: 200.w,
                                height: 54.w,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20.w),
                                ),
                                child: Center(
                                  child: Text(
                                    "학사일정",
                                    style: TextStyle(
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xff393838),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                if (tap) {
                                  tapTapBtn(tap);
                                }
                                // timer.cancel();
                                // timer = Timer.periodic(
                                //     Duration(milliseconds: 500), (timer) {
                                //   containerNumberSet(1);
                                // });
                                containerNumberSet(1);
                                // containerNumber = 1;
                              },
                              child: Container(
                                width: 200.w,
                                height: 54.w,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20.w),
                                ),
                                child: Center(
                                  child: Text(
                                    "수업일수/교육일수",
                                    style: TextStyle(
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xff393838),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  Spacer(),
                  SchoolYearSettingWidget(
                    schoolYear: widget.schoolYear,
                    getFunction: () =>
                        getScheduleInfo(format.format(selectedDate)),
                    schoolYearSetting: widget.schoolYearSetting,
                  ),


                ]else...[

                  SizedBox(
                    width: 900.w,
                    height: 54.w,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(

                          child: SchoolYearSettingWidget(
                            schoolYear: widget.schoolYear,
                            getFunction: () =>
                                getScheduleInfo(format.format(selectedDate)),
                            schoolYearSetting: widget.schoolYearSetting,
                          ),
                        ),
                      ],
                    ),
                  )
                  ]
                ]
              ),
            ),
            if (Provider.of<UserInfo>(context, listen: false)
                .schoolYears
                .contains(widget.schoolYear)) ...[
              checkBtnContainer[containerNumber],
            ] else ...[
              SizedBox(
                height: 160.w,
              ),
              Column(
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 200.w,
                      ),
                      Column(
                        children: [
                          Text("학사일정 시작날짜 : ",style: TextStyle(
                            fontSize: 20.sp,
                            color: Color(0xff393838),
                          ),
                          ),
                          SizedBox(height: 30.w,),
                          Text("학사일정 종료날짜 : ",style: TextStyle(
                            fontSize: 20.sp,
                            color: Color(0xff393838),
                          ),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 30.w,
                      ),
                      Column(
                        children: [
                          SizedBox(height: 5.w,),
                          GestureDetector(
                            onTap: (){
                              showDialog(context: context, builder: (BuildContext context){
                                return AijoaCalendar(changeDate: changeScheduleStartDate, nowDate: DateTime.utc(widget.schoolYear,3,2));
                              });
                            },
                            child: Container(
                              width: 300.w,
                              height: 40.w,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(10.w)),
                                color: Colors.white,
                              ),
                                child: scheduleStartDate == null ? Center(
                                  child: Text("날짜를 설정해주세요.",
                                    style: TextStyle(
                                      fontSize: 20.sp,
                                      color: Color(0x88393838),
                                    ),
                                  ),
                                ):Center(
                                  child: Text(scheduleStartDate!.year.toString() +
                                      "년 " +
                                      scheduleStartDate!.month.toString()+
                                      "월 " +
                                      scheduleStartDate!.day.toString()+
                                      '일',
                                    style: TextStyle(
                                      fontSize: 20.sp,
                                      color: Color(0xff393838),
                                    ),
                                  ),
                                )

                            ),
                          ),
                          SizedBox(height: 20.w,),
                          GestureDetector(
                            onTap: (){
                              showDialog(context: context, builder: (BuildContext context){
                                return AijoaCalendar(changeDate: changeScheduleEndDate, nowDate: DateTime.utc(widget.schoolYear + 1,2,28));
                              });
                            },
                            child: Container(
                              width: 300.w,
                              height: 40.w,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(10.w)),
                                color: Colors.white,
                              ),

                              child: scheduleEndDate == null ? Center(
                                child: Text("날짜를 설정해주세요.",
                                  style: TextStyle(
                                    fontSize: 20.sp,
                                    color: Color(0x88393838),
                                  ),
                                ),
                              ):Center(
                                child: Text(scheduleEndDate!.year.toString() +
                                  "년 " +
                                  scheduleEndDate!.month.toString()+
                                  "월 " +
                                  scheduleEndDate!.day.toString()+
                                  '일',
                                  style: TextStyle(
                                    fontSize: 20.sp,
                                    color: Color(0xff393838),
                                  ),
                                ),
                              )
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    height: 50.w,
                  ),
                  Row(
                    children: [
                      SizedBox(width: 125.w,),
                      ElevatedButton(
                        onPressed: () {
                          if(scheduleStartDate == null && scheduleEndDate == null){
                            showToast("시작날짜와 종료날짜를 선택해주세요.");
                          }else if(scheduleStartDate == null){
                            showToast("시작날짜를 선택해주세요.");
                          }else if(scheduleEndDate == null){
                            showToast("종료날짜를 선택해주세요.");
                          }else{
                            startSchedule(widget.schoolYear.toString(), dayFormat.format(scheduleStartDate!), dayFormat.format(scheduleEndDate!));
                          }

                        },
                        child: Text('시작하기',
                            style: TextStyle(
                                fontSize: 20.sp, fontWeight: FontWeight.w400)),
                        style: ElevatedButton.styleFrom(
                            elevation: 1.0,
                            primary: const Color(0xFFFFFFFF),
                            onPrimary: const Color(0xFF393838),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.w)),
                            side: const BorderSide(color: Color(0xFFA666FB)),
                            fixedSize: Size(150.w, 50.w)),
                      ),
                    ],
                  ),
                ],
              )
            ]
          ],
        )
      ],
    );
  }
}

class MonthSchedule extends StatefulWidget {
  const MonthSchedule({
    Key? key,
    required this.changeDate,
    required this.selectedDay,
    required this.events,
    required this.selectDay,
    required this.holiday,
    required this.weekNews,
    required this.maxWeek,
    required this.thisWeek,
    required this.weekTapBtn,
    required this.weekBtnTap,
    required this.newsController,
    required this.commentsController,
    required this.postWeekSchedule,
    required this.getWeekData,
    required this.changeThisWeek,
    required this.legalEvents,
    required this.kindergartenEvents,
    required this.getHolidayData,
    required this.getScheduleData,
    required this.schoolYear,
  }) : super(key: key);
  final DateTime selectDay;
  final Function(DateTime) changeDate;
  final Function() selectedDay;
  final Map<DateTime, List<Event>> events;
  final Map<DateTime, List<Event>> kindergartenEvents;
  final Map<DateTime, List<Event>> legalEvents;
  final Function(String) getScheduleData;
  final Function(String) getHolidayData;
  final Function(String) getWeekData;
  final Map<DateTime, bool> holiday;
  final int maxWeek;
  final List<List<WeekNews>> weekNews;
  final Function(int) weekBtnTap;
  final List<bool> weekTapBtn;
  final int thisWeek;
  final List<List<TextEditingController>> newsController;
  final List<List<TextEditingController>> commentsController;
  final Function(int, String, String, bool) postWeekSchedule;
  final Function() changeThisWeek;
  final int schoolYear;

  @override
  State<MonthSchedule> createState() => _MonthScheduleState();
}

class _MonthScheduleState extends State<MonthSchedule> {
  int eventCount = 3;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 38.5.w,
        ),
        Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ScheduleCalender(
                  changeDate: widget.changeDate,
                  nowDate: DateTime.now(),
                  events: widget.events,
                  getScheduleData: widget.getScheduleData,
                  getHolidayData: widget.getHolidayData,
                  holiday: widget.holiday,
                  getWeekData: widget.getWeekData,
                  changeThisWeek: widget.changeThisWeek,
                ),
                SizedBox(
                  height: 20.w,
                ),
                Container(
                  height: 100.w,
                  width: 364.w,
                  child: ScrollConfiguration(
                    behavior:
                        const ScrollBehavior().copyWith(overscroll: false),
                    child: ListView(
                      padding: EdgeInsets.zero,
                        physics: const RangeMaintainingScrollPhysics(),
                        children: [
                          if (widget.legalEvents[widget.selectedDay()] !=
                              null) ...[
                            for (int i = 0;
                                i <
                                    widget.legalEvents[widget.selectedDay()]!
                                        .length;
                                i++) ...[
                              LegalEventText(
                                selectedDay: widget.selectedDay,
                                events: widget
                                    .legalEvents[widget.selectedDay()]![i],
                                restDayCheck:
                                    widget.holiday[widget.selectedDay()] == null
                                        ? false
                                        : true,
                              ),
                              SizedBox(
                                height: 20.w,
                              ),
                            ],
                          ],
                          if (widget.kindergartenEvents[widget.selectedDay()] !=
                              null) ...[
                            for (int i = 0;
                                i <
                                    widget
                                        .kindergartenEvents[
                                            widget.selectedDay()]!
                                        .length;
                                i++) ...[
                              DayEventText(
                                selectedDay: widget.selectedDay,
                                getHolidayData: widget.getHolidayData,
                                getScheduleData: widget.getScheduleData,
                                events: widget.kindergartenEvents[
                                    widget.selectedDay()]![i],
                                schoolYear: widget.schoolYear,
                              ),
                              SizedBox(
                                height: 20.w,
                              ),
                            ],
                          ],
                          GestureDetector(
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return ScheduleMemoDialog(
                                      selectedDay: widget.selectedDay,
                                      getScheduleData: widget.getScheduleData,
                                      getHolidayData: widget.getHolidayData,
                                      schoolYear: widget.schoolYear,
                                    );
                                  });
                            },
                            child: DottedBorder(
                              dashPattern: [10, 10],
                              strokeWidth: 2,
                              color: Color(0xFFFED796),
                              borderType: BorderType.RRect,
                              strokeCap: StrokeCap.round,
                              radius: Radius.circular(10.w),
                              borderPadding: EdgeInsets.all(0.w),
                              child: Container(
                                width: 364.w,
                                height: 40.w,
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.w)),
                                  // border: Border.all(color: Color(0xffA666FB), width: 1.w, style: BorderStyle.),
                                  color: Color(0xffffffff),
                                ),
                                child: Center(
                                  child: Container(
                                    width: 35.w,
                                    height: 35.w,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.w)),
                                      // border: Border.all(color: Color(0xffA666FB), width: 1.w),
                                      color: Color(0xffffffff),
                                    ),
                                    child: Center(
                                        child: Icon(
                                      Icons.add_outlined,
                                      color: Color(0xffA666FB),
                                      size: 25.w,
                                    )),
                                  ),
                                ),
                              ),
                            ),
                          )
                        ]),
                  ),
                )
              ],
            ),
            SizedBox(
              width: 60.w,
            ),
            WeekMainEvent(
              weekBtnTap: widget.weekBtnTap,
              weekTapBtn: widget.weekTapBtn,
              weekNews: widget.weekNews,
              thisWeek: widget.thisWeek,
              maxWeek: widget.maxWeek,
              commentsController: widget.commentsController,
              newsController: widget.newsController,
              postWeekSchedule: widget.postWeekSchedule,
            ),
          ],
        )
      ],
    );
  }
}

class LegalEventText extends StatefulWidget {
  const LegalEventText({
    Key? key,
    required this.selectedDay,
    required this.events,
    required this.restDayCheck,
  }) : super(key: key);
  final Function() selectedDay;
  final Event events;
  final bool restDayCheck;

  @override
  State<LegalEventText> createState() => _LegalEventTextState();
}

class _LegalEventTextState extends State<LegalEventText> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      height: 40.w,
      width: 364.w,
      child: Stack(
        children: [
          Row(
            children: [
              Container(
                width: 15.w,
                height: 40.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10.w)),
                  color: Color(0xffA666FB),
                ),
              ),
              SizedBox(
                width: 20.w,
              ),
              Container(
                height: 40.w,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      widget.events.title,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16.sp,
                        color: Color(0xff393838),
                      ),
                    ),
                  ],
                ),
              ),
              Spacer(),

              widget.events.type != '그외'
                  ? Container(
                      width: 50.w,
                      height: 40.w,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10.w)),
                          border: Border.all(
                              width: 1.w,
                              color: widget.restDayCheck
                                  ? Color(0xffFBB348)
                                  : Color(0x55FBB348)),
                          color: widget.restDayCheck
                              ? Color(0xffFED796)
                              : Color(0x55FED796),
                          boxShadow: [
                            widget.restDayCheck
                                ? BoxShadow(
                                    color: Color(0x297b7b7b),
                                    blurRadius: 6,
                                    offset: Offset(
                                        2, 2), // changes position of shadow
                                  )
                                : BoxShadow(
                                    color: Colors.transparent,
                                    blurRadius: 6,
                                    offset: Offset(
                                        2, 2), // changes position of shadow
                                  )
                          ]),
                      child: Center(
                        child: Text(
                          widget.events.type,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14.sp,
                            color: widget.restDayCheck
                                ? Color(0xff393838)
                                : Color(0x55393838),
                          ),
                        ),
                      ))
                  : Container(),
              // Container(
              //   height: 40.w,
              //   child: Column(
              //     mainAxisAlignment: MainAxisAlignment.start,
              //     children: [
              //       Text(
              //         widget.events.type == '그외' ? '' : widget.events.type,
              //         style: TextStyle(
              //           fontWeight: FontWeight.w500,
              //           fontSize: 12.sp,
              //           color: Color(0xff393838),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
            ],
          ),
        ],
      ),
    );
  }
}

class DayEventText extends StatefulWidget {
  const DayEventText({
    Key? key,
    required this.selectedDay,
    required this.events,
    required this.getHolidayData,
    required this.getScheduleData,
    required this.schoolYear,
  }) : super(key: key);
  final Function() selectedDay;
  final Function(String) getScheduleData;
  final Function(String) getHolidayData;
  final Event events;
  final int schoolYear;

  @override
  State<DayEventText> createState() => _DayEventTextState();
}

class _DayEventTextState extends State<DayEventText> {
  bool tapOn = false;
  static final autoLoginStorage = FlutterSecureStorage();
  var monthFormatter = DateFormat('yyyyMM');
  ApiUrl apiUrl = ApiUrl();

  deleteSchedule() async {
    http.Response res = await api(apiUrl.scheduleKindergarten + '/' + widget.events.id.toString(), 'delete', 'adminToken', {}, context);
    if(res.statusCode == 200){
      setState(() {
        widget.getScheduleData(monthFormatter.format(widget.selectedDay()));
        widget.getHolidayData(monthFormatter.format(widget.selectedDay()));
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          tapOn = !tapOn;
        });
      },
      child: Container(
        color: Colors.transparent,
        height: 40.w,
        width: 364.w,
        child: Stack(
          children: [
            Row(
              children: [
                Container(
                  width: 15.w,
                  height: 40.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10.w)),
                    color: Color(0xffA666FB),
                  ),
                ),
                SizedBox(
                  width: 20.w,
                ),
                Container(
                  height: 40.w,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        widget.events.title,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16.sp,
                          color: Color(0xff393838),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            if (tapOn) ...[
              Positioned(
                top: 2.5.w,
                right: 0.w,
                child: GestureDetector(
                  onTap: () {
                    deleteSchedule();
                  },
                  child: Container(
                    width: 35.w,
                    height: 35.w,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10.w)),
                        // border: Border.all(color: Color(0xffA666FB), width: 1.w),
                        color: Color(0xffffffff),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0x29B1B1B1),
                            blurRadius: 6,
                            offset: Offset(2, 2), // changes position of shadow
                          ),
                        ]),
                    child: Center(
                      child: SvgPicture.asset(
                        "assets/icons/icon_close_record.svg",
                        width: 20.w,
                      ),
                      //
                      // Text("삭제",
                      //   style: TextStyle(
                      //     fontSize: 14.sp,
                      //     fontWeight: FontWeight.w400,
                      //     color: Color(0xff393838),
                      //   ),),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 2.5.w,
                right: 40.w,
                child: GestureDetector(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return ScheduleMemoDialog(
                            selectedDay: widget.selectedDay,
                            getHolidayData: widget.getHolidayData,
                            getScheduleData: widget.getScheduleData,
                            scheduleId: widget.events.id,
                            type: widget.events.type,
                            comment: widget.events.title,
                            endDate: widget.events.endDate,
                            schoolYear: widget.schoolYear,
                          );
                        });
                  },
                  child: Container(
                    width: 35.w,
                    height: 35.w,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10.w)),
                        // border: Border.all(color: Color(0xffA666FB), width: 1.w),
                        color: Color(0xffffffff),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0x29B1B1B1),
                            blurRadius: 6,
                            offset: Offset(2, 2), // changes position of shadow
                          ),
                        ]),
                    child: Center(
                        child: Icon(
                      Icons.create,
                      color: Color(0xffA666FB),
                      size: 25.w,
                    )
                        // Text("수정",
                        // style: TextStyle(
                        //   fontSize: 14.sp,
                        //   fontWeight: FontWeight.w400,
                        //   color: Color(0xff393838),
                        // ),),
                        ),
                  ),
                ),
              ),
            ] else ...[
              widget.events.type != '그외'
                  ? Positioned(
                      right: 0.w,
                      child: Container(
                          width: 50.w,
                          height: 40.w,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.w)),
                              border: Border.all(
                                  width: 1.w, color: Color(0xffFBB348)),
                              color: Color(0xffFED796),
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0x297b7b7b),
                                  blurRadius: 6,
                                  offset: Offset(
                                      2, 2), // changes position of shadow
                                )
                              ]),
                          child: Center(
                            child: Text(
                              widget.events.type,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 14.sp,
                                color: Color(0xff393838),
                              ),
                            ),
                          )),
                    )
                  : Positioned(
                      right: 0.w,
                      child: Container(
                          width: 50.w,
                          height: 40.w,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.w)),
                              border: Border.all(
                                  width: 1.w, color: Color(0xffFBB348)),
                              color: Color(0xffFED796),
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0x297b7b7b),
                                  blurRadius: 6,
                                  offset: Offset(
                                      2, 2), // changes position of shadow
                                )
                              ]),
                          child: Center(
                            child: Text(
                              '등원',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 14.sp,
                                color: Color(0xff393838),
                              ),
                            ),
                          )),
                    )
            ]
          ],
        ),
      ),
    );
  }
}

class ScheduleMemoDialog extends StatefulWidget {
  const ScheduleMemoDialog({
    Key? key,
    required this.selectedDay,
    this.scheduleId = 0,
    this.type = '그외',
    this.comment = '',
    this.startDate = '',
    this.endDate = '',
    required this.getScheduleData,
    required this.getHolidayData,
    required this.schoolYear,
  }) : super(key: key);
  final Function() selectedDay;
  final Function(String) getScheduleData;
  final Function(String) getHolidayData;
  final int scheduleId;
  final String type;
  final String comment;
  final dynamic endDate;
  final dynamic startDate;
  final int schoolYear;

  @override
  State<ScheduleMemoDialog> createState() => _ScheduleMemoDialogState();
}

class _ScheduleMemoDialogState extends State<ScheduleMemoDialog> {
  static final autoLoginStorage = FlutterSecureStorage();
  List<String> weekDay = ["", "월", "화", "수", "목", "금", "토", "일"];
  bool enrollment = false;
  bool vacation = false;
  bool holiday = false;
  bool complete = false;
  bool graduation = false;
  String type = '그외';
  var formatter = DateFormat('yyyyMMdd');
  var monthFormatter = DateFormat('yyyyMM');
  TextEditingController textEditingController = TextEditingController();
  ApiUrl apiUrl = ApiUrl();

  postSchedule(String _year, String _startDate, String _endDate, String _type,
      String _comment) async {
    if (_comment == '' && _type == '그외') {
      Navigator.pop(context);
      return;
    }
    http.Response res;
    if (widget.scheduleId != 0) {
      if (_type == "그외" && _comment == "") {
        res = await api(apiUrl.scheduleKindergarten+ '/' +
            widget.scheduleId.toString(), 'delete', 'adminToken', {}, context);
      }else{
        res = await api(apiUrl.scheduleKindergarten, 'patch', 'adminToken', {
          "id": widget.scheduleId.toString(),
          "startDate": _startDate,
          "endDate": _endDate,
          "type": _type,
          "comment": _comment,
        }, context);
      }
    }else{
      res = await api(apiUrl.scheduleKindergarten, 'post', 'adminToken', {
        "year": _year,
        "startDate": _startDate,
        "endDate": _endDate,
        "type": _type,
        "comment": _comment,
      }, context);
    }
    if(res.statusCode == 200){
      setState(() {
        widget.getScheduleData(monthFormatter.format(widget.selectedDay()));
        widget.getHolidayData(monthFormatter.format(widget.selectedDay()));
        Navigator.pop(context);
      });
    }
  }

  buttonOnOff(String buttonName) {
    switch (buttonName) {
      case '시작':
        setState(() {
          enrollment = !enrollment;
          vacation = false;
          holiday = false;
          complete = false;
          graduation = false;
          if (enrollment) {
            type = '시작';
          } else {
            type = '그외';
          }
        });
        break;
      case '방학':
        setState(() {
          vacation = !vacation;
          enrollment = false;

          holiday = false;
          complete = false;
          graduation = false;
          if (vacation) {
            type = '방학';
          } else {
            type = '그외';
          }
        });
        break;
      case '휴원':
        setState(() {
          holiday = !holiday;
          enrollment = false;
          vacation = false;

          complete = false;
          graduation = false;
          if (holiday) {
            type = '휴원';
          } else {
            type = '그외';
          }
        });
        break;
      case '종료':
        setState(() {
          complete = !complete;
          enrollment = false;
          vacation = false;
          holiday = false;

          graduation = false;
          if (complete) {
            type = '종료';
          } else {
            type = '그외';
          }
        });
        break;

      default:
        break;
    }
  }

  changeStartDate(DateTime date) {
    setState(() {
      startDate = date;
    });
  }

  changeEndDate(DateTime date) {
    setState(() {
      endDate = date;
    });
  }

  DateTime? endDate;
  late DateTime startDate;

  @override
  void initState() {
    startDate = widget.selectedDay();
    if (widget.endDate == '') {
      endDate = null;
    } else {
      endDate = widget.endDate;
    }
    if (widget.type != '그외') {
      switch (widget.type) {
        case '시작':
          setState(() {
            enrollment = true;
            type = '시작';
          });
          break;
        case '방학':
          setState(() {
            vacation = true;
            type = '방학';
          });
          break;
        case '휴원':
          setState(() {
            holiday = true;
            type = '휴원';
          });
          break;
        case '종료':
          setState(() {
            complete = true;
            type = '종료';
          });
          break;
        // case '졸업':
        //   setState(() {
        //     graduation = true;
        //   });
        //   break;
        default:
          break;
      }
    }
    textEditingController.text = widget.comment;

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
        elevation: 0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.w))),
        child: GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
          child: Container(
            width: 800.w,
            height: 550.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20.w)),
              color: Color(0xffFCF9F4),
            ),
            child: ScrollConfiguration(
              behavior: const ScrollBehavior().copyWith(overscroll: false),
              child: ListView(
                padding: EdgeInsets.zero,
                physics: const RangeMaintainingScrollPhysics(),
                children: [
                  SizedBox(
                    height: 95.w,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 240.w,
                      ),
                      Text(
                        "시작날짜 :  ",
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff393838),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AijoaCalendar(
                                    changeDate: changeStartDate,
                                    nowDate: startDate);
                              });
                        },
                        child: Text(
                          startDate.year.toString() +
                              "년 " +
                              startDate.month.toString() +
                              "월 " +
                              startDate.day.toString() +
                              "일 " +
                              weekDay[startDate.weekday] +
                              "요일",
                          // '',
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w500,
                            color: Color(0xff393838),
                          ),
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AijoaCalendar(
                                changeDate: changeEndDate, nowDate: startDate);
                          });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 240.w,
                        ),
                        Text(
                          "끝날짜     :  ",
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w500,
                            color: Color(0xff393838),
                          ),
                        ),
                        Text(
                          widget.endDate == ''
                              ? endDate == null
                                  ? '                                               '
                                  : endDate!.year.toString() +
                                      "년 " +
                                      endDate!.month.toString() +
                                      "월 " +
                                      endDate!.day.toString() +
                                      "일 " +
                                      weekDay[endDate!.weekday] +
                                      "요일"
                              : endDate!.year.toString() +
                                  "년 " +
                                  endDate!.month.toString() +
                                  "월 " +
                                  endDate!.day.toString() +
                                  "일 " +
                                  weekDay[endDate!.weekday] +
                                  "요일",
                          // '',
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w500,
                            color: Color(0xff393838),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10.w,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 100.w,
                      ),
                      SizedBox(
                        width: 600.w,
                        height: 45.w,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ScheduleMemoButton(
                                onOff: enrollment,
                                buttonName: '시작',
                                buttonOn: buttonOnOff),
                            ScheduleMemoButton(
                                onOff: vacation,
                                buttonName: '방학',
                                buttonOn: buttonOnOff),
                            ScheduleMemoButton(
                                onOff: holiday,
                                buttonName: '휴원',
                                buttonOn: buttonOnOff),
                            ScheduleMemoButton(
                                onOff: complete,
                                buttonName: '종료',
                                buttonOn: buttonOnOff),
                            // ScheduleMemoButton(
                            //     onOff: graduation,
                            //     buttonName: '졸업',
                            //     buttonOn: buttonOnOff),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 100.w,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30.w,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 100.w,
                      ),
                      Container(
                        width: 600.w,
                        height: 160.w,
                        decoration: BoxDecoration(
                          border:
                              Border.all(width: 1.w, color: Color(0xffFBB348)),
                          color: Color(0xffffffff),
                        ),
                        child: TextField(
                          controller: textEditingController,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 20.sp,
                            color: Color(0xff393838),
                          ),
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            counterText: '',
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                            ), //외곽선
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 100.w,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 54.w,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          postSchedule(
                              widget.schoolYear.toString(),
                              formatter.format(startDate),
                              endDate == null
                                  ? formatter.format(widget.selectedDay())
                                  : formatter.format(endDate!),
                              type,
                              textEditingController.text);
                        },
                        child: Text('저장',
                            style: TextStyle(
                                fontSize: 20.sp, fontWeight: FontWeight.w400)),
                        style: ElevatedButton.styleFrom(
                            elevation: 1.0,
                            primary: const Color(0xFFFFFFFF),
                            onPrimary: const Color(0xFF393838),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.w)),
                            side: const BorderSide(color: Color(0xFFA666FB)),
                            fixedSize: Size(150.w, 50.w)),
                      ),
                      SizedBox(
                        width: 50.w,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context); //result 반영 dialog 종료
                        },
                        child: Text('취소',
                            style: TextStyle(
                                fontSize: 20.sp, fontWeight: FontWeight.w400)),
                        style: ElevatedButton.styleFrom(
                            elevation: 1.0,
                            primary: const Color(0xFFFFFFFF),
                            onPrimary: const Color(0xFF393838),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.w)),
                            side: const BorderSide(color: Color(0xFFA666FB)),
                            fixedSize: Size(150.w, 50.w)),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ));
  }
}

class ScheduleMemoButton extends StatefulWidget {
  const ScheduleMemoButton({
    Key? key,
    required this.onOff,
    required this.buttonName,
    required this.buttonOn,
  }) : super(key: key);
  final String buttonName;
  final bool onOff;
  final Function(String) buttonOn;

  @override
  State<ScheduleMemoButton> createState() => _ScheduleMemoButtonState();
}

class _ScheduleMemoButtonState extends State<ScheduleMemoButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          setState(() {
            widget.buttonOn(widget.buttonName);
            // enrollment = !enrollment;
          });
        },
        child: Container(
            width: 130.w,
            height: 45.w,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10.w)),
                border: Border.all(width: 1.w, color: Color(0xffFBB348)),
                color: widget.onOff ? Color(0xffE9BF7A) : Color(0xffFED796),
                boxShadow: [
                  widget.onOff
                      ? BoxShadow(
                          color: Colors.white,
                          blurRadius: 6,
                          offset: Offset(2, 2), // changes position of shadow
                        )
                      : BoxShadow(
                          color: Color(0x297b7b7b),
                          blurRadius: 6,
                          offset: Offset(2, 2), // changes position of shadow
                        )
                ]),
            child: widget.onOff
                ? Stack(
                    children: [
                      Positioned(
                          top: 5.w,
                          left: 5.w,
                          child: Container(
                            width: 130.w,
                            height: 40.w,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(13.w)),
                              color: Color(0xffFED796),
                            ),
                          )),
                      Center(
                        child: Text(
                          widget.buttonName,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 20.sp,
                            color: Color(0xff393838),
                          ),
                        ),
                      )
                    ],
                  )
                : Center(
                    child: Text(
                      widget.buttonName,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 20.sp,
                        color: Color(0xff393838),
                      ),
                    ),
                  )));
  }
}

class WeekMainEvent extends StatefulWidget {
  const WeekMainEvent({
    Key? key,
    required this.weekBtnTap,
    required this.weekTapBtn,
    required this.weekNews,
    required this.thisWeek,
    required this.maxWeek,
    required this.commentsController,
    required this.newsController,
    required this.postWeekSchedule,

  }) : super(key: key);
  final Function(int) weekBtnTap;
  final List<bool> weekTapBtn;
  final List<List<WeekNews>> weekNews;
  final int thisWeek;
  final int maxWeek;
  final List<List<TextEditingController>> newsController;
  final List<List<TextEditingController>> commentsController;
  final Function(int, String, String, bool) postWeekSchedule;


  @override
  State<WeekMainEvent> createState() => _WeekMainEventState();
}

class _WeekMainEventState extends State<WeekMainEvent> {
  List<FocusNode> textFieldFocus = [
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
    FocusNode(),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 478.w,
      height: 520.w,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              for (int i = 0; i < widget.maxWeek; i++) ...[
                WeekButton(
                    tapOn: widget.weekTapBtn[i],
                    weekNumber: i,
                    tapButton: widget.weekBtnTap)
              ],
              if (widget.maxWeek == 0) ...[
                SizedBox(
                  height: 40.w,
                )
              ]
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CustomContainer(
                cTotalHeight: 54.w,
                cTotalWidth: 160.w,
                cBorderColor: Color(0xffFDB43B),
                cInsideColor: Color(0xffFED796),
                childWidget: Center(
                  child: Text(
                    "주요행사",
                    style: TextStyle(
                        fontSize: 18.w,
                        fontWeight: FontWeight.w500,
                        color: Color(0xff393838)),
                  ),
                ),
              ),
              CustomContainer(
                cTotalHeight: 54.w,
                cTotalWidth: 318.w,
                cBorderColor: Color(0xffFDB43B),
                cInsideColor: Color(0xffFED796),
                cLeftBorderWidth: 1.w,
                cBorderRadius:
                    BorderRadius.only(topRight: Radius.circular(10.w)),
                childWidget: Center(
                  child: Text(
                    "소개글",
                    style: TextStyle(
                        fontSize: 18.w,
                        fontWeight: FontWeight.w500,
                        color: Color(0xff393838)),
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              CustomContainer(
                cTotalHeight: 100.w,
                cTotalWidth: 160.w,
                cBorderColor: Color(0xffFDB43B),
                cInsideColor: Color(0xffffffff),
                cTopBorderWidth: 1.w,
                cLeftBorderWidth: 1.w,
                childWidget: Center(
                  child: Focus(
                    focusNode: textFieldFocus[0],
                    onFocusChange: (hasFocus) {
                      if (hasFocus) {
                      } else {
                        if (widget.weekNews[widget.thisWeek][0].news ==
                            widget.newsController[widget.thisWeek][0].text) {
                        } else {
                          widget.postWeekSchedule(
                              widget.weekNews[widget.thisWeek][0].id,
                              widget.newsController[widget.thisWeek][0].text,
                              widget
                                  .commentsController[widget.thisWeek][0].text,
                              true);
                        }
                      }
                    },
                    child: widget.newsController.isNotEmpty
                        ? TextField(
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                              ), //외곽선
                            ),
                            controller: widget.newsController[widget.thisWeek]
                                [0],
                            style: TextStyle(
                                fontSize: 18.w,
                                fontWeight: FontWeight.w500,
                                color: Color(0xff393838)),
                          )
                        : Text(""),
                  ),
                ),
              ),
              CustomContainer(
                cTotalHeight: 100.w,
                cTotalWidth: 318.w,
                cBorderColor: Color(0xffFDB43B),
                cInsideColor: Color(0xffffffff),
                cTopBorderWidth: 1.w,
                cLeftBorderWidth: 1.w,
                cRightBorderWidth: 1.w,
                childWidget: Center(
                  child: Focus(
                    focusNode: textFieldFocus[1],
                    onFocusChange: (hasFocus) {
                      if (hasFocus) {
                      } else {
                        if (widget.weekNews[widget.thisWeek][0].comment ==
                            widget
                                .commentsController[widget.thisWeek][0].text) {
                        } else {
                          widget.postWeekSchedule(
                              widget.weekNews[widget.thisWeek][0].id,
                              widget.newsController[widget.thisWeek][0].text,
                              widget
                                  .commentsController[widget.thisWeek][0].text,
                              false);
                        }
                      }
                    },
                    child: widget.newsController.length != 0
                        ? TextField(
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                              ), //외곽선
                            ),
                            controller:
                                widget.commentsController[widget.thisWeek][0],
                            style: TextStyle(
                                fontSize: 18.w,
                                fontWeight: FontWeight.w500,
                                color: Color(0xff393838)),
                          )
                        : Text(''),
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              CustomContainer(
                cTotalHeight: 100.w,
                cTotalWidth: 160.w,
                cBorderColor: Color(0xffFDB43B),
                cInsideColor: Color(0xffffffff),
                cTopBorderWidth: 1.w,
                cLeftBorderWidth: 1.w,
                childWidget: Center(
                  child: Focus(
                    focusNode: textFieldFocus[2],
                    onFocusChange: (hasFocus) {
                      if (hasFocus) {
                      } else {
                        if (widget.weekNews[widget.thisWeek][1].news ==
                            widget.newsController[widget.thisWeek][1].text) {
                        } else {
                          widget.postWeekSchedule(
                              widget.weekNews[widget.thisWeek][1].id,
                              widget.newsController[widget.thisWeek][1].text,
                              widget
                                  .commentsController[widget.thisWeek][1].text,
                              true);
                        }
                      }
                    },
                    child: widget.newsController.isNotEmpty
                        ? TextField(
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                              ), //외곽선
                            ),
                            controller: widget.newsController[widget.thisWeek]
                                [1],
                            style: TextStyle(
                                fontSize: 18.w,
                                fontWeight: FontWeight.w500,
                                color: Color(0xff393838)),
                          )
                        : Text(''),
                  ),
                ),
              ),
              CustomContainer(
                cTotalHeight: 100.w,
                cTotalWidth: 318.w,
                cBorderColor: Color(0xffFDB43B),
                cInsideColor: Color(0xffffffff),
                cTopBorderWidth: 1.w,
                cLeftBorderWidth: 1.w,
                cRightBorderWidth: 1.w,
                childWidget: Center(
                  child: Focus(
                    focusNode: textFieldFocus[3],
                    onFocusChange: (hasFocus) {
                      if (hasFocus) {
                      } else {
                        if (widget.weekNews[widget.thisWeek][1].comment ==
                            widget
                                .commentsController[widget.thisWeek][1].text) {
                        } else {
                          widget.postWeekSchedule(
                              widget.weekNews[widget.thisWeek][1].id,
                              widget.newsController[widget.thisWeek][1].text,
                              widget
                                  .commentsController[widget.thisWeek][1].text,
                              false);
                        }
                      }
                    },
                    child: widget.newsController.length != 0
                        ? TextField(
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                              ), //외곽선
                            ),
                            controller:
                                widget.commentsController[widget.thisWeek][1],
                            style: TextStyle(
                                fontSize: 18.w,
                                fontWeight: FontWeight.w500,
                                color: Color(0xff393838)),
                          )
                        : Text(''),
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              CustomContainer(
                cTotalHeight: 100.w,
                cTotalWidth: 160.w,
                cBorderColor: Color(0xffFDB43B),
                cInsideColor: Color(0xffffffff),
                cTopBorderWidth: 1.w,
                cLeftBorderWidth: 1.w,
                childWidget: Center(
                  child: Focus(
                    focusNode: textFieldFocus[4],
                    onFocusChange: (hasFocus) {
                      if (hasFocus) {
                      } else {
                        if (widget.weekNews[widget.thisWeek][2].news ==
                            widget.newsController[widget.thisWeek][2].text) {
                        } else {
                          widget.postWeekSchedule(
                              widget.weekNews[widget.thisWeek][2].id,
                              widget.newsController[widget.thisWeek][2].text,
                              widget
                                  .commentsController[widget.thisWeek][2].text,
                              true);
                        }
                      }
                    },
                    child: widget.newsController.length != 0
                        ? TextField(
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                              ), //외곽선
                            ),
                            controller: widget.newsController[widget.thisWeek]
                                [2],
                            style: TextStyle(
                                fontSize: 18.w,
                                fontWeight: FontWeight.w500,
                                color: Color(0xff393838)),
                          )
                        : Text(''),
                  ),
                ),
              ),
              CustomContainer(
                cTotalHeight: 100.w,
                cTotalWidth: 318.w,
                cBorderColor: Color(0xffFDB43B),
                cInsideColor: Color(0xffffffff),
                cTopBorderWidth: 1.w,
                cLeftBorderWidth: 1.w,
                cRightBorderWidth: 1.w,
                childWidget: Center(
                  child: Focus(
                    focusNode: textFieldFocus[5],
                    onFocusChange: (hasFocus) {
                      if (hasFocus) {
                      } else {
                        if (widget.weekNews[widget.thisWeek][2].comment ==
                            widget
                                .commentsController[widget.thisWeek][2].text) {
                        } else {
                          widget.postWeekSchedule(
                              widget.weekNews[widget.thisWeek][2].id,
                              widget.newsController[widget.thisWeek][2].text,
                              widget
                                  .commentsController[widget.thisWeek][2].text,
                              false);
                        }
                      }
                    },
                    child: widget.newsController.length != 0
                        ? TextField(
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                              ), //외곽선
                            ),
                            controller:
                                widget.commentsController[widget.thisWeek][2],
                            style: TextStyle(
                                fontSize: 18.w,
                                fontWeight: FontWeight.w500,
                                color: Color(0xff393838)),
                          )
                        : Text(""),
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              CustomContainer(
                cTotalHeight: 100.w,
                cTotalWidth: 160.w,
                cBorderColor: Color(0xffFDB43B),
                cInsideColor: Color(0xffffffff),
                cBorderRadius:
                    BorderRadius.only(bottomLeft: Radius.circular(10.w)),
                cTopBorderWidth: 1.w,
                cLeftBorderWidth: 1.w,
                cBottomBorderWidth: 1.w,
                childWidget: Center(
                  child: Focus(
                    focusNode: textFieldFocus[6],
                    onFocusChange: (hasFocus) {
                      if (hasFocus) {
                      } else {
                        if (widget.weekNews[widget.thisWeek][3].news ==
                            widget.newsController[widget.thisWeek][3].text) {
                        } else {
                          widget.postWeekSchedule(
                              widget.weekNews[widget.thisWeek][3].id,
                              widget.newsController[widget.thisWeek][3].text,
                              widget
                                  .commentsController[widget.thisWeek][3].text,
                              true);
                        }
                      }
                    },
                    child: widget.newsController.length != 0
                        ? TextField(
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                              ), //외곽선
                            ),
                            controller: widget.newsController[widget.thisWeek]
                                [3],
                            style: TextStyle(
                                fontSize: 18.w,
                                fontWeight: FontWeight.w500,
                                color: Color(0xff393838)),
                          )
                        : Text(''),
                  ),
                ),
              ),
              CustomContainer(
                cTotalHeight: 100.w,
                cTotalWidth: 318.w,
                cBorderColor: Color(0xffFDB43B),
                cInsideColor: Color(0xffffffff),
                cBorderRadius:
                    BorderRadius.only(bottomRight: Radius.circular(10.w)),
                cTopBorderWidth: 1.w,
                cLeftBorderWidth: 1.w,
                cRightBorderWidth: 1.w,
                cBottomBorderWidth: 1.w,
                childWidget: Center(
                  child: Focus(
                    focusNode: textFieldFocus[7],
                    onFocusChange: (hasFocus) {
                      if (hasFocus) {
                      } else {
                        if (widget.weekNews[widget.thisWeek][3].comment ==
                            widget
                                .commentsController[widget.thisWeek][3].text) {
                        } else {
                          widget.postWeekSchedule(
                              widget.weekNews[widget.thisWeek][3].id,
                              widget.newsController[widget.thisWeek][3].text,
                              widget
                                  .commentsController[widget.thisWeek][3].text,
                              false);
                        }
                      }
                    },
                    child: widget.newsController.length != 0
                        ? TextField(
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                              ), //외곽선
                            ),
                            controller:
                                widget.commentsController[widget.thisWeek][3],
                            style: TextStyle(
                                fontSize: 18.w,
                                fontWeight: FontWeight.w500,
                                color: Color(0xff393838)),
                          )
                        : Text(''),
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

class WeekButton extends StatefulWidget {
  const WeekButton({
    Key? key,
    required this.tapOn,
    required this.weekNumber,
    required this.tapButton,
  }) : super(key: key);
  final bool tapOn;
  final int weekNumber;
  final Function(int) tapButton;

  @override
  State<WeekButton> createState() => _WeekButtonState();
}

class _WeekButtonState extends State<WeekButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!widget.tapOn) {
          widget.tapButton(widget.weekNumber);
        }
      },
      child: CustomContainer(
        cBorderRadius: BorderRadius.only(
            topRight: Radius.circular(10.w), topLeft: Radius.circular(10.w)),
        cRightBorderWidth: widget.tapOn ? 0 : 1.w,
        cLeftBorderWidth: widget.tapOn ? 0 : 1.w,
        cTopBorderWidth: widget.tapOn ? 0 : 1.w,
        cTotalWidth: 60.w,
        cTotalHeight: 40.w,
        cInsideColor: widget.tapOn ? Color(0xffFED796) : Color(0xffFFEFD3),
        cBorderColor: widget.tapOn ? Color(0xffFED796) : Color(0xffFDB43B),
        childWidget: Center(
          child: Text(
            (widget.weekNumber + 1).toString() + "주차",
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14.sp,
              color: Color(0xff393838),
            ),
          ),
        ),
      ),
    );
  }
}

class YearSchedule extends StatefulWidget {
  const YearSchedule({
    Key? key,
    required this.statisticsData,
  }) : super(key: key);
  final dynamic statisticsData;

  @override
  State<YearSchedule> createState() => _YearScheduleState();
}

class _YearScheduleState extends State<YearSchedule> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 20.w,
        ),
        YearTable(
          statisticsData: widget.statisticsData,
        ),
      ],
    );
  }
}

class YearTable extends StatefulWidget {
  const YearTable({
    Key? key,
    required this.statisticsData,
  }) : super(key: key);
  final dynamic statisticsData;

  @override
  State<YearTable> createState() => _YearTableState();
}

class _YearTableState extends State<YearTable> {
  List<int> days = [];
  List<int> teachDays = [];
  List<int> holidays = [];
  List<int> saturdays = [];
  List<int> sundays = [];
  List<int> legalHolidays = [];
  List<int> temporaryHoliday = [];
  List<List<String>> comment = [];

  @override
  void initState() {
    days.clear();
    int firstSemesterDays = 0;
    int secondSemesterDays = 0;
    int firstSemesterTeachDays = 0;
    int secondSemesterTeachDays = 0;
    int firstSemesterHolidays = 0;
    int secondSemesterHolidays = 0;
    int firstSemesterSaturdays = 0;
    int secondSemesterSaturdays = 0;
    int firstSemesterSundays = 0;
    int secondSemesterSundays = 0;
    int firstSemesterLegalHolidays = 0;
    int secondSemesterLegalHolidays = 0;
    int firstSemesterTemporaryHoliday = 0;
    int secondSemesterTemporaryHoliday = 0;
    for (int i = 0; i < widget.statisticsData.length; i++) {
      if (widget.statisticsData[i]["semester"] == 1) {
        firstSemesterDays =
            (firstSemesterDays + widget.statisticsData[i]["days"]) as int;
        firstSemesterTeachDays = (firstSemesterTeachDays +
            widget.statisticsData[i]["days"] -
            widget.statisticsData[i]["holidays"]) as int;
        firstSemesterHolidays = (firstSemesterHolidays +
            widget.statisticsData[i]["holidays"]) as int;
        firstSemesterSaturdays = (firstSemesterSaturdays +
            widget.statisticsData[i]["saturdays"]) as int;
        firstSemesterSundays =
            (firstSemesterSundays + widget.statisticsData[i]["sundays"]) as int;
        firstSemesterLegalHolidays = (firstSemesterLegalHolidays +
            widget.statisticsData[i]["officalRestdays"]) as int;
        firstSemesterTemporaryHoliday = (firstSemesterTemporaryHoliday +
            widget.statisticsData[i]["temporaryRestdays"]) as int;
      }
      if (widget.statisticsData[i]["semester"] == 2) {
        secondSemesterDays =
            (secondSemesterDays + widget.statisticsData[i]["days"]) as int;
        secondSemesterTeachDays = (secondSemesterTeachDays +
            widget.statisticsData[i]["days"] -
            widget.statisticsData[i]["holidays"]) as int;
        secondSemesterHolidays = (secondSemesterHolidays +
            widget.statisticsData[i]["holidays"]) as int;
        secondSemesterSaturdays = (secondSemesterSaturdays +
            widget.statisticsData[i]["saturdays"]) as int;
        secondSemesterSundays = (secondSemesterSundays +
            widget.statisticsData[i]["sundays"]) as int;
        secondSemesterLegalHolidays = (secondSemesterLegalHolidays +
            widget.statisticsData[i]["officalRestdays"]) as int;
        secondSemesterTemporaryHoliday = (secondSemesterTemporaryHoliday +
            widget.statisticsData[i]["temporaryRestdays"]) as int;
      }
      days.add(widget.statisticsData[i]["days"]);
      teachDays.add(widget.statisticsData[i]["days"] -
          widget.statisticsData[i]["holidays"]);
      holidays.add(widget.statisticsData[i]["holidays"]);
      saturdays.add(widget.statisticsData[i]["saturdays"]);
      sundays.add(widget.statisticsData[i]["sundays"]);
      legalHolidays.add(widget.statisticsData[i]["officalRestdays"]);
      temporaryHoliday.add(widget.statisticsData[i]["temporaryRestdays"]);
      comment.add(widget.statisticsData[i]["comments"].cast<String>());
      if (i == 5) {
        days.add(firstSemesterDays);
        teachDays.add(firstSemesterTeachDays);
        holidays.add(firstSemesterHolidays);
        saturdays.add(firstSemesterSaturdays);
        sundays.add(firstSemesterSundays);
        legalHolidays.add(firstSemesterLegalHolidays);
        temporaryHoliday.add(firstSemesterTemporaryHoliday);
        comment.add(['']);
      }
      if (i == 11) {
        days.add(secondSemesterDays);
        teachDays.add(secondSemesterTeachDays);
        holidays.add(secondSemesterHolidays);
        saturdays.add(secondSemesterSaturdays);
        sundays.add(secondSemesterSundays);
        legalHolidays.add(secondSemesterLegalHolidays);
        temporaryHoliday.add(secondSemesterTemporaryHoliday);
        comment.add(['']);
      }
    }
    days.add(firstSemesterDays + secondSemesterDays);
    teachDays.add(firstSemesterTeachDays + secondSemesterTeachDays);
    holidays.add(firstSemesterHolidays + secondSemesterHolidays);
    saturdays.add(firstSemesterSaturdays + secondSemesterSaturdays);
    sundays.add(firstSemesterSundays + secondSemesterSundays);
    legalHolidays.add(firstSemesterLegalHolidays + secondSemesterLegalHolidays);
    temporaryHoliday
        .add(firstSemesterTemporaryHoliday + secondSemesterTemporaryHoliday);
    comment.add(['']);

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Column(
              children: [
                CustomContainer(
                    cBorderRadius:
                        BorderRadius.only(topLeft: Radius.circular(10.w)),
                    cInsideColor: Color(0xffFED796),
                    cBorderColor: Color(0xffFDB43B),
                    cTotalHeight: 50.w,
                    cTotalWidth: 80.w,
                    childWidget: Stack(
                      children: [
                        CustomPaint(
                          size: Size(80.w, 50.w),
                          painter: MyPainter(
                              lineStart: Offset(3.w, 3.w),
                              lineEnd: Offset(80.w, 50.w)),
                        ),
                        Positioned(
                            top: 4.w,
                            right: 9.w,
                            child: YearTableTextStyle(
                              text: '학기',
                            )),
                        Positioned(
                            bottom: 4.w,
                            left: 9.w,
                            child: YearTableTextStyle(
                              text: '요일',
                            )),
                      ],
                    )),
                CustomContainer(
                  cInsideColor: Color(0xffFED796),
                  cBorderColor: Color(0xffFDB43B),
                  cTopBorderWidth: 1.w,
                  cTotalHeight: 50.w,
                  cTotalWidth: 80.w,
                  childWidget: Center(
                    child: YearTableTextStyle(text: '월'),
                  ),
                )
              ],
            ),
            Column(
              children: [
                CustomContainer(
                  cInsideColor: Color(0xffFED796),
                  cBorderColor: Color(0xffFDB43B),
                  cLeftBorderWidth: 1.w,
                  cTotalHeight: 50.w,
                  cTotalWidth: 392.w,
                  childWidget: Center(
                      child: YearTableTextStyle(
                    text: '1',
                  )),
                ),
                Row(
                  children: [
                    for (int i = 3; i < 10; i++) ...[
                      CustomContainer(
                        cInsideColor: Color(0xffffffff),
                        cBorderColor: Color(0xffFDB43B),
                        cLeftBorderWidth: 1.w,
                        cTopBorderWidth: 1.w,
                        cTotalHeight: 50.w,
                        cTotalWidth: 56.w,
                        childWidget: Center(
                            child: YearTableTextStyle(
                          text: (i == 9 ? '계' : i).toString(),
                        )),
                      ),
                    ],
                  ],
                )
              ],
            ),
            Column(
              children: [
                CustomContainer(
                  cInsideColor: Color(0xffFED796),
                  cBorderColor: Color(0xffFDB43B),
                  cLeftBorderWidth: 1.w,
                  cTotalHeight: 50.w,
                  cTotalWidth: 392.w,
                  childWidget: Center(
                      child: YearTableTextStyle(
                    text: '2',
                  )),
                ),
                Row(
                  children: [
                    for (int i = 9; i < 16; i++) ...[
                      CustomContainer(
                        cInsideColor: Color(0xffffffff),
                        cBorderColor: Color(0xffFDB43B),
                        cLeftBorderWidth: 1.w,
                        cTopBorderWidth: 1.w,
                        cTotalHeight: 50.w,
                        cTotalWidth: 56.w,
                        childWidget: Center(
                            child: YearTableTextStyle(
                          text: ((i % 12 == 0 ? 12 : i % 12) == 3
                                  ? '계'
                                  : (i % 12 == 0 ? 12 : i % 12))
                              .toString(),
                        )),
                      ),
                    ],
                  ],
                )
              ],
            ),
            CustomContainer(
              cInsideColor: Color(0xffFED796),
              cBorderColor: Color(0xffFDB43B),
              cBorderRadius: BorderRadius.only(topRight: Radius.circular(10.w)),
              cLeftBorderWidth: 1.w,
              cTotalHeight: 100.w,
              cTotalWidth: 56.w,
              childWidget: Center(
                  child: YearTableTextStyle(
                text: '총계',
              )),
            ),
          ],
        ),
        Row(
          children: [
            CustomContainer(
              cInsideColor: Color(0xffFED796),
              cBorderColor: Color(0xffFDB43B),
              cTopBorderWidth: 1.w,
              cTotalHeight: 50.w,
              cTotalWidth: 80.w,
              childWidget: Center(
                child: YearTableTextStyle(text: '일수'),
              ),
            ),
            for (int i = 0; i < 15; i++) ...[
              CustomContainer(
                cInsideColor: Color(0xffffffff),
                cBorderColor: Color(0xffFDB43B),
                cLeftBorderWidth: 1.w,
                cTopBorderWidth: 1.w,
                cRightBorderWidth: i == 14 ? 1.w : 0,
                cTotalHeight: 50.w,
                cTotalWidth: 56.w,
                childWidget: Center(
                    child: YearTableTextStyle(
                  text: days[i].toString(),
                )),
              ),
            ],
          ],
        ),
        Row(
          children: [
            CustomContainer(
              cInsideColor: Color(0xffFED796),
              cBorderColor: Color(0xffFDB43B),
              cTopBorderWidth: 1.w,
              cTotalHeight: 50.w,
              cTotalWidth: 80.w,
              childWidget: Center(
                child: YearTableTextStyle(text: '수업일수'),
              ),
            ),
            for (int i = 0; i < 15; i++) ...[
              CustomContainer(
                cInsideColor: Color(0xffffffff),
                cBorderColor: Color(0xffFDB43B),
                cLeftBorderWidth: 1.w,
                cTopBorderWidth: 1.w,
                cRightBorderWidth: i == 14 ? 1.w : 0,
                cTotalHeight: 50.w,
                cTotalWidth: 56.w,
                childWidget: Center(
                    child: YearTableTextStyle(
                  text: teachDays[i].toString(),
                )),
              ),
            ],
          ],
        ),
        Row(
          children: [
            CustomContainer(
              cInsideColor: Color(0xffFED796),
              cBorderColor: Color(0xffFDB43B),
              cTopBorderWidth: 1.w,
              cTotalHeight: 50.w,
              cTotalWidth: 80.w,
              childWidget: Center(
                child: YearTableTextStyle(text: '휴일수'),
              ),
            ),
            for (int i = 0; i < 15; i++) ...[
              CustomContainer(
                cInsideColor: Color(0xffffffff),
                cBorderColor: Color(0xffFDB43B),
                cLeftBorderWidth: 1.w,
                cTopBorderWidth: 1.w,
                cRightBorderWidth: i == 14 ? 1.w : 0,
                cTotalHeight: 50.w,
                cTotalWidth: 56.w,
                childWidget: Center(
                    child: YearTableTextStyle(
                  text: holidays[i].toString(),
                )),
              ),
            ],
          ],
        ),
        Row(
          children: [
            CustomContainer(
              cInsideColor: Color(0xffFED796),
              cBorderColor: Color(0xffFDB43B),
              cTopBorderWidth: 1.w,
              cTotalHeight: 200.w,
              cTotalWidth: 30.w,
              childWidget: Center(
                child: YearTableTextStyle(text: '휴\n일\n일\n수'),
              ),
            ),
            Column(
              children: [
                CustomContainer(
                  cInsideColor: Color(0xffFED796),
                  cBorderColor: Color(0xffFDB43B),
                  cTopBorderWidth: 1.w,
                  cLeftBorderWidth: 1.w,
                  cTotalHeight: 50.w,
                  cTotalWidth: 50.w,
                  childWidget: Center(
                    child: YearTableTextStyle(text: '토요일'),
                  ),
                ),
                CustomContainer(
                  cInsideColor: Color(0xffFED796),
                  cBorderColor: Color(0xffFDB43B),
                  cTopBorderWidth: 1.w,
                  cLeftBorderWidth: 1.w,
                  cTotalHeight: 50.w,
                  cTotalWidth: 50.w,
                  childWidget: Center(
                    child: YearTableTextStyle(text: '일요일'),
                  ),
                ),
                CustomContainer(
                  cInsideColor: Color(0xffFED796),
                  cBorderColor: Color(0xffFDB43B),
                  cTopBorderWidth: 1.w,
                  cLeftBorderWidth: 1.w,
                  cTotalHeight: 50.w,
                  cTotalWidth: 50.w,
                  childWidget: Center(
                    child: YearTableTextStyle(text: '공휴일'),
                  ),
                ),
                CustomContainer(
                  cInsideColor: Color(0xffFED796),
                  cBorderColor: Color(0xffFDB43B),
                  cTopBorderWidth: 1.w,
                  cLeftBorderWidth: 1.w,
                  cTotalHeight: 50.w,
                  cTotalWidth: 50.w,
                  childWidget: Center(
                    child: YearTableTextStyle(text: '임시\n휴업일'),
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Row(
                  children: [
                    for (int i = 0; i < 15; i++) ...[
                      CustomContainer(
                        cInsideColor: Color(0xffffffff),
                        cBorderColor: Color(0xffFDB43B),
                        cLeftBorderWidth: 1.w,
                        cTopBorderWidth: 1.w,
                        cRightBorderWidth: i == 14 ? 1.w : 0,
                        cTotalHeight: 50.w,
                        cTotalWidth: 56.w,
                        childWidget: Center(
                            child: YearTableTextStyle(
                          text: saturdays[i].toString(),
                        )),
                      ),
                    ],
                  ],
                ),
                Row(
                  children: [
                    for (int i = 0; i < 15; i++) ...[
                      CustomContainer(
                        cInsideColor: Color(0xffffffff),
                        cBorderColor: Color(0xffFDB43B),
                        cLeftBorderWidth: 1.w,
                        cTopBorderWidth: 1.w,
                        cRightBorderWidth: i == 14 ? 1.w : 0,
                        cTotalHeight: 50.w,
                        cTotalWidth: 56.w,
                        childWidget: Center(
                            child: YearTableTextStyle(
                          text: sundays[i].toString(),
                        )),
                      ),
                    ],
                  ],
                ),
                Row(
                  children: [
                    for (int i = 0; i < 15; i++) ...[
                      CustomContainer(
                        cInsideColor: Color(0xffffffff),
                        cBorderColor: Color(0xffFDB43B),
                        cLeftBorderWidth: 1.w,
                        cTopBorderWidth: 1.w,
                        cRightBorderWidth: i == 14 ? 1.w : 0,
                        cTotalHeight: 50.w,
                        cTotalWidth: 56.w,
                        childWidget: Center(
                            child: YearTableTextStyle(
                          text: legalHolidays[i].toString(),
                        )),
                      ),
                    ],
                  ],
                ),
                Row(
                  children: [
                    for (int i = 0; i < 15; i++) ...[
                      CustomContainer(
                        cInsideColor: Color(0xffffffff),
                        cBorderColor: Color(0xffFDB43B),
                        cLeftBorderWidth: 1.w,
                        cTopBorderWidth: 1.w,
                        cRightBorderWidth: i == 14 ? 1.w : 0,
                        cTotalHeight: 50.w,
                        cTotalWidth: 56.w,
                        childWidget: Center(
                            child: YearTableTextStyle(
                          text: temporaryHoliday[i].toString(),
                        )),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ],
        ),
        Row(
          children: [
            CustomContainer(
              cInsideColor: Color(0xffFED796),
              cBorderColor: Color(0xffFDB43B),
              cBorderRadius:
                  BorderRadius.only(bottomLeft: Radius.circular(10.w)),
              cTopBorderWidth: 1.w,
              cTotalHeight: 100.w,
              cTotalWidth: 80.w,
              childWidget: Center(
                child: YearTableTextStyle(text: '비고'),
              ),
            ),
            for (int i = 0; i < 15; i++) ...[
              if (i == 14) ...[
                CustomContainer(
                    cInsideColor: Color(0xffffffff),
                    cBorderColor: Color(0xffFDB43B),
                    cBorderRadius:
                        BorderRadius.only(bottomRight: Radius.circular(10.w)),
                    cRightBorderWidth: 1.w,
                    cLeftBorderWidth: 1.w,
                    cTopBorderWidth: 1.w,
                    cBottomBorderWidth: 1.w,
                    cTotalHeight: 100.w,
                    cTotalWidth: 56.w,
                    childWidget: ScrollConfiguration(
                      behavior:
                          const ScrollBehavior().copyWith(overscroll: false),
                      child: ListView(
                        padding: EdgeInsets.zero,
                        physics: const RangeMaintainingScrollPhysics(),
                        children: [
                          for (int j = 0; j < comment[i].length; j++) ...[
                            YearTableTextStyle(
                              text: comment[i][j],
                            ),
                          ]
                        ],
                      ),
                    )),
              ] else ...[
                CustomContainer(
                    cInsideColor: Color(0xffffffff),
                    cBorderColor: Color(0xffFDB43B),
                    cLeftBorderWidth: 1.w,
                    cTopBorderWidth: 1.w,
                    cBottomBorderWidth: 1.w,
                    cTotalHeight: 100.w,
                    cTotalWidth: 56.w,
                    childWidget: ScrollConfiguration(
                      behavior:
                          const ScrollBehavior().copyWith(overscroll: false),
                      child: ListView(
                        padding: EdgeInsets.zero,
                        physics: const RangeMaintainingScrollPhysics(),
                        children: [
                          for (int j = 0; j < comment[i].length; j++) ...[
                            YearTableTextStyle(
                              text: comment[i][j],
                            ),
                          ]
                        ],
                      ),
                    )),
              ]
            ],
          ],
        ),
      ],
    );
  }
}

class MyPainter extends CustomPainter {
  const MyPainter({
    Key? key,
    required this.lineEnd,
    required this.lineStart,
  });

  final Offset lineStart;
  final Offset lineEnd;

  @override
  void paint(Canvas canvas, Size size) {
    final p1 = lineStart;
    final p2 = lineEnd;
    final paint = Paint()
      ..color = Color(0xffFDB43B)
      ..strokeWidth = 1.w
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(p1, p2, paint);
  }

  @override
  bool shouldRepaint(CustomPainter old) {
    return true;
  }
}

class YearTableTextStyle extends StatefulWidget {
  const YearTableTextStyle({
    Key? key,
    required this.text,
  }) : super(key: key);
  final String text;

  @override
  State<YearTableTextStyle> createState() => _YearTableTextStyleState();
}

class _YearTableTextStyleState extends State<YearTableTextStyle> {
  @override
  Widget build(BuildContext context) {
    return Text(
      widget.text,
      style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 14.sp,
          color: Color(0xff393838)),
      textAlign: TextAlign.center,
    );
  }
}

class WeekNews {
  int id;
  String? news;
  String? comment;

  WeekNews(
    this.id,
    this.news,
    this.comment,
  );
}
