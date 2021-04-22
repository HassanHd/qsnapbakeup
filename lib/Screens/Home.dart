import 'package:flutter/material.dart';
import 'dart:io';

import 'Settings.dart';
import 'myprofile.dart';
import 'Editprofile.dart';
import 'qrcodetaps.dart';
import 'wallettaps.dart';
class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: [
          // MyProfile(),
          Qrcodetabbs(),
          Editprofile(
            titlecountry: " ",
            codecountry: " ",
            titlecity: " ",
            codecity: " ",
            titlenationalities: " ",
            codenationalities: " ",
          ),
          wallettaps(),
          Settings(),
        ].elementAt(_selectedIndex),
        bottomNavigationBar: BottomNavigationBar(

          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.qr_code),
              title: Text('MY CARD',style:TextStyle(
                  fontSize: 14
              ),),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              title: Text('MY PROFILE',style:TextStyle(
                fontSize: 14
              ),),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_balance_wallet),
              title: Text('MY WALLET',style:TextStyle(
                  fontSize: 14
              ),),
            ),
            BottomNavigationBarItem(
              icon:Icon(Icons.settings),
              title: Text('SETTINGS',style:TextStyle(
                  fontSize: 14
              ),),
            ),
          ],
          backgroundColor: Colors.black,
          type: BottomNavigationBarType.fixed,          currentIndex: _selectedIndex,
          selectedItemColor: Color(0xffffd800),
          unselectedItemColor: Colors.white70,
          onTap: _onItemTapped,
        ),

      ),
    );
  }

  Future<bool> _onBackPressed() {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirm'),
          content: Text('Do you want to exit the App'),
          actions: <Widget>[
            FlatButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop(false); //Will not exit the App
              },
            ),
            FlatButton(
              child: Text('Yes'),
              onPressed: ()=> exit(0),

              // onPressed: () {
              //   // onPressed: ()=> exit(0),
              //
              //   // Navigator.of(context).pop(true); //Will exit the App
              // },
            )
          ],
        );
      },
    ) ?? false;
  }

}
