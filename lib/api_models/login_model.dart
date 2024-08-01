class LoginResponse {
  final bool isSuccess;
  final String code;
  final String message;
  final List<TokenData> result;

  LoginResponse({
    required this.isSuccess,
    required this.code,
    required this.message,
    required this.result,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    var list = json['result'] as List;
    List<TokenData> resultList =
        list.map((i) => TokenData.fromJson(i)).toList();

    return LoginResponse(
      isSuccess: json['isSuccess'],
      code: json['code'],
      message: json['message'],
      result: resultList,
    );
  }
}

class TokenData {
  final String types;
  final String token;
  final String tokenExpriresTime;

  TokenData({
    required this.types,
    required this.token,
    required this.tokenExpriresTime,
  });

  factory TokenData.fromJson(Map<String, dynamic> json) {
    return TokenData(
      types: json['types'],
      token: json['token'],
      tokenExpriresTime: json['tokenExpriresTime'],
    );
  }
}
