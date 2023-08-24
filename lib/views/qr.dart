import 'dart:convert';

import '../controller/storage_controller.dart';
import '../model/contacts.dart';
import '../model/routers.dart';
import '../utils/contstants.dart';
import '../widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

import '../model/locks.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/toast.dart';

class QRView extends StatefulWidget {
  const QRView({required this.type, super.key});
  final String type;

  @override
  State<QRView> createState() => _QRViewState();
}

class _QRViewState extends State<QRView> {
  LockDetails? details;
  RouterDetails? routerDetails;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    scanQR();
  }

  String _scanBarcode = 'Unknown';
  StorageController _storageController = StorageController();
  // LockDetails details = LockDetails(
  //     lockld: "Unknown",
  //     lockSSID: "Unknown",
  //     lockPassword: "Unknown",
  //     isAutoLock: false,
  //     privatePin: "1234",
  //     iPAddress: "Unknown");
  Future<void> scanQR() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      print("=================");
      _scanBarcode = barcodeScanRes;
      print(barcodeScanRes);

      print("=================");
      try {
        List<String> d = barcodeScanRes.split(",");
        if (widget.type == "lock") {
          if (d.length != 8) throw Exception("Not correct data");
          ContactsModel contacts = ContactsModel(
              accessType: d[5],
              startDateTime: DateTime.tryParse(d[6])!,
              endDateTime: DateTime.tryParse(d[7])!,
              name: d[4]);

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
          ContactsModel contacts = ContactsModel(
              accessType: d[6],
              startDateTime: DateTime.tryParse(d[7])!,
              endDateTime: DateTime.tryParse(d[8])!,
              name: d[5]);
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
          _scanBarcode = "The QR does not have the right data";
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(children: [
          Text(_scanBarcode),
          CustomButton(
              text: "Submit",
              onPressed: () {
                print("$_scanBarcode");
                if (_scanBarcode == "Unknown") {
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
