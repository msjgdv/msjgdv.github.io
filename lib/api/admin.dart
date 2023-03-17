import 'package:json_annotation/json_annotation.dart';
import 'package:retrofit/retrofit.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:dio/dio.dart';

part 'admin.g.dart';

@RestApi()
abstract class RestAdminClient {
  factory RestAdminClient({required Dio dio}) => _RestAdminClient(dio);

  @POST('/api/local/check')
  Future<Login2Token> postPwdCheck(
      @Header('authorization') String token,
      @Body() PwdCheckForm pwdCheckForm
      );

  @GET('/api/local')
  Future<dynamic> getAdminInfo(
      @Header('authorization') String token,
      );

  @GET('{imagePath}')
  Future<dynamic> getChildImage(
      @Header('authorization') String token,
      @Path('imagePath') String imageName,
      );

  @PUT('/api/child')
  Future<dynamic> putChildInfo(
      @Header('authorization') String token2,
      @Body() FormData formData
      );
  @PATCH('/api/local')
  Future<dynamic> putAdminInfo(
      @Header('authorization') String token2,
      @Body() FormData formData
      );
  @POST('/api/admin/child/bulkcreate')
  Future<dynamic> postChildInfo(
      @Header('authorization') String token2,
      @Body() FormData formData
      );
  @POST('/api/local/withdrawCheck')
  Future<dynamic> postAdminCheck(
      @Header('authorization') String token,
      @Body() AdminCheck adminCheck,
      );

  @POST('/api/admin/withdraw')
  Future<dynamic> postAdminWithdraw(
      @Header('authorization') String token,
      @Body() AdminCheck adminCheck,
      );

  @GET('/api/class/{year}')
  Future<List<ClassInfo>> getAdminClassInfo(
      @Header('authorization') String token,
      @Path('year') int year,
      );

  @POST('/api/class')
  Future<dynamic> postAdminCreateClass(
      @Header('authorization') String token,
      @Body() CreateClass createClass
      );

  @PUT('/api/class')
  Future<dynamic> putAdminCorrectionClass(
      @Header('authorization') String token,
      @Body() CorrectionClass correctionClass
      );

  @POST('/api/class/delete')
  Future<dynamic> postAdminDeleteClass(
      @Header('authorization') String token,
      @Body() DeleteClass deleteClass,
      );

  @GET('/api/teacher')
  Future<List<TeacherInfo>> getTeacherList(
      @Header('authorization') String token,
      );

  @GET('/api/apply')
  Future<List<ApplyTeacherList>> getApplyList(
      @Header('authorization') String token,
      );

  @POST('/api/teacher')
  Future<dynamic> postTeacher(
      @Header('authorization') String token,
      @Body() Identification identification,
      );
  @DELETE('/api/apply/{id}')
  Future<dynamic> deleteTeacher(
      @Header('authorization') String token,
      @Path('id') int id,
      );

  @PUT('/api/teacher')
  Future<dynamic> putTeacher(
      @Header('authorization') String token,
      @Body() DeleteTeacher deleteTeacher,
      );

  @POST('/api/child')
  Future<dynamic> postChild(
      @Header('authorization') String token,
      @Body() FormData formData,
      );

  @GET('/api/child/{year}')
  Future<List<ChildInfo>> getChildInfo(
      @Header('authorization') String token,
      @Path('year') String year,
      );
  @POST('/api/child/delete')
  Future<dynamic> postChildDelete(
      @Header('authorization') String token,
      @Body() PostChildDelete postChildDelete,
      );
  @GET('/api/kindergarten')
  Future<KindergartenData> getKindergarten(
      @Header('authorization') String token,
      );
  @POST('/api/local/contact')
  Future<dynamic> postContact(
      @Header('authorization') String token,
      @Body() PostContact postContact,
      );

}
final String apiDomain = dotenv.get('BASE_URL', fallback: '');
final restAdminClient = RestAdminClient(dio: Dio(BaseOptions(baseUrl: apiDomain)));

@JsonSerializable()
class AdminCheck {
  String email;
  String name;
  String password;

  AdminCheck({
    required this.name,
    required this.password,
    required this.email,
  });

  factory AdminCheck.fromJson(Map<String, dynamic> json) => _$AdminCheckFromJson(json);
  Map<String, dynamic> toJson() => _$AdminCheckToJson(this);
}



@JsonSerializable()
class ChangedInfo {
  List<String> imageFiles;
  List<Map<String, dynamic>> corrections;
  ChangedInfo({
    required this.imageFiles,
    required this.corrections,

  });
  factory ChangedInfo.fromJson(Map<String, dynamic> json) => _$ChangedInfoFromJson(json);
  Map<String, dynamic> toJson() => _$ChangedInfoToJson(this);
}

@JsonSerializable()
class PwdCheckForm{
  String password;
  String type;
  PwdCheckForm({
    required this.password,
    required this.type
  });
  factory PwdCheckForm.fromJson(Map<String, dynamic> json) => _$PwdCheckFormFromJson(json);
  Map<String, dynamic> toJson() => _$PwdCheckFormToJson(this);
}

//2차 비번 인증 후 받을 2번째 토큰
@JsonSerializable()
class Login2Token{
  String token;
  Login2Token({
    required this.token,
  });
  factory Login2Token.fromJson(Map<String, dynamic> json) => _$Login2TokenFromJson(json);
  Map<String, dynamic> toJson() => _$Login2TokenToJson(this);
}

