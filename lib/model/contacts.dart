class ContactsModel {
  late String name;
  late String accessType;
  late String date;
  late String time;

  ContactsModel(
      {required this.accessType,
      required this.date,
      required this.time,
      required this.name});

  ContactsModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    accessType = json['accessType'];
    date = json['date'];
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['accessType'] = accessType;
    data['date'] = date;
    data['time'] = time;
    return data;
  }

  String toContactsQR() {
    return "$name,$accessType,$date,$time";
  }
}
