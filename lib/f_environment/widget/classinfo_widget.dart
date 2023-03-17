import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:widget_mask/widget_mask.dart';
import 'dart:async';

import 'package:provider/provider.dart';

class ClassInfoWidget extends StatefulWidget {
  const ClassInfoWidget({
    Key? key,
    required this.classChildImage,
    required this.classTeacherImage,
    required this.classNameDeco,
    // required this.classIndex,
    required this.data,
    required this.classChildCount,
    required this.rotateClass,
    required this.nextPage,
    required this.timer,
    required this.delayTimer,

  }) : super(key: key);
  final Map<String, dynamic> data;
  final List<List<Image>> classTeacherImage;
  final List<List<Image>> classChildImage;
  final List<String> classNameDeco;
  // final int classIndex;
  final List<List<int>> classChildCount;
  final Function(int) rotateClass;
  final Function() nextPage;
  final Timer timer;
  final Function(int, Function()) delayTimer;

  @override
  State<ClassInfoWidget> createState() => _ClassInfoWidgetState();
}

class _ClassInfoWidgetState extends State<ClassInfoWidget> {
  int classIndex = 0;
  int column = 0;
  double childHeight = 0;
  double childWidth = 0;
  double childNameHeight = 0;
  double childNameWidth = 0;
  double teacherContainerHeight = 0;
  double teacherContainerWidth = 0;
  double teacherHeight = 0;
  double teacherWidth = 0;
  double teacherWPosition = 0;
  double teacherNameHeight = 0;
  double teacherNameWidth = 0;
  double teacherNameHPosition = 0;
  double teacherNameFontSize = 0;
  double decoContainerHeight = 0;
  double decoContainerWidth = 0;
  double decoClassText = 0;
  double decoChildText = 0;

  dataUpdate() {
    setState(() {
      if (widget.classChildCount[classIndex][0] < 10) {
        childHeight = 120.w;
        childWidth = 120.w;
        childNameHeight = 35.w;
        childNameWidth = 116.w;
        column = 4;
      } else if (widget.classChildCount[classIndex][0] < 20) {
        childHeight = 110.w;
        childWidth = 110.w;
        childNameHeight = 35.w;
        childNameWidth = 116.w;
        column = 5;
      } else {
        childHeight = 110.w;
        childWidth = 110.w;
        childNameHeight = 35.w;
        childNameWidth = 116.w;
        column = 7;
      }

      if (widget.classTeacherImage[classIndex].length <= 1) {
        teacherHeight = 155.w;
        teacherWidth = 155.w;
        teacherWPosition = 18.w;
        teacherNameHeight = 47.w;
        teacherNameWidth = 191.w;
        teacherNameHPosition = 148.w;
        teacherNameFontSize = 20.sp;
        decoContainerHeight = 298.w;
        decoContainerWidth = 464.w;
        teacherContainerHeight = 202.w;
        teacherContainerWidth = 190.w;
        decoClassText = 139.w;
        decoChildText = 15.w;
      } else if (widget.classTeacherImage[classIndex].length <= 2) {
        teacherHeight = 130.w;
        teacherWidth = 130.w;
        teacherWPosition = 25.w;
        teacherNameHeight = 45.w;
        teacherNameWidth = 180.w;
        teacherNameHPosition = 123.w;
        teacherNameFontSize = 18.w;
        decoContainerHeight = 198.w;
        decoContainerWidth = 368.w;
        teacherContainerHeight = 168.w;
        teacherContainerWidth = 380.w;
        decoClassText = 85.w;
        decoChildText = 4.w;
      } else if (widget.classTeacherImage[classIndex].length <= 3) {
        teacherHeight = 120.w;
        teacherWidth = 120.w;
        teacherWPosition = 20.w;
        teacherNameHeight = 40.w;
        teacherNameWidth = 160.w;
        teacherNameHPosition = 115.w;
        teacherNameFontSize = 18.w;
        decoContainerHeight = 278.w;
        decoContainerWidth = 410.w;
        teacherContainerHeight = 155.w;
        teacherContainerWidth = 520.w;
        decoClassText = 120.w;
        decoChildText = 12.w;
      }
    });

  }

  rotateClass(){
    setState(() {
      classIndex++;
      dataUpdate();
    });

    if (classIndex == widget.data["classInfo"].length -1 ) {
      widget.delayTimer(15, (){widget.nextPage();});
      widget.timer;


    }else{
      widget.delayTimer(15, (){rotateClass();});
      widget.timer;
    }
  }

