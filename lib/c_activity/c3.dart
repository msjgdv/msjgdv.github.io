import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/rendering.dart';
import 'package:treasure_map/api/activity.dart';
import 'package:treasure_map/widgets/api.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../provider/app_management.dart';
import '../widgets/custom_container.dart';
import '../widgets/overtab.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../widgets/token_time_over.dart';

class C3 extends StatefulWidget {
  const C3({
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
  State<C3> createState() => _C3State();
}

class _C3State extends State<C3> {
  static final autoLoginStorage = FlutterSecureStorage();
  bool dateOn = true;

  ApiUrl apiUrl = ApiUrl();

  List<GetEmotionData> childEmotionData = [];
  List<List<double>> homeEmotionCount = [];
  List<List<double>> kindergartenEmotionCount = [];
  List<int> todayHomeEmotionNumber = [];
  List<int> todayKindergartenEmotionNumber = [];
  List<Map<String, double>> dataMapHome = [];
  List<Map<String, double>> dataMapKindergarten = [];
  List<TextEditingController> textEditingController = [];

  //현재 날짜로 저장을 해서 페이지에 들어오늘 순간 데이터를 불러오도록함.
  DateTime pageTime = DateTime.now();
  String pageTimeStr = '';

  //overTab에 넘겨주는 함수
  //아래 overTab 위젯에 이 함수를 넣어줘야함 지금은 null이 들어가도 되도록 해놔서 빨간줄 안나옴
  //이 함수에서 api를 보내서 데이터를 가져올 예정임
  //달력에서 날짜를 선택하게 되면 이 함수가 호출되서 그 날짜의 api를 다시 가져옴
  receiveData(DateTime dateTime) async {
    //api 보내는 날짜를 바꿈
    pageTime = dateTime;
    var formatter = DateFormat('yyyyMMdd');
    pageTimeStr = formatter.format(pageTime);
    //api 통신 후 데이터 받아오기

    //데이터 넣어주기
    //ex) data = response["data"];
    await getChildEmotionData();
    setState(() {});
  }

  getChildEmotionData() async {
    http.Response emotionRes = await api(apiUrl.emotion+'/'+Provider.of<UserInfo>(context, listen: false).value[0].toString() +'/'+ pageTimeStr, 'get', 'signInToken', {}, context);
    if(emotionRes.statusCode == 200){
      var emotionRB = utf8.decode(emotionRes.bodyBytes);
      var emotionData = jsonDecode(emotionRB);
      setState(() {
        childEmotionData.clear();
        for (int i = 0; i < emotionData.length; i++) {
          childEmotionData.add(GetEmotionData(
              id: emotionData[i]['id'],
              name: emotionData[i]['name'],
              enteringEmotion: emotionData[i]['enteringEmotion'],
              quittingEmotion: emotionData[i]['quittingEmotion'],
              isContacted: emotionData[i]['isContacted'],
              comment: emotionData[i]['comment'],
              sex: emotionData[i]['sex'],
              enteringEmotions: emotionData[i]['enteringEmotions'].cast<String>(),
              quittingEmotions: emotionData[i]['quittingEmotions'].cast<String>()));
        }
        dataMake();
      });
    }
  }

  dataMake() {
    setState(() {
      homeEmotionCount.clear();
      kindergartenEmotionCount.clear();
      todayHomeEmotionNumber.clear();
      todayKindergartenEmotionNumber.clear();
      dataMapHome.clear();
      dataMapKindergarten.clear();
      textEditingController.clear();

      for (int i = 0; i < childEmotionData.length; i++) {
        homeEmotionCount.add([0, 0, 0, 0, 0, 0]);
        kindergartenEmotionCount.add([0, 0, 0, 0, 0, 0]);
        todayHomeEmotionNumber.add(0);
        todayKindergartenEmotionNumber.add(0);
        dataMapHome.add({});
        dataMapKindergarten.add({});
        textEditingController.add(TextEditingController());
        textEditingController[i].text = childEmotionData[i].comment;

        for (int j = 0; j < childEmotionData[i].enteringEmotions.length; j++) {
          if (childEmotionData[i].enteringEmotions[j] == 'happy') {
            homeEmotionCount[i][0]++;
          } else if (childEmotionData[i].enteringEmotions[j] == 'excite') {
            homeEmotionCount[i][1]++;
          } else if (childEmotionData[i].enteringEmotions[j] == 'angry') {
            homeEmotionCount[i][2]++;
          } else if (childEmotionData[i].enteringEmotions[j] == 'sad') {
            homeEmotionCount[i][3]++;
          } else if (childEmotionData[i].enteringEmotions[j] == 'lonely') {
            homeEmotionCount[i][4]++;
          } else if (childEmotionData[i].enteringEmotions[j] == 'worry') {
            homeEmotionCount[i][5]++;
          }
        }
        for (int j = 0; j < childEmotionData[i].quittingEmotions.length; j++) {
          if (childEmotionData[i].quittingEmotions[j] == 'happy') {
            kindergartenEmotionCount[i][0]++;
          } else if (childEmotionData[i].quittingEmotions[j] == 'excite') {
            kindergartenEmotionCount[i][1]++;
          } else if (childEmotionData[i].quittingEmotions[j] == 'angry') {
            kindergartenEmotionCount[i][2]++;
          } else if (childEmotionData[i].quittingEmotions[j] == 'sad') {
            kindergartenEmotionCount[i][3]++;
          } else if (childEmotionData[i].quittingEmotions[j] == 'lonely') {
            kindergartenEmotionCount[i][4]++;
          } else if (childEmotionData[i].quittingEmotions[j] == 'worry') {
            kindergartenEmotionCount[i][5]++;
          }
        }
        if (childEmotionData[i].quittingEmotion == 'happy') {
          todayKindergartenEmotionNumber[i] = 0;
        } else if (childEmotionData[i].quittingEmotion == 'angry') {
          todayKindergartenEmotionNumber[i] = 1;
        } else if (childEmotionData[i].quittingEmotion == 'excite') {
          todayKindergartenEmotionNumber[i] = 2;
        } else if (childEmotionData[i].quittingEmotion == 'sad') {
          todayKindergartenEmotionNumber[i] = 3;
        } else if (childEmotionData[i].quittingEmotion == 'lonely') {
          todayKindergartenEmotionNumber[i] = 4;
        } else if (childEmotionData[i].quittingEmotion == 'worry') {
          todayKindergartenEmotionNumber[i] = 5;
        }
        if (childEmotionData[i].enteringEmotion == 'happy') {
          todayHomeEmotionNumber[i] = 0;
        } else if (childEmotionData[i].enteringEmotion == 'angry') {
          todayHomeEmotionNumber[i] = 1;
        } else if (childEmotionData[i].enteringEmotion == 'excite') {
          todayHomeEmotionNumber[i] = 2;
        } else if (childEmotionData[i].enteringEmotion == 'sad') {
          todayHomeEmotionNumber[i] = 3;
        } else if (childEmotionData[i].enteringEmotion == 'lonely') {
          todayHomeEmotionNumber[i] = 4;
        } else if (childEmotionData[i].enteringEmotion == 'worry') {
          todayHomeEmotionNumber[i] = 5;
        }

        dataMapHome[i] = {
          "happy": homeEmotionCount[i][0],
          "excited": homeEmotionCount[i][1],
          "angry": homeEmotionCount[i][2],
          "sad": homeEmotionCount[i][3],
          "lonely": homeEmotionCount[i][4],
          "concerned": homeEmotionCount[i][5],
        };
        dataMapKindergarten[i] = {
          "happy": kindergartenEmotionCount[i][0],
          "excited": kindergartenEmotionCount[i][1],
          "angry": kindergartenEmotionCount[i][2],
          "sad": kindergartenEmotionCount[i][3],
          "lonely": kindergartenEmotionCount[i][4],
          "concerned": kindergartenEmotionCount[i][5],
        };
      }
    });
  }

  //화면이 실행이 되면 receiveData함수를 오늘 날짜로 실행해서 데이터를 받아오도록함
  @override
  void initState() {
    receiveData(pageTime);
    // TODO: implement initState
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
                  for (int i = 0; i < childEmotionData.length; i++) ...[
                    Row(
                      children: [
                        Container(
                          width: 39.w,
                          height: 308.w,
                          color: Color(0xfffcfcfc),
                        ),
                        EmotionTable(
                          getEmotionData: childEmotionData[i],
                          date: pageTime,
                          dateStr: pageTimeStr,
                          receiveData: receiveData,
                          todayKindergartenEmotionNumber:
                              todayKindergartenEmotionNumber[i],
                          dataMapKindergarten: dataMapKindergarten[i],
                          todayHomeEmotionNumber: todayHomeEmotionNumber[i],
                          dataMapHome: dataMapHome[i],
                          textEditingController: textEditingController[i],
                        ),
                      ],
                    ),
                    if (i != childEmotionData.length - 1) ...[
                      Container(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            color: Color(0xfffcfcfc),
                            height: 50.w,
                            width: 39.w,
                          )
                        ],
                      ))
                    ],
                  ],
                  Container(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        color: Color(0xfffcfcfc),
                        height: 10.w,
                        width: 39.w,
                      )
                    ],
                  )),
                  Container(
                    height: 50.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(50.w),
                      ),
                      color: Color(0xffFCFCFC),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class EmotionTable extends StatefulWidget {
  const EmotionTable({
    Key? key,
    required this.getEmotionData,
    required this.date,
    required this.receiveData,
    required this.dateStr,
    required this.dataMapHome,
    required this.dataMapKindergarten,
    required this.todayKindergartenEmotionNumber,
    required this.todayHomeEmotionNumber,
    required this.textEditingController,
  }) : super(key: key);
  final GetEmotionData getEmotionData;
  final String dateStr;
  final DateTime date;
  final Function(DateTime) receiveData;
  final Map<String, double> dataMapHome;
  final Map<String, double> dataMapKindergarten;
  final int todayHomeEmotionNumber;
  final int todayKindergartenEmotionNumber;
  final TextEditingController textEditingController;

  @override
  State<EmotionTable> createState() => _EmotionTableState();
}

