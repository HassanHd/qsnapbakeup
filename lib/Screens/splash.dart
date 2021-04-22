import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:page_transition/page_transition.dart';
import 'loginscreen.dart';
import 'package:device_id/device_id.dart';
class Splashscreen extends StatefulWidget {
  @override
  _SplashscreenState createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  var idchick;
  getlogin() async {
    String deviceid = await DeviceId.getID;
    print(deviceid);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    idchick = prefs.get("id");
    print(idchick);
    setState(() {
      idchick = prefs.get("id");
      print(idchick);
    });
  }
  @override
  void initState() {
    this.getlogin();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    if(idchick!=null){
    return AnimatedSplashScreen(
    duration: 0,
    splash: "assats/images/logowhite.png",
    splashIconSize: 100,
    nextScreen: LoginScreen(),
    splashTransition: SplashTransition.slideTransition,
    pageTransitionType: PageTransitionType.fade,
    backgroundColor: Colors.black
    );
    }
    else{
      return  AnimatedSplashScreen(
          duration: 9000,
          splash: "assats/images/Qsnap.gif",
          splashIconSize: double.infinity,
          nextScreen: LoginScreen(),
          splashTransition: SplashTransition.slideTransition,
          pageTransitionType: PageTransitionType.bottomToTop,
          backgroundColor: Colors.black
      );
    }
  }
}
