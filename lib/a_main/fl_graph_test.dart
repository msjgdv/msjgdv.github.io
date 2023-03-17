import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:math' as math;
import 'package:fl_chart/fl_chart.dart';

class GraphTest extends StatefulWidget {
  const GraphTest({Key? key}) : super(key: key);

  @override
  State<GraphTest> createState() => _GraphTestState();
}

class _GraphTestState extends State<GraphTest> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.blueGrey,
        child: Center(
          child: Container(
            width: 800.w,
            height: 500.w,
            decoration: BoxDecoration(
              border: Border.all(width: 1.w, color: Color(0xff222222)),
              borderRadius: BorderRadius.all(Radius.circular(20.w)),
              color: Colors.white,
            ),
            child: GraphSet(), //등원 유아 수 그래프입니다.(이건 잘 못하겠어요)
            // child: BarChartSample1(), //그래프 그리는 함수임미다.(주석에 설명 달아놨습니다. 이것먼저 보시는 것 추천드려요)

            ),
          ),

      ),
    );
  }
}

class GraphSet extends StatefulWidget {
  const GraphSet({Key? key}) : super(key: key);

  @override
  State<GraphSet> createState() => _GraphSetState();
}

class _GraphSetState extends State<GraphSet> {
  double degrees = 90;
  double radians = 0;

  @override
  void initState() {
    super.initState();
    radians = degrees * math.pi / 180;
  }

  @override
  Widget build(BuildContext context) {
    //몇번 만져보시면 알겠지만 그래프가 참 짜증나게 굽니다.
    //일단 만들어놓고 Stack - Positioned 로 그냥 위치에다가 아이 얼굴이나 이름, 퍼센테이지 넣는게 좋을 거같아요.

    double value = 50;
    return Stack(
      children: [
        Positioned(
          top: 50.w,
          left: 100.w,
          child: Container(
            height: 30.w,
            width: 30.w,
            color: Colors.red,
          ),
        ),
        Positioned(
          top: 0.w,
          left: 150.w,
          child: Transform.rotate(
            angle: radians,
            child: SizedBox(
              width: 30.w,
              height: 300.w,
              child: BarChartSample2(value: value,),
            ),
          ),
        ),
        Positioned(
          top: 0.w,
          left: 500.w,
          child: Transform.rotate(
            angle: radians,
            child: SizedBox(
              width: 30.w,
              height: 300.w,
              child: BarChartSample2(value: value,),
            ),
          ),
        ),
        Positioned(
          top: 135.w,
          left: 270.w,
          child: Text(value.toString() + '%'),
        ),
        Container(
          height: 30.w,
          width: 30.w,
          color: Colors.red,
        ),


      ],
    );
  }
}


