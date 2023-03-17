import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:treasure_map/d_play/d3_2.dart';
import 'package:treasure_map/d_play/d4.dart';
import 'package:treasure_map/d_play/d5_2.dart';
import 'package:treasure_map/d_play/d6.dart';
import 'package:treasure_map/d_play/d9.dart';
import 'package:treasure_map/provider/app_management.dart';
import 'package:treasure_map/widgets/api.dart';
import 'package:treasure_map/widgets/get_container_info.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:treasure_map/widgets/overtab.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../widgets/custom_container.dart';
import 'package:provider/provider.dart';
class D1_2 extends StatefulWidget {
  const D1_2({Key? key,
        required this.nextPage,
        required this.prePage,
        required this.nowPage,
        this.scaffoldKey,
        required this.scheduleYearData,
    required this.routhPage,
    required this.changePage,
      })
      : super(key: key);
    final Function nextPage;
    final Function prePage;
    final String nowPage;
    final GlobalKey<ScaffoldState>? scaffoldKey;
    final scheduleYearData;
  final Function(Widget)? routhPage;
  final Function(int) changePage;

  @override
  State<D1_2> createState() => _D1_2State();
}

class _D1_2State extends State<D1_2> {
  bool dateOff = false;

  DateTime pageTime = DateTime.now();
  String pageTimeStr = '';

