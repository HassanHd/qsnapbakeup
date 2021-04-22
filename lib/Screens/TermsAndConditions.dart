import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:flutter_html/flutter_html.dart';
class Terms extends StatefulWidget {
  @override
  _TermsState createState() => _TermsState();
}
class _TermsState extends State<Terms> {
  var description;
  Future _getterms() async {
    var url = 'http://qsnap.net/api/getPage?slug=terms';
    var response = await http.get(url);
    var responsbody = jsonDecode(response.body);
    var data=responsbody["response"]["page"];
    if(responsbody["status"]==200){
      setState(() {
        description=data["description"];

      });
    }
    return "Sucess";
  }
  @override
  void initState() {
    this._getterms ();
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
              Icons.arrow_back,
              color: Color(0xffffd800),
              size: 25,
            ),
            onPressed: (){
              Navigator.pop(context);
            },),
//        toolbarHeight: 65,
          title: Text("TERMS AND CONDITIONS"),


        ),

        body: FutureBuilder(
            future: _getterms(), builder: (context, snapshot) {

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
            return Padding(
              padding: const EdgeInsets.only(top: 25,right: 10,left: 10,bottom: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Text("privacy Policy",style: TextStyle(
                  //   fontWeight: FontWeight.bold,
                  //   fontSize: 30,
                  // ),
                  // ),
                  // SizedBox(height: 10,),
                  new Expanded(
                    flex: 1,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Html(
                        data: description,

                      ),
                    ),
                  ),

                ],
              ),



            );
          }
        }


        )

    );  }
}
