import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'Home.dart';
import 'package:shared_preferences/shared_preferences.dart';



class Support extends StatefulWidget {
  @override
  _SupportState createState() => _SupportState();
}

class _SupportState extends State<Support> {
  final _formKey = GlobalKey<FormState>();
  var id;

  getid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    id = prefs.get("id");
    setState(() {
      id = prefs.get("id");
      print("ssssssid-----" + id);
    });
  }

  TextEditingController _TitleController = TextEditingController();
  TextEditingController _disController = TextEditingController();
  void postSupport(String Title,String description ) async {
    String SignApiUrl = "http://qsnap.net/api/contactSupport";
    var response = await http.post(SignApiUrl, body: {
      'subject': Title,
      'description': description,
      'customerId': id,
    });
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    var result = json.decode(response.body);
    print('Response convert body: ${result}');

    if (result["status"] == 200) {
      print("onPressed-------------->200200200");
      _showverifyAlert(context);



      print("done signup______------>200");
    }
  }

 @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.getid();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xff000000),
        centerTitle: true,
        elevation: 3,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Color(0xffffd800),
            size: 25,
          ),
          onPressed: (){
            Navigator.pop(context);
          },),
//        toolbarHeight: 65,
        title: Text("SUPPORT"),


      ),
      body:Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView(
          children: [

            Container(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(left:8.0),
                child: Text(
                  "Title",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            Card(
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _TitleController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      // filled: true,
                        fillColor: Colors.white,
                        enabledBorder: UnderlineInputBorder(
                          borderSide:
                          BorderSide(color: Colors.white),
                        ),
                        disabledBorder: UnderlineInputBorder(
                          borderSide:
                          BorderSide(color: Colors.white),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide:
                          BorderSide(color: Colors.white),
                        ),
                        hintText: " Give your query a title."),
                    validator: (text) {
                      if (text == null || text.isEmpty) {
                        return 'Please Enter Title';
                      }
                      return null;
                    },
                  ),
                )
            ),

            SizedBox(
              height: 20,
            ),
            Container(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(left:8.0),
                child: Text(
                  "Description",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            Card(
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _disController,

                    maxLines: 10,
    //keyboardType: TextInputType.text,
    decoration: InputDecoration(
    // filled: true,
    fillColor: Colors.white,
    enabledBorder: UnderlineInputBorder(
    borderSide:
    BorderSide(color:Colors.white),
    ),
    disabledBorder: UnderlineInputBorder(
    borderSide:
    BorderSide(color: Colors.white),
    ),
    focusedBorder: UnderlineInputBorder(
    borderSide:
    BorderSide(color: Colors.white),
    ),
    hintText: "what's making you unhappy?"),
    validator: (text) {
    if (text == null || text.isEmpty) {
    return 'Please Enter Title';
    }
    return null;
    },
    ),
                )
            ),
            SizedBox(
              height: 50,
              width: double.infinity,
            ),
            SizedBox(
              height: 50,
              width: double.infinity,
              child: RaisedButton(
                  color: Colors.black87,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    "SEND",
                    style: TextStyle(
                        color: Color(0xffffd800), fontSize: 18),
                  ),
                  onPressed: () {
                    print("onPressed-------------->");
                      print("_formKey-------------->");
                      postSupport(_TitleController.text, _disController.text);
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
_showverifyAlert(BuildContext context) {
  showPlatformDialog(
    context: context,
    builder: (_) => BasicDialogAlert(
      title: Text("We thank you for contacting us, and the problem will be solved in the shortest time",style: TextStyle(color: Colors.black,fontSize: 20),textAlign: TextAlign.center,),
      actions: <Widget>[
        BasicDialogAction(
          title: Text("Ok",style: TextStyle(color: Colors.black,fontSize: 17)),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) =>Home() ),
              // MaterialPageRoute(builder: (context) => verifyAccount(email)),
            );

          },
        ),
      ],
    ),
  );
}