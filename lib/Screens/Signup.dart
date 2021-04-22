import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/gestures.dart';
import 'dart:async';
import 'dart:convert';
import 'BottomSheetsignup.dart';
import 'city.dart';
import 'country.dart';
import 'loginscreen.dart';
import 'BottomSheetDataPolicy.dart';
import 'package:flutter_country_picker/flutter_country_picker.dart';
import 'package:uuid/uuid.dart';
import 'dart:io' show Platform;
import 'package:onesignal_flutter/onesignal_flutter.dart';

import 'verifyAccount.dart';

class SignupScreen extends StatefulWidget {
  String titlecountry;
  String codecountry;
  String titlecity;
  String codecity;
  String fname;
  String lname;
  String email;
  String mobile;
  String dialingCode;

  SignupScreen(
      {this.titlecountry,
      this.codecountry,
      this.titlecity,
      this.codecity,
      this.fname,
      this.lname,
      this.email,
      this.mobile,
      this.dialingCode});

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool isCheck = false;
  String dialingCodemobile = " ";
  Country _selectedmoble;

  final _formKey = GlobalKey<FormState>();
  TextEditingController _fnameController = TextEditingController();
  TextEditingController _lnameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _mobileController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  String _dropDownValue;
  String _dropDownkey;
  List data = List();

  fnamefun() {
    if (widget.fname != null) {
      return _fnameController.text = widget.fname;
    }
  }

  lnamefun() {
    if (widget.lname != null) {
      return _lnameController.text = widget.lname;
    }
  }

  emailfun() {
    if (widget.email != null) {
      return _emailController.text = widget.email;
    } else {
      return _emailController.text;
    }
  }

  mobilefun() {
    if (widget.mobile != null) {
      return _mobileController.text = widget.mobile;
    }
  }

  dialingCodefun() {
    if (widget.dialingCode != null) {
      return dialingCodemobile = widget.dialingCode;
    } else {
      return dialingCodemobile;
    }
  }

  // Future<String> _getuser() async {
  //   var url = 'http://qsnap.net/api/getCountries';
  //   var response = await http.get(url);
  //   var responsbody = jsonDecode(response.body)["response"]["data"];
  //   setState(() {
  //     data = responsbody;
  //   });
  //   // print(responsbody);
  //   return "Sucess";
  // }

  String _dropDownValuecity;
  List datacity = List();

  Future<String> fetchcity(String code) async {
    var url = 'http://qsnap.net/api/getCitiesByCountry?countryCode=$code';
    var response = await http.get(url);
    var responsbody = jsonDecode(response.body)["response"]["data"];
    setState(() {
      datacity = responsbody;
    });

    // print(responsbody);
    return "Sucess";
  }

  String os = Platform.operatingSystem;

