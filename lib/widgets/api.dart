import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mime_type/mime_type.dart';
import 'package:treasure_map/main.dart';
import 'package:treasure_map/widgets/token_time_over.dart';
import 'package:http_parser/http_parser.dart';

class ApiUrl {
  final String baseUrl = 'http://192.168.0.7:8080';

  // final String baseUrl = 'http://tmap.aijoa.us:48764';

  ///local
  final String _loginIn = '/api/local';
  final String _findId = '/api/local/findid';
  final String _reset = '/api/local/reset';
  final String _check = '/api/local/check';
  final String _withdraw = '/api/local/withdraw';
  final String _withdrawCheck = '/api/local/withdrawCheck';
  final String _localNew = '/api/local/new';
  final String _contact = '/api/local/contact';

  //post -> 로그인
  //get -> 내 정보 요청
  //patch -> 내정보 갱신
  String get loginIn => baseUrl + _loginIn;

  //post -> 아이디 찾기
  String get findId => baseUrl + _findId;

  //post -> 비밀번호 재설정
  String get reset => baseUrl + _reset;

  //post -> 비밀번호 재확인
  String get check => baseUrl + _check;

  //post -> 탈퇴요청
  String get withdraw => baseUrl + _withdraw;

  //post -> 탈퇴전 계정검증
  String get withdrawCheck => baseUrl + _withdrawCheck;

  //post -> 유저등록
  String get localNew => baseUrl + _localNew;

  //post -> 문의하기
  String get contact => baseUrl + _contact;

  ///etc
  final String _status = '/api/status';
  final String _version = '/api/version';
  final String _refresh = '/api/refresh';
  final String _email = '/api/email';
  final String _image = '/api/image';

  //get -> 버전정보 받기
  String get version => baseUrl + _version;

  //get -> 내 직위 및 서비스 상태 확인
  String get status => baseUrl + _status;

  //get -> access 토큰 재발급
  String get refresh => baseUrl + _refresh;

  //get -> 검증번호 발송
  //post -> 이메일 인증용 메일발송(회원가입 및 패스워드 찾기)
  String get email => baseUrl + _email;

  //get -> 이미지 불러오기
  String get image => baseUrl + _image;

  ///child
  final String _child = '/api/child';
  final String _childDelete = '/api/child/delete';

  //get -> 아이목록요청
  //post -> 아이생성
  //put -> 아이정보 수정
  String get child => baseUrl + _child;

  //post -> 아이삭제
  String get deleteChild => baseUrl + _childDelete;

  ///class
  final String _class = "/api/class";
  final String _classDelete = "/api/class/delete";

  //get -> 반목록 요청
  //post -> 반생성
  //put -> 반수정
  String get getClass => baseUrl + _class;

  //post -> 반 삭제
  String get deleteClass => baseUrl + _classDelete;

  ///teacher
  final String _teacher = '/api/teacher';

  //get -> 선생님 목록
  //put -> 선생님 삭제
  //post -> 선생님 신청 허가
  String get teacher => baseUrl + _teacher;

  ///kindergarten
  final String _kindergarten = '/api/kindergarten';
  final String _kindergartenInfo = '/api/kindergarten/info';
  final String _kindergartenImage = '/api/kindergarten/image';

  //get -> 정보 받기
  //patch -> 정보 수정
  //post -> 원장선생님으로 설정
  //get{name} -> 기관 찾기
  String get kindergarten => baseUrl + _kindergarten;

  //get -> 시설정보 받기
  String get kindergartenInfo => baseUrl + _kindergartenInfo;

  //post -> 시설 이미지 넣기
  //delete -> 시설 이미지 삭제
  String get kindergartenImage => baseUrl + _kindergartenImage;

  ///role
  final String _apply = '/api/apply';
  final String _applyNone = '/api/apply/none';

  //get -> 신청서 넣은 선생님 목록
  //post -> 신청서 넣기
  //delete -> 신청 반려
  String get apply => baseUrl + _apply;

