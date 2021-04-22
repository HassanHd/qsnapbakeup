// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:async';
// import 'dart:convert';
// import 'package:uuid/uuid.dart';
// import 'dart:io' show Platform;
// import 'dart:io';
// import 'package:flutter/services.dart';
// import 'package:uni_links/uni_links.dart';
// import 'Home.dart';
// import 'addnewwellite.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class uniserv extends StatefulWidget {
//   @override
//   _uniservState createState() => _uniservState();
// }
// enum UniLinksType { string, uri }
//
// class _uniservState extends State<uniserv> {
//   var uuid = Uuid();
//   var idchick;
//   String latestLink = 'Unknown';
//   Uri latestUri;
//   StreamSubscription sub;
//   UniLinksType type = UniLinksType.string;
//
//
//   @override
//   dispose() {
//     if (sub != null) sub.cancel();
//     super.dispose();
//   }
//
//   // Platform messages are asynchronous, so we initialize in an async method.
//   initPlatformState() async {
//     if (type == UniLinksType.string) {
//       await initPlatformStateForStringUniLinks();
//     } else {
//       await initPlatformStateForUriUniLinks();
//     }
//   }
//
//   /// An implementation using a [String] link
//     initPlatformStateForStringUniLinks() async {
//     // Attach a listener to the links stream
//     sub = getLinksStream().listen((String link) {
//       if (!mounted) return;
//       setState(() {
//         latestLink = link ?? 'Unknown';
//         latestUri = null;
//         try {
//           if (link != null){
//             latestUri = Uri.parse(link);
//             if (idchick != null) {
//               Navigator.of(context)
//                   .pushReplacement(MaterialPageRoute(builder: (context) => addnewwilite(idchick,link)));
//             }}
//         } on FormatException {}
//       });
//     }, onError: (err) {
//       if (!mounted) return;
//       setState(() {
//         latestLink = 'Failed to get latest link: $err.';
//         latestUri = null;
//       });
//     });
//
//     // Attach a second listener to the stream
//     getLinksStream().listen((String link) {
//       print('got link: $link');
//     }, onError: (err) {
//       print('got err: $err');
//     });
//
//     // Get the latest link
//     String initialLink;
//     Uri initialUri;
//     // Platform messages may fail, so we use a try/catch PlatformException.
//     try {
//       initialLink = await getInitialLink();
//       print('initial link: $initialLink');
//       if (initialLink != null){
//         print('initial link: $initialLink');
//         initialUri = Uri.parse(initialLink);
//         if (idchick != null) {
//           print('initial link: $initialLink');
//           Navigator.of(context)
//               .pushReplacement(
//               MaterialPageRoute(builder: (context) => addnewwilite(idchick,initialLink)));
//         }
//
//       }
//     } on PlatformException {
//       initialLink = 'Failed to get initial link.';
//       initialUri = null;
//     } on FormatException {
//       initialLink = 'Failed to parse the initial link as Uri.';
//       initialUri = null;
//     }
//
//     // If the widget was removed from the tree while the asynchronous platform
//     // message was in flight, we want to discard the reply rather than calling
//     // setState to update our non-existent appearance.
//     if (!mounted) return;
//
//     setState(() {
//       latestLink = initialLink;
//       latestUri = initialUri;
//     });
//   }
//
//   /// An implementation using the [Uri] convenience helpers
//   initPlatformStateForUriUniLinks() async {
//     // Attach a listener to the Uri links stream
//     sub = getUriLinksStream().listen((Uri uri) {
//       if (!mounted) return;
//       setState(() {
//         latestUri = uri;
//         latestLink = uri?.toString() ?? 'Unknown';
//       });
//     }, onError: (err) {
//       if (!mounted) return;
//       setState(() {
//         latestUri = null;
//         latestLink = 'Failed to get latest link: $err.';
//       });
//     });
//
//     // Attach a second listener to the stream
//     getUriLinksStream().listen((Uri uri) {
//       print('got uri: ${uri?.path} ${uri?.queryParametersAll}');
//     }, onError: (err) {
//       print('got err: $err');
//     });
//
//     // Get the latest Uri
//     Uri initialUri;
//     String initialLink;
//     // Platform messages may fail, so we use a try/catch PlatformException.
//     try {
//       initialUri = await getInitialUri();
//       print('initial uri: ${initialUri?.path}'
//           ' ${initialUri?.queryParametersAll}');
//       initialLink = initialUri?.toString();
//     } on PlatformException {
//       initialUri = null;
//       initialLink = 'Failed to get initial uri.';
//     } on FormatException {
//       initialUri = null;
//       initialLink = 'Bad parse the initial link as Uri.';
//     }
//
//     // If the widget was removed from the tree while the asynchronous platform
//     // message was in flight, we want to discard the reply rather than calling
//     // setState to update our non-existent appearance.
//     if (!mounted) return;
//     setState(() {
//       latestUri = initialUri;
//       latestLink = initialLink;
//     });
//   }
//   getlogin() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     idchick = prefs.get("id");
//     setState(() {
//       if (idchick != null) {
//         // wrong call in wrong place!
//         Navigator.of(context)
//             .pushReplacement(MaterialPageRoute(builder: (context) => Home()));
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container();
//   }
// }
