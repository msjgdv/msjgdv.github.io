import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:treasure_map/provider/app_management.dart';
import 'package:treasure_map/widgets/api.dart';
import 'package:treasure_map/widgets/dropdown_child.dart';
import 'package:treasure_map/widgets/get_container_info.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:treasure_map/widgets/nuri.dart';
import 'package:treasure_map/widgets/overtab.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../widgets/custom_container.dart';
import 'd3_1.dart';

class D10 extends StatefulWidget {
  const D10(
      {Key? key,
      required this.nextPage,
      required this.prePage,
      required this.nowPage,
      this.scaffoldKey})
      : super(key: key);
  final Function nextPage;
  final Function prePage;
  final String nowPage;
  final GlobalKey<ScaffoldState>? scaffoldKey;

  @override
  State<D10> createState() => _D10State();
}

class _D10State extends State<D10> {
  bool dateOff = false;

  DateTime pageTime = DateTime.now();
  String pageTimeStr = '';
  double totalHeight = 40;

  totalHeightSet(double value){
    setState(() {
      totalHeight = value;
    });
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
                padding: EdgeInsets.zero,
                physics: const RangeMaintainingScrollPhysics(),
                children: [
                  Row(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 39.w,
                            height: totalHeight.w,
                            color: const Color(0xffFCFCFC),
                          ),
                        ],
                      ),
                      StudentRecord(
                        totalHeightSet: totalHeightSet,
                      ),
                    ],
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

class StudentRecord extends StatefulWidget {
  const StudentRecord({Key? key,
    required this.totalHeightSet,
  }) : super(key: key);
  final Function(double) totalHeightSet;

  @override
  State<StudentRecord> createState() => _StudentRecordState();
}

class _StudentRecordState extends State<StudentRecord> {
  ApiUrl apiUrl = ApiUrl();
  Color borderColor = const Color(0x9dC13BFD);
  int childId = 0;
  int selectIndex = 0;
  List<DropDownChildInfo> dropDownChildInfo = [];
  bool onOff = false;
  Image? childImg;
  Nuri nuri = Nuri();
  List<double> nuriHeight = [];
  double nuriTotalHeight = 0;

  getChildData() async {
    var formatter = DateFormat('yyyyMMdd');
    String toDayStr = formatter.format(DateTime.now());
    http.Response childRes =
    await api('${apiUrl.child}/$toDayStr?cid=${Provider.of<UserInfo>(context, listen: false).value[0]}', 'get', 'signInToken', {}, context);
    if (childRes.statusCode == 200) {
      var childRB = utf8.decode(childRes.bodyBytes);
      var childData = jsonDecode(childRB);

      setState(() {
        dropDownChildInfo.clear();
        for (int i = 0; i < childData.length; i++) {
          dropDownChildInfo.add(DropDownChildInfo(
              childName: childData[i]['name'], childId: childData[i]['id']));
        }
        onOff = true;

      });
    }
  }

  patchLifeData(String type, value) async{
    http.Response res =
        await api(apiUrl.life, 'patch', 'signInToken', {
          "id": childId,
          "type": type,
          "value": value
        }, context);
    if (res.statusCode == 200) {
      getLifeData();

    }
  }

  patchAddressData(String type, value) async{
    http.Response res =
    await api(apiUrl.child, 'patch', 'signInToken', {
      "id": childId,
      "type": type,
      "value": value
    }, context);
    if (res.statusCode == 200) {
      getLifeData();
    }
  }

  setChildId(int newValue, int index) {
    setState(() {
      childId = newValue;
      selectIndex = index;
    });
    getLifeData();
  }

  var lifeData;

  getLifeData() async {
    http.Response res =
        await api('${apiUrl.life}/$childId', 'get', 'signInToken', {}, context);
    if (res.statusCode == 200) {
      var lifeRB = utf8.decode(res.bodyBytes);

      setState(() {
        lifeData = jsonDecode(lifeRB);
      });
      childImg = await imageApi(lifeData['imagePath'], 'signInToken', context);

      nuriHeight.clear();
      nuriTotalHeight = 0;
      for(int i = 0; i< lifeData['nuriStatus'].length;i++){
        nuriHeight.add(0);
        for(int j = 0; j< lifeData['nuriStatus'][i]['comments'].length;j++){
          nuriHeight[i] = nuriHeight[i] + 40 + 23 * lineCounter(lifeData['nuriStatus'][i]['comments'][j]['comment']);
        }
        nuriTotalHeight = nuriTotalHeight + nuriHeight[i];
      }
      setState(() {
        widget.totalHeightSet(1142.0 + (lifeData['schoolRecords'].length + 1) * 40 + lifeData['attendanceStatus'].length * 40 + lifeData['physicalStatus'].length * 40 + nuriTotalHeight);
      });

    }
  }

