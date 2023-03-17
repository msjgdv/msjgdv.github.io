// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdminCheck _$AdminCheckFromJson(Map<String, dynamic> json) => AdminCheck(
      name: json['name'] as String,
      password: json['password'] as String,
      email: json['email'] as String,
    );

Map<String, dynamic> _$AdminCheckToJson(AdminCheck instance) =>
    <String, dynamic>{
      'email': instance.email,
      'name': instance.name,
      'password': instance.password,
    };

ChangedInfo _$ChangedInfoFromJson(Map<String, dynamic> json) => ChangedInfo(
      imageFiles: (json['imageFiles'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      corrections: (json['corrections'] as List<dynamic>)
          .map((e) => e as Map<String, dynamic>)
          .toList(),
    );

Map<String, dynamic> _$ChangedInfoToJson(ChangedInfo instance) =>
    <String, dynamic>{
      'imageFiles': instance.imageFiles,
      'corrections': instance.corrections,
    };

PwdCheckForm _$PwdCheckFormFromJson(Map<String, dynamic> json) => PwdCheckForm(
      password: json['password'] as String,
      type: json['type'] as String,
    );

Map<String, dynamic> _$PwdCheckFormToJson(PwdCheckForm instance) =>
    <String, dynamic>{
      'password': instance.password,
      'type': instance.type,
    };

Login2Token _$Login2TokenFromJson(Map<String, dynamic> json) => Login2Token(
      token: json['token'] as String,
    );

Map<String, dynamic> _$Login2TokenToJson(Login2Token instance) =>
    <String, dynamic>{
      'token': instance.token,
    };

ClassInfo _$ClassInfoFromJson(Map<String, dynamic> json) => ClassInfo(
      name: json['name'] as String,
      teacher: json['teacher'] as String,
      comment: json['comment'] as String,
      count: json['count'] as int,
      age: json['age'] as String,
      id: json['id'] as int,
      year: json['year'] as int,
      tid: json['tid'] as int,
    );

Map<String, dynamic> _$ClassInfoToJson(ClassInfo instance) => <String, dynamic>{
      'id': instance.id,
      'age': instance.age,
      'name': instance.name,
      'teacher': instance.teacher,
      'count': instance.count,
      'comment': instance.comment,
      'year': instance.year,
      'tid': instance.tid,
    };

CreateClass _$CreateClassFromJson(Map<String, dynamic> json) => CreateClass(
      createList: (json['createList'] as List<dynamic>)
          .map((e) => e as Map<String, dynamic>)
          .toList(),
    );

Map<String, dynamic> _$CreateClassToJson(CreateClass instance) =>
    <String, dynamic>{
      'createList': instance.createList,
    };

CorrectionClass _$CorrectionClassFromJson(Map<String, dynamic> json) =>
    CorrectionClass(
      correctionList: (json['correctionList'] as List<dynamic>)
          .map((e) => e as Map<String, dynamic>)
          .toList(),
    );

Map<String, dynamic> _$CorrectionClassToJson(CorrectionClass instance) =>
    <String, dynamic>{
      'correctionList': instance.correctionList,
    };

DeleteTeacher _$DeleteTeacherFromJson(Map<String, dynamic> json) =>
    DeleteTeacher(
      deleteList:
          (json['deleteList'] as List<dynamic>).map((e) => e as int).toList(),
    );

Map<String, dynamic> _$DeleteTeacherToJson(DeleteTeacher instance) =>
    <String, dynamic>{
      'deleteList': instance.deleteList,
    };

DeleteClass _$DeleteClassFromJson(Map<String, dynamic> json) => DeleteClass(
      deleteList:
          (json['deleteList'] as List<dynamic>).map((e) => e as int).toList(),
    );

Map<String, dynamic> _$DeleteClassToJson(DeleteClass instance) =>
    <String, dynamic>{
      'deleteList': instance.deleteList,
    };

TeacherInfo _$TeacherInfoFromJson(Map<String, dynamic> json) => TeacherInfo(
      id: json['id'] as int,
      name: json['name'] as String,
      phoneNumber: json['phoneNumber'] as String,
      email: json['email'] as String,
      className: json['className'] as String,
    );

Map<String, dynamic> _$TeacherInfoToJson(TeacherInfo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'className': instance.className,
      'phoneNumber': instance.phoneNumber,
      'email': instance.email,
    };

ApplyTeacherList _$ApplyTeacherListFromJson(Map<String, dynamic> json) =>
    ApplyTeacherList(
      email: json['email'] as String,
      name: json['name'] as String,
      id: json['id'] as int,
      phoneNumber: json['phoneNumber'] as String,
    );

Map<String, dynamic> _$ApplyTeacherListToJson(ApplyTeacherList instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'name': instance.name,
      'phoneNumber': instance.phoneNumber,
    };

Identification _$IdentificationFromJson(Map<String, dynamic> json) =>
    Identification(
      id: json['id'] as int,
    );

Map<String, dynamic> _$IdentificationToJson(Identification instance) =>
    <String, dynamic>{
      'id': instance.id,
    };

CreateChild _$CreateChildFromJson(Map<String, dynamic> json) => CreateChild(
      id: json['id'] as int,
      name: json['name'] as String,
      parentName: json['parentName'] as String,
      parentPhoneNumber: json['parentPhoneNumber'] as String,
      comment: json['comment'] as String,
      imageName: json['imageName'] as String,
      sex: json['sex'] as bool,
      birthday: json['birthday'] as String,
    );

Map<String, dynamic> _$CreateChildToJson(CreateChild instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'birthday': instance.birthday,
      'sex': instance.sex,
      'imageName': instance.imageName,
      'comment': instance.comment,
      'parentName': instance.parentName,
      'parentPhoneNumber': instance.parentPhoneNumber,
    };

ChildInfo _$ChildInfoFromJson(Map<String, dynamic> json) => ChildInfo(
      id: json['id'] as int,
      name: json['name'] as String,
      parentName: json['parentName'] as String,
      parentPhoneNumber: json['parentPhoneNumber'] as String,
      comment: json['comment'] as String,
      imagePath: json['imagePath'] as String,
      sex: json['sex'] as bool,
      birthday: json['birthday'] as String,
      relation: json['relation'] as String,
      className: json['className'] as String,
    );

Map<String, dynamic> _$ChildInfoToJson(ChildInfo instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'birthday': instance.birthday,
      'sex': instance.sex,
      'comment': instance.comment,
      'imagePath': instance.imagePath,
      'className': instance.className,
      'parentName': instance.parentName,
      'parentPhoneNumber': instance.parentPhoneNumber,
      'relation': instance.relation,
    };

PostChildDelete _$PostChildDeleteFromJson(Map<String, dynamic> json) =>
    PostChildDelete(
      deleteList:
          (json['deleteList'] as List<dynamic>).map((e) => e as int).toList(),
    );

Map<String, dynamic> _$PostChildDeleteToJson(PostChildDelete instance) =>
    <String, dynamic>{
      'deleteList': instance.deleteList,
    };

KindergartenData _$KindergartenDataFromJson(Map<String, dynamic> json) =>
    KindergartenData(
      name: json['name'] as String,
      phoneNumber: json['phoneNumber'] as String,
      address: json['address'] as String,
      director: json['director'] as String,
      directorPhoneNumber: json['directorPhoneNumber'] as String,
    );

Map<String, dynamic> _$KindergartenDataToJson(KindergartenData instance) =>
    <String, dynamic>{
      'name': instance.name,
      'address': instance.address,
      'phoneNumber': instance.phoneNumber,
      'director': instance.director,
      'directorPhoneNumber': instance.directorPhoneNumber,
    };

PostContact _$PostContactFromJson(Map<String, dynamic> json) => PostContact(
      subject: json['subject'] as String,
      content: json['content'] as String,
    );

Map<String, dynamic> _$PostContactToJson(PostContact instance) =>
    <String, dynamic>{
      'subject': instance.subject,
      'content': instance.content,
    };

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps,no_leading_underscores_for_local_identifiers

class _RestAdminClient implements RestAdminClient {
  _RestAdminClient(
    this._dio, {
    this.baseUrl,
  });

  final Dio _dio;

  String? baseUrl;

  @override
  Future<Login2Token> postPwdCheck(
    token,
    pwdCheckForm,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{r'authorization': token};
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    _data.addAll(pwdCheckForm.toJson());
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<Login2Token>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/api/local/check',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = Login2Token.fromJson(_result.data!);
    return value;
  }

  @override
  Future<dynamic> getAdminInfo(token) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{r'authorization': token};
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch(_setStreamType<dynamic>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/api/local',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = _result.data;
    return value;
  }

  @override
  Future<dynamic> getChildImage(
    token,
    imageName,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{r'authorization': token};
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch(_setStreamType<dynamic>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '${imageName}',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = _result.data;
    return value;
  }

  @override
  Future<dynamic> putChildInfo(
    token2,
    formData,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{r'authorization': token2};
    _headers.removeWhere((k, v) => v == null);
    final _data = formData;
    final _result = await _dio.fetch(_setStreamType<dynamic>(Options(
      method: 'PUT',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/api/child',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = _result.data;
    return value;
  }

  @override
  Future<dynamic> putAdminInfo(
    token2,
    formData,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{r'authorization': token2};
    _headers.removeWhere((k, v) => v == null);
    final _data = formData;
    final _result = await _dio.fetch(_setStreamType<dynamic>(Options(
      method: 'PATCH',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/api/local',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = _result.data;
    return value;
  }

  @override
  Future<dynamic> postChildInfo(
    token2,
    formData,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{r'authorization': token2};
    _headers.removeWhere((k, v) => v == null);
    final _data = formData;
    final _result = await _dio.fetch(_setStreamType<dynamic>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/api/admin/child/bulkcreate',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = _result.data;
    return value;
  }

  @override
  Future<dynamic> postAdminCheck(
    token,
    adminCheck,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{r'authorization': token};
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    _data.addAll(adminCheck.toJson());
    final _result = await _dio.fetch(_setStreamType<dynamic>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/api/local/withdrawCheck',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = _result.data;
    return value;
  }

  @override
  Future<dynamic> postAdminWithdraw(
    token,
    adminCheck,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{r'authorization': token};
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    _data.addAll(adminCheck.toJson());
    final _result = await _dio.fetch(_setStreamType<dynamic>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/api/admin/withdraw',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = _result.data;
    return value;
  }

  @override
  Future<List<ClassInfo>> getAdminClassInfo(
    token,
    year,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{r'authorization': token};
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result =
        await _dio.fetch<List<dynamic>>(_setStreamType<List<ClassInfo>>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/api/class/${year}',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    var value = _result.data!
        .map((dynamic i) => ClassInfo.fromJson(i as Map<String, dynamic>))
        .toList();
    return value;
  }

  @override
  Future<dynamic> postAdminCreateClass(
    token,
    createClass,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{r'authorization': token};
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    _data.addAll(createClass.toJson());
    final _result = await _dio.fetch(_setStreamType<dynamic>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/api/class',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = _result.data;
    return value;
  }

  @override
  Future<dynamic> putAdminCorrectionClass(
    token,
    correctionClass,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{r'authorization': token};
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    _data.addAll(correctionClass.toJson());
    final _result = await _dio.fetch(_setStreamType<dynamic>(Options(
      method: 'PUT',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/api/class',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = _result.data;
    return value;
  }

  @override
  Future<dynamic> postAdminDeleteClass(
    token,
    deleteClass,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{r'authorization': token};
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    _data.addAll(deleteClass.toJson());
    final _result = await _dio.fetch(_setStreamType<dynamic>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/api/class/delete',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = _result.data;
    return value;
  }

  @override
  Future<List<TeacherInfo>> getTeacherList(token) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{r'authorization': token};
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio
        .fetch<List<dynamic>>(_setStreamType<List<TeacherInfo>>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/api/teacher',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    var value = _result.data!
        .map((dynamic i) => TeacherInfo.fromJson(i as Map<String, dynamic>))
        .toList();
    return value;
  }

  @override
  Future<List<ApplyTeacherList>> getApplyList(token) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{r'authorization': token};
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio
        .fetch<List<dynamic>>(_setStreamType<List<ApplyTeacherList>>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/api/apply',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    var value = _result.data!
        .map(
            (dynamic i) => ApplyTeacherList.fromJson(i as Map<String, dynamic>))
        .toList();
    return value;
  }

  @override
  Future<dynamic> postTeacher(
    token,
    identification,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{r'authorization': token};
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    _data.addAll(identification.toJson());
    final _result = await _dio.fetch(_setStreamType<dynamic>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/api/teacher',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = _result.data;
    return value;
  }

  @override
  Future<dynamic> deleteTeacher(
    token,
    id,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{r'authorization': token};
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch(_setStreamType<dynamic>(Options(
      method: 'DELETE',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/api/apply/${id}',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = _result.data;
    return value;
  }

  @override
  Future<dynamic> putTeacher(
    token,
    deleteTeacher,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{r'authorization': token};
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    _data.addAll(deleteTeacher.toJson());
    final _result = await _dio.fetch(_setStreamType<dynamic>(Options(
      method: 'PUT',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/api/teacher',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = _result.data;
    return value;
  }

  @override
  Future<dynamic> postChild(
    token,
    formData,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{r'authorization': token};
    _headers.removeWhere((k, v) => v == null);
    final _data = formData;
    final _result = await _dio.fetch(_setStreamType<dynamic>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/api/child',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = _result.data;
    return value;
  }

  @override
  Future<List<ChildInfo>> getChildInfo(
    token,
    year,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{r'authorization': token};
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result =
        await _dio.fetch<List<dynamic>>(_setStreamType<List<ChildInfo>>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/api/child/${year}',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    var value = _result.data!
        .map((dynamic i) => ChildInfo.fromJson(i as Map<String, dynamic>))
        .toList();
    return value;
  }

  @override
  Future<dynamic> postChildDelete(
    token,
    postChildDelete,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{r'authorization': token};
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    _data.addAll(postChildDelete.toJson());
    final _result = await _dio.fetch(_setStreamType<dynamic>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/api/child/delete',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = _result.data;
    return value;
  }

  @override
  Future<KindergartenData> getKindergarten(token) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{r'authorization': token};
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<KindergartenData>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/api/kindergarten',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = KindergartenData.fromJson(_result.data!);
    return value;
  }

  @override
  Future<dynamic> postContact(
    token,
    postContact,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{r'authorization': token};
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    _data.addAll(postContact.toJson());
    final _result = await _dio.fetch(_setStreamType<dynamic>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/api/local/contact',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = _result.data;
    return value;
  }

  RequestOptions _setStreamType<T>(RequestOptions requestOptions) {
    if (T != dynamic &&
        !(requestOptions.responseType == ResponseType.bytes ||
            requestOptions.responseType == ResponseType.stream)) {
      if (T == String) {
        requestOptions.responseType = ResponseType.plain;
      } else {
        requestOptions.responseType = ResponseType.json;
      }
    }
    return requestOptions;
  }
}
