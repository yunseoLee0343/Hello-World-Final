class CenterMap {
  final String centerID;
  final String name;
  final String status;
  final String closed;
  final String address;
  final String image;
  final double latitude;
  final double longitude;

  CenterMap({
    required this.centerID,
    required this.name,
    required this.status,
    required this.closed,
    required this.address,
    required this.image,
    required this.latitude,
    required this.longitude,
  });

  factory CenterMap.fromJson(Map<String, dynamic> json) {
    return CenterMap(
      centerID: json['cetnerId'] as String,
      name: json['name'] as String,
      status: json['status'] as String,
      closed: json['closed'] as String,
      address: json['address'] as String,
      image: json['image'] as String,
      latitude: json['latitude'] as double,
      longitude: json['longitude'] as double,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cetnerId': centerID,
      'name': name,
      'status': status,
      'closed': closed,
      'address': address,
      'image': image,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}

class ApiResponse {
  final bool isSuccess;
  final String code;
  final String message;
  final List<CenterMap> centerMapList;

  ApiResponse({
    required this.isSuccess,
    required this.code,
    required this.message,
    required this.centerMapList,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    var list = json['result']['centerMapList'] as List;
    List<CenterMap> centerMapList =
        list.map((i) => CenterMap.fromJson(i)).toList();

    return ApiResponse(
      isSuccess: json['isSuccess'] as bool,
      code: json['code'] as String,
      message: json['message'] as String,
      centerMapList: centerMapList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isSuccess': isSuccess,
      'code': code,
      'message': message,
      'result': {
        'centerMapList':
            centerMapList.map((centerMap) => centerMap.toJson()).toList(),
      },
    };
  }
}
