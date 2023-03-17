// import "package:arrow_path/arrow_path.dart";
// import 'package:flutter/cupertino.dart';
// import "package:flutter/material.dart";
// import "dart:math";
// import 'child_management.dart';
// import 'circle_node.dart';
// import 'package:provider/provider.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
//
// class Report1Graph extends StatelessWidget {
//   const Report1Graph({
//     Key? key,
//     required this.names,
//     required this.sexes,
//     required this.arrowTypes,
//     required this.mainChildId,
//     required this.childFaces,
//   }) : super(key: key);
//   final names;
//   final sexes;
//   final arrowTypes;
//   final int mainChildId;
//   final childFaces;
//
//   @override
//   Widget build(BuildContext context) {
//     final int upperLine;
//     final bool isEven;
//     if (names.length % 2 == 0) {
//       isEven = true;
//       upperLine = (names.length / 2).toInt();
//     } else {
//       isEven = false;
//       upperLine = (names.length / 2).round(); //반올림함. 9개면 5뜸.
//     }
//
//     return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
//       Row(mainAxisAlignment: MainAxisAlignment.center, children: [
//         Container(
//           width: 5,
//         ),
//         for (num i = 0; i < upperLine; i++) ...[
//           CircleNode(name: names[i], sex: sexes[i], rr: 45, childFace: childFaces[i],),
//           Container(
//             width: 5,
//           ),
//         ]
//       ]),
//       Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Container(
//               width: upperLine * 50.toDouble(),
//               height: 40,
//               child: Stack(
//                 children: [
//                   for (int i = 0; i < upperLine; i++) ...[
//                     Container(
//                       width: upperLine * 50.toDouble(),
//                       height: 40,
//                       //color: Colors.orange.withOpacity(0.1),
//                       child: CustomPaint(
//                         painter:
//                             ArrowPainter(upperLine, i, arrowTypes[i], isEven),
//                       ),
//                     ),
//                   ]
//                 ],
//               ),
//             ),
//           ]),
//
//       //mainCircle
//       CircleNode(
//         name:context
//             .read<ChildManagement>()
//             .childInfos[context.read<ChildManagement>().childInfos.indexWhere(
//                 (ChildInfoSet) => ChildInfoSet.identification == mainChildId)]
//             .name,
//
//         sex: context
//             .read<ChildManagement>()
//             .childInfos[context.read<ChildManagement>().childInfos.indexWhere(
//                 (ChildInfoSet) => ChildInfoSet.identification == mainChildId)]
//             .sex,
//         rr: 60,
//         childFace: context
//             .read<ChildManagement>()
//             .childInfos[context.read<ChildManagement>().childInfos.indexWhere(
//                 (ChildInfoSet) => ChildInfoSet.identification == mainChildId)]
//             .childFace,
//       ),
//
//       Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Container(
//               width: isEven == true
//                   ? (upperLine * 50).toDouble()
//                   : ((upperLine - 1) * 50).toDouble(),
//               height: 40,
//               child: Stack(
//                 children: [
//                   for (int i = upperLine; i < names.length; i++) ...[
//                     Container(
//                       width: isEven == true
//                           ? (upperLine * 50).toDouble()
//                           : ((upperLine - 1) * 50).toDouble(),
//                       height: 40,
//                       //color: Colors.orange.withOpacity(0.1),
//                       child: CustomPaint(
//                         painter: ArrowPainter(
//                             isEven == true ? upperLine : upperLine - 1,
//                             i,
//                             arrowTypes[i],
//                             isEven),
//                       ),
//                     ),
//                   ]
//                 ],
//               ),
//             ),
//           ]),
//       Row(mainAxisAlignment: MainAxisAlignment.center, children: [
//         Container(
//           width: 5,
//         ),
//         for (num i = upperLine; i < names.length; i++) ...[
//           CircleNode(name: names[i], sex: sexes[i], rr: 45, childFace: childFaces[i],),
//           Container(
//             width: 5,
//           ),
//         ]
//       ]),
//     ]);
//   }
// }
//
// class ArrowPainter extends CustomPainter {
//   final int length;
//   final int index;
//   final String arrowType;
//   final bool isEven;
//
//   // length하고 index 받아서 양쪽에 그리기위해서는 내부 인덱스로 바꿔줘야함.
//   // 내부인덱스는 inner라고 씀.
//
//   ArrowPainter(this.length, this.index, this.arrowType, this.isEven);
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     // TextSpan textSpan;
//     // TextPainter textPainter;
//     Path path;
//     // double myWidth = size.width;
//     //final double myHeight = 280; //80(container) + 80 +  120(mainCircle)
//     final double myWidth = size.width;
//     final double myHeight;
//
//     //print("$length, $index");
//
//     // The arrows usually looks better with rounded caps.
//     Paint paint = Paint()
//       ..style = PaintingStyle.stroke
//       ..strokeCap = StrokeCap.round
//       ..strokeJoin = StrokeJoin.round
//       ..strokeWidth = 2.0;
//
//     final r = 35;
//     path = Path();
//     final int inner;
//
//     final double tri_x;
//     final double tri_y;
//     final double diagonal;
//     final double compensation_x;
//     final double compensation_y;
//
//     //위에 보이는거.
//     if (index < this.length) {
//       myHeight = 140;
//       inner = index;
//       tri_x = (myWidth * 0.5) - (myWidth * (inner / length) + 25);
//       tri_y = myHeight * 0.5;
//       diagonal = sqrt(pow(tri_x, 2) + pow(tri_y, 2));
//       compensation_x = tri_x * r / diagonal;
//       compensation_y = tri_y * r / diagonal;
//
//       if (arrowType == "일방") {
//         path.moveTo(
//             myWidth * 0.5 - compensation_x, myHeight * 0.5 - compensation_y);
//         path.lineTo(myWidth * (inner / length) + 25, 0);
//         path = ArrowPath.make(path: path, isDoubleSided: false);
//         canvas.drawPath(path, paint..color = Colors.red);
//       } else if (arrowType == "양방") {
//         path.moveTo(
//             myWidth * 0.5 - compensation_x, myHeight * 0.5 - compensation_y);
//         path.lineTo(myWidth * (inner / length) + 25, 0);
//         path = ArrowPath.make(path: path, isDoubleSided: true);
//         canvas.drawPath(path, paint..color = Colors.green);
//       } else if (arrowType == "받음") {
//         path.moveTo(myWidth * (inner / length) + 25, 0);
//         path.lineTo(
//             myWidth * 0.5 - compensation_x, myHeight * 0.5 - compensation_y);
//         path = ArrowPath.make(path: path, isDoubleSided: false);
//         canvas.drawPath(path, paint..color = Colors.blue);
//       } else {
//         path.moveTo(myWidth * (inner / length) + 25, 0);
//         path.lineTo(
//             myWidth * 0.5 - compensation_x, myHeight * 0.5 - compensation_y);
//         //path = ArrowPath.make(path: path, isDoubleSided: false);
//         canvas.drawPath(path, paint..color = Colors.black);
//       }
//     }
//
//     //밑에보이는거
//     else {
//       myHeight = size.height - 140; //80(container) + 80 +  120(mainCircle);
//
//       if (isEven) {
//         inner = index - this.length;
//       } else {
//         inner = index - this.length - 1;
//       }
//
//       tri_x = (myWidth * 0.5) - (myWidth * ((inner) / (length)) + 25);
//       tri_y = tri_y = myHeight * 0.5;
//       diagonal = sqrt(pow(tri_x, 2) + pow(tri_y, 2));
//       compensation_x = tri_x * r / diagonal;
//       compensation_y = tri_y * r / diagonal;
//
//       if (arrowType == "일방") {
//         path.moveTo(
//             myWidth * 0.5 - compensation_x, myHeight * 0.5 - compensation_y);
//         path.lineTo(myWidth * (inner / length) + 25, 30);
//         path = ArrowPath.make(path: path, isDoubleSided: false);
//         canvas.drawPath(path, paint..color = Colors.red);
//       } else if (arrowType == "양방") {
//         path.moveTo(
//             myWidth * 0.5 - compensation_x, myHeight * 0.5 - compensation_y);
//         path.lineTo(myWidth * (inner / length) + 25, 30);
//         path = ArrowPath.make(path: path, isDoubleSided: true);
//         canvas.drawPath(path, paint..color = Colors.green);
//       } else if (arrowType == "받음") {
//         path.moveTo(myWidth * (inner / length) + 25, 30);
//         path.lineTo(
//             myWidth * 0.5 - compensation_x, myHeight * 0.5 - compensation_y);
//         path = ArrowPath.make(path: path, isDoubleSided: false);
//         canvas.drawPath(path, paint..color = Colors.blue);
//       } else {
//         path.moveTo(myWidth * (inner / length) + 25, 30);
//         path.lineTo(
//             myWidth * 0.5 - compensation_x, myHeight * 0.5 - compensation_y);
//         //path = ArrowPath.make(path: path, isDoubleSided: false);
//         canvas.drawPath(path, paint..color = Colors.black);
//       }
//     }
//   }
//
//   @override
//   bool shouldRepaint(ArrowPainter oldDelegate) => true;
// }