class BarChartSample1 extends StatefulWidget {
  const BarChartSample1({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => BarChartSample1State();
}

class BarChartSample1State extends State<BarChartSample1> {
  //테스트용 데이터 입니다.
  //childHeadCount를 굳이 사용하고 싶지 않으면 api로 데이터 받아와써 asdf.length()를 쓰세용
  int childHeadCount = 8;
  List<String> childClassName = [
    '가나다',
    '라마바',
    '사아자',
    '차카타',
    '파하가',
    '나다라',
    '마바사',
    '아자차',
    '카타파',
    '하가나',
  ]; //반 이름입니다.
  List<double> chartData = [
    67,
    89,
    30,
    100,
    92,
    94,
    89,
    90
  ]; //퍼센테이지 넣으면 될듯 합니다.

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      //그래프의 배경크기(?)인데 정확한 크기 측정 방법을 모르겠어요
      //그냥 상위 위젯이 500 크기라 거기에 맞춰서 소숫점 바꿔봤습니다.
      aspectRatio: 1.603.w,
      //배경 설정
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18.w),
          color: Color(0xffffffff),
        ),
        //그래프와 그래프 이름
        child: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    '학급별',
                    style: TextStyle(
                      color: Color(0xff0f4a3c),
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 38.w,
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.w),
                      child: BarChart(
                        mainBarData(),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 12.w,
                  ),
                ],
              ),
            ),

            //이걸 제거해보시면 바로 뭔지 아실텐데
            //디자인 상 넣은거라 위치와 크기 디자인 넣을 때 잡아주시면 될듯 합니다.
            Positioned(
                top: 410.w,
                left: 50.w,
                child: Column(
                  children: [
                    Container(
                      height: 2.w,
                      width: 700.w,
                      color: Colors.blue,
                    ),
                    Container(
                      height: 20.w,
                      width: 700.w,
                      color: Colors.white,
                    )
                  ],
                ))
          ],
        ),
      ),
    );
  }

  //그래프 데이터중 막대 그래프 하나입니다
  BarChartGroupData makeGroupData(
    int x,
    double y, {
    // 이부분은 생성자로 사실 안 쓰입니다
    bool isTouched = false,
    Color barColor = Colors.grey,
    double width = 22,
    List<int> showTooltips = const [],
  }) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y, //y값
          color: barColor, //색상
          width: 22.w, //두께
          borderSide: BorderSide(color: Colors.white, width: 0), //몰라요
        ),
      ],
      showingTooltipIndicators: [0],
    );
  }

  //그래프 데이터를 만들때 사용하는 막대그래프에 데이터 넣어주는 역할입니다
  //사람 수만큼 만든다음에
  //데이터를 넣어주면 완성됩니다.
  List<BarChartGroupData> showingGroups() => List.generate(childHeadCount, (i) {
        return makeGroupData(i, chartData[i]);
      });

  //데이터를 표시하는 역할입니다
  //원래는 터치를 해야만 나오는 데이터지만 위에 막대그래프 생성할때 showingTooltipIndicators: [0],로 설정을 해서 항시 표시합니다.
  BarChartData mainBarData() {
    return BarChartData(
      //최대치 설정
      maxY: 100,
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(
          tooltipBgColor: Colors.transparent,
          tooltipMargin: 0.w,
          tooltipPadding: EdgeInsets.only(bottom: 0.w),
          getTooltipItem: (group, groupIndex, rod, rodIndex) {
            //여기에서 몇퍼센트인지 표기를 합니다.
            String attendance = chartData[group.x].toString() + '%';
            //꼭 이 형식을 지켜야 하나 봅니다?
            //아래 children은 없어도 되지만 글씨가 떠서 넣었습니다.
            return BarTooltipItem(
              '',
              TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
                fontSize: 18.sp,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: attendance,
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.sp,
                  ),
                ),
              ],
            );
          },
        ),
      ),
      //그래프의 위아래, 양옆에 데이터를 표기하고 싶으면 각각의 showtitles를 true로 바꿈됩니다.
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
            getTitlesWidget: getTitles,
            reservedSize: 38.w,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: showingGroups(),
      gridData: FlGridData(show: false),
    );
  }

  //아래 반 이름을 나오게 하는 설정입니다.
  //value값은 인원수 만큼 알아서 넣어지더라고요.
  Widget getTitles(double value, TitleMeta meta) {
    TextStyle style = TextStyle(
      color: Color(0xff393838),
      fontWeight: FontWeight.bold,
      fontSize: 14.w,
    );
    Widget text;
    text = Text(childClassName[value.toInt()], style: style);
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 16.w,
      child: text,
    );
  }
}

class BarChartSample2 extends StatefulWidget {
  const BarChartSample2({Key? key,
    required this.value,
  }) : super(key: key);
  final double value;

  @override
  State<StatefulWidget> createState() => BarChartSample2State();
}

class BarChartSample2State extends State<BarChartSample2> {
  final Color barBackgroundColor = const Color(0xff72d8bf);

  @override
  Widget build(BuildContext context) {
    //설명은 위 위젯을 확인하면서 보시면 될듯 합니다.
    return AspectRatio(
      aspectRatio: 0.1.w,
      child: Stack(
        children: <Widget>[
          BarChart(
            mainBarData(),
          ),
        ],
      ),
    );
  }

  BarChartGroupData makeGroupData(
    int x,
    double y, {
    bool isTouched = false,
    Color barColor = Colors.white,
    double width = 22,
    List<int> showTooltips = const [],
  }) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: barColor,
          width: 22.w,
          borderSide: BorderSide(color: Colors.grey, width: 1.w),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: 100,
            color: barBackgroundColor,
          ),
        ),
      ],
    );
  }

  List<BarChartGroupData> showingGroups() => List.generate(1, (i) {
    return makeGroupData(0,widget.value);
      });

  BarChartData mainBarData() {
    return BarChartData(
      alignment: BarChartAlignment.start,
      maxY: 100,
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(
          tooltipBgColor: Colors.blueGrey,
          getTooltipItem: (group, groupIndex, rod, rodIndex) {
          },
        ),
      ),
      titlesData: FlTitlesData(
        show: false,
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
            getTitlesWidget: getTitles,
            reservedSize: 0.w,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: showingGroups(),
      gridData: FlGridData(show: false),
    );
  }

  Widget getTitles(double value, TitleMeta meta) {
    TextStyle style = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 14.w,
    );
    Widget text = Text('', style: style);
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 16,
      child: text,
    );
  }
}
