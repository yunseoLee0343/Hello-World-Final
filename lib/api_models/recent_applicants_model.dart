class AllReservationListRes {
  final List<AllReservationRes> allReservationList;

  AllReservationListRes({required this.allReservationList});

  factory AllReservationListRes.fromJson(Map<String, dynamic> json) {
    var list = json['allReservationList'] as List;
    List<AllReservationRes> reservationsList =
        list.map((i) => AllReservationRes.fromJson(i)).toList();

    return AllReservationListRes(allReservationList: reservationsList);
  }
}

class AllReservationRes {
  final int summaryId;
  final String identificationNum;
  final DateTime uploadedAt;
  final String name;
  final String userImg;
  final String title;

  AllReservationRes({
    required this.summaryId,
    required this.identificationNum,
    required this.uploadedAt,
    required this.name,
    required this.userImg,
    required this.title,
  });

  factory AllReservationRes.fromJson(Map<String, dynamic> json) {
    return AllReservationRes(
      summaryId: json['summaryId'],
      identificationNum: json['identificationNum'],
      uploadedAt: DateTime.parse(json['uploadedAt']),
      name: json['name'],
      userImg: json['userImg'],
      title: json['title'],
    );
  }
}
