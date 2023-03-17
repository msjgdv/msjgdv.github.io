import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:treasure_map/widgets/get_container_info.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:treasure_map/widgets/overtab.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:aligned_dialog/aligned_dialog.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../widgets/custom_container.dart';
import 'd3_1.dart';
class D8_2 extends StatefulWidget {
  const D8_2({Key? key,
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
  State<D8_2> createState() => _D8_2State();
}

class _D8_2State extends State<D8_2> {
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
                physics: const RangeMaintainingScrollPhysics(),
                children: [

                  Row(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 39.w,
                            height: 740.w,
                            color: const Color(0xffFCFCFC),
                          ),
                        ],
                      ),

                      PortfolioReportTable(),
                    ],
                  ),
                  Container(
                    width: 39.w,
                    height: 50.w,
                    decoration: BoxDecoration(
                      color: const Color(0xffFCFCFC),
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        width: 39.w,
                        height: 50.w,
                        decoration: BoxDecoration(
                          color: const Color(0xffFCFCFC),
                        ),
                      ),
                      SizedBox(width: 501.w,),
                      GestureDetector(
                        onTap: () {
                        },
                        child: Container(
                          width: 50.w,
                          height: 50.w,
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
                              child: Icon(Icons.add,
                                color: Color(0xff7649B7),
                                size: 24.w,)
                          ),
                        ),
                      ),
                      SizedBox(width: 265.w,),
                      GestureDetector(
                        onTap: (){
                          // newRecord();
                        },
                        child: Container(
                          width: 100.w,
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
                          child: Center(child: Text('저장',
                            style: TextStyle(
                                color: Color(0xff7649B7),
                                fontWeight: FontWeight.w700,
                                fontSize: 14.sp
                            ),),),
                        ),
                      ),
                      SizedBox(
                        width: 40.w,
                      ),
                      GestureDetector(
                        onTap: (){
                          // newRecord();
                        },
                        child: Container(
                          width: 100.w,
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
                          child: Center(child: Text('삭제',
                            style: TextStyle(
                                color: Color(0xff7649B7),
                                fontWeight: FontWeight.w700,
                                fontSize: 14.sp
                            ),),),
                        ),
                      )

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

class PortfolioReportTable extends StatefulWidget {
  const PortfolioReportTable({Key? key}) : super(key: key);

  @override
  State<PortfolioReportTable> createState() => _PortfolioReportTableState();
}

