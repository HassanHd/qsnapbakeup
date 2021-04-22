import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:convert';
import 'Home.dart';
import 'WalletDescraption.dart';
import 'addqsnap.dart';

class MyWallet extends StatefulWidget {
  @override
  _MyWalletState createState() => _MyWalletState();
}

class _MyWalletState extends State<MyWallet> {
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
      this.getUserDetails();
    }
  }

  // Get json result and convert it to model. Then add
  Future<Null> getUserDetails() async {
    String url = 'http://qsnap.net/api/getCustomerContacts?customerId=$id';
    print("url------->" + url);
    final response = await http.get(url);
    final responseJson = json.decode(response.body)["response"]["contacts"];
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
  Widget build(BuildContext context) {
    return new Scaffold(
      // appBar: new AppBar(
      //   leading: IconButton(
      //     icon: Icon(
      //       Icons.arrow_back_ios_outlined,
      //       color: Color(0xffffd800),
      //       size: 25,
      //     ),
      //     onPressed: () {
      //       Navigator.pushReplacement(
      //         context,
      //         MaterialPageRoute(builder: (context) => Home()),
      //       );
      //     },
      //   ),
      //   actions: [
      //     IconButton(
      //       icon: Icon(
      //         Icons.add_circle_outline,
      //         color: Color(0xffffd800),
      //         size: 25,
      //       ),
      //       onPressed: () {
      //         Navigator.push(
      //           context,
      //           MaterialPageRoute(builder: (context) => AddQsnap()),
      //         );
      //       },
      //     ),
      //     // IconButton(
      //     //   icon: Icon(
      //     //     Icons.search_outlined,
      //     //     color: Color(0xffffd800),
      //     //     size: 25,
      //     //   ),
      //     //   onPressed: () {
      //     //     _toggle();
      //     //   },
      //     // ),
      //   ],
      //   backgroundColor: Color(0xff000000),
      //   centerTitle: true,
      //   elevation: 3,
      //   title: new Text(
      //     'MY WALLET',
      //     style: TextStyle(
      //       color: Color(0xffffd800),
      //     ),
      //   ),
      // ),
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
                          hintText: 'Search Contacts',
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
                                    Navigator.push(
                                        context,
                                        new MaterialPageRoute(
                                            builder: (context) =>
                                                WalletDescraption(
                                                  _searchResult[i].id,
                                                  _searchResult[i].edit,
                                                  _searchResult[i]
                                                      .contactCustomerId,
                                                  id,
                                                )));
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
                                      _searchResult[i].fname +
                                          ' ' +
                                          _searchResult[i].lname,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                    ),
                                  ),
                                  subtitle: Text(_searchResult[i].mobile,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          color: Colors.black54, fontSize: 15)),
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
                                    Navigator.push(
                                        context,
                                        new MaterialPageRoute(
                                            builder: (context) =>
                                                WalletDescraption(
                                                  _userDetails[index].id,
                                                  _userDetails[index].edit,
                                                  _userDetails[index]
                                                      .contactCustomerId,
                                                  id,
                                                )));
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
                                      _userDetails[index].fname +
                                          ' ' +
                                          _userDetails[index].lname,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                    ),
                                  ),
                                  subtitle: Text(_userDetails[index].mobile,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          color: Colors.black54, fontSize: 15)),
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
      if (userDetail.fname.contains(text) ||
          userDetail.lname.contains(text) ||
          userDetail.mobile.contains(text) ||
          userDetail.fname.toLowerCase().contains(text.toLowerCase()) ||
          userDetail.lname.toLowerCase().contains(text.toLowerCase()) ||
          userDetail.fullName.contains(text) ||
          userDetail.fullName.toLowerCase().contains(text.toLowerCase()))
        _searchResult.add(userDetail);
    });

    setState(() {});
  }
}

List<UserDetails> _searchResult = [];

List<UserDetails> _userDetails = [];

class UserDetails {
  var id;
  var fname;
  var lname;
  var image;
  var edit;
  var contactCustomerId;
  var fullName;
  var mobile;

  UserDetails({
    this.id,
    this.fname,
    this.lname,
    this.image,
    this.edit,
    this.contactCustomerId,
    this.fullName,
    this.mobile,
  });

  factory UserDetails.fromJson(Map<String, dynamic> json) {
    return new UserDetails(
      id: json['id'],
      fname: json['fname'],
      lname: json['lname'],
      image: json['image'],
      edit: json['edit'],
      contactCustomerId: json['contactCustomerId'],
      fullName: json['fullName'],
      mobile: json['mobile'],
    );
  }
}
