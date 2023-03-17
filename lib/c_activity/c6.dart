// ignore_for_file: must_be_immutable
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:treasure_map/api/activity.dart';
import 'package:treasure_map/widgets/api.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../provider/app_management.dart';
import '../widgets/overtab.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

//---------------------------------------------------배변구토---------------------------------------------------\\
class C6 extends StatefulWidget {
  const C6({
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
  State<C6> createState() => _C6State();
}

class _C6State extends State<C6> {
  int rowNum = 0; //꽉채운 한줄
  int rowRestNum = 0; //그러지못한 한줄
  bool dateOn = true;

  List<GetDefecationAndVomitData> childDefecationAndVomitData = [];

  getChildDefecationAndVomitData() async {
    ApiUrl apiUrl = ApiUrl();
    http.Response dARes = await api(apiUrl.defecationAndVomit + '/' + Provider.of<UserInfo>(context, listen: false).value[0].toString() + '/' + pageTimeStr, 'get', 'signInToken', {}, context);

    if(dARes.statusCode == 200){
      childDefecationAndVomitData.clear();
      var dARB = utf8.decode(dARes.bodyBytes);
      var dAData = jsonDecode(dARB);
      setState(() {
        for (int i = 0; i < dAData.length; i++) {
          childDefecationAndVomitData.add(GetDefecationAndVomitData(
              id: dAData[i]['id'],
              name: dAData[i]['name'],
              defecation: dAData[i]['defecation'],
              defecationTotal: dAData[i]['defecationTotal'],
              vomit: dAData[i]['vomit'],
              vomitTotal: dAData[i]['vomitTotal']));
        }
        rowNum = childDefecationAndVomitData.length ~/ 2;
        rowRestNum = childDefecationAndVomitData.length % 2;
      });
    }
  }

  postApiDefecationAndVomitData(PostDefecationAndVomitData postDefecationAndVomitData) async {
    ApiUrl apiUrl = ApiUrl();
    http.Response dARes = await api(apiUrl.defecationAndVomit, 'post', 'signInToken', {
      "id": postDefecationAndVomitData.id.toString(),
      "cid": postDefecationAndVomitData.cid.toString(),
      "date": postDefecationAndVomitData.date,
      "type": postDefecationAndVomitData.type,
      "value": postDefecationAndVomitData.value.toString()
    }, context);

    if(dARes.statusCode == 200){
      receiveData(pageTime);
    }
  }

  void addButton(int defecation, int vomit, int id, bool type) {
    late PostDefecationAndVomitData postDefecationAndVomitData;
      if (type == true) {
        postDefecationAndVomitData = PostDefecationAndVomitData(value: defecation + 1, id: id, date: pageTimeStr, type: "defecation", cid: Provider.of<UserInfo>(context,listen: false).value[0]);
      } else {
        postDefecationAndVomitData = PostDefecationAndVomitData(value: vomit + 1, id: id, date: pageTimeStr, type: "vomit", cid: Provider.of<UserInfo>(context,listen: false).value[0]);
      }
    postApiDefecationAndVomitData(postDefecationAndVomitData);

  }

  void minusButton(int defecation, int vomit, int id, bool type) {
    late PostDefecationAndVomitData postDefecationAndVomitData;

      if (type == true) {
        if (defecation == 0) {
          return;
        } else {
          postDefecationAndVomitData = PostDefecationAndVomitData(value: defecation-1, id: id, date: pageTimeStr, type: "defecation", cid: Provider.of<UserInfo>(context,listen: false).value[0]);
        }
      } else {
        if (vomit == 0) {
          return;
        } else {
          postDefecationAndVomitData = PostDefecationAndVomitData(value: vomit-1, id: id, date: pageTimeStr, type: "vomit", cid: Provider.of<UserInfo>(context,listen: false).value[0]);
        }
      }
      postApiDefecationAndVomitData(postDefecationAndVomitData);

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
      getChildDefecationAndVomitData();
      //데이터 넣어주기
      //ex) data = response["data"];
    });
  }

