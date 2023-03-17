import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:treasure_map/e_growth/atti/report/atti_b.dart';
import 'package:treasure_map/e_growth/atti/widget/report_page_header.dart';
import 'package:treasure_map/e_growth/atti/widget/report_text_style.dart';
import 'package:treasure_map/provider/report_data_management.dart';
import 'package:treasure_map/widgets/custom_container.dart';
import 'package:provider/provider.dart';


import '../../../widgets/id_to.dart';

class AttiA extends StatefulWidget {
  const AttiA({
    Key? key,
    required this.changeScreen,
    this.beforeWidget,
  }) : super(key: key);
  final Function(Widget) changeScreen;
  final Widget? beforeWidget;

  @override
  State<AttiA> createState() => _AttiAState();
}

class _AttiAState extends State<AttiA> {



    @override
  void initState() {
      relaytionshipTableCount = (Provider.of<ReportDataManagement>(context,listen: false).cids.length/8).ceil();
      relaytionshipTableRestCount = Provider.of<ReportDataManagement>(context,listen: false).cids.length % 8;
    super.initState();
  }


  int relaytionshipTableCount = 0;
  // ((context.read<ReportDataManagement>().headCount / 8).ceil());
  int relaytionshipTableRestCount = 0;
  // (context.read<ReportDataManagement>().headCount % 8);
  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      // onVerticalDragEnd: (DragEndDetails dragEndDetails){
      //   if (dragEndDetails.primaryVelocity! > 0.0) {
      //     Navigator.push(
      //       context,
      //       MaterialPageRoute(builder: (context) => Home_1()),
      //     );
      //
      //     print("아래");
      //   }
      // },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(50.w),
            bottomLeft: Radius.circular(50.w),
          ),
          color: Color(0xffFCFCFC),
        ),
        child: Column(
          children: [
            Container(
              // color: Color(0xfffcfcfc),
              height: 50.w,
            ),
            ReportPageHeader(
              title: '우리반 또래관계 분석 현황',
              changeScreen: widget.changeScreen,
              nextPage: true,
              beforeWidget: widget.beforeWidget,
              afterWidget: AttiB(beforeWidget: widget, changeScreen: widget.changeScreen, ),
            ),
            Expanded(
              child: ScrollConfiguration(
                behavior: const ScrollBehavior().copyWith(overscroll: false),
                child: ListView(
                  physics: const RangeMaintainingScrollPhysics(),
                  children: [
                    Container(
                      color: Color(0xfffcfcfc),
                      height: 45.w,
                    ),

                    Container(
                        color: Color(0xfffcfcfc),
                        width: 1000.w, child: Row(
                          children: [
                            SizedBox(width: 44.w,),
                            TopicTextStyle(text: '우리반 관계지표'),
                          ],
                        )),
                    Container(
                      color: Color(0xfffcfcfc),
                      height: 20.w,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 44.w,
                        ),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(20.w)),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0x29B1B1B1),
                                    // spreadRadius: ,
                                    blurRadius: 6,
                                    offset: Offset(-2, 2),
                                  )
                                ]),
                            child: Table(
                              border: TableBorder.all(
                                color: Colors.transparent,
                              ),
                              columnWidths: {
                                0: FractionColumnWidth(.06),
                                1: FractionColumnWidth(.16),
                                2: FractionColumnWidth(.14),
                                3: FractionColumnWidth(.14),
                                4: FractionColumnWidth(.14),
                                5: FractionColumnWidth(.14),
                                6: FractionColumnWidth(.14),
                                7: FractionColumnWidth(.14),
                              },
                              // border: TableBorder.all(),
                              children: [
                                TableRow(children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 1, color: Color(0x4D3BFD7E)),
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(20.w)),
                                      color: Color(0xffE2FFE5),
                                    ),
                                    height: 50.w,
                                    child: Center(
                                        child: ReportDefaultTextStyle(text:'순')),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 1, color: Color(0x4D3BFD7E)),
                                      // borderRadius: BorderRadius.only(
                                      //     topLeft: Radius.circular(20.w)),
                                      color: Color(0xffE2FFE5),
                                    ),
                                    height: 50.w,
                                    child: Center(
                                      child: ReportDefaultTextStyle(text: '수집 월'),
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 1, color: Color(0x4D3BFD7E)),
                                      // borderRadius: BorderRadius.only(
                                      //     topLeft: Radius.circular(20.w)),
                                      color: Color(0xffE2FFE5),
                                    ),
                                    height: 50.w,
                                    child: Center(
                                      child: ReportDefaultTextStyle(text: '전체 유아수 '),
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 1, color: Color(0x4D3BFD7E)),
                                      // borderRadius: BorderRadius.only(
                                      //     topLeft: Radius.circular(20.w)),
                                      color: Color(0xffE2FFE5),
                                    ),
                                    height: 50.w,
                                    child: Center(
                                      child: ReportDefaultTextStyle(text: '인기아 수'),
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 1, color: Color(0x4D3BFD7E)),
                                      // borderRadius: BorderRadius.only(
                                      //     topLeft: Radius.circular(20.w)),
                                      color: Color(0xffE2FFE5),
                                    ),
                                    height: 50.w,
                                    child: Center(
                                      child: ReportDefaultTextStyle(text: '보통아 수'),
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 1, color: Color(0x4D3BFD7E)),
                                      // borderRadius: BorderRadius.only(
                                      //     topLeft: Radius.circular(20.w)),
                                      color: Color(0xffE2FFE5),
                                    ),
                                    height: 50.w,
                                    child: Center(
                                      child: ReportDefaultTextStyle(text: '양면아 수'),
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 1, color: Color(0x4D3BFD7E)),
                                      // borderRadius: BorderRadius.only(
                                      //     topLeft: Radius.circular(20.w)),
                                      color: Color(0xffE2FFE5),
                                    ),
                                    height: 50.w,
                                    child: Center(
                                      child: ReportDefaultTextStyle(text: '배척아 수'),
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 1, color: Color(0x4D3BFD7E)),
                                      borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(20.w)),
                                      color: Color(0xffE2FFE5),
                                    ),
                                    height: 50.w,
                                    child: Center(
                                      child: ReportDefaultTextStyle(text: '소외아 수'),
                                    ),
                                  ),
                                ]),
                                for (int i = 0; i < Provider.of<ReportDataManagement>(context,listen: false).reportData.length; i++) ...[
                                  ClassRelationShip(
                                    Provider.of<ReportDataManagement>(context,listen: false).reportData[i]['turn'].toString() + '회차',

                                    Provider.of<ReportDataManagement>(context,listen: false).reportData[i]['startDate'].split('-')[0] + '년 '+
                                        Provider.of<ReportDataManagement>(context,listen: false).reportData[i]['startDate'].split('-')[1]+'월',
                                    Provider.of<ReportDataManagement>(context,listen: false).reportData[i]['headCount'].toString() + '명',
                                    Provider.of<ReportDataManagement>(context,listen: false).reportData[i]['popularCount'].toString() + '명',
                                    Provider.of<ReportDataManagement>(context,listen: false).reportData[i]['commonCount'].toString()+'명',
                                    Provider.of<ReportDataManagement>(context,listen: false).reportData[i]['bothsideCount'].toString() + '명',
                                    Provider.of<ReportDataManagement>(context,listen: false).reportData[i]['ostracizedCount'].toString() + '명',
                                    Provider.of<ReportDataManagement>(context,listen: false).reportData[i]['marginalizedCount'].toString() + '명',
                                    i != Provider.of<ReportDataManagement>(context,listen: false).reportData.length -1
                                  ),
                                ]
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 100.w,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 50.w,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 44.w,
                        ),
                        Container(
                            width: 1000.w, child: TopicTextStyle(text: '또래관계 현황')),
                      ],
                    ),
                    SizedBox(
                      height: 20.w,
                    ),

                    for (int i = 0; i < relaytionshipTableCount; i++) ...[
                        if (i + 1 > Provider.of<ReportDataManagement>(context, listen: false).cids.length / 8) ...[
                          Row(
                            children: [
                              Container(
                                color: Color(0xfffcfcfc),
                                height: (150 + (Provider.of<ReportDataManagement>(context, listen: false).reportData.length -1) * 100 ).w,
                                width: 44.w,

                              ),
                              RelationshipCondition(
                                count: i,
                                restCount: relaytionshipTableRestCount,
                              ),
                            ],
                          ),


                        ] else ...[
                          Row(
                            children: [
                              Container(
                                color: Color(0xfffcfcfc),
                                height: (150 + (Provider.of<ReportDataManagement>(context, listen: false).reportData.length -1) * 100 ).w,
                                width: 44.w,

                              ),
                              RelationshipCondition(
                                count: i,
                              ),
                            ],
                          ),

                            Row(
                              children: [
                                Container(
                                  color: Color(0xfffcfcfc),
                                  height: 30.w,
                                  width: 44.w,

                                ),
                                SizedBox(
                                  height: 30.w,
                                ),
                              ],
                            ),


                        ],
                    ],



                    Container(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          color: Color(0xfffcfcfc),
                          height: 10.w,
                          width: 39.w,
                        )
                      ],
                    )),
                    Container(
                      height: 50.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(50.w),
                        ),
                        color: Color(0xffFCFCFC),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