  //get -> 신청 여부 확인
  String get applyNone => baseUrl + _applyNone;

  ///info panel
  final String _infoPanel = '/api/infopanel';
  final String _infoPanelAttend = '/api/infopanel/attend';
  final String _infoPanelEnvironment = '/api/infopanel/environment';
  final String _infoPanelImage = '/api/infopanel/image';

  //get{date} -> 인포패널 기본페이지 출력용 데이터
  String get infoPanel => baseUrl + _infoPanel;

  //get -> 보육시설 등하원 api
  String get infoPanelAttend => baseUrl + _infoPanelAttend;

  //get -> 보육시설 등하원 api
  String get infoPanelEnvironment => baseUrl + _infoPanelEnvironment;

  //post -> 인포패널 이미지 넣기
  //get -> 인포패널 이미지 수정용 get;
  //delete -> 인포패널 이미지 삭제
  String get infoPanelImage => baseUrl + _infoPanelImage;

  ///schedule
  final String _schedule = '/api/schedule';
  final String _restday = '/api/schedule/restday';
  final String _statistics = '/api/schedule/statistics';
  final String _scheduleKindergarten = '/api/schedule/kindergarten';
  final String _scheduleClass = '/api/schedule/class';
  final String _scheduleWeek = '/api/schedule/week';

  //post -> 학사일정 개시
  //get -> 유치원 학사년도 요청
  //get -> {classId} 특정반의 시작날짜~끝날짜
  String get schedule => baseUrl + _schedule;

  //get -> 해당 월의 휴일 리스트 받기
  String get restday => baseUrl + _restday;

  //get -> 해당 년도의 통계 리스트 받기
  String get statistics => baseUrl + _statistics;

  //get -> 유치원 학사일정 요청
  //post -> 유치원 학사일정 입력
  //patch -> 유치원 학사일정 수정
  //delete -> 유치원 학사일정 삭제
  String get scheduleKindergarten => baseUrl + _scheduleKindergarten;

  //get -> 반 학사일정 요청
  //post -> 반 학사일정 입력
  //patch -> 반 학사일정 수정
  //delete -> 반 학사일정 삭제
  String get scheduleClass => baseUrl + _scheduleClass;

  //get -> 유치원 주간일정 요청
  //post -> 유치원 주간일정 생성
  //patch -> 유치원 주간일정 수정
  //delete -> 유치원 주간일정 삭제제
  String get scheduleWeek => baseUrl + _scheduleWeek;

  ///atti
  final String _atti = '/api/atti/report';
  final String _attiChild = '/api/atti/child';
  final String _attiSurvey = '/api/atti/survey';

  //get?year -> 년도 설정
  //post -> 아띠맵 생성
  //put -> 아띠맵 코멘트 수정
  //patch -> 아띠맵 조사 종료
  //delete -> 아띠맵 삭제
  //get{reportId} -> 아띠맵 결과 데이터 받기
  String get atti => baseUrl + _atti;

  //get -> 아띠맵 아이정보 불러오기
  String get attiChild => baseUrl + _attiChild;

  //post -> 아띠맵 아이선택 정보저장
  //put -> 아띠맵 아이선택 정보변경
  String get attiSurvey => baseUrl + _attiSurvey;

  ///activity
  final String _accident = '/api/activity/accident';
  final String _attendance = '/api/activity/attendance';
  final String _attendanceImage = '/api/activity/attendance/image';
  final String _defecationAndVomit = '/api/activity/defecationAndVomit';
  final String _emotion = '/api/activity/emotion';
  final String _heightAndWeight = '/api/activity/heightAndWeight';
  final String _meal = '/api/activity/meal';
  final String _medicine = '/api/activity/medicine';
  final String _monthlyReport = '/api/activity/monthlyReport';
  final String _nap = '/api/activity/nap';
  final String _temperature = '/api/activity/temperature';

