import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Home.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_country_picker/flutter_country_picker.dart';
import 'LoaderDialog.dart';


class EditQsnap extends StatefulWidget {
  var id, edit,loginId;

  EditQsnap(this.id, this.edit,this.loginId);

  @override
  _EditQsnapState createState() => _EditQsnapState();
}

class _EditQsnapState extends State<EditQsnap> {
  final GlobalKey<State> _LoaderDialog = new GlobalKey<State>();
  DateTime selectedDate = DateTime(2010, 1, 1);
  final _formKey = GlobalKey<FormState>();

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
  String dialingCodemobile = " ";
  String dialingCodecontact1 = " ";
  String dialingCodecontact2 = " ";
  Country _selectedmoble;
  Country _selectedcontact1;
  Country _selectedcontact2;
  File imageFile;
  var base64Image="";
  TextEditingController _fnameController = TextEditingController();
  TextEditingController _lnameController = TextEditingController();
  TextEditingController _nationalityController = TextEditingController();
  TextEditingController _companyController = TextEditingController();
  TextEditingController _jobtitleController = TextEditingController();
  TextEditingController _mobileController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _contact1Controller = TextEditingController();
  TextEditingController _contact2Controller = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _commentController = TextEditingController();
  TextEditingController _company_websiteController = TextEditingController();
  TextEditingController _facebookController = TextEditingController();
  TextEditingController _twitterController = TextEditingController();
  TextEditingController _instagramController = TextEditingController();
  TextEditingController _tiktokController = TextEditingController();
  TextEditingController _linkedinController = TextEditingController();
  var fname, lname, mobile, job_title, company, phone;
  var dob = "";
  var image = "";

  Future _getuser() async {
    var url =
        'http://qsnap.net/api/getContactById?id=${widget
        .id}&edit=${widget.edit}&loginId=${widget.loginId}';
    var response = await http.get(url);
    var responsbody = jsonDecode(response.body);
    var data = responsbody["response"]["contact"];
    if (responsbody["status"] == 200) {
      setState(() {
        _fnameController.text = data["fname"];
        _lnameController.text = data["lname"];
        _mobileController.text = data["mobile"];
        _phoneController.text = data["phone"];
        _jobtitleController.text = data["job_title"];
        _companyController.text = data["company"];
        _nationalityController.text = data["nationality"];
        _emailController.text = data["email"];
        dob = data["dob"];
        image = data["image"];
        dialingCodemobile=data["phoneCode"];
        dialingCodecontact1=data["contact1_code"];
        dialingCodecontact2=data["contact2_code"];
        _company_websiteController.text = data["company_website"];
        _facebookController.text = data["facebook"];
        _twitterController.text= data["twitter"];
        _linkedinController.text = data["linkedIn"];
        _instagramController.text = data["instagram"];
        _tiktokController.text = data["tiktok"];
        _commentController.text = data["comments"];
        _contact1Controller.text = data["contact1_number"];
        _contact2Controller.text = data["contact2_number"];
      });
    }
    print(responsbody);
    return "Sucess";
  }

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
      String company_website,
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
    print("im in fun update edit------------>");

    String updetUrl = "http://qsnap.net/api/updateContact";
    var response = await http.post(updetUrl, body: {
      "id": widget.id,
      'fname': fname,
      'lname': lname,
      //'nationality': nationality,
      'dob': dob,
      'company': company,
      'job_title': job_title,
      'mobile': mobile,
      'email': email,
      'image': base64Image,
      'company_website': company_website,
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
    if (result["status"] == 200) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Home()),
      );
    }
  }

  @override
  void initState() {
    this._getuser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // _getuser();
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
        title: Text("EDIT QSNAP"),
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
                  Container(
                    height: MediaQuery.of(context).size.height,
                    margin: const EdgeInsets.only(top: 60.0),
                    alignment: AlignmentDirectional.center,
                    decoration: BoxDecoration(
                        color: Color(0xff000000),
                        border: Border.all(color: Color(0xff000000), width: 3.0),
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: ListView(
                        children: [
                          //fristname
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
                          SizedBox(
                            height: 10,
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
                          //timer
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
                                    dobfun(),
                                    // "${selectedDate.toLocal()}".split(' ')[0],}
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
                            validator: (text) {
                              if (text == null || text.isEmpty) {
                                return 'Please Enter First Name';
                              }
                              return null;
                            },
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
                            validator: (text) {
                              if (text == null || text.isEmpty) {
                                return 'Please Enter ';
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
                              "Mobile",
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
                                        dialingCodemobile = "+" + country.dialingCode;
                                        print(dialingCodemobile);
                                        // String x = country.currencyISO;
                                      });
                                    },
                                    selectedCountry: _selectedmoble,
                                  ),
                                ),
                                Expanded(
                                  flex: 15,
                                  child: Text(
                                    dialingCodemobile,
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

                          //Contact 1
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            alignment: Alignment.topLeft,
                            child: Text(
                              " Business Number",
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
                                    dialingCodecontact1,
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
                                    dialingCodecontact2,
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
                        //Email
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
                                return 'Please Enter';
                              }
                              return null;
                            },
                          ),
                          //company_website
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
                          TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            controller: _company_websiteController,
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
                            validator: (val) => val.isEmpty || !val.contains("@")
                                ? "enter a valid company_website"
                                : null,

                          ),
                          //FaceBook
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
                          TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            controller: _facebookController,
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
                            validator: (val) => val.isEmpty || !val.contains("@")
                                ? "enter a valid eamil"
                                : null,

                          ),
                          //Twitter
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
                          TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            controller: _twitterController,
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
                                return 'Please Enter';
                              }
                              return null;
                            },
                          ),
                          //Instagram
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
                          TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            controller: _instagramController,
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
                                return 'Please Enter First Name';
                              }
                              return null;
                            },
                          ),
                          //LinkedIn
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
                          TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            controller: _linkedinController,
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
                                return 'Please Enter First Name';
                              }
                              return null;
                            },
                          ),
                          //TikTok
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
                          TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            controller: _tiktokController,
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
                                return 'Please Enter ';
                              }
                              return null;
                            },
                          ),
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
                            validator: (text) {
                              if (text == null || text.isEmpty) {
                                return 'Please Enter First Name';
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: 10,
                            width: double.infinity,
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
                      "EDIT",
                      style:
                      TextStyle(color: Color(0xffffd800), fontSize: 16),
                    ),
                    onPressed: () {
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


                      dob=dobfun();
                      updatprfile(
                        _fnameController.text,
                        _lnameController.text,
                        // _nationalityController.text,
                        dob,
                        _companyController.text,
                        _jobtitleController.text,
                        _mobileController.text,
                        dialingCodemobile,
                        _emailController.text,
                        _company_websiteController.text,
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
                    }),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
        ],
      )
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
        print("imageFile----------------------------->$imageFile");
        List<int> imageBytes = imageFile.readAsBytesSync();
        base64Image = base64Encode(imageBytes);

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
}
