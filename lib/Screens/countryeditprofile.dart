import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'Editprofile.dart';

class searchcountryedit extends StatefulWidget {
  var titlenationalities;
  var codenationalities;
  var titlecity;
  var codecity;


  searchcountryedit(
      {this.titlenationalities,
      this.codenationalities,
      this.titlecity,
      this.codecity});

  @override
  _searchcountryeditState createState() => _searchcountryeditState();
}

class _searchcountryeditState extends State<searchcountryedit> {
  TextEditingController controller = new TextEditingController();

  // Get json result and convert it to model. Then add
  Future<Null> getUserDetails() async {
    String url = 'http://qsnap.net/api/getCountries';
    // print("url------->"+url);
    final response = await http.get(url);
    final responseJson = json.decode(response.body)["response"]["data"];
    setState(() {
      _userDetails.clear();
      for (Map user in responseJson) {
        _userDetails.add(UserDetails.fromJson(user));
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    this.getUserDetails();
    return new Scaffold(
      appBar: new AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Color(0xffffd800),
            size: 25,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Color(0xff000000),
        centerTitle: true,
        elevation: 3,
        title: new Text('Countries'),
      ),
      body: new Column(
        children: <Widget>[
          Container(
            color: Color(0xff000000),
            child: new Padding(
              padding: const EdgeInsets.all(8.0),
              child: new Card(
                child: new ListTile(
                  leading: new Icon(Icons.search),
                  title: new TextField(
                    controller: controller,
                    decoration: new InputDecoration(
                        hintText: 'Search', border: InputBorder.none),
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

          Expanded(
            child: _searchResult.length != 0 || controller.text.isNotEmpty
                ? new ListView.builder(
              itemCount: _searchResult.length,
              itemBuilder: (context, i) {
                return new Card(

                  child: ListTile(
                    onTap: () {
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) =>
                                  Editprofile(
                                    titlecountry:  _searchResult[i].name,
                                    codecountry:_searchResult[i].code,
                                    titlecity: widget.titlecity,
                                    codecity: widget.codecity,
                                    titlenationalities:widget.titlenationalities,
                                    codenationalities:widget.codenationalities,
                                  )
                          ));
                    },
                    title: Text(
                      _searchResult[i].name ,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Color(0xff000000),
                          fontWeight: FontWeight.w300,
                          fontSize: 14),
                    ),
                  ),
                );


              },
            )
                : new ListView.builder(
              itemCount: _userDetails.length,
              itemBuilder: (context, index) {
                return new Card(

                  child: ListTile(
                    onTap: () {
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) =>
                                  Editprofile(
                                    titlecountry: _userDetails[index].name,
                                    codecountry:_userDetails[index].code,
                                    titlecity: widget.titlecity,
                                    codecity: widget.codecity,
                                    titlenationalities:widget.titlenationalities,
                                    codenationalities:widget.codenationalities,
                                  )
                          ));
                    },
                    title: Text(
                      _userDetails[index].name ,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Color(0xff000000),
                          fontWeight: FontWeight.w300,
                          fontSize: 14),
                    ),
                  ),
                );

              },
            ),
          ),
        ],
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
      if (userDetail.name.contains(text)||userDetail.name.toLowerCase().contains(text.toLowerCase()))
        _searchResult.add(userDetail);
    });

    setState(() {});
  }
}

List<UserDetails> _searchResult = [];

List<UserDetails> _userDetails = [];

class UserDetails {
  var code;
  var name;


  UserDetails({this.code, this.name});

  factory UserDetails.fromJson(Map<String, dynamic> json) {
    return new UserDetails(
      code: json['code'],
      name: json['name'],

    );
  }
}