  //get -> 안전사고 정보 받기
  //post -> 안전사고 리포트 생성
  //put -> 안전사고 정보 입력
  //delete -> 안전사고 정보 삭제
  String get accident => baseUrl + _accident;

  //get -> 출석정보 받기
  //post -> 출석정보 입력
  String get attendance => baseUrl + _attendance;

  //post -> 출석 이미지 입력
  String get attendanceImage => baseUrl + _attendanceImage;

  //get -> 배변구토 정보 받기
  //post -> 배변구토 정보 입력
  String get defecationAndVomit => baseUrl + _defecationAndVomit;

  //get -> 감정정보 받기
  //post -> 감정정보 입력
  String get emotion => baseUrl + _emotion;

  //get -> 신장체중 정보 받기
  //post -> 신장체중 정보 입력력
  String get heightAndWeight => baseUrl + _heightAndWeight;

  //get -> 식사정보 받기
  //post -> 식사정보 입력
  String get meal => baseUrl + _meal;

  //get -> 투약정보 받기
  //post -> 투약정보 입력
  String get medicine => baseUrl + _medicine;

  //get -> 월별보고서 받기
  //post -> 월별보고서 생성 및 수정
  String get monthlyReport => baseUrl + _monthlyReport;

  //get -> 낮잠정보 받기
  //post -> 낮잠정보 입력
  String get nap => baseUrl + _nap;

  //get -> 체온정보 받기
  //post -> 체온정보 입력
  String get temperature => baseUrl + _temperature;

  ///auth
  final String _auth = '/api/local/auth';

  //get -> 기관 선생님들 권한 보기
  //post -> 기관 선생님들 관한 부여 및 해제
  String get auth => baseUrl + _auth;

  ///document/record
  final String _record = '/api/document/record';
  final String _recordImage = '/api/document/record/image';
  final String _recordSign = '/api/document/record/sign';
  final String _recordChild = '/api/document/record/child';
  final String _recordDate = '/api/document/record/date';
  final String _recordTheme = '/api/document/record/theme';
  final String _recordNuri = '/api/document/record/nuri';
  final String _recordToDaily = '/api/document/record/daily';

  //get -> 특정 관찰기록 정보보기
  String get record => baseUrl + _record;

  //post -> 관찰기록 놀이참여유아 지정
  String get recordChild => baseUrl + _recordChild;

  //get -> 특정날짜 관찰기록 정보보기
  String get recordDate => baseUrl + _recordDate;

  //get -> 이전에 기록했던 주제 목록들을 가져오는 api
  String get recordTheme => baseUrl + _recordTheme;

  //post -> 참여유아 누리과정 지정
  String get recordNuri => baseUrl + _recordNuri;

  //post -> 관찰기록 하루일과에 붙이기
  String get recordToDaily => baseUrl + _recordToDaily;

  //get -> 특정 관찰기록 사인하기
  String get recordSign => baseUrl + _recordSign;

  //
  String get recordImage => baseUrl + _recordImage;

  ///document/annual
  final String _annual = '/api/document/annual';

  String get annual => baseUrl + _annual;

  ///document/daily
  final String _daily = '/api/document/daily';
  final String _dailySign = '/api/document/daily/sign';
  final String _dailyPlan = '/api/document/daily/record';

  String get daily => baseUrl + _daily;

  String get dailyPlan => baseUrl + _dailyPlan;

  String get dailySign => baseUrl + _dailySign;

  ///document/weekly
  final String _weekly = '/api/document/weekly';
  final String _weeklySign = '/api/document/weekly/sign';
  final String _weeklyFree = '/api/document/weekly/free';
  final String _weeklyCategory = '/api/document/weekly/category';
  final String _weeklySubCategory = '/api/document/weekly/subcategory';
  final String _weeklyAdded = '/api/document/weekly/added';

  String get weekly => baseUrl + _weekly;

  String get weeklySign => baseUrl + _weeklySign;

