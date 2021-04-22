import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:qsnap/model/alligator.dart';
import 'Chat.dart';
import 'mywallet.dart';
import 'LoaderDialog.dart';
import 'nave.dart';

//import 'package:share/share.dart';
import 'package:simple_speed_dial/simple_speed_dial.dart';
import 'package:url_launcher/url_launcher.dart';
import 'Editqsnap.dart';
import 'Home.dart';
import 'LoaderDialog.dart';
import 'dart:async';
import 'package:contacts_service/contacts_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/services.dart' show rootBundle;


class WalletDescraption extends StatefulWidget {
  var id, edit, contactCustomerId, loginId;

  WalletDescraption(this.id, this.edit, this.contactCustomerId, this.loginId);

  @override
  _WalletDescraptionState createState() => _WalletDescraptionState();
}

Widget buildError(BuildContext context, FlutterErrorDetails error) {
  return Scaffold(
    body: Center(
      child: Text(
        "loadeee.",
        style: Theme.of(context).textTheme.title,
      ),
    ),
  );
}

class _WalletDescraptionState extends State<WalletDescraption> {
  TextEditingController _commentController = TextEditingController();
  final GlobalKey<State> _LoaderDialog = new GlobalKey<State>();
  // var idd= widget.id;
  var fname = " ";
  var lname = " ";
  var email=" ";
  var mobile = " ";
  var comments = " ";
  var tiktok = " ";
  var contact1 = " ";
  var contact2 = " ";
  var instagram = " ";
  var linkedIn = " ";
  var twitter = " ";
  var facebook = " ";
  var country_name = " ";
  var city_name = " ";
  var phoneCode = " ";
  var contact1_code = " ";
  var contact2_code = " ";
  var insertdatetime = " ";
  var rel_gps = " ";
  var image;
  var dob_month, dob_day;

  // var nationality_code;
  var qrcode;
  var dob = " ";
  var job_title = " ";
  var company_website = " ";
  var company = " ";
  var phone = "No Number";
  bool visible = false;
  bool visibleDate = true;
  bool visibleCompany = true;
  bool visiblecompany_website = true;
  bool visibleTitle = true;
  bool visibleContact1 = true;
  bool visibleContact2 = true;
  bool visibleinsertdatetime = true;
  bool visiblerel_gps = true;
  bool visibleComments = true;
  bool visibleface = true;
  bool visibletwitter = true;
  bool visibleinsta = true;
  bool visiblelinkedin = true;
  bool visibletiktok = true;
  var sendimg;

  getZodiacSign(int day, int month) {
    if ((month == 1 && day <= 20) || (month == 12 && day >= 22)) {
      return "assats/images/Capricorn.png";
    } else if ((month == 1 && day >= 21) || (month == 2 && day <= 18)) {
      return "assats/images/Aquarius.png";
    } else if ((month == 2 && day >= 19) || (month == 3 && day <= 20)) {
      return "assats/images/Pisces.png";
    } else if ((month == 3 && day >= 21) || (month == 4 && day <= 20)) {
      return "assats/images/Aries.png";
    } else if ((month == 4 && day >= 21) || (month == 5 && day <= 20)) {
      return "assats/images/Taurus.png";
    } else if ((month == 5 && day >= 21) || (month == 6 && day <= 20)) {
      return "assats/images/Gemini.png";
    } else if ((month == 6 && day >= 21) || (month == 7 && day <= 22)) {
      return "assats/images/Cancer.png";
    } else if ((month == 7 && day >= 23) || (month == 8 && day <= 23)) {
      return "assats/images/Leo.png";
    } else if ((month == 8 && day >= 24) || (month == 9 && day <= 23)) {
      return "assats/images/Virgo.png";
    } else if ((month == 9 && day >= 24) || (month == 10 && day <= 23)) {
      return "assats/images/Libra.png";
    } else if ((month == 10 && day >= 24) || (month == 11 && day <= 22)) {
      return "assats/images/Scorpio.png";
    } else if ((month == 11 && day >= 23) || (month == 12 && day <= 21)) {
      return "assats/images/Sagittarius.png";
    } else {
      return "";
    }
  }