@JsonSerializable()
class ClassInfo{
  int id;
  String age;
  String name;
  String teacher;
  int count;
  String comment;
  int year;
  int tid;

  ClassInfo({
    required this.name,
    required this.teacher,
    required this.comment,
    required this.count,
    required this.age,
    required this.id,
    required this.year,
    required this.tid,
});
  factory ClassInfo.fromJson(Map<String, dynamic> json) => _$ClassInfoFromJson(json);
  Map<String, dynamic> toJson() => _$ClassInfoToJson(this);
}

@JsonSerializable()
class CreateClass{
  List<Map<String, dynamic>> createList;
  CreateClass({
    required this.createList,
});
  factory CreateClass.fromJson(Map<String, dynamic> json) => _$CreateClassFromJson(json);
  Map<String, dynamic> toJson() => _$CreateClassToJson(this);
}

@JsonSerializable()
class CorrectionClass{
  List<Map<String, dynamic>> correctionList;
  CorrectionClass({
    required this.correctionList,
  });
  factory CorrectionClass.fromJson(Map<String, dynamic> json) => _$CorrectionClassFromJson(json);
  Map<String, dynamic> toJson() => _$CorrectionClassToJson(this);
}

@JsonSerializable()
class DeleteTeacher{
  List<int> deleteList;
  DeleteTeacher({
    required this.deleteList,
  });
  factory DeleteTeacher.fromJson(Map<String, dynamic> json) => _$DeleteTeacherFromJson(json);
  Map<String, dynamic> toJson() => _$DeleteTeacherToJson(this);
}

@JsonSerializable()
class DeleteClass{
  List<int> deleteList;
  DeleteClass({
    required this.deleteList,
  });
  factory DeleteClass.fromJson(Map<String, dynamic> json) => _$DeleteClassFromJson(json);
  Map<String, dynamic> toJson() => _$DeleteClassToJson(this);
}

@JsonSerializable()
class TeacherInfo{
  int id;
  String name;
  String className;
  String phoneNumber;
  String email;
  TeacherInfo({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.email,
    required this.className,
  });
  factory TeacherInfo.fromJson(Map<String, dynamic> json) => _$TeacherInfoFromJson(json);
  Map<String, dynamic> toJson() => _$TeacherInfoToJson(this);
}

@JsonSerializable()
class ApplyTeacherList{
  int id;
  String email;
  String name;
  String phoneNumber;
  ApplyTeacherList({
    required this.email,
    required this.name,
    required this.id,
    required this.phoneNumber,
});
  factory ApplyTeacherList.fromJson(Map<String, dynamic> json) => _$ApplyTeacherListFromJson(json);
  Map<String, dynamic> toJson() => _$ApplyTeacherListToJson(this);
}

@JsonSerializable()
class Identification{
  int id;
  Identification({
    required this.id
});
  factory Identification.fromJson(Map<String, dynamic> json) => _$IdentificationFromJson(json);
  Map<String, dynamic> toJson() => _$IdentificationToJson(this);
}

@JsonSerializable()
class CreateChild{
  int id;
  String name;
  String birthday;
  bool sex;
  String imageName;
  String comment;
  String parentName;
  String parentPhoneNumber;
  CreateChild({
    required this.id,
    required this.name,
    required this.parentName,
    required this.parentPhoneNumber,
    required this.comment,
    required this.imageName,
    required this.sex,
    required this.birthday,

  });
  factory CreateChild.fromJson(Map<String, dynamic> json) => _$CreateChildFromJson(json);
  Map<String, dynamic> toJson() => _$CreateChildToJson(this);

}

@JsonSerializable()
class ChildInfo{
  int id;
  String name;
  String birthday;
  bool sex;
  String comment;
  String imagePath;
  String className;
  String parentName;
  String parentPhoneNumber;
  String relation;

  ChildInfo({
    required this.id,
    required this.name,
    required this.parentName,
    required this.parentPhoneNumber,
    required this.comment,
    required this.imagePath,
    required this.sex,
    required this.birthday,
    required this.relation,
    required this.className,

  });
  factory ChildInfo.fromJson(Map<String, dynamic> json) => _$ChildInfoFromJson(json);
  Map<String, dynamic> toJson() => _$ChildInfoToJson(this);

}

@JsonSerializable()
class PostChildDelete{
  List<int> deleteList;

  PostChildDelete({
    required this.deleteList,


  });
  factory PostChildDelete.fromJson(Map<String, dynamic> json) => _$PostChildDeleteFromJson(json);
  Map<String, dynamic> toJson() => _$PostChildDeleteToJson(this);

}
@JsonSerializable()
class KindergartenData{
  String name;
  String address;
  String phoneNumber;
  String director;
  String directorPhoneNumber;
  KindergartenData({
   required this.name,
   required this.phoneNumber,
   required this.address,
   required this.director,
    required this.directorPhoneNumber,

});
  factory KindergartenData.fromJson(Map<String, dynamic> json) => _$KindergartenDataFromJson(json);
  Map<String, dynamic> toJson() => _$KindergartenDataToJson(this);
}

@JsonSerializable()
class PostContact{
  String subject;
  String content;
  PostContact({
    required this.subject,
    required this.content,
  });
  factory PostContact.fromJson(Map<String, dynamic> json) => _$PostContactFromJson(json);
  Map<String, dynamic> toJson() => _$PostContactToJson(this);

}