class _EmotionTableState extends State<EmotionTable> {
  static final autoLoginStorage = FlutterSecureStorage();
  double borderWidth = 2.w;

  List<String> boyEmotions = [
    "assets/images/emotion_boy_happy_s.svg",
    "assets/images/emotion_boy_angry_s.svg",
    "assets/images/emotion_boy_excited_s.svg",
    "assets/images/emotion_boy_sadness_s.svg",
    "assets/images/emotion_boy_loneliness_s.svg",
    "assets/images/emotion_boy_concerned_s.svg",
  ];

  List<String> girlEmotions = [
    "assets/images/emotion_girl_happy_s.svg",
    "assets/images/emotion_girl_angry_s.svg",
    "assets/images/emotion_girl_excited_s.svg",
    "assets/images/emotion_girl_sadness_s.svg",
    "assets/images/emotion_girl_loneliness_s.svg",
    "assets/images/emotion_girl_concerned_s.svg",
  ];

  List<Color> colorList = [
    Color(0xfff96797),
    Color(0xfff99367),
    Color(0xff4a3e56),
    Color(0xff679ff9),
    Color(0xffa666fb),
    Color(0xff73d371)
  ];

  postEmotionCommentData(int id, int cid, String dateStr, String value,
      Function(DateTime) receiveData, DateTime date) async {
    ApiUrl apiUrl = ApiUrl();
    http.Response emotionRes = await api(apiUrl.emotion, 'post', 'signInToken', {
      'type': "comment",
      'value': value,
      'id': id.toString(),
      'date': dateStr,
      'cid': cid.toString()
    }, context);
    if(emotionRes.statusCode == 200){
      widget.receiveData(date);
    }
  }