  void postcomment(String comments) async {
    print("postcomment--------->" + comments);
    print("postcomment--------->" + widget.id);
    print("postcomment--------->${widget.edit}");
    String editid = widget.edit.toString();
    var commenturl = "http://qsnap.net/api/updateCustomerComments";
    var response = await http.post(commenturl, body: {
      'id': widget.id,
      'edit': editid,
      'comments': comments,
    });
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    var result = json.decode(response.body);
    print('Response convert body:-----------------------> ${result}');
  }

  Future _getuser() async {
    print(widget.edit);
    print(widget.id);
    print(widget.loginId);

    var contactCustomerIdval = widget.contactCustomerId;
    if (contactCustomerIdval == 0) {
      sendimg =
          "http://qsnap.net/api/shareContactCard?id=${widget.id}&edit=${widget.edit}";
      var url =
          'http://qsnap.net/api/getContactById?id=${widget.id}&edit=${widget.edit}&loginId=${widget.loginId}';
      print(url + "<------------");
      var response = await http.get(url);
      var responsbody = jsonDecode(response.body);
      var data = responsbody["response"]["contact"];
      print('Response convert data:============>  ${data}');

      if (responsbody["status"] == 200) {
        setState(() {

          fname = data["fname"];
          lname = data["lname"];
          mobile = data["phoneCode"] + data["mobile"];
          phone = data["phone"];
          dob = data["dob"];
          dob_month = int.parse(data["dob_month"]);
          dob_day = int.parse(data["dob_day"]);
          job_title = data["job_title"];
          company = data["company"];
          company_website = data["company_website"];
          // country_name = data["nationality"];
          qrcode = data["qrcode"];
          email = data["email"];
          image = data["image"];
          // nationality_code=data["nationality_code"].toLowerCase();
          facebook = data["facebook"];
          twitter = data["twitter"];
          linkedIn = data["linkedIn"];
          instagram = data["instagram"];
          tiktok = data["tiktok"];
          comments = data["comments"];
          contact1 = data["contact1_number"];
          contact2 = data["contact2_number"];
          phoneCode = data["phoneCode"];
          contact1_code = data["contact1_code"];
          contact2_code = data["contact2_code"];
          insertdatetime = data["insertdatetime"];

           print("companycompanycompanycompany--------" + instagram);
        });
        visiblerel_gps = !visiblerel_gps;

        if (dob == "0000-00-00"||dob == "2010-01-01"||dob == " ") {
          visibleDate = !visibleDate;
        }
        if (company == "") {
          visibleCompany = !visibleCompany;
        }
        if (company_website == "") {
          visiblecompany_website = !visiblecompany_website;
        }
        if (job_title == "") {
          visibleTitle = !visibleTitle;
        }
        if (contact1 == "") {
          visibleContact1 = !visibleContact1;
        }
        if (contact2 == "") {
          visibleContact2 = !visibleContact2;
        }
        if (insertdatetime == "") {
          visibleinsertdatetime = !visibleinsertdatetime;
        }

        if (comments == "") {
          visibleComments = !visibleComments;
        }
        if (facebook == "") {
          visibleface = !visibleface;
        }
        if (twitter == "") {
          visibletwitter = !visibletwitter;
        }
        if (linkedIn == "") {
          visiblelinkedin = !visiblelinkedin;
        }
        if (instagram == "") {
          visibleinsta = !visibleinsta;
        }
        if (tiktok == "") {
          visibletiktok = !visibletiktok;
        }
        if (widget.edit == 1) {
          visible = true;
        }
      }
    } else {
      sendimg =
          "http://qsnap.net/api/shareContactCard?id=${widget.contactCustomerId}&edit=${widget.edit}";
      var url =
          'http://qsnap.net/api/getContactById?id=${widget.contactCustomerId}&edit=${widget.edit}&loginId=${widget.loginId}';
      print(url + "<------------");
      var response = await http.get(url);
      var responsbody = jsonDecode(response.body);
      var data = responsbody["response"]["contact"];
      print('Response convert data:============>  ${data}');

      if (responsbody["status"] == 200) {
        setState(() {
          // print("companycompanycompanycompany--------" + data["company"]);
          // print("companycompanycompanycompany--------" + data["qrcode"]);
          // print("companycompanycompanycompany--------" + data["image"]);
          fname = data["fname"];
          lname = data["lname"];
          mobile = data["phoneCode"] + data["mobile"];
          phone = data["phone"];
          dob = data["dob"];
          job_title = data["job_title"];
          company = data["company"];
          company_website = data["company_website"];
          // country_name = data["nationality"];
          qrcode = data["qrcode"];
          email = data["email"];
          image = data["image"];
          // nationality_code=data["nationality_code"].toLowerCase();
          facebook = data["facebook"];
          twitter = data["twitter"];
          linkedIn = data["linkedIn"];
          instagram = data["instagram"];
          tiktok = data["tiktok"];
          comments = data["comments"];
          contact1 = data["contact1_number"];
          contact2 = data["contact2_number"];
          phoneCode = data["phoneCode"];
          contact1_code = data["contact1_code"];
          contact2_code = data["contact2_code"];
          insertdatetime = data["rel_datetime"];
          rel_gps = data["rel_gps"];
          dob_month = int.parse(data["dob_month"]);
          dob_day = int.parse(data["dob_day"]);
          print("dob--------" + instagram);
        });
        if (dob == "0000-00-00"||dob == "2010-01-01"||dob == "") {
          visibleDate = !visibleDate;
        }
        if (company == "") {
          visibleCompany = !visibleCompany;
        }
        if (company_website == "") {
          visiblecompany_website = !visiblecompany_website;
        }
        if (job_title == "") {
          visibleTitle = !visibleTitle;
        }
        if (contact1 == "") {
          visibleContact1 = !visibleContact1;
        }
        if (contact2 == "") {
          visibleContact2 = !visibleContact2;
        }
        if (comments == "") {
          visibleComments = !visibleComments;
        }
        if (facebook == "") {
          visibleface = !visibleface;
        }
        if (twitter == "") {
          visibletwitter = !visibletwitter;
        }
        if (linkedIn == "") {
          visiblelinkedin = !visiblelinkedin;
        }
        if (instagram == "") {
          visibleinsta = !visibleinsta;
        }
        if (tiktok == "") {
          visibletiktok = !visibletiktok;
        }
        if (widget.edit == 1) {
          visible = true;
        }
        if (insertdatetime == "") {
          visibleinsertdatetime = !visibleinsertdatetime;
        }
        if (rel_gps == "") {
          visiblerel_gps = !visiblerel_gps;
        }
      }
    }

    // print(responsbody);
    return "Sucess";
  }

