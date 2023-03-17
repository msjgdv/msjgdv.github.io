
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:treasure_map/widgets/api.dart';

class ImageContainer extends StatefulWidget {
  const ImageContainer({Key? key,
    this.scrollController,
    required this.imagePath,
    required this.imageId,
    required this.positionX,
    required this.positionY,
    required this.totalWidth,
    required this.totalHeight,
    required this.getRecordData,
    required this.index,
    required this.level,
    required this.rid,
    this.picture = true,
  }) : super(key: key);
  final Function(bool)? scrollController;
  final String imagePath;
  final int imageId;
  final double positionX;
  final double positionY;
  final double totalWidth;
  final double totalHeight;
  final Function() getRecordData;
  final int level;
  final int index;
  final int rid;
  final bool picture;

  @override
  State<ImageContainer> createState() => _ImageContainerState();
}

class _ImageContainerState extends State<ImageContainer> {
  double positionY = 0;
  double positionX = 0;
  double totalWidth = 100.w;
  double totalHeight = 100.w;
  bool deleteOnOff = false;

  ApiUrl apiUrl = ApiUrl();
  Image? image;

  bool move = true;

  getImage() async{
    image = await imageApi(widget.imagePath, 'signInToken', context);
    setState(() {
    });
  }

  putImageData() async{
    http.Response res = await api(apiUrl.recordImage, 'put', 'signInToken', {
      "id": widget.imageId,
      "x": positionX,
      "y": positionY,
      "w": totalWidth,
      "h": totalHeight,
    }, context);
    if(res.statusCode == 200){
      await widget.getRecordData();
      await getImage();
      move = true;
    }
  }

  patchImage(String level) async {
    http.Response res = await api(apiUrl.recordImage, 'patch', 'signInToken', {
      "id": widget.imageId,
      "level": level
    }, context);
    if(res.statusCode == 200){
      deleteOnOff = false;
      await widget.getRecordData();
      await getImage();
      move = true;
    }
  }

  deleteImage() async {
    http.Response res = await api('${apiUrl.recordImage}/${widget.rid}/${widget.imageId}', 'delete', 'signInToken', {}, context);
    if(res.statusCode == 200){
      await widget.getRecordData();
    }
  }