class _PortfolioReportTableState extends State<PortfolioReportTable> {
  Color borderColor = const Color(0x9dC13BFD);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 1053.w,
          height: 740.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(topRight: Radius.circular(20.w),
                topLeft: Radius.circular(20.w)),
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
                        text: "반이름" + "의 놀이관찰기록",
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
                        text: "일시",
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
                    cTotalWidth: 276.5.w,
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
                    cTotalWidth: 276.5.w,
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
                        text: "결제",
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
                    cTotalWidth: 276.5.w,
                    cInsideColor: Color(0xffffffff),
                    cTopBorderWidth: 1.w,
                    cLeftBorderWidth: 1.w,
                    childWidget: Center(
                    ),
                  ),
                  CustomContainer(
                    cBorderColor: borderColor,
                    cTotalHeight: 70.w,
                    cTotalWidth: 276.5.w,
                    cInsideColor: Color(0xffffffff),
                    cTopBorderWidth: 1.w,
                    cLeftBorderWidth: 1.w,
                    childWidget: Center(
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
                        text: '담임',
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
                    childWidget: Center(
                    ),
                  ),
                  CustomContainer(
                    cBorderColor: borderColor,
                    cTotalHeight: 70.w,
                    cTotalWidth: 87.w,
                    cInsideColor: Color(0xffCAACF2),
                    cTopBorderWidth: 1.w,
                    cLeftBorderWidth: 1.w,
                    childWidget: Center(
                      child: RecordTableTextStyle(
                        text: '원감',
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
                    childWidget: Center(
                    ),
                  ),
                  CustomContainer(
                    cBorderColor: borderColor,
                    cTotalHeight: 70.w,
                    cTotalWidth: 87.w,
                    cInsideColor: Color(0xffCAACF2),
                    cTopBorderWidth: 1.w,
                    cLeftBorderWidth: 1.w,
                    childWidget: Center(
                      child: RecordTableTextStyle(
                        text: '원장',
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
                    cRightBorderWidth: 1.w,
                    childWidget: Center(
                    ),
                  ),
                ],
              ),



              Row(
                children: [
                  CustomContainer(
                    cBorderColor: borderColor,
                    cTotalHeight: 40.w,
                    cTotalWidth: 276.5.w,
                    cInsideColor: Color(0xffCAACF2),
                    cTopBorderWidth: 1.w,
                    cLeftBorderWidth: 1.w,
                    childWidget: Center(
                      child: RecordTableTextStyle(
                        text: "공간",
                        title: true,
                      ),
                    ),
                  ),
                  CustomContainer(
                    cBorderColor: borderColor,
                    cTotalHeight: 40.w,
                    cTotalWidth: 276.5.w,
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
                    cTotalWidth: 250.w,
                    cInsideColor: Color(0xffCAACF2),
                    cTopBorderWidth: 1.w,
                    cLeftBorderWidth: 1.w,
                    childWidget: Center(
                      child: RecordTableTextStyle(
                        text: "대상유아",
                        title: true,
                      ),
                    ),
                  ),
                  CustomContainer(
                    cBorderColor: borderColor,
                    cTotalHeight: 40.w,
                    cTotalWidth: 250.w,
                    cInsideColor: Color(0xffCAACF2),
                    cTopBorderWidth: 1.w,
                    cLeftBorderWidth: 1.w,
                    cRightBorderWidth: 1.w,
                    childWidget: Center(
                      child: RecordTableTextStyle(
                        text: "참여유아",
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
                    cTotalWidth: 276.5.w,
                    cInsideColor: Color(0xffffffff),
                    cTopBorderWidth: 1.w,
                    cLeftBorderWidth: 1.w,
                    childWidget: Center(
                    ),
                  ),
                  CustomContainer(
                    cBorderColor: borderColor,
                    cTotalHeight: 70.w,
                    cTotalWidth: 276.5.w,
                    cInsideColor: Color(0xffffffff),
                    cTopBorderWidth: 1.w,
                    cLeftBorderWidth: 1.w,
                    childWidget: Center(
                    ),


                  ),
                  CustomContainer(
                    cBorderColor: borderColor,
                    cTotalHeight: 70.w,
                    cTotalWidth: 250.w,
                    cInsideColor: Color(0xffffffff),
                    cTopBorderWidth: 1.w,
                    cLeftBorderWidth: 1.w,
                    childWidget: Center(
                    ),
                  ),
                  CustomContainer(
                    cBorderColor: borderColor,
                    cTotalHeight: 70.w,
                    cTotalWidth: 250.w,
                    cInsideColor: Color(0xffffffff),
                    cTopBorderWidth: 1.w,
                    cLeftBorderWidth: 1.w,
                    cRightBorderWidth: 1.w,
                    childWidget: Center(
                    ),
                  ),
                ],
              ),

              Row(
                children: [
                  CustomContainer(
                    cBorderColor: borderColor,
                    cTotalHeight: 250.w,
                    cTotalWidth: 464.w,
                    cInsideColor: Color(0xffffffff),
                    cTopBorderWidth: 1.w,
                    cLeftBorderWidth: 1.w,
                    childWidget: Center(
                    ),
                  ),
                  CustomContainer(
                    cBorderColor: borderColor,
                    cTotalHeight: 250.w,
                    cTotalWidth: 589.w,
                    cInsideColor: Color(0xffffffff),
                    cTopBorderWidth: 1.w,
                    cLeftBorderWidth: 1.w,
                    cRightBorderWidth: 1.w,
                    childWidget: Center(
                    ),
                  ),
                ],
              ),

              Row(
                children: [
                  CustomContainer(
                    cBorderColor: borderColor,
                    cTotalHeight: 60.w,
                    cTotalWidth: 100.w,
                    cInsideColor: Color(0xffCAACF2),
                    cTopBorderWidth: 1.w,
                    cLeftBorderWidth: 1.w,
                    childWidget: Center(
                      child: RecordTableTextStyle(
                        text: "평가영역",
                        title: true,
                      ),
                    ),
                  ),
                  CustomContainer(
                      cBorderColor: borderColor,
                      cTotalHeight: 60.w,
                      cTotalWidth: 455.w,
                      cInsideColor: Color(0xffffffff),
                      cTopBorderWidth: 1.w,
                      cLeftBorderWidth: 1.w,

                      childWidget: Row(
                        children: [],
                      )
                  ),
                  CustomContainer(
                    cBorderColor: borderColor,
                    cTotalHeight: 60.w,
                    cTotalWidth: 100.w,
                    cInsideColor: Color(0xffCAACF2),
                    cTopBorderWidth: 1.w,
                    cLeftBorderWidth: 1.w,
                    childWidget: Center(
                      child: RecordTableTextStyle(
                        text: "평가방법",
                        title: true,
                      ),
                    ),
                  ),
                  CustomContainer(
                      cBorderColor: borderColor,
                      cTotalHeight: 60.w,
                      cTotalWidth: 398.w,
                      cInsideColor: Color(0xffffffff),
                      cTopBorderWidth: 1.w,
                      cLeftBorderWidth: 1.w,
                      cRightBorderWidth: 1.w,
                      childWidget: Row(
                        children: [],
                      )
                  ),
                ],
              ),
              Row(
                children: [
                  CustomContainer(
                    cBorderColor: borderColor,
                    cTotalHeight: 100.w,
                    cTotalWidth: 100.w,
                    cInsideColor: Color(0xffCAACF2),
                    cTopBorderWidth: 1.w,
                    cLeftBorderWidth: 1.w,
                    childWidget: Center(
                      child: RecordTableTextStyle(
                        text: "평가",
                       title: true,
                      ),
                    ),
                  ),
                  CustomContainer(
                      cBorderColor: borderColor,
                      cTotalHeight: 100.w,
                      cTotalWidth: 953.w,
                      cInsideColor: Color(0xffffffff),
                      cTopBorderWidth: 1.w,
                      cLeftBorderWidth: 1.w,
                      cRightBorderWidth: 1.w,
                      childWidget: Row(
                        children: [],
                      )
                  ),
                ],
              ),

              Row(
                children: [
                  CustomContainer(
                    cBorderColor: borderColor,
                    cTotalHeight: 60.w,
                    cTotalWidth: 100.w,
                    cInsideColor: Color(0xffCAACF2),
                    cBorderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20.w),
                    ),
                    cTopBorderWidth: 1.w,
                    cLeftBorderWidth: 1.w,
                    cBottomBorderWidth: 1.w,
                    childWidget: Center(
                      child: RecordTableTextStyle(
                        text: "비고",
                        title: true,
                      ),
                    ),
                  ),
                  CustomContainer(
                      cBorderColor: borderColor,
                      cTotalHeight: 60.w,
                      cTotalWidth: 953.w,
                      cInsideColor: Color(0xffffffff),
                      cBorderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(20.w),
                      ),
                      cTopBorderWidth: 1.w,
                      cLeftBorderWidth: 1.w,
                      cRightBorderWidth: 1.w,
                      cBottomBorderWidth: 1.w,
                      childWidget: Row(
                        children: [],
                      )
                  ),
                ],
              ),


            ],
          ),
        ),



        Positioned(
            top: 530.w,
            left: 1010.w,
            child: GestureDetector(
              onTap: (){
                showAlignedDialog(
                    offset: Offset(425.w,325.w),
                    barrierColor: Colors.transparent,
                    context: context, builder: (BuildContext context){
                  return PortfolioMethod();
                });

              },
              child: Icon(Icons.arrow_drop_down,
                size: 40.w,
                color: Color(0xff7649B7),),
            )),
        Positioned(
          top: 275.w,
          left: 375.w,
          child: GestureDetector(
            onTap: () {
            },
            child: Stack(
              children: [
                Positioned(
                  top: 5.w,
                  left: 4.w,
                  child: Container(
                    width: 35.w,
                    height: 35.w,
                    decoration: BoxDecoration(
                      borderRadius:
                      BorderRadius.all(Radius.circular(10.w)),
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

                  ),
                ),
                SvgPicture.asset('assets/icons/icon_camera.svg',
                  width: 45.w,
                ),
              ],
            ),
          ),),
        Positioned(
          top: 275.w,
          left: 419.w,
          child: GestureDetector(
            onTap: () {
            },
            child: Stack(
              children: [
                Positioned(
                  top: 5.w,
                  left: 4.w,
                  child: Container(
                    width: 35.w,
                    height: 35.w,
                    decoration: BoxDecoration(
                      borderRadius:
                      BorderRadius.all(Radius.circular(10.w)),
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

                  ),
                ),
                SvgPicture.asset('assets/icons/icon_galery.svg',
                  width: 45.w,
                ),
              ],
            ),
          ),),
        Positioned(
          top: 275.w,
          left: 1006.w,
          child: GestureDetector(
            onTap: () {
            },
            child: Stack(
              children: [
                Positioned(
                  top: 5.w,
                  left: 4.w,
                  child: Container(
                    width: 35.w,
                    height: 35.w,
                    decoration: BoxDecoration(
                      borderRadius:
                      BorderRadius.all(Radius.circular(10.w)),
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

                  ),
                ),
                SvgPicture.asset('assets/icons/icon_voice_record.svg',
                  width: 45.w,
                ),
              ],
            ),
          ),),
        Positioned(
          top: 480.w,
          left: 940.w,
          child: GestureDetector(
            onTap: () {
            },
            child: Container(
                width: 40.w,
                height: 25.w,
                decoration: BoxDecoration(
                  borderRadius:
                  BorderRadius.all(Radius.circular(5.w)),
                  color: Color(0xffFED796),
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
                  child: Text('수정', style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: Color(0xff393838),
                  ),),
                )

            ),
          ),),
        Positioned(
          top: 480.w,
          left: 996.w,
          child: GestureDetector(
            onTap: () {
            },
            child: Container(
                width: 40.w,
                height: 25.w,
                decoration: BoxDecoration(
                  borderRadius:
                  BorderRadius.all(Radius.circular(5.w)),
                  color: Color(0xffFED796),
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
                  child: Text('삭제', style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: Color(0xff393838),
                  ),),
                )

            ),
          ),)


      ],
    );
  }
}


