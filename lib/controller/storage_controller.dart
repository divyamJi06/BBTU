import 'dart:async';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../model/contacts.dart';
import '../model/locks.dart';
import '../model/routers.dart';

class StorageController {
  final FlutterSecureStorage storage = const FlutterSecureStorage();
  void addContacts(ContactsModel contactsModel) async {
    List<ContactsModel> contactList = await readContacts();
    contactList.add(contactsModel);

    List listContectsInJson = contactList.map((e) {
      return e.toJson();
    }).toList();
    storage.write(key: "contacts", value: json.encode(listContectsInJson));
  }

  deleteContacts() async {
    await storage.delete(key: "contacts");
  }

  deleteRouters() async {
    await storage.delete(key: "routers");
  }

  deleteLocks() async {
    await storage.delete(key: "locks");
  }

  deleteMacs() async {
    await storage.delete(key: "macs");
  }

  deleteOneContact(ContactsModel contactsModel) async {
    List<ContactsModel> contactList = await readContacts();
    contactList.removeWhere((element) => element.name == contactsModel.name);
    // for (var element in contactList) {
    //   if(element.name == contactsModel.name){}
    // }
    // contactList.(contactsModel);
    List listContectsInJson = contactList.map((e) {
      return e.toJson();
    }).toList();
    storage.write(key: "contacts", value: json.encode(listContectsInJson));
  }

  Future<List<ContactsModel>> readContacts() async {
    String? contacts = await storage.read(key: "contacts");
    List<ContactsModel> _model = [];
    if (contacts == null) {
      List listContectsInJson = _model.map((e) {
        return e.toJson();
      }).toList();
      storage.write(key: "contacts", value: json.encode(listContectsInJson));
    } else {
      _model = [];
      var jsonContacts = json.decode(contacts);
      for (var element in jsonContacts) {
        _model.add(ContactsModel.fromJson(element));
      }
    }
    return _model;
  }

  Future<List<LockDetails>> readLocks() async {
    String? locks = await storage.read(key: "locks");
    List<LockDetails> _model = [];
    if (locks == null) {
      List listContectsInJson = _model.map((e) {
        return e.toJson();
      }).toList();
      print(json.encode(listContectsInJson));
      storage.write(key: "locks", value: json.encode(listContectsInJson));
    } else {
      _model = [];
      var jsonContacts = json.decode(locks);
      print(json.encode(jsonContacts));
      for (var element in jsonContacts) {
        _model.add(LockDetails.fromJson(element));
      }
    }
    return _model;
  }

  deleteOneLock(LockDetails lockDetails) async {
    List<LockDetails> lockList = await readLocks();
    lockList.removeWhere((element) => element.lockSSID == lockDetails.lockSSID);
    List listContectsInJson = lockList.map((e) {
      return e.toJson();
    }).toList();
    deleteLocks();
    storage.write(key: "locks", value: json.encode(listContectsInJson));
  }

  updateLock(String idOfLock, String newLockId, String newLockSSID,
      String newLockPassword) async {
    List<LockDetails> locksList = await readLocks();
    print(locksList.length);
    deleteLocks();
    for (var element in locksList) {
      if (element.lockld == idOfLock) {
        element.lockld = newLockId;
        element.lockPassword = newLockPassword;
        element.lockSSID = newLockSSID;
        break;
      }
      print(locksList.length);
    }
    for (var element in locksList) {
      addlocks(element);
    }
  }

  updateLockAutoStatus(String lockname, bool status) async {
    List<LockDetails> locksList = await readLocks();
    deleteLocks();
    for (var element in locksList) {
      if (element.lockSSID == lockname) {
        element.isAutoLock = status;
        break;
      }
    }
    for (var element in locksList) {
      addlocks(element);
    }
  }

  getLockBySSID(lockSSID) async {
    List<LockDetails> locksList = await readLocks();
    for (var element in locksList) {
      if (element.lockSSID == lockSSID) return element;
    }
    return null;
  }

  getRouterByName(lockSSID) async {
    List<RouterDetails> routerList = await readRouters();
    for (var element in routerList) {
      if (element.name == lockSSID) return element;
    }
    return null;
  }

  getContactByPhone(phone) async {
    List<ContactsModel> locksList = await readContacts();
    for (var element in locksList) {
      if (element.name == phone) return element;
    }
    return null;
  }

  void addlocks(LockDetails lockDetails) async {
    List<LockDetails> locksList = await readLocks();
    locksList.add(lockDetails);

    List listContectsInJson = locksList.map((e) {
      return e.toJson();
    }).toList();
    storage.write(key: "locks", value: json.encode(listContectsInJson));
  }

  Future<List<RouterDetails>> readRouters() async {
    String? locks = await storage.read(key: "routers");
    List<RouterDetails> _model = [];
    if (locks == null) {
      List listContectsInJson = _model.map((e) {
        return e.toJson();
      }).toList();
      storage.write(key: "routers", value: json.encode(listContectsInJson));
    } else {
      _model = [];
      var jsonContacts = json.decode(locks);
      print(json.encode(jsonContacts));

      for (var element in jsonContacts) {
        _model.add(RouterDetails.fromJson(element));
      }
    }
    return _model;
  }

  deleteOneRouter(RouterDetails lockDetails) async {
    List<RouterDetails> lockList = await readRouters();
    lockList.removeWhere((element) => element.lockID == lockDetails.lockID);
    List listContectsInJson = lockList.map((e) {
      return e.toJson();
    }).toList();
    storage.write(key: "routers", value: json.encode(listContectsInJson));
  }

  void addRouters(RouterDetails lockDetails) async {
    List<RouterDetails> locksList = await readRouters();
    locksList.add(lockDetails);

    List listContectsInJson = locksList.map((e) {
      return e.toJson();
    }).toList();
    storage.write(key: "routers", value: json.encode(listContectsInJson));
  }

  // Future<List<MacsDetails>> readMacs() async {
  //   String? locks = await storage.read(key: "macs");
  //   List<MacsDetails> _model = [];
  //   if (locks == null) {
  //     List listContectsInJson = _model.map((e) {
  //       return e.toJson();
  //     }).toList();
  //     storage.write(key: "macs", value: json.encode(listContectsInJson));
  //   } else {
  //     _model = [];
  //     var jsonContacts = json.decode(locks);
  //     for (var element in jsonContacts) {
  //       _model.add(MacsDetails.fromJson(element));
  //     }
  //   }
  //   return _model;
  // }

  // deleteOneMacs(MacsDetails lockDetails) async {
  //   List<MacsDetails> lockList = await readMacs();
  //   lockList.removeWhere((element) => element.id == lockDetails.id);
  //   List listContectsInJson = lockList.map((e) {
  //     return e.toJson();
  //   }).toList();
  //   storage.write(key: "macs", value: json.encode(listContectsInJson));
  // }

  // updateMacStatus(MacsDetails lockDetails) async {
  //   await deleteOneMacs(lockDetails);
  //   addmacs(lockDetails);
  // }

  // void addmacs(MacsDetails lockDetails) async {
  //   List<MacsDetails> locksList = await readMacs();
  //   locksList.add(lockDetails);

  //   List listContectsInJson = locksList.map((e) {
  //     return e.toJson();
  //   }).toList();
  //   storage.write(key: "macs", value: json.encode(listContectsInJson));
  // }
}
