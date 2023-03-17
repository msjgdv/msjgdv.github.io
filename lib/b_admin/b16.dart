import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:treasure_map/f_environment/environment_setting.dart';
import 'package:treasure_map/provider/record_management.dart';
import 'package:treasure_map/widgets/api.dart';
import 'package:treasure_map/widgets/custom_container.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../main.dart';
import '../widgets/custom_container.dart';
import '../widgets/token_time_over.dart';
//------------------------기관정보------------------------\\

class B16 extends StatefulWidget {
  const B16({
    Key? key,
    required this.notifyParent,
    required this.b16TextFocus,
  }) : super(key: key);
  final Function(double, double)? notifyParent;
  final FocusNode b16TextFocus;

  @override
  State<B16> createState() => _B16State();
}

class _B16State extends State<B16> {
  static final autoLoginStorage = FlutterSecureStorage();
  late var kindergartenData;
  final ScrollController _scrollController = ScrollController();

  TextEditingController name = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();
  TextEditingController classroomCount = TextEditingController();
  TextEditingController classroomArea = TextEditingController();
  TextEditingController indoorgymCount = TextEditingController();
  TextEditingController indoorgymArea = TextEditingController();
  TextEditingController outdoorgymCount = TextEditingController();
  TextEditingController outdoorgymArea = TextEditingController();
  TextEditingController roofgymCount = TextEditingController();
  TextEditingController roofgymArea = TextEditingController();
  TextEditingController neargymCount = TextEditingController();
  TextEditingController neargymArea = TextEditingController();
  TextEditingController healthroomCount = TextEditingController();
  TextEditingController healthroomArea = TextEditingController();
  TextEditingController restroomCount = TextEditingController();
  TextEditingController restroomArea = TextEditingController();
  TextEditingController kitchenCount = TextEditingController();
  TextEditingController kitchenArea = TextEditingController();
  TextEditingController cafeteriaCount = TextEditingController();
  TextEditingController cafeteriaArea = TextEditingController();
  TextEditingController directorroomCount = TextEditingController();
  TextEditingController directorroomArea = TextEditingController();
  TextEditingController teacherroomCount = TextEditingController();
  TextEditingController teacherroomArea = TextEditingController();
  TextEditingController counselingroomCount = TextEditingController();
  TextEditingController counselingroomArea = TextEditingController();
  TextEditingController otherplaceCount = TextEditingController();
  TextEditingController otherplaceArea = TextEditingController();
  Image? kindergartenImage;
  List<Image?> floorImage = [null,null,null];
  Image? logoImage;

  ApiUrl apiUrl = ApiUrl();

  modifyKindergartenInfo(String method, String value) async {
    http.Response res = await api(apiUrl.kindergarten, 'patch', 'adminToken', {
      method: value
    }, context);
    if(res.statusCode == 200){
      getKindergartenInfo();
    }
  }

  getKindergartenInfo() async {
    http.Response res = await api(apiUrl.kindergartenInfo, 'get', 'adminToken', {}, context);
    if(res.statusCode == 200){
      var kindergartenRB = utf8.decode(res.bodyBytes);
      var kindergartenData = jsonDecode(kindergartenRB);
      setState(() {
        name.text = kindergartenData['name'];
        address.text = kindergartenData['address'];
        phoneNumber.text = kindergartenData['phoneNumber'];
        classroomCount.text = kindergartenData['classroomCount'].toString() == 'null' ? '' : kindergartenData['classroomCount'].toString();
        classroomArea.text = kindergartenData['classroomArea'].toString() == 'null' ? '' : kindergartenData['classroomArea'].toString();
        indoorgymCount.text = kindergartenData['indoorgymCount'].toString() == 'null' ? '' : kindergartenData['indoorgymCount'].toString();
        indoorgymArea.text = kindergartenData['indoorgymArea'].toString() == 'null' ? '' : kindergartenData['indoorgymArea'].toString();
        outdoorgymCount.text = kindergartenData['outdoorgymCount'].toString() == 'null' ? '' : kindergartenData['outdoorgymCount'].toString();
        outdoorgymArea.text = kindergartenData['outdoorgymArea'].toString() == 'null' ? '' : kindergartenData['outdoorgymArea'].toString();
        roofgymCount.text = kindergartenData['roofgymCount'].toString() == 'null' ? '' : kindergartenData['roofgymCount'].toString();
        roofgymArea.text = kindergartenData['roofgymArea'].toString() == 'null' ? '' : kindergartenData['roofgymArea'].toString();
        neargymCount.text = kindergartenData['neargymCount'].toString() == 'null' ? '' : kindergartenData['neargymCount'].toString();
        neargymArea.text = kindergartenData['neargymArea'].toString() == 'null' ? '' : kindergartenData['neargymArea'].toString();
        healthroomCount.text = kindergartenData['healthroomCount'].toString() == 'null' ? '' : kindergartenData['healthroomCount'].toString();
        healthroomArea.text = kindergartenData['healthroomArea'].toString() == 'null' ? '' : kindergartenData['healthroomArea'].toString();
        restroomCount.text = kindergartenData['restroomCount'].toString() == 'null' ? '' : kindergartenData['restroomCount'].toString();
        restroomArea.text = kindergartenData['restroomArea'].toString() == 'null' ? '' : kindergartenData['restroomArea'].toString();
        kitchenCount.text = kindergartenData['kitchenCount'].toString() == 'null' ? '' : kindergartenData['kitchenCount'].toString();
        kitchenArea.text = kindergartenData['kitchenArea'].toString() == 'null' ? '' : kindergartenData['kitchenArea'].toString();
        cafeteriaCount.text = kindergartenData['cafeteriaCount'].toString() == 'null' ? '' : kindergartenData['cafeteriaCount'].toString();
        cafeteriaArea.text = kindergartenData['cafeteriaArea'].toString() == 'null' ? '' : kindergartenData['cafeteriaArea'].toString();
        directorroomCount.text = kindergartenData['directorroomCount'].toString() == 'null' ? '' : kindergartenData['directorroomCount'].toString();
        directorroomArea.text = kindergartenData['directorroomArea'].toString() == 'null' ? '' : kindergartenData['directorroomArea'].toString();
        teacherroomCount.text = kindergartenData['teacherroomCount'].toString() == 'null' ? '' : kindergartenData['teacherroomCount'].toString();
        teacherroomArea.text = kindergartenData['teacherroomArea'].toString() == 'null' ? '' : kindergartenData['teacherroomArea'].toString();
        counselingroomCount.text = kindergartenData['counselingroomCount'].toString() == 'null' ? '' : kindergartenData['counselingroomCount'].toString();
        counselingroomArea.text = kindergartenData['counselingroomArea'].toString() == 'null' ? '' : kindergartenData['counselingroomArea'].toString();
        otherplaceCount.text = kindergartenData['otherplaceCount'].toString() == 'null' ? '' : kindergartenData['otherplaceCount'].toString();
        otherplaceArea.text = kindergartenData['otherplaceArea'].toString() == 'null' ? '' : kindergartenData['otherplaceArea'].toString();
      });
        if (kindergartenData['imagePath'] != null) {
          kindergartenImage = await imageApi(kindergartenData['imagePath'], 'adminToken', context);
        } else {
          kindergartenImage = null;
        }
        if (kindergartenData['logoPath'] != null) {
          logoImage = await imageApi(kindergartenData['logoPath'], 'adminToken', context);
        } else {
          logoImage = null;
        }

        int j = 0;
        for (int i = 0; i < 3; i++) {
          if (kindergartenData["floorPathNumbers"].contains(i + 1)) {
            floorImage[i] = await imageApi(kindergartenData['floorPaths'][j], 'adminToken', context);
            j++;
          }else{
            floorImage[i] = null;
          }
        }
        setState(() {});
    }
  }

