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
import 'package:treasure_map/widgets/custom_container.dart';
import 'package:treasure_map/widgets/get_container_info.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:treasure_map/widgets/overtab.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class D1_1 extends StatefulWidget {
  const D1_1({
    Key? key,
    required this.nextPage,
    required this.prePage,
    required this.nowPage,
    this.scaffoldKey,
    required this.scheduleYearData,
    required this.routhPage,
    required this.changePage,
  }) : super(key: key);
  final Function nextPage;
  final Function prePage;
  final String nowPage;
  final GlobalKey<ScaffoldState>? scaffoldKey;
  final Function(Widget)? routhPage;
  final Function(int) changePage;
  final scheduleYearData;

  @override
  State<D1_1> createState() => _D1_1State();
}

class _D1_1State extends State<D1_1> {
  bool dateOff = false;
  int clickedClass = 0;
  ApiUrl apiUrl = ApiUrl();
  String className = '';
  var signData;

  classChangeBtnClick(int index, String name) {
    setState(() {
      clickedClass = index;
      className = name;
    });
  }



  DateTime pageTime = DateTime.now();
  String pageTimeStr = '';

  receiveData(DateTime dateTime) async {
    pageTime = dateTime;
    var formatter = DateFormat('yyyyMMdd');
    pageTimeStr = formatter.format(pageTime);
    setState(() {});
  }

  getSignData() async {
    http.Response res = await api(
        apiUrl.sign + '/' + widget.scheduleYearData['year'].toString(),
        'get',
        'signInToken',
        {},
        context);
    if (res.statusCode == 200) {
      setState(() {
        var signRB = utf8.decode(res.bodyBytes);
        signData = jsonDecode(signRB);
        if(signData['classes'].length > 0){
          className = signData['classes'][0]['name'];
        }
      });

      print(signData);
    }
  }

  @override
  initState() {
    super.initState();
    receiveData(pageTime);
    getSignData();
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
                      SizedBox(
                        width: 39.w,
                      ),
                      Container(
                        width: 1053.w,
                        height: 50.w,
                        child: ScrollConfiguration(
                            behavior: const ScrollBehavior()
                                .copyWith(overscroll: false),
                            child: ListView(
                              padding: EdgeInsets.zero,
                              physics: const RangeMaintainingScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              children: [
                                if (signData != null) ...[
                                  for (int i = 0;
                                      i < signData['classes'].length;
                                      i++) ...[
                                    ChoiceClass(
                                      btnOnOff:
                                          clickedClass == i ? true : false,
                                      btnClick: classChangeBtnClick,
                                      btnName: signData['classes'][i]['name'],
                                      index: i,
                                      start: i == 0 ? true : false,
                                      finish:
                                          i == signData['classes'].length - 1
                                              ? true
                                              : false,
                                    )
                                  ]
                                ]
                              ],
                            )),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30.w,
                  ),
                  Row(children: [
                    Container(
                      width: 39.w,
                      height: 50.w,
                      color: const Color(0xffFCFCFC),
                    ),
                    if (signData != null) ...[
                      ApprovalTable(
                        signData: signData,
                        cid: signData['classes'][clickedClass]['cid'],
                        routhPage: widget.routhPage,
                        changePage: widget.changePage,
                        nextPage: widget.nextPage,
                        nowPage: widget.nowPage,
                        scaffoldKey: widget.scaffoldKey,
                        prePage: widget.prePage,
                        className: className,
                          scheduleYearData: widget.scheduleYearData
                      ),
                    ],
                  ]),
                  Row(
                    children: [
                      Container(
                        width: 39.w,
                        height: 50.w,
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
                      SizedBox(
                        width: 952.w,
                      ),
                      GestureDetector(
                        onTap: () {
                          // newRecord();
                        },
                        child: Container(
                          width: 100.w,
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
                              '일괄결재',
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

class ChoiceClass extends StatefulWidget {
  const ChoiceClass({
    Key? key,
    required this.btnOnOff,
    this.start = false,
    this.finish = false,
    required this.btnName,
    required this.index,
    required this.btnClick,
  }) : super(key: key);
  final bool btnOnOff;
  final bool start;
  final bool finish;
  final String btnName;
  final int index;
  final Function(int, String) btnClick;

  @override
  State<ChoiceClass> createState() => _ChoiceClassState();
}

class _ChoiceClassState extends State<ChoiceClass> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          widget.btnClick(widget.index, widget.btnName);
        });
      },
      child: CustomContainer(
        cTotalWidth: 100.w,
        cTotalHeight: 50.w,
        cBorderRadius: BorderRadius.only(
            topLeft: widget.start ? Radius.circular(10.w) : Radius.zero,
            bottomLeft: widget.start ? Radius.circular(10.w) : Radius.zero,
            topRight: widget.finish ? Radius.circular(10.w) : Radius.zero,
            bottomRight: widget.finish ? Radius.circular(10.w) : Radius.zero),
        cInsideColor:
            widget.btnOnOff ? const Color(0xffFED796) : const Color(0xffE5E5E5),
        cBorderColor: const Color(0xffd0d0d0),
        cRightBorderWidth: widget.finish ? 0.w : 1.w,
        cShadowColor: const Color(0x29767676),
        cShadowBlurRadius: 3,
        cShadowOffset: const Offset(3, 3),
        childWidget: Center(
          child: Text(
            widget.btnName,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: const Color(0xff393838),
            ),
          ),
        ),
      ),
    );
  }
}

