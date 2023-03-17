import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:treasure_map/d_play/d8_2.dart';
import 'package:treasure_map/widgets/get_container_info.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:treasure_map/widgets/overtab.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../widgets/custom_container.dart';
import 'd3_1.dart';
class D8_1 extends StatefulWidget {
  const D8_1({Key? key,
    required this.nextPage,
    required this.prePage,
    required this.nowPage,
    this.scaffoldKey,
    this.routhPage,
  })
      : super(key: key);
  final Function nextPage;
  final Function prePage;
  final String nowPage;
  final GlobalKey<ScaffoldState>? scaffoldKey;
  final Function(Widget)? routhPage;


  @override
  State<D8_1> createState() => _D8_1State();
}

class _D8_1State extends State<D8_1> {
  bool dateOff = false;

  DateTime pageTime = DateTime.now();
  String pageTimeStr = '';

  routhPage(){
    widget.routhPage!(D8_2(nextPage: widget.nextPage, prePage: widget.prePage, nowPage: widget.nowPage,scaffoldKey: widget.scaffoldKey,));
  }

  receiveData(DateTime dateTime) async {
    pageTime = dateTime;
    var formatter = DateFormat('yyyyMMdd');
    pageTimeStr = formatter.format(pageTime);
    setState(() {

    });
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
          OverTab(nextPage: widget.nextPage, prePage: widget.prePage, nowPage: widget.nowPage,dateOnOff: dateOff, receiveData: receiveData,scaffoldKey: widget.scaffoldKey,),
          // Expanded(
          //   child: ScrollConfiguration(
          //     behavior: const ScrollBehavior().copyWith(overscroll: false),
          //     child: ListView(
          //       physics: const RangeMaintainingScrollPhysics(),
          //       children: [
          //         Row(
          //           children: [
          //             Container(
          //               width: 39.w,
          //               // height: 50.w,
          //                 color: const Color(0xffFCFCFC),
          //             ),
          //             PortfolioSearchTable(),
          //           ],
          //         ),
          //         Container(
          //           width: 39.w,
          //           height: 39.w,
          //           color: const Color(0xffFCFCFC),
          //         ),
          //         Row(
          //           children: [
          //             Container(
          //               width: 39.w,
          //               // height: 39.w,
          //               color: const Color(0xffFCFCFC),
          //             ),
          //             PortfolioListTable(routhPage: routhPage,),
          //           ],
          //         ),
          //
          //         Row(
          //           children: [
          //             Container(
          //               width: 50.w,
          //               height: 50.w,
          //               decoration: BoxDecoration(
          //                 borderRadius: BorderRadius.only(
          //                     bottomLeft: Radius.circular(50.w)),
          //                 color: const Color(0xffFCFCFC),
          //               ),
          //             ),
          //           ],
          //         )
          //       ],
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}

class PortfolioSearchTable extends StatefulWidget {
  const PortfolioSearchTable({Key? key}) : super(key: key);

  @override
  State<PortfolioSearchTable> createState() => _PortfolioSearchTableState();
}

class _PortfolioSearchTableState extends State<PortfolioSearchTable> {
  Color borderColor = const Color(0x9dC13BFD);
  @override
  Widget build(BuildContext context) {
    return Container(
        width: 1053.w,
        // height: 590.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20.w)),
          boxShadow: [
            BoxShadow(
              color: Color(0x29ffffff),
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
                  cTotalHeight: 40.w,
                  cTotalWidth: 1053.w,
                  cBorderRadius:
                  BorderRadius.only(topLeft: Radius.circular(20.w),
                  topRight: Radius.circular(20.w)),
                  cInsideColor: Color(0xffCAACF2),
                  cTopBorderWidth: 1.w,
                  cLeftBorderWidth: 1.w,
                  cRightBorderWidth: 1.w,
                  childWidget: Center(
                    child: RecordTableTextStyle(
                      text: "반이름" + "반의 유아별 포트폴리오",
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
                cTotalHeight: 40.w,
                cTotalWidth: 87.w,
                cBorderRadius:
                BorderRadius.only(bottomLeft: Radius.circular(20.w),),

                cInsideColor: Color(0xffCAACF2),
                cTopBorderWidth: 1.w,
                cLeftBorderWidth: 1.w,
                cBottomBorderWidth: 1.w,

                childWidget: Center(
                  child: RecordTableTextStyle(
                    text: "해당유아",
                    title: false,
                  ),
                ),
              ),
              CustomContainer(
                cBorderColor: borderColor,
                cTotalHeight: 40.w,
                cTotalWidth: 168.w,
                cInsideColor: Color(0xffffffff),
                cTopBorderWidth: 1.w,
                cLeftBorderWidth: 1.w,
                cBottomBorderWidth: 1.w,
                childWidget: Center(
                  child: RecordTableTextStyle(
                    text: "",
                    title: false,
                  ),
                ),
              ),
              CustomContainer(
                cBorderColor: borderColor,
                cTotalHeight: 40.w,
                cTotalWidth: 87.w,

                cInsideColor: Color(0xffCAACF2),
                cTopBorderWidth: 1.w,
                cLeftBorderWidth: 1.w,
                cBottomBorderWidth: 1.w,
                childWidget: Center(
                  child: RecordTableTextStyle(
                    text: "누리과정",
                    title: false,
                  ),
                ),
              ),
              CustomContainer(
                cBorderColor: borderColor,
                cTotalHeight: 40.w,
                cTotalWidth: 250.w,
                cInsideColor: Color(0xffffffff),
                cTopBorderWidth: 1.w,
                cLeftBorderWidth: 1.w,
                cBottomBorderWidth: 1.w,
                childWidget: Center(
                  child: RecordTableTextStyle(
                    text: "",
                    title: false,
                  ),
                ),
              ),
              CustomContainer(
                cBorderColor: borderColor,
                cTotalHeight: 40.w,
                cTotalWidth: 87.w,

                cInsideColor: Color(0xffCAACF2),
                cTopBorderWidth: 1.w,
                cLeftBorderWidth: 1.w,
                cBottomBorderWidth: 1.w,
                childWidget: Center(
                  child: RecordTableTextStyle(
                    text: "일자설정",
                    title: false,
                  ),
                ),
              ),
              CustomContainer(
                cBorderColor: borderColor,
                cTotalHeight: 40.w,
                cTotalWidth: 300.w,
                cInsideColor: Color(0xffffffff),
                cTopBorderWidth: 1.w,
                cLeftBorderWidth: 1.w,
                cBottomBorderWidth: 1.w,
                cRightBorderWidth: 1.w,
                childWidget: Center(
                  child: RecordTableTextStyle(
                    text: "",
                    title: false,
                  ),
                ),
              ),
              SizedBox(
                width: 20.w,
              ),
              GestureDetector(
                onTap: (){},
                child: Container(
                  width: 40.w,
                  height: 25.w,
                  decoration: BoxDecoration(
                    color: Color(0xffFED796),
                    borderRadius: BorderRadius.all(Radius.circular(5.w)),

                  ),
                  child: Center(
                    child : Text("검색",
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      color: Color(0xff393838)
                    ),)
                  ),
                ),
              )
            ],
          )
        ]
        )
    );
  }
}


