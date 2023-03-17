import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:treasure_map/provider/app_management.dart';
import 'package:treasure_map/widgets/api.dart';
import 'package:treasure_map/widgets/get_container_info.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:treasure_map/widgets/overtab.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../widgets/custom_container.dart';
import 'd3_1.dart';
class D2 extends StatefulWidget {
  const D2({Key? key,
    required this.nextPage,
    required this.prePage,
    required this.nowPage,
    this.scaffoldKey
  })
      : super(key: key);
  final Function nextPage;
  final Function prePage;
  final String nowPage;
  final GlobalKey<ScaffoldState>? scaffoldKey;

  @override
  State<D2> createState() => _D2State();
}

class _D2State extends State<D2> {
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
  var annualRB;
  var annualData;

  getAnnualData() async{
    ApiUrl apiUrl = ApiUrl();
    // api(apiUrl.annual + '/' + Provider.of<UserInfo>(context, listen : false).value[0], 'get', 'signInToken', {}, context);

    http.Response annualRes =
    await api(apiUrl.annual + '/' + Provider.of<UserInfo>(context, listen : false).value[0].toString(), 'get', 'signInToken', {}, context);

    if (annualRes.statusCode == 200) {
      if(mounted){
        setState((){
          annualRB = utf8.decode(annualRes.bodyBytes);
          annualData = jsonDecode(annualRB);
        });
      }

      print(annualData);
    }
  }

