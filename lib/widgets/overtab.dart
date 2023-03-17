import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:math' as math;
import 'package:aligned_dialog/aligned_dialog.dart';
import 'package:provider/provider.dart';
import 'package:treasure_map/widgets/token_decode.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../a_main/a6_1.dart';
import '../provider/app_management.dart';
import 'calendar.dart';
import 'login_route.dart';

//결국엔 provider를 쓰지 않고 날짜만 가져오는 형식을 사용함
//추후 수정사항은 유치원 이름 받아오는 것 만들기

class OverTab extends StatefulWidget {
  const OverTab({Key? key,
    required this.prePage,
    required this.nextPage,
    required this.nowPage,
    required this.dateOnOff,
    this.receiveData,
    this.scaffoldKey,
  }) : super(key: key);
  final Function nextPage;
  final Function prePage;
  final String nowPage;
  final bool dateOnOff;
  final Function(DateTime)? receiveData;
  final GlobalKey<ScaffoldState>? scaffoldKey;

  @override
  State<OverTab> createState() => _OverTabState();
}

class _OverTabState extends State<OverTab> {
  String date = '';
  DateTime dateTime = DateTime.now();


  @override
  initState(){

    date = getToday(dateTime);

    // TODO: implement initState
    super.initState();
  }


  changeDate(DateTime _date){
    setState(() {
      dateTime = _date;
      date = getToday(_date);
      widget.receiveData!(_date);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                flex: 1,
                child: SizedBox(
                  width: 39.w,
                ),
              ),
              Flexible(
                flex: 100,
                child: Column(
                  children: [
                    SizedBox(
                      height: 40.w,
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 30.w,
                          ),
                          Container(
                            // margin: EdgeInsets.only(top: 20.w,left: 20.w),
                            child:
                            GestureDetector(
                              onTap: (){
                                    loginRoute(context, Provider.of<UserInfo>(context, listen: false).role);
                              },

                                child: SvgPicture.asset('assets/logo/orange.svg',
                                  width: 200.w,
                                )),

                          ),
                          Spacer(),
                          Container(
                            // margin: EdgeInsets.only(
                            //     top: 20.w),
                            height: 58.w,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  Provider.of<UserInfo>(context, listen: false).value[1],
                                  style: TextStyle(
                                      fontSize: 40.w,
                                      color: Color(0xff707070),
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                          Spacer(),
                          Container(
                            // padding: EdgeInsets.only(top: 22.w),
                            width: 130.w,
                            child: widget.dateOnOff == true ? GestureDetector(
                              onTap: (){
                                showAlignedDialog(
                                  offset: Offset(330.w, 225.w),
                                    barrierColor: Colors.transparent,
                                    context: context,
                                    builder: (BuildContext context){
                                      return AijoaCalendar(changeDate: changeDate, nowDate: dateTime,);
                                    }
                                );
                              },
                              child: Text(date,
                            textAlign: TextAlign.end,
                            style: TextStyle(
                              color: Color(0xff393838),
                              fontWeight: FontWeight.w400,
                              fontSize: 20.sp
                            ))):Container(),
                          ),
                          SizedBox(
                            width: 20.w,
                          ),
                          Container(
                            // margin: EdgeInsets.only(top: 25.w),
                            child: GestureDetector(
                              onTap: () {
                                widget.scaffoldKey!.currentState?.openEndDrawer();

                              },
                              child: SvgPicture.asset(
                                'assets/icons/icon_menu.svg',
                                width: 33.w,
                              ),

                            ),
                          ),
                          SizedBox(
                            width: 25.w,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 11.w,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          flex: 1,
                          child: Container(
                            margin: EdgeInsets.only(left: 15.w),
                            child: Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.start,
                              children: [
                                Container(
                                  child: IconButton(
                                    onPressed: () {
                                      widget.prePage();
                                    },
                                    icon: SvgPicture.asset(
                                      'assets/icons/icon_back.svg',
                                    ),
                                    iconSize: 12.w,
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(bottom: 8.w),
                                  width: 240.w,
                                  child: Text(
                                        widget.nowPage,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 24.w,
                                        color: Color(0xff393838)),
                                    textAlign: TextAlign.center,
                                  ).tr(),
                                ),
                                Container(
                                    child: Transform.rotate(
                                  angle: 180 * math.pi / 180,
                                  child: IconButton(
                                    onPressed: () {
                                      widget.nextPage();
                                    },
                                    icon: SvgPicture.asset(
                                      'assets/icons/icon_back.svg',
                                    ),
                                    iconSize: 12.w,
                                  ),
                                ))
                              ],
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          child: Container(
                            margin: EdgeInsets.only(right: 16.w),
                            child: Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.end,
                              children: [
                                GestureDetector(
                                  onTap: () {},
                                  child: SvgPicture.asset(
                                    'assets/icons/icon_find.svg',width: 40.w,),
                                ),
                                SizedBox(
                                  width: 17.w,
                                ),
                                GestureDetector(
                                  onTap: () {},
                                  child: SvgPicture.asset(
                                    'assets/icons/icon_share.svg',width: 35.w,),
                                ),
                                SizedBox(
                                  width: 20.w,
                                ),
                                GestureDetector(
                                  onTap: () {},
                                  child: SvgPicture.asset(
                                    'assets/icons/icon_print.svg',width: 36.w,),
                                ),
                                SizedBox(
                                  width: 20.w,
                                ),
                                GestureDetector(
                                  onTap: () {},
                                  child: SvgPicture.asset(
                                      'assets/icons/icon_comment.svg',width: 36.w,),
                                ),
                                SizedBox(
                                  width: 8.w,
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          )
    );
  }
}

String getToday(DateTime _dateTime){
  var formatter = DateFormat('yyyy.MM.dd');
  var strToday = formatter.format(_dateTime);
  return strToday;
}