class PortfolioListTable extends StatefulWidget {
  const PortfolioListTable({Key? key,
    required this.routhPage,
  }) : super(key: key);
  final Function() routhPage;

  @override
  State<PortfolioListTable> createState() => _PortfolioListTableState();
}

class _PortfolioListTableState extends State<PortfolioListTable> {
  Color borderColor = const Color(0x9dC13BFD);
  @override
  Widget build(BuildContext context) {
    return Container(
        width: 1053.w,
        // height: 590.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20.w)),
          boxShadow: [
            BoxShadow(
              color: Color(0x29ffffff),
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
                  cTotalHeight: 40.w,
                  cTotalWidth: 60.w,
                  cBorderRadius:
                  BorderRadius.only(topLeft: Radius.circular(20.w),),
                  cInsideColor: Color(0xffCAACF2),
                  cTopBorderWidth: 1.w,
                  cLeftBorderWidth: 1.w,
                  childWidget: Center(
                    child: RecordTableTextStyle(
                      text: "번호",
                      title: false,
                    ),
                  ),
                ),
                CustomContainer(
                  cBorderColor: borderColor,
                  cTotalHeight: 40.w,
                  cTotalWidth: 509.w,
                  cInsideColor: Color(0xffCAACF2),
                  cTopBorderWidth: 1.w,
                  cLeftBorderWidth: 1.w,
                  childWidget: Center(
                    child: RecordTableTextStyle(
                      text: "소주제",
                      title: false,
                    ),
                  ),
                ),
                CustomContainer(
                  cBorderColor: borderColor,
                  cTotalHeight: 40.w,
                  cTotalWidth: 484.w,
                  cBorderRadius:
                  BorderRadius.only(topRight: Radius.circular(20.w),),
                  cInsideColor: Color(0xffCAACF2),
                  cTopBorderWidth: 1.w,
                  cLeftBorderWidth: 1.w,
                  cRightBorderWidth: 1.w,
                  childWidget: Center(
                    child: RecordTableTextStyle(
                      text: "누리과정",
                      title: false,
                    ),
                  ),
                ),
              ]
          ),
          GestureDetector(
            onTap: (){
              widget.routhPage();
            },
            child: Row(
                children: [
                  CustomContainer(
                    cBorderColor: borderColor,
                    cTotalHeight: 60.w,
                    cTotalWidth: 60.w,
                    cInsideColor: Color(0xffffffff),
                    cTopBorderWidth: 1.w,
                    cLeftBorderWidth: 1.w,
                    cBottomBorderWidth: 1.w,
                    childWidget: Center(
                      child: RecordTableTextStyle(
                        text: "",
                        title: false,
                      ),
                    ),
                  ),
                  CustomContainer(
                    cBorderColor: borderColor,
                    cTotalHeight: 60.w,
                    cTotalWidth: 509.w,
                    cInsideColor: Color(0xffffffff),
                    cTopBorderWidth: 1.w,
                    cLeftBorderWidth: 1.w,
                    cBottomBorderWidth: 1.w,
                    childWidget: Center(
                      child: RecordTableTextStyle(
                        text: "",
                        title: false,
                      ),
                    ),
                  ),
                  CustomContainer(
                    cBorderColor: borderColor,
                    cTotalHeight: 60.w,
                    cTotalWidth: 484.w,
                    cInsideColor: Color(0xffffffff),
                    cTopBorderWidth: 1.w,
                    cLeftBorderWidth: 1.w,
                    cRightBorderWidth: 1.w,
                    cBottomBorderWidth: 1.w,
                    childWidget: Center(
                      child: RecordTableTextStyle(
                        text: "",
                        title: false,
                      ),
                    ),
                  ),
                ]
            ),
          ),
    ]
        )

    );
  }
}
