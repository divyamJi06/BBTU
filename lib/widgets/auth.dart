import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:local_auth_ios/local_auth_ios.dart';

import '../utils/contstants.dart';
import 'bottom_nav_bar.dart';
import 'custom_button.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  late final LocalAuthentication auth;
  bool _supportState = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    auth = LocalAuthentication();
    authenticatee();
  }

  authenticatee() async {
    final bool didAuthenticate = await auth.authenticate(
        options: AuthenticationOptions(sensitiveTransaction: true),
        localizedReason: 'Please authenticate to proceed',
        authMessages: const <AuthMessages>[
          AndroidAuthMessages(
            signInTitle: 'Oops! Biometric authentication required!',
            cancelButton: 'No thanks',
          ),
          IOSAuthMessages(
            cancelButton: 'No thanks',
          ),
        ]);

    if (didAuthenticate) {
      setState(() {
        _supportState = true;
        Navigator.pushAndRemoveUntil<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
            builder: (BuildContext context) => MyNavigationBar(),
          ),
          (route) => false, //if you want to disable back feature set to false
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: AppBar(
          iconTheme: IconThemeData(color: appBarColour),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
              size: 30,
            ),
          ),
          backgroundColor: backGroundColour,
          // automaticallyImplyLeading: false,
          title: Text(
            "Authentication",
            style: TextStyle(
                color: appBarColour, fontSize: 40, fontWeight: FontWeight.bold),
          ),
          actions: const [],
          centerTitle: true,
          elevation: 0,
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_supportState
                ? "Verification Successfull"
                : "Verification Not Successfull"),
            SizedBox(
              height: 20,
            ),
            CustomButton(text: "Retry", onPressed: authenticatee),
            CustomButton(
                text: "Continue Without Password",
                onPressed: () {
                  Navigator.pushAndRemoveUntil<dynamic>(
                    context,
                    MaterialPageRoute<dynamic>(
                      builder: (BuildContext context) => MyNavigationBar(),
                    ),
                    (route) =>
                        false, //if you want to disable back feature set to false
                  );
                })
          ],
        ),
      ),
    );
  }
}