class ApprovalTable extends StatefulWidget {
  const ApprovalTable({
    Key? key,
    required this.signData,
    required this.cid,
    required this.nextPage,
    required this.prePage,
    required this.nowPage,
    this.scaffoldKey,
    this.routhPage,
    required this.changePage,
    required this.className,
    required this.scheduleYearData,
  }) : super(key: key);
  final Function nextPage;
  final Function prePage;
  final String nowPage;
  final GlobalKey<ScaffoldState>? scaffoldKey;
  final Function(Widget)? routhPage;
  final Function(int) changePage;
  final signData;
  final int cid;
  final String className;
  final scheduleYearData;


  @override
  State<ApprovalTable> createState() => _ApprovalTableState();
}

class _ApprovalTableState extends State<ApprovalTable> {
  Color borderColor = const Color(0x9dC13BFD);
  bool data = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }


  @override
  Widget build(BuildContext context) {
    int count = 0;

    if(widget.signData['documents'].length >0){
      data = widget.signData['documents'].indexWhere((documents) => documents['cid'] == widget.cid)  == -1 ? false : true;
    }
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
              //   cTotalWidth: 273.w,
              //   cInsideColor: Color(0xffCAACF2),
              //   cTopBorderWidth: 1.w,
              //   cLeftBorderWidth: 1.w,
              //   childWidget: Center(
              //     child: ApprovalTableTextStyle(
              //       text: "주제",
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
                  if(data)...[
                    for (int i = 0; i < widget.signData['documents'].length; {
                      if(widget.signData['documents'][i]['cid'] == widget.cid){
                        count ++,
                      }
                    }, i++) ...[
                      if(widget.signData['documents'][i]['cid'] == widget.cid)...[
                        ApprovalTableRow(signData: widget.signData['documents'][i], index: count,
                          routhPage: widget.routhPage,
                          changePage: widget.changePage,
                          nextPage: widget.nextPage,
                          nowPage: widget.nowPage,
                          scaffoldKey: widget.scaffoldKey,
                          prePage: widget.prePage,
                        className: widget.className,
                            scheduleYearData:widget.scheduleYearData),
                      ]
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
    required this.className,
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
  final String className;
  final scheduleYearData;


  @override
  State<ApprovalTableRow> createState() => _ApprovalTableRowState();
}

class _ApprovalTableRowState extends State<ApprovalTableRow> {
  Color borderColor = const Color(0x9dC13BFD);

  signRouteing(){
    Provider.of<UserInfo>(context, listen : false).value[0] = widget.signData['cid'];
    Provider.of<UserInfo>(context, listen : false).value[2] = widget.className;
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
      onTap: (){
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
                text: widget.signData['type'] ?? '',
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
                text: widget.signData['time'] ?? '',
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
          //   cTotalWidth: 273.w,
          //   cInsideColor: Colors.white,
          //   cRightBorderWidth: 1.w,
          //   cBottomBorderWidth: 1.w,
          //   childWidget: Center(
          //     child: ApprovalTableTextStyle(
          //       text: "팽이놀이",
          //     ),
          //   ),
          // ),
          CustomContainer(
            cBorderColor: borderColor,
            cTotalHeight: 50.w,
            cTotalWidth: 331.w,
            cInsideColor: Colors.white,
            cBottomBorderWidth: 1.w,
            childWidget: Center(
              child: ApprovalTableTextStyle(
                text: widget.signData['deadline'] ?? '',
              ),
            ),
          ),
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