TableRow ClassRelationShip(
  String time,
  String date,
  String childHeadCount,
  String popularCount,
  String commonCount,
  String bothSideCount,
  String ostracizedCount,
  String marginalizedCount,
    bool last,
) {
  return TableRow(children: [
    Container(
      decoration: BoxDecoration(
        color: Colors.white,

        border: Border.all(
            width: 1, color: Color(0x4D3BFD7E)),
        borderRadius: last ? BorderRadius.zero : BorderRadius.only(
            bottomLeft: Radius.circular(20.w)),
      ),
      height: 50.w,
      child: Center(
        child: ReportDefaultTextStyle(text: time),
      ),
    ),
    Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
            width: 1, color: Color(0x4D3BFD7E)),
      ),
      height: 50.w,
      child: Center(
        child: ReportDefaultTextStyle(text: date),
      ),
    ),
    Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
            width: 1, color: Color(0x4D3BFD7E)),
      ),
      height: 50.w,
      child: Center(
        child: ReportDefaultTextStyle(text:childHeadCount),
      ),
    ),
    Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
            width: 1, color: Color(0x4D3BFD7E)),
      ),
      height: 50.w,
      child: Center(
        child: ReportDefaultTextStyle(text: popularCount),
      ),
    ),
    Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
            width: 1, color: Color(0x4D3BFD7E)),
      ),
      height: 50.w,
      child: Center(
        child: ReportDefaultTextStyle(text: commonCount),
      ),
    ),
    Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
            width: 1, color: Color(0x4D3BFD7E)),
      ),
      height: 50.w,
      child: Center(
        child:ReportDefaultTextStyle(text: bothSideCount),
      ),
    ),
    Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
            width: 1, color: Color(0x4D3BFD7E)),
      ),
      height: 50.w,
      child: Center(
        child: ReportDefaultTextStyle(text: ostracizedCount),
      ),
    ),
    Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
            width: 1, color: Color(0x4D3BFD7E)),
        borderRadius: last ? BorderRadius.zero : BorderRadius.only(
            bottomRight: Radius.circular(20.w)),
      ),
      height: 50.w,
      child: Center(
        child: ReportDefaultTextStyle(text: marginalizedCount),
      ),
    ),
  ]);
}


