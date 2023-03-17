// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostAttendanceData _$PostAttendanceDataFromJson(Map<String, dynamic> json) =>
    PostAttendanceData(
      type: json['type'] as String,
      value: json['value'] as String,
      id: json['id'] as int,
      date: json['date'] as String,
      cid: json['cid'] as int,
    );

Map<String, dynamic> _$PostAttendanceDataToJson(PostAttendanceData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'date': instance.date,
      'type': instance.type,
      'value': instance.value,
      'cid': instance.cid,
    };

GetAttendanceData _$GetAttendanceDataFromJson(Map<String, dynamic> json) =>
    GetAttendanceData(
      id: json['id'] as int,
      name: json['name'] as String,
      enteringImagePath: json['enteringImagePath'] as String,
      enteringTime: json['enteringTime'] as String,
      estimatedQuittingTime: json['estimatedQuittingTime'] as String,
      isAttendanced: json['isAttendanced'] as bool,
      quittingTime: json['quittingTime'] as String,
    );

Map<String, dynamic> _$GetAttendanceDataToJson(GetAttendanceData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'enteringImagePath': instance.enteringImagePath,
      'enteringTime': instance.enteringTime,
      'quittingTime': instance.quittingTime,
      'isAttendanced': instance.isAttendanced,
      'estimatedQuittingTime': instance.estimatedQuittingTime,
    };

GetTemperatureData _$GetTemperatureDataFromJson(Map<String, dynamic> json) =>
    GetTemperatureData(
      id: json['id'] as int,
      name: json['name'] as String,
      afternoon: (json['afternoon'] as num).toDouble(),
      isReported: json['isReported'] as bool,
      morning: (json['morning'] as num).toDouble(),
      isSickedMorning: json['isSickedMorning'] as bool,
      isSickedAfternoon: json['isSickedAfternoon'] as bool,
    );

Map<String, dynamic> _$GetTemperatureDataToJson(GetTemperatureData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'morning': instance.morning,
      'isSickedMorning': instance.isSickedMorning,
      'afternoon': instance.afternoon,
      'isReported': instance.isReported,
      'isSickedAfternoon': instance.isSickedAfternoon,
    };

PostTemperatureData _$PostTemperatureDataFromJson(Map<String, dynamic> json) =>
    PostTemperatureData(
      type: json['type'] as String,
      value: (json['value'] as num).toDouble(),
      id: json['id'] as int,
      date: json['date'] as String,
      cid: json['cid'] as int,
    );

Map<String, dynamic> _$PostTemperatureDataToJson(
        PostTemperatureData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'date': instance.date,
      'type': instance.type,
      'value': instance.value,
      'cid': instance.cid,
    };