  lineCounter(String string){
    int count = 0;
    for(int i = 0; i< string.split('\n').length;i++){
      count = count + (string.split('\n')[i].length / 60).ceil();
    }
    return count == 0 ? 0 : count - 1;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getChildData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 1053.w,
        // height: 870.w,
        decoration: BoxDecoration(
          // borderRadius: BorderRadius.only(topRight: Radius.circular(20.w),
          //     topLeft: Radius.circular(20.w)),
          boxShadow: [
            // BoxShadow(
            //   color: Color(0x29B1B1B1),
            //   blurRadius: 6,
            //   offset: Offset(-2, 2),
            // )
          ],
        ),
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              CustomContainer(
                cBorderColor: borderColor,
                cTotalHeight: 40.w,
                cTotalWidth: 87.w,
                cInsideColor: Color(0xffCAACF2),
                cTopBorderWidth: 1.w,
                cLeftBorderWidth: 1.w,
                cBottomBorderWidth: 1.w,
                childWidget: Center(
                  child: RecordTableTextStyle(
                    text: '이름',
                    title: false,
                  ),
                ),
              ),
              CustomContainer(
                cBorderColor: borderColor,
                cTotalHeight: 40.w,
                cTotalWidth: 245.w,
                cInsideColor: Color(0xffffffff),
                cTopBorderWidth: 1.w,
                cLeftBorderWidth: 1.w,
                cBottomBorderWidth: 1.w,
                cRightBorderWidth: 1.w,
                childWidget: Row(
                  children: [
                    if (onOff) ...[
                      ChildDropDownButton(
                        setChildId: setChildId,
                        dropDownChildInfo: dropDownChildInfo,
                        borderRadius: 0,
                        borderColor: Colors.transparent,
                        width: 243,
                        shadow: false,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: 30.w,
          ),
          if (lifeData != null) ...[
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Column(
                children: [
                  CustomContainer(
                    cBorderColor: borderColor,
                    cTotalHeight: 40.w,
                    cTotalWidth: 172.w,
                    cBorderRadius: lifeData['classes'].length != 0
                        ? BorderRadius.only(topLeft: Radius.circular(20.w))
                        : BorderRadius.only(
                            topLeft: Radius.circular(20.w),
                            topRight: Radius.circular(20.w)),
                    cInsideColor: Color(0xffCAACF2),
                    cTopBorderWidth: 1.w,
                    cLeftBorderWidth: 1.w,
                    cRightBorderWidth:
                        lifeData['classes'].length != 0 ? 0.w : 1.w,
                    childWidget: Stack(
                      children: [
                        CustomPaint(
                          size: Size(171.w, 40.w),
                          painter: MyPainter(
                              lineStart: Offset(10.w, 2.w),
                              lineEnd: Offset(171.w, 40.w)),
                        ),
                        Positioned(
                          top: 1.5.w,
                          right: 15.5.w,
                          child: RecordTableTextStyle(
                            text: "연령",
                            title: false,
                          ),
                        ),
                        Positioned(
                          bottom: 5.w,
                          left: 11.w,
                          child: RecordTableTextStyle(
                            text: "구분",
                            title: false,
                          ),
                        ),
                        // Center(
                        //   child: RecordTableTextStyle(
                        //     text: "반이름" + "의 생활기록부",
                        //     title: false,
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                  CustomContainer(
                    cBorderColor: borderColor,
                    cTotalHeight: 40.w,
                    cTotalWidth: 172.w,
                    cInsideColor: Color(0xffffffff),
                    cTopBorderWidth: 1.w,
                    cLeftBorderWidth: 1.w,
                    cRightBorderWidth:
                        lifeData['classes'].length != 0 ? 0.w : 1.w,
                    childWidget: Center(
                      child: RecordTableTextStyle(
                        text: "수료/졸업대장번호",
                        title: false,
                      ),
                    ),
                  ),
                  CustomContainer(
                    cBorderColor: borderColor,
                    cTotalHeight: 40.w,
                    cTotalWidth: 172.w,
                    cInsideColor: Color(0xffffffff),
                    cTopBorderWidth: 1.w,
                    cLeftBorderWidth: 1.w,
                    cRightBorderWidth:
                        lifeData['classes'].length != 0 ? 0.w : 1.w,
                    childWidget: Center(
                      child: RecordTableTextStyle(
                        text: "반",
                        title: false,
                      ),
                    ),
                  ),
                  CustomContainer(
                    cBorderColor: borderColor,
                    cTotalHeight: 40.w,
                    cTotalWidth: 172.w,
                    cBorderRadius: lifeData['classes'].length != 0
                        ? BorderRadius.only(bottomLeft: Radius.circular(20.w))
                        : BorderRadius.only(
                            bottomLeft: Radius.circular(20.w),
                            bottomRight: Radius.circular(20.w)),
                    cInsideColor: Color(0xffffffff),
                    cTopBorderWidth: 1.w,
                    cLeftBorderWidth: 1.w,
                    cBottomBorderWidth: 1.w,
                    cRightBorderWidth:
                        lifeData['classes'].length != 0 ? 0.w : 1.w,
                    childWidget: Center(
                      child: RecordTableTextStyle(
                        text: "담임선생님 성명",
                        title: false,
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  for (int i = 0; i < lifeData['classes'].length; i++) ...[
                    CustomContainer(
                      cBorderColor: borderColor,
                      cTotalHeight: 40.w,
                      cTotalWidth: 100.w,
                      cInsideColor: Color(0xffCAACF2),
                      cTopBorderWidth: 1.w,
                      cLeftBorderWidth: 1.w,
                      cRightBorderWidth:
                          i == lifeData['classes'].length - 1 ? 1.w : 0,
                      cBorderRadius: i == lifeData['classes'].length - 1
                          ? BorderRadius.only(topRight: Radius.circular(20.w))
                          : BorderRadius.zero,
                      childWidget: Center(
                        child: RecordTableTextStyle(
                          text: '${lifeData['classes'][i]['age']}세',
                          title: false,
                        ),
                      ),
                    ),
                    CustomContainer(
                      cBorderColor: borderColor,
                      cTotalHeight: 40.w,
                      cTotalWidth: 100.w,
                      cInsideColor: Color(0xffffffff),
                      cTopBorderWidth: 1.w,
                      cLeftBorderWidth: 1.w,
                      cRightBorderWidth:
                          i == lifeData['classes'].length - 1 ? 1.w : 0,
                      childWidget: Center(
                        child:
                        LifeTextField(method: 'number', value:
                            lifeData['classes'][i]['number'] != null
                                ? '${lifeData['classes'][i]['number']}'
                                : '', modifyLife: patchLifeData,
                        )

                        // RecordTableTextStyle(
                        //   text: lifeData['classes'][i]['number'] != null
                        //       ? '${lifeData['classes'][i]['number']}'
                        //       : '',
                        //   title: false,
                        // ),
                      ),
                    ),
                    CustomContainer(
                      cBorderColor: borderColor,
                      cTotalHeight: 40.w,
                      cTotalWidth: 100.w,
                      cInsideColor: Color(0xffffffff),
                      cTopBorderWidth: 1.w,
                      cLeftBorderWidth: 1.w,
                      cRightBorderWidth:
                          i == lifeData['classes'].length - 1 ? 1.w : 0,
                      childWidget: Center(
                        child: RecordTableTextStyle(
                          text: '${lifeData['classes'][i]['class']}',
                          title: false,
                        ),
                      ),
                    ),
                    CustomContainer(
                      cBorderColor: borderColor,
                      cTotalHeight: 40.w,
                      cTotalWidth: 100.w,
                      cInsideColor: Color(0xffffffff),
                      cTopBorderWidth: 1.w,
                      cLeftBorderWidth: 1.w,
                      cBottomBorderWidth: 1.w,
                      cRightBorderWidth:
                          i == lifeData['classes'].length - 1 ? 1.w : 0,
                      cBorderRadius: i == lifeData['classes'].length - 1
                          ? BorderRadius.only(
                              bottomRight: Radius.circular(20.w))
                          : BorderRadius.zero,
                      childWidget: Center(
                        child: RecordTableTextStyle(
                          text: '${lifeData['classes'][i]['teacher']}',
                          title: false,
                        ),
                      ),
                    ),
                  ]
                ],
              ),
              Spacer(),
              Container(
                width: 121.w,
                height: 159.w,
                decoration: BoxDecoration(
                    border: Border.all(width: 1.w, color: Color(0xffD179F8))
                ),
                child: childImg ?? Container(),
              ),
            ]),
            SizedBox(
              height: 39.w,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RecordTableTextStyle(
                  text: '인적사항',
                  title: false,
                ),
                SizedBox(
                  height: 13.w,
                ),
                Row(
                  children: [
                    CustomContainer(
                      cBorderColor: borderColor,
                      cTotalHeight: 40.w,
                      cTotalWidth: 100.w,
                      cInsideColor: Color(0xffCAACF2),
                      cBorderRadius:
                          BorderRadius.only(topLeft: Radius.circular(20.w)),
                      cTopBorderWidth: 1.w,
                      cLeftBorderWidth: 1.w,
                      childWidget: Center(
                        child: RecordTableTextStyle(
                          text: '성명',
                          title: false,
                        ),
                      ),
                    ),
                    CustomContainer(
                      cBorderColor: borderColor,
                      cTotalHeight: 40.w,
                      cTotalWidth: 200.w,
                      cInsideColor: Color(0xffffffff),
                      cTopBorderWidth: 1.w,
                      cLeftBorderWidth: 1.w,
                      childWidget: Center(
                        child: RecordTableTextStyle(
                          text: lifeData['name'] ?? '',
                          title: false,
                        ),
                      ),
                    ),
                    CustomContainer(
                      cBorderColor: borderColor,
                      cTotalHeight: 40.w,
                      cTotalWidth: 100.w,
                      cInsideColor: Color(0xffCAACF2),
                      cTopBorderWidth: 1.w,
                      cLeftBorderWidth: 1.w,
                      childWidget: Center(
                        child: RecordTableTextStyle(
                          text: '성별',
                          title: false,
                        ),
                      ),
                    ),
                    CustomContainer(
                      cBorderColor: borderColor,
                      cTotalHeight: 40.w,
                      cTotalWidth: 200.w,
                      cInsideColor: Color(0xffffffff),
                      cTopBorderWidth: 1.w,
                      cLeftBorderWidth: 1.w,
                      childWidget: Center(
                        child: RecordTableTextStyle(
                          text: (lifeData['sex'] ?? "") == true ? '남' : '여',
                          title: false,
                        ),
                      ),
                    ),
                    CustomContainer(
                      cBorderColor: borderColor,
                      cTotalHeight: 40.w,
                      cTotalWidth: 100.w,
                      cInsideColor: Color(0xffCAACF2),
                      cTopBorderWidth: 1.w,
                      cLeftBorderWidth: 1.w,
                      childWidget: Center(
                        child: RecordTableTextStyle(
                          text: '생년월일',
                          title: false,
                        ),
                      ),
                    ),
                    CustomContainer(
                      cBorderColor: borderColor,
                      cTotalHeight: 40.w,
                      cTotalWidth: 353.w,
                      cInsideColor: Color(0xffffffff),
                      cBorderRadius:
                          BorderRadius.only(topRight: Radius.circular(20.w)),
                      cTopBorderWidth: 1.w,
                      cLeftBorderWidth: 1.w,
                      cRightBorderWidth: 1.w,
                      childWidget: Center(
                        child: RecordTableTextStyle(
                          text: lifeData['birthday'] ?? '',
                          title: false,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    CustomContainer(
                      cBorderColor: borderColor,
                      cTotalHeight: 80.w,
                      cTotalWidth: 100.w,
                      cInsideColor: Color(0xffCAACF2),
                      cTopBorderWidth: 1.w,
                      cLeftBorderWidth: 1.w,
                      childWidget: Center(
                        child: RecordTableTextStyle(
                          text: '주소',
                          title: false,
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        CustomContainer(
                          cBorderColor: borderColor,
                          cTotalHeight: 40.w,
                          cTotalWidth: 953.w,
                          cInsideColor: Color(0xffffffff),
                          cTopBorderWidth: 1.w,
                          cLeftBorderWidth: 1.w,
                          cRightBorderWidth: 1.w,
                          childWidget: Center(
                            child: LifeTextField(
                              method: 'address',
                              value: lifeData['address'] ?? '',
                              modifyLife: patchAddressData,
                            )
                            // RecordTableTextStyle(
                            //   text: lifeData['address'] ?? '',
                            //   title: false,
                            // ),
                          ),
                        ),
                        CustomContainer(
                          cBorderColor: borderColor,
                          cTotalHeight: 40.w,
                          cTotalWidth: 953.w,
                          cInsideColor: Color(0xffffffff),
                          cTopBorderWidth: 1.w,
                          cLeftBorderWidth: 1.w,
                          cRightBorderWidth: 1.w,
                          childWidget: Center(
                            child:
                            LifeTextField(
                              method: 'detailedAddress',
                              value: lifeData['detailedAddress'] ?? '',
                              modifyLife: patchAddressData,
                            )
                            // RecordTableTextStyle(
                            //   text: lifeData['detailedAddress'] ?? '',
                            //   title: false,
                            // ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    CustomContainer(
                      cBorderColor: borderColor,
                      cTotalHeight: 120.w,
                      cTotalWidth: 100.w,
                      cInsideColor: Color(0xffCAACF2),
                      cTopBorderWidth: 1.w,
                      cLeftBorderWidth: 1.w,
                      cBottomBorderWidth: 1.w,
                      cBorderRadius:
                          BorderRadius.only(bottomLeft: Radius.circular(20.w)),
                      childWidget: Center(
                        child: RecordTableTextStyle(
                          text: '가족\n사항',
                          title: false,
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        Row(
                          children: [
                            CustomContainer(
                              cBorderColor: borderColor,
                              cTotalHeight: 40.w,
                              cTotalWidth: 200.w,
                              cInsideColor: Color(0xffCAACF2),
                              cTopBorderWidth: 1.w,
                              cLeftBorderWidth: 1.w,
                              childWidget: Stack(
                                children: [
                                  CustomPaint(
                                    size: Size(200.w, 40.w),
                                    painter: MyPainter(
                                        lineStart: Offset(0.w, 0.w),
                                        lineEnd: Offset(200.w, 40.w)),
                                  ),
                                  Positioned(
                                    top: 5.w,
                                    right: 12.w,
                                    child: RecordTableTextStyle(
                                      text: "관계",
                                      title: false,
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 5.w,
                                    left: 9.w,
                                    child: RecordTableTextStyle(
                                      text: "구분",
                                      title: false,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            CustomContainer(
                              cBorderColor: borderColor,
                              cTotalHeight: 40.w,
                              cTotalWidth: 376.5.w,
                              cInsideColor: Color(0xffCAACF2),
                              cTopBorderWidth: 1.w,
                              cLeftBorderWidth: 1.w,
                              childWidget: Center(
                                child: RecordTableTextStyle(
                                  text: '부',
                                  title: false,
                                ),
                              ),
                            ),
                            CustomContainer(
                              cBorderColor: borderColor,
                              cTotalHeight: 40.w,
                              cTotalWidth: 376.5.w,
                              cInsideColor: Color(0xffCAACF2),
                              cTopBorderWidth: 1.w,
                              cLeftBorderWidth: 1.w,
                              cRightBorderWidth: 1.w,
                              childWidget: Center(
                                child: RecordTableTextStyle(
                                  text: '모',
                                  title: false,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            CustomContainer(
                              cBorderColor: borderColor,
                              cTotalHeight: 40.w,
                              cTotalWidth: 200.w,
                              cInsideColor: Color(0xffffffff),
                              cTopBorderWidth: 1.w,
                              cLeftBorderWidth: 1.w,
                              childWidget: Center(
                                child: RecordTableTextStyle(
                                  text: '성명',
                                  title: false,
                                ),
                              ),
                            ),
                            CustomContainer(
                              cBorderColor: borderColor,
                              cTotalHeight: 40.w,
                              cTotalWidth: 376.5.w,
                              cInsideColor: Color(0xffffffff),
                              cTopBorderWidth: 1.w,
                              cLeftBorderWidth: 1.w,
                              childWidget: Center(
                                child: RecordTableTextStyle(
                                  text: lifeData['parents'].indexWhere(
                                              (parents) =>
                                                  parents['relation'] == '부') !=
                                          -1
                                      ? lifeData['parents'][lifeData['parents']
                                              .indexWhere((parents) =>
                                                  parents['relation'] == '부')]
                                          ['name']
                                      : '',
                                  title: false,
                                ),
                              ),
                            ),
                            CustomContainer(
                              cBorderColor: borderColor,
                              cTotalHeight: 40.w,
                              cTotalWidth: 376.5.w,
                              cInsideColor: Color(0xffffffff),
                              cTopBorderWidth: 1.w,
                              cLeftBorderWidth: 1.w,
                              cRightBorderWidth: 1.w,
                              childWidget: Center(
                                child: RecordTableTextStyle(
                                  text: lifeData['parents'].indexWhere(
                                              (parents) =>
                                                  parents['relation'] == '모') !=
                                          -1
                                      ? lifeData['parents'][lifeData['parents']
                                              .indexWhere((parents) =>
                                                  parents['relation'] == '모')]
                                          ['name']
                                      : '',
                                  title: false,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            CustomContainer(
                              cBorderColor: borderColor,
                              cTotalHeight: 40.w,
                              cTotalWidth: 200.w,
                              cInsideColor: Color(0xffffffff),
                              cTopBorderWidth: 1.w,
                              cLeftBorderWidth: 1.w,
                              cBottomBorderWidth: 1.w,
                              childWidget: Center(
                                child: RecordTableTextStyle(
                                  text: '생년월일',
                                  title: false,
                                ),
                              ),
                            ),
                            CustomContainer(
                              cBorderColor: borderColor,
                              cTotalHeight: 40.w,
                              cTotalWidth: 376.5.w,
                              cInsideColor: Color(0xffffffff),
                              cTopBorderWidth: 1.w,
                              cLeftBorderWidth: 1.w,
                              cBottomBorderWidth: 1.w,
                              childWidget: Center(
                                child: RecordTableTextStyle(
                                  text: lifeData['parents'].indexWhere(
                                              (parents) =>
                                                  parents['relation'] == '부') !=
                                          -1
                                      ? lifeData['parents'][lifeData['parents']
                                              .indexWhere((parents) =>
                                                  parents['relation'] ==
                                                  '부')]['birthday'] ??
                                          ''
                                      : '',
                                  title: false,
                                ),
                              ),
                            ),
                            CustomContainer(
                              cBorderColor: borderColor,
                              cTotalHeight: 40.w,
                              cTotalWidth: 376.5.w,
                              cInsideColor: Color(0xffffffff),
                              cBorderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(20.w)),
                              cTopBorderWidth: 1.w,
                              cLeftBorderWidth: 1.w,
                              cRightBorderWidth: 1.w,
                              cBottomBorderWidth: 1.w,
                              childWidget: Center(
                                child: RecordTableTextStyle(
                                  text: lifeData['parents'].indexWhere(
                                              (parents) =>
                                                  parents['relation'] == '모') !=
                                          -1
                                      ? lifeData['parents'][lifeData['parents']
                                              .indexWhere((parents) =>
                                                  parents['relation'] ==
                                                  '모')]['birthday'] ??
                                          ''
                                      : '',
                                  title: false,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 39.w,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RecordTableTextStyle(
                  text: '학적사항',
                  title: false,
                ),
                SizedBox(
                  height: 13.w,
                ),
                Row(
                  children: [
                    CustomContainer(
                      cBorderColor: borderColor,
                      cTotalHeight: 40.w,
                      cTotalWidth: 200.w,
                      cInsideColor: Color(0xffCAACF2),
                      cBorderRadius:
                          BorderRadius.only(topLeft: Radius.circular(20.w)),
                      cTopBorderWidth: 1.w,
                      cLeftBorderWidth: 1.w,
                      childWidget: Stack(
                        children: [
                          CustomPaint(
                            size: Size(200.w, 40.w),
                            painter: MyPainter(
                                lineStart: Offset(10.w, 2.w),
                                lineEnd: Offset(200.w, 40.w)),
                          ),
                          Positioned(
                            top: 5.w,
                            right: 12.w,
                            child: RecordTableTextStyle(
                              text: "구분",
                              title: false,
                            ),
                          ),
                          Positioned(
                            bottom: 5.w,
                            left: 9.w,
                            child: RecordTableTextStyle(
                              text: "날짜",
                              title: false,
                            ),
                          ),
                        ],
                      ),
                    ),
                    CustomContainer(
                      cBorderColor: borderColor,
                      cTotalHeight: 40.w,
                      cTotalWidth: 653.w,
                      cInsideColor: Color(0xffCAACF2),
                      cTopBorderWidth: 1.w,
                      cLeftBorderWidth: 1.w,
                      childWidget: Center(
                        child: RecordTableTextStyle(
                          text: '내용',
                          title: false,
                        ),
                      ),
                    ),
                    CustomContainer(
                      cBorderColor: borderColor,
                      cTotalHeight: 40.w,
                      cTotalWidth: 200.w,
                      cInsideColor: Color(0xffCAACF2),
                      cBorderRadius:
                          BorderRadius.only(topRight: Radius.circular(20.w)),
                      cTopBorderWidth: 1.w,
                      cLeftBorderWidth: 1.w,
                      cRightBorderWidth: 1.w,
                      childWidget: Center(
                        child: RecordTableTextStyle(
                          text: '특기사항',
                          title: false,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    CustomContainer(
                      cBorderColor: borderColor,
                      cTotalHeight: 40.w,
                      cTotalWidth: 200.w,
                      cInsideColor: Color(0xffffffff),
                      cTopBorderWidth: 1.w,
                      cLeftBorderWidth: 1.w,
                      cBottomBorderWidth: 1.w,
                      cBorderRadius:
                          BorderRadius.only(bottomLeft: Radius.circular(20.w)),
                      childWidget: Center(
                        child: RecordTableTextStyle(
                          text: '',
                          title: false,
                        ),
                      ),
                    ),
                    CustomContainer(
                      cBorderColor: borderColor,
                      cTotalHeight: 40.w,
                      cTotalWidth: 653.w,
                      cInsideColor: Color(0xffffffff),
                      cTopBorderWidth: 1.w,
                      cLeftBorderWidth: 1.w,
                      cBottomBorderWidth: 1.w,
                      childWidget: Center(
                        child: RecordTableTextStyle(
                          text: '',
                          title: false,
                        ),
                      ),
                    ),
                    CustomContainer(
                      cBorderColor: borderColor,
                      cTotalHeight: 40.w,
                      cTotalWidth: 200.w,
                      cInsideColor: Color(0xffffffff),
                      cBorderRadius:
                          BorderRadius.only(bottomRight: Radius.circular(20.w)),
                      cTopBorderWidth: 1.w,
                      cLeftBorderWidth: 1.w,
                      cRightBorderWidth: 1.w,
                      cBottomBorderWidth: 1.w,
                      childWidget: Center(
                        child: RecordTableTextStyle(
                          text: '',
                          title: false,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 39.w,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RecordTableTextStyle(
                  text: '출결사항',
                  title: false,
                ),
                SizedBox(
                  height: 13.w,
                ),
                Row(
                  children: [
                    CustomContainer(
                      cBorderColor: borderColor,
                      cTotalHeight: 40.w,
                      cTotalWidth: 200.w,
                      cInsideColor: Color(0xffCAACF2),
                      cBorderRadius: lifeData['attendanceStatus'].length == 0
                          ? BorderRadius.only(
                              topLeft: Radius.circular(20.w),
                              bottomLeft: Radius.circular(20.w))
                          : BorderRadius.only(topLeft: Radius.circular(20.w)),
                      cTopBorderWidth: 1.w,
                      cLeftBorderWidth: 1.w,
                      cBottomBorderWidth:
                          lifeData['attendanceStatus'].length == 0 ? 1.w : 0,
                      childWidget: Stack(
                        children: [
                          CustomPaint(
                            size: Size(200.w, 40.w),
                            painter: MyPainter(
                                lineStart: Offset(10.w, 2.w),
                                lineEnd: Offset(199.w, 38.w)),
                          ),
                          Positioned(
                            top: 5.w,
                            right: 12.w,
                            child: RecordTableTextStyle(
                              text: "구분",
                              title: false,
                            ),
                          ),
                          Positioned(
                            bottom: 5.w,
                            left: 9.w,
                            child: RecordTableTextStyle(
                              text: "연령",
                              title: false,
                            ),
                          ),
                        ],
                      ),
                    ),
                    CustomContainer(
                      cBorderColor: borderColor,
                      cTotalHeight: 40.w,
                      cTotalWidth: 213.w,
                      cInsideColor: Color(0xffCAACF2),
                      cTopBorderWidth: 1.w,
                      cLeftBorderWidth: 1.w,
                      cBottomBorderWidth:
                          lifeData['attendanceStatus'].length == 0 ? 1.w : 0,
                      childWidget: Center(
                        child: RecordTableTextStyle(
                          text: '수업일수',
                          title: false,
                        ),
                      ),
                    ),
                    CustomContainer(
                      cBorderColor: borderColor,
                      cTotalHeight: 40.w,
                      cTotalWidth: 213.w,
                      cInsideColor: Color(0xffCAACF2),
                      cTopBorderWidth: 1.w,
                      cLeftBorderWidth: 1.w,
                      cBottomBorderWidth:
                          lifeData['attendanceStatus'].length == 0 ? 1.w : 0,
                      childWidget: Center(
                        child: RecordTableTextStyle(
                          text: '출석일수',
                          title: false,
                        ),
                      ),
                    ),
                    CustomContainer(
                      cBorderColor: borderColor,
                      cTotalHeight: 40.w,
                      cTotalWidth: 213.w,
                      cInsideColor: Color(0xffCAACF2),
                      cTopBorderWidth: 1.w,
                      cLeftBorderWidth: 1.w,
                      cBottomBorderWidth:
                          lifeData['attendanceStatus'].length == 0 ? 1.w : 0,
                      childWidget: Center(
                        child: RecordTableTextStyle(
                          text: '결석일수',
                          title: false,
                        ),
                      ),
                    ),
                    CustomContainer(
                      cBorderColor: borderColor,
                      cTotalHeight: 40.w,
                      cTotalWidth: 214.w,
                      cInsideColor: Color(0xffCAACF2),
                      cBorderRadius: lifeData['attendanceStatus'].length == 0
                          ? BorderRadius.only(
                              topRight: Radius.circular(20.w),
                              bottomRight: Radius.circular(20.w))
                          : BorderRadius.only(topRight: Radius.circular(20.w)),
                      cTopBorderWidth: 1.w,
                      cLeftBorderWidth: 1.w,
                      cRightBorderWidth: 1.w,
                      cBottomBorderWidth:
                          lifeData['attendanceStatus'].length == 0 ? 1.w : 0,
                      childWidget: Center(
                        child: RecordTableTextStyle(
                          text: '특기사항',
                          title: false,
                        ),
                      ),
                    ),
                  ],
                ),
                for (int i = 0;
                    i < lifeData['attendanceStatus'].length;
                    i++) ...[
                  Row(
                    children: [
                      CustomContainer(
                        cBorderColor: borderColor,
                        cTotalHeight: 40.w,
                        cTotalWidth: 200.w,
                        cInsideColor: Color(0xffffffff),
                        cTopBorderWidth: 1.w,
                        cLeftBorderWidth: 1.w,
                        cBottomBorderWidth:
                            lifeData['attendanceStatus'].length - 1 == i
                                ? 1.w
                                : 0,
                        cBorderRadius:
                            lifeData['attendanceStatus'].length - 1 == i
                                ? BorderRadius.only(
                                    bottomLeft: Radius.circular(20.w))
                                : BorderRadius.zero,
                        childWidget: Center(
                          child: RecordTableTextStyle(
                            text: '${lifeData['attendanceStatus'][i]['age']}세',
                            title: false,
                          ),
                        ),
                      ),
                      CustomContainer(
                        cBorderColor: borderColor,
                        cTotalHeight: 40.w,
                        cTotalWidth: 213.w,
                        cInsideColor: Color(0xffffffff),
                        cTopBorderWidth: 1.w,
                        cLeftBorderWidth: 1.w,
                        cBottomBorderWidth:
                            lifeData['attendanceStatus'].length - 1 == i
                                ? 1.w
                                : 0,
                        childWidget: Center(
                          child: RecordTableTextStyle(
                            text: lifeData['attendanceStatus'][i]['classDays']
                                .toString(),
                            title: false,
                          ),
                        ),
                      ),
                      CustomContainer(
                        cBorderColor: borderColor,
                        cTotalHeight: 40.w,
                        cTotalWidth: 213.w,
                        cInsideColor: Color(0xffffffff),
                        cTopBorderWidth: 1.w,
                        cLeftBorderWidth: 1.w,
                        cBottomBorderWidth:
                            lifeData['attendanceStatus'].length - 1 == i
                                ? 1.w
                                : 0,
                        childWidget: Center(
                          child: RecordTableTextStyle(
                            text: lifeData['attendanceStatus'][i]
                                    ['attendanceDays']
                                .toString(),
                            title: false,
                          ),
                        ),
                      ),
                      CustomContainer(
                        cBorderColor: borderColor,
                        cTotalHeight: 40.w,
                        cTotalWidth: 213.w,
                        cInsideColor: Color(0xffffffff),
                        cTopBorderWidth: 1.w,
                        cLeftBorderWidth: 1.w,
                        cBottomBorderWidth:
                            lifeData['attendanceStatus'].length - 1 == i
                                ? 1.w
                                : 0,
                        childWidget: Center(
                          child: RecordTableTextStyle(
                            text: lifeData['attendanceStatus'][i]['absentDays']
                                .toString(),
                            title: false,
                          ),
                        ),
                      ),
                      CustomContainer(
                        cBorderColor: borderColor,
                        cTotalHeight: 40.w,
                        cTotalWidth: 214.w,
                        cInsideColor: Color(0xffffffff),
                        cBorderRadius:
                            lifeData['attendanceStatus'].length - 1 == i
                                ? BorderRadius.only(
                                    bottomRight: Radius.circular(20.w))
                                : BorderRadius.zero,
                        cTopBorderWidth: 1.w,
                        cLeftBorderWidth: 1.w,
                        cRightBorderWidth: 1.w,
                        cBottomBorderWidth:
                            lifeData['attendanceStatus'].length - 1 == i
                                ? 1.w
                                : 0,
                        childWidget: Center(
                         child: LifeTextField(method: 'attendanceComment',
                           value: lifeData['attendanceStatus'][i]['comment'] ?? '', modifyLife: patchLifeData,),
                        ),
                      ),
                    ],
                  ),
                ]
              ],
            ),
            SizedBox(
              height: 39.w,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RecordTableTextStyle(
                  text: '신체발달상황',
                  title: false,
                ),
                SizedBox(
                  height: 13.w,
                ),
                Row(
                  children: [
                    CustomContainer(
                      cBorderColor: borderColor,
                      cTotalHeight: 40.w,
                      cTotalWidth: 200.w,
                      cInsideColor: Color(0xffCAACF2),
                      cBorderRadius: lifeData['physicalStatus'].length == 0
                          ? BorderRadius.only(
                              topLeft: Radius.circular(20.w),
                              bottomLeft: Radius.circular(20.w))
                          : BorderRadius.only(
                              topLeft: Radius.circular(20.w),
                            ),
                      cTopBorderWidth: 1.w,
                      cLeftBorderWidth: 1.w,
                      cBottomBorderWidth:
                          lifeData['physicalStatus'].length == 0 ? 1.w : 0,
                      childWidget: Stack(
                        children: [
                          CustomPaint(
                            size: Size(200.w, 40.w),
                            painter: MyPainter(
                                lineStart: Offset(10.w, 2.w),
                                lineEnd: Offset(199.w, 38.w)),
                          ),
                          Positioned(
                            top: 5.w,
                            right: 12.w,
                            child: RecordTableTextStyle(
                              text: "연령",
                              title: false,
                            ),
                          ),
                          Positioned(
                            bottom: 5.w,
                            left: 9.w,
                            child: RecordTableTextStyle(
                              text: "구분",
                              title: false,
                            ),
                          ),
                        ],
                      ),
                    ),
                    CustomContainer(
                      cBorderColor: borderColor,
                      cTotalHeight: 40.w,
                      cTotalWidth: 284.w,
                      cInsideColor: Color(0xffCAACF2),
                      cTopBorderWidth: 1.w,
                      cLeftBorderWidth: 1.w,
                      cBottomBorderWidth:
                          lifeData['physicalStatus'].length == 0 ? 1.w : 0,
                      childWidget: Center(
                        child: RecordTableTextStyle(
                          text: '검사일',
                          title: false,
                        ),
                      ),
                    ),
                    CustomContainer(
                      cBorderColor: borderColor,
                      cTotalHeight: 40.w,
                      cTotalWidth: 284.w,
                      cInsideColor: Color(0xffCAACF2),
                      cTopBorderWidth: 1.w,
                      cLeftBorderWidth: 1.w,
                      cBottomBorderWidth:
                          lifeData['physicalStatus'].length == 0 ? 1.w : 0,
                      childWidget: Center(
                        child: RecordTableTextStyle(
                          text: '키(cm)',
                          title: false,
                        ),
                      ),
                    ),
                    CustomContainer(
                      cBorderColor: borderColor,
                      cTotalHeight: 40.w,
                      cTotalWidth: 285.w,
                      cInsideColor: Color(0xffCAACF2),
                      cBorderRadius: lifeData['physicalStatus'].length == 0
                          ? BorderRadius.only(
                              topRight: Radius.circular(20.w),
                              bottomRight: Radius.circular(20.w))
                          : BorderRadius.only(topRight: Radius.circular(20.w)),
                      cTopBorderWidth: 1.w,
                      cLeftBorderWidth: 1.w,
                      cRightBorderWidth: 1.w,
                      cBottomBorderWidth:
                          lifeData['physicalStatus'].length == 0 ? 1.w : 0,
                      childWidget: Center(
                        child: RecordTableTextStyle(
                          text: '몸무게(kg)',
                          title: false,
                        ),
                      ),
                    ),
                  ],
                ),

                for (int i = 0; i < lifeData["physicalStatus"].length; i++) ...[
                  Row(
                    children: [
                      CustomContainer(
                        cBorderColor: borderColor,
                        cTotalHeight: 40.w,
                        cTotalWidth: 200.w,
                        cInsideColor: Color(0xffffffff),
                        cTopBorderWidth: 1.w,
                        cLeftBorderWidth: 1.w,
                        cBottomBorderWidth:
                            lifeData["physicalStatus"].length - 1 == i
                                ? 1.w
                                : 0,
                        cBorderRadius:
                            lifeData["physicalStatus"].length - 1 == i
                                ? BorderRadius.only(
                                    bottomLeft: Radius.circular(20.w))
                                : BorderRadius.zero,
                        childWidget: Center(
                          child: RecordTableTextStyle(
                            text: '${lifeData["physicalStatus"][i]['age']}세',
                            title: false,
                          ),
                        ),
                      ),
                      CustomContainer(
                        cBorderColor: borderColor,
                        cTotalHeight: 40.w,
                        cTotalWidth: 284.w,
                        cInsideColor: Color(0xffffffff),
                        cTopBorderWidth: 1.w,
                        cLeftBorderWidth: 1.w,
                        cBottomBorderWidth:
                            lifeData["physicalStatus"].length - 1 == i
                                ? 1.w
                                : 0,
                        childWidget: Center(
                          child: RecordTableTextStyle(
                            text: lifeData["physicalStatus"][i]['date'] ?? '',
                            title: false,
                          ),
                        ),
                      ),
                      CustomContainer(
                        cBorderColor: borderColor,
                        cTotalHeight: 40.w,
                        cTotalWidth: 284.w,
                        cInsideColor: Color(0xffffffff),
                        cTopBorderWidth: 1.w,
                        cLeftBorderWidth: 1.w,
                        cBottomBorderWidth:
                            lifeData["physicalStatus"].length - 1 == i
                                ? 1.w
                                : 0,
                        childWidget: Center(
                          child: RecordTableTextStyle(
                            text: lifeData["physicalStatus"][i]['height'] ==
                                    null
                                ? ''
                                : "${lifeData["physicalStatus"][i]['height']}cm",
                            title: false,
                          ),
                        ),
                      ),
                      CustomContainer(
                        cBorderColor: borderColor,
                        cTotalHeight: 40.w,
                        cTotalWidth: 285.w,
                        cInsideColor: Color(0xffffffff),
                        cBorderRadius:
                            lifeData["physicalStatus"].length - 1 == i
                                ? BorderRadius.only(
                                    bottomRight: Radius.circular(20.w))
                                : BorderRadius.zero,
                        cTopBorderWidth: 1.w,
                        cLeftBorderWidth: 1.w,
                        cRightBorderWidth: 1.w,
                        cBottomBorderWidth:
                            lifeData["physicalStatus"].length - 1 == i
                                ? 1.w
                                : 0,
                        childWidget: Center(
                          child: RecordTableTextStyle(
                            text: lifeData["physicalStatus"][i]['weight'] ==
                                    null
                                ? ''
                                : "${lifeData["physicalStatus"][i]['weight']}kg",
                            title: false,
                          ),
                        ),
                      ),
                    ],
                  ),
                ]
              ],
            ),
            SizedBox(
              height: 39.w,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RecordTableTextStyle(
                  text: '건강검진',
                  title: false,
                ),
                SizedBox(
                  height: 13.w,
                ),
                Row(
                  children: [
                    CustomContainer(
                      cBorderColor: borderColor,
                      cTotalHeight: 40.w,
                      cTotalWidth: 200.w,
                      cInsideColor: Color(0xffCAACF2),
                      cBorderRadius:
                      // lifeData['medicalStatus'].length == 0
                      //     ? BorderRadius.only(
                      //     topLeft: Radius.circular(20.w),
                      //     bottomLeft: Radius.circular(20.w)):
                      BorderRadius.only(
                        topLeft: Radius.circular(20.w),
                      ),
                      cTopBorderWidth: 1.w,
                      cLeftBorderWidth: 1.w,
                      cBottomBorderWidth:
                      lifeData['medicalStatus'].length == 0 ? 1.w : 0,
                      childWidget: Stack(
                        children: [
                          CustomPaint(
                            size: Size(200.w, 40.w),
                            painter: MyPainter(
                                lineStart: Offset(10.w, 2.w),
                                lineEnd: Offset(199.w, 38.w)),
                          ),
                          Positioned(
                            top: 5.w,
                            right: 12.w,
                            child: RecordTableTextStyle(
                              text: "구분",
                              title: false,
                            ),
                          ),
                          Positioned(
                            bottom: 5.w,
                            left: 9.w,
                            child: RecordTableTextStyle(
                              text: "연령",
                              title: false,
                            ),
                          ),
                        ],
                      ),
                    ),
                    CustomContainer(
                      cBorderColor: borderColor,
                      cTotalHeight: 40.w,
                      cTotalWidth: 284.w,
                      cInsideColor: Color(0xffCAACF2),
                      cTopBorderWidth: 1.w,
                      cLeftBorderWidth: 1.w,
                      cBottomBorderWidth:
                      lifeData['medicalStatus'].length == 0 ? 1.w : 0,
                      childWidget: Center(
                        child: RecordTableTextStyle(
                          text: '검진일',
                          title: false,
                        ),
                      ),
                    ),
                    CustomContainer(
                      cBorderColor: borderColor,
                      cTotalHeight: 40.w,
                      cTotalWidth: 284.w,
                      cInsideColor: Color(0xffCAACF2),
                      cTopBorderWidth: 1.w,
                      cLeftBorderWidth: 1.w,
                      cBottomBorderWidth:
                      lifeData['medicalStatus'].length == 0 ? 1.w : 0,
                      childWidget: Center(
                        child: RecordTableTextStyle(
                          text: '검진기관',
                          title: false,
                        ),
                      ),
                    ),
                    CustomContainer(
                      cBorderColor: borderColor,
                      cTotalHeight: 40.w,
                      cTotalWidth: 285.w,
                      cInsideColor: Color(0xffCAACF2),
                      cBorderRadius:
                      // lifeData['medicalStatus'].length == 0
                      //     ? BorderRadius.only(
                      //     topRight: Radius.circular(20.w),
                      //     bottomRight: Radius.circular(20.w)):
                      BorderRadius.only(topRight: Radius.circular(20.w)),
                      cTopBorderWidth: 1.w,
                      cLeftBorderWidth: 1.w,
                      cRightBorderWidth: 1.w,
                      cBottomBorderWidth:
                      lifeData['medicalStatus'].length == 0 ? 1.w : 0,
                      childWidget: Center(
                        child: RecordTableTextStyle(
                          text: '특기사항',
                          title: false,
                        ),
                      ),
                    ),
                  ],
                ),

                for (int i = 0; i < lifeData["medicalStatus"].length; i++) ...[
                  Row(
                    children: [
                      CustomContainer(
                        cBorderColor: borderColor,
                        cTotalHeight: 40.w,
                        cTotalWidth: 200.w,
                        cInsideColor: Color(0xffffffff),
                        cTopBorderWidth: 1.w,
                        cLeftBorderWidth: 1.w,
                        cBottomBorderWidth:
                        lifeData["medicalStatus"].length - 1 == i
                            ? 1.w
                            : 0,
                        cBorderRadius:
                        lifeData["medicalStatus"].length - 1 == i
                            ? BorderRadius.only(
                            bottomLeft: Radius.circular(20.w))
                            : BorderRadius.zero,
                        childWidget: Center(
                          child: RecordTableTextStyle(
                            text: '${lifeData["medicalStatus"][i]['age']}세',
                            title: false,
                          ),
                        ),
                      ),
                      CustomContainer(
                        cBorderColor: borderColor,
                        cTotalHeight: 40.w,
                        cTotalWidth: 284.w,
                        cInsideColor: Color(0xffffffff),
                        cTopBorderWidth: 1.w,
                        cLeftBorderWidth: 1.w,
                        cBottomBorderWidth:
                        lifeData["medicalStatus"].length - 1 == i
                            ? 1.w
                            : 0,
                        childWidget: Center(
                          child: RecordTableTextStyle(
                            text: lifeData["medicalStatus"][i]['date'] ?? '',
                            title: false,
                          ),
                        ),
                      ),
                      CustomContainer(
                        cBorderColor: borderColor,
                        cTotalHeight: 40.w,
                        cTotalWidth: 284.w,
                        cInsideColor: Color(0xffffffff),
                        cTopBorderWidth: 1.w,
                        cLeftBorderWidth: 1.w,
                        cBottomBorderWidth:
                        lifeData["medicalStatus"].length - 1 == i
                            ? 1.w
                            : 0,
                        childWidget: Center(
                          child: RecordTableTextStyle(
                            text: lifeData["medicalStatus"][i]['hospital'] ==
                                null
                                ? ''
                                : "${lifeData["medicalStatus"][i]['hospital']}",
                            title: false,
                          ),
                        ),
                      ),
                      CustomContainer(
                        cBorderColor: borderColor,
                        cTotalHeight: 40.w,
                        cTotalWidth: 285.w,
                        cInsideColor: Color(0xffffffff),
                        cBorderRadius:
                        lifeData["medicalStatus"].length - 1 == i
                            ? BorderRadius.only(
                            bottomRight: Radius.circular(20.w))
                            : BorderRadius.zero,
                        cTopBorderWidth: 1.w,
                        cLeftBorderWidth: 1.w,
                        cRightBorderWidth: 1.w,
                        cBottomBorderWidth:
                        lifeData["medicalStatus"].length - 1 == i
                            ? 1.w
                            : 0,
                        childWidget: Center(
                          child: RecordTableTextStyle(
                            text: lifeData["medicalStatus"][i]['comment'] ==
                                null
                                ? ''
                                : "${lifeData["medicalStatus"][i]['comment']}",
                            title: false,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
                Row(
                  children: [
                    CustomContainer(
                      cBorderColor: borderColor,
                      cTotalHeight: 40.w,
                      cTotalWidth: 200.w,
                      cInsideColor: Color(0xffffffff),
                      cTopBorderWidth: 1.w,
                      cLeftBorderWidth: 1.w,
                      cBottomBorderWidth: 1.w,
                      cBorderRadius:
                      BorderRadius.only(bottomLeft: Radius.circular(20.w)),
                      childWidget: Center(
                        child: RecordTableTextStyle(
                          text: '',
                          title: false,
                        ),
                      ),
                    ),
                    CustomContainer(
                      cBorderColor: borderColor,
                      cTotalHeight: 40.w,
                      cTotalWidth: 284.w,
                      cInsideColor: Color(0xffffffff),
                      cTopBorderWidth: 1.w,
                      cLeftBorderWidth: 1.w,
                      cBottomBorderWidth: 1.w,
                      childWidget: Center(
                        child: RecordTableTextStyle(
                          text: '',
                          title: false,
                        ),
                      ),
                    ),
                    CustomContainer(
                      cBorderColor: borderColor,
                      cTotalHeight: 40.w,
                      cTotalWidth: 284.w,
                      cInsideColor: Color(0xffffffff),
                      cTopBorderWidth: 1.w,
                      cLeftBorderWidth: 1.w,
                      cBottomBorderWidth: 1.w,
                      childWidget: Center(
                        child: RecordTableTextStyle(
                          text: '',
                          title: false,
                        ),
                      ),
                    ),
                    CustomContainer(
                      cBorderColor: borderColor,
                      cTotalHeight: 40.w,
                      cTotalWidth: 285.w,
                      cInsideColor: Color(0xffffffff),
                      cBorderRadius:
                      BorderRadius.only(bottomRight: Radius.circular(20.w)),
                      cTopBorderWidth: 1.w,
                      cLeftBorderWidth: 1.w,
                      cRightBorderWidth: 1.w,
                      cBottomBorderWidth: 1.w,
                      childWidget: Center(
                        child: RecordTableTextStyle(
                          text: '',
                          title: false,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 39.w,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RecordTableTextStyle(
                  text: '유아발달상황',
                  title: false,
                ),
                SizedBox(
                  height: 13.w,
                ),
                Row(
                  children: [
                    CustomContainer(
                      cBorderColor: borderColor,
                      cTotalHeight: 40.w,
                      cTotalWidth: 200.w,
                      cInsideColor: Color(0xffCAACF2),
                      cBorderRadius: lifeData['nuriStatus'].length == 0
                          ? BorderRadius.only(
                              topLeft: Radius.circular(20.w),
                              bottomLeft: Radius.circular(20.w))
                          : BorderRadius.only(topLeft: Radius.circular(20.w)),
                      cTopBorderWidth: 1.w,
                      cLeftBorderWidth: 1.w,
                      cBottomBorderWidth:
                          lifeData['nuriStatus'].length == 0 ? 1.w : 0,
                      childWidget: Center(
                        child: RecordTableTextStyle(
                          text: '연령',
                          title: false,
                        ),
                      ),
                    ),
                    CustomContainer(
                      cBorderColor: borderColor,
                      cTotalHeight: 40.w,
                      cTotalWidth: 213.w,
                      cInsideColor: Color(0xffCAACF2),
                      cTopBorderWidth: 1.w,
                      cLeftBorderWidth: 1.w,
                      cBottomBorderWidth:
                      lifeData['nuriStatus'].length == 0 ? 1.w : 0,
                      childWidget: Center(
                        child: RecordTableTextStyle(
                          text: '영역',
                          title: false,
                        ),
                      ),
                    ),
                    CustomContainer(
                      cBorderColor: borderColor,
                      cTotalHeight: 40.w,
                      cTotalWidth: 640.w,
                      cInsideColor: Color(0xffCAACF2),
                      cBorderRadius: lifeData['nuriStatus'].length == 0
                          ? BorderRadius.only(
                              topRight: Radius.circular(20.w),
                              bottomRight: Radius.circular(20.w))
                          : BorderRadius.only(topRight: Radius.circular(20.w)),
                      cTopBorderWidth: 1.w,
                      cLeftBorderWidth: 1.w,
                      cRightBorderWidth: 1.w,
                      cBottomBorderWidth:
                          lifeData['nuriStatus'].length == 0 ? 1.w : 0,
                      childWidget: Center(
                        child: RecordTableTextStyle(
                          text: '발달상황',
                          title: false,
                        ),
                      ),
                    ),
                  ],
                ),
                for (int i = 0; i < lifeData['nuriStatus'].length; i++) ...[
                  Row(
                    children: [
                      CustomContainer(
                        cBorderColor: borderColor,
                        cTotalHeight: nuriHeight[i].w,
                        cTotalWidth: 200.w,
                        cInsideColor: Color(0xffffffff),
                        cTopBorderWidth: 1.w,
                        cLeftBorderWidth: 1.w,
                        cBottomBorderWidth:
                            lifeData['nuriStatus'].length - 1 == i ? 1.w : 0,
                        cBorderRadius: lifeData['nuriStatus'].length - 1 == i
                            ? BorderRadius.only(
                                bottomLeft: Radius.circular(20.w))
                            : BorderRadius.zero,
                        childWidget: Center(
                          child: RecordTableTextStyle(
                            text: '${lifeData['nuriStatus'][i]['age']}세',
                            title: false,
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          for(int j = 0; j< lifeData['nuriStatus'][i]['comments'].length;j++)...[
                            CustomContainer(
                              cBorderColor: borderColor,
                              cTotalHeight: (40 + 23 * lineCounter(lifeData['nuriStatus'][i]['comments'][j]['comment'])).w,
                              cTotalWidth: 213.w,
                              cInsideColor: Color(0xffffffff),
                              cTopBorderWidth: 1.w,
                              cLeftBorderWidth: 1.w,
                              cBottomBorderWidth: lifeData['nuriStatus'].length - 1 == i &&
                              lifeData['nuriStatus'][i]['comments'].length - 1 == j ? 1.w : 0,
                              childWidget: Center(
                                child: RecordTableTextStyle(
                                  text: nuri.area[lifeData['nuriStatus'][i]['age']][lifeData['nuriStatus'][i]['comments'][j]['category'] - 1],
                                  title: false,
                                ),
                              ),
                            ),
                          ]
                        ],
                      ),
                      Column(
                        children: [
                          for(int j = 0; j< lifeData['nuriStatus'][i]['comments'].length;j++)...[
                            CustomContainer(
                              cBorderColor: borderColor,
                              cTotalHeight: (40 + 23 * lineCounter(lifeData['nuriStatus'][i]['comments'][j]['comment'])).w,
                              cTotalWidth: 640.w,
                                cBorderRadius: lifeData['nuriStatus'].length - 1 == i && lifeData['nuriStatus'][i]['comments'].length -1 == j
                                    ? BorderRadius.only(
                                        bottomRight: Radius.circular(20.w))
                                    : BorderRadius.zero,
                              cInsideColor: Color(0xffffffff),
                              cTopBorderWidth: 1.w,
                              cLeftBorderWidth: 1.w,
                              cRightBorderWidth: 1.w,
                              cBottomBorderWidth: lifeData['nuriStatus'].length - 1 == i &&
                              lifeData['nuriStatus'][i]['comments'].length - 1 == j ? 1.w : 0,
                              childWidget: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  RecordTableTextStyle(
                                    text: lifeData['nuriStatus'][i]['comments'][j]['comment'],
                                    title: false,
                                    maxLine: lineCounter(lifeData['nuriStatus'][i]['comments'][j]['comment']) + 1,
                                    textAlign: TextAlign.start,
                                  ),
                                ],
                              ),
                            ),
                          ]
                          // for(int j = 0;j<)
                          // CustomContainer(
                          //   cBorderColor: borderColor,
                          //   cTotalHeight: 300.w,
                          //   cTotalWidth: 640.w,
                          //   cInsideColor: Color(0xffffffff),
                          //   cBorderRadius: lifeData['nuriStatus'].length - 1 == i
                          //       ? BorderRadius.only(
                          //           bottomRight: Radius.circular(20.w))
                          //       : BorderRadius.zero,
                          //   cTopBorderWidth: 1.w,
                          //   cLeftBorderWidth: 1.w,
                          //   cRightBorderWidth: 1.w,
                          //   cBottomBorderWidth:
                          //       lifeData['nuriStatus'].length - 1 == i ? 1.w : 0,
                          //   childWidget: Text(
                          //     lifeData['nuriStatus'][i]['comment']??'',
                          //     textAlign: TextAlign.start,
                          //     style: TextStyle(
                          //     fontSize: 14.sp,
                          //     fontWeight: FontWeight.w400,
                          //     color: const Color(0xff393838)),
                          //   ),
                          // ),
                        ],
                      ),
                    ],
                  ),
                ],
                // Row(
                //   children: [
                //     CustomContainer(
                //       cBorderColor: borderColor,
                //       cTotalHeight: 300.w,
                //       cTotalWidth: 200.w,
                //       cInsideColor: Color(0xffffffff),
                //       cTopBorderWidth: 1.w,
                //       cLeftBorderWidth: 1.w,
                //       childWidget: Center(
                //         child: RecordTableTextStyle(
                //           text: '유아 연령',
                //           title: false,
                //         ),
                //       ),
                //     ),
                //     CustomContainer(
                //       cBorderColor: borderColor,
                //       cTotalHeight: 300.w,
                //       cTotalWidth: 853.w,
                //       cInsideColor: Color(0xffffffff),
                //       cTopBorderWidth: 1.w,
                //       cLeftBorderWidth: 1.w,
                //       cRightBorderWidth: 1.w,
                //       childWidget: Center(
                //         child: RecordTableTextStyle(
                //           text: '해당 연령 발당상황',
                //           title: false,
                //         ),
                //       ),
                //     ),
                //   ],
                // ),
                // Row(
                //   children: [
                //     CustomContainer(
                //       cBorderColor: borderColor,
                //       cTotalHeight: 300.w,
                //       cTotalWidth: 200.w,
                //       cInsideColor: Color(0xffffffff),
                //       cTopBorderWidth: 1.w,
                //       cLeftBorderWidth: 1.w,
                //       cBottomBorderWidth: 1.w,
                //       cBorderRadius:
                //           BorderRadius.only(bottomLeft: Radius.circular(20.w)),
                //       childWidget: Center(
                //         child: RecordTableTextStyle(
                //           text: '유아 연령',
                //           title: false,
                //         ),
                //       ),
                //     ),
                //     CustomContainer(
                //       cBorderColor: borderColor,
                //       cTotalHeight: 300.w,
                //       cTotalWidth: 853.w,
                //       cInsideColor: Color(0xffffffff),
                //       cBorderRadius:
                //           BorderRadius.only(bottomRight: Radius.circular(20.w)),
                //       cTopBorderWidth: 1.w,
                //       cLeftBorderWidth: 1.w,
                //       cRightBorderWidth: 1.w,
                //       cBottomBorderWidth: 1.w,
                //       childWidget: Center(
                //         child: RecordTableTextStyle(
                //           text: '해당 연령 발달상황',
                //           title: false,
                //         ),
                //       ),
                //     ),
                //   ],
                // ),
              ],
            ),
          ],
        ]));
  }
}



class MyPainter extends CustomPainter {
  const MyPainter({
    Key? key,
    required this.lineEnd,
    required this.lineStart,
  });

  final Offset lineStart;
  final Offset lineEnd;

  @override
  void paint(Canvas canvas, Size size) {
    final p1 = lineStart;
    final p2 = lineEnd;
    final paint = Paint()
      ..color = Color(0xffD179F8)
      ..strokeWidth = 1.w
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(p1, p2, paint);
  }

  @override
  bool shouldRepaint(CustomPainter old) {
    return true;
  }
}



class LifeTextField extends StatefulWidget {
  const LifeTextField({
    Key? key,
    required this.method,
    required this.value,
    required this.modifyLife,

  }) : super(key: key);
  final String method;
  final String? value;
  final Function(String, String) modifyLife;

  @override
  State<LifeTextField> createState() => _LifeTextFieldState();
}

class _LifeTextFieldState extends State<LifeTextField> {
  TextEditingController textEditingController = TextEditingController();
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    textEditingController.text = widget.value ?? '';
    return Focus(
        focusNode: focusNode,
        onFocusChange: (hasFocus) async {
          if (hasFocus) {
          } else {
            if (widget.value == textEditingController.text) {} else {
              await widget.modifyLife(
                  widget.method, textEditingController.text);
            }
          }
        },
        child: TextField(
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
            ), //외곽선
          ),
          controller: textEditingController,
          style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: const Color(0xff393838)),
        ));
  }
}