import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:treasure_map/widgets/get_container_info.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:treasure_map/widgets/overtab.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../widgets/custom_container.dart';
import 'd3_1.dart';
import 'd5_4.dart';

class D5_3 extends StatefulWidget {
  const D5_3(
      {Key? key,
      required this.nextPage,
      required this.prePage,
      required this.nowPage,
      this.scaffoldKey,
      this.routhPage,
      })
      : super(key: key);
  final Function nextPage;
  final Function prePage;
  final String nowPage;
  final GlobalKey<ScaffoldState>? scaffoldKey;
  final Function(Widget)? routhPage;

  @override
  State<D5_3> createState() => _D5_3State();
}

class _D5_3State extends State<D5_3> {
  bool dateOff = false;

  DateTime pageTime = DateTime.now();
  String pageTimeStr = '';

  List<String> playName = [
    '흙놀이',
    '식물심기',
    '팽이놀이',
  ];

  int count = 3;

  routingPage(int id){
    widget.routhPage!(D5_4(nextPage: widget.nextPage, prePage: widget.prePage, nowPage: widget.nowPage,scaffoldKey: widget.scaffoldKey,));
  }

  receiveData(DateTime dateTime) async {
    pageTime = dateTime;
    var formatter = DateFormat('yyyyMMdd');
    pageTimeStr = formatter.format(pageTime);
    setState(() {});
  }

  @override
  initState() {
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
                  SizedBox(height: 50.w,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Container(
                      //   width: 39.w,
                      //   height: 50.w,
                      //   color: const Color(0xffFCFCFC),
                      // ),
                      // SizedBox(
                      //   width: 281.w,
                      // ),
                      DateTable(),
                    ],
                  ),
                  SizedBox(
                    height: 100.w,
                  ),
                  Container(
                    height: 170.w,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for(int i = 0; i < count/2;i++)...[
                          if(i == 1)...[
                            SizedBox(
                              height: 70.w,
                            )
                          ],
                          Container(
                            width: 491.w,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                for(int j = 0; (count/2 >= 1 ? i == 0 ? j< 2 : j < count - 2 : j < count); j++)...[
                                  if(j == 1)...[
                                    SizedBox(
                                      width: 91.w,
                                    )
                                  ],
                                  WeekSelectBtn(text: playName[i*2+j], routingPage: routingPage),
                                ],
                              ],
                            ),
                          ),

                        ]
                      ],
                    ),
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

class DateTable extends StatefulWidget {
  const DateTable({Key? key,

  }) : super(key: key);

  @override
  State<DateTable> createState() => _DateTableState();
}

class _DateTableState extends State<DateTable> {
  Color borderColor = const Color(0x9dC13BFD);
  @override
  Widget build(BuildContext context) {
    return  Row(
      children: [
        CustomContainer(
          cBorderColor: borderColor,
          cTotalHeight: 40.w,
          cTotalWidth: 101.w,
          cBorderRadius: BorderRadius.only(topLeft: Radius.circular(10.w),
              bottomLeft: Radius.circular(10.w)),
          cInsideColor: Color(0xffCAACF2),
          cTopBorderWidth: 1.w,
          cLeftBorderWidth: 1.w,
          cBottomBorderWidth: 1.w,
          childWidget: Center(
            child: Text(
              "기간",
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: Color(0xff393838),
              ),
            )
          ),
        ),
        CustomContainer(
          cBorderColor: borderColor,
          cTotalHeight: 40.w,
          cTotalWidth: 390.w,
          cBorderRadius: BorderRadius.only(bottomRight: Radius.circular(10.w),
              topRight: Radius.circular(10.w)),
          cInsideColor: Color(0xffffffff),
          cTopBorderWidth: 1.w,
          cRightBorderWidth: 1.w,
          cBottomBorderWidth: 1.w,
          childWidget: Center(
              child: Text(
                "언제부터 ~ 언제까지",
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: Color(0xff393838),
                ),
              )
          ),
        ),
      ],
    );
  }
}

class WeekSelectBtn extends StatefulWidget {
  const WeekSelectBtn({Key? key,
    required this.text,
    required this.routingPage,
  }) : super(key: key);
  final String text;
  final Function(int) routingPage;


  @override
  State<WeekSelectBtn> createState() => _WeekSelectBtnState();
}

class _WeekSelectBtnState extends State<WeekSelectBtn> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        widget.routingPage(0);
      },
      child: Container(
        width: 200.w,
        height: 50.w,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10.w,)),
            color: Color(0xffFED796),
            boxShadow: [
              BoxShadow(
                color: Color(0x29767676),
                blurRadius: 3,
                offset: Offset(3, 3), // changes position of shadow
              ),
            ]
        ),
        child: Center(
          child: Text(widget.text,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16.sp,
              color: Color(0xff393838),
            ),),
        ),
      ),
    );
  }
}