  @override
  void initState() {
    // _textEditingController.text = widget.getEmotionData.comment;
    // dataMake();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // SizedBox(
        //   width: 39.w,
        // ),
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20.w)),
              boxShadow: [
                BoxShadow(
                  color: const Color(0x29B1B1B1),
                  // spreadRadius: ,
                  blurRadius: 6,
                  offset: Offset(-2, 2),
                )
              ]),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 90.w,
                    height: 40.w,
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.only(topLeft: Radius.circular(20.w)),
                      border: Border.all(
                          width: borderWidth, color: Color(0x4dFDB43B)),
                      color: Color(0xffFFEFD3),
                    ),
                    child: Center(child: DefaultTextStyle(text: '유아명')),
                  ),
                  CustomContainer(
                    cTopBorderWidth: borderWidth,
                    cBottomBorderWidth: borderWidth,
                    cBorderColor: Color(0x6dFDB43B),
                    cInsideColor: Color(0xffFFEFD3),
                    cTotalWidth: 230.w,
                    cTotalHeight: 40.w,
                    childWidget: Center(
                      child: DefaultTextStyle(
                        text: '오늘의 기분',
                      ),
                    ),
                  ),
                  CustomContainer(
                    cTopBorderWidth: borderWidth,
                    cInsideColor: Color(0xffFFFDF8),
                    cTotalWidth: 385.w,
                    cTotalHeight: 40.w,
                    cBorderColor: Color(0xffFFEFD3),
                    childWidget: Center(
                      child: DefaultTextStyle(
                        text: '최근 7일 감정분포',
                      ),
                    ),
                  ),
                  CustomContainer(
                    cRightBorderWidth: borderWidth,
                    cTopBorderWidth: borderWidth,
                    cBottomBorderWidth: borderWidth,
                    cBorderRadius:
                        BorderRadius.only(topRight: Radius.circular(20.w)),
                    cTotalHeight: 40.w,
                    cTotalWidth: 349.w,
                    cBorderColor: Color(0x6dFDB43B),
                    cInsideColor: Color(0xffFFEFD3),
                    childWidget: Center(
                      child: DefaultTextStyle(
                        text: '해당 감정과 관련된 경험',
                      ),
                    ),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      CustomContainer(
                        cRightBorderWidth: borderWidth,
                        cLeftBorderWidth: borderWidth,
                        cTotalHeight: 158.w,
                        cTotalWidth: 90.w,
                        cBorderColor: Color(0xffFFEFD3),
                        cInsideColor: Color(0xffFFFFFF),
                        childWidget: Center(
                          child: DefaultTextStyle(
                            text: widget.getEmotionData.name,
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Color(0x4DFDB43B), width: borderWidth),
                            color: Color(0xffffefd3)),
                        width: 90.w,
                        height: 40.w,
                        child: Center(
                            child: DefaultTextStyle(
                          text: '학부모 알림',
                        )),
                      ),
                      GestureDetector(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return MessageToParent();
                              });
                        },
                        child: CustomContainer(
                          cRightBorderWidth: borderWidth,
                          cLeftBorderWidth: borderWidth,
                          cBottomBorderWidth: borderWidth,
                          cBorderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(20.w)),
                          cTotalHeight: 70.w,
                          cTotalWidth: 90.w,
                          cBorderColor: Color(0xffFFEFD3),
                          cInsideColor: Color(0xffFFFFFF),
                          childWidget: Center(
                            child: widget.getEmotionData.isContacted == true
                                ? DefaultTextStyle(text: "Y")
                                : TextButton(
                                    onPressed: () {

                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return MessageToParent();
                                          });
                                    },
                                    child: DefaultTextStyle(text: "N"),
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                        width: 230.w,
                        height: 134.w,
                        color: Color(0xffFFFFFF),
                        child: Row(
                          children: [
                            Container(
                              width: 80.w,
                              child: Center(
                                child: DefaultTextStyle(
                                  text: '가정',
                                ),
                              ),
                            ),
                            Container(
                              width: 150.w,
                              child: Center(
                                child: widget.getEmotionData.enteringEmotion ==
                                        ''
                                    ? TextButton(
                                        onPressed: () {
                                          setState(() {
                                            emotionSelect(
                                                context,
                                                widget.getEmotionData.id,
                                                widget.getEmotionData.sex,
                                                true,
                                                widget.dateStr,
                                                widget.date,
                                                widget.receiveData,
                                              );
                                          });
                                        },
                                        child: AddButton(),
                                      )
                                    : widget.getEmotionData.sex == true
                                        ? TextButton(
                                            onPressed: () {
                                              emotionSelect(
                                                  context,
                                                  widget.getEmotionData.id,
                                                  widget.getEmotionData.sex,
                                                  true,
                                                  widget.dateStr,
                                                  widget.date,
                                                  widget.receiveData,
                                              );
                                            },
                                            child: SvgPicture.asset(boyEmotions[
                                                widget.todayHomeEmotionNumber]),
                                          )
                                        : TextButton(
                                            onPressed: () {
                                              emotionSelect(
                                                  context,
                                                  widget.getEmotionData.id,
                                                  widget.getEmotionData.sex,
                                                  true,
                                                  widget.dateStr,
                                                  widget.date,
                                                  widget.receiveData,
                                                  );
                                            },
                                            child: SvgPicture.asset(
                                                girlEmotions[
                                                widget.todayHomeEmotionNumber]),
                                          ),
                              ),
                            )
                          ],
                        ),
                      ),
                      CustomContainer(
                        cTotalWidth: 230.w,
                        cTotalHeight: 134.w,
                        cBorderColor: Color(0x6dFDB43B),
                        cInsideColor: Color(0xffFFFFFF),
                        cBottomBorderWidth: borderWidth,
                        childWidget: Row(
                          children: [
                            Container(
                              width: 80.w,
                              child: Center(
                                child: DefaultTextStyle(
                                  text: Provider.of<UserInfo>(context,listen : false).kindergartenState,
                                ),
                              ),
                            ),
                            Container(
                              width: 150.w,
                              child: Center(
                                child: widget.getEmotionData.quittingEmotion ==
                                        ''
                                    ? TextButton(
                                        onPressed: () {
                                          emotionSelect(
                                              context,
                                              widget.getEmotionData.id,
                                              widget.getEmotionData.sex,
                                              false,
                                              widget.dateStr,
                                              widget.date,
                                              widget.receiveData,
                                              );
                                        },
                                        child: AddButton(),
                                      )
                                    : widget.getEmotionData.sex == true
                                        ? TextButton(
                                            onPressed: () {
                                              emotionSelect(
                                                  context,
                                                  widget.getEmotionData.id,
                                                  widget.getEmotionData.sex,
                                                  false,
                                                  widget.dateStr,
                                                  widget.date,
                                                  widget.receiveData,
                                                  );
                                            },
                                            child: SvgPicture.asset(boyEmotions[
                                            widget.todayKindergartenEmotionNumber]),
                                          )
                                        : TextButton(
                                            onPressed: () {
                                              emotionSelect(
                                                  context,
                                                  widget.getEmotionData.id,
                                                  widget.getEmotionData.sex,
                                                  false,
                                                  widget.dateStr,
                                                  widget.date,
                                                  widget.receiveData,
                                                  );
                                            },
                                            child: SvgPicture.asset(girlEmotions[
                                            widget.todayKindergartenEmotionNumber]),
                                          ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                        width: 193.w,
                        height: 40.w,
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Color(0x4dfdb43b), width: borderWidth),
                          color: Color(0xffffefd3),
                        ),
                        child: Center(
                          child: DefaultTextStyle(
                            text: '집',
                          ),
                        ),
                      ),
                      CustomContainer(
                        cTotalHeight: 228.w,
                        cTotalWidth: 193.w,
                        cBottomBorderWidth: borderWidth,
                        cRightBorderWidth: borderWidth,
                        cLeftBorderWidth: borderWidth,
                        cBorderColor: Color(0x6dfdb43b),
                        cInsideColor: Color(0xffFFFFFF),
                        childWidget: Center(
                          child: PieChart(
                            emptyColor: Colors.transparent,
                            dataMap: widget.dataMapHome,
                            colorList: colorList,
                            legendOptions: LegendOptions(
                              showLegends: false,
                            ),
                            chartValuesOptions: ChartValuesOptions(
                              showChartValues: false,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      CustomContainer(
                        cTotalHeight: 40.w,
                        cTotalWidth: 193.w,
                        cBottomBorderWidth: borderWidth,
                        cRightBorderWidth: borderWidth,
                        cTopBorderWidth: borderWidth,
                        cBorderColor: Color(0x6dfdb43b),
                        cInsideColor: Color(0xffffefd3),
                        childWidget: Center(
                          child: DefaultTextStyle(
                            text: Provider.of<UserInfo>(context,listen : false).kindergartenState,
                          ),
                        ),
                      ),
                      CustomContainer(
                        cTotalHeight: 228.w,
                        cTotalWidth: 193.w,
                        cBottomBorderWidth: borderWidth,
                        cRightBorderWidth: borderWidth,
                        cBorderColor: Color(0x6dfdb43b),
                        cInsideColor: Color(0xffFFFFFF),
                        childWidget: Center(
                          child: PieChart(
                            emptyColor: Colors.transparent,
                            dataMap: widget.dataMapKindergarten,
                            colorList: colorList,
                            legendOptions: LegendOptions(
                              showLegends: false,
                            ),
                            chartValuesOptions: ChartValuesOptions(
                              showChartValues: false,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  CustomContainer(
                    cTotalHeight: 268.w,
                    cTotalWidth: 349.w,
                    cBottomBorderWidth: borderWidth,
                    cRightBorderWidth: borderWidth,
                    cBorderRadius:
                        BorderRadius.only(bottomRight: Radius.circular(20.w)),
                    cBorderColor: Color(0xffFFEFD3),
                    cInsideColor: Color(0xffFFFFFF),
                    childWidget: Center(
                      child: Container(
                        width: 340.w,
                        child: Focus(
                          onFocusChange: (hasFocus) {
                            if (hasFocus) {
                            } else {
                              if (widget.textEditingController.text == '') {
                              } else if (widget.getEmotionData.comment ==
                                  widget.textEditingController.text) {
                              } else {
                                postEmotionCommentData(widget.getEmotionData.id, Provider.of<UserInfo>(context, listen: false).value[0], widget.dateStr, widget.textEditingController.text, widget.receiveData,widget.date);
                                //해당 감정과 관련된 경험 api를 보내면 됩니다.
                                // _textEditingController.text
                              }
                            }
                          },
                          child: TextField(
                            controller: widget.textEditingController,
                            maxLines: 10,
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              // hintText: widget.getEmotionData.comment,
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                              ), //외곽선
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        )
      ],
    );
  }
}

class AddButton extends StatelessWidget {
  const AddButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50.w,
      height: 50.w,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10.w)),
          color: Color(0xffFFD288),
          boxShadow: [
            BoxShadow(
              offset: Offset(0, 3),
              blurRadius: 6,
              color: Color(0x29000000),
            )
          ]),
      child: Center(
        child: Text(
          "+",
          style: TextStyle(
            fontSize: 30.sp,
            color: Color(0xffA76902),
          ),
        ),
      ),
    );
  }
}

class DefaultTextStyle extends StatefulWidget {
  const DefaultTextStyle({
    Key? key,
    required this.text,
  }) : super(key: key);
  final String text;

  @override
  State<DefaultTextStyle> createState() => _DefaultTextStyleState();
}

class _DefaultTextStyleState extends State<DefaultTextStyle> {
  @override
  Widget build(BuildContext context) {
    return Text(
      widget.text,
      style: TextStyle(
        color: Color(0xff393838),
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
      ),
      textAlign: TextAlign.center,
    );
  }
}

emotionSelect(context, int identification, bool sex, bool time, String dateStr,
    DateTime date, Function(DateTime) receiveData) {
  return showDialog<void>(
      context: context,
      // barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Color(0xffFFFDF8),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.w))),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20.w)),
              color: Color(0x8cFFEFD3),
            ),
            width: 1060.w,
            height: 700.w,
            child: Column(
              children: [
                SizedBox(
                  height: 12.w,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: SvgPicture.asset(
                        'assets/icons/icon_close_record.svg',
                        width: 30.w,
                        height: 30.w,
                      ),
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                  ],
                ),
                // SizedBox(
                //   height: 8.w,
                // ),
                Row(
                  children: [
                    SizedBox(
                      width: 35.w,
                    ),
                    for (int i = 0; i < 6; i++, i++) ...[
                      //가로, 세로 바꾸기 귀찮아서 두개씩 늘려서 만들었음
                      CustomEmotionButton(
                        buttonNumber: i,
                        sex: sex,
                        time: time,
                        identification: identification,
                        dateStr: dateStr,
                        date: date,
                        receiveData: receiveData,

                      ),
                    ]
                  ],
                ),
                Spacer(),
                Row(
                  children: [
                    SizedBox(
                      width: 35.w,
                    ),
                    for (int i = 1; i < 6; i++, i++) ...[
                      CustomEmotionButton(
                        buttonNumber: i,
                        sex: sex,
                        time: time,
                        identification: identification,
                        dateStr: dateStr,
                        date: date,
                        receiveData: receiveData,

                      ),
                    ]
                  ],
                ),
                SizedBox(
                  height: 58.w,
                )
              ],
            ),
          ),
        );
      });
}