  void initState() {
    dataUpdate();
    widget.delayTimer(15, (){rotateClass();});
    widget.timer;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: decoContainerWidth,
              height: decoContainerHeight,
              // margin: EdgeInsets.only(left: 170.w),
              decoration: BoxDecoration(
                  image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage(widget.classNameDeco[classIndex]),
              )),
              child: Center(
                child: Column(
                  children: [
                    //교실이름구역
                    Container(
                      margin: EdgeInsets.only(left: 20.w, top: decoClassText),
                      child: Text(
                          widget.data["classInfo"][classIndex]["name"],
                          style: TextStyle(
                            fontFamily: 'GamjaFlower',
                            color: Color(0xff39605f),
                            fontSize: 33.sp,
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.normal,
                          )),
                    ),
                    Container(
                      width: 351.w,
                      height: 53.w,
                      margin: EdgeInsets.only(top: decoChildText),
                      child: Center(
                        child: Text(
                          widget.data["classInfo"][classIndex]["age"] +
                              ' | ' +
                              widget.classChildCount[classIndex][0]
                                  .toString() +
                              '명 | 남:' +
                              widget.classChildCount[classIndex][1]
                                  .toString() +
                              '명 여:' +
                              widget.classChildCount[classIndex][2]
                                  .toString() +
                              '명',
                          style: TextStyle(
                              fontSize: 18.sp,
                              color: Colors.black,
                              ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),

            ///담임
            for (int i = 0;
                i < widget.classTeacherImage[classIndex].length;
                i++) ...[
              Container(
                width: teacherContainerWidth,
                height: teacherContainerHeight.w,
                child: Stack(
                  children: [
                    Positioned(
                      top: teacherNameHPosition.w,
                      child: Container(
                        width: teacherNameWidth.w,
                        height: teacherNameHeight.w,
                        // margin: EdgeInsets.only(left: 20.w),
                        decoration: BoxDecoration(
                            color: const Color(0xffc7f7f5),
                            borderRadius: BorderRadius.circular(31.w),
                        border: Border.all(width: 1,color: Color(0xff4dE6D7))),
                        child: Center(
                          child: Text(
                            widget.data["classInfo"][classIndex]
                                ["teachers"][i]["name"],
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: teacherNameFontSize,

                            ),

                          ),
                        ),
                      ),
                    ),



                    Positioned(
                      left: teacherWPosition.w,
                      child: Container(
                        width: teacherWidth.w,
                        height: teacherHeight.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          border: Border.all(width: 1.w, color: const Color(0xffC0F5EF)),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0x297b7b7b),
                              offset: const Offset(3, 3),
                              blurRadius: 4.w,
                            ),
                          ],
                        ),

                        child: Padding(
                          padding: EdgeInsets.all(1.w),
                          child: WidgetMask(
                            blendMode: BlendMode.srcATop,
                            childSaveLayer: true,
                            mask: widget.classTeacherImage[classIndex][i],
                            child: Container(
                              width: teacherWidth.w,
                              height: teacherHeight.w,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                  ],
                ),
              )
            ]

            ///담임
          ],
        ),
        // SizedBox(
        //   height: 30.w,
        // ),

        ///아이들
        for (int i = 0;
            i < widget.classChildCount[classIndex][0] ~/ column;
            i++) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              for (int j = 0; j < column; j++) ...[
                Column(
                  children: [
                    SizedBox(
                      height: 30.w,
                    ),
                    Container(
                      width: childNameWidth>=childWidth ? childNameWidth : childWidth+6.w,
                      height: childNameHeight + childHeight - 8.w,
                      child: Stack(
                        children: [
                          Positioned(
                            left: (childNameWidth - childWidth) / 2 < 0 ? 0 : -(childNameWidth - childWidth) / 2,
                            top: childHeight - 8.w,
                            child: Container(
                              width: childNameWidth,
                              height: childNameHeight,
                              decoration: BoxDecoration(
                                  color: const Color(0xffc7f7f5),
                                  borderRadius: BorderRadius.circular(31.w)),
                              child: Center(
                                child: Text(
                                  widget.data["classInfo"][classIndex]
                                      ["children"][column * i + j]["name"],
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18.sp,

                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            left: (childNameWidth - childWidth) / 2 < 0 ? 0 : (childNameWidth - childWidth) / 2,
                            child: Container(
                              width: childWidth,
                              height: childHeight,

                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                                border: Border.all(width: 1.w, color: Color(0x1a63E6D7)),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0x4d7b7b7b),
                                    offset: const Offset(3, 3),
                                    blurRadius: 6.w,),
                                ],
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(1.w),
                                child: WidgetMask(
                                  blendMode: BlendMode.srcATop,
                                  childSaveLayer: true,
                                  mask: widget.classChildImage[classIndex]
                                      [column * i + j],
                                  child: Container(
                                    width: childWidth,
                                    height: childHeight,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white,
                                    ),
                                    // child:  widget.classTeacherImage[classIndex][i],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ]
            ],
          )
        ],

        ///아이들
        ///나머지 아이들
        if (widget.classChildCount[classIndex][0] % column != 0) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              for (int j = 0;
                  j < widget.classChildCount[classIndex][0] % column;
                  j++) ...[
                Column(
                  children: [
                    SizedBox(height: 30.w,),
                    Container(
                      width: childNameWidth>=childWidth ? childNameWidth : childWidth+6.w,
                      height: childNameHeight + childHeight - 5.w,
                      child: Stack(children: [
                        if (j == 0) ...[
                          Positioned(
                            left: (childNameWidth - childWidth) / 2 < 0 ? 0 : -(childNameWidth - childWidth) / 2,
                            top: childHeight - 5.w,
                            child: Container(
                              width: childNameWidth,
                              height: childNameHeight,
                              // margin: EdgeInsets.only(left: 20.w),
                              decoration: BoxDecoration(
                                  color: const Color(0xffc7f7f5),
                                  borderRadius: BorderRadius.circular(31.w)),
                              child: Center(
                                child: Text(
                                  widget.data["classInfo"][classIndex]["children"][column * (widget.classChildCount[classIndex][0] ~/ column) +j]["name"],
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18.sp,

                                  ),
                                  strutStyle: StrutStyle(
                                    fontSize: 18.sp,
                                    forceStrutHeight: true,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            left: (childNameWidth - childWidth) / 2 < 0 ? 0 : (childNameWidth - childWidth) / 2,
                            child: Container(
                              width: childWidth,
                              height: childHeight,
                              // margin: EdgeInsets.only(left: 18.w),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                                border: Border.all(width: 1.w, color: Color(0x1a63E6D7)),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0x4d7b7b7b),
                                    offset: const Offset(3, 3),
                                    blurRadius: 6.w,),
                                ],
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(1.w),
                                child: WidgetMask(
                                  blendMode: BlendMode.srcATop,
                                  childSaveLayer: true,
                                  mask: widget.classChildImage[classIndex][
                                  column * (widget.classChildCount[classIndex][0] ~/ column) +j],
                                  child: Container(
                                    width: childWidth,
                                    height: childHeight,
                                    // margin: EdgeInsets.only(left: 18.w),
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white,
                                    ),
                                    // child:  widget.classTeacherImage[classIndex][i],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ] else ...[
                          Positioned(
                            top: childHeight - 5.w,
                            child: Container(
                              width: childNameWidth,
                              height: childNameHeight,
                              // margin: EdgeInsets.only(left: 20.w),
                              decoration: BoxDecoration(
                                  color: const Color(0xffc7f7f5),
                                  borderRadius: BorderRadius.circular(31.w)),
                              child: Center(
                                child: Text(
                                  widget.data["classInfo"][classIndex]
                                          ["children"][column * (widget.classChildCount[classIndex][0] ~/ column) +j]["name"],
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18.sp,
                                        ),

                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            left: (childNameWidth - childWidth) / 2,
                            child: Container(
                              width: childWidth,
                              height: childHeight,
                              // margin: EdgeInsets.only(left: 18.w),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                                border: Border.all(width: 1.w, color: Color(0x1a63E6D7)),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0x4d7b7b7b),
                                    offset: const Offset(3, 3),
                                    blurRadius: 6.w,),
                                ],
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(1.w),
                                child: WidgetMask(
                                  blendMode: BlendMode.srcATop,
                                  childSaveLayer: true,
                                  mask: widget.classChildImage[classIndex][column * (widget.classChildCount[classIndex][0] ~/ column) +j],
                                  child: Container(
                                    width: childWidth,
                                    height: childHeight,
                                    // margin: EdgeInsets.only(left: 18.w),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white,

                                    ),
                                    // child:  widget.classTeacherImage[classIndex][i],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ]
                      ]),
                    ),
                  ],
                ),
              ]
            ],
          )
        ]
      ],
    );
  }
}
