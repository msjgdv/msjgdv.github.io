import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:treasure_map/widgets/api.dart';
import 'package:treasure_map/widgets/set_admin_info.dart';
import '../provider/admin_info.dart';
import 'b2_4.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';

class B2_2 extends StatefulWidget {
  const B2_2({Key? key}) : super(key: key);

  @override
  State<B2_2> createState() => _B2_2State();
}

class _B2_2State extends State<B2_2> {
  final myControllerName = TextEditingController();
  final myControllerTel = TextEditingController();
  final myControllerComment = TextEditingController();
  final myControllerPwd1 = TextEditingController();
  final myControllerPwd2 = TextEditingController();

  var adminImg;
  ApiUrl apiUrl = ApiUrl();

  uploadWithImg(File file) async {
    String fileName = file.path.split('/').last;
    imagePostApi(apiUrl.loginIn, 'adminToken', {
      // "images": await MultipartFile.fromFile(file.path, filename: fileName),
      "name": myControllerName.text,
      "phoneNumber": myControllerTel.text,
      // "password": myControllerPwd1.text,
      "comment": myControllerComment.text,
      "imageName": fileName,
    }, file, 'patch', context, () => null);
  }

  uploadWithoutImg() async {
    imagePostApi(apiUrl.loginIn, 'adminToken', {
      "name": myControllerName.text,
      "phoneNumber": myControllerTel.text,
      "comment": myControllerComment.text,
    }, null, 'patch', context, () => null);
  }



  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imageTemp = File(image.path);
      return imageTemp;
    } on PlatformException catch (e) {
      debugPrint('Failed to pick image: $e');
    }
  }

  @override
  void initState() {
    myControllerName.text = Provider.of<AdminInfo>(context, listen: false).name;
    myControllerTel.text =
        Provider.of<AdminInfo>(context, listen: false).phoneNumber;
    myControllerComment.text =
        Provider.of<AdminInfo>(context, listen: false).comment;
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
        backgroundColor: Colors.transparent,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            child: Container(
              width: 800.w,
              height: 550.w,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.w),
                  color: const Color(0xFFFCF9F4)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 40.w),
                  Container(
                    // margin: EdgeInsets.only(left: 320.w),
                    child: Text('내 정보 변경 창',
                        style: TextStyle(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF393838))),
                  ),
                  SizedBox(height: 50.w),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // SizedBox(width: 124.66.w),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              width: 150.34.w,
                              height: 177.67.w,
                              // margin: EdgeInsets.only(top: 64.5.w),
                              child: adminImg == null
                                  ? context.read<AdminInfo>().adminFace
                                  : Image.file(File(
                                      (context.read<AdminInfo>().imageGallery)
                                          .path))
                              //Image.file(image!)
                              ),
                          Container(
                            margin:
                                EdgeInsets.fromLTRB(17.w, 14.83.w, 0.w, 0.w),
                            child: InkWell(
                              onTap: () async {
                                adminImg = await pickImage();
                                Provider.of<AdminInfo>(context, listen: false)
                                    .galleryImgUpdate(adminImg);
                              },
                              child: Text('사진 변경하기',
                                  style: TextStyle(
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.w400,
                                      color: const Color(0xFF393838))),
                            ),
                          )
                        ],
                      ),
                      SizedBox(width: 56.w),
                      Container(
                        height: 255.w,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              // margin: EdgeInsets.only(top: 50.w),
                              child: Text('이름',
                                  style: TextStyle(
                                      fontSize: 20.w,
                                      fontWeight: FontWeight.w400,
                                      color: const Color(0xFF393838))),
                            ),
                            Container(
                              // margin: EdgeInsets.only(top: 48.w),
                              child: Text('연락처',
                                  style: TextStyle(
                                      fontSize: 20.w,
                                      fontWeight: FontWeight.w400,
                                      color: const Color(0xFF393838))),
                            ),
                            Container(
                              // margin: EdgeInsets.only(top: 50.w),
                              child: Text('자기 소개',
                                  style: TextStyle(
                                      fontSize: 20.w,
                                      fontWeight: FontWeight.w400,
                                      color: const Color(0xFF393838))),
                            ),
                            Container(
                              // margin: EdgeInsets.only(top: 41.w),
                              child: Text('패스워드',
                                  style: TextStyle(
                                      fontSize: 20.w,
                                      fontWeight: FontWeight.w400,
                                      color: const Color(0xFF393838))),
                            )
                          ],
                        ),
                      ),
                      SizedBox(width: 33.79.w),
                      Container(
                        height: 255.w,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                                // margin: EdgeInsets.only(top: 68.w),
                                width: 200.w,
                                height: 30.w,
                                child: TextField(
                                  controller: myControllerName,
                                  style: TextStyle(
                                    fontSize: 20.w,
                                    fontWeight: FontWeight.w400,
                                    color: const Color(0xFF393838),
                                  ),
                                )),
                            Container(
                                width: 200.w,
                                height: 30.w,
                                child: TextField(
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    // FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                                  ],
                                  keyboardType: TextInputType.number,
                                  controller: myControllerTel,
                                  style: TextStyle(
                                    fontSize: 20.w,
                                    fontWeight: FontWeight.w400,
                                    color: const Color(0xFF393838),
                                  ),
                                )),
                            Container(
                                height: 30.w,
                                width: 200.w,
                                child: TextField(
                                  // obscureText: true,
                                  controller: myControllerComment,
                                  style: TextStyle(
                                    fontSize: 20.w,
                                    fontWeight: FontWeight.w400,
                                    color: const Color(0xFF393838),
                                  ),
                                )),
                            Container(
                                width: 80.w,
                                height: 30.w,
                                child: ElevatedButton(
                                  onPressed: () {
                                    showDialog(
                                        barrierColor: Colors.transparent,
                                        context: context,
                                        builder: (BuildContext context) {
                                          return const ChangePW();
                                        });
                                  },
                                  child: Text('변경',
                                      style: TextStyle(
                                          fontSize: 18.w,
                                          fontWeight: FontWeight.w400)),
                                  style: ElevatedButton.styleFrom(
                                      elevation: 1.0,
                                      primary: const Color(0xFFFCF9F4),
                                      onPrimary: const Color(0xFF393838),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.w)),
                                      side: const BorderSide(
                                          color: Color(0xFFA666FB)),
                                      fixedSize: Size(150.w, 50.w)),
                                )
                                // TextField(
                                //   obscureText: true,
                                //   controller: myControllerPwd2,
                                //   style: TextStyle(
                                //     fontSize: 20.w,
                                //     fontWeight: FontWeight.w400,
                                //     color: const Color(0xFF393838),
                                //   ),
                                // )
                                ),
                          ],
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 59.w),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // SizedBox(width: 125.w),
                      ElevatedButton(
                        onPressed: () async {
                          if (myControllerPwd1.text != myControllerPwd2.text) {
                            Fluttertoast.showToast(
                                msg: "패스워드가 일치하지 않습니다.",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM);
                          } else {
                            if (adminImg != null) {
                              await uploadWithImg(adminImg);
                            } else {
                              await uploadWithoutImg();
                            }
                              setAdminInfo(
                                  apiUrl.baseUrl + "/",
                                  context.read<AdminInfo>().infoUpdate,
                                  context);
                            Navigator.pop(context);
                          } //결과 반영 dialog 종료
                        },
                        child: Text('확인',
                            style: TextStyle(
                                fontSize: 20.w, fontWeight: FontWeight.w400)),
                        style: ElevatedButton.styleFrom(
                            elevation: 1.0,
                            primary: const Color(0xFFFFFFFF),
                            onPrimary: const Color(0xFF393838),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.w)),
                            side: const BorderSide(color: Color(0xFFA666FB)),
                            fixedSize: Size(150.w, 50.w)),
                      ),
                      SizedBox(width: 50.w),
                      ElevatedButton(
                        onPressed: () {
                          debugPrint('취소');
                          adminImg = null;
                          Navigator.pop(context); //아무내용 없이 dialog 종료
                        },
                        child: Text('취소',
                            style: TextStyle(
                                fontSize: 20.w, fontWeight: FontWeight.w400)),
                        style: ElevatedButton.styleFrom(
                            elevation: 1.0,
                            primary: const Color(0xFFFFFFFF),
                            onPrimary: const Color(0xFF393838),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.w)),
                            side: const BorderSide(color: Color(0xFFA666FB)),
                            fixedSize: Size(150.w, 50.w)),
                      ),
                      SizedBox(width: 50.w),
                      ElevatedButton(
                        onPressed: () {
                          // showPopUpB2_4(contextB2_2);
                          showDialog(
                              barrierColor: Colors.transparent,
                              context: context,
                              builder: (BuildContext context) {
                                return const showPopUpB2_4();
                              });
                        },
                        child: Text('탈퇴',
                            style: TextStyle(
                                fontSize: 20.w, fontWeight: FontWeight.w400)),
                        style: ElevatedButton.styleFrom(
                            elevation: 1.0,
                            primary: const Color(0xFFFFFFFF),
                            onPrimary: const Color(0xFF393838),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.w)),
                            side: const BorderSide(color: Color(0xFFA666FB)),
                            fixedSize: Size(150.w, 50.w)),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ));
  }
}

