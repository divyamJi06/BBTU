import 'custom_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import '../utils/contstants.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:local_auth_ios/local_auth_ios.dart';

import 'bottom_nav_bar.dart';
import 'custom_app_bar.dart';

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
        child: CustomAppBar(heading: "Authentication"),
        preferredSize: const Size.fromHeight(60),
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
            CustomButton(text: "Retry", onPressed: authenticatee)
          ],
        ),
      ),
    );
  }
}
