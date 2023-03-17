import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SelectNumber extends StatefulWidget {
  const SelectNumber({Key? key,
    required this.finalNumber,
    required this.startNumber,
    required this.defaultNumber,
    required this.stringLength,
    required this.setNumber,
  }) : super(key: key);
  final int startNumber;
  final int finalNumber;
  final int defaultNumber;
  final int stringLength;
  final Function(int) setNumber;

  @override
  State<SelectNumber> createState() => _SelectNumberState();
}

class _SelectNumberState extends State<SelectNumber> {
  ScrollController _controller = ScrollController();
  List<int> returnList = [];
  int selectedNumber = 6;
  int dragCount = 0;
  double containerHeight = 0;
  double oneBlockSize = 0;
  @override
  void initState() {
    super.initState();

    _controller = ScrollController();
    _controller.addListener(_scrollListener);
    for(int i = widget.startNumber; i<widget.finalNumber; i++){
      returnList.add(i);
      dragCount++;
    }
    dragCount --;
    widget.setNumber(returnList[widget.defaultNumber]);

    selectedNumber = widget.defaultNumber;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  _scrollListener() {}

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_){
      oneBlockSize = (_controller.position.maxScrollExtent - 24.w)/dragCount;
      _controller.jumpTo(oneBlockSize * widget.defaultNumber + 24.w);
      containerHeight = (_controller.position.maxScrollExtent/dragCount).w;
    });
    return Row(
      children: [
        Container(
          width: (30 * widget.stringLength).w,
          height: 58.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10.w)),
            color: Colors.white,
          ),

          child: GestureDetector(
            onVerticalDragUpdate:
                (DragUpdateDetails dragUpdateDetails) {
              if (_controller.hasClients) {
                if (_controller.offset  <
                    _controller.position.minScrollExtent+ 24.w) {
                } else if (_controller.offset >=
                    _controller.position.minScrollExtent &&
                    _controller.offset <=
                        _controller.position.maxScrollExtent) {
                  _controller.jumpTo(_controller.offset +
                      -dragUpdateDetails.primaryDelta!);
                } else if (_controller.offset >
                    _controller.position.maxScrollExtent) {}
              }
            },
            onVerticalDragEnd: (DragEndDetails dragEndDetails) {

              for (int i = 0; i < dragCount+1; i++) {
                if (oneBlockSize *
                    i -
                    oneBlockSize /
                        2  + 24.w<
                    _controller.offset &&
                    (_controller.offset) <=
                        oneBlockSize *
                            (i + 1) +
                            oneBlockSize /
                                2+ 24.w) {
                  selectedNumber = i;
                  widget.setNumber(returnList[selectedNumber]);
                  _controller.animateTo(
                    ((oneBlockSize *
                        i + 24.w)),
                    duration: Duration(microseconds: 1000000),
                    curve: Curves.fastOutSlowIn,
                  );
                }
              }
            },
            child: ScrollConfiguration(
              behavior: const ScrollBehavior().copyWith(overscroll: false),
              child: ListView(
                physics: const RangeMaintainingScrollPhysics(),
                controller: _controller,
                children: [
                  for (int i = widget.startNumber; i < widget.finalNumber; i++) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          i.toString(),
                          style: TextStyle(fontSize: 40.w,
                              color: Color(0xff393838)),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
        SizedBox(width: 5.w,),
        Container(
          height: 54.w,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: (){
                  if(selectedNumber<dragCount+1){
                    selectedNumber++;
                    widget.setNumber(returnList[selectedNumber]);
                    _controller.animateTo(
                      ((oneBlockSize *
                          selectedNumber + 24.w)),
                      // _controller.animateTo(
                      //   (((_controller.position.maxScrollExtent /
                      //       dragCount) *
                      //       selectTemperature)),
                      duration: Duration(microseconds: 100000),
                      curve: Curves.fastOutSlowIn,
                    );
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5.w)),
                    color: Color(0xFFA666FB),
                  ),
                  child: Icon(Icons.arrow_drop_up,size: 18.w,color: Color(0xffffffff),),
                ),
              ),
              SizedBox(height: 5.w,),
              GestureDetector(
                onTap: (){
                  if(selectedNumber>0){
                    selectedNumber--;
                    widget.setNumber(returnList[selectedNumber]);
                    _controller.animateTo(
                      ((oneBlockSize *
                          selectedNumber + 24.w)),
                      // _controller.animateTo(
                      //   (((_controller.position.maxScrollExtent /
                      //       dragCount-1) *
                      //       selectTemperature)),
                      duration: Duration(microseconds: 100000),
                      curve: Curves.fastOutSlowIn,
                    );
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5.w)),
                    color: Color(0xFFA666FB),
                  ),
                  child: Icon(Icons.arrow_drop_down,size: 18.w,color: Colors.white,),
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}