  String get weeklyFree => baseUrl + _weeklyFree;

  String get weeklyCategory => baseUrl + _weeklyCategory;

  String get weeklySubCategory => baseUrl + _weeklySubCategory;

  String get weeklyAdded => baseUrl + _weeklyAdded;

  ///document/home
  final String _home = '/api/document/home';
  final String _homeSign = '/api/document/home/sign';
  final String _homeMemo = '/api/document/home/memo';
  final String _homeDay = '/api/document/home/day';

  String get home => baseUrl + _home;

  String get homeSign => baseUrl + _homeSign;

  String get homeDay => baseUrl + _homeDay;

  String get homeMemo => baseUrl + _homeMemo;

  ///document/nuri
  final String _nuriChild = '/api/document/nuri/child';
  final String _nuriClass = '/api/document/nuri/class';
  final String _nuriChildSign = '/api/document/nuri/child/sign';
  final String _nuriClassSign = '/api/document/nuri/class/sign';

  String get nuriChild => baseUrl + _nuriChild;

  String get nuriClass => baseUrl + _nuriClass;

  String get nuriChildSign => baseUrl + _nuriChildSign;

  String get nuriClassSign => baseUrl + _nuriClassSign;

  ///document/sign
  final String _sign = '/api/document/sign';

  String get sign => baseUrl + _sign;

  ///document/life
  final String _life = '/api/document/life';

  String get life => baseUrl + _life;
}

api(String url, String apiType, String headerType, dynamic data,
    context) async {
  const autoLoginStorage = FlutterSecureStorage();
  Map<String, String> headers = {};
  if (kDebugMode) {
    print(url);
    print(apiType);
    print(headerType);
    print(data);
  }
  if (headerType == '') {
    headers['Content-Type'] = "application/json";
  } else {
    final token = await autoLoginStorage.read(key: headerType);
    headers['authorization'] = token!;
    headers['Content-Type'] = "application/json";
  }
  var uri = Uri.parse(url);

  http.Response? response;
  if (apiType == 'post') {
    response = await http.post(uri, headers: headers, body: jsonEncode(data));
  } else if (apiType == 'get') {
    response = await http.get(uri, headers: headers);
  } else if (apiType == 'patch') {
    response = await http.patch(uri, headers: headers, body: jsonEncode(data));
  } else if (apiType == 'delete') {
    response = await http.delete(uri, headers: headers, body: jsonEncode(data));
  } else if (apiType == 'put') {
    response = await http.put(uri, headers: headers, body: jsonEncode(data));
  }

  if (response!.statusCode != 200) {
    if (kReleaseMode) {
      if (response.statusCode == 202) {
        var rB = utf8.decode(response.bodyBytes);
        var data = jsonDecode(rB);
        Fluttertoast.showToast(
            msg: data['err'],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM);
        return response;
      } else if (response.statusCode == 409) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SplashScreen()),
        );
        return response;
      } else if (response.statusCode == 419) {
        tokenTimeOverPopUP(context);
        return response;
      } else {
        return response;
      }
    } else if (kDebugMode) {
      switch (response.statusCode) {
        case 202:
          var rB = utf8.decode(response.bodyBytes);
          var data = jsonDecode(rB);
          Fluttertoast.showToast(
              msg: data['err'],
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM);
          return response;
        case 409:
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SplashScreen()),
          );
          return response;
        case 419:
          tokenTimeOverPopUP(context);
          return response;
        default:
          debugPrint(response.statusCode.toString());
          return response;
      }
    }
  } else {
    return response;
  }
}

