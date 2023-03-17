import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:treasure_map/widgets/get_container_info.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:treasure_map/widgets/overtab.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../widgets/custom_container.dart';
import 'd3_1.dart';

class D7_2 extends StatefulWidget {
  const D7_2(
      {Key? key,
      required this.nextPage,
      required this.prePage,
      required this.nowPage,
      this.scaffoldKey})
      : super(key: key);
  final Function nextPage;
  final Function prePage;
  final String nowPage;
  final GlobalKey<ScaffoldState>? scaffoldKey;

  @override
  State<D7_2> createState() => _D7_2State();
}

class _D7_2State extends State<D7_2> {
  bool dateOff = false;

  DateTime pageTime = DateTime.now();
  String pageTimeStr = '';

  double smallTableWidth = 0;
  double smallTableHeight = 90;

  List<int> category = [];

  addDataCategory(int index) {
    setState(() {
      print(index);
      category[index]++;
      addSmallTableSize(category);
    });
  }

  addColumnCategory() {
    setState(() {
      category.add(0);
      addSmallTableSize(category);
    });
  }

  addSmallTableSize(List<int> _category) {
    int length = 0;



    setState(() {

      smallTableWidth = _category.length * 167.w + 55.w;
      for(int i = 0 ; i<_category.length;i++){
        length < _category[i] ? length = _category[i] : length;
      }

      smallTableHeight = length * 120.w + 90.w;

    });
  }

  receiveData(DateTime dateTime) async {
    pageTime = dateTime;
    var formatter = DateFormat('yyyyMMdd');
    pageTimeStr = formatter.format(pageTime);
    setState(() {});
  }