class CustomEmotionButton extends StatefulWidget {
  const CustomEmotionButton({
    Key? key,
    required this.buttonNumber,
    required this.sex,
    required this.time,
    required this.identification,
    required this.dateStr,
    required this.receiveData,
    required this.date,

  }) : super(key: key);
  final int buttonNumber;
  final int identification;
  final bool sex;
  final bool time;
  final String dateStr;
  final DateTime date;
  final Function(DateTime) receiveData;


  @override
  State<CustomEmotionButton> createState() => _CustomEmotionButtonState();
}

class _CustomEmotionButtonState extends State<CustomEmotionButton> {
  static final autoLoginStorage = FlutterSecureStorage();
  List<String> boyEmotions = [
    "assets/images/emotion_boy_happy.svg",
    "assets/images/emotion_boy_angry.svg",
    "assets/images/emotion_boy_excited.svg",
    "assets/images/emotion_boy_sadness.svg",
    "assets/images/emotion_boy_loneliness.svg",
    "assets/images/emotion_boy_concerned.svg",
  ];

  List<String> girlEmotions = [
    "assets/images/emotion_girl_happy.svg",
    "assets/images/emotion_girl_angry.svg",
    "assets/images/emotion_girl_excited.svg",
    "assets/images/emotion_girl_sadness.svg",
    "assets/images/emotion_girl_loneliness.svg",
    "assets/images/emotion_girl_concerned.svg",
  ];

