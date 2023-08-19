import 'dart:async';
import 'package:flutter/material.dart';
import '../controller/api.dart';
import '../utils/contstants.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/custom_app_bar.dart';

class LockOnOff extends StatefulWidget {
  const LockOnOff(
      {required this.IP,
      required this.lockPassKey,
      required this.lockID,
      super.key});
  final String IP;
  final String lockID;
  final String lockPassKey;
  @override
  State<LockOnOff> createState() => _LockOnOffState();
}

class _LockOnOffState extends State<LockOnOff> {
  String lockStatus = "Closed";
  bool lockClosed = true;
  late Timer _timer;

  @override
  void initState() {
    // TODO: implement initState
    _timer = Timer(const Duration(seconds: 20), () {
      _navigateToNextPage();
    });
    super.initState();
    updateLock();
  }

  void _navigateToNextPage() {
    Navigator.pushAndRemoveUntil<dynamic>(
      context,
      MaterialPageRoute<dynamic>(
        builder: (BuildContext context) => MyNavigationBar(),
      ),
      (route) => false, //if you want to disable back feature set to false
    );
  }

  void _buttonPressed() {
    _timer.cancel();
    _timer = Timer(const Duration(seconds: 20), () {
      _navigateToNextPage();
    });
  }

  void updateLock() async {
    String res = await ApiConnect.hitApiGet("${widget.IP}/lockstatus");
    setState(() {
      if (res == "OK CLOSE") {
        lockClosed = true;
        lockStatus = "Closed";
      } else {
        lockClosed = false;
        lockStatus = "Open";
      }
    });
    _buttonPressed();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: updateLock,
        child: const Icon(Icons.refresh_rounded),
      ),
      appBar: PreferredSize(
        child: CustomAppBar(heading: ""),
        preferredSize: const Size.fromHeight(60),
      ),
      body: Center(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(color: backGroundColour),
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    "The status of the Lock is ",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
                  ),
                  Text(
                    lockStatus.toUpperCase(),
                    style: const TextStyle(
                        fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height / 2,
              decoration: BoxDecoration(
                  color: whiteColour, borderRadius: BorderRadius.circular(40)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                      onTap: () async {
                        _buttonPressed();
                        try {
                          String res = await ApiConnect.hitApiGet(
                              "${widget.IP}/lockstatus");
                          if (res == "OK CLOSE") {
                            ApiConnect.hitApiPost("${widget.IP}/getlockcmd", {
                              "Lock_id": widget.lockID,
                              "lock_passkey": widget.lockPassKey,
                              "lock_cmd": "ON"
                            });
                            setState(() {
                              lockClosed = false;
                              lockStatus = "Open";
                            });
                          } else if (res == "OK OPEN") {
                            ApiConnect.hitApiPost("${widget.IP}/getlockcmd", {
                              "Lock_id": widget.lockID,
                              "lock_passkey": widget.lockPassKey,
                              "lock_cmd": "OFF"
                            });
                            setState(() {
                              lockStatus = "Closed";
                              lockClosed = true;
                            });
                          } else {}
                          // res = await ApiConnect.hitApiGet(
                          //     widget.IP + "/lockstatus");
                          // ApiConnect.hitApiPost(routerIP + "/getlockCMD", {});
                        } catch (e) {
                          final scaffold = ScaffoldMessenger.of(context);
                          scaffold.showSnackBar(
                            const SnackBar(
                              content: Text("Unable to perform"),
                              // action: SnackBarAction(
                              // label: 'UNDO',
                              // onPressed: scaffold.hideCurrentSnackBar),
                            ),
                          );
                        } finally {
                          _buttonPressed();
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade400,
                              // spreadRadius: 5,
                              blurRadius: 7,
                              offset: const Offset(
                                  5, 5), // changes position of shadow
                            ),
                          ],
                        ),
                        child: CircleAvatar(
                          radius: 100,
                          child: Icon(
                            Icons.power_settings_new_outlined,
                            size: 60,
                            color: lockClosed
                                ? redButtonColour
                                : greenButtonColour,
                          ),
                          backgroundColor: lockClosed ? redColour : greenColour,
                        ),
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
