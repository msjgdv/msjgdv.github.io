import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:dio/dio.dart';
import 'dart:async';
import 'package:provider/provider.dart';
import 'package:widget_mask/widget_mask.dart';

class KinderInfoWidget extends StatefulWidget {
  const KinderInfoWidget({
    Key? key,
    required this.data,
    required this.kindergartenImage,
    required this.classGraphRate,
    required this.childGraphRate,
    required this.floorImage,
    required this.nextPage,
    required this.delayTimer,
    required this.timer,
  }) : super(key: key);
  final Map<String, dynamic> data;
  final Image? kindergartenImage;
  final List<double> classGraphRate;
  final List<double> childGraphRate;
  final List<Image> floorImage;
  final Function() nextPage;
  final Timer timer;
  final Function(int, Function()) delayTimer;

  @override
  State<KinderInfoWidget> createState() => _KinderInfoWidgetState();
}

class _KinderInfoWidgetState extends State<KinderInfoWidget> {
  int touchedIndex = -1;
  List<Widget> floorImage = [];
  int floorPage = 0;

  pageRoute(){
    if(floorPage > widget.floorImage.length){
      widget.nextPage();
    }else{
      widget.delayTimer(15, (){
        setState(() {
          floorPage++;
          pageRoute();
        });
      });
      // widget.timer;
    }
  }

  @override
  void initState() {
    floorImage.add(FloorInfo(data: widget.data));
    for (int i = 0; i < widget.floorImage.length; i++) {
      floorImage.add(FloorImageWidget(floorImage: widget.floorImage[i]));
    }
    widget.delayTimer(15, (){pageRoute();});
    widget.timer;
    super.initState();
  }

  List<Color> classGraphColor = [
    const Color(0xffc7f7f5),
    const Color(0xffc6d0f4),
    const Color(0xfff4dac6),
    const Color(0xfff4f4c6),
    const Color(0xfff4c6ed)
  ];

  List<String> firstRowStr = [
    "교실수",
    "면적",
    "실내",
    "면적",
    "실외",
    "면적",
    "옥상",
    "면적",
    "인근",
    "면적"
  ];

  List<String> secondRowStr = [
    "수",
    "면적",
    "수",
    "면적",
    "수",
    "면적",
    "수",
    "면적",
  ];
  List<String> thirdRowStr = [
    "수",
    "면적",
    "수",
    "면적",
    "수",
    "면적",
    "수",
    "면적",
  ];

  double boyrate = 0.5;
  double girlrate = 0.78;

  List<dynamic> childClassName = [
    '꽃사랑',
    '개나리',
    '진달래',
    '방울꽃',
    '계란꽃',
    '아카시아',
    '튤립',
    '해바라기',
    //'금잔디',
    //'소나무',
  ]; //반 이름입니다.

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ///<어린이집 사진
          Container(
            width: 400.w,
            height: 490.w,
            margin: EdgeInsets.only(left: 30.w, top: 30.w),
            decoration: BoxDecoration(
              color: Colors.white,
              // color: Colors.black,
              borderRadius: BorderRadius.circular(20.w),
              boxShadow: [
                BoxShadow(
                    color: const Color(0x29b1b1b1),
                    offset: const Offset(-2, 2),
                    blurRadius: 6.w,
                    spreadRadius: 0),
                BoxShadow(
                    color: const Color(0x29dbdbdb),
                    offset: const Offset(-2, -4),
                    blurRadius: 6.w,
                    spreadRadius: 0)
              ],
            ),
            child: widget.kindergartenImage != null ?Container(
                child: ClipRRect(
              borderRadius: BorderRadius.circular(20.w),
              child: widget.kindergartenImage,
            )):Container(),
          ),
          // Container(
          //   width: 400.w,
          //       height: 490.w,
          //   child: ClipRRect(
          //     borderRadius: BorderRadius.circular(20.w),
          //     child: context.watch<KinderDataProvider>().kinderImage,
          //   ),
          // ),
          ///어린이집 사진>

