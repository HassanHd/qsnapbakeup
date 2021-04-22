import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Editprofile.dart';
import 'mywallet.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class MyProfile extends StatefulWidget {
  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  var id;

  getid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    id = prefs.get("id");
    setState(() {
      id = prefs.get("id");
      // print("ssssssid-----"+id);
    });
    this._getuser();
  }

  var fname,
      lname,
      email,
      mobile,
      contact1,
      contact1_code,
      contact2_code,
      contact2,
      phoneCode,
      country_name,
      city_name,
      image,
      qrcode,
      dob,
      job_title,
      company,
      phone,
      nationality,
      nationality_code,
      country_code,
      dob_month,
      iduser,
      dob_day,
      facebook,
      twitter,
      instagram,
      tiktok,
      linkedIn,
      comments;
  bool visible = false;
  bool visibleface = true;
  bool visibletwitter = true;
  bool visibleinsta = true;
  bool visiblelinkedin = true;
  bool visibletiktok = true;
  bool visibletContact1 = true;
  bool visibletContact2 = true;

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

  Future _getuser() async {
    var url = 'http://qsnap.net/api/getProfile?id=$id';
    var response = await http.get(url);
    var responsbody = jsonDecode(response.body);
    var data = responsbody["response"]["customer"];
    if (responsbody["status"] == 200) {
      setState(() {
        iduser = data["id"];
        //print("comments------>$iduser");
        fname = data["fname"];
        lname = data["lname"];
        email = data["email"];
        mobile = data["mobile"];
        phoneCode = data["phoneCode"];
        contact1_code = data["contact1_code"];
        contact2_code = data["contact2_code"];
        contact1 = data["contact1_number"];
        contact2 = data["contact2_number"];
        dob = data["dob"];
        job_title = data["job_title"];
        company = data["company"];
        country_name = data["country_name"];
        city_name = data["city_name"];
        image = data["image"];
        qrcode = data["qrcode"];
        facebook = data["facebook"];
        twitter = data["twitter"];
        linkedIn = data["linkedIn"];
        instagram = data["instagram"];
        tiktok = data["tiktok"];
        var nationalitynull = data["nationality"];
        if (nationalitynull != null) {
          nationality = data["nationality"];
        } else {
          nationality = "Nonationality";
        }
        country_code = data["country_code"].toLowerCase();
        var nationality_codenull = data["nationality_code"].toLowerCase();
        if (nationality_codenull != null) {
          nationality_code = data["nationality_code"].toLowerCase();
         // print("comments------>$nationality_code");
        } else {
          nationality_code = country_code;
        }
        dob_month= int.parse(data["dob_month"]);
       // print("country_code------>$dob_month");
        dob_day= int.parse(data["dob_day"]);
       // print("country_code------>$dob_day");



      });
      if(contact1==""){
        visibletContact1 = !visibletContact1;
      }
      if(contact2==""){
        visibletContact2 = !visibletContact2;
      }
      if(facebook==""){
        visibleface = !visibleface;
      }
      if(twitter==""){
        visibletwitter = !visibletwitter;
      }
      if(linkedIn==""){
        visiblelinkedin = !visiblelinkedin;
      }
      if(instagram==""){
        visibleinsta = !visibleinsta;
      }
      if(tiktok==""){
        visibletiktok = !visibletiktok;
      }
    }
    // print(responsbody);
    return "Sucess";
  }
  Future<void> _facebook() async {
    const urlface = 'https://www.facebook.com/hassan.daboos.7';
    if (await canLaunch(facebook)) {
      await launch(facebook);
    } else {
      throw 'Could not launch $facebook';
    }
  }
  Future<void> _twitter() async {
    //const urlface = 'https://twitter.com/H_Daboos';
    if (await canLaunch(twitter)) {
      await launch(twitter);
    } else {
      throw 'Could not launch $twitter';
    }
  }
  Future<void> _insta() async {
    // const urlinsta = 'https://www.instagram.com/h.daboos/';
    if (await canLaunch(instagram)) {
      await launch(instagram);
    } else {
      throw 'Could not launch $instagram';
    }
  }
  Future<void> _linkedin() async {
    // const urlinsta = 'https://www.linkedin.com/in/hassan-daboos-2a5a66164/';
    if (await canLaunch(linkedIn)) {
      await launch(linkedIn);
    } else {
      throw 'Could not launch $linkedIn';
    }
  }
  Future<void> _tiktok() async {
    // const urlinsta = 'https://www.linkedin.com/in/hassan-daboos-2a5a66164/';
    if (await canLaunch(tiktok)) {
      await launch(tiktok);
    } else {
      throw 'Could not launch $tiktok';
    }
  }
  @override
  void initState() {
    this.getid();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff000000),
        centerTitle: true,
        elevation: 3,
        toolbarHeight: 55,
        title: Image.asset('assats/images/logowhite.png',
            height: 45.0, fit: BoxFit.cover),
        // actions: [
        //   IconButton(
        //     icon: Icon(
        //       Icons.qr_code,
        //       color: Colors.white,
        //       size: 30,
        //     ),
        //     onPressed: () {
        //       Navigator.push(
        //         context,
        //         MaterialPageRoute(
        //             builder: (context) =>
        //                 //qrcodeimg(qrcode)
        //                 Qrcodetabbs(iduser)),
        //       );
        //     },
        //   ),
        // ],
      ),
      body:image == null
    ? Center(
    child: CircularProgressIndicator(
      backgroundColor: Colors.yellow,
    )): SingleChildScrollView(
          child:Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 10.0),
                child: Stack(
//          alignment: Alignment.topCenter,
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height-40,
                      margin: const EdgeInsets.only(top: 60),
                      alignment: AlignmentDirectional.center,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border:
                              Border.all(color: Color(0xffffd800), width: 3.0),
                          borderRadius:
                              BorderRadius.all(Radius.circular(10.0))),
                    ),
                    Column(
                      children: [
                        Center(
                          child: image == null
                              ? Container(
                                  height: 90.0,
                                  width: double.infinity,
                                  decoration: new BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: new DecorationImage(
                                        fit: BoxFit.contain,
                                        image: AssetImage(
                                            "assats/images/profilee.png")),
                                    border: Border.all(
                                        color: const Color(0xffffd800),
                                        width: 3),
                                  ),
                                )
                              : Container(
                                  height: 90.0,
                                  width: double.infinity,
                                  decoration: new BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(0xffffd800),
                                    image: new DecorationImage(
                                      fit: BoxFit.scaleDown,
                                      image: NetworkImage(
                                        image,
                                      ),
                                    ),
                                    border: Border.all(
                                        color: const Color(0xffffd800),
                                        width: 3),
                                  ),
                                ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 60,
                              child: Container(
                                height: 35,
                                child: ListTile(
                                  title: Text(
                                    "First Name",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 15,
                                       fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  subtitle: Text(
                                    fname,
                                    style: TextStyle(
                                      color: Color(0xff000000),
                                      fontSize: 16,
                                       // fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 30,
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Editprofile(
                                          titlecountry: " ",
                                          codecountry: " ",
                                          titlecity: " ",
                                          codecity: " ",
                                          titlenationalities: " ",
                                          codenationalities: " ",
                                        )),
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 5.0),
                                  child: Row(
                                    children: [
                                      IconButton(
                                        icon: Icon(
                                          Icons.edit_outlined,
                                          color: Color(0xff000000),
                                          size: 20,
                                        ),
                                      ),
                                      Text(
                                        "Edit",
                                        style: TextStyle(
                                          color: Color(0xff000000),
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          height: 35,
                          child: ListTile(
                            title: Text(
                              "Last Name",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            subtitle: Text(
                              lname,
                              style: TextStyle(
                                color: Color(0xff000000),
                                fontSize: 16,
                                //fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: 35,
                          child: ListTile(
                            title: Text(
                              "Email",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            subtitle: Row(
                              children: [
                                Text(
                                  email,
                                  style: TextStyle(
                                    color: Color(0xff000000),
                                    fontSize: 16,
                                    // fontWeight: FontWeight.w700,
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
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: 35,
                          child: ListTile(
                            title: Text(
                              "Country",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            subtitle: Text(
                              country_name,
                              style: TextStyle(
                                color: Color(0xff000000),
                                fontSize: 16,
                                // fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: 35,
                          child: ListTile(
                            title: Text(
                              "City",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            subtitle: Text(
                              city_name,
                              style: TextStyle(
                                color: Color(0xff000000),
                                fontSize: 16,
                                // fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: 35,
                          child: ListTile(
                            title: Text(
                              "Nationality",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            subtitle: Row(
                              children: [
                                Text(
                                  nationality,
                                  style: TextStyle(
                                    color: Color(0xff000000),
                                    fontSize: 16,
                                    // fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Image.asset(
                                    'icons/flags/png/$nationality_code.png',
                                    height: 20,
                                    width: 20,
                                    package: 'country_icons'),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: 35,
                          child: ListTile(
                            title: Text(
                              "Date Of Birth",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            subtitle: Row(
                              children: [
                                Text(
                                  dob,
                                  style: TextStyle(
                                    color: Color(0xff000000),
                                    fontSize: 16,
                                    // fontWeight: FontWeight.w700,
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
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: 35,
                          child: ListTile(
                            title: Text(
                              "Company",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            subtitle: Text(
                              company,
                              style: TextStyle(
                                color: Color(0xff000000),
                                fontSize: 16,
                                // fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: 35,
                          child: ListTile(
                            title: Text(
                              "Title/Job Title",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            subtitle: Text(
                              job_title,
                              style: TextStyle(
                                color: Color(0xff000000),
                                fontSize: 16,
                                // fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: 35,
                          child: ListTile(
                            title: Text(
                              "Mobile",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            subtitle: Text(
                              phoneCode + "" + mobile,
                              style: TextStyle(
                                color: Color(0xff000000),
                                fontSize: 16,
                                //fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Visibility(
                          visible: visibletContact1,
                          child: Container(
                            height: 35,
                            child: ListTile(
                              title: Text(
                                "Contact 1",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              subtitle: Text(
                                contact1_code+''+contact1,
                                style: TextStyle(
                                  color: Color(0xff000000),
                                  fontSize: 16,
                                 // fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Visibility(
                          visible: visibletContact2,
                          child: Container(
                            height: 35,
                            child: ListTile(
                              title: Text(
                                "Contact 2",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              subtitle: Text(
                                contact2_code+''+contact2,
                                style: TextStyle(
                                  color: Color(0xff000000),
                                  fontSize: 16,
                                  //fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
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
                                      color: Colors.white,

                                      child: Image.asset(
                                          'assats/images/fbb.png',
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
                                      color: Colors.white,

                                      child: Image.asset(
                                          'assats/images/twitterb.png',
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
                                      color: Colors.white,

                                      child: Image.asset(
                                          'assats/images/instab.png',
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
                                      color: Colors.white,

                                      child: Image.asset(
                                          'assats/images/linkedb.png',
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
                                      color: Colors.white,

                                      child: Image.asset(
                                          'assats/images/tiktokb.png',
                                          height: 25,

                                          fit: BoxFit.cover),
                                    )),
                              ),
                            ],
                          ),
                        )
                        // Padding(
                        //   padding: const EdgeInsets.all(15.0),
                        //   child: InkWell(
                        //     child: Container(
                        //       alignment: Alignment.topLeft,
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
                        //                       AlignmentDirectional.center,
                        //                   decoration: BoxDecoration(
                        //                       color: Colors.white,
                        //                       border: Border.all(
                        //                           color: Color(0xffffd800),
                        //                           width: 3.0),
                        //                       borderRadius: BorderRadius.all(
                        //                           Radius.circular(10.0))),
                        //                 ),
                        //                 Container(
                        //                   color: Colors.white,
                        //                   height: double.infinity,
                        //                   margin: const EdgeInsets.only(
                        //                       top: 5,
                        //                       left: 5,
                        //                       right: 5,
                        //                       bottom: 5),
                        //                   child: Padding(
                        //                     padding: const EdgeInsets.only(
                        //                         top: 5,
                        //                         right: 10,
                        //                         left: 10,
                        //                         bottom: 10),
                        //                     child: ListView(
                        //                       children: [
                        //                         Row(
                        //                           children: [
                        //                             Expanded(
                        //                               flex: 70,
                        //                               child: Text(
                        //                                 "social media",
                        //                                 style: TextStyle(
                        //                                   fontWeight:
                        //                                       FontWeight.bold,
                        //                                   fontSize: 25,
                        //                                 ),
                        //                               ),
                        //                             ),
                        //                             Expanded(
                        //                               flex: 20,
                        //                               child: IconButton(
                        //                                 alignment:
                        //                                     Alignment.topRight,
                        //                                 icon: Icon(
                        //                                   Icons.close_sharp,
                        //                                   color: Colors.black,
                        //                                   size: 30,
                        //                                 ),
                        //                                 onPressed: () {
                        //                                   Navigator.pop(
                        //                                       context);
                        //                                 },
                        //                               ),
                        //                             ),
                        //                           ],
                        //                         ),
                        //                         Container(
                        //                           height: 35,
                        //                           child: ListTile(
                        //                             title: Text(
                        //                               "Facebook",
                        //                               style: TextStyle(
                        //                                 color: Colors.grey,
                        //                                 fontSize: 15,
                        //                                 fontWeight:
                        //                                     FontWeight.w500,
                        //                               ),
                        //                             ),
                        //                             subtitle: Text(
                        //                               facebook,
                        //                               style: TextStyle(
                        //                                 color:
                        //                                     Color(0xff000000),
                        //                                 fontSize: 16,
                        //                                 fontWeight:
                        //                                     FontWeight.w600,
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
                        //                               "twitter",
                        //                               style: TextStyle(
                        //                                 color: Colors.grey,
                        //                                 fontSize: 15,
                        //                                 fontWeight:
                        //                                     FontWeight.w500,
                        //                               ),
                        //                             ),
                        //                             subtitle: Text(
                        //                               twitter,
                        //                               style: TextStyle(
                        //                                 color:
                        //                                     Color(0xff000000),
                        //                                 fontSize: 16,
                        //                                 fontWeight:
                        //                                     FontWeight.w600,
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
                        //                               "Linkedin",
                        //                               style: TextStyle(
                        //                                 color: Colors.grey,
                        //                                 fontSize: 15,
                        //                                 fontWeight:
                        //                                     FontWeight.w500,
                        //                               ),
                        //                             ),
                        //                             subtitle: Text(
                        //                               linkedIn,
                        //                               style: TextStyle(
                        //                                 color:
                        //                                     Color(0xff000000),
                        //                                 fontSize: 16,
                        //                                 fontWeight:
                        //                                     FontWeight.w600,
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
                        //                                 fontWeight:
                        //                                     FontWeight.w500,
                        //                               ),
                        //                             ),
                        //                             subtitle: Text(
                        //                               instagram,
                        //                               style: TextStyle(
                        //                                 color:
                        //                                     Color(0xff000000),
                        //                                 fontSize: 16,
                        //                                 fontWeight:
                        //                                     FontWeight.w600,
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
                        //                                 fontWeight:
                        //                                     FontWeight.w500,
                        //                               ),
                        //                             ),
                        //                             subtitle: Text(
                        //                               tiktok,
                        //                               style: TextStyle(
                        //                                 color:
                        //                                     Color(0xff000000),
                        //                                 fontSize: 16,
                        //                                 fontWeight:
                        //                                     FontWeight.w600,
                        //                               ),
                        //                             ),
                        //                           ),
                        //                         ),
                        //                         SizedBox(
                        //                           height: 10,
                        //                         ),
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
                      ],
                    )
                  ],
                ),
              )
      ),
    );
  }
}
