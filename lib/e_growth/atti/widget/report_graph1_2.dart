import 'dart:math';
import 'dart:math' as math;
import 'package:treasure_map/provider/atti_child_data_management.dart';
import 'package:treasure_map/widgets/id_to.dart';
import 'package:vector_math/vector_math.dart' show radians;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:widget_mask/widget_mask.dart';

class Report3Graph extends StatefulWidget {
  const Report3Graph({
    Key? key,
    required this.inClassNumber,
    required this.arrowDirection,
    required this.childCount,
    required this.linkedChild,
  }) : super(key: key);
  final int childCount;
  final List<int> linkedChild;
  final List<int> arrowDirection;
  final int inClassNumber;

  @override
  State<Report3Graph> createState() => _Report3GraphState();
}

class _Report3GraphState extends State<Report3Graph> {
  final radius = 220;
  double radiusChild = 0;

  @override
  void initState() {

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    radiusChild = 360 / widget.childCount;
    return Container(
        child: Center(
            child: Stack(
      alignment: Alignment.center,
      children: [
        // Text('메인'),
        for (int i = 0; i < widget.childCount; i++) ...[
          Transform(
              transform: Matrix4.identity()
                ..translate(radius.w * cos(radians(radiusChild * i)),
                    radius.w * sin(radians(radiusChild * i))),
              child: PositiveChilds(
                inClassNumber: widget.linkedChild[i],
              )),
          Transform.rotate(
            angle: ((radiusChild) * i * math.pi / 180) + math.pi,
            child: Transform(
                transform: Matrix4.identity()
                  ..translate(
                      0 * cos(radians(radiusChild * i)) - (radius - 50 - 50).w,
                      0 * sin(radians(radiusChild * i))),
                child: Arrow(
                  arrowDirection: widget.arrowDirection[i],
                )),
          ),
        ],
        Stack(
          children: [
            SizedBox(
                width: 100.w,
                height: 114.w,
                child: WidgetMask(
                  blendMode: BlendMode.srcATop,
                  childSaveLayer: true,
                  mask: Provider.of<AttiChildDataManagement>(context,
                          listen: false)
                      .childList[widget.inClassNumber]
                      .childFace,
                  child: Container(
                    width: 100.w,
                    height: 100.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      border: Border.all(width: 1.w, color: Color(0x1AA666FC)),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0x297B7B7B),
                          blurRadius: 4,
                          offset: Offset(3, 3), // changes position of shadow
                        ),
                      ],
                    ),
                  ),
                )),
            Positioned(
                top: 80.w,
                left: 5.w,
                child: Container(
                  width: 90.w,
                  height: 34.w,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(26.w)),
                      color: Color(0xffA666FC)),
                  child: Center(
                    child: Text(
                      Provider.of<AttiChildDataManagement>(context,
                              listen: false)
                          .childList[widget.inClassNumber]
                          .name,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 17.w,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ))
          ],
        ),
      ],
    )));
  }
}

class Arrow extends StatefulWidget {
  const Arrow({Key? key, required this.arrowDirection}) : super(key: key);
  final int arrowDirection;

  @override
  State<Arrow> createState() => _ArrowState();
}

class _ArrowState extends State<Arrow> {
  final radius = 220;
  Color mainColor = Color(0xffA666FC);

  @override
  void initState() {
    switch (widget.arrowDirection) {
      case 0:
        mainColor = Color(0xffFC7266);
        break;
      case 2:
        mainColor = Color(0xff5680DD);
        break;
      case 1:
        mainColor = Color(0xff33D31E);
        break;
      default:
        break;
    }
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: widget.arrowDirection == 1
          ? (0 * math.pi / 180)
          : widget.arrowDirection == 2
              ? (180 * math.pi / 180)
              : widget.arrowDirection == 0
                  ? (0 * math.pi / 180)
                  : (0 * math.pi / 180),
      child: Stack(
        children: [
          Container(
            width: (radius - 60 - 50).w,
            height: 2.w,
            color: mainColor,
          ),
          Transform.rotate(
            angle: (45 * math.pi / 180),
            child: Transform(
              transform: Matrix4.identity()..translate(0.0.w, 4.0.w),
              child: Container(
                width: 10.w,
                height: 2.w,
                color: mainColor,
              ),
            ),
          ),
          Transform.rotate(
            angle: (-45 * math.pi / 180),
            child: Transform(
              transform: Matrix4.identity()..translate(1.0.w, -4.0.w),
              child: Container(
                width: 10.w,
                height: 2.w,
                color: mainColor,
              ),
            ),
          ),
          if (widget.arrowDirection == 1) ...[
            Transform.rotate(
              angle: (45 * math.pi / 180),
              child: Transform(
                transform: Matrix4.identity()..translate(70.5.w, -75.5.w),
                child: Container(
                  width: 10.w,
                  height: 2.w,
                  color: mainColor,
                ),
              ),
            ),
            Transform.rotate(
              angle: (-45 * math.pi / 180),
              child: Transform(
                transform: Matrix4.identity()..translate(70.5.w, 75.5.w),
                child: Container(
                  width: 10.w,
                  height: 2.w,
                  color: mainColor,
                ),
              ),
            ),
          ]
        ],
      ),
    );
  }
}

class PositiveChilds extends StatefulWidget {
  const PositiveChilds({
    Key? key,
    required this.inClassNumber,
  }) : super(key: key);
  final int inClassNumber;

  @override
  State<PositiveChilds> createState() => _PositiveChildsState();
}

class _PositiveChildsState extends State<PositiveChilds> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70.w,
      height: 70.w,
      child: Stack(
        children: [
          Positioned(
              left: 5.w,
              child: WidgetMask(
                blendMode: BlendMode.srcATop,
                childSaveLayer: true,
                mask: Provider.of<IdTo>(context, listen: false).IdToImage(widget.inClassNumber, context),
                child: Container(
                  width: 60.w,
                  height: 60.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    border: Border.all(width: 1.w, color: Color(0x1AA666FC)),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x297B7B7B),
                        blurRadius: 4,
                        offset: Offset(3, 3), // changes position of shadow
                      ),
                    ],
                  ),
                ),
              )),
          Positioned(
            top: 50.w,
            left: 0.w,
            child: Container(
              width: 70.w,
              height: 20.w,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10.w)),
                  border: Border.all(width: 1.w, color: Color(0x4DA666FC))),
              child: Center(
                child: Text(
                  Provider.of<IdTo>(context, listen: false).IdToName(widget.inClassNumber, context),
                  style: TextStyle(
                      fontSize: 12.w,
                      fontWeight: FontWeight.w400,
                      color: Color(0xff393838)),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
