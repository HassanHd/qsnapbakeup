import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Home.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:flutter_dialogs/flutter_dialogs.dart';

class Reset_Password extends StatefulWidget {
  @override
  _Reset_PasswordState createState() => _Reset_PasswordState();
}

class _Reset_PasswordState extends State<Reset_Password> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _passController = TextEditingController();
  var id;
  getid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    id = prefs.get("id");
    setState(() {
      id = prefs.get("id");
      print("id--------------------" + id);
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    this.getid();
    super.initState();
  }
  //updatpass
  void updatpass(String password) async {
    String updetUrl = "http://qsnap.net/api/updateProfile";
    var response = await http.post(updetUrl, body: {
      "id": id,
      'password': password,
    });
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    var result = json.decode(response.body);
    print('Response convert body: ${result}');
    if (result["status"] == 200) {
      _showsuccessfully(context);

      print("done edit______------>200");
    }
  }
  // Initially password is obscure
  bool _obscureText = true;
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
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
          " RESET PASSWORD",
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
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
        child: ListView(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height / 10,
            ),
            // Image.asset(
            //   'assats/images/logo-colored.png',
            //   height: MediaQuery.of(context).size.height / 12,
            //   width: MediaQuery.of(context).size.width / 2,
            // ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      textDirection: TextDirection.ltr,
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Column(
                          children: [
                            Text(
                              "please add your New Password below and click on Submit button.",
                              textAlign: TextAlign.center,

                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,

                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              alignment: Alignment.topLeft,
                              // padding:EdgeInsets.symmetric(horizontal: 10) ,
                              child: Text(
                                "New Password",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            TextFormField(
                              keyboardType: TextInputType.visiblePassword,
                              obscureText: _obscureText,
                              controller: _passController,
                              decoration: InputDecoration(
                                isDense: true,
                                  suffixIcon: FlatButton(onPressed: _toggle,
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 30.0),
                                        child: Icon(Icons.remove_red_eye,
                                            color: _obscureText ? Colors.black12 : Colors
                                                .black87),
                                      )),
                                contentPadding:
                                EdgeInsets.fromLTRB(0, 5.0, 0, 0.0),
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
                              ),
                              validator: (text) {
                                if (text == null || text.isEmpty) {
                                  return 'Please Enter password';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 40,
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
                                "SUBMIT",
                                style: TextStyle(
                                    color: Color(0xffffd800), fontSize: 18),
                              ),
                              onPressed: () {
                                if (_formKey.currentState.validate()) {
                                  updatpass(
                                    _passController.text,

                                  );

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
_showsuccessfully(BuildContext context) {
  showPlatformDialog(
    context: context,
    builder: (_) =>
        BasicDialogAlert(
          title: Text(
            " The password has been changed successfully",
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
                      fontSize: 17

                  )),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Home()),
                );
              },
            ),
          ],
        ),
  );
}