  Future _deletuser() async {
    // print(widget.edit);
    // print(widget.id);
    var url =
        'http://qsnap.net/api/deleteCustomerContact?id=${widget.id}&edit=${widget.edit}';
    // print(url);
    var response = await http.get(url);
    var responsbody = jsonDecode(response.body);
    // print('Response status: ${response.statusCode}');
    if (responsbody["status"] == 200) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Home()),
      );
    }
    // print(responsbody);
    return "Sucess";
  }

  static Future<void> openMap(String rel_gps) async {
    String googleUrl =
        'https://www.google.com/maps/search/?api=1&query=$rel_gps';
    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      throw 'Could not open the map.';
    }
  }

  @override
  void initState() {
    this._getuser();

    super.initState();
  }

  String url = "https://picsum.photos/250?image=9";
  List<Alligator> alligators = [
    Alligator("https://picsum.photos/250?image=9"),
  ];

  String _text = '';
  Future<void> _launched;

  Future<void> _makePhoneCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> _facebook() async {
    const urlface = 'https://www.facebook.com/hassan.daboos.7';
    if (await canLaunch(facebook)) {
      await launch(facebook);
    } else {
      await launch("https://www.facebook.com/$facebook");
      //throw 'Could not launch $facebook';
    }
  }

  Future<void> _twitter() async {
    //const urlface = 'https://twitter.com/H_Daboos';
    if (await canLaunch(twitter)) {
      await launch(twitter);
    } else {
      await launch("https://twitter.com/$twitter");
      throw 'Could not launch $twitter';
    }
  }

  Future<void> _insta() async {
    // const urlinsta = 'https://www.instagram.com/h.daboos/';
    if (await canLaunch(instagram)) {
      await launch(instagram);
    } else {
      await launch("https://www.instagram.com/$instagram");

      throw 'Could not launch $instagram';
    }
  }

  Future<void> _linkedin() async {
    // const urlinsta = 'https://www.linkedin.com/in/hassan-daboos-2a5a66164/';
    if (await canLaunch(linkedIn)) {
      await launch(linkedIn);
    } else {
      await launch("https://www.linkedin.com/in/$linkedIn");
      throw 'Could not launch $linkedIn';
    }
  }

  Future<void> _tiktok() async {
    if (await canLaunch(tiktok)) {
      await launch(tiktok);
    } else {
      await launch("https://t.me/$tiktok");
      throw 'Could not launch $tiktok';
    }
  }

  Future<void> saveContactInPhone() async {
    try {
      // print("saving Conatct");
      PermissionStatus permission = await Permission.contacts.status;

      if (permission != PermissionStatus.granted) {
        await Permission.contacts.request();
        PermissionStatus permission = await Permission.contacts.status;

        if (permission == PermissionStatus.granted) {
          Contact newContact = new Contact();
          newContact.givenName = fname + " " + lname;
          newContact.emails = [Item(label: "email", value: email)];
          newContact.phones = [Item(label: "mobile", value: mobile)];
          _showvrfieAlert(context);
          await ContactsService.addContact(newContact);
        } else {
          //_handleInvalidPermissions(context);
        }
      } else {
        Contact newContact = new Contact();
        newContact.givenName = fname + " " + lname;
        newContact.emails = [Item(label: "email", value: email)];
        newContact.phones = [Item(label: "mobile", value: mobile)];
        _showvrfieAlert(context);
        await ContactsService.addContact(newContact);
      }
      // print("object");
    } catch (e) {
      print(e);
    }
  }

  Future<void> _makeSmS(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
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
            Icons.arrow_back_ios,
            color: Color(0xffffd800),
            size: 25,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
//        toolbarHeight: 65,
        title: Text(fname + " " + lname),
        actions: [
          Visibility(
            visible: visible,
            child: IconButton(
              icon: Icon(
                Icons.edit,
                color: Color(0xffffd800),
                size: 30,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          EditQsnap(widget.id, widget.edit, widget.loginId)),
                );
              },
            ),
          ),
        ],
      ),
      body: image == null
          ? Center(
              child: CircularProgressIndicator(
              backgroundColor: Colors.yellow,
                valueColor: new AlwaysStoppedAnimation<Color>(Colors.black),
            ))
          : SingleChildScrollView(
              child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
              child: Stack(
//          alignment: Alignment.topCenter,
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height,
                    margin: const EdgeInsets.only(top: 80.0),
                    alignment: AlignmentDirectional.center,
                    decoration: BoxDecoration(
                        color: Color(0xff000000),
                        border:
                            Border.all(color: Color(0xff000000), width: 3.0),
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  ),
                  Column(
                    children: [
                      InkWell(
                        onTap: () {
                          showPlatformDialog(
                            context: context,
                            builder: (_) => BasicDialogAlert(
                              title:Image.network(
                                image,
                                width: double.infinity,
                              ) ,
                              actions: <Widget>[
                                BasicDialogAction(
                                  title: Text("Close"),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                        child: Container(
                          height: 100.0,
                          width: 100.0,
                          decoration: new BoxDecoration(
                            // shape: BoxShape.circle,
                            // color: Colors.yellow,
                            color: const Color(0xff000000),
                            image: new DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(
                                image,
                              ),
                            ),
                            border: Border.all(
                                color: Color(0xffffd800), width: 5.0),
                            borderRadius: new BorderRadius.all(
                                const Radius.circular(100.0)),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Container(
                          height: 35,
                          child: ListTile(
                            title: Text(
                              "First Name",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 15,
                              ),
                            ),
                            subtitle: Text(
                              fname,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Container(
                          height: 35,
                          child: ListTile(
                            title: Text(
                              "Last Name",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 15,
                              ),
                            ),
                            subtitle: Text(
                              lname,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Container(
                          height: 35,
                          child: ListTile(
                              title: Text(
                                "Email",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 15,
                                ),
                              ),
                              subtitle: Row(
                                children: [
                                  Text(
                                    email,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Icon(
                                    Icons.verified_user,
                                    color: Color(0xffffd800),
                                    size: 20,
                                  ),
                                ],
                              )),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Container(
                          height: 35,
                          child: ListTile(
                            title: Text(
                              "Mobile",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 15,
                              ),
                            ),
                            subtitle: Text(
                              mobile,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                      // SizedBox(
                      //   height: 10,
                      // ),
                      // Container(
                      //   height: 35,
                      //   child: ListTile(
                      //     title: Text(
                      //       "Nationality",
                      //       style: TextStyle(
                      //         color: Colors.grey,
                      //         fontSize: 15,
                      //
                      //       ),
                      //     ),
                      //     subtitle: Row(
                      //       children: [
                      //         Text(
                      //           country_name,
                      //           style: TextStyle(
                      //             color: Colors.white,
                      //             fontSize: 16,
                      //             fontWeight: FontWeight.w600,
                      //           ),
                      //         ),
                      //         SizedBox(
                      //           width: 5,
                      //         ),
                      //         Image.asset(
                      //             'icons/flags/png/$nationality_code.png',
                      //             height: 20,
                      //             width: 20,
                      //             package: 'country_icons'),
                      //       ],
                      //     ),
                      //   ),
                      // ),

                      Visibility(
                        visible: visibleDate,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Container(
                            height: 35,
                            child: ListTile(
                              title: Text(
                                "Date of Birth",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 15,
                                ),
                              ),
                              subtitle: Row(
                                children: [
                                  Text(
                                    dob,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Image.asset(getZodiacSign(dob_day, dob_month),
                                      height: 25, width: 25),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),

                      Visibility(
                        visible: visibleCompany,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Container(
                            height: 35,
                            child: ListTile(
                              title: Text(
                                "Company",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 15,
                                ),
                              ),
                              subtitle: Text(
                                company,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: visiblecompany_website,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Container(
                            height: 35,
                            child: ListTile(
                              title: Text(
                                "Company Website",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 15,
                                ),
                              ),
                              subtitle: Text(
                                company_website,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      Visibility(
                        visible: visibleTitle,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Container(
                            height: 35,
                            child: ListTile(
                              title: Text(
                                "Title/Job Title",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 15,
                                ),
                              ),
                              subtitle: Text(
                                job_title,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      Visibility(
                        visible: visibleContact1,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Container(
                            height: 35,
                            child: ListTile(
                              title: Text(
                                "Business Number",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 15,
                                ),
                              ),
                              subtitle: Text(
                                contact1_code + '' + contact1,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      Visibility(
                        visible: visibleContact2,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Container(
                            height: 35,
                            child: ListTile(
                              title: Text(
                                "Other Number",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 15,
                                ),
                              ),
                              subtitle: Text(
                                contact2_code + '' + contact2,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      Visibility(
                        visible: visibleComments,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 15),
                          child: Container(
                            height: 35,
                            child: ListTile(
                              title: Text(
                                "Notes",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 15,
                                ),
                              ),
                              subtitle: Text(
                                comments,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: visibleinsertdatetime,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Container(
                            height: 35,
                            child: ListTile(
                              title: Text(
                                "Scan Time",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 15,
                                ),
                              ),
                              subtitle: Text(
                                insertdatetime,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: visiblerel_gps,
                        child: InkWell(
                          onTap: () {
                            openMap(rel_gps);
                          },
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10.0),
                                child: IconButton(
                                  icon: Icon(
                                    Icons.location_history_outlined,
                                    color: Color(0xffffd800),
                                    size: 30,
                                  ),
                                  // onPressed: () {
                                  //   openMap(rel_gps);
                                  // },
                                ),
                              ),
                              Text(
                                "Check scan location",
                                style: TextStyle(
                                  color: Color(0xffffd800),
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Visibility(
                              visible: visibleface,
                              child: InkWell(
                                  onTap: () {
                                    _facebook();
                                  },
                                  child: Container(
                                    alignment: Alignment.topLeft,
                                    color: Colors.black,
                                    child: Image.asset(
                                        'assats/images/facebook-white.png',
                                        height: 25,
                                        fit: BoxFit.cover),
                                  )),
                            ),
                            Visibility(
                              visible: visibletwitter,
                              child: InkWell(
                                  onTap: () {
                                    _twitter();
                                  },
                                  child: Container(
                                    alignment: Alignment.topLeft,
                                    color: Colors.black,
                                    child: Image.asset(
                                        'assats/images/twitterw.png',
                                        height: 25,
                                        fit: BoxFit.cover),
                                  )),
                            ),
                            Visibility(
                              visible: visibleinsta,
                              child: InkWell(
                                  onTap: () {
                                    _insta();
                                  },
                                  child: Container(
                                    alignment: Alignment.topLeft,
                                    color: Colors.black,
                                    child: Image.asset(
                                        'assats/images/insta-white.png',
                                        height: 25,
                                        fit: BoxFit.cover),
                                  )),
                            ),
                            Visibility(
                              visible: visiblelinkedin,
                              child: InkWell(
                                  onTap: () {
                                    _linkedin();
                                  },
                                  child: Container(
                                    alignment: Alignment.topLeft,
                                    color: Colors.black,
                                    child: Image.asset(
                                        'assats/images/linkedin-white.png',
                                        height: 25,
                                        fit: BoxFit.cover),
                                  )),
                            ),
                            Visibility(
                              visible: visibletiktok,
                              child: InkWell(
                                  onTap: () {
                                    _tiktok();
                                  },
                                  child: Container(
                                    alignment: Alignment.topLeft,
                                    // color: Colors.black,
                                    child: Image.asset(
                                        'assats/images/telegram.png',
                                        height: 25,
                                        fit: BoxFit.cover),
                                  )),
                            ),
                          ],
                        ),
                      ),

                      // Padding(
                      //   padding: const EdgeInsets.all(10.0),
                      //   child: InkWell(
                      //     child: Container(
                      //       alignment: Alignment.topLeft,
                      //       color: Colors.white,
                      //       child: Image.asset(
                      //           'assats/images/socilamedia.png',
                      //           height: 25,
                      //           fit: BoxFit.cover),
                      //     ),
                      //     onTap: () {
                      //       showModalBottomSheet<void>(
                      //         context: context,
                      //         builder: (BuildContext context) {
                      //           return Padding(
                      //             padding: const EdgeInsets.all(8.0),
                      //             child: Stack(
                      //               children: [
                      //                 Container(
                      //                   height: MediaQuery.of(context)
                      //                       .size
                      //                       .height,
                      //                   margin: const EdgeInsets.only(top: 1),
                      //                   alignment:
                      //                   AlignmentDirectional.center,
                      //                   decoration: BoxDecoration(
                      //                       color: Colors.black,
                      //                       border: Border.all(
                      //                           color:Colors.white,
                      //                           width: 3.0),
                      //                       borderRadius: BorderRadius.all(
                      //                           Radius.circular(10.0))),
                      //                 ),
                      //                 Container(
                      //                   color: Colors.black,
                      //                   height: double.infinity,
                      //                   margin: const EdgeInsets.only(
                      //                       top: 1,
                      //                       left: 1,
                      //                       right: 1,
                      //                       bottom: 1),
                      //                   child: Padding(
                      //                     padding: const EdgeInsets.only(
                      //                         top: 25,
                      //                         right: 10,
                      //                         left: 10,
                      //                         bottom: 10),
                      //                     child: ListView(
                      //                       children: [
                      //                         IconButton(
                      //                           alignment: Alignment.topLeft,
                      //                           icon: Icon(
                      //                             Icons.close_sharp,
                      //                             color: Colors.grey,
                      //                             size: 30,
                      //                           ),
                      //                           onPressed: () {
                      //                             Navigator.pop(context);
                      //                           },
                      //                         ),
                      //                         Container(
                      //                           height: 35,
                      //                           child: ListTile(
                      //                             title: Text(
                      //                               "Facebook",
                      //                               style: TextStyle(
                      //                                 color: Colors.grey,
                      //                                 fontSize: 15,
                      //                               ),
                      //                             ),
                      //                             subtitle: Text(
                      //                               facebook,
                      //                               style: TextStyle(
                      //                                 color: Colors.white,
                      //                                 fontSize: 16,
                      //                                 fontWeight: FontWeight.w600,
                      //                               ),
                      //                             ),
                      //                           ),
                      //                         ),
                      //                         SizedBox(
                      //                           height: 10,
                      //                         ),
                      //                         Container(
                      //                           height: 35,
                      //                           child: ListTile(
                      //                             title: Text(
                      //                               "Twitter",
                      //                               style: TextStyle(
                      //                                 color: Colors.grey,
                      //                                 fontSize: 15,
                      //                               ),
                      //                             ),
                      //                             subtitle: Text(
                      //                               twitter,
                      //                               style: TextStyle(
                      //                                 color: Colors.white,
                      //                                 fontSize: 16,
                      //                                 fontWeight: FontWeight.w600,
                      //                               ),
                      //                             ),
                      //                           ),
                      //                         ),
                      //                         SizedBox(
                      //                           height: 10,
                      //                         ),
                      //                         Container(
                      //                           height: 35,
                      //                           child: ListTile(
                      //                             title: Text(
                      //                               "Instagram",
                      //                               style: TextStyle(
                      //                                 color: Colors.grey,
                      //                                 fontSize: 15,
                      //                               ),
                      //                             ),
                      //                             subtitle: Text(
                      //                               instagram,
                      //                               style: TextStyle(
                      //                                 color: Colors.white,
                      //                                 fontSize: 16,
                      //                                 fontWeight: FontWeight.w600,
                      //                               ),
                      //                             ),
                      //                           ),
                      //                         ),
                      //                         SizedBox(
                      //                           height: 10,
                      //                         ),
                      //                         Container(
                      //                           height: 35,
                      //                           child: ListTile(
                      //                             title: Text(
                      //                               "TikTok",
                      //                               style: TextStyle(
                      //                                 color: Colors.grey,
                      //                                 fontSize: 15,
                      //                               ),
                      //                             ),
                      //                             subtitle: Text(
                      //                               tiktok,
                      //                               style: TextStyle(
                      //                                 color: Colors.white,
                      //                                 fontSize: 16,
                      //                                 fontWeight: FontWeight.w600,
                      //                               ),
                      //                             ),
                      //                           ),
                      //                         ),
                      //                         SizedBox(
                      //                           height: 10,
                      //                         ),
                      //                         Container(
                      //                           height: 35,
                      //                           child: ListTile(
                      //                             title: Text(
                      //                               "linkedIn",
                      //                               style: TextStyle(
                      //                                 color: Colors.grey,
                      //                               ),
                      //                             ),
                      //                             subtitle: Text(
                      //                               linkedIn,
                      //                               style: TextStyle(
                      //                                 color: Colors.white,
                      //                                 fontSize: 16,
                      //                                 fontWeight: FontWeight.w600,
                      //                               ),
                      //                             ),
                      //                           ),
                      //                         ),
                      //
                      //                       ],
                      //                     ),
                      //                   ),
                      //                 ),
                      //               ],
                      //             ),
                      //           );
                      //         },
                      //       );
                      //     },
                      //   ),
                      // ),

                      SizedBox(
                        height: 40,
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 10.0, bottom: 40.0),
                        child: Image.network(
                          qrcode,
                          height: 75,
                          width: 80,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            )),
      floatingActionButton: SpeedDial(
        child: Icon(Icons.add),
        closedForegroundColor: Colors.black,
        openForegroundColor: Colors.black,
        closedBackgroundColor: Colors.yellow,
        openBackgroundColor: Colors.yellow,
//        labelsStyle:BlendMode.color(Colors.yellow) ,
        speedDialChildren: <SpeedDialChild>[
          SpeedDialChild(
            child: Icon(Icons.chat),
            foregroundColor: Colors.black87,
            backgroundColor: Colors.white,
            label: "Chat",
            onPressed: () {
              if(widget.contactCustomerId!=0){
              //   print("contactCustomerId----->${widget.contactCustomerId}");
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //       builder: (context) => ChatPage(widget.loginId,widget.contactCustomerId,fname + " " + lname)),
              // );


                NavigationService.instance.navigationKey.currentState.pushNamed(
                  "ChatPage",
                  arguments: {
                    "sender_id": widget.loginId,
                    "receiver_name": fname+" "+lname,
                    "receiverId": widget.contactCustomerId,
                  },
                );

              }else{
                _showChatAlert(context);
              }
            },
            closeSpeedDialOnPressed: false,
          ),
          SpeedDialChild(
            child: Icon(Icons.add_comment),
            foregroundColor: Colors.black87,
            backgroundColor: Colors.white,
            label: "Add Notes",
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text(
                        "Add Your Notes ",
                        style: TextStyle(color: Colors.black, fontSize: 20),
                      ),
                      content: TextField(
                        controller: _commentController,
                      ),
                      actions: [
                        MaterialButton(
                          elevation: 5.0,
                          child: Text("add"),
                          onPressed: () {
                            print(
                                "onPressed---------->${_commentController.text}");
                            postcomment(_commentController.text);

                            setState(() {
                              // this.initState();
                              // this._getuser();
                            });
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MyWallet()),
                            );
                          },
                        )
                      ],
                    );
                  });
            },
            closeSpeedDialOnPressed: false,
          ),
          SpeedDialChild(
            child: Icon(Icons.add_circle_outline),
            foregroundColor: Colors.black87,
            backgroundColor: Colors.white,
            label: "Add to Contacts",
            onPressed: () {
              saveContactInPhone();
            },
            closeSpeedDialOnPressed: false,
          ),
          SpeedDialChild(
            child: Icon(Icons.markunread),
            foregroundColor: Colors.black87,
            backgroundColor: Colors.white,
            label: 'Message',
            onPressed: () => setState(() {
              _launched = _makePhoneCall('sms:$mobile');
            }),
          ),
          SpeedDialChild(
            child: Icon(Icons.call),
            foregroundColor: Colors.black87,
            backgroundColor: Colors.white,
            label: 'Call',
            onPressed: () => setState(() {
              _launched = _makePhoneCall('tel:$mobile');
            }),
          ),
          SpeedDialChild(
            child: Icon(Icons.share),
            foregroundColor: Colors.black87,
            backgroundColor: Colors.white,
            label: 'Share',
            onPressed: () => _shareButton(),
          ),
          SpeedDialChild(
            child: Icon(Icons.delete),
            foregroundColor: Colors.black87,
            backgroundColor: Colors.white,
            label: 'Delete',
            onPressed: () {
              _deletuser();
            },
          ),
          // SpeedDialChild(
          //   child: Icon(Icons.settings),
          //   foregroundColor: Colors.black87,
          //   backgroundColor: Colors.white,
          //   label: 'Edit Qsnap',
          //   onPressed: () {
          //     setState(() {
          //
          //     });
          //   },
          // ),
          //  Your other SpeeDialChildren go here.
        ],
      ),
    );
  }

  // share(BuildContext context) {
  //   final RenderBox box = context.findRenderObject();
  //
  //   Share.share("$sendimg",
  //       subject: sendimg,
  //       sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
  // }
  void _shareButton() async {
    var request = await HttpClient().getUrl(Uri.parse(sendimg));
    var response1 = await request.close();
    Uint8List bytes = await consolidateHttpClientResponseBytes(response1);
    await Share.file('ESYS AMLOG', 'amlog.png', bytes, 'image/png',text: "https://qsnap.net/home/addcontact/${widget.contactCustomerId}");
  }
}

_showvrfieAlert(BuildContext context) {
  showPlatformDialog(
    context: context,
    builder: (_) => BasicDialogAlert(
      title: Text(
        "The contact has been added successfully.",
        style: TextStyle(
          color: Colors.black,
        ),
        textAlign: TextAlign.center,
      ),
      actions: <Widget>[
        BasicDialogAction(
          title: Text("Ok"),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    ),
  );
}
_showChatAlert(BuildContext context) {
  showPlatformDialog(
    context: context,
    builder: (_) => BasicDialogAlert(
      title: Text(
        "The contact not used for qsnap.",
        style: TextStyle(
          color: Colors.black,
        ),
        textAlign: TextAlign.center,
      ),
      actions: <Widget>[
        BasicDialogAction(

          title: Text("Ok",textAlign: TextAlign.center,),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    ),
  );
}
