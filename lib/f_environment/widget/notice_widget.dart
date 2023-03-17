import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
class NoticeWidget extends StatefulWidget {
  const NoticeWidget({
    Key? key,
    required this.data,
    required this.eventImage,
    required this.nextPage,
    required this.delayTimer,
    required this.timer,
  }) : super(key: key);
  final Map<String, dynamic> data;
  final List<Image?> eventImage;
  final Function() nextPage;
  final Timer timer;
  final Function(int, Function()) delayTimer;

  @override
  State<NoticeWidget> createState() => _NoticeWidgetState();
}

class _NoticeWidgetState extends State<NoticeWidget> {
  int classIndex = 0;

  rotateClass(){
    setState(() {
      classIndex++;
    });
    if (classIndex == ((widget.data["news"]["classesSpecialDays"].length -1) < 1 ? 1 : (widget.data["news"]["classesSpecialDays"].length -1))) {
      widget.delayTimer(15, (){widget.nextPage();});
      widget.timer;

    }else{
      widget.delayTimer(15, (){rotateClass();});
      widget.timer;
    }
  }

  @override
  void initState() {

    widget.delayTimer(15, (){rotateClass();});
    widget.timer;


    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              width: 480.w,
              height: 300.w,
              margin: EdgeInsets.only(left: 32.w, top: 32.w),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: const Color(0x6663e6d7),
                  width: 1.w,
                ),
                borderRadius: BorderRadius.circular(20.w),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0x29b1b1b1),
                    offset: Offset(-2.w, 2.w),
                    blurRadius: 6.w,
                    spreadRadius: 0.w,
                  ),
                  BoxShadow(
                    color: const Color(0x29dbdbdb),
                    offset: Offset(-2.w, -4.w),
                    blurRadius: 6.w,
                    spreadRadius: 0.w,
                  ),
                ],
              ),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          margin: EdgeInsets.only(left: 27.w, top: 29.w),
                          child: Text('이번달 행사',
                              style: TextStyle(
                                fontFamily: 'NotSanaKR',
                                color: const Color(0xff898989),
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w700,
                                fontStyle: FontStyle.normal,
                              ))),
                      Container(
                          margin: EdgeInsets.only(left: 27.w, top: 30.w),
                          child: Text(
                              widget.data["news"]["month"].toString() +
                                  '월 ' +
                                  widget.data["news"]["week"].toString() +
                                  '주 ' +
                                  widget.data["news"]["weekNews"].toString() +
                                  '주요행사',
                              style: TextStyle(
                                fontFamily: 'NotSanaKR',
                                color: const Color(0xff39605f),
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w700,
                                fontStyle: FontStyle.normal,
                              ))),
                      Container(
                          margin: EdgeInsets.only(left: 27.w, top: 15.w),
                          child: Text(widget.data["news"]["weekNews"],
                              style: TextStyle(
                                fontFamily: 'NotSanaKR',
                                color: const Color(0xff39605f),
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w700,
                                fontStyle: FontStyle.normal,
                              ))),
                      Container(
                          width: 200,
                          margin: EdgeInsets.only(left: 27.w, top: 20.w),
                          child: Row(
                            children: [
                              Flexible(
                                  child: Text(
                                      widget.data["news"]["weekNewsComment"],
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      style: TextStyle(
                                        fontFamily: 'NotSanaKR',
                                        color: const Color(0xff000000),
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w500,
                                        fontStyle: FontStyle.normal,
                                      ))),
                            ],
                          )),
                    ],
                  )
                ],
              ),
            ),
            Container(
              width: 480.w,
              height: 300.w,
              margin: EdgeInsets.only(left: 22.w, top: 32.w),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: const Color(0x6663e6d7),
                  width: 1.w,
                ),
                borderRadius: BorderRadius.circular(20.w),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0x29b1b1b1),
                    offset: Offset(-2.w, 2.w),
                    blurRadius: 6.w,
                    spreadRadius: 0.w,
                  ),
                  BoxShadow(
                    color: const Color(0x29dbdbdb),
                    offset: Offset(-2.w, -4.w),
                    blurRadius: 6.w,
                    spreadRadius: 0.w,
                  ),
                ],
              ),

              child: widget.data["news"]["classesSpecialDays"].length == 0?
                Container(
                  width: 480.w,
                  height: 300.w,
                  decoration: BoxDecoration(
                    color: Color(0xffEFFFFE),

                    borderRadius: BorderRadius.circular(20.w),


                  ),
                  child: Stack(
                    children: [
                      Center(
                        child: Text(
                          widget.data['kindergarten']['name'],
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 20.sp,
                            color: Color(0xff39605F)
                          ),
                        ),
                      ),
                      Positioned(
                        bottom:-42.w,
                        right: 21.w,

                        child: SvgPicture.asset('assets/icons/icon_aijoa_logo_reverse.svg'),
                      width: 54.w,),
                      Positioned(
                        bottom:24.w,
                        right: 106.w,

                        child: Text("데이터로 행복한 아이의 삶을 디자인하다",
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 4.sp,
                                color: Color(0xff39605F)
                            ),))
                    ],
                  ),
                ):

                Row(
                children: [

                  SizedBox(
                    width: 27.w,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          margin: EdgeInsets.only(top: 29.w),
                          child: Text("오늘의 소식",
                              style: TextStyle(
                                fontFamily: 'NotSanaKR',
                                color: const Color(0xff898989),
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w700,
                                fontStyle: FontStyle.normal,
                              ))),
                      SizedBox(
                        height: 27.w,
                      ),
                      for(int i = 0; i< widget.data["news"]["kindergartenSpecialDays"].length;i++)...[
                        Container(

                            child: Text(
                                widget.data["news"]["kindergartenSpecialDays"][i],
                                style: TextStyle(
                                  fontFamily: 'NotSanaKR',
                                  color: const Color(0xff39605f),
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w700,
                                  fontStyle: FontStyle.normal,
                                ))),
                      ],

                      Container(
                          margin: EdgeInsets.only(top: 40.w),
                          child: Text(
                              widget.data["news"]["classesSpecialDays"][classIndex]
                              ['className'].length == 0 ? "" :
                              widget.data["news"]["classesSpecialDays"][classIndex]
                              ['className'],
                              style: TextStyle(
                                fontFamily: 'NotSanaKR',
                                color: const Color(0xff898989),
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w700,
                                fontStyle: FontStyle.normal,
                              ))),
                      SizedBox(
                        height: 27.w,
                      ),

                        for(int i =0; i<widget.data["news"]["classesSpecialDays"][classIndex]
                        ['comments'].length;i++)...[
                          Container(
                              child: Text(
                                  widget.data["news"]["classesSpecialDays"][classIndex]
                                  ['comments'][i],
                                  style: TextStyle(
                                    fontFamily: 'NotSanaKR',
                                    color: const Color(0xff39605f),
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w700,
                                    fontStyle: FontStyle.normal,
                                  )))
                        ],

                      ]



                  )
                ],
              ),

            ),
          ],
        ),
        Container(
          width: 860.w,
            height: 420.w,
            margin: EdgeInsets.only(top: 109.w),
            child: Column(
              children: [
                Row(
                  children: [
                    for(int i = 0; i< 4; i++)...[
                      if(i != 0)...[
                        SizedBox(
                          width: 20.w,
                        )
                      ],
                      Container(
                        width: 200.w,
                        height: 200.w,
                        child: widget.eventImage[i] ?? Container(
                          width: 200.w,
                          height: 200.w,
                          decoration: BoxDecoration(
                            border: Border.all(width: 1.w, color: Colors.black)
                          ),
                        ),
                      ),
                    ]
                  ],
                ),
                SizedBox(
                  height: 20.w,
                ),
                Row(
                  children: [
                    for(int i = 4; i< 8; i++)...[
                      if(i != 4)...[
                        SizedBox(
                          width: 20.w,
                        )
                      ],
                      Container(
                        width: 200.w,
                        height: 200.w,
                        child: widget.eventImage[i] ?? Container(
                          width: 200.w,
                          height: 200.w,
                          decoration: BoxDecoration(
                              border: Border.all(width: 1.w, color: Colors.black)
                          ),
                        ),

                      ),
                    ]
                  ],
                )
              ],
            )),
        // for (int i = 0; i < context.watch<NoticedataProvider>().ro; i++) ...[
        //   Row(children: [
        //     for (int j = 0;
        //     j < context.watch<NoticedataProvider>().co;
        //     j++) ...[
        //       Column(
        //         children: [
        //           if (j == 0) ...[
        //             Container(
        //               width: 200.w,
        //               height: 200.w,
        //               margin: EdgeInsets.only(left: 98.w, top: 30.w),
        //               child: context.watch<NoticedataProvider>().imageList[
        //               context.watch<NoticedataProvider>().co * i + j],
        //             )
        //           ] else ...[
        //             Container(
        //               width: 200.w,
        //               height: 200.w,
        //               margin: EdgeInsets.only(left: 20.w, top: 30.w),
        //               child: Center(
        //                   child: context.watch<NoticedataProvider>().imageList[
        //                   context.watch<NoticedataProvider>().co * i + j]),
        //             )
        //           ],
        //         ],
        //       )
        //     ]
        //   ]),
        // ],
      ],
    );
  }
}
