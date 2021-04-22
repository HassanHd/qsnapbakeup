import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Home.dart';
import 'Nationalities.dart';
import 'cityeditprofile.dart';
import 'countryeditprofile.dart';
import 'loginscreen.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'LoaderDialog.dart';
import 'BottomSheetinfo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_country_picker/flutter_country_picker.dart';
import 'package:custom_switch_button/custom_switch_button.dart';

class Editprofile extends StatefulWidget {
  String titlecountry;
  String codecountry;
  String titlecity;
  String codecity;
  String titlenationalities;
  String codenationalities;

  Editprofile(
      {this.titlecountry,
      this.codecountry,
      this.titlecity,
      this.codecity,
      this.titlenationalities,
      this.codenationalities});

  @override
  _EditprofileState createState() => _EditprofileState();
}

class _EditprofileState extends State<Editprofile> {
  var id;
  final GlobalKey<State> _LoaderDialog = new GlobalKey<State>();

  getid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    id = prefs.get("id");
    setState(() {
      id = prefs.get("id");
      print("id--------------------" + id);
      _getuser();
    });
  }

  int i;
  String isCheckednationalty = "0";
  bool isCheckednationaltyb = false;
  String isCheckedcountry = "0";
  bool isCheckedcountryb = false;
  String isCheckedcity = "0";
  bool isCheckedcityb = false;
  String isCheckeddob = "0";
  bool isCheckeddobb = false;
  String isCheckedcompany = "0";
  bool isCheckedcompanyb = false;
  String isCheckedtitle = "0";
  bool isCheckedtitleb = false;
  String isCheckedphone = "0";
  bool isCheckedphoneb = false;
  String isCheckedcontact1 = "0";
  bool isCheckedcontact1b = false;
  String isCheckedcontact2 = "0";
  bool isCheckedcontact2b = false;
  String isCheckedcompanywebsite = "0";
  bool isCheckedcompanywebsiteb = false;
  String isCheckedfacebook = "0";
  bool isCheckedfacebookb = false;
  String isCheckedtwitter = "0";
  bool isCheckedtwitterb = false;
  String isCheckedinstgram = "0";
  bool isCheckedinstgramb = false;
  String isCheckedlinkedin = "0";
  bool isCheckedlinkedinb = false;
  String isCheckedtaktok = "0";
  bool isCheckedtaktokb = false;

  String _dropDownNationality;
  String _dropDownkeyNationality;
  List dataNationality = List();

  Future<String> _getNationality() async {
    var url = 'http://qsnap.net/api/getNationalities';
    var response = await http.get(url);
    var responsbody = jsonDecode(response.body)["response"]["data"];
    setState(() {
      dataNationality = responsbody;
    });
    // print(responsbody);
    return "Sucess";
  }

  String _dropDownValue;
  String _dropDownkey;
  List data = List();

  Future<String> _getcountry() async {
    var url = 'http://qsnap.net/api/getCountries';
    var response = await http.get(url);
    var responsbody = jsonDecode(response.body)["response"]["data"];
    setState(() {
      data = responsbody;
    });
    // print(responsbody);
    return "Sucess";
  }

  String _dropDownValuecity;
  List datacity = List();

  Future<String> fetchcity(String code) async {
    var url = 'http://qsnap.net/api/getCitiesByCountry?countryCode=$code';
    var response = await http.get(url);
    var responsbody = jsonDecode(response.body)["response"]["data"];
    setState(() {
      datacity = responsbody;
    });

    // print(responsbody);
    return "Sucess";
  }

  DateTime selectedDate = DateTime(2010, 1, 1);

  Future<void> _selectDate(BuildContext context) async {
    DatePicker.showDatePicker(context,
        showTitleActions: true,
        minTime: DateTime(1940, 1, 1),
        maxTime: DateTime(2010, 12, 30),
        theme: DatePickerTheme(
            headerColor: Color(0xffffd800),
            backgroundColor: Colors.black,
            itemStyle: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
            doneStyle: TextStyle(color: Colors.black, fontSize: 16)),
        onChanged: (date) {
      setState(() {
        selectedDate = date;
      });
      print('change $date in time zone ' +
          date.timeZoneOffset.inHours.toString());
    }, onConfirm: (date) {
      print('confirm $date');
      setState(() {
        selectedDate = date;
      });
      // selectedDate=date;
    }, currentTime: DateTime.now(), locale: LocaleType.en);
  }

  Future<void> _showSelectionDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text("From where do you want to take the photo?"),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    GestureDetector(
                      child: Text("Gallery"),
                      onTap: () {
                        _getFromGallery();
                        Navigator.pop(context);
                      },
                    ),
                    Padding(padding: EdgeInsets.all(8.0)),
                    GestureDetector(
                      child: Text("Camera"),
                      onTap: () {
                        _getFromCamera();
                        Navigator.pop(context);
                      },
                    )
                  ],
                ),
              ));
        });
  }

  /// Variables
  File imageFile;
  var base64Image;
  TextEditingController _fnameController = TextEditingController();
  TextEditingController _lnameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _nationalityController = TextEditingController();
  TextEditingController _companyController = TextEditingController();
  TextEditingController _jobtitleController = TextEditingController();
  TextEditingController _mobileController = TextEditingController();
  TextEditingController _contact1Controller = TextEditingController();
  TextEditingController _contact2Controller = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _CommentController = TextEditingController();
  TextEditingController _companywebsiteController = TextEditingController();
  TextEditingController _facebookController = TextEditingController();
  TextEditingController _twitterController = TextEditingController();
  TextEditingController _instagramController = TextEditingController();
  TextEditingController _tiktokController = TextEditingController();
  TextEditingController _linkedinController = TextEditingController();
  var fname, lname, mobile, job_title, company, phone;

  var dob = " ";
  var image = " ";
  var country_name = "";
  var Nationality_name = "";
  var Nationality_id = "";
  var city_name = "";
  var country_id = "";
  var city_id = "";
  var dob_month, dob_day;

  String dialingCodemobile = " ";
  String dialingCodecontact1 = " ";
  String dialingCodecontact2 = " ";

  Future _getuser() async {
    var url = 'http://qsnap.net/api/getProfile?id=$id';
    var response = await http.get(url);
    var responsbody = jsonDecode(response.body);
    var data = responsbody["response"]["customer"];
    print('Response status: ${response.statusCode}');
    if (responsbody["status"] == 200) {
      setState(() {
        _fnameController.text = data["fname"];
        image = data["image"];
        dob_month = int.parse(data["dob_month"]);
        dob_day = int.parse(data["dob_day"]);
        _lnameController.text = data["lname"];
        _emailController.text = data["email"];
        _nationalityController.text = data["nationality"];
        _mobileController.text = data["mobile"];
        dob = data["dob"];
        if (dob == "0000-00-00") {
          dob = "";
        }
        _jobtitleController.text = data["job_title"];
        _companyController.text = data["company"];
        country_name = data["country_name"];
        city_name = data["city_name"];
        Nationality_name = data["nationality"];
        country_id = data["countryId"];
        city_id = data["cityId"];
        Nationality_id = data["nationalityId"];
        _companywebsiteController.text = data["company_website"];
        _facebookController.text = data["facebook"];
        _twitterController.text = data["twitter"];
        _linkedinController.text = data["linkedIn"];
        _instagramController.text = data["instagram"];
        _tiktokController.text = data["tiktok"];
        _contact1Controller.text = data["contact1_number"];
        _contact2Controller.text = data["contact2_number"];
        dialingCodemobile = data["phoneCode"];
        dialingCodecontact1 = data["contact1_code"];
        dialingCodecontact2 = data["contact2_code"];
        isCheckedphone = data["toggle_phone"];
        if (isCheckedphone == "0") {
          isCheckedphoneb = false;
        } else if (isCheckedphone == "1") {
          isCheckedphoneb = true;
        } else {
          isCheckedphone = "0";
          isCheckedphoneb = false;
        }
        isCheckedcountry = data["toggle_countryId"];
        if (isCheckedcountry == "0") {
          isCheckedcountryb = false;
        } else if (isCheckedcountry == "1") {
          isCheckedcountryb = true;
        } else {
          isCheckedcountry = "0";
          isCheckedcountryb = false;
        }
        isCheckedcontact1 = data["toggle_contact1_number"];
        if (isCheckedcontact1 == "0") {
          isCheckedcontact1b = false;
        } else if (isCheckedcontact1 == "1") {
          isCheckedcontact1b = true;
        } else {
          isCheckedcontact1 = "0";
          isCheckedcontact1b = false;
        }
        isCheckedcontact2 = data["toggle_contact2_number"];
        if (isCheckedcontact2 == "0") {
          isCheckedcontact2b = false;
        } else if (isCheckedcontact2 == "1") {
          isCheckedcontact2b = true;
        } else {
          isCheckedcontact2 = "0";
          isCheckedcontact2b = false;
        }

        isCheckedcity = data["toggle_cityId"];
        if (isCheckedcity == "0") {
          isCheckedcityb = false;
        } else if (isCheckedcity == "1") {
          isCheckedcityb = true;
        } else {
          isCheckedcity = "0";
          isCheckedcityb = false;
        }
        isCheckeddob = data["toggle_dob"];
        if (isCheckeddob == "0") {
          isCheckeddobb = false;
        } else if (isCheckeddob == "1") {
          isCheckeddobb = true;
        } else {
          isCheckeddob = "0";
          isCheckeddobb = false;
        }
        isCheckedtitle = data["toggle_job_title"];
        if (isCheckedtitle == "0") {
          isCheckedtitleb = false;
        } else if (isCheckedtitle == "1") {
          isCheckedtitleb = true;
        } else {
          isCheckedtitle = "0";
          isCheckedtitleb = false;
        }
        isCheckedcompany = data["toggle_company"];
        if (isCheckedcompany == "0") {
          isCheckedcompanyb = false;
        } else if (isCheckedcompany == "1") {
          isCheckedcompanyb = true;
        } else {
          isCheckedcompany = "0";
          isCheckedcompanyb = false;
        }
        isCheckednationalty = data["toggle_nationalityId"];
        if (isCheckednationalty == "0") {
          isCheckednationaltyb = false;
        } else if (isCheckednationalty == "1") {
          isCheckednationaltyb = true;
        } else {
          isCheckednationalty = "0";
          isCheckednationaltyb = false;
        }
        isCheckednationalty = data["toggle_nationalityId"];
        if (isCheckednationalty == "0") {
          isCheckednationaltyb = false;
        } else if (isCheckednationalty == "1") {
          isCheckednationaltyb = true;
        } else {
          isCheckednationalty = "0";
          isCheckednationaltyb = false;
        }
        isCheckedfacebook = data["toggle_facebook"];
        if (isCheckedfacebook == "0") {
          isCheckedfacebookb = false;
        } else if (isCheckedfacebook == "1") {
          isCheckedfacebookb = true;
        } else {
          isCheckedfacebook = "0";
          isCheckedfacebookb = false;
        }
        isCheckedtwitter = data["toggle_twitter"];
        if (isCheckedtwitter == "0") {
          isCheckedtwitterb = false;
        } else if (isCheckedtwitter == "1") {
          isCheckedtwitterb = true;
        } else {
          isCheckedtwitter = "0";
          isCheckedtwitterb = false;
        }
        isCheckedinstgram = data["toggle_instagram"];
        if (isCheckedinstgram == "0") {
          isCheckedinstgramb = false;
        } else if (isCheckedinstgram == "1") {
          isCheckedinstgramb = true;
        } else {
          isCheckedinstgram = "0";
          isCheckedinstgramb = false;
        }
        isCheckedtaktok = data["toggle_tiktok"];
        if (isCheckedtaktok == "0") {
          isCheckedtaktokb = false;
        } else if (isCheckedtaktok == "1") {
          isCheckedtaktokb = true;
        } else {
          isCheckedtaktok = "0";
          isCheckedtaktokb = false;
        }
        isCheckedlinkedin = data["toggle_linkedIn"];
        if (isCheckedlinkedin == "0") {
          isCheckedlinkedinb = false;
        } else if (isCheckedlinkedin == "1") {
          isCheckedlinkedinb = true;
        } else {
          isCheckedlinkedin = "0";
          isCheckedlinkedinb = false;
        }
        isCheckedcompanywebsite = data["toggle_company_website"];
        if (isCheckedcompanywebsite == "0") {
          isCheckedcompanywebsiteb = false;
        } else if (isCheckedcompanywebsite == "1") {
          isCheckedcompanywebsiteb = true;
        } else {
          isCheckedcompanywebsite = "0";
          isCheckedcompanywebsiteb = false;
        }
        i = data["permission_count"];
        print(i);

        print("fname------>$Nationality_name");
      });
    }
    // print(responsbody);
    return "Sucess";
  }

  bool _switchcompany = true;

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
      return " ";
    }
  }

  //updattoggel
  void updattoggel() async {
    print("hassan-------------->" + id);
    String Url = "http://qsnap.net/api/toggleSharePermissions";
    print("isCheckedcountry================>$isCheckedcountry");
    print("isCheckedcity================>$isCheckedcity");
    print("isCheckeddob================>$isCheckeddob");
    print("isCheckedtitle================>$isCheckedtitle");
    print("isCheckedcompany================>$isCheckedcompany");
    print("isCheckedcompanywebsite================>$isCheckedcompanywebsite");
    print("isCheckednationalty================>$isCheckednationalty");
    print("isCheckedfacebook================>$isCheckedfacebook");
    print("isCheckedtwitter================>$isCheckedtwitter");
    print("isCheckedinstgram================>$isCheckedinstgram");
    print("isCheckedtaktok================>$isCheckedtaktok");
    print("isCheckedlinkedin================>$isCheckedlinkedin");
    print("isCheckedcontact1================>$isCheckedcontact1");
    print("isCheckedcontact2================>$isCheckedcontact2");
    var response = await http.post(Url, body: {
      "customerId": id,
      'phone': "1",
      'countryId': isCheckedcountry,
      'cityId': isCheckedcity,
      'dob': isCheckeddob,
      'job_title': isCheckedtitle,
      'company': isCheckedcompany,
      'nationalityId': isCheckednationalty,
      'image': "1",
      'company_website': isCheckedcompanywebsite,
      'facebook': isCheckedfacebook,
      'twitter': isCheckedtwitter,
      'instagram': isCheckedinstgram,
      'tiktok': isCheckedtaktok,
      'linkedIn': isCheckedlinkedin,
      'contact1_number': isCheckedcontact1,
      'contact2_number': isCheckedcontact2,
    });

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    var result = json.decode(response.body);
    print('Response convert body: ${result}');
    if (result["status"] == 200) {
      print("donetogel______------>200");
    }
  }

