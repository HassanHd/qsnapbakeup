import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_point_tab_bar/pointTabIndicator.dart';
import 'package:qsnap/Screens/qrcodeee.dart';
import 'package:qsnap/Screens/qrcodeimg.dart';
import 'BottomSheetDataPolicy.dart';
import 'addqsnap.dart';
import 'MyChats.dart';
import 'mywallet.dart';
import 'Home.dart';

class wallettaps extends StatefulWidget {
  // var iduser;
  //
  // Qrcodetabbs(this.iduser);

  @override
  _wallettapsState createState() => _wallettapsState();
}

class _wallettapsState extends State<wallettaps>
    with SingleTickerProviderStateMixin {
  final tabList = ['My Contacts', 'My Chats'];
  final tab = [MyChats()];
  TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(vsync: this, length: tabList.length);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
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
              Icons.add_circle_outline,
              color: Color(0xffffd800),
              size: 25,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddQsnap()),
              );
            },
          ),
          // IconButton(
          //   icon: Icon(
          //     Icons.search_outlined,
          //     color: Color(0xffffd800),
          //     size: 25,
          //   ),
          //   onPressed: () {
          //     _toggle();
          //   },
          // ),
        ],
        backgroundColor: Color(0xff000000),
        centerTitle: true,
        elevation: 3,
        title: new Text(
          'MY WALLET',
          style: TextStyle(
            color: Color(0xffffd800),
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicator: PointTabIndicator(
            position: PointTabIndicatorPosition.bottom,
            color: Color(0xffffd800),
            insets: EdgeInsets.only(bottom: 6),
          ),
          tabs: tabList.map((item) {
            return Tab(
              text:
              item,

              ////// Inta hina ht3ml return l Awl Tab Ally hiya Design sherif
            );
          }).toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // qrcodeimg(widget.iduser),
          MyWallet(),
          MyChats()
        ],
      ),
    );
  }
}
