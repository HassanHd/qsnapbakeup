import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'Support.dart';


class FAQ extends StatefulWidget {
  @override
  _FAQState createState() => _FAQState();
}

class _FAQState extends State<FAQ> {
  Future<List<Data>> _getlistcontacts() async {
    var url = 'http://qsnap.net/api/getFAQ';
    var response = await http.get(url);
    var responsbody = json.decode(response.body)["response"]["data"];
    print(responsbody);
    List<Data> list = [];
    for(var u in responsbody){
      Data x=Data(u["question"],u["answer"]  );
      list.add(x);
    }

    for(var c in list){
      print(c.question);
    }

    print("ssssssssssssssssss$list");
    return list;
  }

  @override
  void initState() {
    super.initState();
    this._getlistcontacts ();
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
          title: Text("FAQ"),
        ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),

        child: Column(
          children: [
            Expanded(
            flex: 1,
              child: FutureBuilder(
                  future: _getlistcontacts(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    print(snapshot.data);
                    if (snapshot.data == null) {
                      return Center(
                          child: CircularProgressIndicator(
                            backgroundColor: Colors.yellow,
                            valueColor: new AlwaysStoppedAnimation<Color>(Colors.black),

                          )
                      );
                    } else {
                      return ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, i) {
                            return ExpansionTile(
                              title: Text(
                                snapshot.data[i].question,
                                style: TextStyle(
                                    fontSize: 15.0,
                                    // fontWeight: FontWeight.bold,
                                    color: Colors.black87
                                ),
                              ),
                              children: <Widget>[

                                ListTile(
                                  title: Text(
                                    snapshot.data[i].answer,
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black54
                                        // fontWeight: FontWeight.w500
                                    ),
                                  ),
                                ),

                              ],
                            );

                          });
                    }
                  }),
            ),
            SizedBox(
              height: 10,
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
                    "To ask a question go to support",
                    style: TextStyle(
                        color: Color(0xffffd800), fontSize: 18),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>Support() ),
                      // MaterialPageRoute(builder: (context) => verifyAccount(email)),
                    );
                  }),
            ),
            SizedBox(
              height: 10,
              width: double.infinity,
            ),
          ],
        ),

        // child: Column(
        //   children: <Widget>[
        //     SizedBox(height:20.0),
        //     ExpansionTile(
        //       title: Text(
        //         "How will i be notified ?",
        //         style: TextStyle(
        //             fontSize: 18.0,
        //             fontWeight: FontWeight.bold,
        //           color: Colors.black87
        //         ),
        //       ),
        //       children: <Widget>[
        //
        //         ListTile(
        //           title: Text(
        //               'imdldldldldmvmvmvmvvmmvmvmvmmvvmvmvmvmvmvmmvmvkddls;a,ms;s;lssklskskl',
        //             style: TextStyle(
        //               fontSize: 13,
        //               fontWeight: FontWeight.w500
        //             ),
        //           ),
        //         ),
        //
        //       ],
        //     ),
        //     SizedBox(height:10.0),
        //
        //
        //   ],
        // ),
      ),
    );
  }
}
class Data{
  String question;
  String answer;

  Data(this.question, this.answer);
}