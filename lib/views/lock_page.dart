import 'gallery_qr.dart';
import 'qr.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../controller/storage_controller.dart';
import '../model/locks.dart';
import '../utils/contstants.dart';
import '../widgets/lock_card.dart';
import 'connect_to_lock.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:scan/scan.dart';

class LockPage extends StatelessWidget {
  LockPage({super.key});

  final StorageController _storageController = new StorageController();

  Future<List<LockDetails>> fetchLocks() async {
    return _storageController.readLocks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: SizedBox(
          height: 70,
          width: 180,
          child: FloatingActionButton.large(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const QRView(type: "lock"),
                        ));
                      },
                      icon: Icon(Icons.photo_camera)),
                  // Container(),
                  VerticalDivider(
                    color: whiteColour,
                    thickness: 2,
                    endIndent: 20,
                    indent: 20,
                  ),
                  IconButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              const GalleryQRPage(type: "lock"),
                        ));
                      },
                      icon: Icon(Icons.photo)),
                ],
              ),
              onPressed: () {}),
        ),
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: AppBar(
            iconTheme: IconThemeData(color: appBarColour),
            backgroundColor: backGroundColour,
            automaticallyImplyLeading: false,
            title: Text(
              "Locks",
              style: TextStyle(
                  color: appBarColour,
                  fontSize: 40,
                  fontWeight: FontWeight.bold),
            ),
            actions: const [],
            centerTitle: true,
            elevation: 0,
          ),
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            // mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FutureBuilder(
                  future: fetchLocks(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }
                    if (snapshot.hasError) return const Text("ERROR");

                    return ListView.builder(
                        padding: const EdgeInsets.only(top: 10),
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ConnectToLockWidget(
                                            lockName:
                                                snapshot.data![index].lockSSID,
                                            IP: snapshot.data![index].iPAddress,
                                            lockID:
                                                snapshot.data![index].lockld,
                                            lockPassKey: snapshot
                                                .data![index].lockPassKey!,
                                          )));
                            },
                            child:
                                LocksCard(locksDetails: snapshot.data![index]),
                          );
                        });
                  }),
            ],
          ),
        ));
  }
}
