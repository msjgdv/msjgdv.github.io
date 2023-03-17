import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:treasure_map/a_main/a1.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:treasure_map/widgets/api.dart';
import 'a6_2.dart';
import 'package:http/http.dart' as http;

class A6_5 extends StatefulWidget {
  const A6_5({Key? key,
  this.selected = false,
    this.SelectedKindergartenName = '',
  }) : super(key: key);
  final bool selected;
  final String SelectedKindergartenName;

  @override
  State<A6_5> createState() => _A6_5State();
}

class _A6_5State extends State<A6_5> {
  bool Selected = false;
  String SelectedKindergartenName = "";

  @override
  void initState() {
    super.initState();
    Selected = widget.selected;
    SelectedKindergartenName = widget.SelectedKindergartenName;
    //api를 보내서 이미 고른 곳이 있는 지 확인을 해야함

  }

  @override
  Widget build(BuildContext context) {
    precacheImage(Image.asset('assets/backgrounds/main_page.png').image, context);
    return WillPopScope(
        onWillPop: () async => false,
        child: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
              fit: BoxFit.cover,
              image: Image.asset('assets/backgrounds/main_page.png').image,
            )),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body:
               ScrollConfiguration(
                behavior: const ScrollBehavior().copyWith(overscroll: false),
          child: ListView(
            physics: const RangeMaintainingScrollPhysics(),
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 60.w,
                        ),
                        Container(
                          height: 125.w,
                          width: 250.w,
                        ),
                        SizedBox(
                          height: 145.w,
                        ),
                        Selected == false
                            ? InkWell(
                                onTap: () {
                                  showDialog(
                                      barrierDismissible: false,
                                      barrierColor: Colors.transparent,
                                      context: context,
                                      builder: (BuildContext context) {
                                        return selectKindergarten();
                                      });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 1.w, color: Color(0xffFDB43B)),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10.w)),
                                    color: Colors.white,
                                  ),
                                  width: 500.w,
                                  height: 50.w,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      SvgPicture.asset(
                                        'assets/icons/icon_find.svg',
                                        height: 41.w,
                                        width: 39.w,
                                      ),
                                      SizedBox(
                                        width: 5.w,
                                      )
                                    ],
                                  ),
                                ),
                              )
                            : Container(
                                width: 500.w,
                                height: 50.w,
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 1.w, color: Color(0xffFDB43B)),
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(10.w)),
                                    color: Colors.white,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Container(
                                        width: 440.w,
                                        child: Text(SelectedKindergartenName,
                                          style: TextStyle(
                                              color: Color(0xff393838),
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          setState(() {
                                            Selected = false;
                                          });
                                        },
                                        icon: SvgPicture.asset(
                                          'assets/icons/icon_close_record.svg',
                                          height: 41.w,
                                          width: 39.w,
                                        ),
                                      ),
                                    ],

                                  ),
                                ),
                              ),
                        SizedBox(
                          height: 119.w,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [

                            Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 1.w, color: Color(0xffA666FB)),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.w))),
                              width: 150.w,
                              height: 50.w,
                              child: ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            const Color(0xffffffff)),
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.w),
                                    ))),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => A6_2()),
                                  );
                                },
                                child: Text(
                                  '뒤로',
                                  style: TextStyle(
                                      color: Color(0xff393838),
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
            )));
  }
}

class selectKindergarten extends StatefulWidget {
  const selectKindergarten({Key? key}) : super(key: key);

  @override
  State<selectKindergarten> createState() => _selectKindergartenState();
}

class _selectKindergartenState extends State<selectKindergarten> {
  final autoLoginStorage = FlutterSecureStorage();
  TextEditingController _textEditingController = TextEditingController();
  List<KindergartenInfo> kindergartenInfo = [];
  String kindergartenName = '';
  int selectedIndex = -1;
  int selectedId = 0;
  
  ApiUrl apiUrl = ApiUrl();

  dataUpload()async{
    http.Response res = await api('${apiUrl.kindergarten}?name=${_textEditingController.text}', 'get', 'signInToken', {}, context);
    if(res.statusCode == 200){
      var resRB = utf8.decode(res.bodyBytes);
      var data = jsonDecode(resRB);
      tileSet(data);
    }
  }

  postTeacher()async {
    http.Response res = await api(apiUrl.apply, 'post', 'signInToken', {}, context);
    return res.statusCode;
  }