  @override
  initState() {
    getKindergartenInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 43.w,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 22.w,
            ),
            Text(
              "기관정보",
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w500,
                color: const Color(0xff393838),
              ),
            ),
            SizedBox(
              height: 30.w,
            ),
            SizedBox(
              height: 550.w,
              width: 910.w,
              child: Scrollbar(
                isAlwaysShown: true,
                controller : _scrollController,
                child: ScrollConfiguration(
                  behavior: const ScrollBehavior().copyWith(overscroll: false),
                  child: ListView(
                    controller : _scrollController, 
    padding: EdgeInsets.zero,
                    physics: const RangeMaintainingScrollPhysics(),
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          CustomContainer(
                            cLeftBorderWidth: 1.w,
                            cTopBorderWidth: 1.w,
                            cInsideColor: const Color(0xffFFEFD3),
                            cBorderColor: const Color(0xffFDB43B),
                            cTotalWidth: 660.w,
                            cTotalHeight: 40.w,
                            cBorderRadius:
                                BorderRadius.only(topLeft: Radius.circular(10.w)),
                            childWidget: Center(
                              child: Text(
                                "기관정보",
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xff393838),
                                ),
                              ),
                            ),
                          ),
                          CustomContainer(
                            cLeftBorderWidth: 1.w,
                            cTopBorderWidth: 1.w,
                            cRightBorderWidth: 1.w,
                            cInsideColor: const Color(0xffFED796),
                            cBorderColor: const Color(0xffFDB43B),
                            cBorderRadius:
                                BorderRadius.only(topRight: Radius.circular(10.w)),
                            cTotalWidth: 250.w,
                            cTotalHeight: 40.w,
                            childWidget: Center(
                              child: Text(
                                "로고",
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xff393838),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Column(
                            children: [
                              Row(
                                children: [
                                  CustomContainer(
                                    cLeftBorderWidth: 1.w,
                                    cTopBorderWidth: 1.w,
                                    cInsideColor: const Color(0xffFED796),
                                    cBorderColor: const Color(0xffFDB43B),
                                    cTotalWidth: 80.w,
                                    cTotalHeight: 40.w,
                                    childWidget: Center(
                                      child: Text(
                                        "기관 명",
                                        style: TextStyle(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w400,
                                          color: const Color(0xff393838),
                                        ),
                                      ),
                                    ),
                                  ),
                                  CustomContainer(
                                    cLeftBorderWidth: 1.w,
                                    cTopBorderWidth: 1.w,

                                    cInsideColor: const Color(0xffffffff),
                                    cBorderColor: const Color(0xffFDB43B),
                                    cTotalWidth: 580.w,
                                    cTotalHeight: 40.w,
                                    // cBorderRadius: BorderRadius.only(topRight: Radius.circular(10.w)),
                                    childWidget: Focus(
                                      focusNode: widget.b16TextFocus,
                                      onFocusChange: (hasFocus) {
                                        if (hasFocus) {
                                        } else {
                                          if (kindergartenData["name"] == name.text) {
                                          } else {
                                            modifyKindergartenInfo(
                                                "name", name.text);
                                          }
                                        }
                                      },
                                      child: TextField(
                                        textAlignVertical: TextAlignVertical.center,
                                        style: TextStyle(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w400,
                                          color: const Color(0xff393838),
                                        ),
                                        controller: name,
                                        // focusNode: widget.b16TextFocus,
                                        textAlign: TextAlign.center,
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.all(8.0.w),
                                          // hintText: widget.getEmotionData.comment,
                                          border: const OutlineInputBorder(
                                            borderSide: BorderSide.none,
                                          ), //외곽선
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),

                              Row(
                                children: [
                                  CustomContainer(
                                    cLeftBorderWidth: 1.w,
                                    cTopBorderWidth: 1.w,
                                    cInsideColor: const Color(0xffFED796),
                                    cBorderColor: const Color(0xffFDB43B),
                                    cTotalWidth: 80.w,
                                    cTotalHeight: 40.w,
                                    childWidget: Center(
                                      child: Text(
                                        "주소",
                                        style: TextStyle(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w400,
                                          color: const Color(0xff393838),
                                        ),
                                      ),
                                    ),
                                  ),
                                  CustomContainer(
                                    cLeftBorderWidth: 1.w,
                                    cTopBorderWidth: 1.w,

                                    cInsideColor: const Color(0xffffffff),
                                    cBorderColor: const Color(0xffFDB43B),
                                    cTotalWidth: 300.w,
                                    cTotalHeight: 40.w,
                                    // cBorderRadius: BorderRadius.only(topRight: Radius.circular(10.w)),
                                    childWidget: Focus(
                                      focusNode: widget.b16TextFocus,
                                      onFocusChange: (hasFocus) {
                                        if (hasFocus) {
                                        } else {
                                          if (kindergartenData["address"] == address.text) {
                                          } else {
                                            modifyKindergartenInfo(
                                                "address", address.text);
                                          }
                                        }
                                      },
                                      child: TextField(
                                        textAlignVertical: TextAlignVertical.center,
                                        style: TextStyle(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w400,
                                          color: const Color(0xff393838),
                                        ),
                                        controller: address,
                                        textAlign: TextAlign.center,
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.all(8.0.w),
                                          // hintText: widget.getEmotionData.comment,
                                          border: const OutlineInputBorder(
                                            borderSide: BorderSide.none,
                                          ), //외곽선
                                        ),
                                      ),
                                    ),
                                  ),
                                  CustomContainer(
                                    cLeftBorderWidth: 1.w,
                                    cTopBorderWidth: 1.w,
                                    cInsideColor: const Color(0xffFED796),
                                    cBorderColor: const Color(0xffFDB43B),
                                    cTotalWidth: 80.w,
                                    cTotalHeight: 40.w,
                                    childWidget: Center(
                                      child: Text(
                                        "연락처",
                                        style: TextStyle(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w400,
                                          color: const Color(0xff393838),
                                        ),
                                      ),
                                    ),
                                  ),
                                  CustomContainer(
                                    cLeftBorderWidth: 1.w,
                                    cTopBorderWidth: 1.w,

                                    cInsideColor: const Color(0xffffffff),
                                    cBorderColor: const Color(0xffFDB43B),
                                    cTotalWidth: 200.w,
                                    cTotalHeight: 40.w,
                                    // cBorderRadius: BorderRadius.only(topRight: Radius.circular(10.w)),
                                    childWidget: Focus(
                                      focusNode: widget.b16TextFocus,
                                      onFocusChange: (hasFocus) {
                                        if (hasFocus) {
                                        } else {
                                          if (kindergartenData["phoneNumber"] ==
                                              phoneNumber.text) {
                                          } else {
                                            modifyKindergartenInfo(
                                                "phoneNumber", phoneNumber.text);
                                          }
                                        }
                                      },
                                      child: TextField(
                                        textAlignVertical: TextAlignVertical.center,
                                        style: TextStyle(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w400,
                                          color: const Color(0xff393838),
                                        ),
                                        controller: phoneNumber,
                                        textAlign: TextAlign.center,
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.all(8.0.w),
                                          // hintText: widget.getEmotionData.comment,
                                          border: const OutlineInputBorder(
                                            borderSide: BorderSide.none,
                                          ), //외곽선
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  CustomContainer(
                                    cLeftBorderWidth: 1.w,
                                    cTopBorderWidth: 1.w,
                                    cInsideColor: const Color(0xffFED796),
                                    cBorderColor: const Color(0xffFDB43B),
                                    cTotalWidth: 80.w,
                                    cTotalHeight: 40.w,
                                    childWidget: Center(
                                      child: Text(
                                        "원장",
                                        style: TextStyle(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w400,
                                          color: const Color(0xff393838),
                                        ),
                                      ),
                                    ),
                                  ),
                                  CustomContainer(
                                    cLeftBorderWidth: 1.w,
                                    cTopBorderWidth: 1.w,

                                    cInsideColor: const Color(0xffffffff),
                                    cBorderColor: const Color(0xffFDB43B),
                                    cTotalWidth: 300.w,
                                    cTotalHeight: 40.w,
                                    // cBorderRadius: BorderRadius.only(topRight: Radius.circular(10.w)),
                                    childWidget: Center(
                                      child: Text(
                                        "민선옥",
                                        style: TextStyle(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w400,
                                          color: const Color(0xff393838),
                                        ),
                                      ),
                                    ),
                                  ),
                                  CustomContainer(
                                    cLeftBorderWidth: 1.w,
                                    cTopBorderWidth: 1.w,
                                    cInsideColor: const Color(0xffFED796),
                                    cBorderColor: const Color(0xffFDB43B),
                                    cTotalWidth: 80.w,
                                    cTotalHeight: 40.w,
                                    childWidget: Center(
                                      child: Text(
                                        "전화번호",
                                        style: TextStyle(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w400,
                                          color: const Color(0xff393838),
                                        ),
                                      ),
                                    ),
                                  ),
                                  CustomContainer(
                                    cLeftBorderWidth: 1.w,
                                    cTopBorderWidth: 1.w,

                                    cInsideColor: const Color(0xffffffff),
                                    cBorderColor: const Color(0xffFDB43B),
                                    cTotalWidth: 200.w,
                                    cTotalHeight: 40.w,
                                    // cBorderRadius: BorderRadius.only(topRight: Radius.circular(10.w)),
                                    childWidget: Center(
                                      child: Text(
                                        '010-1234-5678',
                                        style: TextStyle(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w400,
                                          color: const Color(0xff393838),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: () async{
                              var image = await pickImage(context, 400, 490, false);
                              imagePostApi(apiUrl.kindergartenImage, 'adminToken', {
                                "number" : '1',
                                "type" : "logo",
                              }, image, 'post', context, getKindergartenInfo);
                            },
                            child: CustomContainer(
                              cLeftBorderWidth: 1.w,
                              cTopBorderWidth: 1.w,
                              cRightBorderWidth: 1.w,
                              cInsideColor: const Color(0xffffffff),
                              cBorderColor: const Color(0xffFDB43B),
                              // cBorderRadius: BorderRadius.only(topLeft: Radius.circular(10.w)) ,
                              cTotalWidth: 250.w,
                              cTotalHeight: 120.w,
                              childWidget: logoImage == null ? Center(
                                child: Container(
                                  width: 35.w,
                                  height: 35.w,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(10.w)),
                                    // border: Border.all(color: const Color(0xffA666FB), width: 1.w),
                                    color: const Color(0xffffffff),
                                  ),
                                  child: Center(
                                      child: Icon(
                                        Icons.add_outlined,
                                        color: const Color(0xffA666FB),
                                        size: 25.w,
                                      )),
                                ),
                              ) : Stack(
                                children: [
                                  Center(
                                    child: Container(
                                        padding : EdgeInsets.all(10.w),
                                        child: logoImage),
                                  ),
                                  Positioned(
                                      top: 8.w,
                                      right: 8.w,

                                      child: GestureDetector(
                                        onTap: (){
                                          deleteImage(context, "logo", -1, getKindergartenInfo);
                                        },
                                        child: Container(
                                            width: 25.w,
                                            height: 25.w,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              shape: BoxShape.circle,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Color(0x29B1B1B1),
                                                  blurRadius: 6,
                                                  offset: Offset(-2, 2),
                                                )
                                              ],
                                            ),
                                            child: Icon(Icons.remove_outlined,size: 25.w,color: Color(0xffA666FB),)),))
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          CustomContainer(
                            cLeftBorderWidth: 1.w,
                            cTopBorderWidth: 1.w,
                            cInsideColor: const Color(0xffFED796),
                            cBorderColor: const Color(0xffFDB43B),
                            cTotalWidth: 80.w,
                            cTotalHeight: 200.w,
                            childWidget: Center(
                              child: Text(
                                "시설 사진",
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xff393838),
                                ),
                              ),
                            ),
                          ),
                          Column(
                            children: [
                              CustomContainer(
                                cLeftBorderWidth: 1.w,
                                cTopBorderWidth: 1.w,
                                cInsideColor: const Color(0xffFFEFD3),
                                cBorderColor: const Color(0xffFDB43B),
                                cTotalWidth: 135.w,
                                cTotalHeight: 40.w,
                                childWidget: Center(
                                  child: Text(
                                    "전경사진",
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w400,
                                      color: const Color(0xff393838),
                                    ),
                                  ),
                                ),
                              ),
                              CustomContainer(
                                cLeftBorderWidth: 1.w,
                                cTopBorderWidth: 1.w,
                                cInsideColor: const Color(0xffffffff),
                                cBorderColor: const Color(0xffFDB43B),
                                cTotalWidth: 135.w,
                                cTotalHeight: 160.w,
                                childWidget: Center(
                                    child: GestureDetector(
                                  onTap: () async{
                                    var image = await pickImage(context, 400, 490, true);
                                    imagePostApi(apiUrl.kindergartenImage, 'adminToken', {
                                      "number" : '1',
                                      "type" : "image",
                                    }, image, 'post', context, getKindergartenInfo);
                                  },
                                  child: DottedBorder(
                                      dashPattern: [10, 10],
                                      strokeWidth: 2,
                                      color: const Color(0xFFFED796),
                                      borderType: BorderType.RRect,
                                      strokeCap: StrokeCap.round,
                                      radius: Radius.circular(10.w),
                                      borderPadding: EdgeInsets.all(0.w),
                                      child: Container(
                                        width: 122.w,
                                        height: 150.w,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.w)),
                                          // border: Border.all(color: const Color(0xffA666FB), width: 1.w, style: BorderStyle.),
                                          color: const Color(0xffffffff),
                                        ),
                                        child: kindergartenImage == null? Center(
                                                child: Container(
                                                  width: 35.w,
                                                  height: 35.w,
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.all(
                                                        Radius.circular(10.w)),
                                                    // border: Border.all(color: const Color(0xffA666FB), width: 1.w),
                                                    color: const Color(0xffffffff),
                                                  ),
                                                  child: Center(
                                                      child: Icon(
                                                    Icons.add_outlined,
                                                    color: const Color(0xffA666FB),
                                                    size: 25.w,
                                                  )),
                                                ),
                                              ):Container(
                                            width: 35.w,
                                            height: 35.w,
                                            child: Stack(
                                              children: [
                                                Center(
                                                  child: ClipRRect(
                                                    borderRadius: BorderRadius.circular(10.w),
                                                    child: kindergartenImage,
                                                  ),
                                                ),
                                                Positioned(
                                                    top: 8.w,
                                                    right: 8.w,

                                                    child: GestureDetector(
                                                      onTap: (){
                                                        deleteImage(context, "image", -1, getKindergartenInfo);
                                                      },
                                                      child: Container(
                                                          width: 25.w,
                                                          height: 25.w,
                                                          decoration: BoxDecoration(
                                                            color: Colors.white,
                                                            shape: BoxShape.circle,
                                                            boxShadow: [
                                                              BoxShadow(
                                                                color: Color(0x29B1B1B1),
                                                                blurRadius: 6,
                                                                offset: Offset(-2, 2),
                                                              )
                                                            ],
                                                          ),
                                                          child: Icon(Icons.remove_outlined,size: 25.w,color: Color(0xffA666FB),)),))
                                              ],
                                            )),
                                      )),
                                )),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              CustomContainer(
                                cLeftBorderWidth: 1.w,
                                cTopBorderWidth: 1.w,
                                cRightBorderWidth: 1.w,
                                cInsideColor: const Color(0xffFFEFD3),
                                cBorderColor: const Color(0xffFDB43B),
                                cTotalWidth: 695.w,
                                cTotalHeight: 40.w,
                                childWidget: Center(
                                  child: Text(
                                    "배치도",
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w400,
                                      color: const Color(0xff393838),
                                    ),
                                  ),
                                ),
                              ),
                              CustomContainer(
                                cLeftBorderWidth: 1.w,
                                cTopBorderWidth: 1.w,
                                cRightBorderWidth: 1.w,
                                cInsideColor: const Color(0xffffffff),
                                cBorderColor: const Color(0xffFDB43B),
                                cTotalWidth: 695.w,
                                cTotalHeight: 160.w,
                                childWidget: Row(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children:[
                                      GestureDetector(
                                        onTap: () async{
                                          var image = await pickImage(context, 1000, 445, false);
                                          imagePostApi(apiUrl.kindergartenImage, 'adminToken', {
                                            "number" : '1',
                                            "type" : "floor",
                                          }, image, 'post', context, getKindergartenInfo);
                                        },
                                        child: DottedBorder(
                                            dashPattern: [10, 10],
                                            strokeWidth: 2,
                                            color: const Color(0xFFFED796),
                                            borderType: BorderType.RRect,
                                            strokeCap: StrokeCap.round,
                                            radius: Radius.circular(10.w),
                                            borderPadding: EdgeInsets.all(0.w),
                                            child: Container(
                                              width: 200.w,
                                              height: 80.w,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10.w)),
                                                // border: Border.all(color: const Color(0xffA666FB), width: 1.w, style: BorderStyle.),
                                                color: const Color(0xffffffff),
                                              ),
                                              child: floorImage[0] == null? Center(
                                                child: Container(
                                                  width: 35.w,
                                                  height: 35.w,
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.all(
                                                        Radius.circular(10.w)),
                                                    // border: Border.all(color: const Color(0xffA666FB), width: 1.w),
                                                    color: const Color(0xffffffff),
                                                  ),
                                                  child: Center(
                                                      child: Icon(
                                                        Icons.add_outlined,
                                                        color: const Color(0xffA666FB),
                                                        size: 25.w,
                                                      )),
                                                ),
                                              ):Container(
                                                  width: 200.w,
                                                  height: 80.w,
                                                  child: Stack(
                                                    children: [
                                                      Center(
                                                        child: ClipRRect(
                                                          borderRadius: BorderRadius.circular(10.w),
                                                          child: floorImage[0],
                                                        ),
                                                      ),
                                                      Positioned(
                                                          top: 8.w,
                                                          right: 8.w,

                                                          child: GestureDetector(
                                                            onTap: (){
                                                              deleteImage(context, "floor", 0, getKindergartenInfo);
                                                            },
                                                            child: Container(
                                                                width: 25.w,
                                                                height: 25.w,
                                                                decoration: BoxDecoration(
                                                                  color: Colors.white,
                                                                  shape: BoxShape.circle,
                                                                  boxShadow: [
                                                                    BoxShadow(
                                                                      color: Color(0x29B1B1B1),
                                                                      blurRadius: 6,
                                                                      offset: Offset(-2, 2),
                                                                    )
                                                                  ],
                                                                ),
                                                                child: Icon(Icons.remove_outlined,size: 25.w,color: Color(0xffA666FB),)),))
                                                    ],
                                                  )),
                                            )),
                                      ),
                                      GestureDetector(
                                        onTap: () async{
                                          var image = await pickImage(context, 1000, 445, false);
                                          imagePostApi(apiUrl.kindergartenImage, 'adminToken', {
                                            "number" : '2',
                                            "type" : "floor",
                                          }, image, 'post', context, getKindergartenInfo);
                                        },
                                        child: DottedBorder(
                                            dashPattern: [10, 10],
                                            strokeWidth: 2,
                                            color: const Color(0xFFFED796),
                                            borderType: BorderType.RRect,
                                            strokeCap: StrokeCap.round,
                                            radius: Radius.circular(10.w),
                                            borderPadding: EdgeInsets.all(0.w),
                                            child: Container(
                                              width: 200.w,
                                              height: 80.w,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10.w)),
                                                // border: Border.all(color: const Color(0xffA666FB), width: 1.w, style: BorderStyle.),
                                                color: const Color(0xffffffff),
                                              ),
                                              child: floorImage[1] == null? Center(
                                                child: Container(
                                                  width: 35.w,
                                                  height: 35.w,
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.all(
                                                        Radius.circular(10.w)),
                                                    // border: Border.all(color: const Color(0xffA666FB), width: 1.w),
                                                    color: const Color(0xffffffff),
                                                  ),
                                                  child: Center(
                                                      child: Icon(
                                                        Icons.add_outlined,
                                                        color: const Color(0xffA666FB),
                                                        size: 25.w,
                                                      )),
                                                ),
                                              ):Container(
                                                      width: 200.w,
                                                  height: 80.w,
                                                  child: Stack(
                                                    children: [
                                                      Center(
                                                        child: ClipRRect(
                                                          borderRadius: BorderRadius.circular(10.w),
                                                          child: floorImage[1],
                                                        ),
                                                      ),
                                                      Positioned(
                                                          top: 8.w,
                                                          right: 8.w,

                                                          child: GestureDetector(
                                                            onTap: (){
                                                              deleteImage(context, "floor", 1, getKindergartenInfo);
                                                            },
                                                            child: Container(
                                                                width: 25.w,
                                                                height: 25.w,
                                                                decoration: BoxDecoration(
                                                                  color: Colors.white,
                                                                  shape: BoxShape.circle,
                                                                  boxShadow: [
                                                                    BoxShadow(
                                                                      color: Color(0x29B1B1B1),
                                                                      blurRadius: 6,
                                                                      offset: Offset(-2, 2),
                                                                    )
                                                                  ],
                                                                ),
                                                                child: Icon(Icons.remove_outlined,size: 25.w,color: Color(0xffA666FB),)),))
                                                    ],
                                                  )),
                                            )),
                                      ),
                                      GestureDetector(
                                        onTap: () async{
                                          var image = await pickImage(context, 1000, 445, false);
                                          imagePostApi(apiUrl.kindergartenImage, 'adminToken', {
                                            "number" : '3',
                                            "type" : "floor",
                                          }, image, 'post', context, getKindergartenInfo);
                                        },
                                        child: DottedBorder(
                                            dashPattern: [10, 10],
                                            strokeWidth: 2,
                                            color: const Color(0xFFFED796),
                                            borderType: BorderType.RRect,
                                            strokeCap: StrokeCap.round,
                                            radius: Radius.circular(10.w),
                                            borderPadding: EdgeInsets.all(0.w),
                                            child: Container(
                                              width: 200.w,
                                              height: 80.w,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10.w)),
                                                // border: Border.all(color: const Color(0xffA666FB), width: 1.w, style: BorderStyle.),
                                                color: const Color(0xffffffff),
                                              ),
                                              child: floorImage[2] == null? Center(
                                                child: Container(
                                                  width: 35.w,
                                                  height: 35.w,
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.all(
                                                        Radius.circular(10.w)),
                                                    // border: Border.all(color: const Color(0xffA666FB), width: 1.w),
                                                    color: const Color(0xffffffff),
                                                  ),
                                                  child: Center(
                                                      child: Icon(
                                                        Icons.add_outlined,
                                                        color: const Color(0xffA666FB),
                                                        size: 25.w,
                                                      )),
                                                ),
                                              ):Container(
                                                  width: 200.w,
                                                  height: 80.w,
                                                  child: Stack(
                                                    children: [
                                                      Center(
                                                        child: ClipRRect(
                                                          borderRadius: BorderRadius.circular(10.w),
                                                          child: floorImage[2],
                                                        ),
                                                      ),
                                                      Positioned(
                                                          top: 8.w,
                                                          right: 8.w,

                                                          child: GestureDetector(
                                                            onTap: (){
                                                              deleteImage(context, "floor", 2, getKindergartenInfo);
                                                            },
                                                            child: Container(
                                                                width: 25.w,
                                                                height: 25.w,
                                                                decoration: BoxDecoration(
                                                                  color: Colors.white,
                                                                  shape: BoxShape.circle,
                                                                  boxShadow: [
                                                                    BoxShadow(
                                                                      color: Color(0x29B1B1B1),
                                                                      blurRadius: 6,
                                                                      offset: Offset(-2, 2),
                                                                    )
                                                                  ],
                                                                ),
                                                                child: Icon(Icons.remove_outlined,size: 25.w,color: Color(0xffA666FB),)),))
                                                    ],
                                                  )),
                                            )),
                                      ),
                                    ]
                                )
                              ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          CustomContainer(
                            cLeftBorderWidth: 1.w,
                            cTopBorderWidth: 1.w,
                            cBottomBorderWidth: 1.w,
                            cBorderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(10.w)),
                            cInsideColor: const Color(0xffFED796),
                            cBorderColor: const Color(0xffFDB43B),
                            cTotalWidth: 80.w,
                            cTotalHeight: 360.w,
                            childWidget: Center(
                              child: Text(
                                "시설 정보",
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xff393838),
                                ),
                              ),
                            ),
                          ),
                          Column(
                            children: [
                              Row(
                                children: [
                                  Column(
                                    children: [
                                      CustomContainer(
                                        cLeftBorderWidth: 1.w,
                                        cTopBorderWidth: 1.w,
                                        cInsideColor: const Color(0xffFFEFD3),
                                        cBorderColor: const Color(0xffFDB43B),
                                        cTotalWidth: 166.w,
                                        cTotalHeight: 40.w,
                                        childWidget: Center(
                                          child: Text(
                                            "교실",
                                            style: TextStyle(
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w400,
                                              color: const Color(0xff393838),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          CustomContainer(
                                            cLeftBorderWidth: 1.w,
                                            cTopBorderWidth: 1.w,
                                            cInsideColor: const Color(0xffFED796),
                                            cBorderColor: const Color(0xffFDB43B),
                                            cTotalWidth: 83.w,
                                            cTotalHeight: 40.w,
                                            childWidget: Center(
                                              child: Text(
                                                "교실수",
                                                style: TextStyle(
                                                  fontSize: 16.sp,
                                                  fontWeight: FontWeight.w400,
                                                  color: const Color(0xff393838),
                                                ),
                                              ),
                                            ),
                                          ),
                                          CustomContainer(
                                            cLeftBorderWidth: 1.w,
                                            cTopBorderWidth: 1.w,
                                            cInsideColor: const Color(0xffFED796),
                                            cBorderColor: const Color(0xffFDB43B),
                                            cTotalWidth: 83.w,
                                            cTotalHeight: 40.w,
                                            childWidget: Center(
                                              child: Text(
                                                "면적",
                                                style: TextStyle(
                                                  fontSize: 16.sp,
                                                  fontWeight: FontWeight.w400,
                                                  color: const Color(0xff393838),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),

                                      //교실 - 교실수
                                      Row(
                                        children: [
                                          CustomContainer(
                                            cLeftBorderWidth: 1.w,
                                            cTopBorderWidth: 1.w,
                                            cInsideColor: const Color(0xffffffff),
                                            cBorderColor: const Color(0xffFDB43B),
                                            cTotalWidth: 83.w,
                                            cTotalHeight: 40.w,
                                            childWidget: Focus(
                                              focusNode: widget.b16TextFocus,
                                              onFocusChange: (hasFocus) {
                                                if (hasFocus) {
                                                } else {
                                                  if (kindergartenData["classroomCount"].toString() ==
                                                      classroomCount.text) {
                                                  } else {
                                                    modifyKindergartenInfo(
                                                        "classroomCount",
                                                        classroomCount.text);
                                                  }
                                                }
                                              },
                                              child: TextField(
                                                textAlignVertical:
                                                    TextAlignVertical.center,
                                                style: TextStyle(
                                                  fontSize: 16.sp,
                                                  fontWeight: FontWeight.w400,
                                                  color: const Color(0xff393838),
                                                ),
                                                controller: classroomCount,
                                                textAlign: TextAlign.center,
                                                decoration: InputDecoration(
                                                  contentPadding:
                                                      EdgeInsets.all(8.0.w),
                                                  // hintText: widget.getEmotionData.comment,
                                                  border: const OutlineInputBorder(
                                                    borderSide: BorderSide.none,
                                                  ), //외곽선
                                                ),
                                              ),
                                            ),
                                          ),

                                          //교실 - 면적
                                          CustomContainer(
                                            cLeftBorderWidth: 1.w,
                                            cTopBorderWidth: 1.w,
                                            cInsideColor: const Color(0xffffffff),
                                            cBorderColor: const Color(0xffFDB43B),
                                            cTotalWidth: 83.w,
                                            cTotalHeight: 40.w,
                                            childWidget: Focus(
                                              focusNode: widget.b16TextFocus,
                                              onFocusChange: (hasFocus) {
                                                if (hasFocus) {
                                                } else {
                                                  if (kindergartenData["classroomArea"].toString() ==
                                                      classroomArea.text) {
                                                  } else {
                                                    modifyKindergartenInfo(
                                                        "classroomArea",
                                                        classroomArea.text);
                                                  }
                                                }
                                              },
                                              child: TextField(
                                                textAlignVertical:
                                                    TextAlignVertical.center,
                                                style: TextStyle(
                                                  fontSize: 16.sp,
                                                  fontWeight: FontWeight.w400,
                                                  color: const Color(0xff393838),
                                                ),
                                                controller: classroomArea,
                                                textAlign: TextAlign.center,
                                                decoration: InputDecoration(
                                                  contentPadding:
                                                      EdgeInsets.all(8.0.w),
                                                  // hintText: widget.getEmotionData.comment,
                                                  border: const OutlineInputBorder(
                                                    borderSide: BorderSide.none,
                                                  ), //외곽선
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      CustomContainer(
                                        cLeftBorderWidth: 1.w,
                                        cTopBorderWidth: 1.w,
                                        cRightBorderWidth: 1.w,
                                        cInsideColor: const Color(0xffFFEFD3),
                                        cBorderColor: const Color(0xffFDB43B),
                                        cTotalWidth: 664.w,
                                        cTotalHeight: 40.w,
                                        childWidget: Center(
                                          child: Text(
                                            "체육실/놀이터",
                                            style: TextStyle(
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w400,
                                              color: const Color(0xff393838),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          CustomContainer(
                                            cLeftBorderWidth: 1.w,
                                            cTopBorderWidth: 1.w,
                                            cInsideColor: const Color(0xffFED796),
                                            cBorderColor: const Color(0xffFDB43B),
                                            cTotalWidth: 83.w,
                                            cTotalHeight: 40.w,
                                            childWidget: Center(
                                              child: Text(
                                                "실내",
                                                style: TextStyle(
                                                  fontSize: 16.sp,
                                                  fontWeight: FontWeight.w400,
                                                  color: const Color(0xff393838),
                                                ),
                                              ),
                                            ),
                                          ),
                                          CustomContainer(
                                            cLeftBorderWidth: 1.w,
                                            cTopBorderWidth: 1.w,
                                            cInsideColor: const Color(0xffFED796),
                                            cBorderColor: const Color(0xffFDB43B),
                                            cTotalWidth: 83.w,
                                            cTotalHeight: 40.w,
                                            childWidget: Center(
                                              child: Text(
                                                "면적",
                                                style: TextStyle(
                                                  fontSize: 16.sp,
                                                  fontWeight: FontWeight.w400,
                                                  color: const Color(0xff393838),
                                                ),
                                              ),
                                            ),
                                          ),
                                          CustomContainer(
                                            cLeftBorderWidth: 1.w,
                                            cTopBorderWidth: 1.w,
                                            cInsideColor: const Color(0xffFED796),
                                            cBorderColor: const Color(0xffFDB43B),
                                            cTotalWidth: 83.w,
                                            cTotalHeight: 40.w,
                                            childWidget: Center(
                                              child: Text(
                                                "실외",
                                                style: TextStyle(
                                                  fontSize: 16.sp,
                                                  fontWeight: FontWeight.w400,
                                                  color: const Color(0xff393838),
                                                ),
                                              ),
                                            ),
                                          ),
                                          CustomContainer(
                                            cLeftBorderWidth: 1.w,
                                            cTopBorderWidth: 1.w,
                                            cInsideColor: const Color(0xffFED796),
                                            cBorderColor: const Color(0xffFDB43B),
                                            cTotalWidth: 83.w,
                                            cTotalHeight: 40.w,
                                            childWidget: Center(
                                              child: Text(
                                                "면적",
                                                style: TextStyle(
                                                  fontSize: 16.sp,
                                                  fontWeight: FontWeight.w400,
                                                  color: const Color(0xff393838),
                                                ),
                                              ),
                                            ),
                                          ),
                                          CustomContainer(
                                            cLeftBorderWidth: 1.w,
                                            cTopBorderWidth: 1.w,
                                            cInsideColor: const Color(0xffFED796),
                                            cBorderColor: const Color(0xffFDB43B),
                                            cTotalWidth: 83.w,
                                            cTotalHeight: 40.w,
                                            childWidget: Center(
                                              child: Text(
                                                "옥상",
                                                style: TextStyle(
                                                  fontSize: 16.sp,
                                                  fontWeight: FontWeight.w400,
                                                  color: const Color(0xff393838),
                                                ),
                                              ),
                                            ),
                                          ),
                                          CustomContainer(
                                            cLeftBorderWidth: 1.w,
                                            cTopBorderWidth: 1.w,
                                            cInsideColor: const Color(0xffFED796),
                                            cBorderColor: const Color(0xffFDB43B),
                                            cTotalWidth: 83.w,
                                            cTotalHeight: 40.w,
                                            childWidget: Center(
                                              child: Text(
                                                "면적",
                                                style: TextStyle(
                                                  fontSize: 16.sp,
                                                  fontWeight: FontWeight.w400,
                                                  color: const Color(0xff393838),
                                                ),
                                              ),
                                            ),
                                          ),
                                          CustomContainer(
                                            cLeftBorderWidth: 1.w,
                                            cTopBorderWidth: 1.w,
                                            cInsideColor: const Color(0xffFED796),
                                            cBorderColor: const Color(0xffFDB43B),
                                            cTotalWidth: 83.w,
                                            cTotalHeight: 40.w,
                                            childWidget: Center(
                                              child: Text(
                                                "인근",
                                                style: TextStyle(
                                                  fontSize: 16.sp,
                                                  fontWeight: FontWeight.w400,
                                                  color: const Color(0xff393838),
                                                ),
                                              ),
                                            ),
                                          ),
                                          CustomContainer(
                                            cLeftBorderWidth: 1.w,
                                            cTopBorderWidth: 1.w,
                                            cRightBorderWidth: 1.w,
                                            cInsideColor: const Color(0xffFED796),
                                            cBorderColor: const Color(0xffFDB43B),
                                            cTotalWidth: 83.w,
                                            cTotalHeight: 40.w,
                                            childWidget: Center(
                                              child: Text(
                                                "면적",
                                                style: TextStyle(
                                                  fontSize: 16.sp,
                                                  fontWeight: FontWeight.w400,
                                                  color: const Color(0xff393838),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      //체육실 - 실내
                                      Row(
                                        children: [
                                          CustomContainer(
                                            cLeftBorderWidth: 1.w,
                                            cTopBorderWidth: 1.w,
                                            cInsideColor: const Color(0xffffffff),
                                            cBorderColor: const Color(0xffFDB43B),
                                            cTotalWidth: 83.w,
                                            cTotalHeight: 40.w,
                                            childWidget: Focus(
                                              focusNode: widget.b16TextFocus,
                                              onFocusChange: (hasFocus) {
                                                if (hasFocus) {
                                                } else {
                                                  if (kindergartenData["indoorgymCount"].toString() ==
                                                      indoorgymCount.text) {
                                                  } else {
                                                    modifyKindergartenInfo(
                                                        "indoorgymCount",
                                                        indoorgymCount.text);
                                                  }
                                                }
                                              },
                                              child: TextField(
                                                textAlignVertical:
                                                    TextAlignVertical.center,
                                                style: TextStyle(
                                                  fontSize: 16.sp,
                                                  fontWeight: FontWeight.w400,
                                                  color: const Color(0xff393838),
                                                ),
                                                controller: indoorgymCount,
                                                textAlign: TextAlign.center,
                                                decoration: InputDecoration(
                                                  contentPadding:
                                                      EdgeInsets.all(8.0.w),
                                                  // hintText: widget.getEmotionData.comment,
                                                  border: const OutlineInputBorder(
                                                    borderSide: BorderSide.none,
                                                  ), //외곽선
                                                ),
                                              ),
                                            ),
                                          ),
                                          //체육실 실내 면적
                                          CustomContainer(
                                            cLeftBorderWidth: 1.w,
                                            cTopBorderWidth: 1.w,
                                            cInsideColor: const Color(0xffffffff),
                                            cBorderColor: const Color(0xffFDB43B),
                                            cTotalWidth: 83.w,
                                            cTotalHeight: 40.w,
                                            childWidget: Focus(
                                              focusNode: widget.b16TextFocus,
                                              onFocusChange: (hasFocus) {
                                                if (hasFocus) {
                                                } else {
                                                  if (kindergartenData["indoorgymArea"].toString() ==
                                                      indoorgymArea.text) {
                                                  } else {
                                                    modifyKindergartenInfo(
                                                        "indoorgymArea",
                                                        indoorgymArea.text);
                                                  }
                                                }
                                              },
                                              child: TextField(
                                                textAlignVertical:
                                                    TextAlignVertical.center,
                                                style: TextStyle(
                                                  fontSize: 16.sp,
                                                  fontWeight: FontWeight.w400,
                                                  color: const Color(0xff393838),
                                                ),
                                                controller: indoorgymArea,
                                                textAlign: TextAlign.center,
                                                decoration: InputDecoration(
                                                  contentPadding:
                                                      EdgeInsets.all(8.0.w),
                                                  // hintText: widget.getEmotionData.comment,
                                                  border: const OutlineInputBorder(
                                                    borderSide: BorderSide.none,
                                                  ), //외곽선
                                                ),
                                              ),
                                            ),
                                          ),
                                          //체육실 실외
                                          CustomContainer(
                                            cLeftBorderWidth: 1.w,
                                            cTopBorderWidth: 1.w,
                                            cInsideColor: const Color(0xffffffff),
                                            cBorderColor: const Color(0xffFDB43B),
                                            cTotalWidth: 83.w,
                                            cTotalHeight: 40.w,
                                            childWidget: Focus(
                                              focusNode: widget.b16TextFocus,
                                              onFocusChange: (hasFocus) {
                                                if (hasFocus) {
                                                } else {
                                                  if (kindergartenData["outdoorgymCount"].toString() ==
                                                      outdoorgymCount.text) {
                                                  } else {
                                                    modifyKindergartenInfo(
                                                        "outdoorgymCount",
                                                        outdoorgymCount.text);
                                                  }
                                                }
                                              },
                                              child: TextField(
                                                textAlignVertical:
                                                    TextAlignVertical.center,
                                                style: TextStyle(
                                                  fontSize: 16.sp,
                                                  fontWeight: FontWeight.w400,
                                                  color: const Color(0xff393838),
                                                ),
                                                controller: outdoorgymCount,
                                                textAlign: TextAlign.center,
                                                decoration: InputDecoration(
                                                  contentPadding:
                                                      EdgeInsets.all(8.0.w),
                                                  // hintText: widget.getEmotionData.comment,
                                                  border: const OutlineInputBorder(
                                                    borderSide: BorderSide.none,
                                                  ), //외곽선
                                                ),
                                              ),
                                            ),
                                          ),
                                          //체육실 실외 면적
                                          CustomContainer(
                                            cLeftBorderWidth: 1.w,
                                            cTopBorderWidth: 1.w,
                                            cInsideColor: const Color(0xffffffff),
                                            cBorderColor: const Color(0xffFDB43B),
                                            cTotalWidth: 83.w,
                                            cTotalHeight: 40.w,
                                            childWidget: Focus(
                                              focusNode: widget.b16TextFocus,
                                              onFocusChange: (hasFocus) {
                                                if (hasFocus) {
                                                } else {
                                                  if (kindergartenData["outdoorgymArea"].toString() ==
                                                      outdoorgymArea.text) {
                                                  } else {
                                                    modifyKindergartenInfo(
                                                        "outdoorgymArea",
                                                        outdoorgymArea.text);
                                                  }
                                                }
                                              },
                                              child: TextField(
                                                textAlignVertical:
                                                    TextAlignVertical.center,
                                                style: TextStyle(
                                                  fontSize: 16.sp,
                                                  fontWeight: FontWeight.w400,
                                                  color: const Color(0xff393838),
                                                ),
                                                controller: outdoorgymArea,
                                                textAlign: TextAlign.center,
                                                decoration: InputDecoration(
                                                  contentPadding:
                                                      EdgeInsets.all(8.0.w),
                                                  // hintText: widget.getEmotionData.comment,
                                                  border: const OutlineInputBorder(
                                                    borderSide: BorderSide.none,
                                                  ), //외곽선
                                                ),
                                              ),
                                            ),
                                          ),
                                          //체육실 옥상
                                          CustomContainer(
                                            cLeftBorderWidth: 1.w,
                                            cTopBorderWidth: 1.w,
                                            cInsideColor: const Color(0xffffffff),
                                            cBorderColor: const Color(0xffFDB43B),
                                            cTotalWidth: 83.w,
                                            cTotalHeight: 40.w,
                                            childWidget: Focus(
                                              focusNode: widget.b16TextFocus,
                                              onFocusChange: (hasFocus) {
                                                if (hasFocus) {
                                                } else {
                                                  if (kindergartenData["roofgymCount"].toString() ==
                                                      roofgymCount.text) {
                                                  } else {
                                                    modifyKindergartenInfo(
                                                        "roofgymCount",
                                                        roofgymCount.text);
                                                  }
                                                }
                                              },
                                              child: TextField(
                                                textAlignVertical:
                                                    TextAlignVertical.center,
                                                style: TextStyle(
                                                  fontSize: 16.sp,
                                                  fontWeight: FontWeight.w400,
                                                  color: const Color(0xff393838),
                                                ),
                                                controller: roofgymCount,
                                                textAlign: TextAlign.center,
                                                decoration: InputDecoration(
                                                  contentPadding:
                                                      EdgeInsets.all(8.0.w),
                                                  // hintText: widget.getEmotionData.comment,
                                                  border: const OutlineInputBorder(
                                                    borderSide: BorderSide.none,
                                                  ), //외곽선
                                                ),
                                              ),
                                            ),
                                          ),
                                          //체육실 옥상 면적
                                          CustomContainer(
                                            cLeftBorderWidth: 1.w,
                                            cTopBorderWidth: 1.w,
                                            cInsideColor: const Color(0xffffffff),
                                            cBorderColor: const Color(0xffFDB43B),
                                            cTotalWidth: 83.w,
                                            cTotalHeight: 40.w,
                                            childWidget: Focus(
                                              focusNode: widget.b16TextFocus,
                                              onFocusChange: (hasFocus) {
                                                if (hasFocus) {
                                                } else {
                                                  if (kindergartenData["roofgymArea"].toString() ==
                                                      roofgymArea.text) {
                                                  } else {
                                                    modifyKindergartenInfo(
                                                        "roofgymArea",
                                                        roofgymArea.text);
                                                  }
                                                }
                                              },
                                              child: TextField(
                                                textAlignVertical:
                                                    TextAlignVertical.center,
                                                style: TextStyle(
                                                  fontSize: 16.sp,
                                                  fontWeight: FontWeight.w400,
                                                  color: const Color(0xff393838),
                                                ),
                                                controller: roofgymArea,
                                                textAlign: TextAlign.center,
                                                decoration: InputDecoration(
                                                  contentPadding:
                                                      EdgeInsets.all(8.0.w),
                                                  // hintText: widget.getEmotionData.comment,
                                                  border: const OutlineInputBorder(
                                                    borderSide: BorderSide.none,
                                                  ), //외곽선
                                                ),
                                              ),
                                            ),
                                          ),
                                          //체육실 인근
                                          CustomContainer(
                                            cLeftBorderWidth: 1.w,
                                            cTopBorderWidth: 1.w,
                                            cInsideColor: const Color(0xffffffff),
                                            cBorderColor: const Color(0xffFDB43B),
                                            cTotalWidth: 83.w,
                                            cTotalHeight: 40.w,
                                            childWidget: Focus(
                                              focusNode: widget.b16TextFocus,
                                              onFocusChange: (hasFocus) {
                                                if (hasFocus) {
                                                } else {
                                                  if (kindergartenData["neargymCount"].toString() ==
                                                      neargymCount.text) {
                                                  } else {
                                                    modifyKindergartenInfo(
                                                        "neargymCount",
                                                        neargymCount.text);
                                                  }
                                                }
                                              },
                                              child: TextField(
                                                textAlignVertical:
                                                    TextAlignVertical.center,
                                                style: TextStyle(
                                                  fontSize: 16.sp,
                                                  fontWeight: FontWeight.w400,
                                                  color: const Color(0xff393838),
                                                ),
                                                controller: neargymCount,
                                                textAlign: TextAlign.center,
                                                decoration: InputDecoration(
                                                  contentPadding:
                                                      EdgeInsets.all(8.0.w),
                                                  // hintText: widget.getEmotionData.comment,
                                                  border: const OutlineInputBorder(
                                                    borderSide: BorderSide.none,
                                                  ), //외곽선
                                                ),
                                              ),
                                            ),
                                          ),
                                          //체육실 인근 면적
                                          CustomContainer(
                                            cLeftBorderWidth: 1.w,
                                            cTopBorderWidth: 1.w,
                                            cRightBorderWidth: 1.w,
                                            cInsideColor: const Color(0xffffffff),
                                            cBorderColor: const Color(0xffFDB43B),
                                            cTotalWidth: 83.w,
                                            cTotalHeight: 40.w,
                                            childWidget: Focus(
                                              focusNode: widget.b16TextFocus,
                                              onFocusChange: (hasFocus) {
                                                if (hasFocus) {
                                                } else {
                                                  if (kindergartenData["neargymArea"].toString() ==
                                                      neargymArea.text) {
                                                  } else {
                                                    modifyKindergartenInfo(
                                                        "neargymArea",
                                                        neargymArea.text);
                                                  }
                                                }
                                              },
                                              child: TextField(
                                                textAlignVertical:
                                                    TextAlignVertical.center,
                                                style: TextStyle(
                                                  fontSize: 16.sp,
                                                  fontWeight: FontWeight.w400,
                                                  color: const Color(0xff393838),
                                                ),
                                                controller: neargymArea,
                                                textAlign: TextAlign.center,
                                                decoration: InputDecoration(
                                                  contentPadding:
                                                      EdgeInsets.all(8.0.w),
                                                  // hintText: widget.getEmotionData.comment,
                                                  border: const OutlineInputBorder(
                                                    borderSide: BorderSide.none,
                                                  ), //외곽선
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Column(
                                    children: [
                                      CustomContainer(
                                        cLeftBorderWidth: 1.w,
                                        cTopBorderWidth: 1.w,
                                        cInsideColor: const Color(0xffFFEFD3),
                                        cBorderColor: const Color(0xffFDB43B),
                                        cTotalWidth: 207.5.w,
                                        cTotalHeight: 40.w,
                                        childWidget: Center(
                                          child: Text(
                                            "보건실",
                                            style: TextStyle(
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w400,
                                              color: const Color(0xff393838),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          CustomContainer(
                                            cLeftBorderWidth: 1.w,
                                            cTopBorderWidth: 1.w,
                                            cInsideColor: const Color(0xffFED796),
                                            cBorderColor: const Color(0xffFDB43B),
                                            cTotalWidth: 103.75.w,
                                            cTotalHeight: 40.w,
                                            childWidget: Center(
                                              child: Text(
                                                "수",
                                                style: TextStyle(
                                                  fontSize: 16.sp,
                                                  fontWeight: FontWeight.w400,
                                                  color: const Color(0xff393838),
                                                ),
                                              ),
                                            ),
                                          ),
                                          CustomContainer(
                                            cLeftBorderWidth: 1.w,
                                            cTopBorderWidth: 1.w,
                                            cInsideColor: const Color(0xffFED796),
                                            cBorderColor: const Color(0xffFDB43B),
                                            cTotalWidth: 103.75.w,
                                            cTotalHeight: 40.w,
                                            childWidget: Center(
                                              child: Text(
                                                "면적",
                                                style: TextStyle(
                                                  fontSize: 16.sp,
                                                  fontWeight: FontWeight.w400,
                                                  color: const Color(0xff393838),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      //보건실 수
                                      Row(
                                        children: [
                                          CustomContainer(
                                            cLeftBorderWidth: 1.w,
                                            cTopBorderWidth: 1.w,
                                            cInsideColor: const Color(0xffffffff),
                                            cBorderColor: const Color(0xffFDB43B),
                                            cTotalWidth: 103.75.w,
                                            cTotalHeight: 40.w,
                                            childWidget: Focus(
                                              focusNode: widget.b16TextFocus,
                                              onFocusChange: (hasFocus) {
                                                if (hasFocus) {
                                                } else {
                                                  if (kindergartenData["healthroomCount"].toString() ==
                                                      healthroomCount.text) {
                                                  } else {
                                                    modifyKindergartenInfo(
                                                        "healthroomCount",
                                                        healthroomCount.text);
                                                  }
                                                }
                                              },
                                              child: TextField(
                                                textAlignVertical:
                                                    TextAlignVertical.center,
                                                style: TextStyle(
                                                  fontSize: 16.sp,
                                                  fontWeight: FontWeight.w400,
                                                  color: const Color(0xff393838),
                                                ),
                                                controller: healthroomCount,
                                                textAlign: TextAlign.center,
                                                decoration: InputDecoration(
                                                  contentPadding:
                                                      EdgeInsets.all(8.0.w),
                                                  // hintText: widget.getEmotionData.comment,
                                                  border: const OutlineInputBorder(
                                                    borderSide: BorderSide.none,
                                                  ), //외곽선
                                                ),
                                              ),
                                            ),
                                          ),
                                          // 보건실 면적
                                          CustomContainer(
                                            cLeftBorderWidth: 1.w,
                                            cTopBorderWidth: 1.w,
                                            cInsideColor: const Color(0xffffffff),
                                            cBorderColor: const Color(0xffFDB43B),
                                            cTotalWidth: 103.75.w,
                                            cTotalHeight: 40.w,
                                            childWidget: Focus(
                                              focusNode: widget.b16TextFocus,
                                              onFocusChange: (hasFocus) {
                                                if (hasFocus) {
                                                } else {
                                                  if (kindergartenData["healthroomArea"].toString() ==
                                                      healthroomArea.text) {
                                                  } else {
                                                    modifyKindergartenInfo(
                                                        "healthroomArea",
                                                        healthroomArea.text);
                                                  }
                                                }
                                              },
                                              child: TextField(
                                                textAlignVertical:
                                                    TextAlignVertical.center,
                                                style: TextStyle(
                                                  fontSize: 16.sp,
                                                  fontWeight: FontWeight.w400,
                                                  color: const Color(0xff393838),
                                                ),
                                                controller: healthroomArea,
                                                textAlign: TextAlign.center,
                                                decoration: InputDecoration(
                                                  contentPadding:
                                                      EdgeInsets.all(8.0.w),
                                                  // hintText: widget.getEmotionData.comment,
                                                  border: const OutlineInputBorder(
                                                    borderSide: BorderSide.none,
                                                  ), //외곽선
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      CustomContainer(
                                        cLeftBorderWidth: 1.w,
                                        cTopBorderWidth: 1.w,
                                        cInsideColor: const Color(0xffFFEFD3),
                                        cBorderColor: const Color(0xffFDB43B),
                                        cTotalWidth: 207.5.w,
                                        cTotalHeight: 40.w,
                                        childWidget: Center(
                                          child: Text(
                                            "위생시설(목욕실/화장실)",
                                            style: TextStyle(
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w400,
                                              color: const Color(0xff393838),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          CustomContainer(
                                            cLeftBorderWidth: 1.w,
                                            cTopBorderWidth: 1.w,
                                            cInsideColor: const Color(0xffFED796),
                                            cBorderColor: const Color(0xffFDB43B),
                                            cTotalWidth: 103.75.w,
                                            cTotalHeight: 40.w,
                                            childWidget: Center(
                                              child: Text(
                                                "수",
                                                style: TextStyle(
                                                  fontSize: 16.sp,
                                                  fontWeight: FontWeight.w400,
                                                  color: const Color(0xff393838),
                                                ),
                                              ),
                                            ),
                                          ),
                                          CustomContainer(
                                            cLeftBorderWidth: 1.w,
                                            cTopBorderWidth: 1.w,
                                            cInsideColor: const Color(0xffFED796),
                                            cBorderColor: const Color(0xffFDB43B),
                                            cTotalWidth: 103.75.w,
                                            cTotalHeight: 40.w,
                                            childWidget: Center(
                                              child: Text(
                                                "면적",
                                                style: TextStyle(
                                                  fontSize: 16.sp,
                                                  fontWeight: FontWeight.w400,
                                                  color: const Color(0xff393838),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      //위생시설 수
                                      Row(
                                        children: [
                                          CustomContainer(
                                            cLeftBorderWidth: 1.w,
                                            cTopBorderWidth: 1.w,
                                            cInsideColor: const Color(0xffffffff),
                                            cBorderColor: const Color(0xffFDB43B),
                                            cTotalWidth: 103.75.w,
                                            cTotalHeight: 40.w,
                                            childWidget: Focus(
                                              focusNode: widget.b16TextFocus,
                                              onFocusChange: (hasFocus) {
                                                if (hasFocus) {
                                                } else {
                                                  if (kindergartenData["restroomCount"].toString() ==
                                                      restroomCount.text) {
                                                  } else {
                                                    modifyKindergartenInfo(
                                                        "restroomCount",
                                                        restroomCount.text);
                                                  }
                                                }
                                              },
                                              child: TextField(
                                                textAlignVertical:
                                                    TextAlignVertical.center,
                                                style: TextStyle(
                                                  fontSize: 16.sp,
                                                  fontWeight: FontWeight.w400,
                                                  color: const Color(0xff393838),
                                                ),
                                                controller: restroomCount,
                                                textAlign: TextAlign.center,
                                                decoration: InputDecoration(
                                                  contentPadding:
                                                      EdgeInsets.all(8.0.w),
                                                  // hintText: widget.getEmotionData.comment,
                                                  border: const OutlineInputBorder(
                                                    borderSide: BorderSide.none,
                                                  ), //외곽선
                                                ),
                                              ),
                                            ),
                                          ),
                                          //위생시설 면적
                                          CustomContainer(
                                            cLeftBorderWidth: 1.w,
                                            cTopBorderWidth: 1.w,
                                            cInsideColor: const Color(0xffffffff),
                                            cBorderColor: const Color(0xffFDB43B),
                                            cTotalWidth: 103.75.w,
                                            cTotalHeight: 40.w,
                                            childWidget: Focus(
                                              focusNode: widget.b16TextFocus,
                                              onFocusChange: (hasFocus) {
                                                if (hasFocus) {
                                                } else {
                                                  if (kindergartenData["restroomArea"].toString() ==
                                                      restroomArea.text) {
                                                  } else {
                                                    modifyKindergartenInfo(
                                                        "restroomArea",
                                                        restroomArea.text);
                                                  }
                                                }
                                              },
                                              child: TextField(
                                                textAlignVertical:
                                                    TextAlignVertical.center,
                                                style: TextStyle(
                                                  fontSize: 16.sp,
                                                  fontWeight: FontWeight.w400,
                                                  color: const Color(0xff393838),
                                                ),
                                                controller: restroomArea,
                                                textAlign: TextAlign.center,
                                                decoration: InputDecoration(
                                                  contentPadding:
                                                      EdgeInsets.all(8.0.w),
                                                  // hintText: widget.getEmotionData.comment,
                                                  border: const OutlineInputBorder(
                                                    borderSide: BorderSide.none,
                                                  ), //외곽선
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      CustomContainer(
                                        cLeftBorderWidth: 1.w,
                                        cTopBorderWidth: 1.w,
                                        cInsideColor: const Color(0xffFFEFD3),
                                        cBorderColor: const Color(0xffFDB43B),
                                        cTotalWidth: 207.5.w,
                                        cTotalHeight: 40.w,
                                        childWidget: Center(
                                          child: Text(
                                            "조리실",
                                            style: TextStyle(
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w400,
                                              color: const Color(0xff393838),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          CustomContainer(
                                            cLeftBorderWidth: 1.w,
                                            cTopBorderWidth: 1.w,
                                            cInsideColor: const Color(0xffFED796),
                                            cBorderColor: const Color(0xffFDB43B),
                                            cTotalWidth: 103.75.w,
                                            cTotalHeight: 40.w,
                                            childWidget: Center(
                                              child: Text(
                                                "수",
                                                style: TextStyle(
                                                  fontSize: 16.sp,
                                                  fontWeight: FontWeight.w400,
                                                  color: const Color(0xff393838),
                                                ),
                                              ),
                                            ),
                                          ),
                                          CustomContainer(
                                            cLeftBorderWidth: 1.w,
                                            cTopBorderWidth: 1.w,
                                            cInsideColor: const Color(0xffFED796),
                                            cBorderColor: const Color(0xffFDB43B),
                                            cTotalWidth: 103.75.w,
                                            cTotalHeight: 40.w,
                                            childWidget: Center(
                                              child: Text(
                                                "면적",
                                                style: TextStyle(
                                                  fontSize: 16.sp,
                                                  fontWeight: FontWeight.w400,
                                                  color: const Color(0xff393838),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          CustomContainer(
                                            cLeftBorderWidth: 1.w,
                                            cTopBorderWidth: 1.w,
                                            cInsideColor: const Color(0xffffffff),
                                            cBorderColor: const Color(0xffFDB43B),
                                            cTotalWidth: 103.75.w,
                                            cTotalHeight: 40.w,
                                            childWidget: Focus(
                                              focusNode: widget.b16TextFocus,
                                              onFocusChange: (hasFocus) {
                                                if (hasFocus) {
                                                } else {
                                                  if (kindergartenData["kitchenCount"].toString() ==
                                                      kitchenCount.text) {
                                                  } else {
                                                    modifyKindergartenInfo(
                                                        "kitchenCount",
                                                        kitchenCount.text);
                                                  }
                                                }
                                              },
                                              child: TextField(
                                                textAlignVertical:
                                                    TextAlignVertical.center,
                                                style: TextStyle(
                                                  fontSize: 16.sp,
                                                  fontWeight: FontWeight.w400,
                                                  color: const Color(0xff393838),
                                                ),
                                                controller: kitchenCount,
                                                textAlign: TextAlign.center,
                                                decoration: InputDecoration(
                                                  contentPadding:
                                                      EdgeInsets.all(8.0.w),
                                                  // hintText: widget.getEmotionData.comment,
                                                  border: const OutlineInputBorder(
                                                    borderSide: BorderSide.none,
                                                  ), //외곽선
                                                ),
                                              ),
                                            ),
                                          ),
                                          CustomContainer(
                                            cLeftBorderWidth: 1.w,
                                            cTopBorderWidth: 1.w,
                                            cInsideColor: const Color(0xffffffff),
                                            cBorderColor: const Color(0xffFDB43B),
                                            cTotalWidth: 103.75.w,
                                            cTotalHeight: 40.w,
                                            childWidget: Focus(
                                              focusNode: widget.b16TextFocus,
                                              onFocusChange: (hasFocus) {
                                                if (hasFocus) {
                                                } else {
                                                  if (kindergartenData["kitchenArea"].toString() ==
                                                      kitchenArea.text) {
                                                  } else {
                                                    modifyKindergartenInfo(
                                                        "kitchenArea",
                                                        kitchenArea.text);
                                                  }
                                                }
                                              },
                                              child: TextField(
                                                textAlignVertical:
                                                    TextAlignVertical.center,
                                                style: TextStyle(
                                                  fontSize: 16.sp,
                                                  fontWeight: FontWeight.w400,
                                                  color: const Color(0xff393838),
                                                ),
                                                controller: kitchenArea,
                                                textAlign: TextAlign.center,
                                                decoration: InputDecoration(
                                                  contentPadding:
                                                      EdgeInsets.all(8.0.w),
                                                  // hintText: widget.getEmotionData.comment,
                                                  border: const OutlineInputBorder(
                                                    borderSide: BorderSide.none,
                                                  ), //외곽선
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      CustomContainer(
                                        cLeftBorderWidth: 1.w,
                                        cTopBorderWidth: 1.w,
                                        cInsideColor: const Color(0xffFFEFD3),
                                        cBorderColor: const Color(0xffFDB43B),
                                        cRightBorderWidth: 1.w,
                                        cTotalWidth: 207.5.w,
                                        cTotalHeight: 40.w,
                                        childWidget: Center(
                                          child: Text(
                                            "급식실",
                                            style: TextStyle(
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w400,
                                              color: const Color(0xff393838),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          CustomContainer(
                                            cLeftBorderWidth: 1.w,
                                            cTopBorderWidth: 1.w,
                                            cInsideColor: const Color(0xffFED796),
                                            cBorderColor: const Color(0xffFDB43B),
                                            cTotalWidth: 103.75.w,
                                            cTotalHeight: 40.w,
                                            childWidget: Center(
                                              child: Text(
                                                "수",
                                                style: TextStyle(
                                                  fontSize: 16.sp,
                                                  fontWeight: FontWeight.w400,
                                                  color: const Color(0xff393838),
                                                ),
                                              ),
                                            ),
                                          ),
                                          CustomContainer(
                                            cLeftBorderWidth: 1.w,
                                            cTopBorderWidth: 1.w,
                                            cRightBorderWidth: 1.w,
                                            cInsideColor: const Color(0xffFED796),
                                            cBorderColor: const Color(0xffFDB43B),
                                            cTotalWidth: 103.75.w,
                                            cTotalHeight: 40.w,
                                            childWidget: Center(
                                              child: Text(
                                                "면적",
                                                style: TextStyle(
                                                  fontSize: 16.sp,
                                                  fontWeight: FontWeight.w400,
                                                  color: const Color(0xff393838),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          CustomContainer(
                                            cLeftBorderWidth: 1.w,
                                            cTopBorderWidth: 1.w,
                                            cInsideColor: const Color(0xffffffff),
                                            cBorderColor: const Color(0xffFDB43B),
                                            cTotalWidth: 103.75.w,
                                            cTotalHeight: 40.w,
                                            childWidget: Focus(
                                              focusNode: widget.b16TextFocus,
                                              onFocusChange: (hasFocus) {
                                                if (hasFocus) {
                                                } else {
                                                  if (kindergartenData["cafeteriaCount"].toString() ==
                                                      cafeteriaCount.text) {
                                                  } else {
                                                    modifyKindergartenInfo(
                                                        "cafeteriaCount",
                                                        cafeteriaCount.text);
                                                  }
                                                }
                                              },
                                              child: TextField(
                                                textAlignVertical:
                                                    TextAlignVertical.center,
                                                style: TextStyle(
                                                  fontSize: 16.sp,
                                                  fontWeight: FontWeight.w400,
                                                  color: const Color(0xff393838),
                                                ),
                                                controller: cafeteriaCount,
                                                textAlign: TextAlign.center,
                                                decoration: InputDecoration(
                                                  contentPadding:
                                                      EdgeInsets.all(8.0.w),
                                                  // hintText: widget.getEmotionData.comment,
                                                  border: const OutlineInputBorder(
                                                    borderSide: BorderSide.none,
                                                  ), //외곽선
                                                ),
                                              ),
                                            ),
                                          ),
                                          CustomContainer(
                                            cLeftBorderWidth: 1.w,
                                            cTopBorderWidth: 1.w,
                                            cRightBorderWidth: 1.w,
                                            cInsideColor: const Color(0xffffffff),
                                            cBorderColor: const Color(0xffFDB43B),
                                            cTotalWidth: 103.75.w,
                                            cTotalHeight: 40.w,
                                            childWidget: Focus(
                                              focusNode: widget.b16TextFocus,
                                              onFocusChange: (hasFocus) {
                                                if (hasFocus) {
                                                } else {
                                                  if (kindergartenData["cafeteriaArea"].toString() ==
                                                      cafeteriaArea.text) {
                                                  } else {
                                                    modifyKindergartenInfo(
                                                        "cafeteriaArea",
                                                        cafeteriaArea.text);
                                                  }
                                                }
                                              },
                                              child: TextField(
                                                textAlignVertical:
                                                    TextAlignVertical.center,
                                                style: TextStyle(
                                                  fontSize: 16.sp,
                                                  fontWeight: FontWeight.w400,
                                                  color: const Color(0xff393838),
                                                ),
                                                controller: cafeteriaArea,
                                                textAlign: TextAlign.center,
                                                decoration: InputDecoration(
                                                  contentPadding:
                                                      EdgeInsets.all(8.0.w),
                                                  // hintText: widget.getEmotionData.comment,
                                                  border: const OutlineInputBorder(
                                                    borderSide: BorderSide.none,
                                                  ), //외곽선
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Column(
                                    children: [
                                      CustomContainer(
                                        cLeftBorderWidth: 1.w,
                                        cTopBorderWidth: 1.w,
                                        cInsideColor: const Color(0xffFFEFD3),
                                        cBorderColor: const Color(0xffFDB43B),
                                        cTotalWidth: 207.5.w,
                                        cTotalHeight: 40.w,
                                        childWidget: Center(
                                          child: Text(
                                            "원장실",
                                            style: TextStyle(
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w400,
                                              color: const Color(0xff393838),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          CustomContainer(
                                            cLeftBorderWidth: 1.w,
                                            cTopBorderWidth: 1.w,
                                            cInsideColor: const Color(0xffFED796),
                                            cBorderColor: const Color(0xffFDB43B),
                                            cTotalWidth: 103.75.w,
                                            cTotalHeight: 40.w,
                                            childWidget: Center(
                                              child: Text(
                                                "교실수",
                                                style: TextStyle(
                                                  fontSize: 16.sp,
                                                  fontWeight: FontWeight.w400,
                                                  color: const Color(0xff393838),
                                                ),
                                              ),
                                            ),
                                          ),
                                          CustomContainer(
                                            cLeftBorderWidth: 1.w,
                                            cTopBorderWidth: 1.w,
                                            cInsideColor: const Color(0xffFED796),
                                            cBorderColor: const Color(0xffFDB43B),
                                            cTotalWidth: 103.75.w,
                                            cTotalHeight: 40.w,
                                            childWidget: Center(
                                              child: Text(
                                                "면적",
                                                style: TextStyle(
                                                  fontSize: 16.sp,
                                                  fontWeight: FontWeight.w400,
                                                  color: const Color(0xff393838),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          CustomContainer(
                                            cLeftBorderWidth: 1.w,
                                            cTopBorderWidth: 1.w,
                                            cBottomBorderWidth: 1.w,
                                            cInsideColor: const Color(0xffffffff),
                                            cBorderColor: const Color(0xffFDB43B),
                                            cTotalWidth: 103.75.w,
                                            cTotalHeight: 40.w,
                                            childWidget: Focus(
                                              focusNode: widget.b16TextFocus,
                                              onFocusChange: (hasFocus) {
                                                if (hasFocus) {
                                                } else {
                                                  if (kindergartenData["directorroomCount"].toString() ==
                                                      directorroomCount.text) {
                                                  } else {
                                                    modifyKindergartenInfo(
                                                        "directorroomCount",
                                                        directorroomCount.text);
                                                  }
                                                }
                                              },
                                              child: TextField(
                                                textAlignVertical:
                                                    TextAlignVertical.center,
                                                style: TextStyle(
                                                  fontSize: 16.sp,
                                                  fontWeight: FontWeight.w400,
                                                  color: const Color(0xff393838),
                                                ),
                                                controller: directorroomCount,
                                                textAlign: TextAlign.center,
                                                decoration: InputDecoration(
                                                  contentPadding:
                                                      EdgeInsets.all(8.0.w),
                                                  // hintText: widget.getEmotionData.comment,
                                                  border: const OutlineInputBorder(
                                                    borderSide: BorderSide.none,
                                                  ), //외곽선
                                                ),
                                              ),
                                            ),
                                          ),
                                          CustomContainer(
                                            cLeftBorderWidth: 1.w,
                                            cTopBorderWidth: 1.w,
                                            cBottomBorderWidth: 1.w,
                                            cInsideColor: const Color(0xffffffff),
                                            cBorderColor: const Color(0xffFDB43B),
                                            cTotalWidth: 103.75.w,
                                            cTotalHeight: 40.w,
                                            childWidget: Focus(
                                              focusNode: widget.b16TextFocus,
                                              onFocusChange: (hasFocus) {
                                                if (hasFocus) {
                                                } else {
                                                  if (kindergartenData["directorroomArea"].toString() ==
                                                      directorroomArea.text) {
                                                  } else {
                                                    modifyKindergartenInfo(
                                                        "directorroomArea",
                                                        directorroomArea.text);
                                                  }
                                                }
                                              },
                                              child: TextField(
                                                textAlignVertical:
                                                    TextAlignVertical.center,
                                                style: TextStyle(
                                                  fontSize: 16.sp,
                                                  fontWeight: FontWeight.w400,
                                                  color: const Color(0xff393838),
                                                ),
                                                controller: directorroomArea,
                                                textAlign: TextAlign.center,
                                                decoration: InputDecoration(
                                                  contentPadding:
                                                      EdgeInsets.all(8.0.w),
                                                  // hintText: widget.getEmotionData.comment,
                                                  border: const OutlineInputBorder(
                                                    borderSide: BorderSide.none,
                                                  ), //외곽선
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      CustomContainer(
                                        cLeftBorderWidth: 1.w,
                                        cTopBorderWidth: 1.w,
                                        cInsideColor: const Color(0xffFFEFD3),
                                        cBorderColor: const Color(0xffFDB43B),
                                        cTotalWidth: 207.5.w,
                                        cTotalHeight: 40.w,
                                        childWidget: Center(
                                          child: Text(
                                            "교사실",
                                            style: TextStyle(
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w400,
                                              color: const Color(0xff393838),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          CustomContainer(
                                            cLeftBorderWidth: 1.w,
                                            cTopBorderWidth: 1.w,
                                            cInsideColor: const Color(0xffFED796),
                                            cBorderColor: const Color(0xffFDB43B),
                                            cTotalWidth: 103.75.w,
                                            cTotalHeight: 40.w,
                                            childWidget: Center(
                                              child: Text(
                                                "교실수",
                                                style: TextStyle(
                                                  fontSize: 16.sp,
                                                  fontWeight: FontWeight.w400,
                                                  color: const Color(0xff393838),
                                                ),
                                              ),
                                            ),
                                          ),
                                          CustomContainer(
                                            cLeftBorderWidth: 1.w,
                                            cTopBorderWidth: 1.w,
                                            cInsideColor: const Color(0xffFED796),
                                            cBorderColor: const Color(0xffFDB43B),
                                            cTotalWidth: 103.75.w,
                                            cTotalHeight: 40.w,
                                            childWidget: Center(
                                              child: Text(
                                                "면적",
                                                style: TextStyle(
                                                  fontSize: 16.sp,
                                                  fontWeight: FontWeight.w400,
                                                  color: const Color(0xff393838),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          CustomContainer(
                                            cLeftBorderWidth: 1.w,
                                            cTopBorderWidth: 1.w,
                                            cBottomBorderWidth: 1.w,
                                            cInsideColor: const Color(0xffffffff),
                                            cBorderColor: const Color(0xffFDB43B),
                                            cTotalWidth: 103.75.w,
                                            cTotalHeight: 40.w,
                                            childWidget: Focus(
                                              focusNode: widget.b16TextFocus,
                                              onFocusChange: (hasFocus) {
                                                if (hasFocus) {
                                                } else {
                                                  if (kindergartenData["teacherroomCount"].toString() ==
                                                      teacherroomCount.text) {
                                                  } else {
                                                    modifyKindergartenInfo(
                                                        "teacherroomCount",
                                                        teacherroomCount.text);
                                                  }
                                                }
                                              },
                                              child: TextField(
                                                textAlignVertical:
                                                    TextAlignVertical.center,
                                                style: TextStyle(
                                                  fontSize: 16.sp,
                                                  fontWeight: FontWeight.w400,
                                                  color: const Color(0xff393838),
                                                ),
                                                controller: teacherroomCount,
                                                textAlign: TextAlign.center,
                                                decoration: InputDecoration(
                                                  contentPadding:
                                                      EdgeInsets.all(8.0.w),
                                                  // hintText: widget.getEmotionData.comment,
                                                  border: const OutlineInputBorder(
                                                    borderSide: BorderSide.none,
                                                  ), //외곽선
                                                ),
                                              ),
                                            ),
                                          ),
                                          CustomContainer(
                                            cLeftBorderWidth: 1.w,
                                            cTopBorderWidth: 1.w,
                                            cBottomBorderWidth: 1.w,
                                            cInsideColor: const Color(0xffffffff),
                                            cBorderColor: const Color(0xffFDB43B),
                                            cTotalWidth: 103.75.w,
                                            cTotalHeight: 40.w,
                                            childWidget: Focus(
                                              focusNode: widget.b16TextFocus,
                                              onFocusChange: (hasFocus) {
                                                if (hasFocus) {
                                                } else {
                                                  if (kindergartenData["teacherroomArea"].toString() ==
                                                      teacherroomArea.text) {
                                                  } else {
                                                    modifyKindergartenInfo(
                                                        "teacherroomArea",
                                                        teacherroomArea.text);
                                                  }
                                                }
                                              },
                                              child: TextField(
                                                textAlignVertical:
                                                    TextAlignVertical.center,
                                                style: TextStyle(
                                                  fontSize: 16.sp,
                                                  fontWeight: FontWeight.w400,
                                                  color: const Color(0xff393838),
                                                ),
                                                controller: teacherroomArea,
                                                textAlign: TextAlign.center,
                                                decoration: InputDecoration(
                                                  contentPadding:
                                                      EdgeInsets.all(8.0.w),
                                                  // hintText: widget.getEmotionData.comment,
                                                  border: const OutlineInputBorder(
                                                    borderSide: BorderSide.none,
                                                  ), //외곽선
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      CustomContainer(
                                        cLeftBorderWidth: 1.w,
                                        cTopBorderWidth: 1.w,
                                        cInsideColor: const Color(0xffFFEFD3),
                                        cBorderColor: const Color(0xffFDB43B),
                                        cTotalWidth: 207.5.w,
                                        cTotalHeight: 40.w,
                                        childWidget: Center(
                                          child: Text(
                                            "상담실",
                                            style: TextStyle(
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w400,
                                              color: const Color(0xff393838),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          CustomContainer(
                                            cLeftBorderWidth: 1.w,
                                            cTopBorderWidth: 1.w,
                                            cInsideColor: const Color(0xffFED796),
                                            cBorderColor: const Color(0xffFDB43B),
                                            cTotalWidth: 103.75.w,
                                            cTotalHeight: 40.w,
                                            childWidget: Center(
                                              child: Text(
                                                "교실수",
                                                style: TextStyle(
                                                  fontSize: 16.sp,
                                                  fontWeight: FontWeight.w400,
                                                  color: const Color(0xff393838),
                                                ),
                                              ),
                                            ),
                                          ),
                                          CustomContainer(
                                            cLeftBorderWidth: 1.w,
                                            cTopBorderWidth: 1.w,
                                            cInsideColor: const Color(0xffFED796),
                                            cBorderColor: const Color(0xffFDB43B),
                                            cTotalWidth: 103.75.w,
                                            cTotalHeight: 40.w,
                                            childWidget: Center(
                                              child: Text(
                                                "면적",
                                                style: TextStyle(
                                                  fontSize: 16.sp,
                                                  fontWeight: FontWeight.w400,
                                                  color: const Color(0xff393838),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          CustomContainer(
                                            cLeftBorderWidth: 1.w,
                                            cTopBorderWidth: 1.w,
                                            cBottomBorderWidth: 1.w,
                                            cInsideColor: const Color(0xffffffff),
                                            cBorderColor: const Color(0xffFDB43B),
                                            cTotalWidth: 103.75.w,
                                            cTotalHeight: 40.w,
                                            childWidget: Focus(
                                              focusNode: widget.b16TextFocus,
                                              onFocusChange: (hasFocus) {
                                                if (hasFocus) {
                                                } else {
                                                  if (kindergartenData["counselingroomCount"].toString() ==
                                                      counselingroomCount.text) {
                                                  } else {
                                                    modifyKindergartenInfo(
                                                        "counselingroomCount",
                                                        counselingroomCount.text);
                                                  }
                                                }
                                              },
                                              child: TextField(
                                                textAlignVertical:
                                                    TextAlignVertical.center,
                                                style: TextStyle(
                                                  fontSize: 16.sp,
                                                  fontWeight: FontWeight.w400,
                                                  color: const Color(0xff393838),
                                                ),
                                                controller: counselingroomCount,
                                                textAlign: TextAlign.center,
                                                decoration: InputDecoration(
                                                  contentPadding:
                                                      EdgeInsets.all(8.0.w),
                                                  // hintText: widget.getEmotionData.comment,
                                                  border: const OutlineInputBorder(
                                                    borderSide: BorderSide.none,
                                                  ), //외곽선
                                                ),
                                              ),
                                            ),
                                          ),
                                          CustomContainer(
                                            cLeftBorderWidth: 1.w,
                                            cTopBorderWidth: 1.w,
                                            cBottomBorderWidth: 1.w,
                                            cInsideColor: const Color(0xffffffff),
                                            cBorderColor: const Color(0xffFDB43B),
                                            cTotalWidth: 103.75.w,
                                            cTotalHeight: 40.w,
                                            childWidget: Focus(
                                              focusNode: widget.b16TextFocus,
                                              onFocusChange: (hasFocus) {
                                                if (hasFocus) {
                                                } else {
                                                  if (kindergartenData["counselingroomArea"].toString() ==
                                                      counselingroomArea.text) {
                                                  } else {
                                                    modifyKindergartenInfo(
                                                        "counselingroomArea",
                                                        counselingroomArea.text);
                                                  }
                                                }
                                              },
                                              child: TextField(
                                                textAlignVertical:
                                                    TextAlignVertical.center,
                                                style: TextStyle(
                                                  fontSize: 16.sp,
                                                  fontWeight: FontWeight.w400,
                                                  color: const Color(0xff393838),
                                                ),
                                                controller: counselingroomArea,
                                                textAlign: TextAlign.center,
                                                decoration: InputDecoration(
                                                  contentPadding:
                                                      EdgeInsets.all(8.0.w),
                                                  // hintText: widget.getEmotionData.comment,
                                                  border: const OutlineInputBorder(
                                                    borderSide: BorderSide.none,
                                                  ), //외곽선
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      CustomContainer(
                                        cLeftBorderWidth: 1.w,
                                        cTopBorderWidth: 1.w,
                                        cRightBorderWidth: 1.w,
                                        cInsideColor: const Color(0xffFFEFD3),
                                        cBorderColor: const Color(0xffFDB43B),
                                        cTotalWidth: 207.5.w,
                                        cTotalHeight: 40.w,
                                        childWidget: Center(
                                          child: Text(
                                            "기타공간",
                                            style: TextStyle(
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w400,
                                              color: const Color(0xff393838),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          CustomContainer(
                                            cLeftBorderWidth: 1.w,
                                            cTopBorderWidth: 1.w,
                                            cInsideColor: const Color(0xffFED796),
                                            cBorderColor: const Color(0xffFDB43B),
                                            cTotalWidth: 103.75.w,
                                            cTotalHeight: 40.w,
                                            childWidget: Center(
                                              child: Text(
                                                "교실수",
                                                style: TextStyle(
                                                  fontSize: 16.sp,
                                                  fontWeight: FontWeight.w400,
                                                  color: const Color(0xff393838),
                                                ),
                                              ),
                                            ),
                                          ),
                                          CustomContainer(
                                            cLeftBorderWidth: 1.w,
                                            cTopBorderWidth: 1.w,
                                            cRightBorderWidth: 1.w,
                                            cInsideColor: const Color(0xffFED796),
                                            cBorderColor: const Color(0xffFDB43B),
                                            cTotalWidth: 103.75.w,
                                            cTotalHeight: 40.w,
                                            childWidget: Center(
                                              child: Text(
                                                "면적",
                                                style: TextStyle(
                                                  fontSize: 16.sp,
                                                  fontWeight: FontWeight.w400,
                                                  color: const Color(0xff393838),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          CustomContainer(
                                            cLeftBorderWidth: 1.w,
                                            cTopBorderWidth: 1.w,
                                            cBottomBorderWidth: 1.w,
                                            cInsideColor: const Color(0xffffffff),
                                            cBorderColor: const Color(0xffFDB43B),
                                            cTotalWidth: 103.75.w,
                                            cTotalHeight: 40.w,
                                            childWidget: Focus( 
                                              focusNode: widget.b16TextFocus,
                                              onFocusChange: (hasFocus) {
                                                if (hasFocus) {
                                                } else {
                                                  if (kindergartenData["otherplaceCount"].toString() ==
                                                      otherplaceCount.text) {
                                                  } else {
                                                    modifyKindergartenInfo(
                                                        "otherplaceCount",
                                                        otherplaceCount.text);
                                                  }
                                                }
                                              },
                                              child: TextField(
                                                textAlignVertical:
                                                    TextAlignVertical.center,
                                                style: TextStyle(
                                                  fontSize: 16.sp,
                                                  fontWeight: FontWeight.w400,
                                                  color: const Color(0xff393838),
                                                ),
                                                controller: otherplaceCount,
                                                textAlign: TextAlign.center,
                                                decoration: InputDecoration(
                                                  contentPadding:
                                                      EdgeInsets.all(8.0.w),
                                                  // hintText: widget.getEmotionData.comment,
                                                  border: const OutlineInputBorder(
                                                    borderSide: BorderSide.none,
                                                  ), //외곽선
                                                ),
                                              ),
                                            ),
                                          ),
                                          CustomContainer(
                                            cLeftBorderWidth: 1.w,
                                            cTopBorderWidth: 1.w,
                                            cBottomBorderWidth: 1.w,
                                            cRightBorderWidth: 1.w,
                                            cBorderRadius: BorderRadius.only(
                                                bottomRight: Radius.circular(10.w)),
                                            cInsideColor: const Color(0xffffffff),
                                            cBorderColor: const Color(0xffFDB43B),
                                            cTotalWidth: 103.75.w,
                                            cTotalHeight: 40.w,
                                            childWidget: Focus(
                                              focusNode: widget.b16TextFocus,
                                              onFocusChange: (hasFocus) {
                                                if (hasFocus) {
                                                } else {
                                                  if (kindergartenData["otherplaceArea"].toString() ==
                                                      otherplaceArea.text) {
                                                  } else {
                                                    modifyKindergartenInfo(
                                                        "otherplaceArea",
                                                        otherplaceArea.text);
                                                  }
                                                }
                                              },
                                              child: TextField(
                                                textAlignVertical:
                                                    TextAlignVertical.center,
                                                style: TextStyle(
                                                  fontSize: 16.sp,
                                                  fontWeight: FontWeight.w400,
                                                  color: const Color(0xff393838),
                                                ),
                                                controller: otherplaceArea,
                                                textAlign: TextAlign.center,
                                                decoration: InputDecoration(
                                                  contentPadding:
                                                      EdgeInsets.all(8.0.w),
                                                  // hintText: widget.getEmotionData.comment,
                                                  border: const OutlineInputBorder(
                                                    borderSide: BorderSide.none,
                                                  ), //외곽선
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}

deleteImage(context, String type, int number, Function() dataSetting,) async{
  ApiUrl apiUrl = ApiUrl();
  http.Response res = await api(apiUrl.kindergartenImage + '?type=' + type + (number != -1 ? ("&number=" + (number+1).toString()):'') , 'delete', 'adminToken', {}, context);
  if(res.statusCode == 200){
    dataSetting();
  }
}