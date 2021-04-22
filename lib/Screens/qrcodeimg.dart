import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:math';
import 'package:flutter/painting.dart';
import 'dart:typed_data';
import 'package:shared_preferences/shared_preferences.dart';
import 'cardstylescreen.dart';
import 'package:flutter/foundation.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';

class qrcodeimg extends StatefulWidget {
  // var qrcode;
  //
  // qrcodeimg(this.qrcode);

  @override
  _qrcodeimgState createState() => _qrcodeimgState();
}

class _qrcodeimgState extends State<qrcodeimg> {
  var id;
var url;
  getid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    id = prefs.get("id");
    setState(() {
      id = prefs.get("id");
      imageCache.clear();
      url = 'http://qsnap.net/api/shareContactCard_cards?id=$id&edit=0';
       print("ssssssid-----"+url);
    });

  }
  @override
  void initState() {
    // TODO: implement initState
   this.getid();
    super.initState();

  }
  void _shareButton() async {
    var sendimg="http://qsnap.net/api/shareContactCard_cards?id=$id&edit=0";
    var request = await HttpClient().getUrl(Uri.parse(sendimg));
    var response1 = await request.close();
    Uint8List bytes = await consolidateHttpClientResponseBytes(response1);
    await Share.file('ESYS AMLOG', 'amlog.png', bytes, 'image/png',text:'https://qsnap.net/home/addcontact/$id' );
  }
  Future<void> _shareText() async {
    try {
      Share.text('Qsnap',
          'https://qsnap.net/home/addcontact/$id', 'text/plain');
    } catch (e) {
      print('error: $e');
    }
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Color(0xff000000),
      //   centerTitle: true,
      //   elevation: 3,
      //   toolbarHeight: 55,
      //   title: Image.asset('assats/images/logowhite.png',
      //       height: 45.0, fit: BoxFit.cover),
      //
      // ),
      body: id == null
          ? Center(child: CircularProgressIndicator(
            backgroundColor: Colors.yellow,
        valueColor: new AlwaysStoppedAnimation<Color>(Colors.black),

      )):Container(
        color: Colors.white,
    child: ListView(

      children: [
        CachedNetworkImage(
          placeholder: (context, url) => Center(
            child: CircularProgressIndicator(backgroundColor: Colors.yellow,
                valueColor: new AlwaysStoppedAnimation<Color>(Colors.black),
            ),
          ),
          imageUrl:url,
          // width: double.infinity,
        ),

        // Image.network(
        //   url,
        //       width: double.infinity,
        //
        //
        // ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center ,//Center Row contents horizontally,

          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CardStylesScreen()),
                );

              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center ,//Center Row contents horizontally,

                children: [
                  Container(

                    padding: const EdgeInsets.all(0.0),
                    child: IconButton(
                      icon: Icon(
                        Icons.style,
                        color: Colors.black,
                        size: 25,
                      ),
                      // onPressed: () {
                      //   openMap(rel_gps);
                      // },
                    ),),
                  Text(
                    "Change Style",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left:10.0),
              child: Text("|",style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),),
            ),
            GestureDetector(
              onTap: () {
                _shareButton();
                // _shareText();

              },
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center ,//Center Row contents horizontally,

                  children: [
                  Container(

                    padding: const EdgeInsets.all(0.0),
                    child: IconButton(
                      icon: Icon(
                        Icons.share,
                        color: Colors.black,
                        size: 25,
                      ),
                      // onPressed: () {
                      //   openMap(rel_gps);
                      // },
                    ),),
                  Text(
                    "Share Card",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                ],
              ),
            ),


          ],
        ),
        // IconButton(
        //   icon: Icon(
        //     Icons.share,
        //     color: Colors.black,
        //     size: 30,
        //   ),
        //   onPressed: () {
        //     _shareButton();
        //   },
        // ),
      ],
    ),


      ),


    );
  }
}
