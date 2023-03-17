import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:treasure_map/e_growth/atti/atti5.dart';
import 'package:treasure_map/e_growth/atti/report/atti_a.dart';
import 'package:treasure_map/e_growth/atti/report/home_1.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../widgets/custom_page_route.dart';
import '../widget/home_image.dart';
import 'home_5.dart';

class Home_2 extends StatefulWidget {
  const Home_2({
    Key? key,
    this.nextPage = const Atti5(),
  }) : super(key: key);
  final Widget nextPage;

  @override
  State<Home_2> createState() => _Home_2State();
}

class _Home_2State extends State<Home_2> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onVerticalDragEnd: (DragEndDetails dragEndDetails) {
          if (dragEndDetails.primaryVelocity! > 0.0) {
            Navigator.of(context).push(CustomPageRoute(
                child: Home_1(), direction: AxisDirection.down));
          } else if (dragEndDetails.primaryVelocity! < 0.0) {
            Navigator.of(context).push(CustomPageRoute(
                child: widget.nextPage, direction: AxisDirection.up));
          }
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Colors.white,
          child: Stack(
            children: [
              Positioned(
                top: 100.w,
                left: 112.w,
                child: Text(
                  "또래관계 데이터 분석결과 보고서",
                  style: TextStyle(
                    decoration: TextDecoration.none,
                    fontSize: 70.w,
                    fontWeight: FontWeight.w900,
                    color: Color(0xffEDEDED),
                  ),
                ),
              ),
              Positioned(
                top: 120.w,
                left: 120.w,
                child: Text(
                  "또래관계 데이터 분석결과 보고서",
                  style: TextStyle(
                    decoration: TextDecoration.none,
                    fontSize: 67.w,
                    fontWeight: FontWeight.w900,
                    color: Color(0xff3C3C3B),
                  ),
                ),
              ),
              Positioned(
                top: 260.w,
                  left: 120.w,
                  width: 430.w,
                  child: RichText(
                    text: TextSpan(
                      text: "본 보고서는 또래 간 관계 데이터를 분석한 결과입니다.\n",
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 17.w,
                          color: Color(0xff3C3C3B),
                          height: 2.w),
                      children: <TextSpan>[
                        TextSpan(
                            text: "또래관계 데이터 분석은 또래지명법, 또래평정법, \n사회연결망 분석을 활용하였으며 "
                                "그 결과를 "),
                        TextSpan(
                          text: "8가지로 \n구분하고 시각적으로 표현하여 제공",
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 17.w,
                              color: Color(0xff9027F4 ),
                              height: 2.w),
                        ),
                        TextSpan(
                            text: "합니다. "
                                "또래관계 \n데이터 분석 결과보고서는 "),
                        TextSpan(
                          text: "유아의 개별적인 특징과 \n또래관계의 전체적인 유형을 진단하여 제공",
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 17.w,
                              color: Color(0xff9027F4),
                              height: 2.w),
                        ),
                        TextSpan(text: "하므로 \n교실 내 또래관계를 이해하고 "),
                        TextSpan(
                          text: "개별유아의 특징에 따라 \n또래관계를 지원하는 기초자료로 활용",
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 17.w,
                              color: Color(0xff9027F4),
                              height: 2.w),
                        ),
                        TextSpan(
                          text: "될 수 있습니다. ",
                        )
                      ],

                      // textAlign: TextAlign.center,
                    ),
                  )),
              Positioned(
                top: 270.w,
                  left: 560.w,
                  child: Container(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ReportIntroIcons(info: '우리반 또래관계 분석현황', mainImage: 'assets/icons/atti/atti_find_icon.svg',),
                            SizedBox(height: 30.w,),
                            ReportIntroIcons(info: '개별유아와 또래간 연결\n및 영향수준', mainImage: 'assets/icons/atti/atti_connect_icon.svg',),
                            SizedBox(height: 30.w,),
                            ReportIntroIcons(info: '우리반 동심원형 유아\n네트워크 구조', mainImage: 'assets/icons/atti/atti_circle_network_icon.svg',),
                            SizedBox(height: 30.w,),
                            ReportIntroIcons(info: '우리반 사회적 지위 분포도', mainImage: 'assets/icons/atti/atti_rank_icon.svg',),
                            SizedBox(height: 30.w,),
                            ReportIntroIcons(info: '우리반의 싫어하는 또래 네트워크', mainImage: 'assets/icons/atti/atti_hate_icon.svg',),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ReportIntroIcons(info: '개별유아가 좋아하는 친구들', mainImage: 'assets/icons/atti/atti_heart_icon.svg',),
                            SizedBox(height: 30.w,),
                            ReportIntroIcons(info: '우리반 또래 관계도', mainImage: 'assets/icons/atti/atti_relationship_icon.svg',),
                            SizedBox(height: 30.w,),
                            ReportIntroIcons(info: '우리반 또래 인기도', mainImage: 'assets/icons/atti/atti_popularity_icon.svg',),
                            SizedBox(height: 30.w,),
                            ReportIntroIcons(info: '우리반의 좋아하는 또래 네트워크', mainImage: 'assets/icons/atti/atti_favorite_network_icon.svg',),
                            // SizedBox(height: 30.w,),
                            // ReportIntroIcons(info: '우리반의 싫어하는 또래 네트워크', mainImage: 'assets/icons/atti/atti_hate_icon.svg',),
                          ],
                        )
                      ],
                    ),
                  )
              ),
              Positioned(
                  top: 630.w,
                  left: 610.w,
                  child: Icon(Icons.keyboard_arrow_down,
                    size: 60.w,
                    color: Color(0xff707070),)),
            ],
          ),
        ));
  }
}

class ReportIntroIcons extends StatefulWidget {
  const ReportIntroIcons({Key? key,
  required this.info,
    required this.mainImage,
  }) : super(key: key);
  final String mainImage;
  final String info;


  @override
  State<ReportIntroIcons> createState() => _ReportIntroIconsState();
}

class _ReportIntroIconsState extends State<ReportIntroIcons> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 45.w,
          height: 45.w,
          color: Color(0xff9027F4),
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: SvgPicture.asset(widget.mainImage),
          ),
        ),
        SizedBox(
          width: 15.w,
        ),
        Text(widget.info,
        style: TextStyle(
          decoration: TextDecoration.none,
          color: Color(0xff3C3C3B),
          fontSize: 16.w

        ),),
      ],
    );
  }
}