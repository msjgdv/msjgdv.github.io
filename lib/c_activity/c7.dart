// ignore_for_file: must_be_immutable
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:treasure_map/api/activity.dart';
import 'package:treasure_map/widgets/api.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../provider/app_management.dart';
import '../widgets/overtab.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

//---------------------------------------------------투약---------------------------------------------------\\
class C7 extends StatefulWidget {
  const C7({
    Key? key,
    required this.nextPage,
    required this.prePage,
    required this.nowPage,
    this.scaffoldKey,
  }) : super(key: key);
  final Function nextPage;
  final Function prePage;
  final String nowPage;
  final GlobalKey<ScaffoldState>? scaffoldKey;

  @override
  State<C7> createState() => _C7State();
}

class _C7State extends State<C7> {
  static final autoLoginStorage = FlutterSecureStorage();
  bool dateOn = true;


  List<GetMedicineData> childMedicineData = [];

  getChildMedicineData() async {
    ApiUrl apiUrl = ApiUrl();
    http.Response medicineRes = await api(apiUrl.medicine + '/' + Provider.of<UserInfo>(context, listen: false).value[0].toString() + '/' + pageTimeStr, 'get', 'signInToken', {}, context);
    if(medicineRes.statusCode == 200){
      var medicineRB = utf8.decode(medicineRes.bodyBytes);
      var medicineData = jsonDecode(medicineRB);
      childMedicineData.clear();
      setState(() {
        for (int i = 0; i < medicineData.length; i++) {
          childMedicineData.add(GetMedicineData(
              type: medicineData[i]['type'],
              id: medicineData[i]['id'],
              name: medicineData[i]['name'],
              comment: medicineData[i]['comment'],
              time: medicineData[i]['time'],
              count: medicineData[i]['count'],
              amount: medicineData[i]['amount'],
              parentSign: medicineData[i]['parentSign'],
              storageMethod: medicineData[i]['storageMethod'],
              symptom: medicineData[i]['symptom'],
              teacherSign: medicineData[i]['teacherSign']));
        }
      });
    }
  }

  DateTime pageTime = DateTime.now();
  String pageTimeStr = '';

  receiveData(DateTime dateTime) async {
    //api 보내는 날짜를 바꿈
    pageTime = dateTime;
    var formatter = DateFormat('yyyyMMdd');
    pageTimeStr = formatter.format(pageTime);
    //api 통신 후 데이터 받아오기

    //......
    setState(() {
      getChildMedicineData();
      //데이터 넣어주기
      //ex) data = response["data"];
    });
  }

