import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:treasure_map/widgets/get_container_info.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:treasure_map/widgets/overtab.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../widgets/custom_container.dart';
import 'd3_1.dart';

class D5_4 extends StatefulWidget {
  const D5_4({Key? key,
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
  State<D5_4> createState() => _D5_4State();
}

class _D5_4State extends State<D5_4> {
  bool dateOff = false;

  DateTime pageTime = DateTime.now();
  String pageTimeStr = '';

  List<int> category = [];
  double tablePlusHeight = 40;

  addDataCategory(int index) {
    setState(() {
      category[index]++;
      addHeight();
    });
  }

  addColumnCategory() {
    setState(() {
      category.add(1);
      addHeight();
    });
  }

  addHeight() {
    int count = 0;
    for (int i = 0; i < category.length; i++) {
      count = count + category[i];
    }
    tablePlusHeight = count * 250;
  }

  receiveData(DateTime dateTime) async {
    pageTime = dateTime;
    var formatter = DateFormat('yyyyMMdd');
    pageTimeStr = formatter.format(pageTime);
    setState(() {});
  }

  @override
  initState() {
    category.add(1);
    addHeight();
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
                physics: const RangeMaintainingScrollPhysics(),
                children: [
                  Row(
                    children: [
                      Container(
                        width: 39.w,
                        height: (160+tablePlusHeight).w,
                        decoration: BoxDecoration(
                          color: const Color(0xffFCFCFC),
                        ),
                      ),
                      WeeklyActionTable(
                        category: category,
                        addColumnCategory: addColumnCategory,
                        addDataCategory: addDataCategory,
                        tablePlusHeight: tablePlusHeight,
                      ),
                    ],
                  ),
                  Container(
                    width: 39.w,
                    height: 50.w,
                    color: const Color(0xffFCFCFC),
                  ),
                  Row(
                    children: [
                      Container(
                        width: 39.w,
                        height: 50.w,
                        color: const Color(0xffFCFCFC),
                      ),
                      SizedBox(
                        width: 501.w,
                      ),
                      GestureDetector(
                        onTap: () {
                          addColumnCategory();
                        },
                        child: SvgPicture.asset(
                          "assets/icons/icon_add.svg",
                          width: 50.w,
                          height: 50.w,
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

class WeeklyActionTable extends StatefulWidget {
  const WeeklyActionTable({
    Key? key,
    required this.category,
    required this.addColumnCategory,
    required this.addDataCategory,
    required this.tablePlusHeight,
  }) : super(key: key);
  final List<int> category;
  final Function(int) addDataCategory;
  final Function() addColumnCategory;
  final double tablePlusHeight;

  @override
  State<WeeklyActionTable> createState() => _WeeklyActionTableState();
}

class _WeeklyActionTableState extends State<WeeklyActionTable> {
  Color borderColor = const Color(0x9dC13BFD);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
            width: 1053.w,
            height: (160+widget.tablePlusHeight).w,
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
                    cTotalWidth: 553.w,
                    cBorderRadius:
                    BorderRadius.only(topLeft: Radius.circular(20.w)),
                    cInsideColor: Color(0xffCAACF2),
                    cTopBorderWidth: 1.w,
                    cLeftBorderWidth: 1.w,
                    childWidget: Center(
                      child: RecordTableTextStyle(
                        text: "반이름" + "반의 주간놀이 실행안",
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
                        text: "기간",
                        title: true,
                      ),
                    ),
                  ),
                  // CustomContainer(
                  //   cBorderColor: borderColor,
                  //   cTotalHeight: 50.w,
                  //   cTotalWidth: 413.w,
                  //   cBorderRadius:
                  //   BorderRadius.only(topRight: Radius.circular(20.w)),
                  //   cInsideColor: Color(0xffffffff),
                  //   cTopBorderWidth: 1.w,
                  //   cLeftBorderWidth: 1.w,
                  //   cRightBorderWidth: 1.w,
                  //   childWidget: Center(),
                  // ),
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
                        text: "목표",
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
                    childWidget: Center(),
                  ),
                  CustomContainer(
                    cBorderColor: borderColor,
                    cTotalHeight: 70.w,
                    cTotalWidth: 276.w,
                    cInsideColor: Color(0xffffffff),
                    cTopBorderWidth: 1.w,
                    cLeftBorderWidth: 1.w,
                    childWidget: Center(),
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
                  CustomContainer(
                    cBorderColor: borderColor,
                    cTotalHeight: 70.w,
                    cTotalWidth: 80.w,
                    cInsideColor: Color(0xffffffff),
                    cTopBorderWidth: 1.w,
                    cLeftBorderWidth: 1.w,
                    childWidget: Center(),
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
                  CustomContainer(
                    cBorderColor: borderColor,
                    cTotalHeight: 70.w,
                    cTotalWidth: 81.w,
                    cInsideColor: Color(0xffffffff),
                    cTopBorderWidth: 1.w,
                    cLeftBorderWidth: 1.w,
                    childWidget: Center(),
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
                  CustomContainer(
                    cBorderColor: borderColor,
                    cTotalHeight: 70.w,
                    cTotalWidth: 81.w,
                    cInsideColor: Color(0xffffffff),
                    cTopBorderWidth: 1.w,
                    cLeftBorderWidth: 1.w,
                    cRightBorderWidth: 1.w,
                    childWidget: Center(),
                  ),
                ],
              ),
              for (int i = 0; i < widget.category.length; i++) ...[
                Row(
                  children: [
                    CustomContainer(
                      cBorderColor: borderColor,
                      cTotalHeight: (250*widget.category[i]).w,
                      cTotalWidth: 96.w,
                      cBorderRadius:
                      BorderRadius.only(bottomLeft: (i < widget.category.length -1) ? Radius.zero : Radius.circular(20.w)),
                      cInsideColor: Color(0xffCAACF2),
                      cTopBorderWidth: 1.w,
                      cLeftBorderWidth: 1.w,
                      cBottomBorderWidth: (i < widget.category.length-1) ? 0 : 1.w,
                      childWidget: Center(
                        child: RecordTableTextStyle(
                          text: "이번주\n놀이경험",
                          title: true,
                        ),
                      ),
                    ),

                    Column(

                      children: [
                        for (int j = 0; j < widget.category[i]; j++) ...[
                          CustomContainer(
                            cBorderColor: borderColor,
                            cTotalHeight: 250.w,
                            cTotalWidth: 957.w,
                            cBorderRadius: BorderRadius.only(
                                bottomRight: (i < widget.category.length -1) ? Radius.zero : (j < widget.category[i] -1) ? Radius.zero : Radius.circular(20.w)),
                            cInsideColor: Color(0xffffffff),
                            cTopBorderWidth: 1.w,
                            cLeftBorderWidth: 1.w,
                            cRightBorderWidth: 1.w,
                            cBottomBorderWidth: (i < widget.category.length -1) ? 0 : (j < widget.category[i] -1) ? 0 :1.w,
                            childWidget: Stack(
                              children: [
                                Positioned(
                                  top: 5.w,
                                  right: 5.w,
                                  child: GestureDetector(
                                    onTap: () {},
                                    child: Stack(
                                      children: [
                                        Positioned(
                                          top: 5.w,
                                          left: 4.w,
                                          child: Container(
                                            width: 35.w,
                                            height: 35.w,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(5.w)),
                                              color: Colors.white,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Color(0x29505050),
                                                  blurRadius: 6,
                                                  offset: Offset(1,
                                                      1), // changes position of shadow
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        SvgPicture.asset(
                                          'assets/icons/icon_download.svg',
                                          width: 45.w,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                j == widget.category[i] - 1 ?
                                Positioned(
                                  top: 55.w,
                                  right: 10.w,
                                  child: GestureDetector(
                                    onTap: () {
                                      widget.addDataCategory(i);
                                    },
                                    child: Container(
                                      width: 35.w,
                                      height: 35.w,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                        BorderRadius.all(Radius.circular(5.w)),
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Color(0x29505050),
                                            blurRadius: 6,
                                            offset: Offset(
                                                1, 1), // changes position of shadow
                                          ),
                                        ],
                                      ),
                                      child: Center(
                                        child: Icon(
                                          Icons.add,
                                          color: Color(
                                            0xffA666FB,
                                          ),
                                          size: 30.w,
                                        ),
                                      ),
                                    ),
                                  ),
                                ):Container(),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),

                  ],

                )
              ],
            ])),
      ],
    );
  }
}
