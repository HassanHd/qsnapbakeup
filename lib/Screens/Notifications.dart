import 'package:flutter/material.dart';
import 'DescriptionNotification.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'NotificationsSettings.dart';
import 'nave.dart';


class Notifications extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  var id;

  getid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    id = prefs.get("id");
    setState(() {
      id = prefs.get("id");
      print("id--------------->" + id);
    });
  }

  Future<List<Notifi>> _getNotifiMpa() async {
    var url =
        'http://qsnap.net/api/getNotifications?customerId=$id';
    var response = await http.get(url);
    var responsbody = json.decode(response.body)["response"]["data"];
    print(responsbody);
    List<Notifi> list = [];
    for (var u in responsbody) {
      Notifi x = Notifi(u["id"], u["title"], u["description"], u['customerId'],
          u['datetime']);
      list.add(x);
    }
    for (var c in list) {
      print(c.id);
    }
    print("ssssssssssssssssss$list");
    return list;
  }

  void initState() {
    this.getid();
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
          onPressed: () {
            Navigator.pop(context);
          },
        ),
//        toolbarHeight: 65,
        title: Text("NOTIFICATIONS"),
        actions: [Padding(
          padding: const EdgeInsets.all(3.0),
          child: IconButton(
            icon: Icon(
              Icons.settings,
              color: Color(0xffffd800),
              size: 25,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotificationsSettings()),
              );
            },
          ),
        ),],
      ),
      body: Padding(
          padding: const EdgeInsets.all(5.0),
          child: FutureBuilder(
              future: _getNotifiMpa(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.data == null) {
                  return Center(
                      child: CircularProgressIndicator(
                    backgroundColor: Color(0xffffd800),
                    valueColor:
                        new AlwaysStoppedAnimation<Color>(Colors.black)),
                  );
                } else {
                  return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, i) {
                        return GestureDetector(
                          onTap: () {
                            NavigationService.instance.navigationKey.currentState.pushNamed(
                              "DescriptionNotification",
                              arguments: {"id":snapshot.data[i].id,},
                            );
                          },
                          child: Container(
                            color: Colors.white,
                            child: ListTile(
                              hoverColor: Colors.white,
                              focusColor: Colors.white,
                              title: Text(
                                snapshot.data[i].title,
                                style: TextStyle(
                                  color: Color(0xff000000),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              subtitle: Text(
                                snapshot.data[i].datetime,
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ),
                        );
                      });
                }
              })),
    );
  }
}

class Notifi {
  var id;
  var title;
  var description;
  var customerId;
  var datetime;

  Notifi(this.id, this.title, this.description, this.customerId, this.datetime);
}

// ListView(
// children: [
// GestureDetector(
// onTap: () {
// Navigator.push(
// context,
// MaterialPageRoute(builder: (context) => DescriptionNotification()),
// );
// },
// child: Container(
// color: Colors.white,
// child: ListTile(
// hoverColor: Colors.white,
// focusColor: Colors.white,
// title: Text(
// "Test",
// style: TextStyle(
// color: Color(0xff000000),
// fontSize: 16,
// fontWeight: FontWeight.w600,
// ),
// ),
// subtitle: Text(
// "22-33-22:56",
// style: TextStyle(
// color: Colors.black54,
// fontSize: 13,
// ),
// ),
// ),
// ),
// ),
// Padding(
// padding: const EdgeInsets.symmetric(horizontal: 10),
// child: Divider(
// height: .5,
// color: Colors.grey,
// ),
// ),
// Container(
// color: Colors.white,
//
// child: ListTile(
// hoverColor: Colors.white,
// focusColor: Colors.white,
// title: Text(
// "Test",
// style: TextStyle(
// color: Color(0xff000000),
// fontSize: 16,
// fontWeight: FontWeight.w600,
// ),
// ),
// subtitle: Text(
// "22-33-22:56",
// style: TextStyle(
// color: Colors.black54,
// fontSize: 13,
// ),
// ),
// ),
// ),
// Padding(
// padding: const EdgeInsets.symmetric(horizontal: 10),
// child: Divider(
// height: .5,
// color: Colors.grey,
// ),
// ),
// Container(
// color: Colors.white,
//
// child: ListTile(
// hoverColor: Colors.white,
// focusColor: Colors.white,
// title: Text(
// "Test",
// style: TextStyle(
// color: Color(0xff000000),
// fontSize: 16,
// fontWeight: FontWeight.w600,
// ),
// ),
// subtitle: Text(
// "22-33-22:56",
// style: TextStyle(
// color: Colors.black54,
// fontSize: 13,
// ),
// ),
// ),
// ),
// Padding(
// padding: const EdgeInsets.symmetric(horizontal: 10),
// child: Divider(
// height: .5,
// color: Colors.grey,
// ),
// ),
// ],
//
// ),