  @override
  initState() {
    receiveData(pageTime);
    super.initState();
    //애들 갯수 구해서 childNum에 쑤셔박기


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
            dateOnOff: dateOn,
            receiveData: receiveData,
            scaffoldKey: widget.scaffoldKey,
          ),
          Expanded(
            child: ScrollConfiguration(
              behavior: const ScrollBehavior().copyWith(overscroll: false),
              child: ListView(
                physics: const RangeMaintainingScrollPhysics(),
                children: [
                  for (int i = 0; i < rowNum + 1; i++) ...[
                    if (i == rowNum) ...[
                      Row(
                        children: [
                          for (int j = 0; j < rowRestNum; j++) ...[
                            Container(
                              width: 39.w,
                              height: 222.w,
                              color: const Color(0xffFCFCFC),
                            ),
                            ChildPoopWidget(
                              defecationAndVomitData: childDefecationAndVomitData[i * 2 + 0],
                              addButton: addButton,
                              minusButton: minusButton,
                            ),
                          ]
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            width: 39.w,
                            height: 50.w,
                            decoration: BoxDecoration(
                              //color: Colors.black,
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
                            height: 152.w,
                            color: const Color(0xffFCFCFC),
                          ),
                          ChildPoopWidget(
                            defecationAndVomitData: childDefecationAndVomitData[i * 2 + 0],
                            addButton: addButton,
                            minusButton: minusButton,
                          ),
                          SizedBox(
                            width: 50.w,
                          ),
                          ChildPoopWidget(
                            defecationAndVomitData: childDefecationAndVomitData[i * 2 + 1],
                            addButton: addButton,
                            minusButton: minusButton,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            width: 39.w,
                            height: 50.w,
                            color: const Color(0xffFCFCFC),
                          ),
                        ],
                      )
                    ],
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

class ChildPoopWidget extends StatefulWidget {
  ChildPoopWidget(
      {
        required this.defecationAndVomitData,
        required this.addButton,
        required this.minusButton,
      Key? key})
      : super(key: key);
  final GetDefecationAndVomitData defecationAndVomitData;
  Function(int, int, int, bool) addButton;
  Function(int, int, int, bool) minusButton;

  @override
  State<ChildPoopWidget> createState() => _ChildPoopWidgetState();
}

class _ChildPoopWidgetState extends State<ChildPoopWidget> {
  Color columnhexcolor = const Color(0xFFFFEFD3);
  Color columnhexcolor2 = const Color(0xFFFFFDF8);
  Color rowhexcolor = const Color(0xFFFFFFFF);

  double borderradius = 20.w;
  double borderwidth = 1.w;
  Color borderhexcolor = const Color(0x4DFDB43B);

  double fontsize14 = 14.sp;
  Color fonthexcolor = const Color(0xFF393838);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 492.w,
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
      child: Center(
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
                      style:
                          TextStyle(fontSize: fontsize14, color: fonthexcolor),
                    ),
                  ),
                ),
                Container(
                    width: 90.w,
                    height: 80.w,
                    decoration: BoxDecoration(
                        color: rowhexcolor,
                        border: Border.all(
                            color: borderhexcolor, width: borderwidth),
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(borderradius))),
                    child: Center(child: Text(widget.defecationAndVomitData.name,style:
                    TextStyle(fontSize: fontsize14, color: fonthexcolor),),))
              ],
            ),
            Column(
              children: [
                Container(
                  width: 200.w,
                  height: 30.w,
                  decoration: BoxDecoration(
                    color: columnhexcolor2,
                    border:
                        Border.all(color: borderhexcolor, width: borderwidth),
                  ),
                  child: Center(
                    child: Text(
                      '대변',
                      style:
                          TextStyle(fontSize: fontsize14, color: fonthexcolor),
                    ),
                  ),
                ),
                Row(
                  children: [
                    Container(
                      width: 100.w,
                      height: 40.w,
                      decoration: BoxDecoration(
                        color: columnhexcolor,
                        border: Border.all(
                            color: borderhexcolor, width: borderwidth),
                      ),
                      child: Center(
                        child: Text(
                          '오늘',
                          style: TextStyle(
                              fontSize: fontsize14, color: fonthexcolor),
                        ),
                      ),
                    ),
                    Container(
                        width: 100.w,
                        height: 40.w,
                        decoration: BoxDecoration(
                          color: columnhexcolor,
                          border: Border.all(
                              color: borderhexcolor, width: borderwidth),
                        ),
                        child: Center(
                          child: Text(
                            '주별',
                            style: TextStyle(
                                fontSize: fontsize14, color: fonthexcolor),
                          ),
                        ))
                  ],
                ),

                ///대변
                Row(
                  children: [
                    ///오늘
                    Container(
                      width: 100.w,
                      height: 80.w,
                      decoration: BoxDecoration(
                        color: rowhexcolor,
                        border: Border.all(
                            color: borderhexcolor, width: borderwidth),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: (){
                              widget.minusButton(widget.defecationAndVomitData.defecation, widget.defecationAndVomitData.vomit, widget.defecationAndVomitData.id, true);
                            },
                            child: Container(
                              height: 30.w,
                              width: 30.w,
                              decoration: BoxDecoration(
                                color: Color(0xffffffff),
                                borderRadius: BorderRadius.all(Radius.circular(10.w)),
                                border: Border.all(width: 2.w, color: Color(0xffA666FC),)
                              ),

                              child: Icon(
                                Icons.remove,
                                size: 20.w,
                                color: Color(0xffA666FC),
                              ),
                            ),
                          ),
                          SizedBox(width: 10.w,),



                          Center(child: Text(widget.defecationAndVomitData.defecation.toString(),style:
                          TextStyle(fontSize: fontsize14, color: fonthexcolor),),),
                          SizedBox(width: 10.w,),
                          GestureDetector(
                            onTap: (){
                              widget.addButton(widget.defecationAndVomitData.defecation, widget.defecationAndVomitData.vomit, widget.defecationAndVomitData.id, true);
                            },
                            child: Container(
                              height: 30.w,
                              width: 30.w,
                              decoration: BoxDecoration(
                                color: Color(0xffA666FC),
                                borderRadius: BorderRadius.all(Radius.circular(10.w)),
                              ),

                              child: Icon(
                                Icons.add,
                                size: 20.w,
                                color: Colors.white,
                              ),
                            ),
                          ),

                        ],
                      ),
                    ),

                    ///주별
                    Container(
                      width: 100.w,
                      height: 80.w,
                      decoration: BoxDecoration(
                        color: rowhexcolor,
                        border: Border.all(
                            color: borderhexcolor, width: borderwidth),
                      ),
                      child: Center(child: Text(widget.defecationAndVomitData.defecationTotal.toString(),style:
                      TextStyle(fontSize: fontsize14, color: fonthexcolor),)),
                    )
                  ],
                ),
              ],
            ),
            Column(
              children: [
                Container(
                  width: 200.w,
                  height: 30.w,
                  decoration: BoxDecoration(
                      color: columnhexcolor2,
                      border:
                          Border.all(color: borderhexcolor, width: borderwidth),
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(borderradius))),
                  child: Center(
                    child: Text(
                      '구토',
                      style:
                          TextStyle(fontSize: fontsize14, color: fonthexcolor),
                    ),
                  ),
                ),
                Row(
                  children: [
                    Container(
                      width: 100.w,
                      height: 40.w,
                      decoration: BoxDecoration(
                        color: columnhexcolor,
                        border: Border.all(
                            color: borderhexcolor, width: borderwidth),
                      ),
                      child: Center(
                        child: Text(
                          '오늘',
                          style: TextStyle(
                              fontSize: fontsize14, color: fonthexcolor),
                        ),
                      ),
                    ),
                    Container(
                        width: 100.w,
                        height: 40.w,
                        decoration: BoxDecoration(
                          color: columnhexcolor,
                          border: Border.all(
                              color: borderhexcolor, width: borderwidth),
                        ),
                        child: Center(
                          child: Text(
                            '주별',
                            style: TextStyle(
                                fontSize: fontsize14, color: fonthexcolor),
                          ),
                        ))
                  ],
                ),

                ///구토
                Row(
                  children: [
                    ///오늘
                    Container(
                      width: 100.w,
                      height: 80.w,
                      decoration: BoxDecoration(
                        color: rowhexcolor,
                        border: Border.all(
                            color: borderhexcolor, width: borderwidth),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: (){
                              widget.minusButton(widget.defecationAndVomitData.defecation, widget.defecationAndVomitData.vomit,widget.defecationAndVomitData.id,false);
                            },
                            child: Container(
                              height: 30.w,
                              width: 30.w,
                              decoration: BoxDecoration(
                                  color: Color(0xffffffff),
                                  borderRadius: BorderRadius.all(Radius.circular(10.w)),
                                  border: Border.all(width: 2.w, color: Color(0xffA666FC),)
                              ),

                              child: Icon(
                                Icons.remove,
                                size: 20.w,
                                color: Color(0xffA666FC),
                              ),
                            ),
                          ),
                          SizedBox(width: 10.w,),

                          Center(child: Text(widget.defecationAndVomitData.vomit.toString(),style:
                          TextStyle(fontSize: fontsize14, color: fonthexcolor),)),

                          SizedBox(width: 10.w,),
                          GestureDetector(
                            onTap: (){
                              widget.addButton(widget.defecationAndVomitData.defecation, widget.defecationAndVomitData.vomit, widget.defecationAndVomitData.id, false);
                            },
                            child: Container(
                              height: 30.w,
                              width: 30.w,
                              decoration: BoxDecoration(
                                color: Color(0xffA666FC),
                                borderRadius: BorderRadius.all(Radius.circular(10.w)),
                              ),

                              child: Icon(
                                Icons.add,
                                size: 20.w,
                                color: Colors.white,
                              ),
                            ),
                          ),


                        ],
                      ),
                    ),

                    ///주별
                    Container(
                      width: 100.w,
                      height: 80.w,
                      decoration: BoxDecoration(
                          color: rowhexcolor,
                          border: Border.all(
                              color: borderhexcolor, width: borderwidth),
                          borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(borderradius))),
                      child: Center(child: Text(widget.defecationAndVomitData.vomitTotal.toString(),style:
                      TextStyle(fontSize: fontsize14, color: fonthexcolor),)),
                    )
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
