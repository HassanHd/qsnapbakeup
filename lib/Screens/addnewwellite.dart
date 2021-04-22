import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'Home.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';


class addnewwilite extends StatefulWidget {

  @override
  _addnewwiliteState createState() => _addnewwiliteState();
}

class _addnewwiliteState extends State<addnewwilite> {
  var x;
var idchick;
var initialLink;
  void updatqsnap() async {
    String updetUrl = "http://qsnap.net/api/scanqrcode";
     x=initialLink.toString().replaceAll('qsnapapp://?id=', '');
    //  x=d.toString().replaceAll('qsnapapp://?id=', '');


      var response = await http.post(updetUrl, body: {
        'id': idchick,
        'data': x,
        'gps': "0.0,0.0",
      });
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      var result = json.decode(response.body);
      print('Response convert body: ${result}');

      if (result["status"] == 200) {
        if (result["response"]["inserted"] == 1) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Home()),
          );
        }
        else if (result["response"]["inserted"] == 0) {
          _showConfirmationAlert(context);
        }
        print("done edit______------>200");
      }




  }

  @override
  Widget build(BuildContext context) {
    Map args = ModalRoute.of(context).settings.arguments;
    print(args["idchick"]);
    idchick=args["idchick"];
    initialLink=args["initialLink"];

    return Scaffold(
      appBar: new AppBar(
        actions: [

        ],
        backgroundColor: Color(0xff000000),
        centerTitle: true,
        elevation: 3,
        title: new Text(
          'ADD NEW CONTACT',
          style: TextStyle(
            color: Color(0xffffd800),
          ),
        ),
      ),
      // body: Center(
      //   child: new ListView(
      //     shrinkWrap: true,
      //     padding: const EdgeInsets.all(8.0),
      //     children: <Widget>[
      //       new ListTile(
      //         title: new Text(x),
      //         subtitle: new Text('${widget.idchick}'),
      //       ),
      //
      //     ],
      //   ),
      // ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
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
             Padding(
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
                            "Do you want to add this contact to your wallet ?",
                            textAlign: TextAlign.center,

                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,

                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 40,
                        width: double.infinity,
                      ),
                      SizedBox(
                        height: 40,
                        width: double.infinity-20,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,

                          children: [
                            RaisedButton(
                                color: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: Text(
                                  "Cancel",
                                  style: TextStyle(
                                      color: Color(0xffffd800), fontSize: 18),
                                ),
                                onPressed: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(builder: (context) => Home()),
                                  );
                                }),
                            SizedBox(
                              width: 20,
                            ),
                            RaisedButton(

                                color: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: Text(
                                  "OK",
                                  style: TextStyle(
                                      color: Color(0xffffd800), fontSize: 18),
                                ),
                                onPressed: () {
                                  updatqsnap();

                                }),

                          ],
                        ),
                      ),
                    ],
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
        "This contact already exists",
        style: TextStyle(color: Colors.black, fontSize: 20),
        textAlign: TextAlign.center,
      ),
      actions: <Widget>[
        BasicDialogAction(
          title: Text("Ok"),
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
