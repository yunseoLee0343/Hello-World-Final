class CounselorRes {
  final String name;
  final String centerName;
  final List<String> language;
  final DateTime start;
  final DateTime end;

  CounselorRes({
    required this.name,
    required this.centerName,
    required this.language,
    required this.start,
    required this.end,
  });

  factory CounselorRes.fromJson(Map<String, dynamic> json) {
    return CounselorRes(
      name: json['name'] as String,
      centerName: json['centerName'] as String,
      language: List<String>.from(json['language'] as List<dynamic>),
      start: DateTime.parse(json['start'] as String),
      end: DateTime.parse(json['end'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'centerName': centerName,
      'language': language,
      'start': start.toIso8601String(),
      'end': end.toIso8601String(),
    };
  }
}

class CounselorListRes {
  final DateTime today;
  final List<CounselorRes> counselorList;

  CounselorListRes({
    required this.today,
    required this.counselorList,
  });

  factory CounselorListRes.fromJson(Map<String, dynamic> json) {
    return CounselorListRes(
      today: DateTime.parse(json['today'] as String),
      counselorList: (json['counselorList'] as List<dynamic>)
          .map((item) => CounselorRes.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'today': today.toIso8601String(),
      'counselorList':
          counselorList.map((counselor) => counselor.toJson()).toList(),
    };
  }
}
