import 'package:json_annotation/json_annotation.dart';
import 'package:retrofit/retrofit.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:dio/dio.dart';

part 'activity.g.dart';

@RestApi()
abstract class RestActivityClient{
  factory RestActivityClient({required Dio dio}) => _RestActivityClient(dio);

  @POST('/api/activity/attendance')
  Future<dynamic> postAttendance(
      @Header('authorization') String token,
      @Body() PostAttendanceData postAttendanceData,
      );

  @POST('/api/activity/attendance/image')
  Future<dynamic> postAttendanceImage(
      @Header('authorization') String token,
      @Body() FormData formData,
      );

  @GET('/api/activity/attendance/{classId}/{YYYYMMDD}')
  Future<List<GetAttendanceData>> getAttendance(
      @Header('authorization') String token,
      @Path('classId') int classId,
      @Path('YYYYMMDD') String date,
      );

  @GET('/api/activity/temperature/{classId}/{YYYYMMDD}')
  Future<List<GetTemperatureData>> getTemperature(
      @Header('authorization') String token,
      @Path('classId') int classId,
      @Path('YYYYMMDD') String date,
      );

  @POST('/api/activity/temperature')
  Future<dynamic> postTemperature(
      @Header('authorization') String token,
      @Body() PostTemperatureData postTemperatureData,
      );

  @GET('/api/activity/emotion/{classId}/{YYYYMMDD}')
  Future<List<GetEmotionData>> getEmotion(
      @Header('authorization') String token,
      @Path('classId') int classId,
      @Path('YYYYMMDD') String date,
      );

  @POST('/api/activity/emotion')
  Future<dynamic> postEmotion(
      @Header('authorization') String token,
      @Body() PostEmotionData postEmotionData,
      );

  @GET('/api/activity/meal/{classId}/{YYYYMMDD}')
  Future<List<GetMealData>> getMeal(
      @Header('authorization') String token,
      @Path('classId') int classId,
      @Path('YYYYMMDD') String date,
      );

  @POST('/api/activity/meal')
  Future<dynamic> postMeal(
      @Header('authorization') String token,
      @Body() PostMealData postMealData,
      );

  @GET('/api/activity/nap/{classId}/{YYYYMMDD}')
  Future<List<GetNapData>> getNap(
      @Header('authorization') String token,
      @Path('classId') int classId,
      @Path('YYYYMMDD') String date,
      );

  @POST('/api/activity/nap')
  Future<dynamic> postNap(
      @Header('authorization') String token,
      @Body() PostNapData postNapData,
      );

  @GET('/api/activity/defecationAndVomit/{classId}/{YYYYMMDD}')
  Future<List<GetDefecationAndVomitData>> getDefecationAndVomit(
      @Header('authorization') String token,
      @Path('classId') int classId,
      @Path('YYYYMMDD') String date,
      );

  @POST('/api/activity/defecationAndVomit')
  Future<dynamic> postDefecationAndVomit(
      @Header('authorization') String token,
      @Body() PostDefecationAndVomitData postDefecationAndVomitData,
      );

  @GET('/api/activity/accident/{classId}')
  Future<List<GetAccident>> getAccident(
      @Header('authorization') String token,
      @Path('classId') int classId,
      );

  @POST('/api/activity/accident')
  Future<dynamic> postAccident(
      @Header('authorization') String token,
      @Body() PostAccidentData postAccidentData,
      );
  @PUT('/api/activity/accident')
  Future<dynamic> putAccident(
      @Header('authorization') String token,
      @Body() PutAccidentData putAccidentData,
      );
  @DELETE('/api/activity/accident/{accidentId}')
  Future<dynamic> deleteAccident(
      @Header('authorization') String token,
      @Path('accidentId') int accidentId,
      );

  @GET('/api/activity/heightAndWeight/{classId}/{YYYYMMDD}')
  Future<List<GetBodyProfile>> getBodyProfile(
      @Header('authorization') String token,
      @Path('classId') int classId,
      @Path('YYYYMMDD') String date,
      );

