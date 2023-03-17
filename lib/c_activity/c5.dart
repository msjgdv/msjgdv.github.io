import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:treasure_map/api/activity.dart';
import 'package:treasure_map/widgets/api.dart';
import 'package:treasure_map/widgets/custom_container.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../provider/app_management.dart';
import '../widgets/overtab.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../widgets/token_time_over.dart';

class C5 extends StatefulWidget {
  const C5({
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
  State<C5> createState() => _C5State();
}

class _C5State extends State<C5> {
  bool dateOn = true;
  List<GetNapData> childNapData = [];

  getChildNapData() async {

    ApiUrl apiUrl = ApiUrl();
    http.Response napRes = await api(apiUrl.nap + '/' + Provider.of<UserInfo>(context, listen: false).value[0].toString() + '/' + pageTimeStr, 'get', 'signInToken', {}, context);
    if(napRes.statusCode == 200){

      var napRB = utf8.decode(napRes.bodyBytes);
      var napData = jsonDecode(napRB);
      childNapData.clear();
      setState(() {
        for (int i = 0; i < napData.length; i++) {
          List<double> graphData = [];
          for(int j = 0; j< napData[i]['graph'].length;j++){
            graphData.add(napData[i]['graph'][j].toDouble());
          }
          childNapData.add(GetNapData(
              id: napData[i]['id'],
              name: napData[i]['name'],
              graph: graphData,
              value: napData[i]['value'].toDouble()));
          // print(response[i].value);
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
      getChildNapData();
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
                  for (int i = 0; i < childNapData.length ~/ 2; i++) ...[
                    Row(
                      children: [
                        Container(
                          width: 39.w,
                          height: 425.w,
                          color: Color(0xfffcfcfc),
                        ),
                        NapTable(
                          getNapData: childNapData[i * 2 + 0],
                          receiveData: receiveData,
                          date: pageTime,
                          dateStr: pageTimeStr,
                        ),
                        SizedBox(
                          width: 30.w,
                        ),
                        NapTable(
                          getNapData: childNapData[i * 2 + 1],
                          receiveData: receiveData,
                          date: pageTime,
                          dateStr: pageTimeStr,
                        ),
                      ],
                    ),
                    if (i != childNapData.length ~/ 2 - 1) ...[
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
                  for (int i = 0; i < childNapData.length % 2; i++) ...[
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
                          height: 425.w,
                          color: Color(0xfffcfcfc),
                        ),
                        NapTable(
                          getNapData: childNapData[childNapData.length-1],
                          receiveData: receiveData,
                          date: pageTime,
                          dateStr: pageTimeStr,
                        ),
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

class NapTable extends StatefulWidget {
  const NapTable({
    Key? key,
    required this.getNapData,
    required this.dateStr,
    required this.date,
    required this.receiveData,

  }) : super(key: key);
  final GetNapData getNapData;
  final String dateStr;
  final DateTime date;
  final Function(DateTime) receiveData;

  @override
  State<NapTable> createState() => _NapTableState();
}

class _NapTableState extends State<NapTable> {
  double borderWidth = 2.w;
  List<Color> gradientColors = [
    const Color(0xff2481DB),
    const Color(0xff39E6C4),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20.w)),
          boxShadow: [
            BoxShadow(
              color: const Color(0x29B1B1B1),
              blurRadius: 6,
              offset: Offset(-2, 2),
            )
          ]),
      child: Column(
        children: [
          Row(
            children: [
              Column(
                children: [
                  Container(
                    width: 90.w,
                    height: 69.w,
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.only(topLeft: Radius.circular(20.w)),
                      border: Border.all(
                          width: borderWidth, color: Color(0x4DFDB43B)),
                      color: Color(0xffFFEFD3),
                    ),
                    child: Center(
                        child: DefaultTextStyle(
                      text: "유아명",
                    )),
                  ),
                  CustomContainer(
                    cLeftBorderWidth: borderWidth,
                    cRightBorderWidth: borderWidth,
                    cBottomBorderWidth: borderWidth,
                    cTotalWidth: 90.w,
                    cTotalHeight: 92.w,
                    cBorderColor: Color(0x6DFDB43B),
                    cInsideColor: Color(0xffffffff),
                    childWidget: Center(
                      child: DefaultTextStyle(
                        text: widget.getNapData.name,
                      ),
                    ),
                  )
                ],
              ),
              Column(
                children: [
                  CustomContainer(
                    cTotalHeight: 30.w,
                    cTotalWidth: 420.w,
                    cBottomBorderWidth: borderWidth,
                    cRightBorderWidth: borderWidth,
                    cTopBorderWidth: borderWidth,
                    cBorderRadius:
                        BorderRadius.only(topRight: Radius.circular(20.w)),
                    cBorderColor: Color(0x6DFDB43B),
                    cInsideColor: Color(0xfffffdf8),
                    childWidget: DefaultTextStyle(
                      text: '낮잠시간',
                    ),
                  ),
                  Row(
                    children: [
                      Column(
                        children: [
                          CustomContainer(
                            cTotalWidth: 70.w,
                            cTotalHeight: 71.w,
                            cRightBorderWidth: borderWidth,
                            cBottomBorderWidth: borderWidth,
                            cBorderColor: Color(0x6DFDB43B),
                            cInsideColor: Color(0xffFFEFD3),
                            childWidget: Center(
                              child: DefaultTextStyle(
                                text: '낮잠 거부',
                              ),
                            ),
                          ),
                          CustomContainer(
                            cTotalWidth: 70.w,
                            cTotalHeight: 60.w,
                            cBottomBorderWidth: borderWidth,
                            cRightBorderWidth: borderWidth,
                            cBorderColor: Color(0x6DFDB43B),
                            cInsideColor: Color(0xffffffff),
                            childWidget: Center(
                              child: NapButton(
                                  buttonNumber: 0,
                                  buttonOnOff:
                                  widget.getNapData.value == 0 ? true : false,
                                  identification: widget.getNapData.id,
                                receiveData: widget.receiveData,
                                date: widget.date,
                                dateStr: widget.dateStr,),
                            ),
                          )
                        ],
                      ),
                      Column(
                        children: [
                          CustomContainer(
                            cTotalWidth: 70.w,
                            cTotalHeight: 71.w,
                            cRightBorderWidth: borderWidth,
                            cBottomBorderWidth: borderWidth,
                            cBorderColor: Color(0x6DFDB43B),
                            cInsideColor: Color(0xffFFEFD3),
                            childWidget: Center(
                              child: DefaultTextStyle(
                                text: '1시간 미만',
                              ),
                            ),
                          ),
                          CustomContainer(
                            cTotalWidth: 70.w,
                            cTotalHeight: 60.w,
                            cBottomBorderWidth: borderWidth,
                            cRightBorderWidth: borderWidth,
                            cBorderColor: Color(0x6DFDB43B),
                            cInsideColor: Color(0xffffffff),
                            childWidget: Center(
                              child: NapButton(
                                  buttonNumber: 0.5,
                                  buttonOnOff:
                                  widget.getNapData.value == 0.5 ? true : false,
                                  identification: widget.getNapData.id,
                                receiveData: widget.receiveData,
                                date: widget.date,
                                dateStr: widget.dateStr,),
                            ),
                          )
                        ],
                      ),
                      Column(
                        children: [
                          CustomContainer(
                            cTotalWidth: 70.w,
                            cTotalHeight: 71.w,
                            cRightBorderWidth: borderWidth,
                            cBottomBorderWidth: borderWidth,
                            cBorderColor: Color(0x6DFDB43B),
                            cInsideColor: Color(0xffFFEFD3),
                            childWidget: Center(
                              child: DefaultTextStyle(
                                text: '1시간 -\n1시간 30분',
                              ),
                            ),
                          ),
                          CustomContainer(
                            cTotalWidth: 70.w,
                            cTotalHeight: 60.w,
                            cBottomBorderWidth: borderWidth,
                            cRightBorderWidth: borderWidth,
                            cBorderColor: Color(0x6DFDB43B),
                            cInsideColor: Color(0xffffffff),
                            childWidget: Center(
                              child: NapButton(
                                  buttonNumber:1,
                                  buttonOnOff:
                                  widget.getNapData.value == 1 ? true : false,
                                  identification: widget.getNapData.id,
                                receiveData: widget.receiveData,
                                date: widget.date,
                                dateStr: widget.dateStr,),
                            ),
                          )
                        ],
                      ),
                      Column(
                        children: [
                          CustomContainer(
                            cTotalWidth: 70.w,
                            cTotalHeight: 71.w,
                            cRightBorderWidth: borderWidth,
                            cBottomBorderWidth: borderWidth,
                            cBorderColor: Color(0x6DFDB43B),
                            cInsideColor: Color(0xffFFEFD3),
                            childWidget: Center(
                              child: DefaultTextStyle(
                                text: '1시간 30분\n- 2시간',
                              ),
                            ),
                          ),
                          CustomContainer(
                            cTotalWidth: 70.w,
                            cTotalHeight: 60.w,
                            cBottomBorderWidth: borderWidth,
                            cRightBorderWidth: borderWidth,
                            cBorderColor: Color(0x6DFDB43B),
                            cInsideColor: Color(0xffffffff),
                            childWidget: Center(
                              child: NapButton(
                                  buttonNumber: 1.5,
                                  buttonOnOff:
                                  widget.getNapData.value == 1.5 ? true : false,
                                  identification: widget.getNapData.id,
                                receiveData: widget.receiveData,
                                date: widget.date,
                                dateStr: widget.dateStr,),
                            ),
                          )
                        ],
                      ),
                      Column(
                        children: [
                          CustomContainer(
                            cTotalWidth: 70.w,
                            cTotalHeight: 71.w,
                            cRightBorderWidth: borderWidth,
                            cBottomBorderWidth: borderWidth,
                            cBorderColor: Color(0x6DFDB43B),
                            cInsideColor: Color(0xffFFEFD3),
                            childWidget: Center(
                              child: DefaultTextStyle(
                                text: '2시간 -\n2시간 30분',
                              ),
                            ),
                          ),
                          CustomContainer(
                            cTotalWidth: 70.w,
                            cTotalHeight: 60.w,
                            cBottomBorderWidth: borderWidth,
                            cRightBorderWidth: borderWidth,
                            cBorderColor: Color(0x6DFDB43B),
                            cInsideColor: Color(0xffffffff),
                            childWidget: Center(
                              child: NapButton(
                                  buttonNumber: 2,
                                  buttonOnOff:
                                  widget.getNapData.value == 2 ? true : false,
                                  identification: widget.getNapData.id,
                                receiveData: widget.receiveData,
                                date: widget.date,
                                dateStr: widget.dateStr,),
                            ),
                          )
                        ],
                      ),
                      Column(
                        children: [
                          CustomContainer(
                            cTotalWidth: 70.w,
                            cTotalHeight: 71.w,
                            cRightBorderWidth: borderWidth,
                            cBottomBorderWidth: borderWidth,
                            cBorderColor: Color(0x6DFDB43B),
                            cInsideColor: Color(0xffFFEFD3),
                            childWidget: Center(
                              child: DefaultTextStyle(
                                text: '2시간 30분이상',
                              ),
                            ),
                          ),
                          CustomContainer(
                            cTotalWidth: 70.w,
                            cTotalHeight: 60.w,
                            cBottomBorderWidth: borderWidth,
                            cRightBorderWidth: borderWidth,
                            cBorderColor: Color(0x6DFDB43B),
                            cInsideColor: Color(0xffffffff),
                            childWidget: Center(
                              child: NapButton(
                                  buttonNumber: 2.5,
                                  buttonOnOff:
                                  widget.getNapData.value == 2.5 ? true : false,
                                  identification: widget.getNapData.id,
                              receiveData: widget.receiveData,
                              date: widget.date,
                              dateStr: widget.dateStr,),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          Column(
            children: [
              CustomContainer(
                cTotalHeight: 40.w,
                cTotalWidth: 510.w,
                cBottomBorderWidth: borderWidth,
                cRightBorderWidth: borderWidth,
                cLeftBorderWidth: borderWidth,
                cInsideColor: Color(0xffFFEFD3),
                cBorderColor: Color(0x6dFBB348),
                childWidget: Center(
                  child: DefaultTextStyle(
                    text: '최근 낮잠량 그래프',
                  ),
                ),
              ),
              CustomContainer(
                cTotalHeight: 229.w,
                cTotalWidth: 510.w,
                cBottomBorderWidth: borderWidth,
                cRightBorderWidth: borderWidth,
                cLeftBorderWidth: borderWidth,
                cBorderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(
                      20.w,
                    ),
                    bottomRight: Radius.circular(20.w)),
                cInsideColor: Color(0xffffffff),
                cBorderColor: Color(0x6dFBB348),
                childWidget: LineChart(mainData()),
              ),
            ],
          )
        ],
      ),
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
        text = '0';
        break;
      case 5:
        text = '~ 1';
        break;
      case 10:
        text = '1 ~ 1.5';
        break;
      case 15:
        text = '1.5 ~ 2';
        break;
      case 20:
        text = '2 ~ 2.5';
        break;
      case 25:
        text = '2.5 ~';
        break;
      case 30:
        text = '단위 : 시간';
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
                          text: '낮잠 거부',
                          style: TextStyle(
                            color: Color(0xffffffff),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ] else if (flSpot.y == 0.5) ...[
                        TextSpan(
                          text: '1시간 이하',
                          style: TextStyle(
                            color: Color(0xffffffff),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ] else if (flSpot.y == 1) ...[
                        TextSpan(
                          text: '1시간 - 1시간 30분',
                          style: TextStyle(
                            color: Color(0xffffffff),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ] else if (flSpot.y == 1.5) ...[
                        TextSpan(
                          text: '1시간 30분 - 2시간',
                          style: TextStyle(
                            color: Color(0xffffffff),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ] else if (flSpot.y == 2) ...[
                        TextSpan(
                          text: '2시간 - 2시간 30분',
                          style: TextStyle(
                            color: Color(0xffffffff),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ] else if (flSpot.y == 2.5) ...[
                        TextSpan(
                          text: '2시간 30분 이상',
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
            showTitles: false,
            interval: 1,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 70.w,
          ),
        ),
      ),
      borderData: FlBorderData(
          show: false,
          border: Border.all(color: const Color(0xff37434d), width: 1)),
      minX: 0,
      maxX: widget.getNapData.graph.length.toDouble() - 1,
      minY: 0,
      maxY: 3,
      lineBarsData: [
        LineChartBarData(
          spots: [
            for (int i = 0; i < widget.getNapData.graph.length; i++) ...[
              FlSpot(i.toDouble(), widget.getNapData.graph[i].toDouble()),
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

class NapButton extends StatefulWidget {
  const NapButton({
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
  final DateTime date;
  final Function(DateTime) receiveData;

  @override
  State<NapButton> createState() => _NapButtonState();
}

class _NapButtonState extends State<NapButton> {
  static final autoLoginStorage = FlutterSecureStorage();

  postNapData(int id, int cid, String dateStr, double value, Function(DateTime) receiveData, DateTime date) async {
    ApiUrl apiUrl = ApiUrl();
    http.Response napRes = await api(apiUrl.nap, 'post', 'signInToken', {
      "id": id.toString(),
      "cid": cid.toString(),
      "date": dateStr,
      "value": value.toString(),
    }, context);
    if(napRes.statusCode == 200){
      receiveData(date);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: widget.buttonOnOff == true
          ? IconButton(
              onPressed: () {},
              icon: Icon(Icons.check),
            )
          : TextButton(
              onPressed: () {
                postNapData(widget.identification, Provider.of<UserInfo>(context, listen: false).value[0], widget.dateStr, widget.buttonNumber, widget.receiveData, widget.date);
                //버튼 번호 api보내기
              },
              child: Text("     ")),
    );
  }
}
