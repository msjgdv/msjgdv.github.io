import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:graphview/GraphView.dart';
import 'package:provider/provider.dart';
import 'package:treasure_map/provider/atti_child_data_management.dart';
import 'package:widget_mask/widget_mask.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../provider/report_data_management.dart';

class GraphClusterViewPage extends StatefulWidget {
  const GraphClusterViewPage({
    Key? key,
    required this.NetWorkAloneEdge,
    required this.NetworkEdge,
  }) : super(key: key);
  final List<List<int>> NetworkEdge;
  final List<int> NetWorkAloneEdge;

  @override
  _GraphClusterViewPageState createState() => _GraphClusterViewPageState();
}

class _GraphClusterViewPageState extends State<GraphClusterViewPage> {
  GlobalKey gKey = GlobalKey();
  TransformationController transformationController =
      TransformationController();

  @override
  Widget build(BuildContext context) {
    int circleNumber = -1;
    return Scaffold(
        body: Row(
      children: [
        Expanded(
          child: WidgetSize(
            onChange: (Size size) {
              setState(() {
                Matrix4 matrix4 =
                    Matrix4(1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 2);
                transformationController = TransformationController(matrix4);
              });
            },
            child: Container(
              color: Colors.white,
              child: Center(
                child: InteractiveViewer(
                    // onInteractionUpdate: (gesture) {
                    //   print("asdf");
                    //
                    // },
                    transformationController: transformationController,
                    // constrained: false,
                    // boundaryMargin: EdgeInsets.symmetric(horizontal: 500.w),
                    // panEnabled: false,
                    scaleEnabled: false,
                    minScale: 0.001,
                    maxScale: 1,
                    // clipBehavior: Clip.none,

                    // scaleFactor: 100,
                    child: Container(
                      // margin: EdgeInsets.symmetric(horizontal: 400.w),
                      color: Colors.white,
                      width: 1000.w,
                      child: GraphView(
                          graph: graph,
                          algorithm: builder,
                          paint: Paint()
                            ..color = Colors.transparent
                            ..strokeWidth = 5.w
                            ..style = PaintingStyle.fill,
                          builder: (Node node) {
                            // I can decide what widget should be shown here based on the id
                            var a = node.key!.value.toString();

                            circleNumber ++ ;
                            return circleWidget(a, circleNumber);

                          }),
                    )),
              ),
            ),
          ),
        ),
      ],
    ));
  }

