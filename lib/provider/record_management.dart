import 'package:flutter/material.dart';

class Record with ChangeNotifier {
  String time;
  String type;
  String content;

  Record({
    required this.time,
    required this.type,
    required this.content,
  });
}

class RecordDataManagement with ChangeNotifier {
  int recordNum = 5;
  List<Record> recordList = [
    Record(time: '22.04.22 16:12', type: '아이 반이동', content: '장비선생님이 아이1을 코끼리반으로 반 이동시킴'),
    Record(time: '22.04.22 16:12', type: '아이 반이동', content: '장비선생님이 아이1을 코끼리반으로 반 이동시킴'),
    Record(time: '22.04.22 16:12', type: '아이 반이동', content: '장비선생님이 아이1을 코끼리반으로 반 이동시킴'),
    Record(time: '22.04.22 16:12', type: '아이 반이동', content: '장비선생님이 아이1을 코끼리반으로 반 이동시킴'),
    Record(time: '22.04.22 16:12', type: '아이 반이동', content: '장비선생님이 아이1을 코끼리반으로 반 이동시킴'),
  ];
}