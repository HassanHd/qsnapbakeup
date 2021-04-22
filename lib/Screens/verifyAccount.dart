import 'package:flutter/material.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:convert';
import 'Editprofile.dart';
import 'Home.dart';
import 'Signup.dart';

class verifyAccount extends StatefulWidget {
  var email;

  verifyAccount(this.email);

  @override
  _verifyAccountState createState() => _verifyAccountState();
}

class _verifyAccountState extends State<verifyAccount> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _codeController = TextEditingController();
  TextEditingController _emailController = TextEditingController();

  savelogin(String id) async {
    print("email------>${widget.email}");

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("id", id);
  }

  void getvirifi(var varifi) async {
    print("password------>$varifi");
    print("email------>${widget.email}");

    String loginApiUrl = "http://qsnap.net/api/verifyAccount?email=${widget.email}&code=$varifi";
    var searchResult = await http.get(loginApiUrl);
    var result = json.decode(searchResult.body);
    var acount = result["response"]["status"];
    if (result["status"] == 200) {
      if (result["response"]["verified"] == 2) {
        var idddd = result["response"]["customerId"];
        print("idd-------->"+idddd);
        setState(() {
          savelogin(idddd);
          _showvrfieAlert(context);

        });
      }
    }
  }

  void resendCode(var email) async {
    print("email------>$email");
    String loginApiUrl =
        "http://qsnap.net/api/resendVerificationMail?email=$email";
    var searchResult = await http.get(loginApiUrl);
    var result = json.decode(searchResult.body);
    if (result["status"] == 200) {
      _showConfirmationAlert(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: .5,
        title: Text(
          "ACCOUNT VERIFICATION",
          style: TextStyle(
            color: Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
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
              MaterialPageRoute(
                  builder: (context) => SignupScreen(
                    titlecountry: "",
                    codecountry: "",
                    titlecity: "",
                    codecity: "",
                  )),
              // MaterialPageRoute(builder: (context) => verifyAccount(email)),
            );
            // Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
        child: ListView(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height / 20,
            ),
            Image.asset(
              'assats/images/logo-colored.png',
              height: MediaQuery.of(context).size.height / 12,
              width: MediaQuery.of(context).size.width / 2,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      textDirection: TextDirection.ltr,
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "A verification code has been sent to your designated email address please check and verify.",
                          textAlign: TextAlign.center,

                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 17,

                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),

                        Container(
                          width: double.infinity,
                          child: Text(
                            "Code",
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
                          controller: _codeController,
                          decoration: InputDecoration(
                              // filled: true,
                            isDense: true,
                            contentPadding: EdgeInsets.fromLTRB(0, 5.0, 0, 5.0),
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
                              // hintText: "Code"
                          ),
                          validator: (text) {
                            if (text == null || text.isEmpty) {
                              return 'Please Enter Code';
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 20,
                          width: double.infinity,
                        ),
                        InkWell(
                          onTap: () {
                            resendCode(widget.email);
                          },
                          child: Container(
                            width: double.infinity,
                            child: Text(
                              "Resend Code ?",
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color:Colors.black,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                          width: double.infinity,
                        ),
                        SizedBox(
                          height: 40,
                          width: double.infinity,
                          child: RaisedButton(
                              color:Colors.black ,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: Text(
                                "VERIFY",
                                style: TextStyle(
                                    color:Color(0xffffd800) , fontSize: 18),
                              ),
                              onPressed: () {
                                if (_formKey.currentState.validate()) {
                                  getvirifi(_codeController.text);

                                  // fordetpass(_emailController.text);
                                }
                              }),
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
    );
  }
}

_showConfirmationAlert(BuildContext context) {
  showPlatformDialog(
    context: context,
    builder: (_) => BasicDialogAlert(
      title: Text(
        "Please check your email for a new verification code.",
        style: TextStyle(
          color: Colors.black,
          fontSize: 20
        ),
        textAlign: TextAlign.center,
      ),
      actions: <Widget>[
        BasicDialogAction(
          title: Text("Ok",
              style: TextStyle(
                color: Colors.black,
              )),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    ),
  );
}

_showvrfieAlert(BuildContext context) {
  showPlatformDialog(
    context: context,
    builder: (_) => BasicDialogAlert(
      title: Text(
        "The account has been verified successfully.",
        style: TextStyle(
          color: Colors.black,
          fontSize: 20
        ),
        textAlign: TextAlign.center,
      ),
      actions: <Widget>[
        BasicDialogAction(
          title: Text("Ok",
              style: TextStyle(
                color: Colors.black,
              )),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) =>  Editprofile(
                titlecountry: " ",
                codecountry: " ",
                titlecity: " ",
                codecity: " ",
                titlenationalities: " ",
                codenationalities: " ",
              ),),
            );
          },
        ),
      ],
    ),
  );
}
