import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/material.dart';
import 'AboutSnab.dart';
import 'Alerts.dart';
import 'Home.dart';
import 'Privacy policy.dart';
import 'faq.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'dart:io' show Platform;
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'NotificationsSettings.dart';
import 'Notifications.dart';
import 'loginscreen.dart';
import 'TermsAndConditions.dart';
import 'resetPassword.dart';
import 'support.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  String os = Platform.operatingSystem;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff000000),
        centerTitle: true,
        elevation: 3,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_outlined,
            color: Color(0xffffd800),
            size: 25,
          ),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Home()),
            );
          },
        ),
//        toolbarHeight: 65,
        title: Text(
          "SETTINGS",
          style: TextStyle(
            color: Color(0xffffd800),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AboutQsnap()),
                  );
                },
                child: Container(
                  // alignment: Alignment.topLeft,
                  height: 30,
                  child: ListTile(
                    title: Text(
                      "ABOUT QSNAP",
                      style: TextStyle(
                          color: Colors.black87,
                          fontSize: 15,
                          fontWeight: FontWeight.w700),
                    ),
                    leading: Icon(
                      Icons.error_outline,
                      size: 25,
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios_sharp,
                      size: 20,
                    ),
                  ),
                ),
              ),
              //  SizedBox(height: 10),
              //
              // GestureDetector(
              //   onTap: () {
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(builder: (context) => NotificationsSettings()),
              //     );
              //   },
              //   child: Container(
              //     // alignment: Alignment.topLeft,
              //     height: 30,
              //     child: ListTile(
              //       title: Text(
              //         "NOTIFICATIONS SETTINGS",
              //         style: TextStyle(
              //             color: Colors.black87,
              //             fontSize: 15,
              //             fontWeight: FontWeight.w700),
              //       ),
              //       leading: Icon(
              //         Icons.notification_important_rounded,
              //         size: 25,
              //       ),
              //       trailing: Icon(
              //         Icons.arrow_forward_ios_sharp,
              //         size: 20,
              //       ),
              //     ),
              //   ),
              // ),
              SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Notifications()),
                  );
                },
                child: Container(
                  // alignment: Alignment.topLeft,
                  height: 30,
                  child: ListTile(
                    title: Text(
                      "NOTIFICATIONS",
                      style: TextStyle(
                          color: Colors.black87,
                          fontSize: 15,
                          fontWeight: FontWeight.w700),
                    ),
                    leading: Icon(
                      Icons.notifications_active,
                      size: 25,
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios_sharp,
                      size: 20,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  _shareText();
                },
                child: Container(
                  height: 30,
                  child: ListTile(
                    title: Text(
                      "SHARE APP",
                      style: TextStyle(
                          color: Colors.black87,
                          fontSize: 15,
                          fontWeight: FontWeight.w700),
                    ),
                    leading: Icon(
                      Icons.share,
                      size: 25,
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios_sharp,
                      size: 20,
                    ),
                  ),
                ),
              ),
              // SizedBox(height: 10),
              // InkWell(
              //   onTap: () {
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(builder: (context) => Alerts()),
              //     );
              //   },
              //   child: Container(
              //     height: 30,
              //     child: ListTile(
              //       title: Text(
              //         "ALERTS",
              //         style: TextStyle(
              //             color: Colors.black87,
              //             fontSize: 15,
              //             fontWeight: FontWeight.w700),
              //       ),
              //       leading: Icon(
              //         Icons.add_alert,
              //         size: 25,
              //       ),
              //       trailing: Icon(
              //         Icons.arrow_forward_ios_sharp,
              //         size: 20,
              //       ),
              //     ),
              //   ),
              // ),
               SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  _showConfirmationAlert(context);
                },
                child: Container(
                  height: 30,
                  child: ListTile(
                    title: Text(
                      "UPGRADE TO GOLD",
                      style: TextStyle(
                          color: Colors.black87,
                          fontSize: 15,
                          fontWeight: FontWeight.w700),
                    ),
                    leading: Icon(
                      Icons.file_upload,
                      size: 25,
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios_sharp,
                      size: 20,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PrivcyPolicy()),
                  );
                },
                child: Container(
                  height: 30,
                  child: ListTile(
                    title: Text(
                      "DATA POLICY",
                      style: TextStyle(
                          color: Colors.black87,
                          fontSize: 15,
                          fontWeight: FontWeight.w700),
                    ),
                    leading: Icon(
                      Icons.security,
                      size: 25,
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios_sharp,
                      size: 20,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Terms()),
                  );
                },
                child: Container(
                  height: 30,
                  child: ListTile(
                    title: Text(
                      "TERMS AND CONDITIONS",
                      style: TextStyle(
                          color: Colors.black87,
                          fontSize: 15,
                          fontWeight: FontWeight.w700),
                    ),
                    leading: Icon(
                      Icons.admin_panel_settings,
                      size: 25,
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios_sharp,
                      size: 20,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  // Or, use a predicate getter.
                  _rateapp();
                },
                child: Container(
                  height: 30,
                  child: ListTile(
                    title: Text(
                      "RATE US",
                      style: TextStyle(
                          color: Colors.black87,
                          fontSize: 15,
                          fontWeight: FontWeight.w700),
                    ),
                    leading: Icon(
                      Icons.rate_review,
                      size: 25,
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios_sharp,
                      size: 20,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FAQ()),
                  );
                },
                child: Container(
                  height: 30,
                  child: ListTile(
                    title: Text(
                      "FAQ",
                      style: TextStyle(
                          color: Colors.black87,
                          fontSize: 15,
                          fontWeight: FontWeight.w700),
                    ),
                    leading: Icon(
                      Icons.help_outline,
                      size: 25,
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios_sharp,
                      size: 20,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Support()),
                  );
                },
                child: Container(
                  height: 30,
                  child: ListTile(
                    title: Text(
                      "SUPPORT",
                      style: TextStyle(
                          color: Colors.black87,
                          fontSize: 15,
                          fontWeight: FontWeight.w700),
                    ),
                    leading: Icon(
                      Icons.support_agent,
                      size: 25,
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios_sharp,
                      size: 20,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Reset_Password()),
                  );
                },
                child: Container(
                  height: 30,
                  child: ListTile(
                    title: Text(
                      "RESET PASSWORD",
                      style: TextStyle(
                          color: Colors.black87,
                          fontSize: 15,
                          fontWeight: FontWeight.w700),
                    ),
                    leading: Icon(
                      Icons.lock,
                      size: 25,
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios_sharp,
                      size: 20,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              GestureDetector(
                onTap: () async {
                  SharedPreferences preferences =
                      await SharedPreferences.getInstance();
                  await preferences.clear();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                },
                child: Container(
                  height: 30,
                  child: ListTile(
                    title: Text(
                      "LOGOUT",
                      style: TextStyle(
                          color: Colors.black87,
                          fontSize: 15,
                          fontWeight: FontWeight.w700),
                    ),
                    leading: Icon(
                      Icons.exit_to_app,
                      size: 25,
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios_sharp,
                      size: 20,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 40,
              ),
              Text(
                "V1.0.3",
                style: TextStyle(
                    color: Colors.black,
                    // color: Colors.black54,
                    fontSize: 18,
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showToast(BuildContext context) {
    final scaffold = Scaffold.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: const Text('im in android'),
        action: SnackBarAction(
            label: 'UNDO', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }
}

Future<void> _shareText() async {
  try {
    Share.text(
        'QSNAP',
        'https://play.google.com/store/apps/details?id=com.optimalsolutions.qsnapapp',
        'text/plain');
  } catch (e) {
    print('error: $e');
  }
}

Future<void> _rateapp() async {
  const urlrate =
      'https://play.google.com/store/apps/details?id=com.optimalsolutions.qsnapapp';
  if (await canLaunch(urlrate)) {
    await launch(urlrate);
  } else {
    await launch(urlrate);
    //throw 'Could not launch $facebook';
  }
}

_showConfirmationAlert(BuildContext context) {
  showPlatformDialog(
    context: context,
    builder: (_) => BasicDialogAlert(
      title: Text(
        " UPGRADE TO GOLD",
        style: TextStyle(color: Colors.black, fontSize: 20),
        textAlign: TextAlign.center,
      ),
      content: Text(
        "Coming Soon.",
        style: TextStyle(fontWeight: FontWeight.w400, fontSize: 17),
        textAlign: TextAlign.center,
      ),
      actions: <Widget>[
        BasicDialogAction(
          title: Text(
            "Ok",
            style: TextStyle(color: Colors.black),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    ),
  );
}