  List<String> emotion = ["행복", "화남", "신남", "슬픔", "외로움", "걱정"];
  List<String> emotionData = [
    "happy",
    "angry",
    'excite',
    'sad',
    'lonely',
    'worry'
  ];

  postEmotionData(int id, int cid, String dateStr, bool type, String value,
      Function(DateTime) receiveData, DateTime date) async {
    ApiUrl apiUrl = ApiUrl();
    http.Response emotionRes = await api(apiUrl.emotion, 'post', 'signInToken', {
      'type': type ? "enteringEmotion" : "quittingEmotion",
      'value': value,
      'id': id.toString(),
      'date': dateStr,
      'cid': cid.toString()
    }, context);
    if(emotionRes.statusCode == 200){
      widget.receiveData(date);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 40.w, right: 40.w),
      width: 250.w,
      height: 252.w,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20.w)),
          border: Border.all(color: Color(0x4DFDB43B)),
          color: Color(0xffffffff),
          boxShadow: [
            BoxShadow(
              color: Color(0x29AAAAAA),
              offset: Offset(3, 3),
              blurRadius: 11,
            )
          ]),
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
          elevation: MaterialStateProperty.all(0),
        ),
        onPressed: () {
          setState(() {
            postEmotionData(
                widget.identification,
                Provider.of<UserInfo>(context, listen: false).value[0],
                widget.dateStr,
                widget.time,
                emotionData[widget.buttonNumber],
                widget.receiveData,
                widget.date);
          });

          //api 보내는 곳임
          Navigator.of(context).pop();
        },
        child: Column(
          children: [
            SizedBox(
              height: 31.w,
            ),
            widget.sex == true
                ? SvgPicture.asset(
                    boyEmotions[widget.buttonNumber],
                    width: 194.w,
                    height: 147.w,
                  )
                : SvgPicture.asset(
                    girlEmotions[widget.buttonNumber],
                    width: 194.w,
                    height: 147.w,
                  ),
            SizedBox(
              height: 24.w,
            ),
            Text(
              emotion[widget.buttonNumber],
              style: TextStyle(
                color: Color(0xff393838),
                fontSize: 20.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

postEmotionComment(context, String name) {
  return showDialog<void>(
      context: context,
      // barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.w))),
          child: Container(
            width: 550.w,
            height: 285.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10.w)),
              border: Border.all(color: Color(0xff7649B7), width: 1),
              color: Color(0xffE2D3FE),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 40.w,
                ),
                Text(
                  name + ' 유아의 학부모에게\n해당 감정과 관련된 경험에 대해 전달합니다.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w500,
                    color: Color(0xff393838),
                  ),
                ),
                SizedBox(
                  height: 56.w,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 150.w,
                      height: 50.w,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border:
                              Border.all(color: Color(0xffA666FB), width: 1.w),
                          borderRadius:
                              BorderRadius.all(Radius.circular(10.w))),
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.transparent),
                          elevation: MaterialStateProperty.all(0),
                        ),
                        onPressed: () {
                          //api 보내는 곳임
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          "확인",
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 20.w,
                            color: Color(0xff393838),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 62.w,
                    ),
                    Container(
                      width: 150.w,
                      height: 50.w,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border:
                              Border.all(color: Color(0xffA666FB), width: 1.w),
                          borderRadius:
                              BorderRadius.all(Radius.circular(10.w))),
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.transparent),
                          elevation: MaterialStateProperty.all(0),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          "취소",
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 20.w,
                            color: Color(0xff393838),
                          ),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        );
      });
}

