import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:treasure_map/api/activity.dart';
import 'package:treasure_map/widgets/api.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../provider/app_management.dart';
import '../widgets/custom_container.dart';
import '../widgets/overtab.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class C4 extends StatefulWidget {
  const C4({
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
  State<C4> createState() => _C4State();
}

class _C4State extends State<C4> {
  bool dateOn = true;

  List<GetMealData> childMealData = [];


  getChildMealData() async {
    ApiUrl apiUrl = ApiUrl();
    http.Response mealRes = await api(apiUrl.meal + '/' + Provider.of<UserInfo>(context, listen: false).value[0].toString() + '/' + pageTimeStr, 'get', 'signInToken', {}, context);
    if(mealRes.statusCode == 200){
      var mealRB = utf8.decode(mealRes.bodyBytes);
      var mealData = jsonDecode(mealRB);
      childMealData.clear();
        setState(() {
          for (int i = 0; i < mealData.length; i++) {
            List<double> graphData = [];
            for(int j = 0; j< mealData[i]['graph'].length;j++){
              graphData.add(mealData[i]['graph'][j].toDouble());
            }
            childMealData.add(GetMealData(
                id: mealData[i]['id'],
                name: mealData[i]['name'],
                graph: graphData,
                value: mealData[i]['value'].toDouble()));
          }
        });

    }
  }

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

    //......
    setState(() {
      getChildMealData();
      //데이터 넣어주기
      //ex) data = response["data"];
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
                  for (int i = 0; i < childMealData.length ~/ 2; i++) ...[
                    Row(
                      children: [
                        Container(
                          width: 39.w,
                          height: 418.w,
                          color: Color(0xfffcfcfc),
                        ),
                        MealTable(
                          name: childMealData[i * 2 + 0].name,
                          identification: childMealData[i * 2 + 0].id,
                          mealAmount: childMealData[i * 2 + 0].value,
                          recentMealAmount: childMealData[i * 2 + 0].graph,
                          date: pageTime,
                          dateStr: pageTimeStr,
                          receiveData: receiveData,
                        ),
                        //i * 2 + 0
                        SizedBox(
                          width: 50.w,
                        ),
                        MealTable(
                          name: childMealData[i * 2 + 1].name,
                          identification: childMealData[i * 2 + 1].id,
                          mealAmount: childMealData[i * 2 + 1].value,
                          recentMealAmount: childMealData[i * 2 + 1].graph,
                          date: pageTime,
                          dateStr: pageTimeStr,
                          receiveData: receiveData,
                        ),
                        //i * 2 + 1
                      ],
                    ),
                    if (i != childMealData.length ~/ 2 - 1) ...[
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
                    ]
                  ],
                  for (int i = 0; i < childMealData.length % 2; i++) ...[
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
                    )),
                    Row(
                      children: [
                        Container(
                          width: 39.w,
                          height: 418.w,
                          color: Color(0xfffcfcfc),
                        ),
                        MealTable(
                          name: childMealData[childMealData.length - 1].name,
                          identification: childMealData[childMealData.length - 1].id,
                          mealAmount: childMealData[childMealData.length - 1].value,
                          recentMealAmount: childMealData[childMealData.length - 1].graph,
                          date: pageTime,
                          dateStr: pageTimeStr,
                          receiveData: receiveData,
                        ), //childHeadCount - 1
                      ],
                    )
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

class MealTable extends StatefulWidget {
  const MealTable({
    Key? key,
    required this.identification,
    required this.name,
    required this.mealAmount,
    required this.recentMealAmount,
    required this.dateStr,
    required this.date,
    required this.receiveData,
  }) : super(key: key);
  final int identification;
  final String name;
  final double mealAmount;
  final List<double> recentMealAmount;
  final DateTime date;
  final String dateStr;
  final Function(DateTime) receiveData;

  @override
  State<MealTable> createState() => _MealTableState();
}

class _MealTableState extends State<MealTable> {
  double borderWidth = 2.w;
  List<Color> gradientColors = [
    const Color(0xff2481DB),
    const Color(0xff39E6C4),
  ];
  bool showAvg = false;

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: Column(children: [
        Row(
          children: [
            Container(
              width: 90.w,
              height: 50.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(20.w)),
                border:
                    Border.all(width: borderWidth, color: Color(0x4DFDB43B)),
                color: Color(0xffFFEFD3),
              ),
              child: Center(
                  child: DefaultTextStyle(
                text: "유아명",
              )),
            ),
            CustomContainer(
              cTotalHeight: 50.w,
              cTotalWidth: 410.w,
              cBottomBorderWidth: borderWidth,
              cRightBorderWidth: borderWidth,
              cTopBorderWidth: borderWidth,
              cBorderColor: Color(0x6DFDB43B),
              cInsideColor: Color(0xffffefd3),
              cBorderRadius: BorderRadius.only(topRight: Radius.circular(20.w)),
              childWidget: Center(
                child: DefaultTextStyle(
                  text: '식사량 수준',
                ),
              ),
            ),
          ],
        ),
        Row(
          children: [
            CustomContainer(
              cTotalHeight: 100.w,
              cTotalWidth: 90.w,
              cLeftBorderWidth: borderWidth,
              cRightBorderWidth: borderWidth,
              cBorderColor: Color(0x6DFDB43B),
              cInsideColor: Color(0xffffffff),
              childWidget: Center(
                child: DefaultTextStyle(
                  text: widget.name,
                ),
              ),
            ),
            CustomContainer(
              cTotalHeight: 100.w,
              cTotalWidth: 410.w,
              cRightBorderWidth: borderWidth,
              cBorderColor: Color(0x6DFDB43B),
              cInsideColor: Color(0xffffffff),
              childWidget: Column(
                children: [
                  SizedBox(
                    height: 13.w,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MealButton(
                          buttonNumber: 0,
                          buttonOnOff: widget.mealAmount == 0 ? true : false,
                          identification: widget.identification, date: widget.date, receiveData: widget.receiveData, dateStr: widget.dateStr,  ),
                      MealButton(
                          buttonNumber: 0.5,
                          buttonOnOff: widget.mealAmount == 0.5 ? true : false,
                          identification: widget.identification, date: widget.date, receiveData: widget.receiveData, dateStr: widget.dateStr,),
                      MealButton(
                          buttonNumber: 1,
                          buttonOnOff: widget.mealAmount == 1 ? true : false,
                          identification: widget.identification, date: widget.date, receiveData: widget.receiveData, dateStr: widget.dateStr,),
                      MealButton(
                        buttonNumber: 1.5,
                        buttonOnOff: widget.mealAmount == 1.5 ? true : false,
                        identification: widget.identification, date: widget.date, receiveData: widget.receiveData, dateStr: widget.dateStr,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        Container(
          width: 499.w,
          height: 50.w,
          decoration: BoxDecoration(
            border: Border.all(width: borderWidth, color: Color(0x4DFDB43B)),
            color: Color(0xffFFEFD3),
          ),
          child: Center(
              child: DefaultTextStyle(
            text: "최근 식사량 수집결과", // 30일 전 데이터 부터 가져와서 표기
          )),
        ),
        CustomContainer(
          cTotalHeight: 218.w,
          cTotalWidth: 499.w,
          cRightBorderWidth: borderWidth,
          cLeftBorderWidth: borderWidth,
          cBottomBorderWidth: borderWidth,
          cBorderRadius: BorderRadius.only(
              bottomRight: Radius.circular(20.w),
              bottomLeft: Radius.circular(20.w)),
          cBorderColor: Color(0x6DFDB43B),
          cInsideColor: Color(0xffffffff),
          childWidget: Center(
            child: Container(
              width: 480.w,
              height: 200.w,
              child: LineChart(
                mainData(),
              ),
            ),
          ),
        ),
      ]),
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    TextStyle style = TextStyle(
      color: Color(0xff393838),
      fontWeight: FontWeight.w400,
      fontSize: 14.w,
    );
    Widget text;
    switch (value.toInt()) {
      case 0:
        text = Text('', style: style);
        break;
      default:
        text = Text('', style: style);
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 30.0.w,
      child: text,
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    TextStyle style = TextStyle(
      color: Color(0xff393838),
      fontWeight: FontWeight.w400,
      fontSize: 14.w,
    );
    String text;
    switch ((value*10).toInt()) {
      case 0:
        text = '안했음';
        break;
      case 5:
        text = '조금';
        break;
      case 10:
        text = '보통';
        break;
      case 15:
        text = '많이';
        break;
      default:
        return Container();
    }
    return Text(text, style: style, textAlign: TextAlign.left);
  }

  LineChartData mainData() {
    return LineChartData(
      lineTouchData: LineTouchData(
          enabled: true,
          touchTooltipData: LineTouchTooltipData(
              tooltipBgColor: Color(0xffA666FB),
              getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                return touchedBarSpots.map((barSpot) {
                  final flSpot = barSpot;
                  return LineTooltipItem(
                    '',
                    const TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                    children: [
                      if (flSpot.y == 0) ...[
                        TextSpan(
                          text: '안했음',
                          style: TextStyle(
                            color: Color(0xffffffff),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ] else if (flSpot.y == 0.5) ...[
                        TextSpan(
                          text: '조금',
                          style: TextStyle(
                            color: Color(0xffffffff),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ] else if (flSpot.y == 1) ...[
                        TextSpan(
                          text: '보통',
                          style: TextStyle(
                            color: Color(0xffffffff),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ] else if (flSpot.y == 1.5) ...[
                        TextSpan(
                          text: '많이',
                          style: TextStyle(
                            color: Color(0xffffffff),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ]
                    ],
                  );
                }).toList();
              })),
      gridData: FlGridData(
        show: false,
        drawVerticalLine: false,
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 40.w,
            interval: 1,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 0.5,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 50.w,
          ),
        ),
      ),
      borderData: FlBorderData(
          show: false,
          border: Border.all(color: const Color(0xff37434d), width: 1)),
      minX: 0,
      maxX: widget.recentMealAmount.length.toDouble() - 1,
      minY: 0,
      maxY: 2,
      lineBarsData: [
        LineChartBarData(
          spots: [
            for (int i = 0; i < widget.recentMealAmount.length; i++) ...[
              FlSpot(i.toDouble(), widget.recentMealAmount[i].toDouble()),
            ],
          ],
          isCurved: false,
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          barWidth: 3.w,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: false,
            gradient: LinearGradient(
              colors: [Colors.transparent, Colors.transparent],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        ),
      ],
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
        fontSize: 14.w,
        fontWeight: FontWeight.w400,
      ),
      textAlign: TextAlign.center,
    );
  }
}

class MealButton extends StatefulWidget {
  const MealButton({
    Key? key,
    required this.buttonNumber,
    required this.buttonOnOff,
    required this.identification,
    required this.receiveData,
    required this.date,
    required this.dateStr,
  }) : super(key: key);
  final double buttonNumber;
  final bool buttonOnOff;
  final int identification;
  final String dateStr;
  final Function(DateTime) receiveData;
  final DateTime date;

  @override
  State<MealButton> createState() => _MealButtonState();
}

class _MealButtonState extends State<MealButton> {
  ApiUrl apiUrl = ApiUrl();

  List<String> mealImageUrl = [
    "assets/icons/icon_meal_1.svg",
    "assets/icons/icon_meal_2.svg",
    "assets/icons/icon_meal_3.svg",
    "assets/icons/icon_meal_4.svg"
  ];
  List<String> mealAmountText = [
    "안했음",
    "조금",
    "보통",
    "많이",
  ];

  postMealData(int id, int cid, String dateStr, double value, Function(DateTime) receiveData, DateTime date) async {
    http.Response mealRes = await api(apiUrl.meal, 'post', 'signInToken', {
      "id": id.toString(),
      "cid": cid.toString(),
      "date": dateStr,
      "value": value.toString()
    }, context);
    if(mealRes.statusCode == 200){
      receiveData(date);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        widget.buttonOnOff == true
            ? Stack(
                children: [
                  Container(
                    width: 85.w,
                    height: 50.w,
                    margin: EdgeInsets.symmetric(horizontal: 8.w),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10.w)),
                      color: Color(0x29919191),
                    ),
                    child: Container(
                      decoration: BoxDecoration(boxShadow: [
                        BoxShadow(
                          color: Color(0xffffffff),
                          offset: Offset(0, 0),
                          blurRadius: 4,
                          spreadRadius: -5.0,
                        )
                      ]),
                    ),
                  ),
                  Positioned(
                      top: 3.w,
                      left: 3.w,
                      child: Container(
                          width: 82.w,
                          height: 47.w,
                          margin: EdgeInsets.symmetric(horizontal: 8.w),
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.w)),
                            color: Color(0xfff9f9f9),
                          ))),
                  Container(
                    width: 85.w,
                    height: 50.w,
                    margin: EdgeInsets.symmetric(horizontal: 8.w),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10.w)),
                      border: Border.all(color: Color(0x4DFDB43B)),
                      color: Colors.transparent,
                    ),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.w),
                        )),
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.transparent),
                        // shadowColor: MaterialStateProperty.all<Color>(Color(0x29919191)),
                        elevation: MaterialStateProperty.all(0),
                      ),
                      onPressed: () {
                        //api 보내는 곳임
                      },
                      child: SvgPicture.asset(
                        mealImageUrl[widget.buttonNumber ==  0 ? 0 : widget.buttonNumber ==  0.5 ? 1 : widget.buttonNumber ==  1 ? 2 : 3],
                        width: 44.w,
                        height: 40.w,
                      ),
                    ),
                  ),
                ],
              )
            : Container(
                width: 85.w,
                height: 50.w,
                margin: EdgeInsets.symmetric(horizontal: 8.w),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10.w)),
                    border: Border.all(color: Color(0x4DFDB43B)),
                    color: Color(0xffffffff),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x29919191),
                        offset: Offset(3, 3),
                        blurRadius: 4,
                      )
                    ]),
                child: ElevatedButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.w),
                    )),
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Color(0xffffffff)),
                    elevation: MaterialStateProperty.all(0),
                  ),
                  onPressed: () {
                    postMealData(widget.identification, Provider.of<UserInfo>(context, listen: false).value[0], widget.dateStr, widget.buttonNumber, widget.receiveData, widget.date);
                    //api 보내는 곳임
                    // print(mealAmountText[widget.buttonNumber]);
                  },
                  child: SvgPicture.asset(
                    mealImageUrl[widget.buttonNumber ==  0 ? 0 : widget.buttonNumber ==  0.5 ? 1 : widget.buttonNumber ==  1 ? 2 : 3],
                    width: 44.w,
                    height: 40.w,
                  ),
                ),
              ),
        SizedBox(
          height: 6.w,
        ),
        DefaultTextStyle(text: mealAmountText[widget.buttonNumber ==  0 ? 0 : widget.buttonNumber ==  0.5 ? 1 : widget.buttonNumber ==  1 ? 2 : 3]),
      ],
    );
  }
}