//updatprfile
  void updatprfile(
    String fname,
    String lname,
    String email,
    String nationality,
    String dob,
    String company,
    String job_title,
    String mobile,
    String id,
    String password,
    String facebook,
    String twitter,
    String instagram,
    String tiktok,
    String linkedIn,
    String comments,
    String contact1_number,
    String contact2_number,
    String company_website,
  ) async {
    print(dob);
    String updetUrl = "http://qsnap.net/api/updateProfile";
    var response = await http.post(updetUrl, body: {
      "id": id,
      'fname': fname,
      'lname': lname,
      'email': email,
      'nationality': nationality,
      'dob': dob,
      'company': company,
      'job_title': job_title,
      'mobile': mobile,
      'phoneCode': dialingCodemobile,
      'company_website': company_website,
      'facebook': facebook,
      'twitter': twitter,
      'instagram': instagram,
      'tiktok': tiktok,
      'linkedIn': linkedIn,
      'comments': comments,
      'contact1_number': contact1_number,
      'contact1_code': dialingCodecontact1,
      'contact2_code': dialingCodecontact2,
      'contact2_number': contact2_number,
      'password': password,
      'countryCode': valcountry(),
      'nationalityCode': valNationality(),
      'cityId': valcity(),
    });
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    var result = json.decode(response.body);
    print('Response convert body: ${result}');
    if (result["status"] == 200) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
      print("done edit______------>200");
    }
  }

  //uplodeimg
  void updatimge(var base64Image, String id) async {
    print("uplodeimg----------------------------->" + id);
    print("base64Image----------------------->" + base64Image);
    String updetUrl = "http://qsnap.net/api/updateProfileImage";
    var response = await http.post(updetUrl, body: {
      'image': base64Image,
      "id": id,
    });

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    //var result = json.decode(response.body);
  }

  @override
  void initState() {
    this.getid();
    // this._getuser();
    super.initState();
    this._getcountry();
    this._getNationality();
  }

  Country _selectedmoble;
  Country _selectedcontact1;
  Country _selectedcontact2;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff000000),
        centerTitle: true,
        elevation: 3,
        title: new Text(
          'MY PROFILE',
          style: TextStyle(
            color: Color(0xffffd800),
          ),
        ),
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
        actions: [
          IconButton(
            icon: Icon(
              Icons.info_outline_rounded,
              color: Color(0xffffd800),
              size: 30,
            ),
            onPressed: () {
              showModalBottomSheet<void>(
                context: context,
                builder: (BuildContext context) {
                  return BottomSheetinfo();
                },
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            flex: 95,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
              child: Stack(
                alignment: AlignmentDirectional.topCenter,
                children: [
                  // Container(
                  //   height: MediaQuery.of(context).size.height,
                  //   width: MediaQuery.of(context).size.width,
                  //   color: Colors.white,
                  // ),
                  Container(
                    height: MediaQuery.of(context).size.height,
                    margin: const EdgeInsets.only(top: 60.0),
                    alignment: AlignmentDirectional.center,
                    decoration: BoxDecoration(
                        color: Color(0xff000000),
                        border:
                            Border.all(color: Color(0xff000000), width: 3.0),
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(10),
                            topLeft: Radius.circular(10))),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: ListView(
                        children: [
                          SizedBox(
                            height: 15,
                          ),
                          Container(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "First Name",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          TextFormField(
                            keyboardType: TextInputType.name,
                            controller: _fnameController,
                            style: TextStyle(
                              color: Colors.white,
                            ),
                            decoration: InputDecoration(
                              isDense: true,
                              contentPadding:
                                  EdgeInsets.fromLTRB(0, 5.0, 0, 5.0),
                              // filled: true,
                              fillColor: Colors.black87,
                              enabledBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xffffd800)),
                              ),
                              disabledBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xffffd800)),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xffffd800)),
                              ),
                            ),
                            validator: (text) {
                              if (text == null || text.isEmpty) {
                                return 'Please Enter First Name';
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "Last Name",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          TextFormField(
                            keyboardType: TextInputType.name,
                            controller: _lnameController,
                            style: TextStyle(
                              color: Colors.white,
                            ),
                            decoration: InputDecoration(
                              isDense: true,
                              contentPadding:
                                  EdgeInsets.fromLTRB(0, 5.0, 0, 5.0),
                              // filled: true,
                              fillColor: Colors.black87,
                              enabledBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xffffd800)),
                              ),
                              disabledBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xffffd800)),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xffffd800)),
                              ),
                            ),
                            validator: (text) {
                              if (text == null || text.isEmpty) {
                                return 'Please Enter last Name';
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "Email",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            controller:
                            _emailController!=null?_emailController:''
                            ,
                            style: TextStyle(
                              color: Colors.white,
                            ),
                            decoration: InputDecoration(
                              isDense: true,
                              contentPadding:
                                  EdgeInsets.fromLTRB(0, 5.0, 0, 5.0),
                              // filled: true,
                              fillColor: Colors.black87,
                              enabledBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xffffd800)),
                              ),
                              disabledBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xffffd800)),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xffffd800)),
                              ),
                            ),
                            validator: (text) {
                              if (text == null || text.isEmpty) {
                                return 'Please Enter email';
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            height: 15,
                            // width: double.infinity,
                            child: Text(
                              "Mobile",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 0, left: 0),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 10,
                                  child: CountryPicker(
                                    dense: false,
                                    showFlag: false,
                                    //displays flag, true by default
                                    showDialingCode: false,
                                    //displays dialing code, false by default
                                    showName: false,
                                    //displays country name, true by default
                                    showCurrency: false,
                                    //eg. 'British pound'
                                    showCurrencyISO: false,
                                    //eg. 'GBP'
                                    onChanged: (Country country) {
                                      setState(() {
                                        _selectedmoble = country;
                                        dialingCodemobile =
                                            "+" + country.dialingCode;
                                        print(dialingCodemobile);
                                        // String x = country.currencyISO;
                                      });
                                    },
                                    selectedCountry: _selectedmoble,
                                  ),
                                ),
                                Expanded(
                                  flex: 90,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 15,
                                        child: Text(
                                          dialingCodemobile!=null?dialingCodemobile:'',
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            fontSize: 15,
                                            // fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 80,
                                        child: Container(
                                          height: 35,
                                          child: TextFormField(
                                            keyboardType: TextInputType.phone,
                                            controller: _mobileController,
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                            decoration: InputDecoration(
                                              // filled: true,
                                              fillColor: Colors.black87,

                                              focusedBorder:
                                                  UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Color(0xffffd800)),
                                              ),
                                              hintText: "",
                                            ),
                                            validator: (text) {
                                              if (text == null ||
                                                  text.isEmpty) {
                                                return 'Please Enter Contact1';
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Divider(
                            height: 1,
                            indent: 0.0,
                            endIndent: 0.0,
                            thickness: 1,
                            color: Color(0xffffd800),
                          ),
                          SizedBox(
                            height: 5,
                          ),

                          //newnat
                          Container(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "Nationality",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 80,
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              searchNationalities(
                                                titlecountry: titelcountry(),
                                                codecountry: valcountry(),
                                                titlecity: titelcity(),
                                                codecity: valcity(),
                                              )),
                                    );
                                  },
                                  child: Container(
                                    // height: 35,
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      titelNationality(),
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        // fontWeight: FontWeight.w500,
                                        fontSize: 14,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 20,
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      if (isCheckednationalty == "0") {
                                        isCheckednationalty = "1";
                                        i = i + 1;
                                      } else {
                                        isCheckednationalty = "0";
                                        i = i - 1;
                                      }
                                      // else{
                                      //  // isCheckednationalty = "1";
                                      //   i=i+1;
                                      //
                                      // }
                                      isCheckednationaltyb =
                                          !isCheckednationaltyb;
                                    });
                                  },
                                  child: Center(
                                    child: CustomSwitchButton(
                                      backgroundColor: Color(0xffffd800),
                                      unCheckedColor: Colors.black,
                                      animationDuration:
                                          Duration(milliseconds: 400),
                                      checkedColor: Colors.white,
                                      checked: isCheckednationaltyb,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 10.0, bottom: 5),
                            child: Divider(
                              height: 1,
                              indent: 0.0,
                              endIndent: 0.0,
                              thickness: 1,
                              color: Color(0xffffd800),
                            ),
                          ),
                          //country
                          Padding(
                            padding: const EdgeInsets.only(left: 0),
                            child: Container(
                              width: double.infinity,
                              child: Text(
                                "Country",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 80,
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              searchcountryedit(
                                                titlenationalities:
                                                    titelNationality(),
                                                codenationalities:
                                                    valNationality(),
                                                titlecity: titelcity(),
                                                codecity: valcity(),
                                              )),
                                    );
                                  },
                                  child: Container(
                                    // height: 35,
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      titelcountry(),
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        // fontWeight: FontWeight.w500,
                                        fontSize: 14,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 20,
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      if (isCheckedcountry == "0") {
                                        isCheckedcountry = "1";
                                        i = i + 1;
                                      } else {
                                        isCheckedcountry = "0";
                                        i = i - 1;
                                      }

                                      isCheckedcountryb = !isCheckedcountryb;
                                    });
                                  },
                                  child: Center(
                                    child: CustomSwitchButton(
                                      backgroundColor: Color(0xffffd800),
                                      unCheckedColor: Colors.black,
                                      animationDuration:
                                          Duration(milliseconds: 400),
                                      checkedColor: Colors.white,
                                      checked: isCheckedcountryb,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 10.0, bottom: 5),
                            child: Divider(
                              height: 1,
                              indent: 0.0,
                              endIndent: 0.0,
                              thickness: 1,
                              color: Color(0xffffd800),
                            ),
                          ),
                          //city
                          Padding(
                            padding: const EdgeInsets.only(left: 0),
                            child: Container(
                              width: double.infinity,
                              child: Text(
                                "City",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 80,
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => searchcityedit(
                                                titlenationalities:
                                                    titelNationality(),
                                                codenationalities:
                                                    valNationality(),
                                                titlecountry: titelcountry(),
                                                codecountry: valcountry(),
                                              )),
                                    );
                                  },
                                  child: Container(
                                    // height: 35,
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      titelcity(),
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        // fontWeight: FontWeight.w500,
                                        fontSize: 14,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 20,
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      if (isCheckedcity == "0") {
                                        isCheckedcity = "1";
                                        i = i + 1;
                                      } else {
                                        isCheckedcity = "0";
                                        i = i - 1;
                                      }
                                      isCheckedcityb = !isCheckedcityb;
                                    });
                                  },
                                  child: Center(
                                    child: CustomSwitchButton(
                                      backgroundColor: Color(0xffffd800),
                                      unCheckedColor: Colors.black,
                                      animationDuration:
                                          Duration(milliseconds: 400),
                                      checkedColor: Colors.white,
                                      checked: isCheckedcityb,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 10.0, bottom: 5),
                            child: Divider(
                              height: 1,
                              indent: 0.0,
                              endIndent: 0.0,
                              thickness: 1,
                              color: Color(0xffffd800),
                            ),
                          ),
                          Container(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "Date of Birth",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 80,
                                child: InkWell(
                                  onTap: () {
                                    // CupertinoRoundedDatePicker.show(
                                    //   context,
                                    //   fontFamily: "Mali",
                                    //   textColor: Colors.black,
                                    //   background: const Color(0xffffd800),
                                    //   borderRadius: 16,
                                    //   minimumDate:DateTime(2010,1,1),
                                    //   maximumDate: DateTime(1940,1, 1),
                                    //   minimumYear:1940,
                                    //   maximumYear:2010,
                                    //   initialDate: DateTime(2010,1,1),
                                    //   initialDatePickerMode: CupertinoDatePickerMode.date,
                                    //   onDateTimeChanged: (newDateTime) {
                                    //     setState(() {
                                    //       print('confirm $newDateTime');
                                    //       selectedDate=newDateTime ;
                                    //     });
                                    //
                                    //     //
                                    //   },
                                    //
                                    // );
                                    _selectDate(context);
                                  },
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 60,
                                        child: Text(
                                          dobfun()!=null?dobfun():' ',
                                          // "${selectedDate.toLocal()}".split(' ')[0],}
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 20,
                                        child: Image.asset(
                                            getZodiacSign(dob_day, dob_month),
                                            height: 25,
                                            width: 25),
                                      ),
                                      Expanded(
                                        flex: 20,
                                        child: Icon(
                                          Icons.calendar_today,
                                          color: Color(0xffffd800),
                                          size: 25,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 20,
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      if (isCheckeddob == "0") {
                                        isCheckeddob = "1";
                                        i = i + 1;
                                      } else {
                                        isCheckeddob = "0";
                                        i = i - 1;
                                      }
                                      isCheckeddobb = !isCheckeddobb;
                                    });
                                  },
                                  child: Center(
                                    child: CustomSwitchButton(
                                      backgroundColor: Color(0xffffd800),
                                      unCheckedColor: Colors.black,
                                      animationDuration:
                                          Duration(milliseconds: 400),
                                      checkedColor: Colors.white,
                                      checked: isCheckeddobb,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Divider(
                            height: 1,
                            indent: 0.0,
                            endIndent: 0.0,
                            thickness: 1,
                            color: Color(0xffffd800),
                          ),

                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "Company",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 75,
                                child: TextFormField(
                                  keyboardType: TextInputType.text,
                                  controller: _companyController,
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                  decoration: InputDecoration(
                                    isDense: true,
                                    contentPadding:
                                        EdgeInsets.fromLTRB(0, 5.0, 0, 5.0),
                                    // filled: true,
                                    fillColor: Colors.black87,

                                    focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Color(0xffffd800)),
                                    ),
                                  ),
                                  validator: (text) {
                                    if (text == null || text.isEmpty) {
                                      return 'Please Enter First Name';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              Expanded(
                                flex: 20,
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      if (isCheckedcompany == "0") {
                                        isCheckedcompany = "1";
                                        i = i + 1;
                                      } else {
                                        isCheckedcompany = "0";
                                        i = i - 1;
                                      }
                                      print(
                                          "isCheckedcompany$isCheckedcompany");
                                      isCheckedcompanyb = !isCheckedcompanyb;
                                      print(
                                          "isCheckedcompany$isCheckedcompanyb");
                                    });
                                  },
                                  child: Center(
                                    child: CustomSwitchButton(
                                      backgroundColor: Color(0xffffd800),
                                      unCheckedColor: Colors.black,
                                      animationDuration:
                                          Duration(milliseconds: 400),
                                      checkedColor: Colors.white,
                                      checked: isCheckedcompanyb,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Divider(
                            height: 1,
                            indent: 0.0,
                            endIndent: 0.0,
                            thickness: 1,
                            color: Color(0xffffd800),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "Title/Job Title",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 75,
                                child: TextFormField(
                                  keyboardType: TextInputType.text,
                                  controller: _jobtitleController,
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                  decoration: InputDecoration(
                                    isDense: true,
                                    contentPadding:
                                        EdgeInsets.fromLTRB(0, 5.0, 0, 5.0),
                                    // filled: true,
                                    fillColor: Colors.black87,

                                    focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Color(0xffffd800)),
                                    ),
                                  ),
                                  validator: (text) {
                                    if (text == null || text.isEmpty) {
                                      return 'Please Enter ';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              Expanded(
                                flex: 20,
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      if (isCheckedtitle == "0") {
                                        isCheckedtitle = "1";
                                        i = i + 1;
                                      } else {
                                        isCheckedtitle = "0";
                                        i = i - 1;
                                      }
                                      isCheckedtitleb = !isCheckedtitleb;
                                    });
                                  },
                                  child: Center(
                                    child: CustomSwitchButton(
                                      backgroundColor: Color(0xffffd800),
                                      unCheckedColor: Colors.black,
                                      animationDuration:
                                          Duration(milliseconds: 400),
                                      checkedColor: Colors.white,
                                      checked: isCheckedtitleb,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Divider(
                            height: 1,
                            indent: 0.0,
                            endIndent: 0.0,
                            thickness: 1,
                            color: Color(0xffffd800),
                          ),
                          // SizedBox(
                          //   height: 10,
                          // ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "Company Website",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 75,
                                child: TextFormField(
                                  keyboardType: TextInputType.text,
                                  controller: _companywebsiteController,
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                  decoration: InputDecoration(
                                    isDense: true,
                                    contentPadding:
                                        EdgeInsets.fromLTRB(0, 5.0, 0, 5.0),
                                    fillColor: Colors.black87,
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Color(0xffffd800)),
                                    ),
                                  ),
                                  validator: (text) {
                                    if (text == null || text.isEmpty) {
                                      return 'Please Enter ';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              Expanded(
                                flex: 20,
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      if (isCheckedcompanywebsite == "0") {
                                        isCheckedcompanywebsite = "1";
                                        i = i + 1;
                                      } else {
                                        isCheckedcompanywebsite = "0";
                                        i = i - 1;
                                      }
                                      isCheckedcompanywebsiteb =
                                          !isCheckedcompanywebsiteb;
                                    });
                                  },
                                  child: Center(
                                    child: CustomSwitchButton(
                                      backgroundColor: Color(0xffffd800),
                                      unCheckedColor: Colors.black,
                                      animationDuration:
                                          Duration(milliseconds: 400),
                                      checkedColor: Colors.white,
                                      checked: isCheckedcompanywebsiteb,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Divider(
                            height: 1,
                            indent: 0.0,
                            endIndent: 0.0,
                            thickness: 1,
                            color: Color(0xffffd800),
                          ),
                          SizedBox(
                            height: 5,
                          ),

                          Padding(
                            padding: const EdgeInsets.only(left: 0, top: 5),
                            child: Container(
                              height: 15,
                              // width: double.infinity,
                              child: Text(
                                "Business Number",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 0, left: 0),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 10,
                                  child: CountryPicker(
                                    dense: false,
                                    showFlag: false,
                                    //displays flag, true by default
                                    showDialingCode: false,
                                    //displays dialing code, false by default
                                    showName: false,
                                    //displays country name, true by default
                                    showCurrency: false,
                                    //eg. 'British pound'
                                    showCurrencyISO: false,
                                    //eg. 'GBP'
                                    onChanged: (Country country) {
                                      setState(() {
                                        _selectedcontact1 = country;
                                        dialingCodecontact1 =
                                            "+" + country.dialingCode;
                                        print(dialingCodecontact1);
                                      });
                                    },
                                    selectedCountry: _selectedcontact1,
                                  ),
                                ),
                                Expanded(
                                  flex: 15,
                                  child: Text(
                                    dialingCodecontact1!=null?dialingCodecontact1:'',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontSize: 15,
                                      // fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 75,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 72,
                                        child: Container(
                                          height: 35,
                                          child: TextFormField(
                                            keyboardType: TextInputType.phone,
                                            controller: _contact1Controller,
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                            decoration: InputDecoration(
                                              // filled: true,
                                              fillColor: Colors.black87,
                                              enabledBorder:
                                                  UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Color(0xffffd800)),
                                              ),
                                              disabledBorder:
                                                  UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Color(0xffffd800)),
                                              ),
                                              focusedBorder:
                                                  UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Color(0xffffd800)),
                                              ),
                                              hintText: "",
                                            ),
                                            validator: (text) {
                                              if (text == null ||
                                                  text.isEmpty) {
                                                return 'Please Enter Business number';
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 28,
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              if (isCheckedcontact1 == "0") {
                                                isCheckedcontact1 = "1";
                                                i = i + 1;
                                              } else {
                                                isCheckedcontact1 = "0";
                                                i = i - 1;
                                              }

                                              isCheckedcontact1b =
                                                  !isCheckedcontact1b;
                                            });
                                          },
                                          child: Center(
                                            child: CustomSwitchButton(
                                              backgroundColor:
                                                  Color(0xffffd800),
                                              unCheckedColor: Colors.black,
                                              animationDuration:
                                                  Duration(milliseconds: 400),
                                              checkedColor: Colors.white,
                                              checked: isCheckedcontact1b,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Divider(
                            height: 1,
                            indent: 0.0,
                            endIndent: 0.0,
                            thickness: 1,
                            color: Color(0xffffd800),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 0, top: 5),
                            child: Container(
                              height: 15,
                              // width: double.infinity,
                              child: Text(
                                "Other Number",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 0, left: 0),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 10,
                                  child: CountryPicker(
                                    dense: false,
                                    showFlag: false,
                                    //displays flag, true by default
                                    showDialingCode: false,
                                    //displays dialing code, false by default
                                    showName: false,
                                    //displays country name, true by default
                                    showCurrency: false,
                                    //eg. 'British pound'
                                    showCurrencyISO: false,
                                    //eg. 'GBP'
                                    onChanged: (Country country) {
                                      setState(() {
                                        _selectedcontact2 = country;
                                        dialingCodecontact2 =
                                            "+" + country.dialingCode;
                                        print(dialingCodecontact2);
                                      });
                                    },
                                    selectedCountry: _selectedcontact2,
                                  ),
                                ),
                                Expanded(
                                  flex: 15,
                                  child: Text(
                                    dialingCodecontact2!=null?dialingCodecontact2:'',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontSize: 15,
                                      // fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 75,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 72,
                                        child: Container(
                                          height: 35,
                                          child: TextFormField(
                                            keyboardType: TextInputType.phone,
                                            controller: _contact2Controller,
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                            decoration: InputDecoration(
                                              // filled: true,
                                              fillColor: Colors.black87,
                                              // enabledBorder: UnderlineInputBorder(
                                              //   borderSide:
                                              //       BorderSide(color: Color(0xffffd800)),
                                              // ),
                                              // disabledBorder: UnderlineInputBorder(
                                              //   borderSide:
                                              //       BorderSide(color: Color(0xffffd800)),
                                              // ),
                                              focusedBorder:
                                                  UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Color(0xffffd800)),
                                              ),
                                              hintText: "",
                                            ),
                                            validator: (text) {
                                              if (text == null ||
                                                  text.isEmpty) {
                                                return 'Please Enter Contact2';
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 28,
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              if (isCheckedcontact2 == "0") {
                                                isCheckedcontact2 = "1";
                                                i = i + 1;
                                              } else {
                                                isCheckedcontact2 = "0";
                                                i = i - 1;
                                              }
                                              isCheckedcontact2b =
                                                  !isCheckedcontact2b;
                                            });
                                          },
                                          child: Center(
                                            child: CustomSwitchButton(
                                              backgroundColor:
                                                  Color(0xffffd800),
                                              unCheckedColor: Colors.black,
                                              animationDuration:
                                                  Duration(milliseconds: 400),
                                              checkedColor: Colors.white,
                                              checked: isCheckedcontact2b,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Divider(
                            height: 1,
                            indent: 0.0,
                            endIndent: 0.0,
                            thickness: 1,
                            color: Color(0xffffd800),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "Facebook",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 77,
                                child: TextFormField(
                                  keyboardType: TextInputType.emailAddress,
                                  controller: _facebookController,
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                  decoration: InputDecoration(
                                    isDense: true,
                                    contentPadding:
                                        EdgeInsets.fromLTRB(0, 5.0, 0, 5.0),
                                    // filled: true,
                                    fillColor: Colors.black87,
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Color(0xffffd800)),
                                    ),
                                  ),
                                  validator: (text) {
                                    if (text == null || text.isEmpty) {
                                      return 'Please Enter First Name';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              Expanded(
                                flex: 23,
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      if (isCheckedfacebook == "0") {
                                        isCheckedfacebook = "1";
                                        i = i + 1;
                                      } else {
                                        isCheckedfacebook = "0";
                                        i = i - 1;
                                      }
                                      isCheckedfacebookb = !isCheckedfacebookb;
                                    });
                                  },
                                  child: Center(
                                    child: CustomSwitchButton(
                                      backgroundColor: Color(0xffffd800),
                                      unCheckedColor: Colors.black,
                                      animationDuration:
                                          Duration(milliseconds: 400),
                                      checkedColor: Colors.white,
                                      checked: isCheckedfacebookb,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Divider(
                            height: 1,
                            indent: 0.0,
                            endIndent: 0.0,
                            thickness: 1,
                            color: Color(0xffffd800),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "Twitter",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 77,
                                child: TextFormField(
                                  keyboardType: TextInputType.emailAddress,
                                  controller: _twitterController,
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                  decoration: InputDecoration(
                                    isDense: true,
                                    contentPadding:
                                        EdgeInsets.fromLTRB(0, 5.0, 0, 5.0),
                                    // filled: true,
                                    fillColor: Colors.black87,
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Color(0xffffd800)),
                                    ),
                                  ),
                                  validator: (text) {
                                    if (text == null || text.isEmpty) {
                                      return 'Please Enter First Name';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              Expanded(
                                flex: 23,
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      if (isCheckedtwitter == "0") {
                                        isCheckedtwitter = "1";
                                        i = i + 1;
                                      } else {
                                        isCheckedtwitter = "0";
                                        i = i - 1;
                                      }
                                      isCheckedtwitterb = !isCheckedtwitterb;
                                    });
                                  },
                                  child: Center(
                                    child: CustomSwitchButton(
                                      backgroundColor: Color(0xffffd800),
                                      unCheckedColor: Colors.black,
                                      animationDuration:
                                          Duration(milliseconds: 400),
                                      checkedColor: Colors.white,
                                      checked: isCheckedtwitterb,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Divider(
                            height: 1,
                            indent: 0.0,
                            endIndent: 0.0,
                            thickness: 1,
                            color: Color(0xffffd800),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "Instagram",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 77,
                                child: TextFormField(
                                  keyboardType: TextInputType.emailAddress,
                                  controller: _instagramController,
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                  decoration: InputDecoration(
                                    isDense: true,
                                    contentPadding:
                                        EdgeInsets.fromLTRB(0, 5.0, 0, 5.0),
                                    // filled: true,
                                    fillColor: Colors.black87,
                                    // enabledBorder: UnderlineInputBorder(
                                    //   borderSide: BorderSide(color: Color(0xffffd800)),
                                    // ),
                                    // disabledBorder: UnderlineInputBorder(
                                    //   borderSide: BorderSide(color: Color(0xffffd800)),
                                    // ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Color(0xffffd800)),
                                    ),
                                  ),
                                  validator: (text) {
                                    if (text == null || text.isEmpty) {
                                      return 'Please Enter First Name';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              Expanded(
                                flex: 23,
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      if (isCheckedinstgram == "0") {
                                        isCheckedinstgram = "1";
                                        i = i + 1;
                                      } else {
                                        isCheckedinstgram = "0";
                                        i = i - 1;
                                      }
                                      isCheckedinstgramb = !isCheckedinstgramb;
                                    });
                                  },
                                  child: Center(
                                    child: CustomSwitchButton(
                                      backgroundColor: Color(0xffffd800),
                                      unCheckedColor: Colors.black,
                                      animationDuration:
                                          Duration(milliseconds: 400),
                                      checkedColor: Colors.white,
                                      checked: isCheckedinstgramb,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Divider(
                            height: 1,
                            indent: 0.0,
                            endIndent: 0.0,
                            thickness: 1,
                            color: Color(0xffffd800),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "LinkedIn",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 77,
                                child: TextFormField(
                                  keyboardType: TextInputType.emailAddress,
                                  controller: _linkedinController,
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                  decoration: InputDecoration(
                                    isDense: true,
                                    contentPadding:
                                        EdgeInsets.fromLTRB(0, 5.0, 0, 5.0),
                                    // filled: true,
                                    fillColor: Colors.black87,
                                    // enabledBorder: UnderlineInputBorder(
                                    //   borderSide: BorderSide(color: Color(0xffffd800)),
                                    // ),
                                    // disabledBorder: UnderlineInputBorder(
                                    //   borderSide: BorderSide(color: Color(0xffffd800)),
                                    // ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Color(0xffffd800)),
                                    ),
                                  ),
                                  validator: (text) {
                                    if (text == null || text.isEmpty) {
                                      return 'Please Enter First Name';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              Expanded(
                                flex: 23,
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      if (isCheckedlinkedin == "0") {
                                        isCheckedlinkedin = "1";
                                        i = i + 1;
                                      } else {
                                        isCheckedlinkedin = "0";
                                        i = i - 1;
                                      }
                                      isCheckedlinkedinb = !isCheckedlinkedinb;
                                    });
                                  },
                                  child: Center(
                                    child: CustomSwitchButton(
                                      backgroundColor: Color(0xffffd800),
                                      unCheckedColor: Colors.black,
                                      animationDuration:
                                          Duration(milliseconds: 400),
                                      checkedColor: Colors.white,
                                      checked: isCheckedlinkedinb,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Divider(
                            height: 1,
                            indent: 0.0,
                            endIndent: 0.0,
                            thickness: 1,
                            color: Color(0xffffd800),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "Telegram",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 76,
                                child: TextFormField(
                                  keyboardType: TextInputType.emailAddress,
                                  controller: _tiktokController,
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                  decoration: InputDecoration(
                                    isDense: true,
                                    contentPadding:
                                        EdgeInsets.fromLTRB(0, 5.0, 0, 5.0),
                                    // filled: true,
                                    fillColor: Colors.black87,

                                    focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Color(0xffffd800)),
                                    ),
                                  ),
                                  validator: (text) {
                                    if (text == null || text.isEmpty) {
                                      return 'Please Enter First Name';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              Expanded(
                                flex: 23,
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      if (isCheckedtaktok == "0") {
                                        isCheckedtaktok = "1";
                                        i = i + 1;
                                      } else {
                                        isCheckedtaktok = "0";
                                        i = i - 1;
                                      }
                                      isCheckedtaktokb = !isCheckedtaktokb;
                                    });
                                  },
                                  child: Center(
                                    child: CustomSwitchButton(
                                      backgroundColor: Color(0xffffd800),
                                      unCheckedColor: Colors.black,
                                      animationDuration:
                                          Duration(milliseconds: 400),
                                      checkedColor: Colors.white,
                                      checked: isCheckedtaktokb,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Divider(
                            height: 1,
                            indent: 0.0,
                            endIndent: 0.0,
                            thickness: 1,
                            color: Color(0xffffd800),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.topCenter,
                    height: MediaQuery.of(context).size.height / 7,
                    // width: MediaQuery.of(context).size.width,

                    child: GestureDetector(
                      onTap: () => _showSelectionDialog(context),
                      child: Center(
                        child: imageFile == null
                            ? Container(
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
                              )
                            : new Container(
                                height: 100.0,
                                width: 100.0,
                                decoration: new BoxDecoration(
                                  color: const Color(0xff7c94b6),
                                  image: new DecorationImage(
                                    image: new FileImage(imageFile),
                                    fit: BoxFit.cover,
                                  ),
                                  border: Border.all(
                                      color: Color(0xffffd800), width: 5.0),
                                  borderRadius: new BorderRadius.all(
                                      const Radius.circular(100.0)),
                                ),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 8,
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
              child: SizedBox(
                height: 40,
                width: double.infinity,
                child: RaisedButton(
                    color: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      "UPDATE MY CARD",
                      style: TextStyle(color: Color(0xffffd800), fontSize: 17),
                    ),
                    onPressed: () {
                      if (i <= 6) {
                        // showDialog(
                        //   context: context,
                        //   barrierDismissible: false,
                        //   builder: (BuildContext context) {
                        //     return Dialog(child: Text("Loading.."));
                        //   },
                        // );
                        LoaderDialog.showLoadingDialog(context, _LoaderDialog);
                        updattoggel();
                        dob = dobfun();
                        updatprfile(
                          _fnameController.text,
                          _lnameController.text,
                          _emailController.text,
                          _nationalityController.text,
                          dob,
                          _companyController.text,
                          _jobtitleController.text,
                          _mobileController.text,
                          id.toString(),
                          _passwordController.text,
                          _facebookController.text,
                          _twitterController.text,
                          _instagramController.text,
                          _tiktokController.text,
                          _linkedinController.text,
                          _CommentController.text,
                          _contact1Controller.text,
                          _contact2Controller.text,
                          _companywebsiteController.text,
                        );
                      } else {
                        _toggelmore(context);
                      }
                    }),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );

  }

  /// Get from gallery
  _getFromGallery() async {
    PickedFile pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
        print("imageFile----------------------------->$imageFile");

        // List<int> imageBytes = imageFile.readAsBytesSync();
        // print(imageBytes);
        // base64Image = base64UrlEncode(imageBytes);
        List<int> imageBytes = imageFile.readAsBytesSync();
        String base64Image = base64Encode(imageBytes);
        // print(base64Image);
        updatimge(base64Image, id);
      });
    }
  }

  /// Get from Camera
  _getFromCamera() async {
    PickedFile pickedFile = await ImagePicker().getImage(
      source: ImageSource.camera,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
        // print("imageFile----------------------------->$imageFile");
        // List<int> imageBytes = imageFile.readAsBytesSync();
        // print("dddd$imageBytes");
        // base64Image = base64UrlEncode(imageBytes);
        List<int> imageBytes = imageFile.readAsBytesSync();
        String base64Image = base64Encode(imageBytes);
        // print(base64Image);

        updatimge(base64Image, id);
      });
    }
  }

  String dobfun() {
    if (selectedDate == DateTime(2010, 1, 1)) {
      return dob;
    } else {
      return "${selectedDate.toLocal()}".split(' ')[0];
    }
  }

  valphone() {
    if (_dropDownValue == null) {
      return country_id;
    } else {
      return _dropDownValue;
    }
  }

  valNationality() {
    if (widget.codenationalities == " ") {
      return Nationality_id;
    } else {
      return widget.codenationalities;
    }
  }

  titelNationality() {
    if (widget.codenationalities == " ") {
      return Nationality_name;
    } else {
      return widget.titlenationalities;
    }
  }

  valcountry() {
    if (widget.codecountry == " ") {
      return country_id;
    } else {
      return widget.codecountry;
    }
  }

  titelcountry() {
    if (widget.codecountry == " ") {
      return country_name;
    } else {
      return widget.titlecountry;
    }
  }

  valcity() {
    if (widget.codecity == " ") {
      return city_id;
    } else {
      return widget.codecity;
    }
  }

  titelcity() {
    if (widget.codecity == " ") {
      return city_name;
    } else {
      return widget.titlecity;
    }
  }
}

class CustomPicker extends CommonPickerModel {
  String digits(int value, int length) {
    return '$value'.padLeft(length, "0");
  }

  CustomPicker({DateTime currentTime, LocaleType locale})
      : super(locale: locale) {
    this.currentTime = currentTime ?? DateTime.now();
    this.setLeftIndex(this.currentTime.hour);
    this.setMiddleIndex(this.currentTime.minute);
    this.setRightIndex(this.currentTime.second);
  }

  @override
  String leftStringAtIndex(int index) {
    if (index >= 0 && index < 24) {
      return this.digits(index, 2);
    } else {
      return null;
    }
  }

  @override
  String middleStringAtIndex(int index) {
    if (index >= 0 && index < 60) {
      return this.digits(index, 2);
    } else {
      return null;
    }
  }

  @override
  String rightStringAtIndex(int index) {
    if (index >= 0 && index < 60) {
      return this.digits(index, 2);
    } else {
      return null;
    }
  }

  @override
  String leftDivider() {
    return "|";
  }

  @override
  String rightDivider() {
    return "|";
  }

  @override
  List<int> layoutProportions() {
    return [1, 2, 1];
  }

  @override
  DateTime finalTime() {
    return currentTime.isUtc
        ? DateTime.utc(
            currentTime.year,
            currentTime.month,
            currentTime.day,
            this.currentLeftIndex(),
            this.currentMiddleIndex(),
            this.currentRightIndex())
        : DateTime(
            currentTime.year,
            currentTime.month,
            currentTime.day,
            this.currentLeftIndex(),
            this.currentMiddleIndex(),
            this.currentRightIndex());
  }
}

_toggelmore(BuildContext context) {
  showPlatformDialog(
    context: context,
    builder: (_) => BasicDialogAlert(
      title: Text(
        " You can have only 6 pieces of info on your profile.",
        style: TextStyle(color: Colors.black, fontSize: 20),
        textAlign: TextAlign.center,
      ),
      actions: <Widget>[
        BasicDialogAction(
          title:
              Text("Ok", style: TextStyle(color: Colors.black, fontSize: 17)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    ),
  );
}