  Widget circleWidget(String identification, int circleNumber) {

    // print(identification);
    bool isThere = true;
    bool sex = true;
    Image childFace = Image.asset('');
    int inClassNumber = Provider.of<AttiChildDataManagement>(context, listen: false)
        .childList
        .indexWhere((AttiChild) =>
    AttiChild.identification == int.parse(identification));

    childFace = Provider.of<AttiChildDataManagement>(context, listen: false)
        .childList[inClassNumber]
        .childFace;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onPanUpdate: (info) {
            var x = info.globalPosition.dx;
            var y = info.globalPosition.dy;

            setState(() {
              builder.setFocusedNode(graph.getNodeAtPosition(
                  circleNumber));
              graph
                  .getNodeAtPosition(circleNumber)
                  .position = Offset(x, y);
            });
          },
          child: Container(
            width: 100.w,
            height: 100.w,
            decoration: BoxDecoration(
              // border: Border.all(color: Color(0x1AA666FC), width: 1),
              boxShadow: [
                isThere == true
                    ? BoxShadow(
                        color: Color(0x297B7B7B),
                        blurRadius: 6,
                        offset: Offset(4, 4),
                      )
                    : BoxShadow(color: Colors.transparent),
              ],
              color: isThere == true ? Color(0x1AA666FC) : Colors.transparent,
              // border color //외곽색 (green:남자, orange:여자)
              shape: BoxShape.circle,
            ),
            child: isThere == true
                ? WidgetMask(
                    blendMode: BlendMode.srcATop,
                    childSaveLayer: true,
                    mask: isThere == true
                        ? childFace
                        : Container(
                            width: 100.w,
                            height: 100.w,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.transparent),
                          ),
                    child: Container(
                        padding: EdgeInsets.all(0),
                        child: Container(
                          width: 100.w,
                          height: 100.w,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle, color: Colors.white),
                        )))
                : Container(),
          ),
        ),
        Container(
            child: Padding(
                padding: const EdgeInsets.only(top: 2),
                child: isThere == true
                    ? Container(
                        width: 120.w,
                        height: 40.w,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(10.w)),
                            border:
                                Border.all(width: 1, color: Color(0x4DA666FC))),
                        child: Center(
                          child: Text(
                              context
                                  .read<AttiChildDataManagement>()
                                  .childList[context
                                      .read<AttiChildDataManagement>()
                                      .childList
                                      .indexWhere((AttiChild) =>
                                          AttiChild.identification ==
                                          int.parse(identification))]
                                  .name,
                              style: TextStyle(
                                  fontSize: 20.w, color: Color(0xff393838))),
                        ),
                      )
                    : Text(
                        '',
                        style: TextStyle(
                            fontSize: 30.w, color: Colors.transparent),
                      ))),
      ],
    );
  }

  final Graph graph = Graph();
  late Algorithm builder;

  @override
  void initState() {
    // print(widget.NetworkEdge[0]);
    // var i;
    List<Node>? nodes = [];
    for (int i = 0; i < context.read<ReportDataManagement>().reportData.last['headCount']; i++) {
      nodes.add(Node.Id(
          // context.read<ChildManagement>().childInfos[i].identification.toString()
          context
              .read<AttiChildDataManagement>()
              .childList[context
                  .read<AttiChildDataManagement>()
                  .childList
                  .indexWhere((AttiChild) =>
                      AttiChild.identification ==
                      context.read<ReportDataManagement>().reportData.last['cid'][i])]
              .identification
              .toString()
          // context.read<ReportDataManagement>().cid[i].toString()

          ));

      //nodes[i].position = Offset(-50,-50);
      nodes[i].size = Size(90.w, 90.w);
    }

    List<int> idHoller = [];
    idHoller = context.read<ReportDataManagement>().reportData.last['cid'].cast<int>();

    for (int i = 0; i < widget.NetworkEdge.length; i++) {

      graph.addEdge(
          nodes[idHoller
              .indexWhere((idHoller) => idHoller == widget.NetworkEdge.cast<List<int>>()[i][0])],
          nodes[idHoller
              .indexWhere((idHoller) => idHoller == widget.NetworkEdge.cast<List<int>>()[i][1])],
          paint: Paint()
            ..strokeWidth = 6.w
            ..color = Color(0xffAF7AF7));
    }

    for (int i = 0; i < widget.NetWorkAloneEdge.length; i++) {

      nodes.add(Node.Id(widget.NetWorkAloneEdge[i]));
      graph.addEdge(
          nodes[idHoller.indexWhere(
              (idHoller) => idHoller == widget.NetWorkAloneEdge[i])],
          nodes[idHoller.indexWhere(
              (idHoller) => idHoller == widget.NetWorkAloneEdge[i])],
          // noneNode[i],
          paint: Paint()
            ..strokeWidth = 5.w
            ..color = Colors.black.withOpacity(0));
    }

    builder = FruchtermanReingoldAlgorithm(iterations: 1000);
  }
}

class WidgetSize extends StatefulWidget {
  final Widget child;
  final Function onChange;

  const WidgetSize({
    Key? key,
    required this.onChange,
    required this.child,
  }) : super(key: key);

  @override
  _WidgetSizeState createState() => _WidgetSizeState();
}

class _WidgetSizeState extends State<WidgetSize> {
  @override
  Widget build(BuildContext context) {
    SchedulerBinding.instance.addPostFrameCallback(postFrameCallback);
    return Container(
      key: widgetKey,
      child: widget.child,
    );
  }

  var widgetKey = GlobalKey();
  var oldSize;

  void postFrameCallback(_) {
    var context = widgetKey.currentContext;
    if (context == null) return;

    var newSize = context.size;
    if (oldSize == newSize) return;

    oldSize = newSize;
    widget.onChange(newSize);
  }
}