  @override
  initState() {
    getAnnualData();
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
                  if(annualData != null)...[
                    for(int i = 0; i< annualData.length;i++)...[
                      if(i != 0)...[
                        Container(
                          width: 39.w,
                          height: 50.w,
                          color: const Color(0xffFCFCFC),
                        ),
                      ],
                      Row(
                        children: [
                          Container(
                            width: 39.w,
                            height: (50+annualData[i]['weeks'].length * 40).w,
                            color: const Color(0xffFCFCFC),
                          ),
                          TimeTable(annualData: annualData[i], getAnnualData: getAnnualData,),
                        ],
                      ),
                  ]

                  ],

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



class TimeTable extends StatefulWidget {
  const TimeTable({Key? key,
    required this.annualData,
    required this.getAnnualData,
  }) : super(key: key);
  final annualData;
  final Function() getAnnualData;

  @override
  State<TimeTable> createState() => _TimeTableState();
}

class _TimeTableState extends State<TimeTable> {
  Color borderColor = const Color(0x9dC13BFD);

  // List<TextEditingController> events = [];
  // List<TextEditingController> specialDays = [];
  List<TextEditingController> expected = [];
  List<TextEditingController> played = [];

  int thisMonth = 0;


  patchAnnualData(int week, String type, String value) async{
    ApiUrl apiUrl = ApiUrl();
    http.Response annualRes =
    await api(apiUrl.annual, 'patch', 'signInToken', {
      "cid": Provider.of<UserInfo>(context, listen: false).value[0].toString(),
      "yearMonth": widget.annualData['year'].toString()
          + (widget.annualData['month'] < 10 ? '0' + widget.annualData['month'].toString() : widget.annualData['month'].toString()),
      "week": week.toString(),
      "type": type,
      "value": value
    }, context);

    if (annualRes.statusCode == 200) {
      widget.getAnnualData();
      // var annualRB = utf8.decode(annualRes.bodyBytes);
      // var annualData = jsonDecode(annualRB);
      // print(annualData);
    }
  }

  @override
  void initState() {
    for(int i = 0; i< widget.annualData['weeks'].toString().length; i++){
      // events.add(TextEditingController());
      // specialDays.add(TextEditingController());
      expected.add(TextEditingController());
      played.add(TextEditingController());
    }
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    for(int i = 0; i< widget.annualData['weeks'].length; i++){
      // events[i].text = widget.annualData['weeks'][i]['events'] ?? '';
      // specialDays[i].text = widget.annualData['weeks'][i]['specialDays']?? '';
      expected[i].text = widget.annualData['weeks'][i]['expected']?? '';
      played[i].text = widget.annualData['weeks'][i]['played']?? '';
    }

    return  Container(
        width: 1053.w,
        // height: 590.w,
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
          Row(
              children: [
                CustomContainer(
                  cBorderColor: borderColor,
                  cTotalHeight: 50.w,
                  cTotalWidth: 89.w,
                  cBorderRadius:
                  BorderRadius.only(topLeft: Radius.circular(20.w)),
                  cInsideColor: Color(0xffCAACF2),
                  cTopBorderWidth: 1.w,
                  cLeftBorderWidth: 1.w,
                  childWidget: Center(
                    child: RecordTableTextStyle(
                      text: "월",
                      title: false,
                    ),
                  ),
                ),
                CustomContainer(
                  cBorderColor: borderColor,
                  cTotalHeight: 50.w,
                  cTotalWidth: 88.w,
                  cInsideColor: Color(0xffCAACF2),
                  cTopBorderWidth: 1.w,
                  cLeftBorderWidth: 1.w,
                  childWidget: Center(
                    child: RecordTableTextStyle(
                      text: "주",
                      title: false,
                    ),
                  ),
                ),
                CustomContainer(
                  cBorderColor: borderColor,
                  cTotalHeight: 50.w,
                  cTotalWidth: 219.w,
                  cInsideColor: Color(0xffCAACF2),
                  cTopBorderWidth: 1.w,
                  cLeftBorderWidth: 1.w,
                  childWidget: Center(
                    child: RecordTableTextStyle(
                      text: "유치원 주요 교육 행사",
                     title: false,
                    ),
                  ),
                ),
                CustomContainer(
                  cBorderColor: borderColor,
                  cTotalHeight: 50.w,
                  cTotalWidth: 219.w,
                  cInsideColor: Color(0xffCAACF2),
                  cTopBorderWidth: 1.w,
                  cLeftBorderWidth: 1.w,
                  childWidget: Center(
                    child: RecordTableTextStyle(
                      text: "특별한 날",
                      title: false,
                    ),
                  ),
                ),
                CustomContainer(
                  cBorderColor: borderColor,
                  cTotalHeight: 50.w,
                  cTotalWidth: 219.w,
                  cInsideColor: Color(0xffCAACF2),
                  cTopBorderWidth: 1.w,
                  cLeftBorderWidth: 1.w,
                  childWidget: Center(
                    child: RecordTableTextStyle(
                      text: "예상 놀이주제",
                      title: false,
                    ),
                  ),
                ),
                CustomContainer(
                  cBorderColor: borderColor,
                  cTotalHeight: 50.w,
                  cTotalWidth: 219.w,
                  cBorderRadius:
                  BorderRadius.only(topRight: Radius.circular(20.w)),
                  cInsideColor: Color(0xffCAACF2),
                  cTopBorderWidth: 1.w,
                  cLeftBorderWidth: 1.w,
                  cRightBorderWidth: 1.w,
                  childWidget: Center(
                    child: RecordTableTextStyle(
                      text: "실행 놀이주제",
                      title: false,
                    ),
                  ),
                ),
              ]
          ),
          Row(
              children: [
                CustomContainer(
                  cBorderColor: borderColor,
                  cTotalHeight: widget.annualData['weeks'].length * 40.w,
                  cTotalWidth: 89.w,
                  cBorderRadius:
                  BorderRadius.only(bottomLeft: Radius.circular(20.w)),
                  cInsideColor: Color(0xffCAACF2),
                  cTopBorderWidth: 1.w,
                  cLeftBorderWidth: 1.w,
                  childWidget: Center(
                    child: RecordTableTextStyle(
                      text: widget.annualData['month'].toString() + "월",
                      title: false,
                    ),
                  ),
                ),
                Column(
                  children: [
                    for(int i = 0; i<widget.annualData['weeks'].length;i++)...[
                      CustomContainer(
                        cBorderColor: borderColor,
                        cTotalHeight: 40.w,
                        cTotalWidth: 88.w,
                        cInsideColor: Color(0xffffffff),
                        cTopBorderWidth: 1.w,
                        cLeftBorderWidth: 1.w,
                        cBottomBorderWidth: (widget.annualData['weeks'].length - 1 == i) ? 1.w : 0.w,
                        childWidget: Center(
                          child: RecordTableTextStyle(
                            text: (i+1).toString(),
                            title: false,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                Column(
                  children: [
                    for(int i = 0; i<widget.annualData['weeks'].length;i++)...[
                      CustomContainer(
                        cBorderColor: borderColor,
                        cTotalHeight: 40.w,
                        cTotalWidth: 219.w,
                        cInsideColor: Color(0xffffffff),
                        cTopBorderWidth: 1.w,
                        cLeftBorderWidth: 1.w,
                        cBottomBorderWidth: (widget.annualData['weeks'].length - 1 == i) ? 1.w : 0.w,
                        childWidget: Center(
                          child:

                          RecordTableTextStyle(
                            text: widget.annualData['weeks'][i]["events"] ??'',
                            title: false,
                          ),
                          // Focus(
                          //   onFocusChange: (hasFocus) {
                          //     if (hasFocus) {
                          //     } else {
                          //       if (widget.annualData['weeks'][i]["events"] == events[i].text) {
                          //       } else {
                          //         patchAnnualData(widget.annualData['weeks'][i]['week'], 'events', events[i].text);
                          //       }
                          //     }
                          //   },
                          //   child: TextField(
                          //     textAlignVertical: TextAlignVertical.center,
                          //     style:TextStyle(
                          //         fontSize: 14.sp,
                          //         fontWeight: FontWeight.w400,
                          //         color: const Color(0xff393838)),
                          //     controller: events[i],
                          //     textAlign: TextAlign.center,
                          //     decoration: InputDecoration(
                          //       border: const OutlineInputBorder(
                          //         borderSide: BorderSide.none,
                          //       ), //외곽선
                          //     ),
                          //   ),
                          // ),
                        ),
                      ),
                    ]

                  ],
                ),
                Column(
                  children: [
                    for(int i = 0; i<widget.annualData['weeks'].length;i++)...[
                      CustomContainer(
                        cBorderColor: borderColor,
                        cTotalHeight: 40.w,
                        cTotalWidth: 219.w,
                        cInsideColor: Color(0xffffffff),
                        cTopBorderWidth: 1.w,
                        cLeftBorderWidth: 1.w,
                        cBottomBorderWidth: (widget.annualData['weeks'].length - 1 == i) ? 1.w : 0.w,
                        childWidget: Center(
                          child:
                          RecordTableTextStyle(
                            text: widget.annualData['weeks'][i]["specialDays"]??'',
                            title: false,
                          ),
                          // Focus(
                          //   onFocusChange: (hasFocus) {
                          //     if (hasFocus) {
                          //     } else {
                          //       if (widget.annualData['weeks'][i]["specialDays"] == specialDays[i].text) {
                          //       } else {
                          //         patchAnnualData(widget.annualData['weeks'][i]['week'], 'specialDays', specialDays[i].text);
                          //       }
                          //     }
                          //   },
                          //   child: TextField(
                          //     textAlignVertical: TextAlignVertical.center,
                          //     style:TextStyle(
                          //         fontSize: 14.sp,
                          //         fontWeight: FontWeight.w400,
                          //         color: const Color(0xff393838)),
                          //     controller: specialDays[i],
                          //     textAlign: TextAlign.center,
                          //     decoration: InputDecoration(
                          //       border: const OutlineInputBorder(
                          //         borderSide: BorderSide.none,
                          //       ), //외곽선
                          //     ),
                          //   ),
                          // ),
                        ),
                      ),
                    ]

                  ],
                ),
                Column(
                  children: [
                    for(int i = 0; i<widget.annualData['weeks'].length;i++)...[
                      CustomContainer(
                        cBorderColor: borderColor,
                        cTotalHeight: 40.w,
                        cTotalWidth: 219.w,
                        cInsideColor: Color(0xffffffff),
                        cTopBorderWidth: 1.w,
                        cLeftBorderWidth: 1.w,
                        cBottomBorderWidth: (widget.annualData['weeks'].length - 1 == i) ? 1.w : 0.w,
                        childWidget: Center(
                          child: Focus(
                            onFocusChange: (hasFocus) {
                              if (hasFocus) {
                              } else {
                                if (widget.annualData['weeks'][i]["expected"] == expected[i].text) {
                                } else {
                                  patchAnnualData(widget.annualData['weeks'][i]['week'], 'expected', expected[i].text);
                                }
                              }
                            },
                            child: TextField(
                              textAlignVertical: TextAlignVertical.center,
                              style:TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xff393838)),
                              controller: expected[i],
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                border: const OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                ), //외곽선
                              ),
                            ),
                          ),
                        ),
                      ),
                    ]

                  ],
                ),
                Column(
                  children: [
                    for(int i = 0; i<widget.annualData['weeks'].length;i++)...[
                      CustomContainer(
                        cBorderColor: borderColor,
                        cTotalHeight: 40.w,
                        cTotalWidth: 219.w,
                        cInsideColor: Color(0xffffffff),
                        cTopBorderWidth: 1.w,
                        cLeftBorderWidth: 1.w,
                        cRightBorderWidth: 1.w,
                        cBottomBorderWidth: (widget.annualData['weeks'].length - 1 == i) ? 1.w : 0.w,
                          cBorderRadius:
                          (widget.annualData['weeks'].length - 1 == i) ? BorderRadius.only(bottomRight: Radius.circular(20.w)):
                        BorderRadius.zero,
                        childWidget: Center(
                          child: Focus(
                            onFocusChange: (hasFocus) {
                              if (hasFocus) {
                              } else {
                                if (widget.annualData['weeks'][i]["played"] == played[i].text) {
                                } else {
                                  patchAnnualData(widget.annualData['weeks'][i]['week'], 'played', played[i].text);
                                }
                              }
                            },
                            child: TextField(
                              textAlignVertical: TextAlignVertical.center,
                              style:TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xff393838)),
                              controller: played[i],
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                border: const OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                ), //외곽선
                              ),
                            ),
                          ),
                        ),
                      ),
                    ]


                  ],
                ),
              ]
          )
        ]
        )
    );
  }
}