          ///<학급수, 유아수 그래프
          Column(children: [
            Row(children: [
              SizedBox(
                // width: 49.w,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 76.w, top: 118.w),
                    child: Text("학급수",
                        style: TextStyle(
                            color: const Color(0xff393838),
                            fontWeight: FontWeight.w700,
                            fontFamily: "NotoSansKR",
                            // fontStyle: FontStyle.normal,
                            fontSize: 16.0.sp),
                        textAlign: TextAlign.left),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ///<원형그래프:학급수
                      Container(
                        width: 279.w,
                        height: 143.w,
                        margin: EdgeInsets.only(left: 25.w,top: 15.w),
                        child: Row(
                          children: [
                            AspectRatio(
                              aspectRatio: 1,
                              child: PieChart(
                                PieChartData(
                                  borderData: FlBorderData(
                                    show: false,
                                  ),
                                  sectionsSpace: 0,
                                  centerSpaceRadius: 30.w,
                                  sections: showingSections(
                                      widget.data["kindergarten"]["classAges"]
                                          .length,
                                      widget.classGraphRate),
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                Column(
                                  // mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    for (int i = 0;
                                        i <
                                            widget
                                                .data["kindergarten"]
                                                    ["classAges"]
                                                .length;
                                        i++) ...[
                                      Row(
                                        children: [
                                          Indicator(
                                              color: classGraphColor[i],
                                              text: widget.data["kindergarten"]
                                                  ["classAges"][i],
                                              isSquare: true),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 7.w,
                                      ),
                                    ]
                                  ],
                                ),
                                SizedBox(
                                  width: 10.w,
                                ),
                                Column(
                                  // mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    for (int i = 0;
                                        i <
                                            widget
                                                .data["kindergarten"]
                                                    ["classAges"]
                                                .length;
                                        i++) ...[
                                      Row(
                                        children: [
                                          Text(
                                            widget.data["kindergarten"]
                                                        ["classCounts"][i]
                                                    .toString() +
                                                '개',
                                            style: TextStyle(
                                              fontFamily: 'NotoSansKR',
                                              color: const Color(0xff393838),
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w400,
                                              fontStyle: FontStyle.normal,
                                            ),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 7.w,
                                      ),
                                    ]
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      ///원형그래프:학급수>
                    ],
                  ),
                ],
              ),

              ///<원형그래프: 유아수
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 51.w, top: 122.w),
                    child: Text("유아수",
                        style: TextStyle(
                            color: const Color(0xff393838),
                            fontWeight: FontWeight.w700,
                            fontFamily: "NotoSansKR",
                            fontStyle: FontStyle.normal,
                            fontSize: 16.0.sp),
                        textAlign: TextAlign.left),
                  ),
                  Container(
                    width: 279.w,
                    height: 143.w,
                    margin: EdgeInsets.only(top: 15.w),
                    child: Row(
                      children: [
                        AspectRatio(
                          aspectRatio: 1,
                          child: PieChart(
                            PieChartData(
                                borderData: FlBorderData(
                                  show: false,
                                ),
                                sectionsSpace: 0,
                                centerSpaceRadius: 30.w,
                                sections: showingSections(
                                  widget
                                      .data["kindergarten"]["classAges"].length,
                                  widget.childGraphRate,
                                )),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            for (int i = 0;
                                i <
                                    widget.data["kindergarten"]["classAges"]
                                        .length;
                                i++) ...[
                              Indicator(
                                  color: classGraphColor[i],
                                  text: widget.data["kindergarten"]["classAges"]
                                      [i],
                                  isSquare: true),
                              SizedBox(
                                height: 7.w,
                              ),
                            ]
                          ],
                        ),
                        SizedBox(
                          width: 10.w,
                        ),
                        Column(
                          // mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            for (int i = 0;
                                i <
                                    widget.data["kindergarten"]["classAges"]
                                        .length;
                                i++) ...[
                              Row(
                                children: [
                                  Text(
                                    widget.data["kindergarten"]
                                                ["childrenCounts"][i]
                                            .toString() +
                                        '명',
                                    style: TextStyle(
                                      fontFamily: 'NotoSansKR',
                                      color: const Color(0xff393838),
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w400,
                                      fontStyle: FontStyle.normal,
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 7.w,
                              ),
                            ]
                          ],
                        ),
                      ],
                    ),

                    ///원형그래프:유아수>
                  ),
                ],
              )
            ]),
            Container(
                width: 544.w,
                height: 150.w,
                margin: EdgeInsets.only(left: 43.w, top: 30.w),
                decoration: BoxDecoration(
                  color: const Color(0xffffffff),
                  borderRadius: BorderRadius.circular(20.w),
                  boxShadow: [
                    BoxShadow(
                        color: const Color(0x29b1b1b1),
                        offset: const Offset(-2, 2),
                        blurRadius: 6.w,
                        spreadRadius: 0),
                    BoxShadow(
                        color: const Color(0x29dbdbdb),
                        offset: const Offset(-2, -4),
                        blurRadius: 6.w,
                        spreadRadius: 0)
                  ],
                  border: Border.all(color: const Color(0x6663e6d7), width: 1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 93.w, top: 23.w),
                      child: Text("교사당/학급당 유아수",
                          style: TextStyle(
                            fontFamily: 'NotoSansKR',
                            color: const Color(0xff393838),
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700,
                            fontStyle: FontStyle.normal,
                          )),
                    ),
                    Row(
                      children: [
                        Column(
                          children: [
                            Container(
                              margin: EdgeInsets.only(left: 93.w, top: 20.w),
                              child: Text("교사당 유아수",
                                  style: TextStyle(
                                    fontFamily: 'NotoSansKR',
                                    color: const Color(0xff393838),
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w400,
                                    fontStyle: FontStyle.normal,
                                  )),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 93.w, top: 20.w),
                              child: Text("학급당 유아수",
                                  style: TextStyle(
                                    fontFamily: 'NotoSansKR',
                                    color: const Color(0xff393838),
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w400,
                                    fontStyle: FontStyle.normal,
                                  )),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: (200.0 *
                                      (widget.data["kindergarten"]
                                              ["childrenCountByTeacher"] ??
                                          0) /
                                      60)
                                  .w,
                              height: 20.w,
                              margin: EdgeInsets.only(left: 20.w, top: 20.w),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(10.w),
                                    bottomRight: Radius.circular(10.w)),
                                color: const Color(0xffc7f7f5),
                              ),
                            ),
                            Container(
                              width: (200.0 *
                                      (widget.data["kindergarten"]
                                              ["childrenCountByClass"] ??
                                          0) /
                                      60)
                                  .w,
                              height: 20.w,
                              margin: EdgeInsets.only(left: 20.w, top: 20.w),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(10.w),
                                    bottomRight: Radius.circular(10.w)),
                                color: const Color(0xff39605f),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.only(left: 40.w, top: 20.w),
                              child: Text(
                                  (widget.data["kindergarten"]
                                              ["childrenCountByTeacher"] ??
                                          0)
                                      .toStringAsFixed(1),
                                  style: TextStyle(
                                    fontFamily: 'NotoSansKR',
                                    color: Color(0xff393838),
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w400,
                                    fontStyle: FontStyle.normal,
                                  )),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 40.w, top: 20.w),
                              child: Text(
                                  (widget.data["kindergarten"]
                                              ["childrenCountByClass"] ??
                                          0)
                                      .toStringAsFixed(1),
                                  style: TextStyle(
                                    fontFamily: 'NotoSansKR',
                                    color: Color(0xff393838),
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w400,
                                    fontStyle: FontStyle.normal,
                                  )),
                            ),
                          ],
                        )
                      ],
                    ),
                  ],
                )),
          ])

          ///학급수, 유아수 그래프>
        ],
      ),
      floorImage[floorPage],]
        );
  }

  /// 원형그래프
  List<PieChartSectionData> showingSections(int num, List<double> value) {
    return List.generate(num, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 25.0.sp : 16.0.sp;
      final radius = isTouched ? 60.0.w : 20.0.w; //그래프 테두리 두깨
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: const Color(0xffc7f7f5),
            value: value[0],
            radius: radius,
            titleStyle: const TextStyle(
              //강제로 fontSize: 0 지정해줘야 숫자 안뜸
              fontSize: 0,
              fontWeight: FontWeight.bold,
              color: Color(0xffffffff),
            ),
          );
        case 1:
          return PieChartSectionData(
            color: const Color(0xffc6d0f4),
            value: value[1],
            radius: radius,
            titleStyle: const TextStyle(
              fontSize: 0,
              fontWeight: FontWeight.bold,
              color: Color(0xffffffff),
            ),
          );
        case 2:
          return PieChartSectionData(
            color: const Color(0xfff4dac5),
            value: value[2],
            radius: radius,
            titleStyle: const TextStyle(
              fontSize: 0,
              fontWeight: FontWeight.bold,
              color: Color(0xffffffff),
            ),
          );
        case 3:
          return PieChartSectionData(
            color: const Color(0xfff4f4c6),
            value: value[3],
            title: '15%',
            radius: radius,
            titleStyle: const TextStyle(
              fontSize: 0,
              fontWeight: FontWeight.bold,
              color: Color(0xffffffff),
            ),
          );
        case 4:
          return PieChartSectionData(
            color: const Color(0xfff4c6ed),
            value: value[4],
            radius: radius,
            titleStyle: const TextStyle(
              fontSize: 0,
              fontWeight: FontWeight.bold,
              color: Color(0xffffffff),
            ),
          );
        // case 5:
        //   return PieChartSectionData(
        //     color: const Color(0xfff4c6ed),
        //     value: value[5],
        //     radius: radius,
        //     titleStyle: const TextStyle(
        //       fontSize: 0,
        //       fontWeight: FontWeight.bold,
        //       color: Color(0xffffffff),
        //     ),
        //   );
        // case 6:
        //   return PieChartSectionData(
        //     color: const Color(0xfff4c6ed),
        //     value: value[6],
        //     radius: radius,
        //     titleStyle: const TextStyle(
        //       fontSize: 0,
        //       fontWeight: FontWeight.bold,
        //       color: Color(0xffffffff),
        //     ),
        //   );
        // case 7:
        //   return PieChartSectionData(
        //     color: const Color(0xfff4c6ed),
        //     value: value[7],
        //     radius: radius,
        //     titleStyle: const TextStyle(
        //       fontSize: 0,
        //       fontWeight: FontWeight.bold,
        //       color: Color(0xffffffff),
        //     ),
        //   );
        default:
          print(i);
          throw Error();
      }
    });
  }

  ///
}

