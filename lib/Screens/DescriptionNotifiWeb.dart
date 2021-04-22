import 'package:flutter/material.dart';
import 'package:qsnap/Screens/loginscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'Notifications.dart';

class DescriptionNotifiWeb extends StatefulWidget {


  @override
  _DescriptionNotifiWebState createState() => _DescriptionNotifiWebState();
}

class _DescriptionNotifiWebState extends State<DescriptionNotifiWeb> {
  var id;

  var datetime,description,title;
  Future _getdisNotifi() async {
    var url = 'http://qsnap.net/api/getNotificationDescription?id=$id';
    var response = await http.get(url);
    var responsbody = jsonDecode(response.body);
    var data=responsbody["response"]["notification"];
    if(responsbody["status"]==200){
      setState(() {
        description=data["description"];
        datetime=data["datetime"];
        title=data["title"];

        // print("id------>$fname");
      });
    }
    // print(responsbody);
    return "Sucess";
  }

  @override
  void initState() {
    this._getdisNotifi ();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Map args = ModalRoute.of(context).settings.arguments;
    print(args["id"]);
    id=args["id"];

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Color(0xff000000),
          centerTitle: true,
          elevation: 3,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Color(0xffffd800),
              size: 25,
            ),
            onPressed: (){
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );          },),
//        toolbarHeight: 65,
          title: Text("DESCRIPTION"),
        ),
        body:FutureBuilder(
            future: _getdisNotifi(),
            builder: (context, snapshot) {

              // print(snapshot.data);
              if(snapshot.data == null){
                return Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.yellow,
                      valueColor: new AlwaysStoppedAnimation<Color>(Colors.black),

                    )
                );
              }

              else {
                return
                  ListView(

                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8,top: 8,bottom: 3),
                        child: Row(
                          children: [
                            // Text(
                            //   "TITLE:",
                            //   style: TextStyle(
                            //     color: Color(0xff000000),
                            //     fontSize: 17,
                            //     fontWeight: FontWeight.w600,
                            //   ),
                            // ),
                            // SizedBox(width: 5),

                            Text(
                              title,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 17,
                                fontWeight: FontWeight.w600,

                              ),
                            ),
                          ],
                        ),
                      ),
                      // ListTile(
                      //      hoverColor: Colors.white,
                      //      focusColor: Colors.white,
                      //      title: Text(
                      //        "TITLE:",
                      //        style: TextStyle(
                      //          color: Color(0xff000000),
                      //          fontSize: 16,
                      //          fontWeight: FontWeight.w600,
                      //        ),
                      //      ),
                      //      subtitle: Text(
                      //        "update",
                      //        style: TextStyle(
                      //          color: Colors.black54,
                      //          fontSize: 13,
                      //        ),
                      //      ),
                      //    ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8,bottom: 8),
                        child:  Text(
                          datetime,
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      // ListTile(
                      //       hoverColor: Colors.white,
                      //       focusColor: Colors.white,
                      //       title: Text(
                      //         "DATE:",
                      //         style: TextStyle(
                      //           color: Color(0xff000000),
                      //           fontSize: 16,
                      //           fontWeight: FontWeight.w600,
                      //         ),
                      //       ),
                      //       subtitle: Text(
                      //         "20-3-2021-01:2",
                      //         style: TextStyle(
                      //           color: Colors.black54,
                      //           fontSize: 13,
                      //         ),
                      //       ),
                      //     ),
                      // Padding(
                      // padding: const EdgeInsets.only(right:8.0,left: 8.0,top: 8.0),
                      // child: Text(
                      // "DESCRIPTION:",
                      // style: TextStyle(
                      // color: Color(0xff000000),
                      // fontSize: 16,
                      // fontWeight: FontWeight.bold,
                      // ),
                      // ),
                      // ),
                      Padding(
                        padding: const EdgeInsets.only(right:8.0,left: 8.0),
                        child: Text(
                          description
                          ,    style: TextStyle(
                          color: Colors.black,
                          fontSize: 17,
                        ),
                        ),
                      ),

                    ],
                  );
              }
            }
        )
    );
  }

}
