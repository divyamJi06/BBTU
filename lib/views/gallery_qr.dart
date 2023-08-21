import '../controller/storage_controller.dart';
import '../widgets/toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scan/scan.dart';

import '../model/contacts.dart';
import '../model/locks.dart';
import '../model/routers.dart';
import '../utils/contstants.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/custom_button.dart';

class GalleryQRPage extends StatefulWidget {
  const GalleryQRPage({required this.type, super.key});
  final String type;

  @override
  State<GalleryQRPage> createState() => _GalleryQRPageState();
}

class _GalleryQRPageState extends State<GalleryQRPage> {
  String _platformVersion = 'Unknown';
  StorageController _storageController = StorageController();

  String qrcode = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    String platformVersion;
    try {
      platformVersion = await Scan.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
    scanFromGallery();
  }

  scanFromGallery() async {
    XFile? res = (await ImagePicker().pickImage(source: ImageSource.gallery));
    if (res != null) {
      String? str = await Scan.parse(res.path);
      if (str != null) {
        setState(() {
          qrcode = str;
          print("---------------------");
          print(qrcode);
          print("---------------------");
          parseData(qrcode);
        });
      }
    }
  }

  parseData(barcodeScanRes) {
    try {
      List<String> d = barcodeScanRes.split(",");
      print("----------------");
      print(widget.type);
      print("----------------");
      if (widget.type == "lock") {
        if (d.length != 8) throw Exception("Not correct data");
        ContactsModel contacts =
            ContactsModel(accessType: d[5], date: d[6], time: d[7], name: d[4]);
        details = LockDetails(
            contactsModel: contacts,
            iPAddress: routerIP,
            lockld: d[0],
            isAutoLock: false,
            privatePin: "2345",
            lockSSID: d[1],
            lockPassKey: d[2],
            lockPassword: d[3]);
      } else if (widget.type == "router") {
        if (d.length != 9) throw Exception("Not correct data");

        ContactsModel contacts =
            ContactsModel(accessType: d[6], date: d[7], time: d[8], name: d[5]);
        routerDetails = RouterDetails(
          lockID: d[0],
          name: d[1],
          password: d[2],
          lockPasskey: d[3],
          iPAddress: d[4],
          contactsModel: contacts,
        );
      } else {
        print("heello");
      }
    } catch (e) {
      print(e);
      setState(() {
        qrcode = "The QR does not have the right data";
      });
    }
  }

  LockDetails? details;
  RouterDetails? routerDetails;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(children: [
          Text(qrcode),
          CustomButton(
              text: "Submit",
              onPressed: () {
                print("$qrcode");
                if (qrcode == "Unknown") {
                  showToast(context, "QR data is not correct.");
                  return;
                }
                if (widget.type == "lock") {
                  _storageController.addlocks(details!);
                } else {
                  _storageController.addRouters(routerDetails!);
                }
                Navigator.pushAndRemoveUntil<dynamic>(
                  context,
                  MaterialPageRoute<dynamic>(
                    builder: (BuildContext context) => MyNavigationBar(),
                  ),
                  (route) =>
                      false, //if you want to disable back feature set to false
                );
              })
        ]),
      ),
    );
  }
}
