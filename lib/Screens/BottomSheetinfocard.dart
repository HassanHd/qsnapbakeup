import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
class BottomSheetinfocard extends StatefulWidget {
  @override
  _BottomSheetinfocardState createState() => _BottomSheetinfocardState();
}

class _BottomSheetinfocardState extends State<BottomSheetinfocard> {
  var description;
  Future _getuser() async {
    var url = 'http://qsnap.net/api/getPage?slug=mycardinfo';
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
    this._getuser ();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _getuser(), builder: (context, snapshot) {

      if(snapshot.data == null){
        return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.yellow,
              valueColor: new AlwaysStoppedAnimation<Color>(Colors.black),
            )
        );
      }else{
        return Container(
          color: Colors.white,
          height: double.infinity,
          margin: const EdgeInsets.only(top: 5, left: 5, right: 5),
          child: Padding(
            padding: const EdgeInsets.only(top: 5,right: 10,left: 10,bottom: 10),
            child: ListView(
              children: [

                // SizedBox(height: 5,),

                Row(
                  children: [
                    Expanded(
                      flex: 80,
                      child: Text("Help",style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 27,
                      ),
                      ),
                    ),
                    Expanded(
                      flex: 20,
                      child: IconButton(
                        alignment: Alignment.topRight,

                        icon: Icon(
                          Icons.close_sharp,
                          color: Colors.black,
                          size: 30,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10,),
                Text(description,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 15,
                  ),
                ),


              ],
            ),
          ),


        );
      }
    }


    );
  }
}