  tileSet(var response) {
    setState(() {
      kindergartenInfo.clear();
      for (int i = 0; i < response.length; i++) {
        kindergartenInfo.add(KindergartenInfo(
            kindergartenId: response[i]['kid'],
            kindergartenName: response[i]['name'],
            kindergartenSelected: false));
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Dialog(
        elevation: 0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.w))),
        child: SingleChildScrollView(
          child: Container(
            width: 800.w,
            height: 450.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20.w)),
              color: Color(0xffFCF9F4),
            ),
            child: Column(
              children: [
                SizedBox(
                  height: 90.w,
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(width: 1.w, color: Color(0xffFDB43B)),
                    borderRadius: BorderRadius.all(Radius.circular(10.w)),
                    color: Colors.white,
                  ),
                  width: 500.w,
                  height: 50.w,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        width: 440.w,
                        child: TextField(
                          onChanged: (val){
                            setState(() {
                              if(selectedIndex != -1){
                                if(val != kindergartenInfo[selectedIndex].kindergartenName){
                                  kindergartenInfo[selectedIndex].kindergartenSelected = false;
                                  selectedId = 0;
                                }
                              }

                            });

                          },
                          controller: _textEditingController,
                          textAlign: TextAlign.start,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                            ),
                          ),
                          style: TextStyle(
                              color: Color(0xff393838),
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          dataUpload();
                          print(_textEditingController.text);
                          //_textEditingController.text - api 보냄
                          setState(() {

                          });
                        },
                        icon: SvgPicture.asset(
                          'assets/icons/icon_find.svg',
                          height: 41.w,
                          width: 39.w,
                        ),
                      ),
                      // SizedBox(
                      //   width: 13.w,
                      // )
                    ],
                  ),
                ),
                SizedBox(
                  height: 10.w,
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(width: 1.w, color: Color(0xffFDB43B)),
                    borderRadius: BorderRadius.all(Radius.circular(10.w)),
                    color: Colors.white,
                  ),
                  width: 500.w,
                  height: 165.w,
                  child: ScrollConfiguration(
                    behavior: const ScrollBehavior().copyWith(overscroll: false),
                    child: ListView(
                      physics: const RangeMaintainingScrollPhysics(),
                      children: [
                        for (int i = 0; i < kindergartenInfo.length; i++) ...[
                          ListTile(
                            title: Text(kindergartenInfo[i].kindergartenName),
                            onTap: () {
                              setState(() {
                                if(selectedIndex != -1){
                                  kindergartenInfo[selectedIndex].kindergartenSelected = false;
                                }
                                selectedIndex = i;
                                kindergartenInfo[i].kindergartenSelected = true;
                                _textEditingController.text = kindergartenInfo[i].kindergartenName;
                                kindergartenName = kindergartenInfo[i].kindergartenName;
                                selectedId = kindergartenInfo[i].kindergartenId;
                              });
                            },
                            selected: kindergartenInfo[i].kindergartenSelected,

                          ),
                        ]
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 28.w,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          border:
                              Border.all(width: 1.w, color: Color(0xffA666FB)),
                          borderRadius:
                              BorderRadius.all(Radius.circular(10.w))),
                      width: 150.w,
                      height: 50.w,
                      child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                const Color(0xffffffff)),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.w),
                            ))),
                        onPressed: () {
                          //api보내는 곳
                          //selectedId
                          if(selectedId == 0){
                          print("데이터 없음");

                          }else{
                            confirm(context, postTeacher);

                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(builder: (context) => A6_5()),
                            // );
                          }

                        },
                        child: Text(
                          '확인',
                          style: TextStyle(
                              color: Color(0xff393838),
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 50.w,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          border:
                              Border.all(width: 1.w, color: Color(0xffA666FB)),
                          borderRadius:
                              BorderRadius.all(Radius.circular(10.w))),
                      width: 150.w,
                      height: 50.w,
                      child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                const Color(0xffffffff)),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.w),
                            ))),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          '뒤로',
                          style: TextStyle(
                              color: Color(0xff393838),
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class KindergartenInfo {
  String kindergartenName;
  int kindergartenId;
  bool kindergartenSelected;

  KindergartenInfo({
    required this.kindergartenId,
    required this.kindergartenName,
    required this.kindergartenSelected,
  });
}


confirm(context, Function dataUpload){
  final autoLoginStorage = FlutterSecureStorage();
  return showDialog(
      barrierColor: Colors.transparent,
      context: context, builder: (BuildContext context){
    return Dialog(
      elevation: 0,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.w))),
      child: Container(
        width: 480.w,
        height: 250.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10.w)),
          border: Border.all(width: 1.w, color: Color(0xff7649B7)),
          color: Color(0xffE2D3FE),
        ),
        child: Column(
          children: [
            SizedBox(
              height: 45.w,
            ),
            Text('이후 진행시 담임선생님으로 역할이 고정 되며\n다른 역할로 바꿀수 없습니다.\n정말로 진행하시겠습니까?',
              style: TextStyle(
                  color: Color(0xff393838),
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w400),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 39.w,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(width: 1.w, color: Color(0xffA666FB)),
                      borderRadius: BorderRadius.all(Radius.circular(10.w))
                  ),
                  width: 150.w,
                  height: 50.w,
                  child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                        MaterialStateProperty.all<Color>(
                            const Color(0xffffffff)),
                        shape: MaterialStateProperty.all<
                            RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.w),
                            ))),
                    onPressed: () {
                      int statusCode = dataUpload();
                      if(statusCode == 200){
                        autoLoginStorage.delete(key: "id");
                        autoLoginStorage.delete(key: "password");
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => A1()),
                        );
                      }
                    },
                    child: Text('확인',
                      style: TextStyle(
                          color: Color(0xff393838),
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w400),
                    ),

                  ),

                ),
                SizedBox(
                  width: 50.w,
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(width: 1.w, color: Color(0xffA666FB)),
                      borderRadius: BorderRadius.all(Radius.circular(10.w))
                  ),
                  width: 150.w,
                  height: 50.w,
                  child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                        MaterialStateProperty.all<Color>(
                            const Color(0xffffffff)),
                        shape: MaterialStateProperty.all<
                            RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.w),
                            ))),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('취소',
                      style: TextStyle(
                          color: Color(0xff393838),
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w400),
                    ),

                  ),

                ),

              ],
            )

          ],
        ),

      ),

    );
  });
}
