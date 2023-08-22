import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:permission_handler/permission_handler.dart';

import '../controller/permission.dart';
import '../utils/contstants.dart';
import '../views/lock_page.dart';
import '../views/router_page.dart';

class MyNavigationBar extends StatefulWidget {
  MyNavigationBar({Key? key}) : super(key: key);

  @override
  _MyNavigationBarState createState() => _MyNavigationBarState();
}

class _MyNavigationBarState extends State<MyNavigationBar> {
  late final LocalAuthentication auth;
  bool _supportState = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // auth.isDeviceSupported().then((value) {
    //   setState(() async {
    //     _supportState = value;
    //     if (value) {
    //       List<BiometricType> biometrics = await auth.getAvailableBiometrics();
    //       print(biometrics);
    //     }
    //   });
    // });

    requestPermission(Permission.camera);
    requestPermission(Permission.location);
    // requestPermission(Permission.accessMediaLocation);
  }


  int _selectedIndex = 0;
  static final List<Widget> _widgetOptions = <Widget>[
    RouterPage(),
    LockPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //     title: const Text('BelBird BTLock-I'), backgroundColor: backGroundColour),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: const Icon(Icons.wifi_outlined),
              label: ('Router'),
              backgroundColor: backGroundColour,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.lock_rounded),
              label: ('Locks'),
              backgroundColor: backGroundColour,
            ),
          ],
          type: BottomNavigationBarType.shifting,
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.black,
          iconSize: 40,
          onTap: _onItemTapped,
          elevation: 5),
    );
  }
}
