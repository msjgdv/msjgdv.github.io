import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:treasure_map/e_growth/atti/widget/report_page_header.dart';
import 'package:treasure_map/e_growth/atti/widget/report_text_style.dart';
import 'package:treasure_map/widgets/custom_container.dart';
import 'package:provider/provider.dart';
import '../../../provider/report_data_management.dart';
import '../../../widgets/id_to.dart';

class AttiB extends StatefulWidget {
  const AttiB({
    Key? key,
    required this.changeScreen,
    required this.beforeWidget,
  }) : super(key: key);
  final Function(Widget) changeScreen;
  final Widget beforeWidget;

  @override
  State<AttiB> createState() => _AttiBState();
}

class _AttiBState extends State<AttiB> {
  int headCount = 30;
  int relaytionshipTableCount = 0;
  int relaytionshipTableRestCount = 0;

  @override
  void initState() {
    headCount = Provider.of<ReportDataManagement>(context, listen: false).cids.length;
    relaytionshipTableCount = (headCount / 8).ceil();
    relaytionshipTableRestCount = headCount % 8;
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
          Container(
            // color: Color(0xfffcfcfc),
            height: 50.w,
          ),
          ReportPageHeader(
            title: '사회연결망 중앙성 지표',
            changeScreen: widget.changeScreen,
            nextPage: false,
            beforeWidget: widget.beforeWidget,
          ),
          Expanded(
              child: ScrollConfiguration(
                behavior: const ScrollBehavior().copyWith(overscroll: false),
                child: ListView(
                  physics: const RangeMaintainingScrollPhysics(),
            children: [
                for (int i = 0; i < relaytionshipTableCount; i++) ...[
                  if (i + 1 > headCount / 8) ...[
                    Row(
                      children: [
                        Container(
                          color: Color(0xfffcfcfc),
                          height:(200 + (Provider.of<ReportDataManagement>(context, listen: false).reportData.length -1) * 150 ).w,

                          width: 44.w,
                        ),
                        CentralityIndicators(
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
                          height: (200 + (Provider.of<ReportDataManagement>(context, listen: false).reportData.length -1) * 150 ).w,
                          width: 44.w,
                        ),
                        CentralityIndicators(
                          count: i,

                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          color: Color(0xfffcfcfc),
                          height: 50.w,
                          width: 44.w,
                        ),
                        SizedBox(
                          height: 50.w,
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
              ))
        ],
      ),
    );
  }
}

class CentralityIndicators extends StatefulWidget {
  const CentralityIndicators({
    Key? key,
    required this.count,
    this.restCount = 8,
  }) : super(key: key);
  final int count;
  final int restCount;

  @override
  State<CentralityIndicators> createState() => _CentralityIndicatorsState();
}

class _CentralityIndicatorsState extends State<CentralityIndicators> {
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
                  cBorderRadius:
                      BorderRadius.only(topLeft: Radius.circular(20.w)),
                  cTopBorderWidth: 1.w,
                  cLeftBorderWidth: 1.w,
                  cTotalWidth: 60.w,
                  cTotalHeight: 50.w,
                  childWidget: Center(
                    child: ReportDefaultTextStyle(text: '순'),
                  ),
                ),
                for (int i = 0; i < Provider.of<ReportDataManagement>(context, listen: false).reportData.length; i++) ...[
                  CustomContainer(
                    cTotalHeight: 150.w,
                    cTotalWidth: 60.w,
                    cLeftBorderWidth: 1.w,
                    cBottomBorderWidth: 1.w,
                    cInsideColor: Colors.white,
                    cBorderColor: Color(0x4D3BFD7E),
                    cBorderRadius:i == (Provider.of<ReportDataManagement>(context,listen: false).reportData.length -1) ?
                    BorderRadius.only(bottomLeft: Radius.circular(20.w)) : BorderRadius.zero,
                    childWidget: Center(
                      child: ReportDefaultTextStyle(text: Provider.of<ReportDataManagement>(context, listen: false).reportData[i]['turn'].toString() + '회차'),
                    ),
                  ),
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
                for (int i = 0; i < Provider.of<ReportDataManagement>(context, listen: false).reportData.length; i++) ...[
                  CustomContainer(
                    cTotalHeight: 50.w,
                    cTotalWidth: 150.w,
                    cLeftBorderWidth: 1.w,
                    cBottomBorderWidth: 1.w,
                    cRightBorderWidth: 1.w,
                    cInsideColor: Colors.white,
                    cBorderColor: Color(0x4D3BFD7E),
                    childWidget: Center(
                      child: ReportDefaultTextStyle(text: '연결중심성'),
                    ),
                  ),
                  CustomContainer(
                    cTotalHeight: 50.w,
                    cTotalWidth: 150.w,
                    cLeftBorderWidth: 1.w,
                    cBottomBorderWidth: 1.w,
                    cRightBorderWidth: 1.w,
                    cInsideColor: Colors.white,
                    cBorderColor: Color(0x4D3BFD7E),
                    childWidget: Center(
                      child: ReportDefaultTextStyle(text: '매개역할 수준'),
                    ),
                  ),
                  CustomContainer(
                    cTotalHeight: 50.w,
                    cTotalWidth: 150.w,
                    cLeftBorderWidth: 1.w,
                    cBottomBorderWidth: 1.w,
                    cRightBorderWidth: 1.w,
                    cInsideColor: Colors.white,
                    cBorderColor: Color(0x4D3BFD7E),
                    childWidget: Center(
                      child: ReportDefaultTextStyle(text: '영향력 수준'),
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
                  (widget.restCount == (i + 1)) != true
                      ? CustomContainer(
                          cTotalHeight: 50.w,
                          cTotalWidth: 105.w,
                          cTopBorderWidth: 1.w,
                          cBottomBorderWidth: 1.w,
                          cRightBorderWidth: 1.w,
                          cInsideColor: Color(0xffE2FFE5),
                          cBorderColor: Color(0x4D3BFD7E),
                          childWidget: Center(
                            child: ReportDefaultTextStyle(
                                text: Provider.of<IdTo>(context,listen: false).IdToName(Provider.of<ReportDataManagement>(context,listen: false).cids[i + widget.count * 8], context)),
                          ),
                        )
                      : CustomContainer(
                          cTotalHeight: 50.w,
                          cTotalWidth: 105.w,
                          cTopBorderWidth: 1.w,
                          cBottomBorderWidth: 1.w,
                          cRightBorderWidth: 1.w,
                          cBorderRadius: BorderRadius.only(
                              topRight: Radius.circular(20.w)),
                          cInsideColor: Color(0xffE2FFE5),
                          cBorderColor: Color(0x4D3BFD7E),
                          childWidget: Center(
                            child: ReportDefaultTextStyle(
                                text: Provider.of<IdTo>(context,listen: false).IdToName(Provider.of<ReportDataManagement>(context,listen: false).cids[i + widget.count * 8], context)),
                          ),
                        ),
                  for (int j = 0; j < Provider.of<ReportDataManagement>(context, listen: false).reportData.length; j++) ...[
                    CustomContainer(
                      cTotalHeight: 50.w,
                      cTotalWidth: 105.w,
                      cBottomBorderWidth: 1.w,
                      cRightBorderWidth: 1.w,
                      cInsideColor: Colors.white,
                      cBorderColor: Color(0x4D3BFD7E),
                      childWidget: Center(
                        child:
    ReportDefaultTextStyle(text:
    // Provider.of<ReportDataManagement>(context,listen: false).reportData[j]degreeCentrality[i + widget.count * 8].toStringAsFixed(2)
    Provider.of<IdTo>(context,listen: false).IdToData(Provider.of<ReportDataManagement>(context,listen: false).cids[i + widget.count * 8], 'degreeCentrality', j, context)
    ),
                      ),
                    ),
                    CustomContainer(
                      cTotalHeight: 50.w,
                      cTotalWidth: 105.w,
                      cBottomBorderWidth: 1.w,
                      cRightBorderWidth: 1.w,
                      cInsideColor: Colors.white,
                      cBorderColor: Color(0x4D3BFD7E),
                      childWidget: Center(
                        child: ReportDefaultTextStyle(text:
                        // Provider.of<ReportDataManagement>(context,listen: false).betweennessCentrality[i + widget.count * 8].toStringAsFixed(2)
                        Provider.of<IdTo>(context,listen: false).IdToData(Provider.of<ReportDataManagement>(context,listen: false).cids[i + widget.count * 8], 'betweennessCentrality', j, context)
                        ),
                      ),
                    ),
                    (widget.restCount == (i + 1)) != true
                        ? CustomContainer(
                            cTotalHeight: 50.w,
                            cTotalWidth: 105.w,
                            cBottomBorderWidth: 1.w,
                            cRightBorderWidth: 1.w,
                            cInsideColor: Colors.white,
                            cBorderColor: Color(0x4D3BFD7E),
                            childWidget: Center(
                              child: ReportDefaultTextStyle(text:
                                // Provider.of<ReportDataManagement>(context,listen: false).closenessCentrality[i + widget.count * 8].toStringAsFixed(2)
                                  Provider.of<IdTo>(context,listen: false).IdToData(Provider.of<ReportDataManagement>(context,listen: false).cids[i + widget.count * 8], 'closenessCentrality', j, context)
                              ),
                            ),
                          )
                        : CustomContainer(
                            cTotalHeight: 50.w,
                            cTotalWidth: 105.w,
                            cBottomBorderWidth: 1.w,
                            cRightBorderWidth: 1.w,
                            cInsideColor: Colors.white,
                            cBorderColor: Color(0x4D3BFD7E),
                            cBorderRadius: j == (Provider.of<ReportDataManagement>(context,listen: false).reportData.length -1) ? BorderRadius.only(
                                bottomRight:Radius.circular(20.w)) : BorderRadius.zero,
                            childWidget: Center(
                              child: ReportDefaultTextStyle(text:
                              // Provider.of<ReportDataManagement>(context,listen: false).closenessCentrality[i + widget.count * 8].toStringAsFixed(2)
                              Provider.of<IdTo>(context,listen: false).IdToData(Provider.of<ReportDataManagement>(context,listen: false).cids[i + widget.count * 8], 'closenessCentrality', j, context)
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