class ChangePW extends StatefulWidget {
  const ChangePW({Key? key}) : super(key: key);

  @override
  State<ChangePW> createState() => _ChangePWState();
}

class _ChangePWState extends State<ChangePW> {
  TextEditingController PW = TextEditingController();
  TextEditingController confirmPW = TextEditingController();


  patchPW() async {
    ApiUrl apiUrl = ApiUrl();
    imagePostApi(apiUrl.loginIn, 'adminToken', {
      "password": PW.text,
    }, null, 'patch', context, () => null);
    Navigator.pop(context);

  }


  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
              child: Container(
                  width: 600.w,
                  height: 300.w,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.w),
                      color: const Color(0xFFFCF9F4)),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 30.w),
                        Container(
                          // margin: EdgeInsets.only(left: 320.w),
                          child: Text('비밀번호 변경',
                              style: TextStyle(
                                  fontSize: 24.sp,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xFF393838))),
                        ),
                        SizedBox(height: 30.w),
                        Container(
                          width: 500.w,
                          height: 80.w,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                crossAxisAlignment : CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('패스워드',
                                      style: TextStyle(
                                          fontSize: 20.w,
                                          fontWeight: FontWeight.w400,
                                          color: const Color(0xFF393838))),
                                  Spacer(),
                                  Text('패스워드 확인',
                                      style: TextStyle(
                                          fontSize: 20.w,
                                          fontWeight: FontWeight.w400,
                                          color: const Color(0xFF393838))),
                                ],
                              ),
                              SizedBox(
                                width: 20.w,
                              ),
                              Column(
                                crossAxisAlignment : CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                      width: 200.w,
                                      height: 30.w,
                                      child: TextField(
                                        obscureText: true,
                                        controller: PW,
                                        style: TextStyle(
                                          fontSize: 20.w,
                                          fontWeight: FontWeight.w400,
                                          color: const Color(0xFF393838),
                                        ),
                                      )),
                                  Spacer(),
                                  Container(
                                      height: 30.w,
                                      width: 200.w,
                                      child: TextField(
                                        obscureText: true,
                                        controller: confirmPW,
                                        style: TextStyle(
                                          fontSize: 20.w,
                                          fontWeight: FontWeight.w400,
                                          color: const Color(0xFF393838),
                                        ),
                                      )),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 40.w,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () async {
                                if (PW.text != confirmPW.text) {
                                  Fluttertoast.showToast(
                                      msg: "패스워드가 일치하지 않습니다.",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM);
                                } else {
                                 patchPW();

                                } //결과 반영 dialog 종료
                              },
                              child: Text('확인',
                                  style: TextStyle(
                                      fontSize: 20.w, fontWeight: FontWeight.w400)),
                              style: ElevatedButton.styleFrom(
                                  elevation: 1.0,
                                  primary: const Color(0xFFFFFFFF),
                                  onPrimary: const Color(0xFF393838),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.w)),
                                  side: const BorderSide(color: Color(0xFFA666FB)),
                                  fixedSize: Size(150.w, 50.w)),
                            ),
                            SizedBox(width: 50.w),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context); //아무내용 없이 dialog 종료
                              },
                              child: Text('취소',
                                  style: TextStyle(
                                      fontSize: 20.w, fontWeight: FontWeight.w400)),
                              style: ElevatedButton.styleFrom(
                                  elevation: 1.0,
                                  primary: const Color(0xFFFFFFFF),
                                  onPrimary: const Color(0xFF393838),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.w)),
                                  side: const BorderSide(color: Color(0xFFA666FB)),
                                  fixedSize: Size(150.w, 50.w)),
                            ),
                          ],
                        )

                      ]
                  )
              )
          )
      ),
    );
  }
}