  @POST('/api/activity/heightAndWeight')
  Future<dynamic> postBodyProfile(
      @Header('authorization') String token,
      @Body() PostBodyProfileData postBodyProfileData,
      );

  @GET('/api/activity/medicine/{classId}/{YYYYMMDD}')
  Future<List<GetMedicineData>> getMedicine(
      @Header('authorization') String token,
      @Path('classId') int classId,
      @Path('YYYYMMDD') String date,
      );

  @GET('/api/activity/monthlyReport/{classId}/{YYYYMMDD}')
  Future<List<GetMonthlyReportData>> getMonthlyReport(
      @Header('authorization') String token,
      @Path('classId') int classId,
      @Path('YYYYMMDD') String date,
      );

  @POST('/api/activity/monthlyReport')
  Future<dynamic> postMonthlyReport(
      @Header('authorization') String token,
      @Body() PostMonthlyReport postMonthlyReport,
      );

}
final String apiDomain = dotenv.get('BASE_URL', fallback: '');
final restActivityClient = RestActivityClient(dio: Dio(BaseOptions(baseUrl: apiDomain)));

@JsonSerializable()
class PostAttendanceData{
  int id;
  String date;
  String type;
  String value;
  int cid;
  PostAttendanceData({
    required this.type,
    required this.value,
    required this.id,
    required this.date,
    required this.cid,
});
  factory PostAttendanceData.fromJson(Map<String, dynamic> json) => _$PostAttendanceDataFromJson(json);
  Map<String, dynamic> toJson() => _$PostAttendanceDataToJson(this);
}

@JsonSerializable()
class GetAttendanceData{
  int id;
  String name;
  String enteringImagePath;
  String enteringTime;
  String quittingTime;
  bool isAttendanced;
  String estimatedQuittingTime;
  GetAttendanceData({
    required this.id,
    required this.name,
    required this.enteringImagePath,
    required this.enteringTime,
    required this.estimatedQuittingTime,
    required this.isAttendanced,
    required this.quittingTime,
});
  factory GetAttendanceData.fromJson(Map<String, dynamic> json) => _$GetAttendanceDataFromJson(json);
  Map<String, dynamic> toJson() => _$GetAttendanceDataToJson(this);
}

@JsonSerializable()
class GetTemperatureData{
  int id;
  String name;
  double morning;
  bool isSickedMorning;
  double afternoon;
  bool isReported;
  bool isSickedAfternoon;

  GetTemperatureData({
    required this.id,
    required this.name,
    required this.afternoon,
    required this.isReported,
    required this.morning,
    required this.isSickedMorning,
    required this.isSickedAfternoon,
  });
  factory GetTemperatureData.fromJson(Map<String, dynamic> json) => _$GetTemperatureDataFromJson(json);
  Map<String, dynamic> toJson() => _$GetTemperatureDataToJson(this);
}


@JsonSerializable()
class PostTemperatureData{
  int id;
  String date;
  String type;
  double value;
  int cid;
  PostTemperatureData({
    required this.type,
    required this.value,
    required this.id,
    required this.date,
    required this.cid,
  });
  factory PostTemperatureData.fromJson(Map<String, dynamic> json) => _$PostTemperatureDataFromJson(json);
  Map<String, dynamic> toJson() => _$PostTemperatureDataToJson(this);
}

@JsonSerializable()
class GetEmotionData{
  int id;
  String name;
  String enteringEmotion;
  String quittingEmotion;
  List<String> enteringEmotions;
  List<String> quittingEmotions;
  String comment;
  bool isContacted;
  bool sex;

  GetEmotionData({
    required this.id,
    required this.name,
    required this.enteringEmotion,
    required this.quittingEmotion,
    required this.enteringEmotions,
    required this.quittingEmotions,
    required this.isContacted,
    required this.comment,
    required this.sex,
  });
  factory GetEmotionData.fromJson(Map<String, dynamic> json) => _$GetEmotionDataFromJson(json);
  Map<String, dynamic> toJson() => _$GetEmotionDataToJson(this);
}


