import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:treasure_map/widgets/api.dart';
import 'package:treasure_map/widgets/custom_container.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:treasure_map/widgets/overtab.dart';
import 'package:provider/provider.dart';
import '../provider/app_management.dart';
import 'package:http/http.dart' as http;
import 'd3_2.dart';

///관찰기록 리스트

class D3_1 extends StatefulWidget {
  const D3_1({
    Key? key,
    required this.nextPage,
    required this.prePage,
    required this.nowPage,
    this.scaffoldKey,
    required this.nowDate,
    this.routhPage,
    required this.changePage,
  }) : super(key: key);
  final Function nextPage;
  final Function prePage;
  final String nowPage;
  final GlobalKey<ScaffoldState>? scaffoldKey;
  final DateTime nowDate;
  final Function(Widget)? routhPage;
  final Function(int) changePage;

  @override
  State<D3_1> createState() => _D3_1State();
}

class _D3_1State extends State<D3_1> {
  bool dateOff = false;

  DateTime pageTime = DateTime.now();
  String pageTimeStr = '';
  var formatter = DateFormat('yyyyMMdd');

  receiveData(DateTime dateTime) async {
    pageTime = dateTime;
    pageTimeStr = formatter.format(pageTime);
    setState(() {});
  }

  newRecord() async {
    ApiUrl apiUrl = ApiUrl();
    http.Response res = await api(apiUrl.record, 'post', 'signInToken', {
      'date': pageTimeStr,
      'cid': Provider.of<UserInfo>(context, listen: false).value[0]
    }, context);
    if(res.statusCode == 200){
      var recordRB = utf8.decode(res.bodyBytes);
      var recordData = jsonDecode(recordRB);
      widget.routhPage!(D3_2(
        nextPage: widget.nextPage,
        prePage: widget.prePage,
        nowPage: widget.nowPage,
        scaffoldKey: widget.scaffoldKey,
        recordId: recordData['id'],
        routePage: widget.routhPage,
        changePage:widget.changePage,
      ));
    }
  }

