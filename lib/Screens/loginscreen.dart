import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'Signup.dart';
import 'forgotpassword.dart';
import 'Home.dart';
import 'nave.dart';
import 'addnewwellite.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:uuid/uuid.dart';
import 'dart:io' show Platform;
import 'dart:io';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import 'package:flutter/services.dart';
import 'package:uni_links/uni_links.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

enum UniLinksType { string, uri }

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _varifiController = TextEditingController();
  var uuid = Uuid();
  var idchick;
  String _latestLink = 'Unknown';
  Uri _latestUri;
  StreamSubscription _sub;
  UniLinksType _type = UniLinksType.string;

  @override
  dispose() {
    if (_sub != null) _sub.cancel();
    super.dispose();
  }


  initPlatformState() async {
    if (_type == UniLinksType.string) {
      await initPlatformStateForStringUniLinks();
    } else {
      await initPlatformStateForUriUniLinks();
    }
  }

  /// An implementation using a [String] link
  initPlatformStateForStringUniLinks() async {
    // Attach a listener to the links stream
    _sub = getLinksStream().listen((String link) {
      if (!mounted) return;
      setState(() {
        _latestLink = link ?? 'Unknown';
        _latestUri = null;
        try {
          if (link != null) {
            _latestUri = Uri.parse(link);
            if (idchick != null) {
              // Navigator.of(context)
              //    .pushReplacement(MaterialPageRoute(builder: (context) => addnewwilite(idchick: idchick,initialLink: link,)));
              // NavigationService.instance.navigateToReplacement("addnewwilite");
              NavigationService.instance.navigationKey.currentState.pushReplacementNamed(
                "addnewwilite",
                arguments: {"idchick": idchick,"initialLink":link},
              );
            }
          }
        } on FormatException {}
      });
    }, onError: (err) {
      if (!mounted) return;
      setState(() {
        _latestLink = 'Failed to get latest link: $err.';
        _latestUri = null;
      });
    });

    // Attach a second listener to the stream
    getLinksStream().listen((String link) {
      print('got link: $link');
      if (idchick != null) {
        NavigationService.instance.navigationKey.currentState.pushReplacementNamed(
          "addnewwilite",
          arguments: {"idchick": idchick,"initialLink":link},
        );
      }
    }, onError: (err) {
      print('got err: $err');
    });

    // Get the latest link
    String initialLink;
    Uri initialUri;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      initialLink = await getInitialLink();
      print('initial link: $initialLink');
      if (initialLink != null) {
        print('initial link: $initialLink');
        initialUri = Uri.parse(initialLink);
        if (idchick != null) {
          print('initial link: $initialLink');
          // Navigator.of(context)
          //     .pushReplacement(
          //     MaterialPageRoute(builder: (context) => addnewwilite()));
          // NavigationService.instance.navigateToReplacement("addnewwilite");
          // Navigator.of(context).pushReplacementNamed(
          //   "addnewwilite",
          //   arguments: {"idchick": idchick,"initialLink":link},
          NavigationService.instance.navigationKey.currentState.pushReplacementNamed(
            "addnewwilite",
            arguments: {"idchick": idchick,"initialLink":initialLink},
          );

        }
      }
    } on PlatformException {
      initialLink = 'Failed to get initial link.';
      initialUri = null;
    } on FormatException {
      initialLink = 'Failed to parse the initial link as Uri.';
      initialUri = null;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _latestLink = initialLink;
      _latestUri = initialUri;
    });
  }

  /// An implementation using the [Uri] convenience helpers
  initPlatformStateForUriUniLinks() async {
    // Attach a listener to the Uri links stream
    _sub = getUriLinksStream().listen((Uri uri) {
      if (!mounted) return;
      setState(() {
        _latestUri = uri;
        _latestLink = uri?.toString() ?? 'Unknown';
      });
    }, onError: (err) {
      if (!mounted) return;
      setState(() {
        _latestUri = null;
        _latestLink = 'Failed to get latest link: $err.';
      });
    });

    // Attach a second listener to the stream
    getUriLinksStream().listen((Uri uri) {
      print('got uri: ${uri?.path} ${uri?.queryParametersAll}');
    }, onError: (err) {
      print('got err: $err');
    });

    // Get the latest Uri
    Uri initialUri;
    String initialLink;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      initialUri = await getInitialUri();
      print('initial uri: ${initialUri?.path}'
          ' ${initialUri?.queryParametersAll}');
      initialLink = initialUri?.toString();
    } on PlatformException {
      initialUri = null;
      initialLink = 'Failed to get initial uri.';
    } on FormatException {
      initialUri = null;
      initialLink = 'Bad parse the initial link as Uri.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
    setState(() {
      _latestUri = initialUri;
      _latestLink = initialLink;
    });
  }


  void getLogin(String email, String password) async {
    print("email------>$email");
    print("password------>$password");
    String os = Platform.operatingSystem;
    // String o = Platform.i;
    print(os);
    var status = await OneSignal.shared.getPermissionSubscriptionState();

    String onesignalUserId = status.subscriptionStatus.userId;
    var uuidlogin = onesignalUserId;
    print("uuidlogin------>$uuidlogin");
    String loginApiUrl =
        "http://qsnap.net/api/signin?email=$email&password=$password&uuid=$uuidlogin &platform=$os&version=1.0.3";
    var searchResult = await http.get(loginApiUrl);
    var result = json.decode(searchResult.body);
    var acount = result["response"]["status"];
    print("acount--------------->"+acount.toString());
    print("loginApiUrl--------------->"+loginApiUrl);
    if (result["status"] == 200) {
      if (result["response"]["status"] == 4) {
        setState(() {
          String id = result["response"]["customer"]["id"];
          String fname = result["response"]["customer"]["fname"];
          String lname = result["response"]["customer"]["lname"];
          String name = fname+' '+lname;
          print("name------>$name");
          savename(name);
          savelogin(id);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Home()),
          );
        });
      } else if (result["response"]["status"] == 0) {
        _customernotfound(context);
      } else if (result["response"]["status"] == 1) {
        _showConfirmationAlert(context);
      } else if (result["response"]["status"] == 2) {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("Check your email for the verification code ",
                    style: TextStyle(color: Colors.black, fontSize: 20)),
                content: TextField(
                  controller: _varifiController,
                ),
                actions: [
                  MaterialButton(
                    elevation: 5.0,
                    child: Text("OK",
                        style: TextStyle(
                          color: Colors.black,
                        )),
                    onPressed: () {
                      getvirifi(_emailController.text, _varifiController.text);
                      // item.add(customController.text);
                      setState(() {});
                      Navigator.of(context).pop();
                    },
                  )
                ],
              );
            });
      } else {
        _showConfirmationAlert(context);
      }
    }
  }

  savelogin(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("id", id);
    idchick = prefs.get("id");

  }
  savename(String name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("name", name);
  }

  getlogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    idchick = prefs.get("id");
    setState(() {
      if (idchick != null) {
        // wrong call in wrong place!
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (context) => Home()));
      }
    });
  }

  void getvirifi(String email, String varifi) async {
    print("email------>$email");
    print("password------>$varifi");
    String loginApiUrl =
        "http://qsnap.net/api/verifyAccount?email=$email&code=$varifi";
    var searchResult = await http.get(loginApiUrl);
    var result = json.decode(searchResult.body);
    var acount = result["response"]["status"];
    print("acount--------------->" + acount.toString());
    if (result["status"] == 200) {
      if (result["response"]["verified"] == 2) {
        var idddd = result["response"]["customerId"];
        setState(() {
          savelogin(idddd);

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Home()),
          );
        });
      }
    }
  }

  void _showToastany(BuildContext context) {
    final scaffold = Scaffold.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: const Text('You do not have any  an account'),
        action: SnackBarAction(
            label: 'UNDO', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }

  // Initially password is obscure
  bool _obscureText = true;

  String _password;

  // Toggles the password show status
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  void initState() {
    this.getlogin();
    initPlatformState();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onBackPressed,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 5.0, vertical: 20.0),
            child: ListView(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height / 10,
                ),
                Image.asset(
                  'assats/images/logo-colored.png',
                  height: MediaQuery.of(context).size.height / 12,
                  width: MediaQuery.of(context).size.width / 2,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(height: 10),
                    Form(
                      key: _formKey,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          textDirection: TextDirection.ltr,
                          children: [
                            /***********/
                            SizedBox(
                              height: 40,
                            ),
                            // Container(
                            //   alignment: Alignment.topLeft,
                            //   child: Text(
                            //     "Email",
                            //     textAlign: TextAlign.left,
                            //     style: TextStyle(
                            //       fontWeight: FontWeight.w800,
                            //       fontSize: 14,
                            //       color: Colors.grey,
                            //     ),
                            //   ),
                            // ),
                            TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                  isDense: true,
                                  contentPadding:
                                      EdgeInsets.fromLTRB(0, 5.0, 0, 5.0),
                                  // filled: true,
                                  fillColor: Colors.white,
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.grey.shade500),
                                  ),
                                  disabledBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.grey.shade500),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.grey.shade500),
                                  ),
                                  hintText: "",
                                  labelText: "Email",
                                  labelStyle:TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 15,
                                    color: Colors.grey,
                                  )

                              ),
                              validator: (text) {
                                if (text == null || text.isEmpty) {
                                  return 'Please Enter Email';
                                }
                                return null;
                              },
                            ),

                           // Container(
                           //   alignment: Alignment.topLeft,
                           //     padding: const EdgeInsets.only(top:5.0),
                           //   child: Text(
                           //        "Password",
                           //        textAlign: TextAlign.left,
                           //        style: TextStyle(
                           //          fontWeight: FontWeight.w800,
                           //          fontSize: 14,
                           //          color: Colors.grey,
                           //        ),
                           //      ),
                           //    ),
                            TextFormField(
                                  controller: _passwordController,
                                  keyboardType: TextInputType.visiblePassword,
                                  decoration: InputDecoration(
                                      isDense: false,
                                      contentPadding:
                                          EdgeInsets.fromLTRB(0, 5.0, 0, 5.0),
                                      // filled: true,
                                      fillColor: Colors.white,
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.grey),
                                      ),
                                      disabledBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.grey),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.grey),
                                      ),
                                      hintText: "",
                                      labelText: "Password",
                                      labelStyle:TextStyle(
                                        fontWeight: FontWeight.w800,
                                        fontSize: 15,
                                        color: Colors.grey,
                                      ) ,
                                      suffixIcon: FlatButton(
                                          onPressed: _toggle,
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(left: 30.0,bottom: 0),
                                            child: Icon(Icons.remove_red_eye,
                                                color: _obscureText
                                                    ? Colors.black12
                                                    : Colors.black87),
                                          ))),
                                  obscureText: _obscureText,
                                  onSaved: (val) => _password = val,
                                  validator: (text) {
                                    if (text == null || text.isEmpty) {
                                      return 'Please Enter Password';
                                    }
                                    return null;
                                  },
                                ),


                            SizedBox(
                              height: 10,
                              width: double.infinity,
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Forgotpassword()),
                                );
                              },
                              child: Container(
                                width: double.infinity,
                                child: Text(
                                  "Forgot Password ?",
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 25,
                              width: double.infinity,
                            ),
                            SizedBox(
                              height: 40,
                              width: double.infinity,
                              child: RaisedButton(
                                  color: Colors.black,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  child: Text(
                                    "LOGIN",
                                    style: TextStyle(
                                        color: Color(0xffffd800), fontSize: 18),
                                  ),
                                  onPressed: () {
                                    if (_formKey.currentState.validate()) {
                                      getLogin(_emailController.text,
                                          _passwordController.text);
                                    }
                                  }),
                            ),
                            SizedBox(
                              height: 20,
                              width: double.infinity,
                            ),
                            Container(
                              width: double.infinity,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 40,
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    child: Text(
                                      " Don't have an account? ",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w800,
                                        fontSize: 15,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    child: Container(
                                      child: Text(
                                        " SIGN UP",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => SignupScreen(
                                                  titlecountry: "",
                                                  codecountry: "",
                                                  titlecity: "",
                                                  codecity: "",
                                                )),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ));
  }

  Future<bool> _onBackPressed() {
    return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Confirm'),
              content: Text('Do you want to exit the App'),
              actions: <Widget>[
                FlatButton(
                  child: Text('No'),
                  onPressed: () {
                    Navigator.of(context).pop(false); //Will not exit the App
                  },
                ),
                FlatButton(
                  child: Text('Yes'),
                  onPressed: () {
                    Navigator.of(context).pop(true); //Will exit the App
                  },
                )
              ],
            );
          },
        ) ??
        false;
  }
}

_showConfirmationAlert(BuildContext context) {
  showPlatformDialog(
    context: context,
    builder: (_) => BasicDialogAlert(
      title: Text(
        " Please enter the correct password",
        style: TextStyle(color: Colors.black, fontSize: 20),
        textAlign: TextAlign.center,
      ),
      actions: <Widget>[
        BasicDialogAction(
          title:
              Text("Ok", style: TextStyle(color: Colors.black, fontSize: 17)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    ),
  );
}

_customernotfound(BuildContext context) {
  showPlatformDialog(
    context: context,
    builder: (_) => BasicDialogAlert(
      title: Text(
        " Please enter the correct email",
        style: TextStyle(color: Colors.black, fontSize: 20),
        textAlign: TextAlign.center,
      ),
      actions: <Widget>[
        BasicDialogAction(
          title:
              Text("Ok", style: TextStyle(color: Colors.black, fontSize: 17)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    ),
  );
}
