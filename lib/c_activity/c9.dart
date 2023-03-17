// ignore_for_file: must_be_immutable
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:treasure_map/api/activity.dart';
import 'package:treasure_map/widgets/api.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../provider/app_management.dart';
import '../widgets/overtab.dart';
import '../widgets/select_number.dart';
import 'package:aligned_dialog/aligned_dialog.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

//---------------------------------------------------신장/체중---------------------------------------------------\\
class C9 extends StatefulWidget {
  const C9({
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
  State<C9> createState() => _C9State();
}

class _C9State extends State<C9> {
  static final autoLoginStorage = FlutterSecureStorage();
  int childNum = 8; //애들수
  int rowNum = 0; //꽉채운 한줄
  int rowRestNum = 0; //그러지못한 한줄
  bool dateOn = true;

  List<String> testchildnamelist = [];
  List<double> testchildheightlist = [];
  List<double> testchildweightlist = [];

  List<GetBodyProfile> childBodyProfile = [];

  getChildBodyProfile() async {
    ApiUrl apiUrl = ApiUrl();
    http.Response bodyRes = await api('${apiUrl.heightAndWeight}/${Provider.of<UserInfo>(context, listen: false).value[0]}/$pageTimeStr', 'get', 'signInToken', {}, context);

    if(bodyRes.statusCode == 200){
      var bodyRB = utf8.decode(bodyRes.bodyBytes);
      var bodyData = jsonDecode(bodyRB);
      childBodyProfile.clear();
      if (mounted) {
        setState(() {
          for (int i = 0; i < bodyData.length; i++) {
            childBodyProfile.add(GetBodyProfile(
                name: bodyData[i]['name'],
                id: bodyData[i]['id'],
                height: bodyData[i]['height'],
                weight: bodyData[i]['weight']));
          }
          rowNum = childBodyProfile.length ~/ 3;
          rowRestNum = childBodyProfile.length % 3;
        });
      }
    }

  }

  DateTime pageTime = DateTime.now();
  String pageTimeStr = '';

  receiveData(DateTime dateTime) async {
    //api 보내는 날짜를 바꿈
    pageTime = dateTime;
    var formatter = DateFormat('yyyyMMdd');
    pageTimeStr = formatter.format(pageTime);
    //api 통신 후 데이터 받아오기

    //......
    setState(() {
      getChildBodyProfile();
      //데이터 넣어주기
      //ex) data = response["data"];
    });
  }

  @override
  initState() {
    receiveData(pageTime);
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
        color: const Color(0xffFCFCFC),
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
                  for (int i = 0; i < rowNum + 1; i++) ...[
                    if (i == rowNum) ...[
                      //겉절이 row있으면 저절로 채워짐
                      Row(
                        children: [
                          for (int j = 0; j < rowRestNum; j++) ...[
                            Container(
                              width: 39.w,
                              height: 102.w,
                              color: const Color(0xffFCFCFC),
                            ),
                            ChildHeightWidget(
                              getBodyProfile: childBodyProfile[i * 3 + j],
                              receiveData: receiveData,
                              date: pageTime,
                              dateStr: pageTimeStr,
                            ),
                            SizedBox(
                              width: 62.w,
                            ),
                          ]
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            width: 39.w,
                            height: 50.w,
                            decoration: BoxDecoration(
                              //color: Colors.black,
                              color: const Color(0xffFCFCFC),
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(50.w)),
                            ),
                          ),
                        ],
                      )
                    ] else ...[
                      //꽉찬 row
                      Row(
                        children: [
                          Container(
                            width: 39.w,
                            height: 102.w,
                            color: const Color(0xffFCFCFC),
                          ),
                          ChildHeightWidget(
                            getBodyProfile: childBodyProfile[i * 3 + 0],
                            receiveData: receiveData,
                            date: pageTime,
                            dateStr: pageTimeStr,
                          ),
                          SizedBox(
                            width: 101.w,
                          ),
                          ChildHeightWidget(
                            getBodyProfile: childBodyProfile[i * 3 + 1],
                            receiveData: receiveData,
                            date: pageTime,
                            dateStr: pageTimeStr,
                          ),
                          SizedBox(
                            width: 101.w,
                          ),
                          ChildHeightWidget(
                            getBodyProfile: childBodyProfile[i * 3 + 2],
                            receiveData: receiveData,
                            date: pageTime,
                            dateStr: pageTimeStr,
                            rowLast: true,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            width: 39.w,
                            height: 50.w,
                            color: const Color(0xffFCFCFC),
                          ),
                        ],
                      )
                    ],
                  ]
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ChildHeightWidget extends StatefulWidget {
  ChildHeightWidget(
      {required this.getBodyProfile,
      required this.receiveData,
      required this.date,
      required this.dateStr,
        this.rowLast = false,
      Key? key})
      : super(key: key);
  final GetBodyProfile getBodyProfile;
  final Function(DateTime) receiveData;
  final DateTime date;
  final String dateStr;
  final bool rowLast;

  @override
  State<ChildHeightWidget> createState() => _ChildHeightWidgetState();
}

class _ChildHeightWidgetState extends State<ChildHeightWidget> {
  static final autoLoginStorage = FlutterSecureStorage();

  Color columnhexcolor = const Color(0xFFFFEFD3);
  Color columnhexcolor2 = const Color(0xFFFFFDF8);
  Color rowhexcolor = const Color(0xFFFFFFFF);

  double borderradius = 20.w;
  double borderwidth = 1.w;
  Color borderhexcolor = const Color(0x4DFDB43B);

  double fontsize14 = 14.sp;
  Color fonthexcolor = const Color(0xFF393838);

  postBodyProfile(double data, String type) async {
    ApiUrl apiUrl = ApiUrl();
    http.Response bodyRes = await api(apiUrl.heightAndWeight, 'post', 'signInToken', {
      "id": widget.getBodyProfile.id.toString(),
      "cid": Provider.of<UserInfo>(context, listen: false).value[0].toString(),
      "date": widget.dateStr,
      "type": type,
      "value": data.toString()
    }, context);
    if(bodyRes.statusCode == 200){
      widget.receiveData(widget.date);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 287.w,
      height: 102.w,
      decoration: BoxDecoration(
        color: columnhexcolor,
        border: Border.all(color: borderhexcolor, width: borderwidth),
        borderRadius: BorderRadius.all(Radius.circular(borderradius)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x29B1B1B1),
            blurRadius: 6,
            offset: Offset(-2, 2),
          )
        ],
      ),
      child: Row(
        children: [
          Column(
            children: [
              Container(
                width: 102.w,
                height: 40.w,
                decoration: BoxDecoration(
                    color: columnhexcolor,
                    border:
                        Border.all(color: borderhexcolor, width: borderwidth),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(borderradius))),
                child: Center(
                  child: Text(
                    '유아명',
                    style: TextStyle(fontSize: fontsize14, color: fonthexcolor),
                  ),
                ),
              ),
              Container(
                width: 102.w,
                height: 60.w,
                decoration: BoxDecoration(
                    color: rowhexcolor,
                    border:
                        Border.all(color: borderhexcolor, width: borderwidth),
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(borderradius))),
                child: Center(child: Text(widget.getBodyProfile.name,
                  style: TextStyle(fontSize: fontsize14, color: fonthexcolor),),)
              )
            ],
          ),
          Column(
            children: [
              Container(
                width: 91.w,
                height: 40.w,
                decoration: BoxDecoration(
                  color: columnhexcolor,
                  border: Border.all(color: borderhexcolor, width: borderwidth),
                ),
                child: Center(
                  child: Text(
                    '신장',
                    style: TextStyle(fontSize: fontsize14, color: fonthexcolor),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  showAlignedDialog(
                      offset: Offset(0.w, 70.w),
                      barrierColor: Colors.transparent,
                      context: context,
                      builder: (BuildContext context) {
                        return TakeNumberHeight(
                          postBodyProfile: postBodyProfile,
                        );
                      });
                },
                child: Container(
                  width: 91.w,
                  height: 60.w,
                  decoration: BoxDecoration(
                      color: rowhexcolor,
                      border:
                          Border.all(color: borderhexcolor, width: borderwidth),
                      // borderRadius:
                          // BorderRadius.only(bottomLeft: Radius.circular(10.w))
                      ),
                  child: Center(
                    child: Text(widget.getBodyProfile.height == null
                        ? '-'
                        : widget.getBodyProfile.height.toString(),
                      style: TextStyle(fontSize: fontsize14, color: fonthexcolor),),
                  ),
                ),
              )
            ],
          ),
          Column(
            children: [
              Container(
                width: 92.w,
                height: 40.w,
                decoration: BoxDecoration(
                    color: columnhexcolor,
                    border:
                        Border.all(color: borderhexcolor, width: borderwidth),
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(borderradius))),
                child: Center(
                  child: Text(
                    '체중',
                    style: TextStyle(fontSize: fontsize14, color: fonthexcolor),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  showAlignedDialog(
                      offset: Offset(!widget.rowLast ? 100.w: 18.w, 70.w),
                      barrierColor: Colors.transparent,
                      context: context,
                      builder: (BuildContext context) {
                        return TakeNumberWeight(
                            postBodyProfile: postBodyProfile);
                      });
                },
                child: Container(
                  width: 92.w,
                  height: 60.w,
                  decoration: BoxDecoration(
                      color: rowhexcolor,
                      border:
                          Border.all(color: borderhexcolor, width: borderwidth),
                      borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(borderradius))),
                  child: Center(
                    child: Text(widget.getBodyProfile.weight == null
                        ? '-'
                        : widget.getBodyProfile.weight.toString(),
                      style: TextStyle(fontSize: fontsize14, color: fonthexcolor),),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

class TakeNumberHeight extends StatefulWidget {
  const TakeNumberHeight({
    Key? key,
    required this.postBodyProfile,
  }) : super(key: key);
  final Function(double, String) postBodyProfile;

  @override
  State<TakeNumberHeight> createState() => _TakeNumberHeightState();
}

class _TakeNumberHeightState extends State<TakeNumberHeight> {
  int heightFront = 0;
  int heightBack = 0;
  double height = 0;

  setHeightFront(int _number) {
    heightFront = _number;
  }

  setHeightBack(int _number) {
    heightBack = _number;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320.w,
      height: 80.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20.w)),
        border: Border.all(width: 1.w, color: Color(0xFFA666FB)),
        boxShadow: [
          BoxShadow(
            color: Color(0x294D4D4D),
            blurRadius: 4,
            offset: Offset(2, 2), // changes position of shadow
          ),
        ],
        color: Colors.white,
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SelectNumber(
              startNumber: 50,
              finalNumber: 120,
              defaultNumber: 40,
              stringLength: 3,
              setNumber: setHeightFront,
            ),
            Container(
              width: 30.w,
              child: Text(
                " .",
                style: TextStyle(fontSize: 40.w, color: Color(0xff393838)),
              ),
            ),
            SelectNumber(
              startNumber: 0,
              finalNumber: 10,
              defaultNumber: 5,
              stringLength: 1,
              setNumber: setHeightBack,
            ),
            SizedBox(
              width: 20.w,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 70.w,
                  height: 50.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10.w)),
                    color: Colors.white,
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      height = heightFront + heightBack / 10;
                      widget.postBodyProfile(height, "height");
                      Navigator.pop(context);
                    },
                    child: Text('확인',
                        style: TextStyle(
                            fontSize: 18.sp, fontWeight: FontWeight.w400)),
                    style: ElevatedButton.styleFrom(
                        elevation: 1.0,
                        primary: const Color(0xFFFFEFD3),
                        onPrimary: const Color(0xFF393838),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.w)),
                        side: const BorderSide(color: Color(0xFFffffff)),
                        fixedSize: Size(70.w, 50.w)),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class TakeNumberWeight extends StatefulWidget {
  const TakeNumberWeight({
    Key? key,
    required this.postBodyProfile,
  }) : super(key: key);
  final Function(double, String) postBodyProfile;

  @override
  State<TakeNumberWeight> createState() => _TakeNumberWeightState();
}

class _TakeNumberWeightState extends State<TakeNumberWeight> {
  int weightFront = 0;
  int weightBack = 0;
  double weight = 0;

  setWeightFront(int _number) {
    weightFront = _number;
  }

  setWeightBack(int _number) {
    weightBack = _number;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300.w,
      height: 80.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20.w)),
        border: Border.all(width: 1.w, color: Color(0xFFA666FB)),
        boxShadow: [
          BoxShadow(
            color: Color(0x294D4D4D),
            blurRadius: 4,
            offset: Offset(2, 2), // changes position of shadow
          ),
        ],
        color: Colors.white,
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SelectNumber(
              startNumber: 10,
              finalNumber: 50,
              defaultNumber: 10,
              stringLength: 2,
              setNumber: setWeightFront,
            ),
            Container(
              width: 30.w,
              child: Text(
                " .",
                style: TextStyle(fontSize: 40.w, color: Color(0xff393838)),
              ),
            ),
            SelectNumber(
              startNumber: 0,
              finalNumber: 10,
              defaultNumber: 5,
              stringLength: 1,
              setNumber: setWeightBack,
            ),
            SizedBox(
              width: 20.w,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 70.w,
                  height: 50.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10.w)),
                    color: Colors.white,
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      weight = weightFront + weightBack / 10;
                      widget.postBodyProfile(weight, "weight");
                      Navigator.pop(context);
                    },
                    child: Text('확인',
                        style: TextStyle(
                            fontSize: 18.sp, fontWeight: FontWeight.w400)),
                    style: ElevatedButton.styleFrom(
                        elevation: 1.0,
                        primary: const Color(0xFFFFEFD3),
                        onPrimary: const Color(0xFF393838),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.w)),
                        side: const BorderSide(color: Color(0xFFffffff)),
                        fixedSize: Size(70.w, 50.w)),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