  @override
  initState() {
    super.initState();
    pageTimeStr = formatter.format(widget.nowDate);
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
                        height: 420.w,
                        decoration: BoxDecoration(
                          color: const Color(0xffFCFCFC),
                        ),
                      ),
                      RecordTable(
                        thisRecord: newRecord,
                        nowDate: widget.nowDate,
                        routhPage: widget.routhPage,
                        nextPage: widget.nextPage,
                        prePage: widget.prePage,
                        scaffoldKey: widget.scaffoldKey,
                        nowPage: widget.nowPage,
                        changePage: widget.changePage,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 40.w,
                  ),
                  Row(
                    children: [
                      Container(
                        width: 39.w,
                        height: 40.w,
                        decoration: BoxDecoration(
                          color: const Color(0xffFCFCFC),
                        ),
                      ),
                      SizedBox(
                        width: 469.w,
                      ),
                      GestureDetector(
                        onTap: () {
                          newRecord();
                          // widget.routhPage!(D3_2(nextPage: widget.nextPage, prePage: widget.prePage, nowPage: widget.nowPage,scaffoldKey: widget.scaffoldKey,));
                        },
                        child: Container(
                          width: 108.w,
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
                              '관찰기록작성',
                              style: TextStyle(
                                  color: Color(0xff7649B7),
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14.sp),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        width: 39.w,
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

class RecordTable extends StatefulWidget {
  const RecordTable({
    Key? key,
    required this.thisRecord,
    required this.nowDate,
    required this.routhPage,
    required this.nextPage,
    required this.scaffoldKey,
    required this.nowPage,
    required this.prePage,
    required this.changePage,
  }) : super(key: key);
  final Function thisRecord;
  final DateTime nowDate;
  final Function(Widget)? routhPage;
  final Function nextPage;
  final Function prePage;
  final String nowPage;
  final GlobalKey<ScaffoldState>? scaffoldKey;
  final Function(int) changePage;

  @override
  State<RecordTable> createState() => _RecordTableState();
}

class _RecordTableState extends State<RecordTable> {
  Color borderColor = const Color(0x9dC13BFD);
  List<String> weekDay = ["", "월요일", "화요일", "수요일", "목요일", "금요일", "토요일", "일요일"];
  var recordDateData;
  var formatter = DateFormat('yyyyMMdd');
  String pageTimeStr = '';

  getDayRecord() async {
    ApiUrl apiUrl = ApiUrl();

    http.Response recordDateRes = await api(
        apiUrl.recordDate +
            '/' +
            pageTimeStr +
            '/' +
            Provider.of<UserInfo>(context, listen: false).value[0].toString(),
        'get',
        'signInToken',
        {},
        context);

    if (recordDateRes.statusCode == 200) {
      setState(() {
        var recordDateRB = utf8.decode(recordDateRes.bodyBytes);
        recordDateData = jsonDecode(recordDateRB);
      });

    }
  }

  @override
  void initState() {
    super.initState();
    pageTimeStr = formatter.format(widget.nowDate);
    getDayRecord();

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1053.w,
      height: 420.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(20.w), topLeft: Radius.circular(20.w)),
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
                cInsideColor: Color(0xffE5D0FE),
                cTopBorderWidth: 1.w,
                cLeftBorderWidth: 1.w,
                childWidget: Center(
                  child: RecordTableTextStyle(
                    text:
                    Provider.of<UserInfo>(context).value[2] +
                        "의 관찰기록 목록",
                    title: true,
                  ),
                ),
              ),
              CustomContainer(
                cBorderColor: borderColor,
                cTotalHeight: 50.w,
                cTotalWidth: 500.w,
                cBorderRadius:
                    BorderRadius.only(topRight: Radius.circular(20.w)),
                cInsideColor: Color(0xffCAACF2),
                cTopBorderWidth: 1.w,
                cLeftBorderWidth: 1.w,
                cRightBorderWidth: 1.w,
                childWidget: Center(
                  child: RecordTableTextStyle(
                    text: widget.nowDate.year.toString() +
                        '년 ' +
                        widget.nowDate.month.toString() +
                        '월 ' +
                        widget.nowDate.day.toString() +
                        '일 ' +
                        weekDay[widget.nowDate.weekday],
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
                cTotalHeight: 40.w,
                cTotalWidth: 90.w,
                cInsideColor: Color(0xffCAACF2),
                cTopBorderWidth: 1.w,
                cLeftBorderWidth: 1.w,
                cRightBorderWidth: 1.w,
                cBottomBorderWidth: 1.w,
                childWidget: Center(
                  child: RecordTableTextStyle(
                    text: "번호",
                    title: true,
                  ),
                ),
              ),
              CustomContainer(
                cBorderColor: borderColor,
                cTotalHeight: 40.w,
                cTotalWidth: 213.w,
                cInsideColor: Color(0xffCAACF2),
                cTopBorderWidth: 1.w,
                cRightBorderWidth: 1.w,
                cBottomBorderWidth: 1.w,
                childWidget: Center(
                  child: RecordTableTextStyle(
                    text: "놀이주제",
                    title: true,
                  ),
                ),
              ),
              CustomContainer(
                cBorderColor: borderColor,
                cTotalHeight: 40.w,
                cTotalWidth: 350.w,
                cInsideColor: Color(0xffCAACF2),
                cTopBorderWidth: 1.w,
                cRightBorderWidth: 1.w,
                cBottomBorderWidth: 1.w,
                childWidget: Center(
                  child: RecordTableTextStyle(
                    text: "관찰유아",
                    title: true,
                  ),
                ),
              ),
              CustomContainer(
                cBorderColor: borderColor,
                cTotalHeight: 40.w,
                cTotalWidth: 300.w,
                cInsideColor: Color(0xffCAACF2),
                cTopBorderWidth: 1.w,
                cRightBorderWidth: 1.w,
                cBottomBorderWidth: 1.w,
                childWidget: Center(
                  child: RecordTableTextStyle(
                    text: "유아관심",
                    title: true,
                  ),
                ),
              ),
              CustomContainer(
                cBorderColor: borderColor,
                cTotalHeight: 40.w,
                cTotalWidth: 100.w,
                cInsideColor: Color(0xffCAACF2),
                cTopBorderWidth: 1.w,
                cRightBorderWidth: 1.w,
                cBottomBorderWidth: 1.w,
                childWidget: Center(
                  child: RecordTableTextStyle(
                    text: "관찰자",
                    title: true,
                  ),
                ),
              ),
            ],
          ),
          CustomContainer(
              cBorderColor: borderColor,
              cTotalHeight: 330.w,
              cTotalWidth: 1052.w,
              cInsideColor: Colors.white,
              cBorderRadius: BorderRadius.only(
                  // bottomRight: Radius.circular(20.w),
                  // bottomLeft: Radius.circular(20.w)
                  ),
              cLeftBorderWidth: 1.w,
              cRightBorderWidth: 1.w,
              cBottomBorderWidth: 1.w,
              childWidget: ScrollConfiguration(
                behavior: const ScrollBehavior().copyWith(overscroll: false),
                child: ListView(
                  padding: EdgeInsets.zero,
                  physics: const RangeMaintainingScrollPhysics(),
                  children: [
                    if (recordDateData != null) ...[
                      for (int i = 0; i < recordDateData.length; i++) ...[
                        RecordTableRow(
                          number: i,
                          children: recordDateData[i]["children"] ?? '',
                          subject: recordDateData[i]["subject"] ?? '',
                          interest: recordDateData[i]['interest'] ?? '',
                          writer: recordDateData[i]['writer'] ?? '',
                          id: recordDateData[i]['id'],
                          routhPage: widget.routhPage,
                          nextPage: widget.nextPage,
                          prePage: widget.prePage,
                          scaffoldKey: widget.scaffoldKey,
                          nowPage: widget.nowPage,
                          changePage: widget.changePage,
                        ),
                      ]
                    ]
                  ],
                ),
              )),
        ],
      ),
    );
  }
}

