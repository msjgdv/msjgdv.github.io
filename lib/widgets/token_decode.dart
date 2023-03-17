import 'package:jwt_decode/jwt_decode.dart';

tokenDecode(String _token, String _info){
  Map<String, dynamic> data = Jwt.parseJwt(_token.toString());
  return data[_info];
}