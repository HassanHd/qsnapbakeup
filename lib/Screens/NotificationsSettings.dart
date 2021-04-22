import 'package:flutter/material.dart';
import 'package:custom_switch_button/custom_switch_button.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationsSettings extends StatefulWidget {
  @override
  _NotificationsSettingsState createState() => _NotificationsSettingsState();
}

class _NotificationsSettingsState extends State<NotificationsSettings> {



  bool isCheckednotificationsall = false;
  var notificationsallint = "0";
  var id;

  getid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    id = prefs.get("id");
    setState(() {
      id = prefs.get("id");
      print("ssssssid-----" + id);
      if(id!=null){
        _getdisNotifi();
      }
    });
  }

  Future _getdisNotifi() async {
    var url = 'http://qsnap.net/api/getNotificationFromContacts?id=$id';
    var response = await http.get(url);
    var responsbody = jsonDecode(response.body);
    var data=responsbody["response"];
    if(responsbody["status"]==200){
      setState(() {
        notificationsallint=data["notificationFromContacts"];
        print("notificationsallint");
        print(notificationsallint);
        if (notificationsallint == "0") {
          isCheckednotificationsall = false;
        }
        else if (notificationsallint == "1") {
          isCheckednotificationsall = true;
        } else {
          notificationsallint = "0";
          isCheckednotificationsall = false;
        }

      });
    }
    // print(responsbody);
    return "Sucess";
  }
  void postnotificationsall(String notificationsall) async {
    String SignApiUrl = "http://qsnap.net/api/updateNotificationFromContacts";
    print('notificationsallint------->$notificationsall');
    print(id);
    var response = await http.post(SignApiUrl, body: {
      'notificationFromContacts': notificationsall,
      'id': id,
    });
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    var result = json.decode(response.body);
    print('Response convert body: ${result}');

    if (result["status"] == 200) {
      Navigator.pop(context);

    }
  }
@override
  void initState() {
 this.getid();
    // TODO: implement initState
    super.initState();
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
            Icons.arrow_back_ios,
            color: Color(0xffffd800),
            size: 25,
          ),
          onPressed: (){
            Navigator.pop(context);
          },),
//        toolbarHeight: 65,
        title: Text("NOTIFICATIONS SETTINGS"),


      ),
    body: Padding(
      padding: const EdgeInsets.all(5.0),
      child: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Row(
              children: [
                Expanded(
                  flex: 75,
                  child: Container(
                    alignment: Alignment.topLeft,
                    child:  Text(
                      "Receive notifications from contacts",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 17,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
                Expanded(
                  flex: 25,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {

                        if (notificationsallint == "0") {
                          notificationsallint = "1";
                        } else {
                          notificationsallint = "0";
                        }
                        isCheckednotificationsall =
                        !isCheckednotificationsall;
                      });
                    },
                    child: Center(
                      child: CustomSwitchButton(
                        backgroundColor: Color(0xffffd800),
                        unCheckedColor: Colors.black,
                        animationDuration:
                        Duration(milliseconds: 400),
                        checkedColor: Colors.white,
                        checked: isCheckednotificationsall,
                      ),
                    ),
                  ),
                ),

              ],
            ),
          ),
          Padding(
            padding:
            const EdgeInsets.only(top: 10.0, bottom: 5,left: 10,right: 10),
            child: Divider(
              height: 1,
              indent: 0.0,
              endIndent: 0.0,
              thickness: 1,
              color: Color(0xffffd800),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left:20.0,right: 20,top:20),
            child: SizedBox(
              height: 50,
              width: double.infinity,
              child: RaisedButton(
                  color: Colors.black87,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "SAVE",
                    style: TextStyle(
                        color: Color(0xffffd800), fontSize: 18),
                  ),
                  onPressed: () {
                    postnotificationsall(notificationsallint);
                    // postnote( notificationsallint);
                  }),
            ),
          ),
        ],
      ),
    ),
    );
  }
}