@JsonSerializable()
class PostEmotionData{
  int id;
  String date;
  String type;
  String value;
  int cid;
  PostEmotionData({
    required this.type,
    required this.value,
    required this.id,
    required this.date,
    required this.cid,
  });
  factory PostEmotionData.fromJson(Map<String, dynamic> json) => _$PostEmotionDataFromJson(json);
  Map<String, dynamic> toJson() => _$PostEmotionDataToJson(this);
}


@JsonSerializable()
class GetMealData{
  int id;
  String name;
  List<double> graph;
  double value;
  GetMealData({
    required this.id,
    required this.name,
    required this.graph,
    required this.value,
  });
  factory GetMealData.fromJson(Map<String, dynamic> json) => _$GetMealDataFromJson(json);
  Map<String, dynamic> toJson() => _$GetMealDataToJson(this);
}

@JsonSerializable()
class PostMealData{
  int id;
  String date;
  double value;
  int cid;
  PostMealData({
    required this.value,
    required this.id,
    required this.date,
    required this.cid,
  });
  factory PostMealData.fromJson(Map<String, dynamic> json) => _$PostMealDataFromJson(json);
  Map<String, dynamic> toJson() => _$PostMealDataToJson(this);
}

@JsonSerializable()
class GetNapData{
  int id;
  String name;
  List<double> graph;
  double value;
  GetNapData({
    required this.id,
    required this.name,
    required this.graph,
    required this.value,
  });
  factory GetNapData.fromJson(Map<String, dynamic> json) => _$GetNapDataFromJson(json);
  Map<String, dynamic> toJson() => _$GetNapDataToJson(this);
}

@JsonSerializable()
class PostNapData{
  int id;
  String date;
  double value;
  int cid;
  PostNapData({
    required this.value,
    required this.id,
    required this.date,
    required this.cid,
  });
  factory PostNapData.fromJson(Map<String, dynamic> json) => _$PostNapDataFromJson(json);
  Map<String, dynamic> toJson() => _$PostNapDataToJson(this);
}

@JsonSerializable()
class GetDefecationAndVomitData{
  int id;
  String name;
  int defecation;
  int defecationTotal;
  int vomit;
  int vomitTotal;
  GetDefecationAndVomitData({
    required this.id,
    required this.name,
    required this.defecation,
    required this.defecationTotal,
    required this.vomit,
    required this.vomitTotal,
  });
  factory GetDefecationAndVomitData.fromJson(Map<String, dynamic> json) => _$GetDefecationAndVomitDataFromJson(json);
  Map<String, dynamic> toJson() => _$GetDefecationAndVomitDataToJson(this);
}

@JsonSerializable()
class PostDefecationAndVomitData{
  int id;
  String date;
  double value;
  String type;
  int cid;
  PostDefecationAndVomitData({
    required this.value,
    required this.id,
    required this.date,
    required this.type,
    required this.cid,
  });
  factory PostDefecationAndVomitData.fromJson(Map<String, dynamic> json) => _$PostDefecationAndVomitDataFromJson(json);
  Map<String, dynamic> toJson() => _$PostDefecationAndVomitDataToJson(this);
}
@JsonSerializable()
class GetAccident{
  int aid;
  int id;
  String name;
  bool sex;
  String date;
  String time;
  String teacherAction;
  String hospitalAction;
  dynamic medicalFee;
  dynamic isInsuranced;
  dynamic isAmbulanced;
  String contactTime;
  String place;
  String situation;
  String cause;
  String accidentType;
  GetAccident({
   required this.name,
   required this.date,
   required this.id,
   required this.sex,
   required this.accidentType,
   required this.aid,
   required this.cause,
   required this.contactTime,
   required this.hospitalAction,
   required this.isAmbulanced,
    required this.isInsuranced,
    required this.medicalFee,
    required this.place,
    required this.situation,
    required this.teacherAction,
    required this.time,
});
  factory GetAccident.fromJson(Map<String, dynamic> json) => _$GetAccidentFromJson(json);
  Map<String, dynamic> toJson() => _$GetAccidentToJson(this);
}
@JsonSerializable()
class PostAccidentData{
  int id;
  int cid;
  PostAccidentData({
    required this.id,
    required this.cid,
});
  factory PostAccidentData.fromJson(Map<String, dynamic> json) => _$PostAccidentDataFromJson(json);
  Map<String, dynamic> toJson() => _$PostAccidentDataToJson(this);
}
@JsonSerializable()
class PutAccidentData{
  int aid;
  String type;
  String value;
  PutAccidentData({
    required this.value,
    required this.aid,
    required this.type
});
  factory PutAccidentData.fromJson(Map<String, dynamic> json) => _$PutAccidentDataFromJson(json);
  Map<String, dynamic> toJson() => _$PutAccidentDataToJson(this);
}

