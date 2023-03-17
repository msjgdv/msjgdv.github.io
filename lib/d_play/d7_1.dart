import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:treasure_map/d_play/d7_2.dart';
import 'package:treasure_map/widgets/get_container_info.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:treasure_map/widgets/overtab.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
class D7_1 extends StatefulWidget {
  const D7_1({Key? key,
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
  State<D7_1> createState() => _D7_1State();
}

class _D7_1State extends State<D7_1> {
  bool dateOff = false;

  DateTime pageTime = DateTime.now();
  String pageTimeStr = '';

  int count = 5;

  List<String> playList = [
    '숨바꼭질',
    '고무줄놀이',
    '말뚝박기',
    '망까기',
    '말타기',
  ];

  receiveData(DateTime dateTime) async {
    pageTime = dateTime;
    var formatter = DateFormat('yyyyMMdd');
    pageTimeStr = formatter.format(pageTime);
    setState(() {

    });
  }

  routingPage(int id){
    widget.routhPage!(D7_2(nextPage: widget.nextPage, prePage: widget.prePage, nowPage: widget.nowPage,scaffoldKey: widget.scaffoldKey,));
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
          // Expanded(
          //   child: ScrollConfiguration(
          //     behavior: const ScrollBehavior().copyWith(overscroll: false),
          //     child: ListView(
          //       physics: const RangeMaintainingScrollPhysics(),
          //       children: [
          //         for(int i = 0; i < count/4;i++)...[
          //           if(i != 0)...[
          //             Container(
          //               width: 50.w,
          //               height: 70.w,
          //
          //                 color: const Color(0xffFCFCFC),
          //
          //             ),
          //           ],
          //           Container(
          //             width: 491.w,
          //             color: Color(0xfffcfcfc),
          //             child: Row(
          //               mainAxisAlignment: MainAxisAlignment.center,
          //               children: [
          //                 for(int j = 0; (count/4 >= 1 ? i < count~/4 ? j< 4 : j < count%4 : j < count); j++)...[
          //                   if(j != 0)...[
          //                     Container(
          //                       width: 50.w,
          //                       height: 91.w,
          //
          //                         color: const Color(0xffFCFCFC),
          //
          //                     ),
          //
          //                   ],
          //                   SubjectSelectBtn(text: playList[i*4+j], routingPage: routingPage),
          //                 ],
          //               ],
          //             ),
          //           ),
          //
          //         ],
          //         Row(
          //           children: [
          //             Container(
          //               width: 50.w,
          //               height: 50.w,
          //               decoration: BoxDecoration(
          //                 borderRadius: BorderRadius.only(
          //                     bottomLeft: Radius.circular(50.w)),
          //                 color: const Color(0xffFCFCFC),
          //               ),
          //             ),
          //           ],
          //         )
          //       ],
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}



class SubjectSelectBtn extends StatefulWidget {
  const SubjectSelectBtn({Key? key,
    required this.text,
    required this.routingPage,
  }) : super(key: key);
  final String text;
  final Function(int) routingPage;


  @override
  State<SubjectSelectBtn> createState() => _SubjectSelectBtnState();
}

class _SubjectSelectBtnState extends State<SubjectSelectBtn> {
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