class FloorInfo extends StatefulWidget {
  const FloorInfo({
    Key? key,
    required this.data,
  }) : super(key: key);
  final Map<String, dynamic> data;

  @override
  State<FloorInfo> createState() => _FloorInfoState();
}

class _FloorInfoState extends State<FloorInfo> {
  List<Color> classGraphColor = [
    const Color(0xffc7f7f5),
    const Color(0xffc6d0f4),
    const Color(0xfff4dac6),
    const Color(0xfff4f4c6),
    const Color(0xfff4c6ed)
  ];

  List<String> firstRowStr = [
    "교실수",
    "면적",
    "실내",
    "면적",
    "실외",
    "면적",
    "옥상",
    "면적",
    "인근",
    "면적"
  ];

  List<String> secondRowStr = [
    "수",
    "면적",
    "수",
    "면적",
    "수",
    "면적",
    "수",
    "면적",
  ];
  List<String> thirdRowStr = [
    "수",
    "면적",
    "수",
    "면적",
    "수",
    "면적",
    "수",
    "면적",
  ];

  double boyrate = 0.5;
  double girlrate = 0.78;

  List<dynamic> childClassName = [
    '꽃사랑',
    '개나리',
    '진달래',
    '방울꽃',
    '계란꽃',
    '아카시아',
    '튤립',
    '해바라기',
    //'금잔디',
    //'소나무',
  ]; //반 이름입니다.

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(
          children: [
            Row(
              children: [
                Container(
                  width: 200.w,
                  height: 41.w,
                  margin: EdgeInsets.only(left: 35.w, top: 50.w),
                  decoration: BoxDecoration(
                      color: const Color(0xffeffffe),
                      border:
                          Border.all(color: const Color(0x4d63e6d7), width: 1),
                      borderRadius:
                          BorderRadius.only(topLeft: Radius.circular(20.w))),
                  child: Center(
                    child: Text("교실",
                        style: TextStyle(
                          fontFamily: 'NotoSansKR',
                          color: const Color(0xff393838),
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                        )),
                  ),
                ),
                Container(
                  width: 784.w,
                  height: 41.w,
                  margin: EdgeInsets.only(top: 50.w),
                  decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.only(topRight: Radius.circular(20.w)),
                      border:
                          Border.all(color: const Color(0x4d63e6d7), width: 1),
                      color: const Color(0xffeffffe)),
                  child: Center(
                    child: Text("체육장/놀이터",
                        style: TextStyle(
                          fontFamily: 'NotoSansKR',
                          color: const Color(0xff393838),
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                        )),
                  ),
                )
              ],
            ),
            Row(
              children: [
                SizedBox(
                  width: 35.w,
                ),
                for (int i = 0; i < 2; i++) ...[
                  Container(
                    width: 100.w,
                    height: 41.w,
                    decoration: BoxDecoration(
                      color: const Color(0xffc7f7f5),
                      border: Border.all(
                        color: const Color(0x4d63e6d7),
                        //width: 0.5.w,
                      ),
                    ),
                    child: Center(
                      child: Text(firstRowStr[i],
                          style: TextStyle(
                            fontFamily: 'NotoSansKR',
                            color: const Color(0xff393838),
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.normal,
                          )),
                    ),
                  ),
                ],
                for (int i = 2; i < 10; i++) ...[
                  Container(
                    width: 98.w,
                    height: 41.w,
                    decoration: BoxDecoration(
                      color: const Color(0xffc7f7f5),
                      border: Border.all(
                        color: const Color(0x4d63e6d7),
                        //width: 0.5.w,
                      ),
                    ),
                    child: Center(
                      child: Text(firstRowStr[i],
                          style: TextStyle(
                            fontFamily: 'NotoSansKR',
                            color: const Color(0xff393838),
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.normal,
                          )),
                    ),
                  )
                ]
              ],
            ),
            Row(
              children: [
                SizedBox(
                  width: 35.w,
                ),
                for (int i = 0; i < 2; i++) ...[
                  if (i == 0) ...[
                    Container(
                      width: 100.w,
                      height: 41.w,
                      decoration: BoxDecoration(
                        color: const Color(0xffffffff),
                        border: Border.all(
                          color: const Color(0x4d63e6d7),
                          //width: 0.5.w,
                        ),
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20.w)),
                      ),
                      child: Center(
                        child: GraphTextStyle(
                            text: widget.data["kindergarten"]["classroomCount"]
                                .toString()),
                      ),
                    ),
                  ] else ...[
                    Container(
                      width: 100.w,
                      height: 41.w,
                      decoration: BoxDecoration(
                        color: const Color(0xffffffff),
                        border: Border.all(
                          color: const Color(0x4d63e6d7),
                          //width: 0.5.w,
                        ),
                      ),
                      child: Center(
                        child: GraphTextStyle(
                            text: widget.data["kindergarten"]["classroomArea"]
                                .toString()),
                      ),
                    ),
                  ]
                ],
                Container(
                  width: 98.w,
                  height: 41.w,
                  decoration: BoxDecoration(
                    color: const Color(0xffffffff),
                    border: Border.all(
                      color: const Color(0x4d63e6d7),
                      //width: 0.5.w,
                    ),
                  ),
                  child: Center(
                    child: GraphTextStyle(
                        text: widget.data["kindergarten"]["indoorgymCount"]
                            .toString()),
                  ),
                ),
                Container(
                  width: 98.w,
                  height: 41.w,
                  decoration: BoxDecoration(
                    color: const Color(0xffffffff),
                    border: Border.all(
                      color: const Color(0x4d63e6d7),
                      //width: 0.5.w,
                    ),
                  ),
                  child: Center(
                    child: GraphTextStyle(
                        text: widget.data["kindergarten"]["indoorgymArea"]
                            .toString()),
                  ),
                ),
                Container(
                  width: 98.w,
                  height: 41.w,
                  decoration: BoxDecoration(
                    color: const Color(0xffffffff),
                    border: Border.all(
                      color: const Color(0x4d63e6d7),
                      //width: 0.5.w,
                    ),
                  ),
                  child: Center(
                    child: GraphTextStyle(
                        text: widget.data["kindergarten"]["outdoorgymCount"]
                            .toString()),
                  ),
                ),
                Container(
                  width: 98.w,
                  height: 41.w,
                  decoration: BoxDecoration(
                    color: const Color(0xffffffff),
                    border: Border.all(
                      color: const Color(0x4d63e6d7),
                      //width: 0.5.w,
                    ),
                  ),
                  child: Center(
                    child: GraphTextStyle(
                        text: widget.data["kindergarten"]["outdoorgymArea"]
                            .toString()),
                  ),
                ),
                Container(
                  width: 98.w,
                  height: 41.w,
                  decoration: BoxDecoration(
                    color: const Color(0xffffffff),
                    border: Border.all(
                      color: const Color(0x4d63e6d7),
                      //width: 0.5.w,
                    ),
                  ),
                  child: Center(
                    child: GraphTextStyle(
                        text: widget.data["kindergarten"]["roofgymCount"]
                            .toString()),
                  ),
                ),
                Container(
                  width: 98.w,
                  height: 41.w,
                  decoration: BoxDecoration(
                    color: const Color(0xffffffff),
                    border: Border.all(
                      color: const Color(0x4d63e6d7),
                      //width: 0.5.w,
                    ),
                  ),
                  child: Center(
                    child: GraphTextStyle(
                        text: widget.data["kindergarten"]["roofgymArea"]
                            .toString()),
                  ),
                ),
                Container(
                  width: 98.w,
                  height: 41.w,
                  decoration: BoxDecoration(
                    color: const Color(0xffffffff),
                    border: Border.all(
                      color: const Color(0x4d63e6d7),
                      //width: 0.5.w,
                    ),
                  ),
                  child: Center(
                    child: GraphTextStyle(
                        text: widget.data["kindergarten"]["neargymCount"]
                            .toString()),
                  ),
                ),
                Container(
                  width: 98.w,
                  height: 41.w,
                  decoration: BoxDecoration(
                    color: const Color(0xffffffff),
                    border: Border.all(
                      color: const Color(0x4d63e6d7),
                      //width: 0.5.w,
                    ),
                    borderRadius:
                        BorderRadius.only(bottomRight: Radius.circular(20.w)),
                  ),
                  child: Center(
                    child: GraphTextStyle(
                        text: widget.data["kindergarten"]["neargymArea"]
                            .toString()),
                  ),
                ),
              ],
            )
          ],
        ),
        Column(
          children: [
            Row(
              children: [
                Container(
                  width: 200.w,
                  height: 41.w,
                  margin: EdgeInsets.only(left: 35.w, top: 30.w),
                  decoration: BoxDecoration(
                      color: const Color(0xffeffffe),
                      border:
                          Border.all(color: const Color(0x4d63e6d7), width: 1),
                      borderRadius:
                          BorderRadius.only(topLeft: Radius.circular(20.w))),
                  child: Center(
                    child: Text("보건실",
                        style: TextStyle(
                          fontFamily: 'NotoSansKR',
                          color: const Color(0xff393838),
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                        )),
                  ),
                ),
                Container(
                  width: 261.w,
                  height: 41.w,
                  margin: EdgeInsets.only(top: 30.w),
                  decoration: BoxDecoration(
                      border:
                          Border.all(color: const Color(0x4d63e6d7), width: 1),
                      color: const Color(0xffeffffe)),
                  child: Center(
                    child: Text("위생시설(목욕실/화장실)",
                        style: TextStyle(
                          fontFamily: 'NotoSansKR',
                          color: const Color(0xff393838),
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                        )),
                  ),
                ),
                Container(
                  width: 263.w,
                  height: 41.w,
                  margin: EdgeInsets.only(top: 30.w),
                  decoration: BoxDecoration(
                      border:
                          Border.all(color: const Color(0x4d63e6d7), width: 1),
                      color: const Color(0xffeffffe)),
                  child: Center(
                    child: Text("조리실",
                        style: TextStyle(
                          fontFamily: 'NotoSansKR',
                          color: const Color(0xff393838),
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                        )),
                  ),
                ),
                Container(
                  width: 262.w,
                  height: 41.w,
                  margin: EdgeInsets.only(top: 30.w),
                  decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.only(topRight: Radius.circular(20.w)),
                      border:
                          Border.all(color: const Color(0x4d63e6d7), width: 1),
                      color: const Color(0xffeffffe)),
                  child: Center(
                    child: Text("급식실",
                        style: TextStyle(
                          fontFamily: 'NotoSansKR',
                          color: const Color(0xff393838),
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                        )),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                SizedBox(
                  width: 35.w,
                ),
                for (int i = 0; i < 2; i++) ...[
                  Container(
                    width: 100.w,
                    height: 41.w,
                    decoration: BoxDecoration(
                      color: const Color(0xffc7f7f5),
                      border: Border.all(
                        color: const Color(0x4d63e6d7),
                        //width: 0.5.w,
                      ),
                    ),
                    child: Center(
                      child: Text(secondRowStr[i],
                          style: TextStyle(
                            fontFamily: 'NotoSansKR',
                            color: const Color(0xff393838),
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.normal,
                          )),
                    ),
                  ),
                ],
                for (int i = 2; i < 8; i++) ...[
                  Container(
                    width: 131.w,
                    height: 41.w,
                    decoration: BoxDecoration(
                      color: const Color(0xffc7f7f5),
                      border: Border.all(
                        color: const Color(0x4d63e6d7),
                        //width: 0.5.w,
                      ),
                    ),
                    child: Center(
                      child: Text(secondRowStr[i],
                          style: TextStyle(
                            fontFamily: 'NotoSansKR',
                            color: const Color(0xff393838),
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.normal,
                          )),
                    ),
                  )
                ]
              ],
            ),
            Row(
              children: [
                SizedBox(
                  width: 35.w,
                ),
                for (int i = 0; i < 2; i++) ...[
                  if (i == 0) ...[
                    Container(
                      width: 100.w,
                      height: 41.w,
                      decoration: BoxDecoration(
                        color: const Color(0xffffffff),
                        border: Border.all(
                          color: const Color(0x4d63e6d7),
                          //width: 0.5.w,
                        ),
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20.w)),
                      ),
                      child: Center(
                        child: GraphTextStyle(
                            text: widget.data["kindergarten"]["healthroomCount"]
                                .toString()),
                      ),
                    ),
                  ] else ...[
                    Container(
                      width: 100.w,
                      height: 41.w,
                      decoration: BoxDecoration(
                        color: const Color(0xffffffff),
                        border: Border.all(
                          color: const Color(0x4d63e6d7),
                          //width: 0.5.w,
                        ),
                      ),
                      child: Center(
                        child: GraphTextStyle(
                            text: widget.data["kindergarten"]["healthroomArea"]
                                .toString()),
                      ),
                    ),
                  ]
                ],
                Container(
                  width: 131.w,
                  height: 41.w,
                  decoration: BoxDecoration(
                    color: const Color(0xffffffff),
                    border: Border.all(
                      color: const Color(0x4d63e6d7),
                      //width: 0.5.w,
                    ),
                  ),
                  child: Center(
                    child: GraphTextStyle(
                        text: widget.data["kindergarten"]["restroomCount"]
                            .toString()),
                  ),
                ),
                Container(
                  width: 131.w,
                  height: 41.w,
                  decoration: BoxDecoration(
                    color: const Color(0xffffffff),
                    border: Border.all(
                      color: const Color(0x4d63e6d7),
                      //width: 0.5.w,
                    ),
                  ),
                  child: Center(
                    child: GraphTextStyle(
                        text: widget.data["kindergarten"]["restroomArea"]
                            .toString()),
                  ),
                ),
                Container(
                  width: 131.w,
                  height: 41.w,
                  decoration: BoxDecoration(
                    color: const Color(0xffffffff),
                    border: Border.all(
                      color: const Color(0x4d63e6d7),
                      //width: 0.5.w,
                    ),
                  ),
                  child: Center(
                    child: GraphTextStyle(
                        text: widget.data["kindergarten"]["kitchenCount"]
                            .toString()),
                  ),
                ),
                Container(
                  width: 131.w,
                  height: 41.w,
                  decoration: BoxDecoration(
                    color: const Color(0xffffffff),
                    border: Border.all(
                      color: const Color(0x4d63e6d7),
                      //width: 0.5.w,
                    ),
                  ),
                  child: Center(
                    child: GraphTextStyle(
                        text: widget.data["kindergarten"]["kitchenArea"]
                            .toString()),
                  ),
                ),
                Container(
                  width: 131.w,
                  height: 41.w,
                  decoration: BoxDecoration(
                    color: const Color(0xffffffff),
                    border: Border.all(
                      color: const Color(0x4d63e6d7),
                      //width: 0.5.w,
                    ),
                  ),
                  child: Center(
                    child: GraphTextStyle(
                        text: widget.data["kindergarten"]["cafeteriaCount"]
                            .toString()),
                  ),
                ),
                Container(
                  width: 131.w,
                  height: 41.w,
                  decoration: BoxDecoration(
                    color: const Color(0xffffffff),
                    border: Border.all(
                      color: const Color(0x4d63e6d7),
                      //width: 0.5.w,
                    ),
                    borderRadius:
                        BorderRadius.only(bottomRight: Radius.circular(20.w)),
                  ),
                  child: Center(
                    child: GraphTextStyle(
                        text: widget.data["kindergarten"]["cafeteriaArea"]
                            .toString()),
                  ),
                )
              ],
            )
          ],
        ),
        Column(
          children: [
            Row(
              children: [
                Container(
                  width: 200.w,
                  height: 41.w,
                  margin: EdgeInsets.only(left: 35.w, top: 30.w),
                  decoration: BoxDecoration(
                      color: const Color(0xffeffffe),
                      border:
                          Border.all(color: const Color(0x4d63e6d7), width: 1),
                      borderRadius:
                          BorderRadius.only(topLeft: Radius.circular(20.w))),
                  child: Center(
                    child: Text("원장실",
                        style: TextStyle(
                          fontFamily: 'NotoSansKR',
                          color: const Color(0xff393838),
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                        )),
                  ),
                ),
                Container(
                  width: 261.w,
                  height: 41.w,
                  margin: EdgeInsets.only(top: 30.w),
                  decoration: BoxDecoration(
                      border:
                          Border.all(color: const Color(0x4d63e6d7), width: 1),
                      color: const Color(0xffeffffe)),
                  child: Center(
                    child: Text("교사실",
                        style: TextStyle(
                          fontFamily: 'NotoSansKR',
                          color: const Color(0xff393838),
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                        )),
                  ),
                ),
                Container(
                  width: 263.w,
                  height: 41.w,
                  margin: EdgeInsets.only(top: 30.w),
                  decoration: BoxDecoration(
                      border:
                          Border.all(color: const Color(0x4d63e6d7), width: 1),
                      color: const Color(0xffeffffe)),
                  child: Center(
                    child: Text("상담실",
                        style: TextStyle(
                          fontFamily: 'NotoSansKR',
                          color: const Color(0xff393838),
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                        )),
                  ),
                ),
                Container(
                  width: 262.w,
                  height: 41.w,
                  margin: EdgeInsets.only(top: 30.w),
                  decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.only(topRight: Radius.circular(20.w)),
                      border:
                          Border.all(color: const Color(0x4d63e6d7), width: 1),
                      color: const Color(0xffeffffe)),
                  child: Center(
                    child: Text("기타공간",
                        style: TextStyle(
                          fontFamily: 'NotoSansKR',
                          color: const Color(0xff393838),
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                        )),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                SizedBox(
                  width: 35.w,
                ),
                for (int i = 0; i < 2; i++) ...[
                  Container(
                    width: 100.w,
                    height: 41.w,
                    decoration: BoxDecoration(
                      color: const Color(0xffc7f7f5),
                      border: Border.all(
                        color: const Color(0x4d63e6d7),
                        //width: 0.5.w,
                      ),
                    ),
                    child: Center(
                      child: Text(thirdRowStr[i],
                          style: TextStyle(
                            fontFamily: 'NotoSansKR',
                            color: const Color(0xff393838),
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.normal,
                          )),
                    ),
                  ),
                ],
                for (int i = 2; i < 8; i++) ...[
                  Container(
                    width: 131.w,
                    height: 41.w,
                    decoration: BoxDecoration(
                      color: const Color(0xffc7f7f5),
                      border: Border.all(
                        color: const Color(0x4d63e6d7),
                        //width: 0.5.w,
                      ),
                    ),
                    child: Center(
                      child: Text(thirdRowStr[i],
                          style: TextStyle(
                            fontFamily: 'NotoSansKR',
                            color: const Color(0xff393838),
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.normal,
                          )),
                    ),
                  )
                ]
              ],
            ),
            Row(
              children: [
                SizedBox(
                  width: 35.w,
                ),
                for (int i = 0; i < 2; i++) ...[
                  if (i == 0) ...[
                    Container(
                      width: 100.w,
                      height: 41.w,
                      decoration: BoxDecoration(
                        color: const Color(0xffffffff),
                        border: Border.all(
                          color: const Color(0x4d63e6d7),
                          //width: 0.5.w,
                        ),
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20.w)),
                      ),
                      child: Center(
                        child: GraphTextStyle(
                            text: widget.data["kindergarten"]
                                    ["directorroomCount"]
                                .toString()),
                      ),
                    ),
                  ] else ...[
                    Container(
                      width: 100.w,
                      height: 41.w,
                      decoration: BoxDecoration(
                        color: const Color(0xffffffff),
                        border: Border.all(
                          color: const Color(0x4d63e6d7),
                          //width: 0.5.w,
                        ),
                      ),
                      child: Center(
                        child: GraphTextStyle(
                            text: widget.data["kindergarten"]
                                    ["directorroomArea"]
                                .toString()),
                      ),
                    ),
                  ]
                ],
                Container(
                  width: 131.w,
                  height: 41.w,
                  decoration: BoxDecoration(
                    color: const Color(0xffffffff),
                    border: Border.all(
                      color: const Color(0x4d63e6d7),
                      //width: 0.5.w,
                    ),
                  ),
                  child: Center(
                    child: GraphTextStyle(
                        text: widget.data["kindergarten"]["teacherroomCount"]
                            .toString()),
                  ),
                ),
                Container(
                  width: 131.w,
                  height: 41.w,
                  decoration: BoxDecoration(
                    color: const Color(0xffffffff),
                    border: Border.all(
                      color: const Color(0x4d63e6d7),
                      //width: 0.5.w,
                    ),
                  ),
                  child: Center(
                    child: GraphTextStyle(
                        text: widget.data["kindergarten"]["teacherroomArea"]
                            .toString()),
                  ),
                ),
                Container(
                  width: 131.w,
                  height: 41.w,
                  decoration: BoxDecoration(
                    color: const Color(0xffffffff),
                    border: Border.all(
                      color: const Color(0x4d63e6d7),
                      //width: 0.5.w,
                    ),
                  ),
                  child: Center(
                    child: GraphTextStyle(
                        text: widget.data["kindergarten"]["counselingroomCount"]
                            .toString()),
                  ),
                ),
                Container(
                  width: 131.w,
                  height: 41.w,
                  decoration: BoxDecoration(
                    color: const Color(0xffffffff),
                    border: Border.all(
                      color: const Color(0x4d63e6d7),
                      //width: 0.5.w,
                    ),
                  ),
                  child: Center(
                    child: GraphTextStyle(
                        text: widget.data["kindergarten"]["counselingroomArea"]
                            .toString()),
                  ),
                ),
                Container(
                  width: 131.w,
                  height: 41.w,
                  decoration: BoxDecoration(
                    color: const Color(0xffffffff),
                    border: Border.all(
                      color: const Color(0x4d63e6d7),
                      //width: 0.5.w,
                    ),
                  ),
                  child: Center(
                    child: GraphTextStyle(
                        text: widget.data["kindergarten"]["otherplaceCount"]
                            .toString()),
                  ),
                ),
                Container(
                  width: 131.w,
                  height: 41.w,
                  decoration: BoxDecoration(
                    color: const Color(0xffffffff),
                    border: Border.all(
                      color: const Color(0x4d63e6d7),
                      //width: 0.5.w,
                    ),
                    borderRadius:
                        BorderRadius.only(bottomRight: Radius.circular(20.w)),
                  ),
                  child: Center(
                    child: GraphTextStyle(
                        text: widget.data["kindergarten"]["otherplaceArea"]
                            .toString()),
                  ),
                )
              ],
            )
          ],
        ),
      ],
    );
  }
}

