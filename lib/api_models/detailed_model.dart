class DetailSummaryRes {
  final int summaryId;
  final String identificationNum;
  final DateTime uploadedAt; // LocalDateTime in Dart
  final String name;
  final String userImg;
  final String chatSummary;
  final String mainPoint;

  DetailSummaryRes({
    required this.summaryId,
    required this.identificationNum,
    required this.uploadedAt,
    required this.name,
    required this.userImg,
    required this.chatSummary,
    required this.mainPoint,
  });

  factory DetailSummaryRes.fromJson(Map<String, dynamic> json) {
    return DetailSummaryRes(
      summaryId: json['summaryId'],
      identificationNum: json['identificationNum'],
      uploadedAt: DateTime.parse(json['uploadedAt']), // Convert to DateTime
      name: json['name'],
      userImg: json['userImg'],
      chatSummary: json['chatSummary'],
      mainPoint: json['mainPoint'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'summaryId': summaryId,
      'identificationNum': identificationNum,
      'uploadedAt': uploadedAt.toIso8601String(), // Convert to ISO 8601 string
      'name': name,
      'userImg': userImg,
      'chatSummary': chatSummary,
      'mainPoint': mainPoint,
    };
  }
}
