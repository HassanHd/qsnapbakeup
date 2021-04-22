import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:page_transition/page_transition.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:uuid/uuid.dart';
import 'Screens/DescriptionNotifiWeb.dart';
import 'Screens/loginscreen.dart';
import 'Screens/splash.dart';
import 'Screens/Chat.dart';
import 'Screens/nave.dart';
import 'Screens/DescriptionNotification.dart';
import 'Screens/addnewwellite.dart';
import 'package:device_id/device_id.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  OneSignal.shared
      .init("f2053935-10bf-436e-b125-03ecea8fe244", iOSSettings: null);
  OneSignal.shared
      .setInFocusDisplayType(OSNotificationDisplayType.notification);
  OneSignal.shared.setNotificationOpenedHandler((notification) {
    var notify = notification.notification.payload.additionalData;
print("notify[]---------");
print(notify);
    if (notify["page"] == "notification") {
      NavigationService.instance.navigationKey.currentState.pushReplacementNamed(
        "DescriptionNotifiWeb",
        arguments: {"id": notify["id"],},
      );
    }
   else if (notify["page"] == "chat") {
      NavigationService.instance.navigationKey.currentState.pushReplacementNamed(
        "ChatPage",
        arguments: {
          "id": notify["id"],
          "sender_id": notify["sender_id"],
          "receiver_name": notify["receiver_name"],
          "receiverId": notify["receiverId"],
        },
      );
    }



  });
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: NavigationService.instance.navigationKey,
      routes: {
        "addnewwilite": (BuildContext context) => addnewwilite(),
        "ChatPage": (BuildContext context) => ChatPage(),
        "DescriptionNotification": (BuildContext context) => DescriptionNotification(),
        "DescriptionNotifiWeb": (BuildContext context) => DescriptionNotifiWeb(),
      },
      title: 'QSNAP',
      debugShowCheckedModeBanner: false,
      home: Splashscreen(),
    );
  }
}