class FloorImageWidget extends StatefulWidget {
  const FloorImageWidget({
    Key? key,
    required this.floorImage,
  }) : super(key: key);
  final Image? floorImage;

  @override
  State<FloorImageWidget> createState() => _FloorImageWidgetState();
}

class _FloorImageWidgetState extends State<FloorImageWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 44.w,),
        WidgetMask(
          blendMode: BlendMode.srcATop,
          childSaveLayer: false,
          mask: widget.floorImage!,
          child: Container(
            width: 994.w,
            height: 446.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20.w)),
              color: Colors.white,
            ),
          ),
        ),

      ],
    );
  }
}

class Indicator extends StatelessWidget {
  final Color color;
  final Color textColor;
  final String text;
  final bool isSquare;
  final double size;

  const Indicator({
    Key? key,
    required this.color,
    this.textColor = Colors.white,
    required this.text,
    required this.isSquare,
    this.size = 10,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: size.w,
          height: size.w,
          decoration: BoxDecoration(
            shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
            color: color,
          ),
        ),
        SizedBox(
          width: 10.w,
        ),
        Text(
          text,
          style: TextStyle(
            color: const Color(0xff393838),
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            fontStyle: FontStyle.normal,
            fontFamily: "NotoSansKR",
          ),
        )
      ],
    );
  }
}

class GraphTextStyle extends StatefulWidget {
  const GraphTextStyle({
    Key? key,
    required this.text,
  }) : super(key: key);
  final String text;

  @override
  State<GraphTextStyle> createState() => _GraphTextStyleState();
}

class _GraphTextStyleState extends State<GraphTextStyle> {
  @override
  Widget build(BuildContext context) {
    return Text(
      widget.text == 'null' ? '-' : widget.text,
      style: TextStyle(
        color: const Color(0xff393838),
        fontSize: 16.sp,
        fontWeight: FontWeight.w400,
      ),
    );
  }
}
