// import 'dart:math';
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/scheduler.dart';
// import 'package:graphview/GraphView.dart';
// import 'package:provider/provider.dart';
// import 'package:widget_mask/widget_mask.dart';
//
// class NominationGraphViewPage extends StatefulWidget {
//   const NominationGraphViewPage({
//     Key? key,
//     required this.nomination,
//   }) : super(key: key);
//   final List<int> nomination;
//   @override
//   _NominationGraphViewPageState createState() => _NominationGraphViewPageState();
// }
//
// class _NominationGraphViewPageState extends State<NominationGraphViewPage> {
//   TransformationController transformationController =
//   TransformationController();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: Row(
//           children: [
//             Expanded(
//               child: WidgetSize(
//                 onChange: (Size size) {
//                   setState(() {
//                     Matrix4 matrix4 =
//                     Matrix4(1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 2);
//                     transformationController = TransformationController(matrix4);
//                   });
//                 },
//                 child: Container(
//                   child: InteractiveViewer(
//                       transformationController: transformationController,
//                       constrained: false,
//                       boundaryMargin: EdgeInsets.all(8),
//                       panEnabled: true,
//                       minScale: 0.001,
//                       maxScale: 100,
//                       child: GraphView(
//                           graph: graph,
//                           algorithm: builder,
//                           paint: Paint()
//                             ..color = Colors.green
//                             ..strokeWidth = 1
//                             ..style = PaintingStyle.fill,
//                           builder: (Node node) {
//                             // I can decide what widget should be shown here based on the id
//                             var a = node.key!.value.toString();
//
//                             return circleWidget(a);
//                           })),
//                 ),
//               ),
//             ),
//           ],
//         ));
//   }
//
//   Widget circleWidget(String name) {
//     bool isThere = true;
//     bool sex = true;
//     Image childFace = Image.asset('assets/images/C2/head.png');
//
//     if (context
//         .read<ChildManagement>()
//         .childInfos
//         .indexWhere((ChildInfoSet) => ChildInfoSet.name == name) !=
//         -1) {
//       childFace = context
//           .read<ChildManagement>()
//           .childInfos[context
//           .read<ChildManagement>()
//           .childInfos
//           .indexWhere((ChildInfoSet) => ChildInfoSet.name == name)]
//           .childFace;
//       if (context
//           .read<ChildManagement>()
//           .childInfos[context
//           .read<ChildManagement>()
//           .childInfos
//           .indexWhere((ChildInfoSet) => ChildInfoSet.name == name)]
//           .sex ==
//           '남') {
//         sex = true;
//       } else {
//         sex = false;
//       }
//       isThere = true;
//     } else if (context
//         .read<ChildManagement>()
//         .childInfos
//         .indexWhere((ChildInfoSet) => ChildInfoSet.name == name) ==
//         -1) {
//       isThere = false;
//     }
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         Container(
//           padding: EdgeInsets.all(5),
//           width: 120,
//           height: 120,
//           decoration: BoxDecoration(
//             color: isThere == true
//                 ? sex == true
//                 ? Colors.green
//                 : Colors.orange
//                 : Colors.transparent,
//             // border color //외곽색 (green:남자, orange:여자)
//             shape: BoxShape.circle,
//           ),
//           child: Padding(
//             padding: EdgeInsets.all(2), // border width
//             child: isThere == true
//                 ? WidgetMask(
//                 blendMode: BlendMode.srcATop,
//                 childSaveLayer: true,
//                 mask: isThere == true
//                     ? childFace
//                     : Image.asset(
//                   'assets/images/C2/head.png',
//                   color: Colors.transparent,
//                 ),
//                 child: Container(
//                     padding: EdgeInsets.all(0),
//                     child: WidgetMask(
//                         blendMode: BlendMode.srcATop,
//                         childSaveLayer: true,
//                         mask: isThere == true
//                             ? Image.asset('assets/images/C2/head.png')
//                             : Image.asset(
//                           'assets/images/C2/head.png',
//                           color: Colors.transparent,
//                         ),
//                         child: Container(
//                           child: isThere == true
//                               ? Image.asset('assets/images/C2/head.png')
//                               : Image.asset(
//                             'assets/images/C2/head.png',
//                             color: Colors.transparent,
//                           ),
//                         ))))
//                 : Container(),
//           ),
//         ),
//         Container(
//             child: Padding(
//                 padding: const EdgeInsets.only(top: 2),
//                 child: isThere == true
//                     ? Text(name, style: TextStyle(fontSize: 25))
//                     : Text(
//                   name,
//                   style:
//                   TextStyle(fontSize: 30, color: Colors.transparent),
//                 ))),
//       ],
//     );
//   }
//
//   final Graph graph = Graph();
//   late Algorithm builder;
//
//   @override
//   void initState() {
//     var i;
//     List<Node>? nodes = [];
//     for (i = 0; i < context.read<ReportDataManagement>().headCount; i++) {
//       nodes.add(Node.Id(context
//           .read<ChildManagement>()
//           .childInfos[context.read<ChildManagement>().childInfos.indexWhere(
//               (ChildInfoSet) =>
//           ChildInfoSet.identification ==
//               context.read<ReportDataManagement>().cid[i])]
//           .name));
//
//       //nodes[i].position = Offset(-50,-50);
//       nodes[i].size = Size(60, 60);
//     }
//
//     List<int> idHoller = [];
//     idHoller = context.read<ReportDataManagement>().cid;
//
//     // for (int i = 0;
//     // i < widget.nomination.length;
//     // i++) {
//     //   graph.addEdge(
//     //       nodes[idHoller.indexWhere((idHoller) =>
//     //       idHoller ==
//     //           widget.nomination[i])],
//     //       nodes[idHoller.indexWhere((idHoller) =>
//     //       idHoller ==
//     //           widget.nomination[i])],
//     //       paint: Paint()
//     //         ..strokeWidth = 5
//     //         ..color = Colors.black.withOpacity(1));
//     // }
//
//     for (int i = 0;
//     i <
//         widget.nomination.length;
//     i++) {
//       nodes.add(Node.Id(i));
//       graph.addEdge(
//           nodes[idHoller.indexWhere((idHoller) =>
//           idHoller ==
//               widget.nomination[i])],
//           nodes[context.read<ReportDataManagement>().headCount + i],
//           paint: Paint()
//             ..strokeWidth = 5
//             ..color = Colors.black.withOpacity(0));
//     }
//
//     builder = FruchtermanReingoldAlgorithm(iterations: 1000);
//   }
// }
//
// class WidgetSize extends StatefulWidget {
//   final Widget child;
//   final Function onChange;
//
//   const WidgetSize({
//     Key? key,
//     required this.onChange,
//     required this.child,
//   }) : super(key: key);
//
//   @override
//   _WidgetSizeState createState() => _WidgetSizeState();
// }
//
// class _WidgetSizeState extends State<WidgetSize> {
//   @override
//   Widget build(BuildContext context) {
//     SchedulerBinding.instance?.addPostFrameCallback(postFrameCallback);
//     return Container(
//       key: widgetKey,
//       child: widget.child,
//     );
//   }
//
//   var widgetKey = GlobalKey();
//   var oldSize;
//
//   void postFrameCallback(_) {
//     var context = widgetKey.currentContext;
//     if (context == null) return;
//
//     var newSize = context.size;
//     if (oldSize == newSize) return;
//
//     oldSize = newSize;
//     widget.onChange(newSize);
//   }
// }