  @override
  initState() {
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
        color: const Color(0xffFCFCFC),
      ),
      child: Column(
        children: [
          OverTab(
            nextPage: widget.nextPage,
            prePage: widget.prePage,
            nowPage: widget.nowPage,
            receiveData: receiveData,
            dateOnOff: dateOn,
            scaffoldKey: widget.scaffoldKey,
          ),
          Expanded(
            child: ScrollConfiguration(
              behavior: const ScrollBehavior().copyWith(overscroll: false),
              child: ListView(
                physics: const RangeMaintainingScrollPhysics(),
                children: [
                  for (int i = 0; i < childMedicineData.length; i++) ...[
                    Row(
                      children: [
                        Container(
                          width: 39.w,
                          height: 152.w,
                          //color: Colors.black,
                          color: const Color(0xffFCFCFC),
                        ),
                        ChildMedicineWidget(
                            getMedicineData: childMedicineData[i],),
                      ],
                    ),
                    if (i == childMedicineData.length - 1) ...[
                      Row(
                        children: [
                          Container(
                            width: 39.w,
                            height: 50.w,
                            decoration: BoxDecoration(
                              color: const Color(0xffFCFCFC),
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(50.w)),
                            ),
                          ),
                        ],
                      )
                    ] else ...[
                      Row(
                        children: [
                          Container(
                            width: 39.w,
                            height: 50.w,
                            color: const Color(0xffFCFCFC),
                          ),
                        ],
                      )
                    ]
                  ]
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ChildMedicineWidget extends StatefulWidget {
  ChildMedicineWidget({
    required this.getMedicineData,
    Key? key})
      : super(key: key);
  final GetMedicineData getMedicineData;

  @override
  State<ChildMedicineWidget> createState() => _ChildMedicineWidgetState();
}

class _ChildMedicineWidgetState extends State<ChildMedicineWidget> {
  Color columnhexcolor = const Color(0xFFFFEFD3);
  Color columnhexcolor2 = const Color(0xFFFFFDF8);
  Color rowhexcolor = const Color(0xFFFFFFFF);

  double borderradius = 20.w;
  double borderwidth = 1.w;
  Color borderhexcolor = const Color(0x4DFDB43B);

  double fontsize14 = 14.sp;
  Color fonthexcolor = const Color(0xFF393838);

  List<String> columntitlelist = [
    '약 종류',
    '투약 용량',
    '투약 횟수',
    '투약 시간',
    '보관 방법',
    '특이사항'
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 26.2.w),
      //width: 1052.w, //왜 width조절이 안되지??
      height: 152.w,
      decoration: BoxDecoration(
        color: columnhexcolor,
        border: Border.all(color: borderhexcolor, width: borderwidth),
        borderRadius: BorderRadius.all(Radius.circular(borderradius)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x29B1B1B1),
            blurRadius: 6,
            offset: Offset(-2, 2),
          )
        ],
      ),
      child: Row(
        children: [
          Column(
            children: [
              Container(
                width: 90.w,
                height: 70.w,
                decoration: BoxDecoration(
                    color: columnhexcolor,
                    border:
                        Border.all(color: borderhexcolor, width: borderwidth),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(borderradius))),
                child: Center(
                  child: Text(
                    '유아명',
                    style: TextStyle(fontSize: fontsize14, color: fonthexcolor),
                  ),
                ),
              ),
              Container(
                  width: 90.w,
                  height: 80.w,
                  decoration: BoxDecoration(
                      color: rowhexcolor,
                      border:
                          Border.all(color: borderhexcolor, width: borderwidth),
                      borderRadius: BorderRadius.only(
                          // bottomLeft: Radius.circular(borderradius)
                      )),
                  child: Center(child: Text(widget.getMedicineData.name,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 14.sp,
                    color: Color(0xff393838),
                  ),))
              )
            ],
          ),
          Column(
            children: [
              Container(
                width: 90.w,
                height: 70.w,
                decoration: BoxDecoration(
                  color: columnhexcolor,
                  border: Border.all(color: borderhexcolor, width: borderwidth),
                ),
                child: Center(
                  child: Text(
                    '증상',
                    style: TextStyle(fontSize: fontsize14, color: fonthexcolor),
                  ),
                ),
              ),
              Container(
                width: 90.w,
                height: 80.w,

                decoration: BoxDecoration(
                    color: rowhexcolor,
                    border:
                        Border.all(color: borderhexcolor, width: borderwidth),
                    borderRadius:
                        BorderRadius.only(bottomLeft: Radius.circular(10.w))),
    child: Center(child: Text(widget.getMedicineData.symptom,
      style: TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: 14.sp,
        color: Color(0xff393838),
      ),))
              )
            ],
          ),
          Column(
            children: [
              Container(
                width: 480.w,
                height: 30.w,
                decoration: BoxDecoration(
                  color: columnhexcolor2,
                  border: Border.all(color: borderhexcolor, width: borderwidth),
                ),
                child: Center(
                  child: Text(
                    '투약내용',
                    style: TextStyle(fontSize: fontsize14, color: fonthexcolor),
                  ),
                ),
              ),
              Row(
                children: [
                  Column(
                    children: [
                      Container(
                        width: 80.w,
                        height: 40.w,
                        decoration: BoxDecoration(
                          color: columnhexcolor,
                          border: Border.all(
                              color: borderhexcolor, width: borderwidth),
                        ),
                        child: Center(
                          child: Text(
                            '약 종류',
                            style: TextStyle(
                                fontSize: fontsize14, color: fonthexcolor),
                          ),
                        ),
                      ),
                      Container(
                        width: 80.w,
                        height: 80.w,
                        decoration: BoxDecoration(
                          color: rowhexcolor,
                          border: Border.all(
                              color: borderhexcolor, width: borderwidth),
                        ),
                          child: Center(child: Text(widget.getMedicineData.type,
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 14.sp,
                              color: Color(0xff393838),
                            ),))
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                        width: 80.w,
                        height: 40.w,
                        decoration: BoxDecoration(
                          color: columnhexcolor,
                          border: Border.all(
                              color: borderhexcolor, width: borderwidth),
                        ),
                        child: Center(
                          child: Text(
                            '투약 용량',
                            style: TextStyle(
                                fontSize: fontsize14, color: fonthexcolor),
                          ),
                        ),
                      ),
                      Container(
                        width: 80.w,
                        height: 80.w,
                        decoration: BoxDecoration(
                          color: rowhexcolor,
                          border: Border.all(
                              color: borderhexcolor, width: borderwidth),
                        ),
                          child: Center(child: Text(widget.getMedicineData.amount,
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 14.sp,
                              color: Color(0xff393838),
                            ),))
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                        width: 80.w,
                        height: 40.w,
                        decoration: BoxDecoration(
                          color: columnhexcolor,
                          border: Border.all(
                              color: borderhexcolor, width: borderwidth),
                        ),
                        child: Center(
                          child: Text(
                            '투약 횟수',
                            style: TextStyle(
                                fontSize: fontsize14, color: fonthexcolor),
                          ),
                        ),
                      ),
                      Container(
                        width: 80.w,
                        height: 80.w,
                        decoration: BoxDecoration(
                          color: rowhexcolor,
                          border: Border.all(
                              color: borderhexcolor, width: borderwidth),
                        ),
                          child: Center(child: Text(widget.getMedicineData.count,
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 14.sp,
                              color: Color(0xff393838),
                            ),))
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                        width: 80.w,
                        height: 40.w,
                        decoration: BoxDecoration(
                          color: columnhexcolor,
                          border: Border.all(
                              color: borderhexcolor, width: borderwidth),
                        ),
                        child: Center(
                          child: Text(
                            '투약 시간',
                            style: TextStyle(
                                fontSize: fontsize14, color: fonthexcolor),
                          ),
                        ),
                      ),
                      Container(
                        width: 80.w,
                        height: 80.w,
                        decoration: BoxDecoration(
                          color: rowhexcolor,
                          border: Border.all(
                              color: borderhexcolor, width: borderwidth),
                        ),
                          child: Center(child: Text(widget.getMedicineData.time,
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 14.sp,
                              color: Color(0xff393838),
                            ),))
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                        width: 80.w,
                        height: 40.w,
                        decoration: BoxDecoration(
                          color: columnhexcolor,
                          border: Border.all(
                              color: borderhexcolor, width: borderwidth),
                        ),
                        child: Center(
                          child: Text(
                            '보관 방법',
                            style: TextStyle(
                                fontSize: fontsize14, color: fonthexcolor),
                          ),
                        ),
                      ),
                      Container(
                        width: 80.w,
                        height: 80.w,
                        decoration: BoxDecoration(
                          color: rowhexcolor,
                          border: Border.all(
                              color: borderhexcolor, width: borderwidth),
                        ),
                          child: Center(child: Text(widget.getMedicineData.storageMethod,
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 14.sp,
                              color: Color(0xff393838),
                            ),))
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                        width: 80.w,
                        height: 40.w,
                        decoration: BoxDecoration(
                          color: columnhexcolor,
                          border: Border.all(
                              color: borderhexcolor, width: borderwidth),
                        ),
                        child: Center(
                          child: Text(
                            '특이사항',
                            style: TextStyle(
                                fontSize: fontsize14, color: fonthexcolor),
                          ),
                        ),
                      ),
                      Container(
                        width: 80.w,
                        height: 80.w,
                        decoration: BoxDecoration(
                          color: rowhexcolor,
                          border: Border.all(
                              color: borderhexcolor, width: borderwidth),
                        ),
                          child: Center(child: Text(widget.getMedicineData.comment,
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 14.sp,
                              color: Color(0xff393838),
                            ),))
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
          Column(
            children: [
              Container(
                width: 400.w,
                height: 30.w,
                decoration: BoxDecoration(
                    color: columnhexcolor2,
                    border:
                        Border.all(color: borderhexcolor, width: borderwidth),
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(borderradius))),
                child: Center(
                  child: Text(
                    '투약',
                    style: TextStyle(fontSize: fontsize14, color: fonthexcolor),
                  ),
                ),
              ),
              Row(
                children: [
                  Container(
                    width: 200.w,
                    height: 40.w,
                    decoration: BoxDecoration(
                      color: columnhexcolor,
                      border:
                          Border.all(color: borderhexcolor, width: borderwidth),
                    ),
                    child: Center(
                      child: Text(
                        '의뢰',
                        style: TextStyle(
                            fontSize: fontsize14, color: fonthexcolor),
                      ),
                    ),
                  ),
                  Container(
                      width: 200.w,
                      height: 40.w,
                      decoration: BoxDecoration(
                        color: columnhexcolor,
                        border: Border.all(
                            color: borderhexcolor, width: borderwidth),
                      ),
                      child: Center(
                        child: Text(
                          '확인',
                          style: TextStyle(
                              fontSize: fontsize14, color: fonthexcolor),
                        ),
                      ))
                ],
              ),
              Row(
                children: [
                  Container(
                    width: 200.w,
                    height: 80.w,
                    decoration: BoxDecoration(
                      color: rowhexcolor,
                      border:
                          Border.all(color: borderhexcolor, width: borderwidth),
                    ),
                  ),
                  Container(
                    width: 200.w,
                    height: 80.w,
                    decoration: BoxDecoration(
                        color: rowhexcolor,
                        border: Border.all(
                            color: borderhexcolor, width: borderwidth),
                        borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(borderradius))),
                  )
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