// class ChildHeightWidget extends StatefulWidget {
//   ChildHeightWidget(
//       {required this.index,
//         required this.testchildname,
//         required this.testchildheight,
//         required this.testchildweight,
//         required this.doublePicker,
//         Key? key})
//       : super(key: key);
//   int index;
//   String testchildname;
//   double testchildheight;
//   double testchildweight;
//   Function(int, bool) doublePicker;
//
//   @override
//   State<ChildHeightWidget> createState() => _ChildHeightWidgetState();
// }
//
// class _ChildHeightWidgetState extends State<ChildHeightWidget> {
//   Color columnhexcolor = const Color(0xFFFFEFD3);
//   Color columnhexcolor2 = const Color(0xFFFFFDF8);
//   Color rowhexcolor = const Color(0xFFFFFFFF);
//
//   double borderradius = 20.w;
//   double borderwidth = 1.w;
//   Color borderhexcolor = const Color(0x4DFDB43B);
//
//   double fontsize14 = 14.sp;
//   Color fonthexcolor = const Color(0xFF393838);
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       // width: 287.w,
//       height: 102.w,
//       decoration: BoxDecoration(
//         color: columnhexcolor,
//         border: Border.all(color: borderhexcolor, width: borderwidth),
//         borderRadius: BorderRadius.all(Radius.circular(borderradius)),
//         boxShadow: const [
//           BoxShadow(
//             color: Color(0x29B1B1B1),
//             blurRadius: 6,
//             offset: Offset(-2, 2),
//           )
//         ],
//       ),
//       child: Row(
//         children: [
//           Column(
//             children: [
//               Container(
//                 width: 95.w,
//                 height: 40.w,
//                 decoration: BoxDecoration(
//                     color: columnhexcolor,
//                     border:
//                     Border.all(color: borderhexcolor, width: borderwidth),
//                     borderRadius: BorderRadius.only(
//                         topLeft: Radius.circular(borderradius))),
//                 child: Center(
//                   child: Text(
//                     '유아명',
//                     style: TextStyle(fontSize: fontsize14, color: fonthexcolor),
//                   ),
//                 ),
//               ),
//               Container(
//                 width: 95.w,
//                 height: 60.w,
//                 decoration: BoxDecoration(
//                     color: rowhexcolor,
//                     border:
//                     Border.all(color: borderhexcolor, width: borderwidth),
//                     borderRadius: BorderRadius.only(
//                         bottomLeft: Radius.circular(borderradius))),
//                 child: Center(child: Text(widget.testchildname)),
//               )
//             ],
//           ),
//           Column(
//             children: [
//               Container(
//                 width: 80.w,
//                 height: 40.w,
//                 decoration: BoxDecoration(
//                   color: columnhexcolor,
//                   border: Border.all(color: borderhexcolor, width: borderwidth),
//                 ),
//                 child: Center(
//                   child: Text(
//                     '신장',
//                     style: TextStyle(fontSize: fontsize14, color: fonthexcolor),
//                   ),
//                 ),
//               ),
//               GestureDetector(
//                 onTap: (){
//                   showAlignedDialog(
//                       offset: Offset(0.w,
//                           70.w ),
//                       barrierColor: Colors.transparent,
//                       context: context,
//                       builder: (BuildContext context) {
//                         return TakeNumberHeight(cid: 1,);
//                       });
//                 },
//                 child: Container(
//                   width: 80.w,
//                   height: 60.w,
//                   decoration: BoxDecoration(
//                       color: rowhexcolor,
//                       border:
//                       Border.all(color: borderhexcolor, width: borderwidth),
//                       borderRadius:
//                       BorderRadius.only(bottomLeft: Radius.circular(10.w))),
//                   child: Center(
//                     child: Text(widget.testchildheight.toString()),
//                   ),
//                 ),
//               )
//             ],
//           ),
//           Column(
//             children: [
//               Container(
//                 width: 80.w,
//                 height: 40.w,
//                 decoration: BoxDecoration(
//                     color: columnhexcolor,
//                     border:
//                     Border.all(color: borderhexcolor, width: borderwidth),
//                     borderRadius: BorderRadius.only(
//                       // topRight: Radius.circular(borderradius)
//                     )
//                 ),
//                 child: Center(
//                   child: Text(
//                     '체중',
//                     style: TextStyle(fontSize: fontsize14, color: fonthexcolor),
//                   ),
//                 ),
//               ),
//               GestureDetector(
//                 onTap: (){
//                   showAlignedDialog(
//                       offset: Offset(100.w,
//                           70.w ),
//                       barrierColor: Colors.transparent,
//                       context: context,
//                       builder: (BuildContext context) {
//                         return TakeNumberWeight(cid: 1,);
//                       });
//
//                 },
//                 child: Container(
//                   width: 80.w,
//                   height: 60.w,
//                   decoration: BoxDecoration(
//                       color: rowhexcolor,
//                       border:
//                       Border.all(color: borderhexcolor, width: borderwidth),
//                       borderRadius: BorderRadius.only(
//                         // bottomRight: Radius.circular(borderradius)
//                       )),
//                   child: Center(
//                     child: Text(widget.testchildweight.toString()),
//                   ),
//                 ),
//               )
//             ],
//           ),
//           Column(
//             children: [
//               Container(
//                 width: 100.w,
//                 height: 40.w,
//                 decoration: BoxDecoration(
//                     color: columnhexcolor,
//                     border:
//                     Border.all(color: borderhexcolor, width: borderwidth),
//                     borderRadius: BorderRadius.only(
//                       // topLeft: Radius.circular(borderradius)
//                     )),
//                 child: Center(
//                   child: Text(
//                     '최근측정날짜',
//                     style: TextStyle(fontSize: fontsize14, color: fonthexcolor),
//                   ),
//                 ),
//               ),
//               Container(
//                 width: 100.w,
//                 height: 60.w,
//                 decoration: BoxDecoration(
//                     color: rowhexcolor,
//                     border:
//                     Border.all(color: borderhexcolor, width: borderwidth),
//                     borderRadius: BorderRadius.only(
//                       // bottomLeft: Radius.circular(borderradius)
//                     )),
//                 child: Center(child: Text(widget.testchildname)),
//               )
//             ],
//           ),
//           Column(
//             children: [
//               Container(
//                 width: 75.w,
//                 height: 40.w,
//                 decoration: BoxDecoration(
//                     color: columnhexcolor,
//                     border:
//                     Border.all(color: borderhexcolor, width: borderwidth),
//                     borderRadius: BorderRadius.only(
//                       // topLeft: Radius.circular(borderradius)
//                     )),
//                 child: Center(
//                   child: Text(
//                     '신장',
//                     style: TextStyle(fontSize: fontsize14, color: fonthexcolor),
//                   ),
//                 ),
//               ),
//               Container(
//                 width: 75.w,
//                 height: 60.w,
//                 decoration: BoxDecoration(
//                     color: rowhexcolor,
//                     border:
//                     Border.all(color: borderhexcolor, width: borderwidth),
//                     borderRadius: BorderRadius.only(
//                       // bottomLeft: Radius.circular(borderradius)
//                     )),
//                 child: Center(child: Text(widget.testchildname)),
//               )
//             ],
//           ),
//           Column(
//             children: [
//               Container(
//                 width: 75.w,
//                 height: 40.w,
//                 decoration: BoxDecoration(
//                     color: columnhexcolor,
//                     border:
//                     Border.all(color: borderhexcolor, width: borderwidth),
//                     borderRadius: BorderRadius.only(
//                         topRight: Radius.circular(borderradius)
//                     )),
//                 child: Center(
//                   child: Text(
//                     '체중',
//                     style: TextStyle(fontSize: fontsize14, color: fonthexcolor),
//                   ),
//                 ),
//               ),
//               Container(
//                 width: 75.w,
//                 height: 60.w,
//                 decoration: BoxDecoration(
//                     color: rowhexcolor,
//                     border:
//                     Border.all(color: borderhexcolor, width: borderwidth),
//                     borderRadius: BorderRadius.only(
//                         bottomRight: Radius.circular(borderradius)
//                     )),
//                 child: Center(child: Text(widget.testchildname)),
//               )
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
