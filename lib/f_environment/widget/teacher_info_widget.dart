import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:widget_mask/widget_mask.dart';
import 'dart:async';
import 'package:provider/provider.dart';

class TeacherInfoWidget extends StatefulWidget {
  const TeacherInfoWidget({
    Key? key,
    required this.data,
    required this.committeesImage,
    required this.directorImage,
    required this.teacherImage,
    required this.nextPage,
    required this.delayTimer,
    required this.timer,
  }) : super(key: key);
  final Map<String, dynamic> data;
  final List<Image> directorImage;
  final List<Image> teacherImage;
  final List<Image> committeesImage;
  final Function() nextPage;
  final Timer timer;
  final Function(int, Function()) delayTimer;

  @override
  State<TeacherInfoWidget> createState() => _TeacherInfoWidgetState();
}

class _TeacherInfoWidgetState extends State<TeacherInfoWidget> {
  List<Widget> teacherInfo = [];

  teacherSet(){
    setState(() {
      teacherInfo.clear();
      for (int i = 0; i < widget.teacherImage.length; i++) {
        print(widget.data["teachers"][i]["introduction"]);
        teacherInfo.add(
          Container(
            width: 180.w,
            height: 226.w,
            child: Stack(
              children: [
                Positioned(
                  top: 127.w,
                  child: Container(
                    width: 180.w,
                    height: 45.w,
                    // margin: EdgeInsets.only(left: 20.w),
                    decoration: BoxDecoration(
                        color: const Color(0xffc7f7f5),
                        borderRadius: BorderRadius.circular(31.w),
                        border: Border.all(color: const Color(0x4d63E6D7))),
                    child: Center(
                      child: Text(
                        widget.data["teachers"][i]["name"],
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16.sp,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 22.5.w,
                  child: Container(
                    width: 135.w,
                    height: 135.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      border:
                      Border.all(width: 1.w, color: const Color(0xffC0F5EF)),
                      boxShadow: [
                        BoxShadow(
                            color: const Color(0x297b7b7b),
                            offset: const Offset(3, 3),
                            blurRadius: 4.w,
                            spreadRadius: 0)
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(1),
                      child: WidgetMask(
                        blendMode: BlendMode.srcATop,
                        childSaveLayer: true,
                        mask: widget.teacherImage[i],
                        child: Container(
                          width: 135.w,
                          height: 135.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          // child:  widget.classTeacherImage[widget.classIndex][i],
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 180.w,
                  left: 0.w,
                  child: Container(
                    width: 200.w,
                    height: 45.w,
                    child: Center(
                      child: Text(
                        widget.data["teachers"][i]["introduction"]
                            .toString() == 'null' ? '' : widget.data["teachers"][i]["introduction"]
                            .toString(),
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14.sp,
                          fontFamily: '.NotoSansKR',
                        ),
                        strutStyle: StrutStyle(
                          fontSize: 14.sp,
                          forceStrutHeight: true,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );

      }
      // print(teacherInfo.length);
    });

  }

  @override
  void initState() {
    teacherSet();

    int seconds = 15;
    if (widget.teacherImage.length < 4) {
      seconds = 15;
    } else {
      seconds = widget.teacherImage.length * 4;
    }
    widget.delayTimer(seconds, () {
      widget.nextPage();
    });
    widget.timer;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Column(
      // crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 49.w,
        ),
        Row(
          // crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ///원장
            for (int i = 0; i < widget.directorImage.length; i++) ...[
              Container(
                width: 200.w,
                height: 232.w,
                child: Stack(
                  children: [
                    Positioned(
                      top: 133.w,
                      child: Container(
                        width: 200.w,
                        height: 45.w,
                        // margin: EdgeInsets.only(left: 20.w),
                        decoration: BoxDecoration(
                            color: const Color(0xff71D8D4),
                            borderRadius: BorderRadius.circular(31.w),
                            border: Border.all(
                                width: 1.w, color: Color(0x4d63E6D7))),
                        child: Center(
                          child: Text(
                            widget.data["directors"][i]["name"],
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20.sp,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 30.w,
                      child: Container(
                        width: 140.w,
                        height: 140.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          border: Border.all(
                              width: 1.w, color: const Color(0xffC0F5EF)),
                          boxShadow: [
                            BoxShadow(
                                color: const Color(0x297b7b7b),
                                offset: const Offset(3, 3),
                                blurRadius: 4.w,
                                spreadRadius: 0)
                          ],
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(1.w),
                          child: WidgetMask(
                            blendMode: BlendMode.srcATop,
                            childSaveLayer: true,
                            mask: widget.directorImage[i],
                            child: Container(
                              width: 140.w,
                              height: 140.w,
                              // margin: EdgeInsets.only(left: 18.w),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                              // child:  widget.classTeacherImage[widget.classIndex][i],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 175.w,
                      left: 0.w,
                      child: Container(
                        width: 200.w,
                        height: 45.w,
                        child: Center(
                          child: Text(
                            widget.data["directors"][i]["introduction"]
                                        .toString() ==
                                    "null"
                                ? ""
                                : widget.data["directors"][i]["introduction"]
                                    .toString(),
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14.sp,
                              fontFamily: '.NotoSansKR',
                            ),
                            strutStyle: StrutStyle(
                              fontSize: 14.sp,
                              forceStrutHeight: true,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ]

            ///원장
          ],
        ),
        SizedBox(
          height: 65.w,
        ),

        ///선생님

        if (teacherInfo.isNotEmpty) ...[
          if(teacherInfo.length<6)...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                for(int i = 0; i< teacherInfo.length;i++)...[
                  teacherInfo[i],
                ]
              ],
            )

          ]else...[
            CarouselSlider(
                items: teacherInfo,
                options: CarouselOptions(
                  height: 226.w,
                  autoPlay: true,
                  enlargeCenterPage: false,
                  viewportFraction: 0.2,
                  aspectRatio: 2.0,
                  initialPage: 1,
                )),
          ]
        ],

        ///학부모

        SizedBox(
          height: 65.w,
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            for (int j = 0; j < widget.data["committees"].length; j++) ...[
              Container(
                width: 180.w,
                height: 196.w,
                child: Stack(
                  children: [
                    Positioned(
                      top: 124.w,
                      child: Container(
                        width: 180.w,
                        height: 45.w,
                        // margin: EdgeInsets.only(left: 20.w),
                        decoration: BoxDecoration(
                            color: const Color(0xffFFC9C9),
                            borderRadius: BorderRadius.circular(31.w),
                            border: Border.all(color: const Color(0x4dE66363))),
                        child: Center(
                          child: Text(
                            widget.data["committees"][j]["name"],
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16.sp,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 22.5.w,
                      child: Container(
                        width: 135.w,
                        height: 135.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          border: Border.all(
                              width: 1.w, color: const Color(0xffC0F5EF)),
                          boxShadow: [
                            BoxShadow(
                                color: const Color(0x297b7b7b),
                                offset: const Offset(3, 3),
                                blurRadius: 4.w,
                                spreadRadius: 0)
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(1),
                          child: WidgetMask(
                            blendMode: BlendMode.srcATop,
                            childSaveLayer: true,
                            mask: widget.committeesImage[j],
                            child: Container(
                              width: 135.w,
                              height: 135.w,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                              // child:  widget.classTeacherImage[widget.classIndex][i],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 179.w,
                      left: 0.w,
                      child: Container(
                        width: 180.w,
                        height: 17.w,
                        child: Center(
                          child: Text(
                            widget.data["committees"][j]["className"]
                                        .toString() ==
                                    "null"
                                ? ""
                                : widget.data["committees"][j]["className"]
                                    .toString(),
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14.sp,
                              fontFamily: '.NotoSansKR',
                            ),
                            strutStyle: StrutStyle(
                              fontSize: 14.sp,
                              forceStrutHeight: true,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ]
          ],
        )
      ],
    );
  }
}
