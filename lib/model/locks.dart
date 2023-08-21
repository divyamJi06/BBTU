import 'contacts.dart';

class LockDetails {
  late String lockld;
  late String lockSSID;
  late String lockPassword;
  late String iPAddress;
  late String lockPassKey;
  late bool isAutoLock;
  late String privatePin;
  late ContactsModel contactsModel;

  LockDetails(
      {required this.lockld,
      required this.lockPassKey,
      required this.lockSSID,
      required this.contactsModel,
      required this.isAutoLock,
      required this.privatePin,
      required this.lockPassword,
      required this.iPAddress});

  LockDetails.fromJson(Map<String, dynamic> json) {
    lockld = json['LockId'];
    lockSSID = json['LockSSID'];
    lockPassword = json['LockPassword'];
    contactsModel = ContactsModel.fromJson(json['contactsModel']);
    privatePin = json['privatePin'];
    isAutoLock = json['isAutoLock'];
    iPAddress = json['IPAddress'];
    lockPassKey = json['LockPasskey'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['LockId'] = lockld;
    data['LockSSID'] = lockSSID;
    data['isAutoLock'] = isAutoLock;
    data['privatePin'] = privatePin;
    data['LockPassword'] = lockPassword;
    data['IPAddress'] = iPAddress;
    data['contactsModel'] = contactsModel.toJson();
    data['LockPasskey'] = lockPassKey;
    return data;
  }

  String toLockQR() {
    return "$lockld,$lockSSID,$lockPassKey,$lockPassword";
  }
}
