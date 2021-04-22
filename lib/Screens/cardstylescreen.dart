import 'package:flutter/material.dart';
import 'Home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';

class CardStylesScreen extends StatefulWidget {
  @override
  _CardStylesScreenState createState() => _CardStylesScreenState();
}

class _CardStylesScreenState extends State<CardStylesScreen> {
  var idchick;

  getlogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    idchick = prefs.get("id");
    print(idchick);
    setState(() {
      idchick = prefs.get("id");
      print(idchick);
    });
  }

  Future<List<Styles>> _getlistMpa() async {
    var url = 'http://qsnap.net/api/getCardDesigns';
    var response = await http.get(url);
    var responsbody = json.decode(response.body)["response"]["data"];
    print(responsbody);
    List<Styles> list = [];
    for (var u in responsbody) {
      Styles x = Styles(u["id"], u["name"], u["image"],);
      list.add(x);
    }
    for (var c in list) {
      print(c.name);
      print(c.image);
    }
    print("ssssssssssssssssss$list");
    return list;
  }
  void updatcard(String idstyle) async {
    print('idchick$idchick');
    print('idstyle$idstyle');

    String updetUrl = "http://qsnap.net/api/updateCustomerCardDesign";
    var response = await http.post(updetUrl, body: {
      "id": idchick,
      'cardId': idstyle,
    });
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    var result = json.decode(response.body);
    print('Response convert body: ${result}');
    if (result["status"] == 200) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => Home()),
      );
      print("done edit______------>200");
    }
  }
  @override
  void initState() {
    this.getlogin();
    this._getlistMpa();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff000000),
        centerTitle: true,
        elevation: 3,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_outlined,
            color: Color(0xffffd800),
            size: 25,
          ),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Home()),
            );
          },
        ),
//        toolbarHeight: 65,
        title: Text(
          "CHANGE STYLE",
          style: TextStyle(
            color: Color(0xffffd800),
          ),
        ),
      ),
      body: Padding(
          padding: const EdgeInsets.all(5.0),
          child: FutureBuilder(
            future: _getlistMpa(),
            builder:(BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.data == null)  {
                return Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.yellow,
                      valueColor: new AlwaysStoppedAnimation<Color>(
                          Colors.black),
                    )
                );
              }
              else{
                return ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                itemCount: snapshot.data.length,
    itemBuilder: (context, i) {
      return GestureDetector(
        onTap: (){
          updatcard(snapshot.data[i].id);
        },
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(

            children: [
              Image.network(snapshot.data[i].image, fit: BoxFit.fill, height:400,),
              Text(
                snapshot.data[i].name,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        )


      );
    }
                );
              }
            },
          )
      ),

    );
  }
}

class Styles {
  var id;
  var name;
  var image;

  Styles(this.id, this.name, this.image);
}