  void postSignup(String fname, String lname, String email, String mobile,
      String password) async {
    String SignApiUrl = "http://qsnap.net/api/register";
    var status = await OneSignal.shared.getPermissionSubscriptionState();

    String uuid = status.subscriptionStatus.userId;
    var response = await http.post(SignApiUrl, body: {
      'fname': widget.fname,
      'lname': widget.lname,
      'email': email,
      'mobile': widget.mobile,
      'countryCode': widget.codecountry,
      'countryId': widget.codecountry,
      'cityId': widget.codecity,
      'password': password,
      'phoneCode': widget.dialingCode,
      'uuid': uuid,
      'version': '1.0.3',
      'platform': os,
    });
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    var result = json.decode(response.body);
    print('Response convert body: ${result}');

    if (result["status"] == 200) {
      if (result["response"]["inserted"] == 1) {
        showPlatformDialog(
          context: context,
          builder: (_) => BasicDialogAlert(
            title: Text(
              "A verification code has been sent to your designated email address please check and verify",
              style: TextStyle(color: Colors.black, fontSize: 20),
              textAlign: TextAlign.center,
            ),
            actions: <Widget>[
              BasicDialogAction(
                title: Text("Ok",
                    style: TextStyle(color: Colors.black, fontSize: 17)),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            verifyAccount(_emailController.text)),
                    // MaterialPageRoute(builder: (context) => verifyAccount(email)),
                  );
                },
              ),
            ],
          ),
        );
      } else {
        _showConfirmationAlert(context);
      }

      print("done signup______------>200");
    } else {
      _phonecodeAlert(context);
    }
  }

  @override
  void initState() {
    this.fnamefun();
    this.lnamefun();
    this.emailfun();
    this.mobilefun();
    this.dialingCodefun();
    super.initState();
    // this._getuser();
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

  Country _selectedf;

  String asset;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onBackPressed,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            centerTitle: true,
            elevation: .5,
            title: Text(
              "SIGN UP",
              style: TextStyle(
                  color: Colors.black87,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2),
            ),
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.black87,
                size: 25,
              ),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                  // MaterialPageRoute(builder: (context) => verifyAccount(email)),
                );
                // Navigator.pop(context);
              },
            ),
          ),
          body: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
            child: ListView(
              children: [
                Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      textDirection: TextDirection.ltr,
                      children: [
                        SizedBox(
                          height: 15,
                        ),
                        Container(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "First Name",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        TextFormField(
                          keyboardType: TextInputType.name,
                          controller: _fnameController,
                          textCapitalization: TextCapitalization.sentences,
                          decoration: InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.fromLTRB(0, 5.0, 0, 5.0),
                            // filled: true,
                            fillColor: Colors.white,
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            disabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                          ),
                          validator: (text) {
                            if (text == null || text.isEmpty) {
                              return 'Please Enter First Name';
                            }
                            return null;
                          },
                        ),
                        //lastname
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: double.infinity,
                          child: Text(
                            "Last Name",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        TextFormField(
                          keyboardType: TextInputType.name,
                          controller: _lnameController,
                          textCapitalization: TextCapitalization.sentences,
                          decoration: InputDecoration(
                              isDense: true,
                              contentPadding:
                                  EdgeInsets.fromLTRB(0, 5.0, 0, 5.0),
                              // filled: true,
                              fillColor: Colors.white,
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              disabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              hintText: ""),
                          validator: (text) {
                            if (text == null || text.isEmpty) {
                              return 'Please Enter Last Name';
                            }
                            return null;
                          },
                        ),
                        //Email
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: double.infinity,
                          child: Text(
                            "Email",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          controller: _emailController,
                          decoration: InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.fromLTRB(0, 5.0, 0, 5.0),
                            // filled: true,
                            fillColor: Colors.white,
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            disabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            hintText: "",
                          ),
                          validator: (text) {
                            if (text == null || text.isEmpty) {
                              return 'Please Enter Email';
                            }
                            return null;
                          },
                        ),
                        //mobile
                        SizedBox(
                          height: 15,
                        ),
                        Container(
                          width: double.infinity,
                          child: Text(
                            "Mobile",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                              flex: 10,
                              child: CountryPicker(
                                dense: false,
                                showFlag: false,
                                //displays flag, true by default
                                showDialingCode: false,
                                //displays dialing code, false by default
                                showName: false,
                                //displays country name, true by default
                                showCurrency: false,
                                //eg. 'British pound'
                                showCurrencyISO: false,
                                //eg. 'GBP'
                                onChanged: (Country country) {
                                  setState(() {
                                    _selectedmoble = country;
                                    dialingCodemobile =
                                        "+" + country.dialingCode;
                                    print(dialingCodemobile);
                                    // String x = country.currencyISO;
                                  });
                                },
                                selectedCountry: _selectedmoble,
                              ),
                            ),
                            Expanded(
                              flex: 15,
                              child: Text(
                                dialingCodemobile,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontSize: 15,
                                  // fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 90,
                              child: TextFormField(
                                keyboardType: TextInputType.phone,
                                controller: _mobileController,
                                decoration: InputDecoration(
                                  isDense: true,
                                  contentPadding:
                                      EdgeInsets.fromLTRB(0, 5.0, 0, 5.0),
                                  // filled: true,
                                  fillColor: Colors.white,
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                  ),
                                  disabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                  ),
                                  // hintText: "Contact",
                                ),
                                validator: (text) {
                                  if (text == null || text.isEmpty) {
                                    return 'Please Enter phone';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 3),
                          child: Divider(
                            height: 1,
                            thickness: 1,
                            color: Colors.grey,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 0, top: 10, bottom: 0.0),
                          child: Container(
                            width: double.infinity,
                            child: Text(
                              "Country",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 15,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),

                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => searchcountry(
                                        fname: _fnameController.text,
                                        lname: _lnameController.text,
                                        email: _emailController.text,
                                        mobile: _mobileController.text,
                                        dialingCode: dialingCodemobile,
                                      )),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.only(top: 15, ),
                            width: double.infinity,
                            alignment: Alignment.topLeft,
                            child: Text(
                              widget.titlecountry,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                // fontWeight: FontWeight.w500,
                                fontSize: 15,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 3),
                          child: Divider(
                            height: 1,
                            thickness: 1,
                            color: Colors.grey,
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.only(
                              left: 0, top: 10, bottom: 0.0),
                          child: Container(
                            width: double.infinity,
                            child: Text(
                              "City",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 15,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => searchcity(
                                        titlecountry: widget.titlecountry,
                                        codecountry: widget.codecountry,
                                        fname: widget.fname,
                                        lname: widget.lname,
                                        email: widget.email,
                                        mobile: widget.mobile,
                                        dialingCode: widget.dialingCode,
                                      )),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.only(top: 15, ),

                            // height: 35,
                            width: double.infinity,
                            alignment: Alignment.topLeft,
                            child: Text(
                              widget.titlecity,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                // fontWeight: FontWeight.w500,
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        // Container(
                        //   height: 35,
                        //   child: Padding(
                        //     padding: const EdgeInsets.only(left: 0,right: 15),
                        //     child: DropdownButtonHideUnderline(
                        //       child: DropdownButton(
                        //         hint: _dropDownValuecity == null
                        //             ? Text('City')
                        //             : Text(
                        //           _dropDownValuecity,
                        //           style: TextStyle(
                        //               color: Colors.black,
                        //               fontWeight: FontWeight.bold),
                        //         ),
                        //         isExpanded: true,
                        //         iconSize: 30.0,
                        //         style: TextStyle(color: Colors.black87),
                        //         items: datacity.map(
                        //               (val) {
                        //             return DropdownMenuItem<String>(
                        //               value: val['id'],
                        //               child: Text(val['name']),
                        //             );
                        //           },
                        //         ).toList(),
                        //         onChanged: (newVal) {
                        //           setState(
                        //                 () {
                        //               _dropDownValuecity = newVal;
                        //               print(datacity);
                        //               // var data = [{'id': 1, 'descripcion': 'Asier'}, {'id': 2, 'descripcion': 'Pepe'}];
                        //               // var estateSelected = data.firstWhere((dropdown) => dropdown['id'] == 1);
                        //               // print(estateSelected);
                        //               print("_dropDownValuecity------>"+_dropDownValuecity);
                        //             },
                        //           );
                        //         },
                        //         value: _dropDownValuecity,
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 0),
                          child: Divider(
                            height: 1,
                            thickness: 1,
                            color: Colors.grey,
                          ),
                        ),
                        //password
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: double.infinity,
                          child: Text(
                            "Password",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        Container(
                          height: 35,
                          child: TextFormField(
                            keyboardType: TextInputType.visiblePassword,
                            controller: _passwordController,
                            decoration: InputDecoration(
                                // filled: true,
                                isDense: true,
                                contentPadding:
                                    EdgeInsets.fromLTRB(0, 5.0, 0, 5.0),
                                fillColor: Colors.white,
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                disabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                // hintText: "Password",
                                suffixIcon: FlatButton(
                                    onPressed: _toggle,
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(left: 25.0),
                                      child: Icon(Icons.remove_red_eye,
                                          color: _obscureText
                                              ? Colors.black12
                                              : Colors.black54),
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
                        ),
                        SizedBox(
                          height: 10,
                          width: double.infinity,
                        ),

                        // SizedBox(
                        //   height: 10,
                        //   width: double.infinity,
                        // ),
                        Row(
                          children: [
                            Expanded(
                              flex: 10,
                              child: Checkbox(
                                  value: isCheck,
                                  checkColor: Color(0xffffd800),
                                  // color of tick Mark
                                  activeColor: Colors.black87,
                                  onChanged: (bool value) {
                                    setState(() {
                                      isCheck = value;
                                    });
                                  }),
                            ),
                            Expanded(
                              flex: 5,
                              child: SizedBox(
                                width: 0,
                              ),
                            ),
                            Expanded(
                              flex: 85,
                              child: RichText(
                                text: TextSpan(
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                  ),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text:
                                          "By checking this box you are confirming you are 16 years or over agreeing to our  ",
                                    ),
                                    TextSpan(
                                        text: 'Terms & Conditions',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            showModalBottomSheet<void>(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return BottomSheetWidget();
                                              },
                                            );
                                          }),
                                    TextSpan(text: ' and '),
                                    TextSpan(
                                        text: 'Data Policy',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            showModalBottomSheet<void>(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return BottomSheetDataPolicy();
                                              },
                                            );
                                          }),
                                    TextSpan(text: ' .*'),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 25,
                          width: double.infinity,
                        ),
                        SizedBox(
                          height: 40,
                          width: double.infinity,
                          child: RaisedButton(
                              color: Colors.black87,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: Text(
                                "SUBMIT",
                                style: TextStyle(
                                    color: Color(0xffffd800), fontSize: 18),
                              ),
                              onPressed: () {
                                print("onPressed-------------->");
                                if (isCheck == true) {
                                  print("true-------------->");
                                  if (_formKey.currentState.validate()) {

                                    postSignup(
                                        _fnameController.text,
                                        _lnameController.text,
                                        _emailController.text,
                                        _mobileController.text,
                                        _passwordController.text);
                                  }
                                } else {
                                  print("else-------------->");
                                  _agreeAlert(context);
                                }
                              }),
                        ),
                      ],
                    ),
                  ),
                ),
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
              content: Text('Would you like to go login?'),
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
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                      // MaterialPageRoute(builder: (context) => verifyAccount(email)),
                    ); //Will exit the App
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
        " This Email Already Exists",
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

_agreeAlert(BuildContext context) {
  showPlatformDialog(
    context: context,
    builder: (_) => BasicDialogAlert(
      title: Text(
        " Please agree on terms and conditions",
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

_phonecodeAlert(BuildContext context) {
  showPlatformDialog(
    context: context,
    builder: (_) => BasicDialogAlert(
      title: Text(
        " Please Enter phoneCode",
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
