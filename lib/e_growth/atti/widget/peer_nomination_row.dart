// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:widget_mask/widget_mask.dart';
// import 'package:peer_relationship_chart/widjets/app_management.dart';
// import 'package:peer_relationship_chart/widjets/child_management.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
//
// class NominationImage extends StatefulWidget {
//   const NominationImage({
//     Key? key,
//     required this.idToName,
//     required this.idToImage,
//     required this.childList,
//     required this.childType,
//     required this.childTypeExplanation,
//     required this.mainColor,
//   }) : super(key: key);
//   final Function(int) idToName;
//   final Function(int) idToImage;
//   final List<int> childList;
//   final Color mainColor;
//   final String childType;
//   final String childTypeExplanation;
//
//   @override
//   State<NominationImage> createState() => _NominationImageState();
// }
//
// class _NominationImageState extends State<NominationImage> {
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Container(
//           child: Text(
//             widget.childType,
//             style: TextStyle(
//               fontSize: 24.w,
//               fontWeight: FontWeight.w700,
//               color: widget.mainColor,
//             ),
//           ),
//         ),
//         Container(
//           child: Text(
//             widget.childTypeExplanation,
//             style: TextStyle(
//               fontSize: 19.w,
//               fontWeight: FontWeight.w500,
//               color: Color(0xff393838),
//             ),
//           ),
//         ),
//         SizedBox(
//           height: 15.w,
//         ),
//         Container(
//
//           child: Column(children: [
//             if(widget.childList.length >9)...[
//               Container(
//                 width: 790.w,
//                 child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//
//                   children: [
//                     // SizedBox(
//                     //   width: 25.w,
//                     // ),
//                     for (int i = 0; i < 9; i++) ...[
//                       NominationImageMask(
//                         childFace: widget.idToImage(widget.childList[i]),
//                         name: widget.idToName(widget.childList[i]),
//                         mainColor: widget.mainColor,
//                       )
//                     ],
//                   ],
//                 ),
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   SizedBox(
//                     width: 25.w,
//                   ),
//                   for (int i = 9; i < widget.childList.length; i++) ...[
//                     NominationImageMask(
//                       childFace: widget.idToImage(widget.childList[i]),
//                       name: widget.idToName(widget.childList[i]),
//                       mainColor: widget.mainColor,
//                     )
//                   ],
//                 ],
//               )
//             ]else...[
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   SizedBox(
//                     width: 25.w,
//                   ),
//                   for (int i = 0; i < widget.childList.length; i++) ...[
//                     NominationImageMask(
//                       childFace: widget.idToImage(widget.childList[i]),
//                       name: widget.idToName(widget.childList[i]),
//                       mainColor: widget.mainColor,
//                     )
//                   ],
//                 ],
//               ),
//             ]
//           ]),
//         )
//       ],
//     );
//   }
// }
//
// class NominationImageMask extends StatefulWidget {
//   const NominationImageMask({
//     Key? key,
//     required this.childFace,
//     required this.name,
//     required this.mainColor,
//   }) : super(key: key);
//   final Image childFace;
//   final String name;
//   final Color mainColor;
//
//   @override
//   State<NominationImageMask> createState() => _NominationImageMaskState();
// }
//
// class _NominationImageMaskState extends State<NominationImageMask> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 60.w,
//       margin: EdgeInsets.all(10.w),
//       child: Stack(
//         children: [
//           Image.asset(
//             'assets/images/C2/head.png',
//             color: widget.mainColor,
//           ),
//           Center(
//             child: WidgetMask(
//                 blendMode: BlendMode.srcATop,
//                 childSaveLayer: true,
//                 mask: widget.childFace,
//                 child: Container(
//                     padding: EdgeInsets.all(4.w),
//                     child: WidgetMask(
//                         blendMode: BlendMode.srcATop,
//                         childSaveLayer: true,
//                         mask: Image.asset('assets/images/C2/head.png'),
//                         child: Container(
//                           child: Image.asset(
//                             'assets/images/C2/head.png',
//                           ),
//                         )))),
//           ),
//           Container(
//             margin: EdgeInsets.only(
//               top: 60.w,
//             ),
//             child: Container(
//               width: 60.w,
//               margin: EdgeInsets.symmetric(horizontal: 3.w),
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.all(Radius.circular(8.w)),
//                 // color: Color(0xffCAACF2),
//               ),
//               child: Text(
//                 widget.name,
//                 style: TextStyle(
//                   fontSize: 10.w,
//                   fontWeight: FontWeight.w500,
//                   color: Color(0xff393838),
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