  @override
  Widget build(BuildContext context) {
    if(move){
      getImage();
      positionY = widget.positionY;
      positionX = widget.positionX;
      totalWidth = widget.totalWidth;
      totalHeight = widget.totalHeight;
    }
    if(widget.picture){
      return Positioned(
        top: positionY,
        left: positionX,
        child: Listener(
          onPointerMove: (opm){
            widget.scrollController!(false);
          },
          onPointerUp: (opu){
            widget.scrollController!(true);
          },
          child: Container(
            width: totalWidth,
            height: totalHeight,
            child: Stack(
              children: [
                Center(
                  child: Container(
                    padding: EdgeInsets.all(9.w),
                    width: totalWidth - 18.w,
                    height: totalHeight - 18.w,
                    decoration: BoxDecoration(
                        border: Border.all(width: 1.w, color: Colors.black),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Color(0x29000000),
                            blurRadius: 6,
                            offset: Offset(0, 3),
                          )
                        ]),
                  ),
                ),
                //1(왼쪽 위 구석을 선택할 시)
                Positioned(
                    top: 0.w,
                    left: 0.w,
                    child: GestureDetector(
                      onPanStart: (DragStartDetails dragStartDetails) {
                        setState(() {
                          deleteOnOff = false;
                          move = false;
                        });
                      },
                      onPanUpdate: (DragUpdateDetails dragUpdateDetails) {
                        setState(() {
                          if(dragUpdateDetails.delta.dy>=0 && dragUpdateDetails.delta.dx >= 0){
                            if(totalHeight - dragUpdateDetails.delta.dy <= 100.w && totalWidth - dragUpdateDetails.delta.dx<= 100.w){
                            }else if(totalHeight - dragUpdateDetails.delta.dy>= 100.w && totalWidth - dragUpdateDetails.delta.dx <= 100.w){
                              totalHeight = totalHeight - dragUpdateDetails.delta.dy;
                              positionY = positionY + dragUpdateDetails.delta.dy;
                            }else if(totalHeight - dragUpdateDetails.delta.dy<= 100.w && totalWidth - dragUpdateDetails.delta.dx >= 100.w){
                              totalWidth = totalWidth - dragUpdateDetails.delta.dx;
                              positionX = positionX + dragUpdateDetails.delta.dx;
                            }else{
                              totalHeight = totalHeight - dragUpdateDetails.delta.dy;
                              totalWidth = totalWidth - dragUpdateDetails.delta.dx;
                              positionY = positionY + dragUpdateDetails.delta.dy;
                              positionX = positionX + dragUpdateDetails.delta.dx;
                            }
                          }else if(dragUpdateDetails.delta.dy<=0 && dragUpdateDetails.delta.dx >= 0){
                            if(totalWidth - dragUpdateDetails.delta.dx < 100.w){
                              totalHeight = totalHeight - dragUpdateDetails.delta.dy;
                              positionY = positionY + dragUpdateDetails.delta.dy;
                            }else{
                              totalHeight = totalHeight - dragUpdateDetails.delta.dy;
                              totalWidth = totalWidth - dragUpdateDetails.delta.dx;
                              positionY = positionY + dragUpdateDetails.delta.dy;
                              positionX = positionX + dragUpdateDetails.delta.dx;
                            }
                          }else if(dragUpdateDetails.delta.dy>=0 && dragUpdateDetails.delta.dx <= 0){
                            if(totalHeight - dragUpdateDetails.delta.dy< 100.w){
                              totalWidth = totalWidth - dragUpdateDetails.delta.dx;
                              positionX = positionX + dragUpdateDetails.delta.dx;
                            }else{
                              totalHeight = totalHeight - dragUpdateDetails.delta.dy;
                              totalWidth = totalWidth - dragUpdateDetails.delta.dx;
                              positionY = positionY + dragUpdateDetails.delta.dy;
                              positionX = positionX + dragUpdateDetails.delta.dx;
                            }
                          }else if(dragUpdateDetails.delta.dy<=0 && dragUpdateDetails.delta.dx <= 0){
                            totalHeight = totalHeight - dragUpdateDetails.delta.dy;
                            totalWidth = totalWidth - dragUpdateDetails.delta.dx;
                            positionY = positionY + dragUpdateDetails.delta.dy;
                            positionX = positionX + dragUpdateDetails.delta.dx;
                          }
                          // totalHeight = totalHeight - dragUpdateDetails.delta.dy;
                          // totalWidth = totalWidth - dragUpdateDetails.delta.dx;
                          // positionY = positionY + dragUpdateDetails.delta.dy;
                          // positionX = positionX + dragUpdateDetails.delta.dx;

                        });
                      },
                      onPanEnd: (DragEndDetails dragEndDetails) {
                        putImageData();
                        // move = true;
                        // widget.scrollController(true);
                      },
                      child: Container(
                        width: totalWidth / 2,
                        height: totalHeight / 2,
                        color: Colors.transparent,
                      ),
                    )),
                //2(오른쪽 위 구석을 선택할 시)
                Positioned(
                    top: 0.w,
                    right: 0.w,
                    child: GestureDetector(
                      onPanStart: (DragStartDetails dragStartDetails) {
                        setState(() {
                          deleteOnOff = false;
                          move = false;
                        });
                      },
                      onPanUpdate: (DragUpdateDetails dragUpdateDetails) {
                        setState(() {
                          if(dragUpdateDetails.delta.dy>=0 && dragUpdateDetails.delta.dx <= 0){
                            // print("둘다 축소");
                            if(totalHeight - dragUpdateDetails.delta.dy<= 100.w && totalWidth + dragUpdateDetails.delta.dx<= 100.w){
                            }else if(totalHeight - dragUpdateDetails.delta.dy>= 100.w && totalWidth + dragUpdateDetails.delta.dx<= 100.w){
                              totalHeight = totalHeight - dragUpdateDetails.delta.dy;
                              positionY = positionY + dragUpdateDetails.delta.dy;
                            }else if(totalHeight - dragUpdateDetails.delta.dy<= 100.w && totalWidth + dragUpdateDetails.delta.dx>= 100.w){
                              totalWidth = totalWidth + dragUpdateDetails.delta.dx;
                              // positionX = positionX - dragUpdateDetails.delta.dx;
                            }else{
                              totalHeight = totalHeight - dragUpdateDetails.delta.dy;
                              totalWidth = totalWidth + dragUpdateDetails.delta.dx;
                              positionY = positionY + dragUpdateDetails.delta.dy;
                            }
                          }else if(dragUpdateDetails.delta.dy<=0 && dragUpdateDetails.delta.dx <= 0){
                            // print("왼쪽 위로 드래그");
                            if(totalWidth + dragUpdateDetails.delta.dx< 100.w){
                              totalHeight = totalHeight - dragUpdateDetails.delta.dy;
                              positionY = positionY + dragUpdateDetails.delta.dy;
                            }else{
                              totalHeight = totalHeight - dragUpdateDetails.delta.dy;
                              totalWidth = totalWidth + dragUpdateDetails.delta.dx;
                              positionY = positionY + dragUpdateDetails.delta.dy;
                            }
                          }else if(dragUpdateDetails.delta.dy>=0 && dragUpdateDetails.delta.dx >= 0){
                            // print("오른쪽 아래로 드래그");
                            if(totalHeight - dragUpdateDetails.delta.dy< 100.w){
                              totalWidth = totalWidth + dragUpdateDetails.delta.dx;
                            }else{
                              totalHeight = totalHeight - dragUpdateDetails.delta.dy;
                              totalWidth = totalWidth + dragUpdateDetails.delta.dx;
                              positionY = positionY + dragUpdateDetails.delta.dy;
                            }
                          }else{
                            totalHeight = totalHeight - dragUpdateDetails.delta.dy;
                            totalWidth = totalWidth + dragUpdateDetails.delta.dx;
                            positionY = positionY + dragUpdateDetails.delta.dy;
                          }
                          // totalHeight = totalHeight - dragUpdateDetails.delta.dy;
                          // totalWidth = totalWidth + dragUpdateDetails.delta.dx;
                          // positionY = positionY + dragUpdateDetails.delta.dy;


                          // positionX = positionX + dragUpdateDetails.delta.dx;
                        });
                      },
                      onPanEnd: (DragEndDetails dragEndDetails) {
                        putImageData();
                        // move = true;
                      },
                      child: Container(
                        width: totalWidth / 2,
                        height: totalHeight / 2,
                        color: Colors.transparent,
                      ),
                    )),
                //3(왼쪽 아래 구석을 선택할 시)
                Positioned(
                    bottom: 0.w,
                    left: 0.w,
                    child: GestureDetector(
                      onPanStart: (DragStartDetails dragStartDetails) {
                        setState(() {
                          deleteOnOff = false;
                          move = false;
                        });
                      },
                      onPanUpdate: (DragUpdateDetails dragUpdateDetails) {
                        setState(() {
                          if(dragUpdateDetails.delta.dy <= 0 && dragUpdateDetails.delta.dx >= 0){
                            if(totalHeight + dragUpdateDetails.delta.dy<= 100.w && totalWidth - dragUpdateDetails.delta.dx<= 100.w){
                            }else if(totalHeight + dragUpdateDetails.delta.dy>= 100.w && totalWidth - dragUpdateDetails.delta.dx<= 100.w){
                              totalHeight = totalHeight + dragUpdateDetails.delta.dy;
                              // positionX = positionX + dragUpdateDetails.delta.dx;
                            }else if(totalHeight + dragUpdateDetails.delta.dy<= 100.w && totalWidth - dragUpdateDetails.delta.dx>= 100.w){
                              totalWidth = totalWidth - dragUpdateDetails.delta.dx;
                              positionX = positionX + dragUpdateDetails.delta.dx;
                            }else{
                              totalHeight = totalHeight + dragUpdateDetails.delta.dy;
                              totalWidth = totalWidth - dragUpdateDetails.delta.dx;
                              positionX = positionX + dragUpdateDetails.delta.dx;
                            }
                          }else if(dragUpdateDetails.delta.dy <= 0 && dragUpdateDetails.delta.dx <= 0){
                            if(totalHeight + dragUpdateDetails.delta.dy< 100.w){
                              // totalHeight = totalHeight + dragUpdateDetails.delta.dy;
                              totalWidth = totalWidth - dragUpdateDetails.delta.dx;
                              positionX = positionX + dragUpdateDetails.delta.dx;

                            }else{
                              totalHeight = totalHeight + dragUpdateDetails.delta.dy;
                              totalWidth = totalWidth - dragUpdateDetails.delta.dx;
                              positionX = positionX + dragUpdateDetails.delta.dx;
                            }
                          }else if(dragUpdateDetails.delta.dy >= 0 && dragUpdateDetails.delta.dx >= 0){
                            if(totalWidth - dragUpdateDetails.delta.dx< 100.w){
                              totalHeight = totalHeight + dragUpdateDetails.delta.dy;
                              // totalWidth = totalWidth - dragUpdateDetails.delta.dx;
                              // positionX = positionX + dragUpdateDetails.delta.dx;
                            }else{
                              totalHeight = totalHeight + dragUpdateDetails.delta.dy;
                              totalWidth = totalWidth - dragUpdateDetails.delta.dx;
                              positionX = positionX + dragUpdateDetails.delta.dx;
                            }
                          }else{
                            totalHeight = totalHeight + dragUpdateDetails.delta.dy;
                            totalWidth = totalWidth - dragUpdateDetails.delta.dx;
                            positionX = positionX + dragUpdateDetails.delta.dx;
                          }
                          // totalHeight = totalHeight + dragUpdateDetails.delta.dy;
                          // totalWidth = totalWidth - dragUpdateDetails.delta.dx;
                          // positionX = positionX + dragUpdateDetails.delta.dx;

                          // positionY = positionY + dragUpdateDetails.delta.dy;
                        });
                      },
                      onPanEnd: (DragEndDetails dragEndDetails) {
                        putImageData();
                        // move = true;
                      },
                      child: Container(
                        width: totalWidth / 2,
                        height: totalHeight / 2,
                        color: Colors.transparent,
                      ),
                    )),
                //4(오른쪽 아래 구석을 선택할 시)
                Positioned(
                    bottom: 0.w,
                    right: 0.w,
                    child: GestureDetector(
                      onPanStart: (DragStartDetails dragStartDetails) {
                        setState(() {
                          deleteOnOff = false;
                          move = false;
                        });
                      },
                      onPanUpdate: (DragUpdateDetails dragUpdateDetails) {
                        setState(() {
                          if(dragUpdateDetails.delta.dy<=0 && dragUpdateDetails.delta.dx <= 0){
                            if(totalHeight + dragUpdateDetails.delta.dy<= 100.w && totalWidth + dragUpdateDetails.delta.dx<= 100.w){

                            }else if(totalHeight + dragUpdateDetails.delta.dy>= 100.w && totalWidth + dragUpdateDetails.delta.dx<= 100.w){

                              totalHeight = totalHeight + dragUpdateDetails.delta.dy;
                              // totalWidth = totalWidth + dragUpdateDetails.delta.dx;
                            }else if(totalHeight + dragUpdateDetails.delta.dy<= 100.w && totalWidth + dragUpdateDetails.delta.dx>= 100.w){

                              // totalHeight = totalHeight + dragUpdateDetails.delta.dy;
                              totalWidth = totalWidth + dragUpdateDetails.delta.dx;
                            }else{
                              totalHeight = totalHeight + dragUpdateDetails.delta.dy;
                              totalWidth = totalWidth + dragUpdateDetails.delta.dx;
                            }
                          }else if(dragUpdateDetails.delta.dy<=0 && dragUpdateDetails.delta.dx >= 0){
                            if(totalHeight + dragUpdateDetails.delta.dy< 100.w){
                              // totalHeight = totalHeight + dragUpdateDetails.delta.dy;
                              totalWidth = totalWidth + dragUpdateDetails.delta.dx;
                            }else{
                              totalHeight = totalHeight + dragUpdateDetails.delta.dy;
                              totalWidth = totalWidth + dragUpdateDetails.delta.dx;
                            }
                          }else if(dragUpdateDetails.delta.dy>=0 && dragUpdateDetails.delta.dx <= 0){
                            if(totalWidth + dragUpdateDetails.delta.dx< 100.w){
                              totalHeight = totalHeight + dragUpdateDetails.delta.dy;
                              // totalWidth = totalWidth + dragUpdateDetails.delta.dx;
                            }else{
                              totalHeight = totalHeight + dragUpdateDetails.delta.dy;
                              totalWidth = totalWidth + dragUpdateDetails.delta.dx;
                            }
                          }else{
                            totalHeight = totalHeight + dragUpdateDetails.delta.dy;
                            totalWidth = totalWidth + dragUpdateDetails.delta.dx;
                          }
                          // totalHeight = totalHeight + dragUpdateDetails.delta.dy;
                          // totalWidth = totalWidth + dragUpdateDetails.delta.dx;
                        });
                      },
                      onPanEnd: (DragEndDetails dragEndDetails) {
                        putImageData();
                        // move = true;
                      },
                      child: Container(
                        width: totalWidth / 2,
                        height: totalHeight / 2,
                        color: Colors.transparent,
                      ),
                    )),

                //5(왼쪽 구석을 선택할 시)
                Positioned(
                    left: 0.w,
                    top: 18.w,
                    child: GestureDetector(
                      onPanStart: (DragStartDetails dragStartDetails) {
                        setState(() {
                          deleteOnOff = false;
                          move = false;
                        });
                      },
                      onPanUpdate: (DragUpdateDetails dragUpdateDetails) {
                        setState(() {
                          if(dragUpdateDetails.delta.dx>=0){
                            if(totalWidth - dragUpdateDetails.delta.dx< 100.w){

                            }else{
                              totalWidth = totalWidth - dragUpdateDetails.delta.dx;
                              positionX = positionX + dragUpdateDetails.delta.dx;
                            }
                          }else{
                            totalWidth = totalWidth - dragUpdateDetails.delta.dx;
                            positionX = positionX + dragUpdateDetails.delta.dx;
                          }

                          // totalWidth = totalWidth - dragUpdateDetails.delta.dx;
                          // positionX = positionX + dragUpdateDetails.delta.dx;

                          // totalHeight = totalHeight - dragUpdateDetails.delta.dy;
                          // positionY = positionY + dragUpdateDetails.delta.dy;
                        });
                      },
                      onPanEnd: (DragEndDetails dragEndDetails) {
                        putImageData();
                        // move = true;
                      },
                      child: Container(
                        width: totalWidth / 2,
                        height: totalHeight - 36.w,
                        color: Colors.transparent,
                      ),
                    )),
                //6(위 구석을 선택할 시)
                Positioned(
                    top: 0.w,
                    left: 18.w,
                    child: GestureDetector(
                      onPanStart: (DragStartDetails dragStartDetails) {
                        setState(() {
                          deleteOnOff = false;
                          move = false;
                        });
                      },
                      onPanUpdate: (DragUpdateDetails dragUpdateDetails) {
                        setState(() {
                          if(dragUpdateDetails.delta.dy>=0 ){
                            if(totalHeight - dragUpdateDetails.delta.dy < 100.w ){

                            }else{
                              totalHeight = totalHeight - dragUpdateDetails.delta.dy;
                              positionY = positionY + dragUpdateDetails.delta.dy;
                            }
                          }else{
                            totalHeight = totalHeight - dragUpdateDetails.delta.dy;
                            positionY = positionY + dragUpdateDetails.delta.dy;
                          }

                          // totalHeight = totalHeight - dragUpdateDetails.delta.dy;
                          // positionY = positionY + dragUpdateDetails.delta.dy;


                          // totalWidth = totalWidth - dragUpdateDetails.delta.dx;
                          // positionX = positionX + dragUpdateDetails.delta.dx;
                        });
                      },
                      onPanEnd: (DragEndDetails dragEndDetails) {
                        putImageData();
                        // move = true;
                      },
                      child: Container(
                        width: totalWidth - 36.w,
                        height: totalHeight / 2,
                        color: Colors.transparent,
                      ),
                    )),
                //7(아래쪽 구석을 선택할 시)
                Positioned(
                    bottom: 0.w,
                    left: 18.w,
                    child: GestureDetector(
                      onPanStart: (DragStartDetails dragStartDetails) {
                        setState(() {
                          deleteOnOff = false;
                          move = false;
                        });
                      },
                      onPanUpdate: (DragUpdateDetails dragUpdateDetails) {
                        setState(() {
                          if(dragUpdateDetails.delta.dy<=0 ){
                            if(totalHeight + dragUpdateDetails.delta.dy< 100.w){
                            }
                            else{
                              totalHeight = totalHeight + dragUpdateDetails.delta.dy;
                            }
                          }else{
                            totalHeight = totalHeight + dragUpdateDetails.delta.dy;
                          }
                          // totalHeight = totalHeight + dragUpdateDetails.delta.dy;


                          // totalWidth = totalWidth - dragUpdateDetails.delta.dx;
                          // positionY = positionY + dragUpdateDetails.delta.dy;
                          // positionX = positionX + dragUpdateDetails.delta.dx;
                        });
                      },
                      onPanEnd: (DragEndDetails dragEndDetails) {
                        putImageData();
                        // move = true;
                      },
                      child: Container(
                        width: totalWidth - 36.w,
                        height: totalHeight / 2,
                        color: Colors.transparent,
                      ),
                    )),
                //8(오른쪽 구석을 선택할 시)
                Positioned(
                    right: 0.w,
                    top: 18.w,
                    child: GestureDetector(
                      onPanStart: (DragStartDetails dragStartDetails) {
                        setState(() {
                          deleteOnOff = false;
                          move = false;
                        });
                      },
                      onPanUpdate: (DragUpdateDetails dragUpdateDetails) {
                        setState(() {
                          if(dragUpdateDetails.delta.dx <= 0){
                            if(totalWidth + dragUpdateDetails.delta.dx< 100.w){

                            }else{
                              totalWidth = totalWidth + dragUpdateDetails.delta.dx;
                            }
                          }else{
                            totalWidth = totalWidth + dragUpdateDetails.delta.dx;
                          }
                          // totalWidth = totalWidth + dragUpdateDetails.delta.dx;

                          // totalHeight = totalHeight + dragUpdateDetails.delta.dy;

                          // positionY = positionY + dragUpdateDetails.delta.dy;
                          // positionX = positionX + dragUpdateDetails.delta.dx;
                        });
                      },
                      onPanEnd: (DragEndDetails dragEndDetails) {
                        putImageData();
                        // move = true;
                      },
                      child: Container(
                        width: totalWidth / 2,
                        height: totalHeight - 36.w,
                        color: Colors.transparent,
                      ),
                    )),

                Center(
                  child: GestureDetector(
                      onLongPress: () {
                        setState(() {
                          deleteOnOff = true;
                        });
                      },
                      onPanUpdate: (DragUpdateDetails dragUpdateDetails) {
                        setState(() {
                          move = false;
                          // totalHeight = totalHeight + dragUpdateDetails.delta.dy;
                          // totalWidth = totalWidth + dragUpdateDetails.delta.dx;
                          positionY = positionY + dragUpdateDetails.delta.dy;
                          positionX = positionX + dragUpdateDetails.delta.dx;
                        });
                      },
                      onPanEnd: (DragEndDetails dragEndDetails) {
                        putImageData();
                        // move = true;
                      },
                      // child:  WidgetMask(
                      //   mask: image!,
                      //   child:
                      // Container(
                      //     padding: EdgeInsets.all(15.w),
                      //     width: totalWidth - 30.w ,
                      //     height: totalHeight - 30.w,
                      //     color: Colors.blue,
                      //   ),
                      // )
                      child:
                      image != null ?
                      Container(
                        padding: EdgeInsets.all(15.w),
                        width: totalWidth - 30.w,
                        height: totalHeight - 30.w,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: image!.image,
                                fit: BoxFit.fill
                            )
                        ),
                        // color: Colors.blue,
                        // child:
                      ):Container()
                  ),
                ),
                if (deleteOnOff) ...[
                  Positioned(
                    top: 0.w,
                    right: 0.w,
                    child: GestureDetector(
                      onTap: () {
                        deleteImage();
                      },
                      child: Container(
                          width: 20.w,
                          height: 20.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                  color: Color(0x29505050),
                                  offset: Offset(2, 2),
                                  blurRadius: 6)
                            ],
                            color: Color(0xffCAACF2),
                          ),
                          child: Center(
                            child:
                            Icon(Icons.close, size: 20.w, color: Colors.white),
                          )),
                    ),
                  ),
                  Positioned(
                    top: 0.w,
                    right: 25.w,
                    child: GestureDetector(
                      onTap: () {
                        patchImage('down');
                      },
                      child: Container(
                          width: 20.w,
                          height: 20.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                  color: Color(0x29505050),
                                  offset: Offset(2, 2),
                                  blurRadius: 6)
                            ],
                            color: Color(0xffCAACF2),
                          ),
                          child: Center(
                            child:
                            Icon(Icons.arrow_drop_down_outlined, size: 20.w, color: Colors.white),
                          )),
                    ),
                  ),
                  Positioned(
                    top: 0.w,
                    right: 50.w,
                    child: GestureDetector(
                      onTap: () {
                        patchImage('up');
                      },
                      child: Container(
                          width: 20.w,
                          height: 20.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                  color: Color(0x29505050),
                                  offset: Offset(2, 2),
                                  blurRadius: 6)
                            ],
                            color: Color(0xffCAACF2),
                          ),
                          child: Center(
                            child:
                            Icon(Icons.arrow_drop_up_outlined, size: 20.w, color: Colors.white),
                          )),
                    ),
                  ),

                ],
                // Center(
                //   child: Column(
                //     mainAxisAlignment: MainAxisAlignment.center,
                //     children: [
                //       Text('id: ' + widget.imageId.toString(),
                //       style: TextStyle(
                //         color: Colors.white,
                //       ),),
                //       Text('level: ' + widget.level.toString(),
                //         style: TextStyle(
                //           color: Colors.white,
                //         ),),
                //       Text('index: ' + widget.index.toString(),
                //         style: TextStyle(
                //           color: Colors.white,
                //         ),),
                //     ],
                //   ),
                // )
              ],
            ),
          ),
        ),
      );
    }else{
      return Positioned(
        top: positionY,
        left: positionX,
        child: Container(
          width: totalWidth,
          height: totalHeight,
          child: Stack(
            children: [
              Center(
                child: Container(
                  padding: EdgeInsets.all(9.w),
                  width: totalWidth - 18.w,
                  height: totalHeight - 18.w,
                  decoration: BoxDecoration(
                      border: Border.all(width: 1.w, color: Colors.black),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Color(0x29000000),
                          blurRadius: 6,
                          offset: Offset(0, 3),
                        )
                      ]),
                ),
              ),
              //1(왼쪽 위 구석을 선택할 시)
              Positioned(
                  top: 0.w,
                  left: 0.w,
                  child: Container(
                    width: totalWidth / 2,
                    height: totalHeight / 2,
                    color: Colors.transparent,
                  )),
              //2(오른쪽 위 구석을 선택할 시)
              Positioned(
                  top: 0.w,
                  right: 0.w,
                  child: Container(
                    width: totalWidth / 2,
                    height: totalHeight / 2,
                    color: Colors.transparent,
                  )),
              //3(왼쪽 아래 구석을 선택할 시)
              Positioned(
                  bottom: 0.w,
                  left: 0.w,
                  child: Container(
                    width: totalWidth / 2,
                    height: totalHeight / 2,
                    color: Colors.transparent,
                  )),
              //4(오른쪽 아래 구석을 선택할 시)
              Positioned(
                  bottom: 0.w,
                  right: 0.w,
                  child: Container(
                    width: totalWidth / 2,
                    height: totalHeight / 2,
                    color: Colors.transparent,
                  )),

              //5(왼쪽 구석을 선택할 시)
              Positioned(
                  left: 0.w,
                  top: 18.w,
                  child: Container(
                    width: totalWidth / 2,
                    height: totalHeight - 36.w,
                    color: Colors.transparent,
                  )),
              //6(위 구석을 선택할 시)
              Positioned(
                  top: 0.w,
                  left: 18.w,
                  child: Container(
                    width: totalWidth - 36.w,
                    height: totalHeight / 2,
                    color: Colors.transparent,
                  )),
              //7(아래쪽 구석을 선택할 시)
              Positioned(
                  bottom: 0.w,
                  left: 18.w,
                  child: Container(
                    width: totalWidth - 36.w,
                    height: totalHeight / 2,
                    color: Colors.transparent,
                  )),
              //8(오른쪽 구석을 선택할 시)
              Positioned(
                  right: 0.w,
                  top: 18.w,
                  child: Container(
                    width: totalWidth / 2,
                    height: totalHeight - 36.w,
                    color: Colors.transparent,
                  )),

              Center(
                child: image != null ?
                Container(
                  padding: EdgeInsets.all(15.w),
                  width: totalWidth - 30.w,
                  height: totalHeight - 30.w,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: image!.image,
                          fit: BoxFit.fill
                      )
                  ),
                  // color: Colors.blue,
                  // child:
                ):Container(),
              ),
              if (deleteOnOff) ...[
                Positioned(
                  top: 0.w,
                  right: 0.w,
                  child: Container(
                      width: 20.w,
                      height: 20.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                              color: Color(0x29505050),
                              offset: Offset(2, 2),
                              blurRadius: 6)
                        ],
                        color: Color(0xffCAACF2),
                      ),
                      child: Center(
                        child:
                        Icon(Icons.close, size: 20.w, color: Colors.white),
                      )),
                ),
                Positioned(
                  top: 0.w,
                  right: 25.w,
                  child: Container(
                      width: 20.w,
                      height: 20.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                              color: Color(0x29505050),
                              offset: Offset(2, 2),
                              blurRadius: 6)
                        ],
                        color: Color(0xffCAACF2),
                      ),
                      child: Center(
                        child:
                        Icon(Icons.arrow_drop_down_outlined, size: 20.w, color: Colors.white),
                      )),
                ),
                Positioned(
                  top: 0.w,
                  right: 50.w,
                  child: Container(
                      width: 20.w,
                      height: 20.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                              color: Color(0x29505050),
                              offset: Offset(2, 2),
                              blurRadius: 6)
                        ],
                        color: Color(0xffCAACF2),
                      ),
                      child: Center(
                        child:
                        Icon(Icons.arrow_drop_up_outlined, size: 20.w, color: Colors.white),
                      )),
                ),

              ],

            ],
          ),
        ),
      );
    }

  }
}



Future pickImage(ImageSource source, context) async {
  try {
    final image = await ImagePicker().pickImage(source: source);
    if (image == null) return;
    final imageTemp = File(image.path);
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: imageTemp.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ],
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: true),
        IOSUiSettings(
          title: 'Cropper',
        ),
        WebUiSettings(
          context: context,
        ),
      ],
    );
    return File(croppedFile!.path);
  } on PlatformException catch (e) {
    print('Failed to pick image: $e');
  }
}