class RelationshipCondition extends StatefulWidget {
  const RelationshipCondition({
    Key? key,
    required this.count,
    this.restCount = 8,
  }) : super(key: key);
  final int count;
  final int restCount;


  @override
  State<RelationshipCondition> createState() => _RelationshipConditionState();
}

class _RelationshipConditionState extends State<RelationshipCondition> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20.w)),
          boxShadow: [
            BoxShadow(
              color: const Color(0x29B1B1B1),
              // spreadRadius: ,
              blurRadius: 6,
              offset: Offset(-2, 2),
            )
          ]),
      child: Row(
        children: [
          Container(
            width: 60.w,
            child: Column(
              children: [
                CustomContainer(
                  cInsideColor: Color(0xffE2FFE5),
                  cBorderColor: Color(0x4D3BFD7E),
                  cBorderRadius: BorderRadius.only(topLeft: Radius.circular(20.w)),
                  cTopBorderWidth: 1.w,
                  cLeftBorderWidth: 1.w,
                  cTotalWidth: 60.w,
                  cTotalHeight: 50.w,

                  childWidget: Center(
                    child: ReportDefaultTextStyle(text : '순'),
                  ),
                ),

                for (int i = 0; i < Provider.of<ReportDataManagement>(context,listen: false).reportData.length; i++) ...[
                  if(i == Provider.of<ReportDataManagement>(context,listen: false).reportData.length - 1)...[
                    CustomContainer(
                      cTotalHeight: 100.w,
                      cTotalWidth: 60.w,
                      cLeftBorderWidth: 1.w,
                      cBottomBorderWidth: 1.w,
                      cInsideColor: Colors.white,
                      cBorderColor: Color(0x4D3BFD7E),
                      cBorderRadius: BorderRadius.only(bottomLeft: Radius.circular(20.w)),
                      childWidget: Center(
                        child: ReportDefaultTextStyle(text : Provider.of<ReportDataManagement>(context,listen: false).reportData[i]['turn'].toString() + '회차'),
                      ),
                    ),
                  ]else...[
                    CustomContainer(
                      cTotalHeight: 100.w,
                      cTotalWidth: 60.w,
                      cLeftBorderWidth: 1.w,
                      cBottomBorderWidth: 1.w,
                      cInsideColor: Colors.white,
                      cBorderColor: Color(0x4D3BFD7E),
                      // cBorderRadius: BorderRadius.only(bottomLeft: Radius.circular(20.w)),
                      childWidget: Center(
                        child: ReportDefaultTextStyle(text : Provider.of<ReportDataManagement>(context,listen: false).reportData[i]['turn'].toString() + '회차'),
                      ),
                    ),
                  ]

                ],
              ],
            ),
          ),
          Container(
            width: 150.w,
            child: Column(
              children: [
                CustomContainer(
                  cInsideColor: Color(0xffE2FFE5),
                  cBorderColor: Color(0x4D3BFD7E),
                  cTopBorderWidth: 1.w,
                  cLeftBorderWidth: 1.w,
                  cTotalWidth: 160.w,
                  cTotalHeight: 50.w,

                ),

                for (int i = 0; i < Provider.of<ReportDataManagement>(context,listen: false).reportData.length; i++) ...[
                  CustomContainer(
                    cTotalHeight: 50.w,
                    cTotalWidth: 150.w,
                    cLeftBorderWidth: 1.w,
                    cBottomBorderWidth: 1.w,
                    cRightBorderWidth: 1.w,
                    cInsideColor: Colors.white,
                    cBorderColor: Color(0x4D3BFD7E),
                    childWidget: Center(
                      child: ReportDefaultTextStyle(text : '긍정지명'),
                    ),
                  ), CustomContainer(
                    cTotalHeight: 50.w,
                    cTotalWidth: 150.w,
                    cLeftBorderWidth: 1.w,
                    cBottomBorderWidth: 1.w,
                    cRightBorderWidth: 1.w,
                    cInsideColor: Colors.white,
                    cBorderColor: Color(0x4D3BFD7E),
                    childWidget: Center(
                      child: ReportDefaultTextStyle(text : '부정지명'),
                    ),
                  ),
                ],
              ],
            ),
          ),


          for (int i = 0; i < widget.restCount; i++) ...[
            Container(
              width: 105.w,
              child: Column(
                children: [
                  (widget.restCount == (i + 1)) != true ?
                  CustomContainer(
                    cTotalHeight: 50.w,
                    cTotalWidth: 105.w,
                    cTopBorderWidth: 1.w,
                    cBottomBorderWidth: 1.w,
                    cRightBorderWidth: 1.w,
                    cInsideColor: Color(0xffE2FFE5),
                    cBorderColor: Color(0x4D3BFD7E),
                    childWidget: Center(
                      child: ReportDefaultTextStyle(text : Provider.of<IdTo>(context,listen: false).IdToName(Provider.of<ReportDataManagement>(context,listen: false).cids[i + widget.count * 8], context)),
                    ),
                  ) : CustomContainer(
                    cTotalHeight: 50.w,
                    cTotalWidth: 105.w,
                    cTopBorderWidth: 1.w,
                    cBottomBorderWidth: 1.w,
                    cRightBorderWidth: 1.w,
                    cBorderRadius: BorderRadius.only(topRight: Radius.circular(20.w)),
                    cInsideColor: Color(0xffE2FFE5),
                    cBorderColor: Color(0x4D3BFD7E),
                    childWidget: Center(
                      child: ReportDefaultTextStyle(text : Provider.of<IdTo>(context,listen: false).IdToName(Provider.of<ReportDataManagement>(context,listen: false).cids[i + widget.count * 8], context)),
                    ),
                  ),

                  for (int j= 0; j < Provider.of<ReportDataManagement>(context,listen: false).reportData.length; j++) ...[
                    CustomContainer(
                      cTotalHeight: 50.w,
                      cTotalWidth: 105.w,
                      cBottomBorderWidth: 1.w,
                      cRightBorderWidth: 1.w,
                      cInsideColor: Colors.white,
                      cBorderColor: Color(0x4D3BFD7E),
                      childWidget: Center(
                        child: ReportDefaultTextStyle(text :
                        // Provider.of<ReportDataManagement>(context,listen: false).reportData[j]['positivePointingCount'][i + widget.count * 8].toString()
                        Provider.of<IdTo>(context,listen: false).IdToData(Provider.of<ReportDataManagement>(context,listen: false).cids[i + widget.count * 8], 'positivePointingCount', j, context)
                        ),
                      ),
                    ),
                    (widget.restCount == (i + 1)) != true ?
                    CustomContainer(
                      cTotalHeight: 50.w,
                      cTotalWidth: 105.w,
                      cBottomBorderWidth: 1.w,
                      cRightBorderWidth: 1.w,
                      cInsideColor: Colors.white,
                      cBorderColor: Color(0x4D3BFD7E),
                      childWidget: Center(
                        child: ReportDefaultTextStyle(text :
                        // Provider.of<ReportDataManagement>(context,listen: false).reportData[j]['onePointingCount'][i + widget.count * 8].toString()
                        Provider.of<IdTo>(context,listen: false).IdToData(Provider.of<ReportDataManagement>(context,listen: false).cids[i + widget.count * 8], 'onePointingCount', j, context)
                        ),
                      ),
                    ):CustomContainer(
                      cTotalHeight: 50.w,
                      cTotalWidth: 105.w,
                      cBottomBorderWidth: 1.w,
                      cRightBorderWidth: 1.w,
                      cInsideColor: Colors.white,
                      cBorderColor: Color(0x4D3BFD7E),
                      cBorderRadius: j == Provider.of<ReportDataManagement>(context,listen: false).reportData.length -1 ? BorderRadius.only(bottomRight: Radius.circular(20.w)) : BorderRadius.zero,
                      childWidget: Center(
                        child: ReportDefaultTextStyle(text :
                        // Provider.of<ReportDataManagement>(context,listen: false).reportData[j]['onePointingCount'][i + widget.count * 8].toString()
                        Provider.of<IdTo>(context,listen: false).IdToData(Provider.of<ReportDataManagement>(context,listen: false).cids[i + widget.count * 8], 'onePointingCount', j, context)
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ]
        ],
      ),
    );
  }
}

