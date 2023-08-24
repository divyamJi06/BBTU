class ContactsModel {
  late String name;
  late String accessType;
  late DateTime startDateTime;
  late DateTime endDateTime;

  ContactsModel(
      {required this.accessType,
      required this.startDateTime,
      required this.endDateTime,
      required this.name});

  ContactsModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    accessType = json['accessType'];
    startDateTime = DateTime.tryParse(json['startDateTime'])!;
    endDateTime = DateTime.tryParse(json['endDateTime'])!;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['accessType'] = accessType;
    data['startDateTime'] = startDateTime.toIso8601String();
    data['endDateTime'] = endDateTime.toIso8601String();
    return data;
  }

  String toContactsQR() {
    return "$name,$accessType,${startDateTime.toString()},${endDateTime.toString()}";
  }
}
