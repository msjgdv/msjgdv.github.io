import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/app_management.dart';
import 'login_route.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PatternLock extends StatefulWidget {
  const PatternLock({Key? key,
    required this.height,
    required this.width,
    required this.settingPassword,
  }) : super(key: key);
  final double width;
  final double height;
  final Function(String) settingPassword;

  @override
  State<PatternLock> createState() => _PatternLockState();
}

class _PatternLockState extends State<PatternLock> {
  List<PatternDot> patternDotList = [];
  String password = '';
  // List<int> passwordO = [1,4,5,3];
  List<GlobalKey> globalKey = [];
  List<Offset> dotPosition = [];
  List<Offset> drawLineStart = [];
  List<Offset> drawLineEnd = [];
  GlobalKey globalKeyThisWidget = GlobalKey();

  _getPosition(GlobalKey key) {
    if (key.currentContext != null) {
      final RenderBox renderBox =
      key.currentContext!.findRenderObject() as RenderBox;
      final position = renderBox.localToGlobal(Offset.zero);
      return position;
    }
  }

  drawLine(){
    setState(() {
      for(int i = 0;i<9;i++){
        if(drawLineEnd.last > dotPosition[i] && drawLineEnd.last < dotPosition[i] + Offset(50.w,50.w)){
          if(patternDotList[i].state == 0){
            if(drawLineStart.length == 0){
              drawLineStart.add(dotPosition[i]+Offset(25.w,25.w));
              password = password + i.toString();
            }else{
              drawLineEnd.last =dotPosition[i]+Offset(25.w,25.w);
              drawLineStart.add(dotPosition[i]+Offset(25.w,25.w));
              drawLineEnd.add(drawLineEnd.last);
              password = password + i.toString();
            }
            patternDotList[i] = PatternDot(state: 1, globalKey: globalKey[i],);
          }
        }
      }
    });
  }

  @override
  void initState() {
    for(int i = 0;i<9;i++){
      globalKey.add(GlobalKey());
      dotPosition.add(Offset.zero);
    }
    patternDotList = [
      for(int i = 0; i< 9;i++)...[
        PatternDot(state: 0, globalKey: globalKey[i]),
      ]
    ];

    // Future.delayed(const Duration(milliseconds: 300), () {
    //   setState(() {
    //     a = _getPosition(globalKeyThisWidget);
    //     print(a);
    //     for(int i = 0; i< 9;i++){
    //       dotPosition[i] = _getPosition(globalKey[i])
    //           - Offset(a.dx,a.dy);
    //
    //     }
    //   });
    // });
    // WidgetsBinding.instance?.addPostFrameCallback(_afterLayout);

    // TODO: implement initState
    super.initState();
  }
  Offset a = Offset.zero;
  _afterLayout(_) {
    a = _getPosition(globalKeyThisWidget);
    for(int i = 0; i< 9;i++){
      dotPosition[i] = _getPosition(globalKey[i])
          - Offset(a.dx,a.dy);
    }
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback(_afterLayout);
    return Container(
      key: globalKeyThisWidget,
      height: widget.height,
      width: widget.width,
      color: Color(0xffFCF9F4),
      child: Stack(
        children: [
          for(int i = 0 ;i< drawLineStart.length;i++)...[
            CustomPaint(
              size: Size(widget.width,widget.height),
              painter: MyPainter(lineStart : drawLineStart[i], lineEnd: drawLineEnd[i]),
            ),
          ],
          Center(
            child: GestureDetector(
              onPanStart: (DragStartDetails dragStartDetails) {
                setState(() {
                  if(drawLineStart.length == 0){
                    drawLineEnd.add(dragStartDetails.globalPosition
                        - Offset(a.dx,a.dy));
                  }
                });
              },
              onPanUpdate: (DragUpdateDetails dragUpdateDetails) {
                setState(() {
                  drawLineEnd.last = dragUpdateDetails.globalPosition
                      - Offset(a.dx,a.dy);
                  drawLine();
                });
              },
              onPanEnd: (DragEndDetails dragEndDetails){
                setState(() {
                  drawLineEnd.clear();
                  drawLineStart.clear();
                  for(int i = 0;i<9;i++){
                      patternDotList[i] = PatternDot(state: 0, globalKey: globalKey[i],);
                  }
                  if(password.length>1){
                    widget.settingPassword(password);
                  }
                  password= '';
                });
              },

              child: Container(
                color: Colors.transparent,
                height: widget.height,
                width: widget.width,
                child: Stack(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        for (int i = 0; i < 3; i++) ...[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              for (int j = 0; j < 3; j++) ...[
                                patternDotList[i * 3 + j],
                              ]
                            ],
                          ),
                        ]
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
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
      ..color = Color(0xffFBB348)
      ..strokeWidth = 5.w
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(p1, p2, paint);
  }

  @override
  bool shouldRepaint(CustomPainter old) {
    return true;
  }
}

class PatternDot extends StatefulWidget {
  const PatternDot({
    Key? key,
    required this.state,
    required this.globalKey,
  }) : super(key: key);
  final int state;
  final GlobalKey globalKey;

  @override
  State<PatternDot> createState() => _PatternDotState();
}

class _PatternDotState extends State<PatternDot> {
  List<Color> dotColor = [

    Color(0xffFED796),
    Color(0xffFBB348),
    Color(0xffA666FB),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      key: widget.globalKey,
      width: 50.w,
      height: 50.w,
      child: Center(
        child: Container(
          width: 30.w,
          height: 30.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: dotColor[widget.state],
          ),
        ),
      ),
    );
  }
}
