import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:convert';
import 'Home.dart';
import 'WalletDescraption.dart';
import 'addqsnap.dart';
import 'package:flutter/material.dart';
import 'nave.dart';

class MyChats extends StatefulWidget {
  @override
  _MyChatsState createState() => _MyChatsState();
}

class _MyChatsState extends State<MyChats> {
  TextEditingController controller = new TextEditingController();
  var id;
  bool visible = false;

  getid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    id = prefs.get("id");
    setState(() {
      id = prefs.get("id");
      print("ssssssid-----" + id);
    });
    if (id != null) {
      getUserDetails();
    }
  }

  // Get json result and convert it to model. Then add
  Future<Null> getUserDetails() async {
    String url = 'http://qsnap.net/api/Chat_display?SenderId=$id';
    print("url------->" + url);
    final response = await http.get(url);
    final responseJson = json.decode(response.body)["response"]["data"];
    print(responseJson);
    setState(() {
      _userDetails.clear();
      for (Map user in responseJson) {
        _userDetails.add(UserDetails.fromJson(user));
      }
    });
  }

  // void _toggle() {
  //   setState(() {
  //     visible = !visible;
  //   });
  // }

  @override
  void initState() {
    this.getid();
    super.initState();

  }
@override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    if(id!=null){
      getUserDetails();
    }
    return new Scaffold(

      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: new Column(
          children: <Widget>[
            new Container(
              color: Colors.white38,
              child: new Padding(
                padding: const EdgeInsets.all(8.0),
                child: new Card(
                  child: new ListTile(
                    leading: new Icon(Icons.search),
                    title: new TextField(
                      controller: controller,
                      decoration: new InputDecoration(
                          hintText: 'Search Chats',
                          border: InputBorder.none),
                      onChanged: onSearchTextChanged,
                    ),
                    trailing: new IconButton(
                      icon: new Icon(Icons.cancel),
                      onPressed: () {
                        controller.clear();
                        onSearchTextChanged('');
                      },
                    ),
                  ),
                ),
              ),
            ),
            new Expanded(
              child: _searchResult.length != 0 || controller.text.isNotEmpty
                  ? new ListView.builder(
                itemCount: _searchResult.length,
                itemBuilder: (context, i) {
                  return new Card(
                    margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                    elevation: 8.0,
                    child: Container(
                      child: Container(
                        width: double.infinity,
                        child: Container(
                          child: ListTile(
                            onTap: () {
                              NavigationService.instance.navigationKey.currentState.pushNamed(
                                "ChatPage",
                                arguments: {
                                  "sender_id": _searchResult[i].id,
                                  "receiver_name": _searchResult[i].Receiver_name,
                                  "receiverId": _searchResult[i].Receiver_id,
                                },
                              );
                              //    _searchResult[i].id,
                            },
                            leading: CircleAvatar(
                              backgroundColor: Color(0xffffd800),
                              foregroundColor: Color(0xffffd800),
                              radius: 30,
                              child: Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: CircleAvatar(
                                    backgroundColor: Colors.black,
                                    foregroundColor: Color(0xffffd800),
                                    backgroundImage: NetworkImage(
                                      _searchResult[i].image,
                                    ),
                                    radius: 50),
                              ),
                            ),
                            // Container(
                            //   height: 100.0,
                            //   width: 100.0,
                            //   decoration: new BoxDecoration(
                            //      shape: BoxShape.circle,
                            //     // color: Colors.yellow,
                            //     color: const Color(0xff000000),
                            //     image: new DecorationImage(
                            //       fit: BoxFit.cover,
                            //       image: NetworkImage(
                            //         _searchResult[i].image,
                            //       ),
                            //     ),
                            //     border: Border.all(
                            //         color: const Color(0xffffd800),
                            //         width: 1.5),
                            //   ),
                            // ),
                            title: Container(
                              // padding: EdgeInsets.only(top: 3),
                              child: Text(
                                _searchResult[i].Receiver_name ,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              ),
                            ),
                            subtitle: Text(_searchResult[i].last_datetime,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    color: Colors.black54, fontSize: 15)),
                            trailing:
                            (_searchResult[i].unread_count==0)?SizedBox(height: 0,width: 0,):
                            MaterialButton(
                              onPressed: () {},
                              color: Colors.red,
                              textColor: Colors.white,
                              child: Text("${_searchResult[i].unread_count}"),
                              padding: EdgeInsets.all(16),
                              shape: CircleBorder(),
                            ),


                          ),
                        ),
                      ),
                    ),
                  );
                },
              )
                  : new ListView.builder(
                itemCount: _userDetails.length,
                itemBuilder: (context, index) {
                  return new Card(
                    margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                    elevation: 8.0,
                    child: Container(
                      child: Container(
                        width: double.infinity,
                        child: Container(
                          child: ListTile(
                            onTap: () {
                              NavigationService.instance.navigationKey.currentState.pushNamed(
                                "ChatPage",
                                arguments: {
                                  "sender_id": _userDetails[index].id,
                                  "receiver_name": _userDetails[index].Receiver_name,
                                  "receiverId": _userDetails[index].Receiver_id,
                                },
                              );
                            },
                            leading: CircleAvatar(
                              backgroundColor: Color(0xffffd800),
                              foregroundColor: Color(0xffffd800),
                              radius: 30,
                              child: Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: CircleAvatar(
                                    backgroundColor: Colors.black,
                                    foregroundColor: Color(0xffffd800),
                                    backgroundImage: NetworkImage(
                                      _userDetails[index].image,
                                    ),
                                    radius: 25),
                              ),
                            ),
                            // Container(
                            //   height: 100.0,
                            //   width: 100.0,
                            //   decoration: new BoxDecoration(
                            //      shape: BoxShape.circle,
                            //      // color: Colors.yellow,
                            //      color: const Color(0xff000000),
                            //     image: new DecorationImage(
                            //       fit: BoxFit.cover,
                            //       image: NetworkImage(
                            //         _userDetails[index].image,
                            //       ),
                            //     ),
                            //     border: Border.all(
                            //         color: const Color(0xffffd800),
                            //         width:1.5),
                            //   ),
                            // ),
                            title: Container(
                              // padding: EdgeInsets.only(top: 3),
                              child: Text(
                                _userDetails[index].Receiver_name ,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              ),
                            ),
                            subtitle: Text(_userDetails[index].last_datetime,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    color: Colors.black54, fontSize: 15)),
                            trailing:(_userDetails[index].unread_count==0)?SizedBox(height: 0,width: 0,)
                                  :MaterialButton(
                              onPressed: () {},
                              color: Colors.red,
                              textColor: Colors.white,
                              child: Text("${_userDetails[index].unread_count}"),
                              padding: EdgeInsets.all(0),
                              shape: CircleBorder(),
                            ),

                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  onSearchTextChanged(String text) async {
    _searchResult.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    _userDetails.forEach((userDetail) {
      if (userDetail.Receiver_name.contains(text) ||
          userDetail.Receiver_name.toLowerCase().contains(text.toLowerCase())
         )
        _searchResult.add(userDetail);
    });

    setState(() {});
  }
}

List<UserDetails> _searchResult = [];

List<UserDetails> _userDetails = [];

class UserDetails {
  var id;
  var Receiver_id;
  var last_datetime;
  var read_count;
  var total_count;
  var last_message_unix;
  var Receiver_name;
  var image;
  var unread_count;


  UserDetails(
      {this.id,
      this.Receiver_id,
      this.last_datetime,
      this.read_count,
      this.total_count,
      this.last_message_unix,
      this.Receiver_name,
      this.image,
      this.unread_count});

  factory UserDetails.fromJson(Map<String, dynamic> json) {
    return new UserDetails(
      id: json['id'],
      Receiver_id: json['Receiver_id'],
      last_datetime: json['last_datetime'],
      read_count: json['read_count'],
      total_count: json['total_count'],
      last_message_unix: json['last_message_unix'],
      Receiver_name: json['Receiver_name'],
      image: json['image'],
      unread_count: json['unread_count'],
    );
  }
}
