import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:flutter_country_picker/flutter_country_picker.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'Home.dart';
import 'LoaderDialog.dart';

class AddQsnap extends StatefulWidget {
  @override
  _AddQsnapState createState() => _AddQsnapState();
}

class _AddQsnapState extends State<AddQsnap> {
  final GlobalKey<State> _LoaderDialog = new GlobalKey<State>();

  final _formKey = GlobalKey<FormState>();

  var id;
  String dialingCodemobile = " ";
  String dialingCodecontact1 = " ";
  String dialingCodecontact2 = " ";
  Country _selectedmoble;
  Country _selectedcontact1;
  Country _selectedcontact2;

  getid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    id = prefs.get("id");
    setState(() {
      id = prefs.get("id");
    });
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
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18),
            doneStyle:
            TextStyle(color: Colors.black, fontSize: 16)),

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

  // Variables
  File imageFile;
  var base64Image="";
  TextEditingController _fnameController = TextEditingController();
  TextEditingController _lnameController = TextEditingController();
  TextEditingController _nationalityController = TextEditingController();
  TextEditingController _companyController = TextEditingController();
  TextEditingController _jobtitleController = TextEditingController();
  TextEditingController _mobileController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _contact1Controller = TextEditingController();
  TextEditingController _contact2Controller = TextEditingController();
  TextEditingController _commentController = TextEditingController();
  TextEditingController _facebookController = TextEditingController();
  TextEditingController _twitterController = TextEditingController();
  TextEditingController _instagramController = TextEditingController();
  TextEditingController _tiktokController = TextEditingController();
  TextEditingController _linkedinController = TextEditingController();


  //updatprfile
  void updatprfile(
      String fname,
      String lname,
      // String nationality,
      String dob,
      String company,
      String job_title,
      String mobile,
      String phoneCode,
      String email,
      String facebook,
      String twitter,
      String instagram,
      String tiktok,
      String linkedIn,
      String comments,
      String contact1_number,
      String contact1_code,
      String contact2_number,
      String contact2_code,

      ) async {
    print(dob);
    print("im in fun add------------>");

    String updetUrl = "http://qsnap.net/api/addToContact";
    var response = await http.post(updetUrl, body: {
      "customerId": id,
      'fname': fname,
      'lname': lname,
      // 'nationality': nationality,
      'dob': dob,
      'company': company,
      'job_title': job_title,
      'mobile': mobile,
      // 'phone': phone,
      'email': email,
      'image': base64Image,
      'facebook': facebook,
      'twitter': twitter,
      'instagram': instagram,
      'tiktok': tiktok,
      'linkedIn': linkedIn,
      'comments': comments,
      'contact1_number': contact1_number,
      'contact2_number': contact2_number,
      'phoneCode': phoneCode,
      'contact1_code': contact1_code,
      'contact2_code': contact2_code,

    });
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    var result = json.decode(response.body);
    print('Response convert body: ${result}');

    if (result["status"] == 200) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Home()),
      );
      print("done edit______------>200");
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
//        toolbarHeight: 65,
        title: Text("  ADD MANUALLY",style: TextStyle(color: Color(0xffffd800))),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 95,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                child: Stack(
                  alignment: AlignmentDirectional.topCenter,
                  children: [
                    // Container(
                    //   height: MediaQuery.of(context).size.height,
                    //   width: MediaQuery.of(context).size.width,
                    //   color: Colors.white,
                    // ),
                    // Container(
                    //   height: MediaQuery.of(context).size.height - 20,
                    //   margin: const EdgeInsets.only(top: 50.0),
                    //   alignment: AlignmentDirectional.center,
                    //   decoration: BoxDecoration(
                    //       color: Color(0xff000000),
                    //       border: Border.all(color: Color(0xff000000), width: 3.0),
                    //       borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    // ),
                    Container(
                      height: MediaQuery.of(context).size.height,
                      margin: const EdgeInsets.only(top: 60.0),
                      alignment: AlignmentDirectional.center,
                      decoration: BoxDecoration(
                          color: Color(0xff000000),
                          border: Border.all(color: Color(0xff000000), width: 3.0),
                          borderRadius: BorderRadius.all(Radius.circular(10.0))),
                      child: Form(
                        key: _formKey,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: ListView(
                            children: [
                              //fristname
                              // SizedBox(
                              //   height: ,
                              // ),
                              Padding(
                                padding: const EdgeInsets.only(top:20.0),
                                child: Container(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    "First Name *",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ),
                              TextFormField(
                                controller: _fnameController,
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                                decoration: InputDecoration(
                                  isDense: true,
                                  contentPadding: EdgeInsets.fromLTRB(0, 5.0, 0, 5.0),
                                  // filled: true,
                                  fillColor: Colors.black87,
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Color(0xffffd800)),
                                  ),
                                  disabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Color(0xffffd800)),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Color(0xffffd800)),
                                  ),
                                ),
                                validator: (text) {
                                  if (text == "" || text.isEmpty) {
                                    return 'Please Enter First Name';
                                  }
                                  return null;
                                },
                              ),
                              //lname
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "Last Name *",
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
                                  contentPadding: EdgeInsets.fromLTRB(0, 5.0, 0, 5.0),
                                  // filled: true,
                                  fillColor: Colors.black87,
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Color(0xffffd800)),
                                  ),
                                  disabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Color(0xffffd800)),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Color(0xffffd800)),
                                  ),
                                ),
                                validator: (text) {
                                  if (text == null || text.isEmpty) {
                                    return 'Please Enter last Name';
                                  }
                                  return null;
                                },
                              ),
                              //Email
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "Email *",
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
                                controller: _emailController,
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                                decoration: InputDecoration(
                                  isDense: true,
                                  contentPadding: EdgeInsets.fromLTRB(0, 5.0, 0, 5.0),
                                  // filled: true,
                                  fillColor: Colors.black87,
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Color(0xffffd800)),
                                  ),
                                  disabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Color(0xffffd800)),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Color(0xffffd800)),
                                  ),
                                ),
                                validator: (text) {
                                  if (text == null || text.isEmpty) {
                                    return 'Please Enter Email';
                                  }
                                  return null;
                                },
                              ),

                              //Mobile
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "Mobile*",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontSize: 15,
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
                                      flex: 20,
                                      child: CountryPicker(
                                        dense: false,
                                        showFlag: true,
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
                                            dialingCodemobile = "+" + country.dialingCode;
                                            print(dialingCodemobile);
                                            // String x = country.currencyISO;
                                          });
                                        },
                                        selectedCountry: _selectedmoble,
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
                                            hintText: "",
                                          ),
                                          validator: (text) {
                                            if (text == null || text.isEmpty) {
                                              return 'Please Enter Mobile';
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              //natonalte
                              // Container(
                              //   height: 35,
                              //   child: ListTile(
                              //     title: Text(
                              //       "Nationality",
                              //       style: TextStyle(
                              //         color: Colors.grey,
                              //         fontSize: 14,
                              //         fontWeight: FontWeight.w500,
                              //       ),
                              //     ),
                              //     subtitle: TextFormField(
                              //       keyboardType: TextInputType.text,
                              //       controller: _nationalityController,
                              //       style: TextStyle(
                              //         color: Colors.white,
                              //       ),
                              //       decoration: InputDecoration(
                              //         // filled: true,
                              //         fillColor: Colors.black,
                              //         enabledBorder: UnderlineInputBorder(
                              //           borderSide: BorderSide(color: Color(0xffffd800)),
                              //         ),
                              //         disabledBorder: UnderlineInputBorder(
                              //           borderSide: BorderSide(color: Color(0xffffd800)),
                              //         ),
                              //         focusedBorder: UnderlineInputBorder(
                              //           borderSide: BorderSide(color: Color(0xffffd800)),
                              //         ),
                              //         hintText: "",
                              //       ),
                              //       validator: (text) {
                              //         if (text == null || text.isEmpty) {
                              //           return 'Please Enter Nationality';
                              //         }
                              //         return null;
                              //       },
                              //     ),
                              //   ),
                              // ),
                              // SizedBox(
                              //   height: 20,
                              // ),

                              //Company
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
                              TextFormField(
                                keyboardType: TextInputType.text,
                                controller: _companyController,
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                                decoration: InputDecoration(
                                  isDense: true,
                                  contentPadding: EdgeInsets.fromLTRB(0, 5.0, 0, 5.0),
                                  // filled: true,
                                  fillColor: Colors.black87,
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Color(0xffffd800)),
                                  ),
                                  disabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Color(0xffffd800)),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Color(0xffffd800)),
                                  ),
                                ),
                              ),
                              //Titel
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
                              TextFormField(
                                keyboardType: TextInputType.text,
                                controller: _jobtitleController,
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                                decoration: InputDecoration(
                                  isDense: true,
                                  contentPadding: EdgeInsets.fromLTRB(0, 5.0, 0, 5.0),
                                  // filled: true,
                                  fillColor: Colors.black87,
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Color(0xffffd800)),
                                  ),
                                  disabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Color(0xffffd800)),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Color(0xffffd800)),
                                  ),
                                ),

                              ),
                              //timer
                              SizedBox(
                                height: 10,
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
                              InkWell(
                                onTap: () {
                                  _selectDate(context);
                                },
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 80,
                                      child: Text(
                                        "${selectedDate.toLocal()}".split(' ')[0],
                                        style: TextStyle(color: Colors.white),
                                      ),
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
                              SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 0),
                                child: Divider(
                                  height: 1,
                                  indent: 0.0,
                                  endIndent: 0.0,
                                  thickness: 1,
                                  color: Color(0xffffd800),
                                ),
                              ),
                              // TextFormField(
                              //   keyboardType: TextInputType.phone,
                              //   controller: _mobileController,
                              //   style: TextStyle(
                              //     color: Colors.white,
                              //   ),
                              //   decoration: InputDecoration(
                              //     isDense: true,
                              //     contentPadding: EdgeInsets.fromLTRB(0, 5.0, 0, 5.0),
                              //     // filled: true,
                              //     fillColor: Colors.black87,
                              //     enabledBorder: UnderlineInputBorder(
                              //       borderSide: BorderSide(color: Color(0xffffd800)),
                              //     ),
                              //     disabledBorder: UnderlineInputBorder(
                              //       borderSide: BorderSide(color: Color(0xffffd800)),
                              //     ),
                              //     focusedBorder: UnderlineInputBorder(
                              //       borderSide: BorderSide(color: Color(0xffffd800)),
                              //     ),
                              //   ),
                              //   validator: (text) {
                              //     if (text == null || text.isEmpty) {
                              //       return 'Please Enter Mobile';
                              //     }
                              //     return null;
                              //   },
                              // ),
                              //Contact 1
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "Business Number",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontSize: 15,
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
                                      flex: 20,
                                      child: CountryPicker(
                                        dense: false,
                                        showFlag: true,
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
                                      flex: 80,
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
                                            hintText: "",
                                          ),

                                        ),
                                      ),
                                    ),

                                  ],
                                ),
                              ),
                              // TextFormField(
                              //   keyboardType: TextInputType.phone,
                              //   controller: _contact1Controller,
                              //   style: TextStyle(
                              //     color: Colors.white,
                              //   ),
                              //   decoration: InputDecoration(
                              //     isDense: true,
                              //     contentPadding: EdgeInsets.fromLTRB(0, 5.0, 0, 5.0),
                              //     // filled: true,
                              //     fillColor: Colors.black87,
                              //     enabledBorder: UnderlineInputBorder(
                              //       borderSide: BorderSide(color: Color(0xffffd800)),
                              //     ),
                              //     disabledBorder: UnderlineInputBorder(
                              //       borderSide: BorderSide(color: Color(0xffffd800)),
                              //     ),
                              //     focusedBorder: UnderlineInputBorder(
                              //       borderSide: BorderSide(color: Color(0xffffd800)),
                              //     ),
                              //   ),
                              //
                              // ),

                              //Contact 2

                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "Other Number",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontSize: 15,
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
                                      flex: 20,
                                      child: CountryPicker(
                                        dense: false,
                                        showFlag: true,
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
                                      flex: 80,
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
                                            hintText: "",
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // TextFormField(
                              //   keyboardType: TextInputType.phone,
                              //   controller: _contact2Controller,
                              //   style: TextStyle(
                              //     color: Colors.white,
                              //   ),
                              //   decoration: InputDecoration(
                              //     isDense: true,
                              //     contentPadding: EdgeInsets.fromLTRB(0, 5.0, 0, 5.0),
                              //     // filled: true,
                              //     fillColor: Colors.black87,
                              //     enabledBorder: UnderlineInputBorder(
                              //       borderSide: BorderSide(color: Color(0xffffd800)),
                              //     ),
                              //     disabledBorder: UnderlineInputBorder(
                              //       borderSide: BorderSide(color: Color(0xffffd800)),
                              //     ),
                              //     focusedBorder: UnderlineInputBorder(
                              //       borderSide: BorderSide(color: Color(0xffffd800)),
                              //     ),
                              //   ),
                              //
                              // ),







                              //Comment
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "Notes",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                              TextFormField(
                                keyboardType: TextInputType.text,
                                controller: _commentController,
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                                decoration: InputDecoration(
                                  isDense: true,
                                  contentPadding: EdgeInsets.fromLTRB(0, 5.0, 0, 5.0),
                                  // filled: true,
                                  fillColor: Colors.black87,
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Color(0xffffd800)),
                                  ),
                                  disabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Color(0xffffd800)),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Color(0xffffd800)),
                                  ),
                                ),

                              ),
                              SizedBox(
                                height: 10,
                                width: double.infinity,
                              ),

                            ],
                          ),
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
                              ? Stack(
                            children: [
                              new Center(
                                child: new CircleAvatar(
                                  radius: 50.0,
                                  backgroundColor: const Color(0xFF000000),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 0.0),
                                child: new Center(
                                  child: Icon(
                                    Icons.camera_enhance,
                                    color: Color(0xffffd800),
                                    size: 50,
                                  ),
                                ),
                              ),
                            ],
                          )
                              : new Container(
                            height: 90.0,
                            width: 90.0,
                            decoration: new BoxDecoration(
                              color: const Color(0xff7c94b6),
                              image: new DecorationImage(
                                image: new FileImage(imageFile),
                                fit: BoxFit.cover,
                              ),
                              border: Border.all(
                                  color: Color(0xffffd800), width: 5.0),
                              borderRadius: new BorderRadius.all(
                                  const Radius.circular(80.0)),
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
                      "ADD",
                      style:
                      TextStyle(color: Color(0xffffd800), fontSize: 18),
                    ),
                    onPressed: (){
                      if (_formKey.currentState.validate()) {
                        print("im in fun onPressed------------>");
                        // showDialog(
                        //   context: context,
                        //   barrierDismissible: false,
                        //   builder: (BuildContext context) {
                        //     return Dialog(
                        //         child: Text("Loading..")
                        //     );
                        //   },
                        // );
                        LoaderDialog.showLoadingDialog(context, _LoaderDialog);

                        updatprfile(
                          _fnameController.text,
                          _lnameController.text,
                          // _nationalityController.text,
                          selectedDate.toString(),
                          _companyController.text,
                          _jobtitleController.text,
                          _mobileController.text,
                          dialingCodemobile,
                          _emailController.text,
                          _facebookController.text,
                          _twitterController.text,
                          _instagramController.text,
                          _tiktokController.text,
                          _linkedinController.text,
                          _commentController.text,
                          _contact1Controller.text,
                          dialingCodecontact1,
                          _contact2Controller.text,
                          dialingCodecontact2,
                        );
                      }}),
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
        List<int> imageBytes = imageFile.readAsBytesSync();
        base64Image = base64Encode(imageBytes);
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
        List<int> imageBytes = imageFile.readAsBytesSync();
        base64Image = base64Encode(imageBytes);
      });
    }
  }
}
