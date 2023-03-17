import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:widget_mask/widget_mask.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:async';

import 'package:provider/provider.dart';

class InfoPageWidget extends StatefulWidget {
  const InfoPageWidget({Key? key,
    required this.infoImage,
    required this.nextPage,
  }) : super(key: key);
  final List<Image?> infoImage;
  final Function() nextPage;

  @override
  State<InfoPageWidget> createState() => _InfoPageWidgetState();
}

class _InfoPageWidgetState extends State<InfoPageWidget> {
  Image voidPage = Image.asset("assets/images/borabora/childlifedata/void_page.png");
  int now = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1920.w,
      height: 1080.w,
      color: Color(0xffEFFFFE),
      child:
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          for(int i = now;i<now + 3;i++)...[
            Container(
              width: 581.29.w,
              height: 824.87.w,
              child:Stack(
                children: [
                  Positioned(
                      top: 25.32.w,
                      left: 8.14.w,
                      child: WidgetMask(
                        blendMode: BlendMode.srcATop,
                        childSaveLayer: true,
                        mask: widget.infoImage[i] == null ? voidPage : widget.infoImage[i]!,
                        child: Container(
                          width: 565.w,
                          height: 800.w,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(20.w)),
                          ),
                        ),
                      )),
                  Container(
                    width: 581.29.w,
                    height: 824.87.w,
                    child:    SvgPicture.asset(
                      'assets/images/borabora/childlifedata/info_page_deco.svg',
                      height: 32.w,
                      width: 32.w,
                    ),


                  )
                ],
              ),
            )
          ]

        ],
      ),
    );
  }
}
