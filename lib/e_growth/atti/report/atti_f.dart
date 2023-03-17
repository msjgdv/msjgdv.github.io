import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:treasure_map/provider/report_data_management.dart';
import 'package:widget_mask/widget_mask.dart';

import '../../../widgets/id_to.dart';
import '../widget/peer_graphview.dart';
import '../widget/report_page_header.dart';

class AttiF extends StatefulWidget {
  const AttiF({
    Key? key,
    required this.changeScreen,
    this.beforeWidget,
  }) : super(key: key);
  final Function(Widget) changeScreen;
  final Widget? beforeWidget;

  @override
  State<AttiF> createState() => _AttiFState();
}

class _AttiFState extends State<AttiF> {
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
            height: 50.w,
          ),
          ReportPageHeader(
            title: '우리반 또래 인기도',
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
                Row(
                  children: [
                    Container(
                      width: 59.w,
                      color: Color(0xffFCFCFC),
                      height: (150 + 125 * (Provider.of<ReportDataManagement>(context,listen: false).reportData.last['nominationPopularId'].length /8).ceil()).w,
                    ),
                    Container(
                      width: 1021.w,
                      height: (150 + 125 * (Provider.of<ReportDataManagement>(context,listen: false).reportData.last['nominationPopularId'].length /8).ceil()).w,
                      decoration: BoxDecoration(
                        border: Border.all(width: 1.w, color: Color(0x663BFD7E)),
                        borderRadius: BorderRadius.all(Radius.circular(20.w)),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0x29B1B1B1),
                            blurRadius: 6,
                            offset: Offset(-2, 2), // changes position of shadow
                          ),
                          BoxShadow(
                            color: Color(0x1a3BFD7E),
                            blurRadius: 8,
                            // spreadRadius: -12.0,
                            offset: Offset(-7, 7), // changes position of shadow
                          ),
                          BoxShadow(
                            color: Color(0xffffffff),
                            blurRadius: 5,
                            spreadRadius: -3.0,
                            offset: Offset(0, 0), // changes position of shadow
                          ),
                        ],
                        // color: Colors.white
                      ),
                      child: Container(
                        child: Column(
                          children: [
                            SizedBox(
                              height: 28.w,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "인기아",
                                  style: TextStyle(
                                    fontSize: 18.w,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xff393838),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 10.w,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "유아가 획득한 총점을 기준으로 상위 30%의 아이들",
                                  style: TextStyle(
                                    fontSize: 16.w,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xff393838),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 47.w,
                            ),
                            Column(
                              children: [
                                for (int i = 0, j =0; i <(Provider.of<ReportDataManagement>(context,listen: false).reportData.last['nominationPopularId'].length /8).ceil();i++) ...[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      if (i <(Provider.of<ReportDataManagement>(context,listen: false).reportData.last['nominationPopularId'].length /8).ceil() -1) ...[
                                        for (int k = 0;k <8;k++,j++) ...[
                                          ChildFace(
                                            childId: Provider.of<
                                                        ReportDataManagement>(context,listen: false).reportData.last['nominationPopularId'][j],
                                            colorType: 0,
                                          ),
                                          if (k != 8 - 1) ...[
                                            SizedBox(
                                              width: 21.w,
                                            ),
                                          ]
                                        ]
                                      ] else if (i ==(Provider.of<ReportDataManagement>(context,listen: false).reportData.last['nominationPopularId'].length /8).ceil() -1)...[
                                          for(int k = 0;
                                          k <(Provider.of<ReportDataManagement>(context,listen: false).reportData.last['nominationPopularId'].length%8 == 0 ? 8 : Provider.of<ReportDataManagement>(context,listen: false).reportData.last['nominationPopularId'].length%8);k++,j++)...[
                                            ChildFace(
                                              childId: Provider.of<
                                                  ReportDataManagement>(context,listen: false).reportData.last['nominationPopularId'][j],
                                              colorType: 0,
                                            ),
                                            if (k != (Provider.of<ReportDataManagement>(context,listen: false).reportData.last['nominationPopularId'].length%8 == 0 ? 8 : Provider.of<ReportDataManagement>(context,listen: false).reportData.last['nominationPopularId'].length%8) - 1) ...[
                                              SizedBox(
                                                width: 21.w,
                                              ),
                                            ]
                                          ],

                                        ],
                                    ],
                                  ),
                                  if(i != (Provider.of<ReportDataManagement>(context,listen: false).reportData.last['nominationPopularId'].length /8).ceil()-1)...[
                                    SizedBox(
                                      height: 20.w,
                                    ),
                                  ],
                                ],
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  width: 59.w,
                  color: Color(0xffFCFCFC),
                  height: 25.w,
                ),
                Row(
                  children: [
                    Container(
                      width: 59.w,
                      color: Color(0xffFCFCFC),
                      height: (150 + 125 * (Provider.of<ReportDataManagement>(context,listen: false).reportData.last['nominationCommonId'].length /8).ceil()).w,
                    ),
                    Container(
                      width: 1021.w,
                      height: (150 + 125 * (Provider.of<ReportDataManagement>(context,listen: false).reportData.last['nominationCommonId'].length /8).ceil()).w,
                      decoration: BoxDecoration(
                        border: Border.all(width: 1.w, color: Color(0x663BFD7E)),
                        borderRadius: BorderRadius.all(Radius.circular(20.w)),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0x29B1B1B1),
                            blurRadius: 6,
                            offset: Offset(-2, 2), // changes position of shadow
                          ),
                          BoxShadow(
                            color: Color(0x1a3BFD7E),
                            blurRadius: 8,
                            // spreadRadius: -12.0,
                            offset: Offset(-7, 7), // changes position of shadow
                          ),
                          BoxShadow(
                            color: Color(0xffffffff),
                            blurRadius: 5,
                            spreadRadius: -3.0,
                            offset: Offset(0, 0), // changes position of shadow
                          ),
                        ],
                        // color: Colors.white
                      ),
                      child: Container(
                        child: Column(
                          children: [
                            SizedBox(
                              height: 28.w,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "보통아",
                                  style: TextStyle(
                                    fontSize: 18.w,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xff393838),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 10.w,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "유아가 획득한 총점을 기준으로 상위 30%~70%의 아이들",
                                  style: TextStyle(
                                    fontSize: 16.w,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xff393838),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 47.w,
                            ),
                            Column(
                              children: [
                                for (int i = 0, j =0; i <(Provider.of<ReportDataManagement>(context,listen: false).reportData.last['nominationCommonId'].length /8).ceil();i++) ...[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      if (i <(Provider.of<ReportDataManagement>(context,listen: false).reportData.last['nominationCommonId'].length /8).ceil() -1) ...[
                                        for (int k = 0;k <8;k++,j++) ...[
                                          ChildFace(
                                            childId: Provider.of<
                                                ReportDataManagement>(context,listen: false).reportData.last['nominationCommonId'][j],
                                            colorType: 0,
                                          ),
                                          if (k != 8 - 1) ...[
                                            SizedBox(
                                              width: 21.w,
                                            ),
                                          ]
                                        ]
                                      ] else if (i ==(Provider.of<ReportDataManagement>(context,listen: false).reportData.last['nominationCommonId'].length /8).ceil() -1)...[
                                        for(int k = 0;
                                        k <(Provider.of<ReportDataManagement>(context,listen: false).reportData.last['nominationCommonId'].length%8 == 0 ? 8 : Provider.of<ReportDataManagement>(context,listen: false).reportData.last['nominationCommonId'].length%8);k++,j++)...[
                                          ChildFace(
                                            childId: Provider.of<
                                                ReportDataManagement>(
                                                context,
                                                listen: false)
                                                .reportData.last['nominationCommonId'][j],
                                            colorType: 0,
                                          ),
                                          if (k != (Provider.of<ReportDataManagement>(context,listen: false).reportData.last['nominationCommonId'].length%8 == 0 ? 8 : Provider.of<ReportDataManagement>(context,listen: false).reportData.last['nominationCommonId'].length%8) - 1) ...[
                                            SizedBox(
                                              width: 21.w,
                                            ),
                                          ]
                                        ],

                                      ],
                                    ],
                                  ),
                                  if(i != (Provider.of<ReportDataManagement>(context,listen: false).reportData.last['nominationCommonId'].length /8).ceil()-1)...[
                                    SizedBox(
                                      height: 20.w,
                                    ),
                                  ],
                                ],
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  width: 59.w,
                  color: Color(0xffFCFCFC),
                  height: 25.w,
                ),
                Row(
                  children: [
                    Container(
                      width: 59.w,
                      color: Color(0xffFCFCFC),
                      height: (150 + 125 * (Provider.of<ReportDataManagement>(context,listen: false).reportData.last['nominationUnpopularId'].length /8).ceil()).w,
                    ),
                    Container(
                      width: 1021.w,
                      height: (150 + 125 * (Provider.of<ReportDataManagement>(context,listen: false).reportData.last['nominationUnpopularId'].length /8).ceil()).w,
                      decoration: BoxDecoration(
                        border: Border.all(width: 1.w, color: Color(0x663BFD7E)),
                        borderRadius: BorderRadius.all(Radius.circular(20.w)),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0x29B1B1B1),
                            blurRadius: 6,
                            offset: Offset(-2, 2), // changes position of shadow
                          ),
                          BoxShadow(
                            color: Color(0x1a3BFD7E),
                            blurRadius: 8,
                            // spreadRadius: -12.0,
                            offset: Offset(-7, 7), // changes position of shadow
                          ),
                          BoxShadow(
                            color: Color(0xffffffff),
                            blurRadius: 5,
                            spreadRadius: -3.0,
                            offset: Offset(0, 0), // changes position of shadow
                          ),
                        ],
                        // color: Colors.white
                      ),
                      child: Container(
                        child: Column(
                          children: [
                            SizedBox(
                              height: 28.w,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "비인기아",
                                  style: TextStyle(
                                    fontSize: 18.w,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xff393838),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 10.w,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "유아가 획득한 총점을 기준으로 하위 30%의 아이들",
                                  style: TextStyle(
                                    fontSize: 16.w,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xff393838),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 47.w,
                            ),
                            Column(
                              children: [
                                for (int i = 0, j =0; i <(Provider.of<ReportDataManagement>(context,listen: false).reportData.last['nominationUnpopularId'].length /8).ceil();i++) ...[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      if (i <(Provider.of<ReportDataManagement>(context,listen: false).reportData.last['nominationUnpopularId'].length /8).ceil() -1) ...[
                                        for (int k = 0;k <8;k++,j++) ...[
                                          ChildFace(
                                            childId: Provider.of<
                                                ReportDataManagement>(context,listen: false).reportData.last['nominationUnpopularId'][j],
                                            colorType: 0,
                                          ),
                                          if (k != 8 - 1) ...[
                                            SizedBox(
                                              width: 21.w,
                                            ),
                                          ]
                                        ]
                                      ] else if (i ==(Provider.of<ReportDataManagement>(context,listen: false).reportData.last['nominationUnpopularId'].length /8).ceil() -1)...[
                                        for(int k = 0;
                                        k <(Provider.of<ReportDataManagement>(context,listen: false).reportData.last['nominationUnpopularId'].length%8 == 0 ? 8 : Provider.of<ReportDataManagement>(context,listen: false).reportData.last['nominationUnpopularId'].length%8);k++,j++)...[
                                          ChildFace(
                                            childId: Provider.of<
                                                ReportDataManagement>(context,listen: false).reportData.last['nominationUnpopularId'][j],
                                            colorType: 0,
                                          ),
                                          if (k != (Provider.of<ReportDataManagement>(context,listen: false).reportData.last['nominationUnpopularId'].length%8 == 0 ? 8 : Provider.of<ReportDataManagement>(context,listen: false).reportData.last['nominationUnpopularId'].length%8) - 1) ...[
                                            SizedBox(
                                              width: 21.w,
                                            ),
                                          ]
                                        ],

                                      ],
                                    ],
                                  ),
                                  if(i != (Provider.of<ReportDataManagement>(context,listen: false).reportData.last['nominationUnpopularId'].length /8).ceil()-1)...[
                                    SizedBox(
                                      height: 20.w,
                                    ),
                                  ],
                                ],
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
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

class ChildFace extends StatefulWidget {
  const ChildFace({
    Key? key,
    required this.childId,
    required this.colorType,
  }) : super(key: key);
  final int childId;
  final int colorType;

  @override
  State<ChildFace> createState() => _ChildFaceState();
}

class _ChildFaceState extends State<ChildFace> {
  List<Color> borderColor = [
    Color(0x4dA666FC),
    Color(0x663BFD7E),
    Color(0x663BFD7E)
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 86.w,
      height: 100.w,
      child: Stack(
        children: [
          Positioned(
            left: 6.w,
            child: Container(
                width: 74.w,
                height: 74.w,
                decoration: BoxDecoration(
                    border: Border.all(
                        width: 1.w, color: borderColor[widget.colorType]),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x297B7B7B),
                        blurRadius: 4,
                        offset: Offset(3, 3), // changes position of shadow
                      ),
                    ]),
                child: WidgetMask(
                    blendMode: BlendMode.srcATop,
                    childSaveLayer: true,
                    mask: Provider.of<IdTo>(context, listen: false)
                        .IdToImage(widget.childId, context),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      width: 74.w,
                      height: 74.w,
                    ))),
          ),
          Positioned(
              top: 70.w,
              child: Container(
                width: 86.w,
                height: 26.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10.w)),
                  border: Border.all(
                      width: 1, color: borderColor[widget.colorType]),
                  color: Colors.white,
                ),
                child: Center(
                  child: Text(
                    Provider.of<IdTo>(context, listen: false)
                        .IdToName(widget.childId, context),
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 14.w,
                      color: Color(0xff393838),
                    ),
                  ),
                ),
              ))
        ],
      ),
    );
  }
}