class PortfolioMethod extends StatefulWidget {
  const PortfolioMethod({Key? key}) : super(key: key);

  @override
  State<PortfolioMethod> createState() => _PortfolioMethodState();
}

class _PortfolioMethodState extends State<PortfolioMethod> {
  List<bool> portfolioMethodBtn = [false,false,false,false,false,false,false,];
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200.w,
      height: 333.w,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10.w)),
          color: Color(0xffFFEFD3),
          boxShadow: [
            BoxShadow(
              color: Color(0x29959595),
              blurRadius: 3,
              offset: Offset(2, 2), // changes position of shadow
            ),
          ]
      ),
      child: Stack(
        children: [
          Positioned(
              top: 3.5.w,
              right: 2.w,
              child: GestureDetector(
                onTap: (){
                  Navigator.pop(context);
                },
                child: Icon(Icons.arrow_drop_up,
                  size: 40.w,
                  color: Color(0xffFDB43B),),
              )),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 15.w,
                  ),
                  GestureDetector(
                    onTap: (){
                      setState(() {
                        portfolioMethodBtn[0] = !portfolioMethodBtn[0];
                      });
                    },
                    child: Container(
                      width: 30.w,
                      height: 30.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5.w)),
                        border: Border.all(color: Color(0xffFDB43B), width: 1.w),
                        color: portfolioMethodBtn[0] ? Color(0xffFDB43B) : Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 15.w,
                  ),
                  RecordTableTextStyle(text: '일화기록', title: true),
                ],
              ),
              Row(
                children: [
                  SizedBox(
                    width: 15.w,
                  ),
                  GestureDetector(
                    onTap: (){
                      setState(() {
                        portfolioMethodBtn[1] = !portfolioMethodBtn[1];
                      });
                    },
                    child: Container(
                      width: 30.w,
                      height: 30.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5.w)),
                        border: Border.all(color: Color(0xffFDB43B), width: 1.w),
                        color: portfolioMethodBtn[1] ? Color(0xffFDB43B) : Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 15.w,
                  ),
                  RecordTableTextStyle(text: '체크리스트', title: true),
                ],
              ),
              Row(
                children: [
                  SizedBox(
                    width: 15.w,
                  ),
                  GestureDetector(
                    onTap: (){
                      setState(() {
                        portfolioMethodBtn[2] = !portfolioMethodBtn[2];
                      });
                    },
                    child: Container(
                      width: 30.w,
                      height: 30.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5.w)),
                        border: Border.all(color: Color(0xffFDB43B), width: 1.w),
                        color: portfolioMethodBtn[2] ? Color(0xffFDB43B) : Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 15.w,
                  ),
                  RecordTableTextStyle(text: '사건표집', title: true),
                ],
              ),
              Row(
                children: [
                  SizedBox(
                    width: 15.w,
                  ),
                  GestureDetector(
                    onTap: (){
                      setState(() {
                        portfolioMethodBtn[3] = !portfolioMethodBtn[3];
                      });
                    },
                    child: Container(
                      width: 30.w,
                      height: 30.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5.w)),
                        border: Border.all(color: Color(0xffFDB43B), width: 1.w),
                        color: portfolioMethodBtn[3] ? Color(0xffFDB43B) : Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 15.w,
                  ),
                  RecordTableTextStyle(text: '시간표집', title: true),
                ],
              ),
              Row(
                children: [
                  SizedBox(
                    width: 15.w,
                  ),
                  GestureDetector(
                    onTap: (){
                      setState(() {
                        portfolioMethodBtn[4] = !portfolioMethodBtn[4];
                      });
                    },
                    child: Container(
                      width: 30.w,
                      height: 30.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5.w)),
                        border: Border.all(color: Color(0xffFDB43B), width: 1.w),
                        color: portfolioMethodBtn[4] ? Color(0xffFDB43B) : Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 15.w,
                  ),
                  RecordTableTextStyle(text: '명정척도', title: true),
                ],
              ),
              Row(
                children: [
                  SizedBox(
                    width: 15.w,
                  ),
                  GestureDetector(
                    onTap: (){
                      setState(() {
                        portfolioMethodBtn[5] = !portfolioMethodBtn[5];
                      });
                    },
                    child: Container(
                      width: 30.w,
                      height: 30.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5.w)),
                        border: Border.all(color: Color(0xffFDB43B), width: 1.w),
                        color: portfolioMethodBtn[5] ? Color(0xffFDB43B) : Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 15.w,
                  ),
                  RecordTableTextStyle(text: '유아작품', title: true),
                ],
              ),
              Row(
                children: [
                  SizedBox(
                    width: 15.w,
                  ),
                  GestureDetector(
                    onTap: (){
                      setState(() {
                        portfolioMethodBtn[6] = !portfolioMethodBtn[6];
                      });
                    },
                    child: Container(
                      width: 30.w,
                      height: 30.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5.w)),
                        border: Border.all(color: Color(0xffFDB43B), width: 1.w),
                        color: portfolioMethodBtn[6] ? Color(0xffFDB43B) : Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 15.w,
                  ),
                  RecordTableTextStyle(text: '부모상담', title: true),
                ],
              )

            ],
          )
        ],
      ),
    );
  }
}