  receiveData(DateTime dateTime) async {
    pageTime = dateTime;
    var formatter = DateFormat('yyyyMMdd');
    pageTimeStr = formatter.format(pageTime);
    setState(() {});
  }

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
                        height: 80.w,
                        color: const Color(0xffFCFCFC),
                      ),

                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        width: 39.w,
                        height: 50.w,
                        color: const Color(0xffFCFCFC),
                      ),
                      ApprovalTable(
                        routhPage: widget.routhPage,
                        changePage: widget.changePage,
                        nextPage: widget.nextPage,
                        nowPage: widget.nowPage,
                        scaffoldKey: widget.scaffoldKey,
                        prePage: widget.prePage,
                        scheduleYearData: widget.scheduleYearData,
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

class ApprovalTable extends StatefulWidget {
  const ApprovalTable({Key? key,
    required this.scheduleYearData,
    required this.nextPage,
    required this.prePage,
    required this.nowPage,
    this.scaffoldKey,
    this.routhPage,
    required this.changePage,
  }) : super(key: key);
  final scheduleYearData;
  final Function nextPage;
  final Function prePage;
  final String nowPage;
  final GlobalKey<ScaffoldState>? scaffoldKey;
  final Function(Widget)? routhPage;
  final Function(int) changePage;
  @override
  State<ApprovalTable> createState() => _ApprovalTableState();
}

class _ApprovalTableState extends State<ApprovalTable> {
  Color borderColor = const Color(0x9dC13BFD);
  ApiUrl apiUrl = ApiUrl();

  var signData;

  getSignData() async{
    http.Response res = await api(apiUrl.sign + '/' + widget.scheduleYearData['year'].toString(), 'get' ,'signInToken', {}, context);
    if(res.statusCode == 200){
      setState(() {
        var signRB = utf8.decode(res.bodyBytes);
        signData = jsonDecode(signRB);
      });

      print(signData);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSignData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1053.w,
      height: 323.w,
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
                cTotalWidth: 60.w,
                cBorderRadius:
                    BorderRadius.only(topLeft: Radius.circular(20.w)),
                cInsideColor: Color(0xffCAACF2),
                cTopBorderWidth: 1.w,
                cLeftBorderWidth: 1.w,
                childWidget: Center(
                  child: ApprovalTableTextStyle(
                    text: "번호",
                  ),
                ),
              ),
              CustomContainer(
                cBorderColor: borderColor,
                cTotalHeight: 50.w,
                cTotalWidth: 220.w,
                cInsideColor: Color(0xffCAACF2),
                cTopBorderWidth: 1.w,
                cLeftBorderWidth: 1.w,
                childWidget: Center(
                  child: ApprovalTableTextStyle(
                    text: "문서명",
                  ),
                ),
              ),
              CustomContainer(
                cBorderColor: borderColor,
                cTotalHeight: 50.w,
                cTotalWidth: 220.w,
                cInsideColor: Color(0xffCAACF2),
                cTopBorderWidth: 1.w,
                cLeftBorderWidth: 1.w,
                childWidget: Center(
                  child: ApprovalTableTextStyle(
                    text: "문서날짜",
                  ),
                ),
              ),
              CustomContainer(
                cBorderColor: borderColor,
                cTotalHeight: 50.w,
                cTotalWidth: 220.w,
                cInsideColor: Color(0xffCAACF2),
                cTopBorderWidth: 1.w,
                cLeftBorderWidth: 1.w,
                childWidget: Center(
                  child: ApprovalTableTextStyle(
                    text: "작성자",
                  ),
                ),
              ),
              // CustomContainer(
              //   cBorderColor: borderColor,
              //   cTotalHeight: 50.w,
              //   cTotalWidth: 170.w,
              //   cInsideColor: Color(0xffCAACF2),
              //   cTopBorderWidth: 1.w,
              //   cLeftBorderWidth: 1.w,
              //   childWidget: Center(
              //     child: ApprovalTableTextStyle(
              //       text: "제출기한",
              //     ),
              //   ),
              // ),
              // CustomContainer(
              //   cBorderColor: borderColor,
              //   cTotalHeight: 50.w,
              //   cTotalWidth: 253.w,
              //   cInsideColor: Color(0xffCAACF2),
              //   cTopBorderWidth: 1.w,
              //   cLeftBorderWidth: 1.w,
              //   childWidget: Center(
              //     child: ApprovalTableTextStyle(
              //       text: "코멘트",
              //     ),
              //   ),
              // ),
              CustomContainer(
                cBorderColor: borderColor,
                cTotalHeight: 50.w,
                cTotalWidth: 333.w,
                cBorderRadius:
                    BorderRadius.only(topRight: Radius.circular(20.w)),
                cInsideColor: Color(0xffCAACF2),
                cTopBorderWidth: 1.w,
                cLeftBorderWidth: 1.w,
                cRightBorderWidth: 1.w,
                childWidget: Center(
                  child: ApprovalTableTextStyle(
                    text: "제출기한",
                  ),
                ),
              ),
            ],
          ),
          Container(
            height: 273.w,
            width: 1053.w,
            decoration: BoxDecoration(
              // borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20.w),
              // bottomRight: Radius.circular(20.w)),
              border: Border.all(width: 1.w, color: borderColor),
              color: Colors.white,
            ),
            child: ScrollConfiguration(
              behavior: const ScrollBehavior().copyWith(overscroll: false),
              child: ListView(
                padding: EdgeInsets.zero,
                physics: const RangeMaintainingScrollPhysics(),
                children: [
                  if(signData != null)...[
                    for (int i = 0; i<signData['documents'].length; i++) ...[
                      ApprovalTableRow(
                        routhPage: widget.routhPage,
                        changePage: widget.changePage,
                        nextPage: widget.nextPage,
                        nowPage: widget.nowPage,
                        scaffoldKey: widget.scaffoldKey,
                        prePage: widget.prePage,
                        scheduleYearData:widget.scheduleYearData,
                        signData: signData['documents'][i],
                        index: i,
                      ),
                    ]
                  ]
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class ApprovalTableRow extends StatefulWidget {
  const ApprovalTableRow({Key? key,
    required this.signData,
    required this.index,
    required this.nextPage,
    required this.prePage,
    required this.nowPage,
    this.scaffoldKey,
    this.routhPage,
    required this.changePage,
    required this.scheduleYearData,
  }) : super(key: key);
  final Function nextPage;
  final Function prePage;
  final String nowPage;
  final GlobalKey<ScaffoldState>? scaffoldKey;
  final Function(Widget)? routhPage;
  final Function(int) changePage;
  final signData;
  final int index;
  final scheduleYearData;

  @override
  State<ApprovalTableRow> createState() => _ApprovalTableRowState();
}

class _ApprovalTableRowState extends State<ApprovalTableRow> {
  Color borderColor = const Color(0x9dC13BFD);

  signRouteing(){
    switch (widget.signData['type']){
      case '관찰기록' :
        widget.routhPage!(D3_2(nextPage: widget.nextPage, prePage: widget.prePage, nowPage: widget.nowPage, recordId: widget.signData['params'][0], changePage: widget.changePage));
        break;
      case '하루일과' :
        widget.routhPage!(D4(nextPage: widget.nextPage, prePage: widget.prePage, nowPage: widget.nowPage, pageTime: DateTime.parse(widget.signData['params'][1],)));
        break;
      case '주간계획' :
        widget.routhPage!(D5_2(nextPage: widget.nextPage, prePage: widget.prePage, nowPage: widget.nowPage, pageTime: DateTime.parse(widget.signData['params'][1],),));
        break;
      case '가정통신문' :
        widget.routhPage!(D6(nextPage: widget.nextPage, prePage: widget.prePage, nowPage: widget.nowPage, scheduleYearData: widget.scheduleYearData, pageTime: DateTime.parse(widget.signData['params'][1],)));
        break;
      case '아이별 누리과정분석' :
        widget.routhPage!(D9(nextPage: widget.nextPage, prePage: widget.prePage, nowPage: widget.nowPage, scheduleYearData: widget.scheduleYearData,pageTime: widget.signData['params'][1], childId: widget.signData['params'][2], targetClass: false,));
        break;
      case '반별 누리과정분석' :
        widget.routhPage!(D9(nextPage: widget.nextPage, prePage: widget.prePage, nowPage: widget.nowPage, scheduleYearData: widget.scheduleYearData,pageTime: widget.signData['params'][1], childId: widget.signData['params'][2], targetClass: true,));
        break;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.signData);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:(){
        signRouteing();
      },
      child: Row(
        children: [
          CustomContainer(
            cBorderColor: borderColor,
            cTotalHeight: 50.w,
            cTotalWidth: 60.w,
            cInsideColor: Colors.white,
            cRightBorderWidth: 1.w,
            cBottomBorderWidth: 1.w,
            childWidget: Center(
              child: ApprovalTableTextStyle(
                text: (widget.index + 1).toString(),
              ),
            ),
          ),
          CustomContainer(
            cBorderColor: borderColor,
            cTotalHeight: 50.w,
            cTotalWidth: 220.w,
            cInsideColor: Colors.white,
            cRightBorderWidth: 1.w,
            cBottomBorderWidth: 1.w,
            childWidget: Center(
              child: ApprovalTableTextStyle(
                text: widget.signData['type'],
              ),
            ),
          ),
          CustomContainer(
            cBorderColor: borderColor,
            cTotalHeight: 50.w,
            cTotalWidth: 220.w,
            cInsideColor: Colors.white,
            cRightBorderWidth: 1.w,
            cBottomBorderWidth: 1.w,
            childWidget: Center(
              child: ApprovalTableTextStyle(
                text: widget.signData['time'],
              ),
            ),
          ),
          CustomContainer(
            cBorderColor: borderColor,
            cTotalHeight: 50.w,
            cTotalWidth: 220.w,
            cInsideColor: Colors.white,
            cRightBorderWidth: 1.w,
            cBottomBorderWidth: 1.w,
            childWidget: Center(
              child: ApprovalTableTextStyle(
                text: widget.signData['writer'] ?? '',
              ),
            ),
          ),
          // CustomContainer(
          //   cBorderColor: borderColor,
          //   cTotalHeight: 50.w,
          //   cTotalWidth: 220.w,
          //   cInsideColor: Colors.white,
          //   cRightBorderWidth: 1.w,
          //   cBottomBorderWidth: 1.w,
          //   childWidget: Center(
          //     child: ApprovalTableTextStyle(
          //       text: "관찰기록",
          //     ),
          //   ),
          // ),
          CustomContainer(
            cBorderColor: borderColor,
            cTotalHeight: 50.w,
            cTotalWidth: 331.w,
            cInsideColor: Colors.white,
            // cRightBorderWidth: 1.w,
            cBottomBorderWidth: 1.w,
            childWidget: Center(
              child: ApprovalTableTextStyle(
                text: widget.signData['deadline'] ?? '',
              ),
            ),
          ),
          // CustomContainer(
          //   cBorderColor: borderColor,
          //   cTotalHeight: 50.w,
          //   cTotalWidth: 211.w,
          //   cInsideColor: Colors.white,
          //   // cRightBorderWidth: 1.w,
          //   cBottomBorderWidth: 1.w,
          //   childWidget: Center(
          //     child: ApprovalTableTextStyle(
          //       text: "팽이놀이",
          //     ),
          //   ),
          // ),
          // CustomContainer(
          //   cBorderColor: borderColor,
          //   cTotalHeight: 50.w,
          //   cTotalWidth: 138.w,
          //   cInsideColor: Colors.white,
          //   cBottomBorderWidth: 1.w,
          //   childWidget: Center(
          //     child: ApprovalTableTextStyle(
          //       text: "잘하셨습니다.",
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}

class ApprovalTableTextStyle extends StatefulWidget {
  const ApprovalTableTextStyle({
    Key? key,
    required this.text,
  }) : super(key: key);
  final String text;

  @override
  State<ApprovalTableTextStyle> createState() => _ApprovalTableTextStyleState();
}

class _ApprovalTableTextStyleState extends State<ApprovalTableTextStyle> {
  @override
  Widget build(BuildContext context) {
    return Text(
      widget.text,
      style: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 14.sp,
          color: Color(0xff393838)),
    );
  }
}
