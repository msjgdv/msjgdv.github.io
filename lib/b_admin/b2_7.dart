import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:treasure_map/widgets/api.dart';
import 'package:http/http.dart' as http;
import 'package:signature/signature.dart';
import 'package:path_provider/path_provider.dart';
class B2_7 extends StatefulWidget {
  const B2_7({Key? key}) : super(key: key);

  @override
  State<B2_7> createState() => _B2_7State();
}

class _B2_7State extends State<B2_7> {

  SignatureController signController = SignatureController(
    penColor: Colors.black,
    penStrokeWidth: 10,
    exportBackgroundColor: Colors.transparent,
  );

  @override
  void initState() {

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
                    child: Text('사인',
                        style: TextStyle(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF393838))),
                  ),
                  SizedBox(height: 50.w),
                  Container(
                    width: 600.w,
                    height: 270.w,
                    decoration: BoxDecoration(
                      // border: Border.all(color: Colors.white, width: 1.w)
                      color: Colors.white,
                      // borderRadius: BorderRadius.all(Radius.circular(20.w)),
                    ),
                    child: Signature(
                      controller: signController,
                      width: 600.w,
                      height: 270.w,
                      backgroundColor: Colors.white,
                    ),
                  ),
                  SizedBox(height: 50.w),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // SizedBox(width: 125.w),
                      ElevatedButton(
                        onPressed: () async {
                          ApiUrl apiUrl = ApiUrl();
                          Uint8List? image = await signController.toPngBytes();
                          final tempDir = await getTemporaryDirectory();
                          File file = await File('${tempDir.path}/image.png').create();
                          file.writeAsBytesSync(image!);
                          final imageTemp = File(file.path);
                          // File imageFile = File.fromRawPath(image!);
                          String fileName = imageTemp.path.split('/').last;
                          await imagePostApi(apiUrl.loginIn, 'adminToken', {
                            'signName' : fileName,
                          }, imageTemp, 'patch', context, () => null);
                          Navigator.pop(context);
                          // if(res.statusCode == 200){
                          //   Navigator.pop(context);
                          // }

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
                        onPressed: () async {
                          signController.clear();
                        },
                        child: Text('지우기',
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
                ],
              ),
            ),
          ),
        ));
  }
}