imagePostApi(String url, String headerType, dynamic data, File? image,
    String apiType, context, Function() dataSetting) async {
  const autoLoginStorage = FlutterSecureStorage();
  Map<String, String> headers = {};
  var uri = Uri.parse(url);
  if (headerType == '') {
  } else {
    final token = await autoLoginStorage.read(key: headerType);
    headers['authorization'] = token!;
    headers['Content-Type'] = "multipart/form-data";
  }
  http.MultipartRequest request;
  if (image != null) {
    String? mimeType;
    String imageName = image.path.split('/').last;
    if (image.existsSync()) {
      mimeType = mime(imageName);
      mimeType ??= 'text/plain; charset=UTF-8';
    }

    request = http.MultipartRequest(apiType, uri)
      ..headers.addAll(headers)
      ..fields.addAll(data)
      ..files.add(await http.MultipartFile.fromPath(
        'image',
        image.path,
        contentType: MediaType(imageName, mimeType!.split('/')[1]),
      ));
  } else {
    request = http.MultipartRequest(apiType, uri)
      ..headers.addAll(headers)
      ..fields.addAll(data);
  }

  final response = request.send().then((response) async {
    http.Response res = await http.Response.fromStream(response);
    if (res.statusCode != 200) {
      if (kReleaseMode) {
        if (res.statusCode == 409) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SplashScreen()),
          );
        } else if (res.statusCode == 419) {
          tokenTimeOverPopUP(context);
        } else {}
      } else if (kDebugMode) {
        switch (res.statusCode) {
          case 202:
            var rB = utf8.decode(res.bodyBytes);
            var data = jsonDecode(rB);
            Fluttertoast.showToast(
                msg: data['err'],
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM);
            break;
          case 409:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SplashScreen()),
            );
            break;
          case 419:
            tokenTimeOverPopUP(context);
            break;
          default:
            debugPrint(res.statusCode.toString());
            break;
        }
      }
    } else {
      dataSetting();
    }
  });
  return response;
}

imagesPostApi(String url, String headerType, FormData data, String apiType,
    context, Function dataSetting) async {
  const autoLoginStorage = FlutterSecureStorage();
  Dio dio = Dio();
  dio.options.contentType = 'multipart/form-data';
  dio.options.maxRedirects.isFinite;
  if (kDebugMode) {
    print(url);
    print(apiType);
    print(headerType);
    print(data);
  }

  if (headerType == '') {
  } else {
    final token = await autoLoginStorage.read(key: headerType);
    dio.options.headers = {'authorization': token!};
  }
  var response;
  if(apiType == 'post'){
    response = await dio.post(
      url,
      data: data,
    );
  }else{
    response = await dio.put(
      url,
      data: data,
    );
  }


  if (response.statusCode != 200) {
    if (kReleaseMode) {
      if (response.statusCode == 202) {
        Fluttertoast.showToast(
            msg: response.data['err'],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM);
        return response;
      } else if (response.statusCode == 409) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SplashScreen()),
        );
        return response;
      } else if (response.statusCode == 419) {
        tokenTimeOverPopUP(context);
        return response;
      } else {
        return response;
      }
    } else if (kDebugMode) {
      switch (response.statusCode) {
        case 202:

          Fluttertoast.showToast(
              msg: response.data['err'],
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM);
          return response;
        case 409:
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SplashScreen()),
          );
          return response;
        case 419:
          tokenTimeOverPopUP(context);
          return response;
        default:
          debugPrint(response.statusCode.toString());
          return response;
      }
    }
  } else {
    dataSetting();
  }
  return response;
}

imageApi(String url, String headerType, context) async {
  ApiUrl apiUrl = ApiUrl();
  const autoLoginStorage = FlutterSecureStorage();
  Map<String, String> headers = {};

  if (headerType == '') {
  } else {
    final token = await autoLoginStorage.read(key: headerType);
    headers['authorization'] = token!;
    headers['Content-Type'] = "application/json";
  }
  Image image = Image.network(
    '${apiUrl.baseUrl}/$url',
    headers: headers,
      fit: BoxFit.cover
  );
  return image;
}

void showToast(String message) {
  Fluttertoast.showToast(
      textColor: Colors.white,
      msg: message,
      backgroundColor: Colors.grey,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM);
}