class RecordTableTextStyle extends StatefulWidget {
  const RecordTableTextStyle({
    Key? key,
    required this.text,
    required this.title,
    this.holiday = false,
    this.textAlign = TextAlign.center,
    this.maxLine = 2,
  }) : super(key: key);
  final String text;
  final bool title;
  final bool holiday;
  final TextAlign textAlign;
  final int maxLine;

  @override
  State<RecordTableTextStyle> createState() => _RecordTableTextStyleState();
}

class _RecordTableTextStyleState extends State<RecordTableTextStyle> {


  @override
  Widget build(BuildContext context) {
    return Text(
      widget.text,
      textAlign: widget.textAlign,
        maxLines: widget.maxLine,
      softWrap: true,
      style: TextStyle(
          fontSize: 14.sp,
          fontWeight: widget.title ? FontWeight.w500 : FontWeight.w400,
          color: widget.holiday ?  Colors.red : const Color(0xff393838)),
    );
  }
}

class RecordTableContentTextStyle extends StatefulWidget {
  const RecordTableContentTextStyle({
    Key? key,
    required this.text,
  }) : super(key: key);
  final String text;

  @override
  State<RecordTableContentTextStyle> createState() =>
      _RecordTableContentTextStyleState();
}

class _RecordTableContentTextStyleState
    extends State<RecordTableContentTextStyle> {
  @override
  Widget build(BuildContext context) {
    return Text(
      widget.text,
      textAlign: TextAlign.start,
      style: TextStyle(
          fontSize: 20.sp,
          fontWeight: FontWeight.w400,
          color: const Color(0xff393838)),
    );
  }
}

class RecordTableRow extends StatefulWidget {
  const RecordTableRow({
    Key? key,
    required this.number,
    required this.subject,
    required this.children,
    required this.interest,
    required this.writer,
    required this.id,
    required this.routhPage,
    required this.prePage,
    required this.nowPage,
    required this.scaffoldKey,
    required this.nextPage,
    required this.changePage,
  }) : super(key: key);
  final int number;
  final String subject;
  final String children;
  final String interest;
  final String writer;
  final int id;
  final Function(Widget)? routhPage;
  final Function nextPage;
  final Function prePage;
  final String nowPage;
  final GlobalKey<ScaffoldState>? scaffoldKey;
  final Function(int) changePage;


  @override
  State<RecordTableRow> createState() => _RecordTableRowState();
}

class _RecordTableRowState extends State<RecordTableRow> {
  Color borderColor = const Color(0x9dC13BFD);

  // Color borderColor = Colors.transparent;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.routhPage!(D3_2(
          nextPage: widget.nextPage,
          prePage: widget.prePage,
          nowPage: widget.nowPage,
          scaffoldKey: widget.scaffoldKey,
          recordId: widget.id,
          changePage: widget.changePage,

        ));
      },
      child: Container(
        width: 1050.w,
        height: 40.w,
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
            color: Color(0x29B1B1B1),
            blurRadius: 6,
            offset: Offset(2, 2),
          )
        ]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            CustomContainer(
              cBorderColor: borderColor,
              cTotalHeight: 40.w,
              cTotalWidth: 89.w,
              cInsideColor: Color(0xffffffff),
              // cInsideColor: Colors.transparent,
              cRightBorderWidth: 1.w,
              cBottomBorderWidth: 1.w,
              childWidget: Center(
                child: RecordTableTextStyle(
                  text: widget.number.toString(),
                  title: false,
                ),
              ),
            ),
            CustomContainer(
              cBorderColor: borderColor,
              cTotalHeight: 40.w,
              cTotalWidth: 213.w,
              cInsideColor: Color(0xffffffff),
              // cInsideColor: Colors.transparent,
              cRightBorderWidth: 1.w,
              cBottomBorderWidth: 1.w,
              childWidget: Center(
                child: RecordTableTextStyle(
                  text: widget.subject,
                  title: false,
                ),
              ),
            ),
            CustomContainer(
              cBorderColor: borderColor,
              cTotalHeight: 40.w,
              cTotalWidth: 350.w,
              cInsideColor: Color(0xffffffff),
              cRightBorderWidth: 1.w,
              cBottomBorderWidth: 1.w,
              childWidget: Center(
                child: RecordTableTextStyle(
                  text: widget.children,
                  title: false,
                ),
              ),
            ),
            CustomContainer(
              cBorderColor: borderColor,
              cTotalHeight: 40.w,
              cTotalWidth: 300.w,
              cInsideColor: Color(0xffffffff),
              cRightBorderWidth: 1.w,
              cBottomBorderWidth: 1.w,
              childWidget: Center(
                child: RecordTableTextStyle(
                  text: widget.interest,
                  title: false,
                ),
              ),
            ),
            CustomContainer(
                cBorderColor: borderColor,
                cTotalHeight: 40.w,
                cTotalWidth: 98.w,
                cInsideColor: Color(0xffffffff),
                cBottomBorderWidth: 1.w,
                childWidget: Center(
                  child: RecordTableTextStyle(
                    text: widget.writer,
                    title: false,
                  ),
                )

                // Center(
                //   child: RecordTableTextStyle(
                //     text: "",
                //     title: false,
                //   ),
                // ),
                ),
          ],
        ),
      ),
    );
  }
}