@JsonSerializable()
class GetBodyProfile{
  int id;
  String name;
  dynamic height;
  dynamic weight;

  GetBodyProfile({
    required this.name,
  required this.id,
  required this.height,
  required this.weight,
  });
  factory GetBodyProfile.fromJson(Map<String, dynamic> json) => _$GetBodyProfileFromJson(json);
  Map<String, dynamic> toJson() => _$GetBodyProfileToJson(this);
}
@JsonSerializable()
class PostBodyProfileData{
  int id;
  int cid;
  String date;
  String type;
  double value;
  PostBodyProfileData({
   required this.date,
  required this.id,
  required this.type,
  required this.value,
  required this.cid,
});
  factory PostBodyProfileData.fromJson(Map<String, dynamic> json) => _$PostBodyProfileDataFromJson(json);
  Map<String, dynamic> toJson() => _$PostBodyProfileDataToJson(this);
}

@JsonSerializable()
class GetMedicineData{
  int id;
  String name;
  String symptom;
  String type;
  String amount;
  String count;
  String time;
  String storageMethod;
  String comment;
  String parentSign;
  String teacherSign;
  GetMedicineData({
   required this.type,
   required this.id,
   required this.name,
   required this.comment,
   required this.time,
   required this.count,
   required this.amount,
   required this.parentSign,
   required this.storageMethod,
   required this.symptom,
   required this.teacherSign,
});
  factory GetMedicineData.fromJson(Map<String, dynamic> json) => _$GetMedicineDataFromJson(json);
  Map<String, dynamic> toJson() => _$GetMedicineDataToJson(this);
}

@JsonSerializable()
class GetMonthlyReportData{
  int id;
  String name;
  bool sex;
  String imagePath;
  bool isReported;
  List<int> attendance;
  List<String> enteringTime;
  List<String> quittingTime;
  int temperature;
  List<double> height;
  List<double> weight;
  List<String> enteringEmotion;
  List<String> quittingEmotion;
  List<double> meal;
  List<double> nap;
  List<double> defecationAndVomit;
  List<double> medicine;
  List<double> accident;
  String autoCreatedComment;
  String comment;
  GetMonthlyReportData({
    required this.id,
    required this.name,
    required this.sex,
  required this.weight,
  required this.height,
  required this.temperature,
  required this.enteringEmotion,
  required this.quittingEmotion,
  required this.isReported,
  required this.quittingTime,
  required this.enteringTime,
  required this.imagePath,
  required this.accident,
  required this.attendance,
  required this.defecationAndVomit,
  required this.meal,
  required this.medicine,
  required this.nap,
    required this.comment,
    required this.autoCreatedComment,

  });
  factory GetMonthlyReportData.fromJson(Map<String, dynamic> json) => _$GetMonthlyReportDataFromJson(json);
  Map<String, dynamic> toJson() => _$GetMonthlyReportDataToJson(this);
}

@JsonSerializable()
class PostMonthlyReport{
  int id;
  String type;
  String value;
  String date;
  int cid;
  PostMonthlyReport({
   required this.value,
   required this.id,
   required this.type,
    required this.date,
    required this.cid,
});
  factory PostMonthlyReport.fromJson(Map<String, dynamic> json) => _$PostMonthlyReportFromJson(json);
  Map<String, dynamic> toJson() => _$PostMonthlyReportToJson(this);
}