GetEmotionData _$GetEmotionDataFromJson(Map<String, dynamic> json) =>
    GetEmotionData(
      id: json['id'] as int,
      name: json['name'] as String,
      enteringEmotion: json['enteringEmotion'] as String,
      quittingEmotion: json['quittingEmotion'] as String,
      enteringEmotions: (json['enteringEmotions'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      quittingEmotions: (json['quittingEmotions'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      isContacted: json['isContacted'] as bool,
      comment: json['comment'] as String,
      sex: json['sex'] as bool,
    );

Map<String, dynamic> _$GetEmotionDataToJson(GetEmotionData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'enteringEmotion': instance.enteringEmotion,
      'quittingEmotion': instance.quittingEmotion,
      'enteringEmotions': instance.enteringEmotions,
      'quittingEmotions': instance.quittingEmotions,
      'comment': instance.comment,
      'isContacted': instance.isContacted,
      'sex': instance.sex,
    };

PostEmotionData _$PostEmotionDataFromJson(Map<String, dynamic> json) =>
    PostEmotionData(
      type: json['type'] as String,
      value: json['value'] as String,
      id: json['id'] as int,
      date: json['date'] as String,
      cid: json['cid'] as int,
    );

Map<String, dynamic> _$PostEmotionDataToJson(PostEmotionData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'date': instance.date,
      'type': instance.type,
      'value': instance.value,
      'cid': instance.cid,
    };

GetMealData _$GetMealDataFromJson(Map<String, dynamic> json) => GetMealData(
      id: json['id'] as int,
      name: json['name'] as String,
      graph: (json['graph'] as List<dynamic>)
          .map((e) => (e as num).toDouble())
          .toList(),
      value: (json['value'] as num).toDouble(),
    );

Map<String, dynamic> _$GetMealDataToJson(GetMealData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'graph': instance.graph,
      'value': instance.value,
    };

PostMealData _$PostMealDataFromJson(Map<String, dynamic> json) => PostMealData(
      value: (json['value'] as num).toDouble(),
      id: json['id'] as int,
      date: json['date'] as String,
      cid: json['cid'] as int,
    );

Map<String, dynamic> _$PostMealDataToJson(PostMealData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'date': instance.date,
      'value': instance.value,
      'cid': instance.cid,
    };

GetNapData _$GetNapDataFromJson(Map<String, dynamic> json) => GetNapData(
      id: json['id'] as int,
      name: json['name'] as String,
      graph: (json['graph'] as List<dynamic>)
          .map((e) => (e as num).toDouble())
          .toList(),
      value: (json['value'] as num).toDouble(),
    );

Map<String, dynamic> _$GetNapDataToJson(GetNapData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'graph': instance.graph,
      'value': instance.value,
    };

PostNapData _$PostNapDataFromJson(Map<String, dynamic> json) => PostNapData(
      value: (json['value'] as num).toDouble(),
      id: json['id'] as int,
      date: json['date'] as String,
      cid: json['cid'] as int,
    );

Map<String, dynamic> _$PostNapDataToJson(PostNapData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'date': instance.date,
      'value': instance.value,
      'cid': instance.cid,
    };

GetDefecationAndVomitData _$GetDefecationAndVomitDataFromJson(
        Map<String, dynamic> json) =>
    GetDefecationAndVomitData(
      id: json['id'] as int,
      name: json['name'] as String,
      defecation: json['defecation'] as int,
      defecationTotal: json['defecationTotal'] as int,
      vomit: json['vomit'] as int,
      vomitTotal: json['vomitTotal'] as int,
    );

Map<String, dynamic> _$GetDefecationAndVomitDataToJson(
        GetDefecationAndVomitData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'defecation': instance.defecation,
      'defecationTotal': instance.defecationTotal,
      'vomit': instance.vomit,
      'vomitTotal': instance.vomitTotal,
    };

PostDefecationAndVomitData _$PostDefecationAndVomitDataFromJson(
        Map<String, dynamic> json) =>
    PostDefecationAndVomitData(
      value: (json['value'] as num).toDouble(),
      id: json['id'] as int,
      date: json['date'] as String,
      type: json['type'] as String,
      cid: json['cid'] as int,
    );

Map<String, dynamic> _$PostDefecationAndVomitDataToJson(
        PostDefecationAndVomitData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'date': instance.date,
      'value': instance.value,
      'type': instance.type,
      'cid': instance.cid,
    };

GetAccident _$GetAccidentFromJson(Map<String, dynamic> json) => GetAccident(
      name: json['name'] as String,
      date: json['date'] as String,
      id: json['id'] as int,
      sex: json['sex'] as bool,
      accidentType: json['accidentType'] as String,
      aid: json['aid'] as int,
      cause: json['cause'] as String,
      contactTime: json['contactTime'] as String,
      hospitalAction: json['hospitalAction'] as String,
      isAmbulanced: json['isAmbulanced'],
      isInsuranced: json['isInsuranced'],
      medicalFee: json['medicalFee'],
      place: json['place'] as String,
      situation: json['situation'] as String,
      teacherAction: json['teacherAction'] as String,
      time: json['time'] as String,
    );

Map<String, dynamic> _$GetAccidentToJson(GetAccident instance) =>
    <String, dynamic>{
      'aid': instance.aid,
      'id': instance.id,
      'name': instance.name,
      'sex': instance.sex,
      'date': instance.date,
      'time': instance.time,
      'teacherAction': instance.teacherAction,
      'hospitalAction': instance.hospitalAction,
      'medicalFee': instance.medicalFee,
      'isInsuranced': instance.isInsuranced,
      'isAmbulanced': instance.isAmbulanced,
      'contactTime': instance.contactTime,
      'place': instance.place,
      'situation': instance.situation,
      'cause': instance.cause,
      'accidentType': instance.accidentType,
    };

PostAccidentData _$PostAccidentDataFromJson(Map<String, dynamic> json) =>
    PostAccidentData(
      id: json['id'] as int,
      cid: json['cid'] as int,
    );

Map<String, dynamic> _$PostAccidentDataToJson(PostAccidentData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'cid': instance.cid,
    };

PutAccidentData _$PutAccidentDataFromJson(Map<String, dynamic> json) =>
    PutAccidentData(
      value: json['value'] as String,
      aid: json['aid'] as int,
      type: json['type'] as String,
    );

Map<String, dynamic> _$PutAccidentDataToJson(PutAccidentData instance) =>
    <String, dynamic>{
      'aid': instance.aid,
      'type': instance.type,
      'value': instance.value,
    };

GetBodyProfile _$GetBodyProfileFromJson(Map<String, dynamic> json) =>
    GetBodyProfile(
      name: json['name'] as String,
      id: json['id'] as int,
      height: json['height'],
      weight: json['weight'],
    );

Map<String, dynamic> _$GetBodyProfileToJson(GetBodyProfile instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'height': instance.height,
      'weight': instance.weight,
    };

PostBodyProfileData _$PostBodyProfileDataFromJson(Map<String, dynamic> json) =>
    PostBodyProfileData(
      date: json['date'] as String,
      id: json['id'] as int,
      type: json['type'] as String,
      value: (json['value'] as num).toDouble(),
      cid: json['cid'] as int,
    );

Map<String, dynamic> _$PostBodyProfileDataToJson(
        PostBodyProfileData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'cid': instance.cid,
      'date': instance.date,
      'type': instance.type,
      'value': instance.value,
    };

GetMedicineData _$GetMedicineDataFromJson(Map<String, dynamic> json) =>
    GetMedicineData(
      type: json['type'] as String,
      id: json['id'] as int,
      name: json['name'] as String,
      comment: json['comment'] as String,
      time: json['time'] as String,
      count: json['count'] as String,
      amount: json['amount'] as String,
      parentSign: json['parentSign'] as String,
      storageMethod: json['storageMethod'] as String,
      symptom: json['symptom'] as String,
      teacherSign: json['teacherSign'] as String,
    );

Map<String, dynamic> _$GetMedicineDataToJson(GetMedicineData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'symptom': instance.symptom,
      'type': instance.type,
      'amount': instance.amount,
      'count': instance.count,
      'time': instance.time,
      'storageMethod': instance.storageMethod,
      'comment': instance.comment,
      'parentSign': instance.parentSign,
      'teacherSign': instance.teacherSign,
    };

GetMonthlyReportData _$GetMonthlyReportDataFromJson(
        Map<String, dynamic> json) =>
    GetMonthlyReportData(
      id: json['id'] as int,
      name: json['name'] as String,
      sex: json['sex'] as bool,
      weight: (json['weight'] as List<dynamic>)
          .map((e) => (e as num).toDouble())
          .toList(),
      height: (json['height'] as List<dynamic>)
          .map((e) => (e as num).toDouble())
          .toList(),
      temperature: json['temperature'] as int,
      enteringEmotion: (json['enteringEmotion'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      quittingEmotion: (json['quittingEmotion'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      isReported: json['isReported'] as bool,
      quittingTime: (json['quittingTime'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      enteringTime: (json['enteringTime'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      imagePath: json['imagePath'] as String,
      accident: (json['accident'] as List<dynamic>)
          .map((e) => (e as num).toDouble())
          .toList(),
      attendance:
          (json['attendance'] as List<dynamic>).map((e) => e as int).toList(),
      defecationAndVomit: (json['defecationAndVomit'] as List<dynamic>)
          .map((e) => (e as num).toDouble())
          .toList(),
      meal: (json['meal'] as List<dynamic>)
          .map((e) => (e as num).toDouble())
          .toList(),
      medicine: (json['medicine'] as List<dynamic>)
          .map((e) => (e as num).toDouble())
          .toList(),
      nap: (json['nap'] as List<dynamic>)
          .map((e) => (e as num).toDouble())
          .toList(),
      comment: json['comment'] as String,
      autoCreatedComment: json['autoCreatedComment'] as String,
    );

Map<String, dynamic> _$GetMonthlyReportDataToJson(
        GetMonthlyReportData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'sex': instance.sex,
      'imagePath': instance.imagePath,
      'isReported': instance.isReported,
      'attendance': instance.attendance,
      'enteringTime': instance.enteringTime,
      'quittingTime': instance.quittingTime,
      'temperature': instance.temperature,
      'height': instance.height,
      'weight': instance.weight,
      'enteringEmotion': instance.enteringEmotion,
      'quittingEmotion': instance.quittingEmotion,
      'meal': instance.meal,
      'nap': instance.nap,
      'defecationAndVomit': instance.defecationAndVomit,
      'medicine': instance.medicine,
      'accident': instance.accident,
      'autoCreatedComment': instance.autoCreatedComment,
      'comment': instance.comment,
    };

PostMonthlyReport _$PostMonthlyReportFromJson(Map<String, dynamic> json) =>
    PostMonthlyReport(
      value: json['value'] as String,
      id: json['id'] as int,
      type: json['type'] as String,
      date: json['date'] as String,
      cid: json['cid'] as int,
    );

Map<String, dynamic> _$PostMonthlyReportToJson(PostMonthlyReport instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'value': instance.value,
      'date': instance.date,
      'cid': instance.cid,
    };

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps,no_leading_underscores_for_local_identifiers

class _RestActivityClient implements RestActivityClient {
  _RestActivityClient(
    this._dio, {
    this.baseUrl,
  });

  final Dio _dio;

  String? baseUrl;

  @override
  Future<dynamic> postAttendance(
    token,
    postAttendanceData,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{r'authorization': token};
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    _data.addAll(postAttendanceData.toJson());
    final _result = await _dio.fetch(_setStreamType<dynamic>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/api/activity/attendance',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = _result.data;
    return value;
  }

  @override
  Future<dynamic> postAttendanceImage(
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
          '/api/activity/attendance/image',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = _result.data;
    return value;
  }

  @override
  Future<List<GetAttendanceData>> getAttendance(
    token,
    classId,
    date,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{r'authorization': token};
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio
        .fetch<List<dynamic>>(_setStreamType<List<GetAttendanceData>>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/api/activity/attendance/${classId}/${date}',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    var value = _result.data!
        .map((dynamic i) =>
            GetAttendanceData.fromJson(i as Map<String, dynamic>))
        .toList();
    return value;
  }

  @override
  Future<List<GetTemperatureData>> getTemperature(
    token,
    classId,
    date,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{r'authorization': token};
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio
        .fetch<List<dynamic>>(_setStreamType<List<GetTemperatureData>>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/api/activity/temperature/${classId}/${date}',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    var value = _result.data!
        .map((dynamic i) =>
            GetTemperatureData.fromJson(i as Map<String, dynamic>))
        .toList();
    return value;
  }

  @override
  Future<dynamic> postTemperature(
    token,
    postTemperatureData,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{r'authorization': token};
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    _data.addAll(postTemperatureData.toJson());
    final _result = await _dio.fetch(_setStreamType<dynamic>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/api/activity/temperature',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = _result.data;
    return value;
  }

  @override
  Future<List<GetEmotionData>> getEmotion(
    token,
    classId,
    date,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{r'authorization': token};
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio
        .fetch<List<dynamic>>(_setStreamType<List<GetEmotionData>>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/api/activity/emotion/${classId}/${date}',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    var value = _result.data!
        .map((dynamic i) => GetEmotionData.fromJson(i as Map<String, dynamic>))
        .toList();
    return value;
  }

  @override
  Future<dynamic> postEmotion(
    token,
    postEmotionData,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{r'authorization': token};
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    _data.addAll(postEmotionData.toJson());
    final _result = await _dio.fetch(_setStreamType<dynamic>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/api/activity/emotion',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = _result.data;
    return value;
  }

  @override
  Future<List<GetMealData>> getMeal(
    token,
    classId,
    date,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{r'authorization': token};
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio
        .fetch<List<dynamic>>(_setStreamType<List<GetMealData>>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/api/activity/meal/${classId}/${date}',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    var value = _result.data!
        .map((dynamic i) => GetMealData.fromJson(i as Map<String, dynamic>))
        .toList();
    return value;
  }

  @override
  Future<dynamic> postMeal(
    token,
    postMealData,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{r'authorization': token};
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    _data.addAll(postMealData.toJson());
    final _result = await _dio.fetch(_setStreamType<dynamic>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/api/activity/meal',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = _result.data;
    return value;
  }

  @override
  Future<List<GetNapData>> getNap(
    token,
    classId,
    date,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{r'authorization': token};
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio
        .fetch<List<dynamic>>(_setStreamType<List<GetNapData>>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/api/activity/nap/${classId}/${date}',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    var value = _result.data!
        .map((dynamic i) => GetNapData.fromJson(i as Map<String, dynamic>))
        .toList();
    return value;
  }

  @override
  Future<dynamic> postNap(
    token,
    postNapData,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{r'authorization': token};
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    _data.addAll(postNapData.toJson());
    final _result = await _dio.fetch(_setStreamType<dynamic>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/api/activity/nap',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = _result.data;
    return value;
  }

  @override
  Future<List<GetDefecationAndVomitData>> getDefecationAndVomit(
    token,
    classId,
    date,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{r'authorization': token};
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<List<dynamic>>(
        _setStreamType<List<GetDefecationAndVomitData>>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/api/activity/defecationAndVomit/${classId}/${date}',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    var value = _result.data!
        .map((dynamic i) =>
            GetDefecationAndVomitData.fromJson(i as Map<String, dynamic>))
        .toList();
    return value;
  }

  @override
  Future<dynamic> postDefecationAndVomit(
    token,
    postDefecationAndVomitData,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{r'authorization': token};
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    _data.addAll(postDefecationAndVomitData.toJson());
    final _result = await _dio.fetch(_setStreamType<dynamic>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/api/activity/defecationAndVomit',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = _result.data;
    return value;
  }

  @override
  Future<List<GetAccident>> getAccident(
    token,
    classId,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{r'authorization': token};
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio
        .fetch<List<dynamic>>(_setStreamType<List<GetAccident>>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/api/activity/accident/${classId}',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    var value = _result.data!
        .map((dynamic i) => GetAccident.fromJson(i as Map<String, dynamic>))
        .toList();
    return value;
  }

  @override
  Future<dynamic> postAccident(
    token,
    postAccidentData,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{r'authorization': token};
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    _data.addAll(postAccidentData.toJson());
    final _result = await _dio.fetch(_setStreamType<dynamic>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/api/activity/accident',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = _result.data;
    return value;
  }

  @override
  Future<dynamic> putAccident(
    token,
    putAccidentData,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{r'authorization': token};
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    _data.addAll(putAccidentData.toJson());
    final _result = await _dio.fetch(_setStreamType<dynamic>(Options(
      method: 'PUT',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/api/activity/accident',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = _result.data;
    return value;
  }

  @override
  Future<dynamic> deleteAccident(
    token,
    accidentId,
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
          '/api/activity/accident/${accidentId}',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = _result.data;
    return value;
  }

  @override
  Future<List<GetBodyProfile>> getBodyProfile(
    token,
    classId,
    date,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{r'authorization': token};
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio
        .fetch<List<dynamic>>(_setStreamType<List<GetBodyProfile>>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/api/activity/heightAndWeight/${classId}/${date}',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    var value = _result.data!
        .map((dynamic i) => GetBodyProfile.fromJson(i as Map<String, dynamic>))
        .toList();
    return value;
  }

  @override
  Future<dynamic> postBodyProfile(
    token,
    postBodyProfileData,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{r'authorization': token};
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    _data.addAll(postBodyProfileData.toJson());
    final _result = await _dio.fetch(_setStreamType<dynamic>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/api/activity/heightAndWeight',
          queryParameters: queryParameters,
          data: _data,
        )
        .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = _result.data;
    return value;
  }

  @override
  Future<List<GetMedicineData>> getMedicine(
    token,
    classId,
    date,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{r'authorization': token};
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio
        .fetch<List<dynamic>>(_setStreamType<List<GetMedicineData>>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/api/activity/medicine/${classId}/${date}',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    var value = _result.data!
        .map((dynamic i) => GetMedicineData.fromJson(i as Map<String, dynamic>))
        .toList();
    return value;
  }

  @override
  Future<List<GetMonthlyReportData>> getMonthlyReport(
    token,
    classId,
    date,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{r'authorization': token};
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<List<dynamic>>(
        _setStreamType<List<GetMonthlyReportData>>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/api/activity/monthlyReport/${classId}/${date}',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    var value = _result.data!
        .map((dynamic i) =>
            GetMonthlyReportData.fromJson(i as Map<String, dynamic>))
        .toList();
    return value;
  }

  @override
  Future<dynamic> postMonthlyReport(
    token,
    postMonthlyReport,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{r'authorization': token};
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    _data.addAll(postMonthlyReport.toJson());
    final _result = await _dio.fetch(_setStreamType<dynamic>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
        .compose(
          _dio.options,
          '/api/activity/monthlyReport',
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
