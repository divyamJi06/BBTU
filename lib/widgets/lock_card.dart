import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../controller/storage_controller.dart';
import '../model/locks.dart';
import '../utils/contstants.dart';
import 'bottom_nav_bar.dart';

class LocksCard extends StatefulWidget {
  final LockDetails locksDetails;
  LocksCard({
    required this.locksDetails,
    super.key,
  });

  @override
  State<LocksCard> createState() => _LocksCardState();
}

class _LocksCardState extends State<LocksCard> {
  StorageController _storageController = StorageController();
  bool hide = true;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: MediaQuery.of(context).size.width * .8,
          // height: 150,
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
              color: Colors.grey.shade400,
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(5, 5), // changes position of shadow
            ),
          ], color: whiteColour, borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      "Lock ID : ",
                      style: TextStyle(
                          fontSize: 20,
                          color: blackColour,
                          fontWeight: FontWeight.bold),
                    ),
                    Wrap(
                      children: [
                        Text(
                          widget.locksDetails.lockld,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 20,
                              color: blackColour,
                              fontWeight: FontWeight.w400),
                        ),
                      ],
                    )
                  ],
                ),
                Row(
                  children: [
                    Text(
                      "Lock Name : ",
                      style: TextStyle(
                          fontSize: 20,
                          color: blackColour,
                          fontWeight: FontWeight.bold),
                    ),
                    Wrap(
                      children: [
                        Text(
                          widget.locksDetails.lockSSID,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 20,
                              color: blackColour,
                              fontWeight: FontWeight.w400),
                        ),
                      ],
                    )
                  ],
                ),
                Row(
                  children: [
                    Text(
                      "Lock PassKey : ",
                      style: TextStyle(
                          fontSize: 20,
                          color: blackColour,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      hide
                          ? List.generate(
                              widget.locksDetails.lockPassKey!.length,
                              (index) => "*").join()
                          : widget.locksDetails.lockPassKey!,
                      style: TextStyle(
                          fontSize: 20,
                          color: blackColour,
                          fontWeight: FontWeight.w400),
                    )
                  ],
                ),
                Row(
                  children: [
                    Text(
                      "Lock Password: ",
                      style: TextStyle(
                          fontSize: 20,
                          color: blackColour,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      hide
                          ? List.generate(
                              widget.locksDetails.lockPassword.length,
                              (index) => "*").join()
                          : widget.locksDetails.lockPassword,
                      style: TextStyle(
                          fontSize: 20,
                          color: blackColour,
                          fontWeight: FontWeight.w400),
                    )
                  ],
                ),
                Container(
                  decoration: BoxDecoration(
                      color: backGroundColour,
                      borderRadius: BorderRadius.circular(12)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                          tooltip: "Delete Lock",
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (cont) {
                                  return AlertDialog(
                                    title: const Text('BBT Lock'),
                                    content:
                                        const Text('This will delete the Lock'),
                                    actions: [
                                      OutlinedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text('CANCEL'),
                                      ),
                                      OutlinedButton(
                                        onPressed: () async {
                                          _storageController.deleteOneLock(
                                              widget.locksDetails);
                                          Navigator.pushAndRemoveUntil<dynamic>(
                                            context,
                                            MaterialPageRoute<dynamic>(
                                              builder: (BuildContext context) =>
                                                  MyNavigationBar(),
                                            ),
                                            (route) =>
                                                false, //if you want to disable back feature set to false
                                          );
                                        },
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  );
                                });
                          },
                          icon: const Icon(Icons.delete)),
                      // const SizedBox(
                      //   width: 10,
                      // ),
                      // IconButton(
                      //     tooltip: "Refresh Lock",
                      //     onPressed: () {
                      //       _storageController.deleteLocks();
                      //       // Navigator.push(
                      //       //     context,
                      //       //     MaterialPageRoute(
                      //       //         builder: (context) =>
                      //       //             UpdateLockInstallationPage(
                      //       //                 lockDetails: widget.locksDetails)));
                      //     },
                      //     icon: const Icon(Icons.refresh_rounded)),
                      const SizedBox(
                        width: 10,
                      ),
                      IconButton(
                          tooltip: "Show Details",
                          onPressed: () {
                            setState(() {
                              hide = !hide;
                            });
                          },
                          icon: hide
                              ? const Icon(Icons.remove_red_eye)
                              : const Icon(CupertinoIcons.eye_slash_fill)),
                      const SizedBox(
                        width: 10,
                      ),
                      // Transform.scale(
                      //     scale: 1,
                      //     child: Switch(
                      //       onChanged: (value) async {
                      //         if (value) {
                      //           await ApiConnect.hitApiPost(
                      //               "${widget.locksDetails.iPAddress}/Autolock",
                      //               {"AutoLockTime": "ON"});
                      //         } else {
                      //           await ApiConnect.hitApiPost(
                      //               "${widget.locksDetails.iPAddress}/Autolock",
                      //               {"AutoLockTime": "OFF"});
                      //         }

                      //         _storageController.updateLockAutoStatus(
                      //             widget.locksDetails.lockSSID, value);
                      //         Navigator.pushAndRemoveUntil<dynamic>(
                      //           context,
                      //           MaterialPageRoute<dynamic>(
                      //             builder: (BuildContext context) =>
                      //                 MyNavigationBar(),
                      //           ),
                      //           (route) =>
                      //               false, //if you want to disable back feature set to false
                      //         );
                      //       },
                      //       value: widget.locksDetails.isAutoLock,
                      //       activeColor: appBarColour,
                      //       activeTrackColor: backGroundColour,
                      //       inactiveThumbColor: blackColour,
                      //       inactiveTrackColor: whiteColour,
                      //     )),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