class MessageToParent extends StatefulWidget {
  const MessageToParent({Key? key}) : super(key: key);

  @override
  State<MessageToParent> createState() => _MessageToParentState();
}

class _MessageToParentState extends State<MessageToParent> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
        elevation: 8,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.w))),
        child: Container(
          width: 550.w,
          height: 285.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20.w)),
            border: Border.all(width: 1.w, color: Color(0xFF7649B7)),
            color: Color(0xffE2D3FE),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "현재 학부모 어플과 함께\n개발 중인 기능입니다.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22.w,
                  fontWeight: FontWeight.w500,
                  color: Color(0xff393838),
                ),
              ),
              SizedBox(
                height: 60.w,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // SizedBox(width: 80.w),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('확인',
                        style: TextStyle(
                            fontSize: 20.sp, fontWeight: FontWeight.w400)),
                    style: ElevatedButton.styleFrom(
                        elevation: 1.0,
                        primary: const Color(0xFFFFFFFF),
                        onPrimary: const Color(0xFF393838),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.w)),
                        side: const BorderSide(color: Color(0xFFA666FB)),
                        fixedSize: Size(150.w, 50.w)),
                  ),
                  SizedBox(width: 50.w),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('취소',
                        style: TextStyle(
                            fontSize: 20.sp, fontWeight: FontWeight.w400)),
                    style: ElevatedButton.styleFrom(
                        elevation: 1.0,
                        primary: const Color(0xFFFFFFFF),
                        onPrimary: const Color(0xFF393838),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.w)),
                        side: const BorderSide(color: Color(0xFFA666FB)),
                        fixedSize: Size(150.w, 50.w)),
                  ),
                ],
              ),
              SizedBox(
                height: 35.w,
              )
            ],
          ),
        ));
  }
}
