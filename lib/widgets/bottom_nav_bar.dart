import 'package:bbtu/controller/permission.dart';
import 'package:bbtu/views/lock_page.dart';
import 'package:bbtu/views/router_page.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import '../utils/contstants.dart';

class MyNavigationBar extends StatefulWidget {
  MyNavigationBar({Key? key}) : super(key: key);

  @override
  _MyNavigationBarState createState() => _MyNavigationBarState();
}

class _MyNavigationBarState extends State<MyNavigationBar> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
