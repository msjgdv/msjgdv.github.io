import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:treasure_map/d_play/d5_2.dart';
import 'package:treasure_map/d_play/d5_3.dart';
import 'package:treasure_map/widgets/get_container_info.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:treasure_map/widgets/overtab.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
class D5_1 extends StatefulWidget {
  const D5_1({Key? key,
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
  State<D5_1> createState() => _D5_1State();
}

class _D5_1State extends State<D5_1> {
  bool dateOff = false;

  DateTime pageTime = DateTime.now();
  String pageTimeStr = '';

  receiveData(DateTime dateTime) async {
    pageTime = dateTime;
    var formatter = DateFormat('yyyyMMdd');
    pageTimeStr = formatter.format(pageTime);
    setState(() {

    });
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
          OverTab(nextPage: widget.nextPage, prePage: widget.prePage, nowPage: widget.nowPage,dateOnOff: dateOff, receiveData: receiveData,scaffoldKey: widget.scaffoldKey,),
          Expanded(
            child: ScrollConfiguration(
              behavior: const ScrollBehavior().copyWith(overscroll: false),
              child: ListView(
                physics: const RangeMaintainingScrollPhysics(),
                children: [
                  Container(
                    width: 50.w,
                    height: 200.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(50.w)),
                      color: const Color(0xffFCFCFC),
                    ),

                  ),

                  Row(
                    children: [
                      Container(
                        width: 50.w,
                        height: 80.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(50.w)),
                          color: const Color(0xffFCFCFC),
                        ),

                      ),
                      SizedBox(
                        width: 210.w,
                      ),

                      GestureDetector(
                        onTap: (){
                          widget.routhPage!(D5_2(nextPage: widget.nextPage, prePage: widget.prePage, nowPage: widget.nowPage,scaffoldKey: widget.scaffoldKey,));
                        },
                        child: Container(
                          width: 250.w,
                          height: 80.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(20.w,)),
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
                            child: Text('주간놀이 계획안',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 20.sp,
                              color: Color(0xff393838),
                            ),),
                          ),
                        ),
                      ),

                      SizedBox(
                        width: 100.w,
                      ),
                      GestureDetector(
                        onTap: (){
                          widget.routhPage!(D5_3(nextPage: widget.nextPage, prePage: widget.prePage, nowPage: widget.nowPage, routhPage: widget.routhPage,scaffoldKey: widget.scaffoldKey,));
                        },
                        child: Container(
                          width: 250.w,
                          height: 80.w,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(20.w,)),
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
                            child: Text('주간놀이 실행안',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 20.sp,
                                color: Color(0xff393838),
                              ),),
                          ),
                        ),
                      ),

                    ],
                  ),
                  // Container(
                  //   width: 50.w,
                  //   height: 200.w,
                  //   decoration: BoxDecoration(
                  //     borderRadius: BorderRadius.only(bottomLeft: Radius.circular(50.w)),
                  //     color: const Color(0xffFCFCFC),
                  //   ),
                  //
                  // ),
                  Row(
                    children: [
                      Container(
                        width: 50.w,
                        height: 50.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(50.w)),
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
