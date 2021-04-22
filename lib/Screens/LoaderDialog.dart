import 'package:flutter/material.dart';
class LoaderDialog {
  static Future<void> showLoadingDialog(BuildContext context, GlobalKey key) async {
    var wid = MediaQuery.of(context).size.width / 2;
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(child: CircularProgressIndicator(
          backgroundColor:Color(0xffffd800) ,
          valueColor: new AlwaysStoppedAnimation<Color>(Colors.black),

        ));
      },
    );
  }
}