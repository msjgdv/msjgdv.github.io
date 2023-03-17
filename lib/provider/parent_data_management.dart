import 'package:flutter/material.dart';

class Parent with ChangeNotifier {
  var id;
  var childName;
  String childClassName;
  String relation;
  String name;
  String phoneNum;



  Parent({
    this.id,
    this.childName,
    required this.childClassName,
    required this.relation,
    required this.name,
    required this.phoneNum,
  });
}

class ParentDataManagement with ChangeNotifier{
  int parentNum = 2;
  List<Parent> parentList = [ //메인 list에 뜨는 학부모들
    Parent(name: '권영호', childClassName: '코끼리반', relation: '아빠', phoneNum: '01011112222', id: 'parent@aijoa.com', childName: 'ex1'),
    Parent(name: '선생', childClassName: '토끼반', relation: '엄마', phoneNum: '01012341234', id: 'adult@aijoa.com', childName: 'ex2')
  ];

}