  @override
  initState() {
    addSmallTableSize(category);
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
                        height: 590.w,
                        decoration: BoxDecoration(
                          color: const Color(0xffFCFCFC),
                        ),
                      ),
                      PlayFlowTable(
                        addDataCategory: addDataCategory,
                        addColumnCategory: addColumnCategory,
                        category: category,
                        smallTableHeight: smallTableHeight,
                        smallTableWidth: smallTableWidth,
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

class PlayFlowTable extends StatefulWidget {
  const PlayFlowTable({Key? key,
    required this.category,
    required this.addDataCategory,
    required this.addColumnCategory,
    required this.smallTableHeight,
    required this.smallTableWidth,

  }) : super(key: key);
  final List<int> category;
  final Function(int) addDataCategory;
  final Function() addColumnCategory;
  final double smallTableWidth;
  final double smallTableHeight;

  @override
  State<PlayFlowTable> createState() => _PlayFlowTableState();
}

class _PlayFlowTableState extends State<PlayFlowTable> {
  Color borderColor = const Color(0x9dC13BFD);

  double positionX = 0;
  double positionY = 0;

  @override
  void initState() {

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(
          width: 1053.w,
          height: 590.w,
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
                      text: "반이름" + "반의 놀이흐름도",
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
                  cTotalWidth: 553.w,
                  cInsideColor: Color(0xffCAACF2),
                  cTopBorderWidth: 1.w,
                  cLeftBorderWidth: 1.w,
                  childWidget: Center(
                    child: RecordTableTextStyle(
                      text: "참여유아",
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
                  cTotalWidth: 553.w,
                  cInsideColor: Color(0xffffffff),
                  cTopBorderWidth: 1.w,
                  cLeftBorderWidth: 1.w,
                  childWidget: Center(),
                ),
                // CustomContainer(
                //   cBorderColor: borderColor,
                //   cTotalHeight: 70.w,
                //   cTotalWidth: 276.w,
                //   cInsideColor: Color(0xffffffff),
                //   cTopBorderWidth: 1.w,
                //   cLeftBorderWidth: 1.w,
                //   childWidget: Center(),
                // ),
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
            Row(
              children: [
                CustomContainer(
                  cBorderColor: borderColor,
                  cTotalHeight: 40.w,
                  cTotalWidth: 553.w,
                  cInsideColor: Color(0xffCAACF2),
                  cTopBorderWidth: 1.w,
                  cLeftBorderWidth: 1.w,
                  childWidget: Center(
                    child: RecordTableTextStyle(
                      text: "놀이배경",
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
                  cBottomBorderWidth: 1.w,
                  childWidget: Center(
                    child: RecordTableTextStyle(
                      text: "놀이 흐름도",
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
                  cTotalHeight: 390.w,
                  cTotalWidth: 329.w,
                  cBorderRadius:
                      BorderRadius.only(bottomLeft: Radius.circular(20.w)),
                  cInsideColor: Color(0xffffffff),
                  cTopBorderWidth: 1.w,
                  cLeftBorderWidth: 1.w,
                  cBottomBorderWidth: 1.w,
                  childWidget: GestureDetector(
                    onTap: (){

                    },
                    child: Stack(
                      children: [
                        Positioned(
                          top: 9.w,
                          right: 9.w,
                          child: Container(
                            width: 34.w,
                            height: 34.w,

                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(Radius.circular(5.w)),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0x29505050),

                                    blurRadius: 6,
                                    offset: Offset(1, 1),
                                  )
                                ]

                            ),
                            child: SvgPicture.asset('assets/icons/icon_galery.svg',
                            width: 45.w,),
                          ),
                        ),
                        Positioned(
                          top: 4.w,
                            right: 3.w,
                            child: SvgPicture.asset('assets/icons/icon_galery.svg',
                          width: 45.w,))
                      ],
                    ),
                  ),
                ),
                CustomContainer(
                  cBorderColor: borderColor,
                  cTotalHeight: 390.w,
                  cTotalWidth: 225.w,
                  cBorderRadius:
                      BorderRadius.only(bottomRight: Radius.circular(20.w)),
                  cInsideColor: Color(0xffffffff),
                  cTopBorderWidth: 1.w,
                  cLeftBorderWidth: 1.w,
                  cBottomBorderWidth: 1.w,
                  cRightBorderWidth: 1.w,
                  childWidget: Center(),
                ),
                GestureDetector(
                  onVerticalDragUpdate: (DragUpdateDetails dragUpdateDetails){
                    setState(() {
                          if(positionY >= 0 && dragUpdateDetails.delta.dy >= 0){

                          }else if(390.w - widget.smallTableHeight > positionY && dragUpdateDetails.delta.dy < 0){

                          }
                          else{
                            positionY = positionY + dragUpdateDetails.delta.dy;
                          }
                    });
                  },
                  onHorizontalDragUpdate: (DragUpdateDetails dragUpdateDetails){
                    setState(() {
                      if(positionX > 0 && dragUpdateDetails.delta.dx > 0){

                      }else if( 499.w - widget.smallTableWidth > positionX && dragUpdateDetails.delta.dx < 0){

                      }
                      else{
                        positionX = positionX + dragUpdateDetails.delta.dx;
                      }
                    });
                  },
                  onHorizontalDragEnd: (DragEndDetails dragEndDetails){
                    setState(() {
                      if(positionX > 0 && dragEndDetails.velocity.pixelsPerSecond.dx > 0){
                        positionX=0;
                      }else if(500.w - widget.smallTableWidth > positionX && dragEndDetails.velocity.pixelsPerSecond.dx < 0){
                        if(widget.smallTableWidth < 499.w){

                        }else{
                          positionX=499.w - widget.smallTableWidth;
                        }

                      }
                    });

                  },
                  onVerticalDragEnd: (DragEndDetails dragEndDetails){
                    setState(() {
                      if(positionY > 0 && dragEndDetails.velocity.pixelsPerSecond.dy > 0){
                        positionY=0;
                      }else if(390.w - widget.smallTableHeight > positionY && dragEndDetails.velocity.pixelsPerSecond.dy < 0)  {
                        if(widget.smallTableHeight<390.w){

                        }else{
                          positionY = 390.w - widget.smallTableHeight;
                        }

                      }
                    });

                  },
                  child: Container(
                    width: 499.w,
                    height: 390.w,
                    color: Colors.white,
                    child: Stack(
                      children: [
                        Positioned(
                          top: positionY.w,
                          left: positionX.w,
                          child: Container(
                            width: widget.smallTableWidth.w,
                            height: widget.smallTableHeight.w,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                for(int i = 0 ; i<widget.category.length;i++)...[
                                  Column(
                                    children: [
                                      CustomContainer(
                                        cBorderColor: borderColor,
                                        cTotalHeight: 40.w,
                                        cTotalWidth: 167.w,
                                        cInsideColor: Color(0xffCAACF2),
                                        cBottomBorderWidth: 1.w,
                                        cRightBorderWidth: 1.w,
                                        childWidget: Center(
                                          child: RecordTableTextStyle(
                                            text: "A주제",
                                            title: false,
                                          ),
                                        ),
                                      ),
                                      for(int j = 0; j< widget.category[i];j++)...[
                                        CustomContainer(
                                          cBorderColor: borderColor,
                                          cTotalHeight: 120.w,
                                          cTotalWidth: 167.w,
                                          cInsideColor: Color(0xffffffff),
                                          cBottomBorderWidth: 1.w,
                                          cRightBorderWidth: 1.w,
                                          cLeftBorderWidth: 1.w,
                                          childWidget: Column(
                                            children: [
                                              SizedBox(
                                                height: 14.w,
                                              ),
                                              RecordTableTextStyle(
                                                text: "A소주제",
                                                title: false,
                                              ),
                                              Spacer(),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                children: [
                                                  GestureDetector(
                                                    onTap: (){},
                                                    child:Container(
                                                      width: 34.w,
                                                      height: 34.w,

                                                      child: Center(
                                                        child: Container(
                                                          width: 19.w,
                                                          height: 3.w,
                                                          color: Color(0xffA666FB),
                                                        ),
                                                      ),
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius: BorderRadius.all(Radius.circular(5.w)),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Color(0x29505050),
                                                            blurRadius: 6,
                                                            offset: Offset(1, 1), // changes position of shadow
                                                          ),

                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  GestureDetector(
                                                    onTap: (){},

                                                    child: Stack(
                                                      children : [
                                                        Positioned(
                                                          top : 6.w,
                                                          left : 5.w,
                                                          child: Container(
                                                            width: 34.w,
                                                            height: 34.w,
                                                            decoration: BoxDecoration(
                                                              color: Colors.white,
                                                              borderRadius: BorderRadius.all(Radius.circular(5.w)),
                                                              boxShadow: [
                                                                BoxShadow(
                                                                  color: Color(0x29505050),
                                                                  blurRadius: 6,
                                                                  offset: Offset(1, 1), // changes position of shadow
                                                                ),

                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        SvgPicture.asset('assets/icons/icon_download.svg',
                                                          width: 45.w,),
                                                      ],
                                                    ),
                                                  ),
                                                  GestureDetector(
                                                    onTap: (){},
                                                    child:Container(
                                                      width: 34.w,
                                                      height: 34.w,

                                                      child: Center(
                                                        child: Container(
                                                          width: 19.w,
                                                          height: 3.w,
                                                          color: Color(0xffA666FB),
                                                        ),
                                                      ),
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius: BorderRadius.all(Radius.circular(5.w)),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Color(0x29505050),
                                                            blurRadius: 6,
                                                            offset: Offset(1, 1), // changes position of shadow
                                                          ),

                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 10.w,
                                              )
                                            ],
                                          )
                                        ),
                                      ],
                                      SizedBox(
                                        height: 16.w,
                                      ),
                                      GestureDetector(
                                        onTap: (){
                                          widget.addDataCategory(i);
                                        },
                                        child: Container(
                                          width: 116.w,
                                          height: 34.w,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.all(Radius.circular(5.w)),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Color(0x29505050),
                                                blurRadius: 6,
                                                offset: Offset(1, 1), // changes position of shadow
                                              ),

                                            ],
                                          ),
                                          child: Center(
                                            child: Text('소주제추가',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 12.sp,
                                              color: Color(0xffA666FB),
                                            ),),
                                          ),
                                        ),
                                      )
                                    ],
                                  )
                                ],
                                GestureDetector(
                                  onTap: (){
                                    widget.addColumnCategory();
                                  },
                                  child: SvgPicture.asset('assets/icons/icon_add.svg',
                                  width: 50.w,),
                                )

                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            )
          ]))
    ]);
  }
}
