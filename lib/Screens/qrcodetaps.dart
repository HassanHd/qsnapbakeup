import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_point_tab_bar/pointTabIndicator.dart';
import 'package:qsnap/Screens/qrcodeee.dart';
import 'package:qsnap/Screens/qrcodeimg.dart';
import 'BottomSheetDataPolicy.dart';
import 'BottomSheetinfocard.dart';
import 'Home.dart';


class Qrcodetabbs extends StatefulWidget {
  // var iduser;
  //
  // Qrcodetabbs(this.iduser);

  @override
  _QrcodetabbsState createState() => _QrcodetabbsState();
}

class _QrcodetabbsState extends State<Qrcodetabbs>
    with SingleTickerProviderStateMixin {
  final tabList = ['My Card', 'Scan Others'];
  final tab = [qecoode()];
  TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(vsync: this, length: tabList.length);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_outlined,
            color: Color(0xff000000),
            size: 25,
          ),
          onPressed: () {

          },
        ),
        backgroundColor: Color(0xff000000),
        title: Text('MY CARD',style: TextStyle(color: Color(0xffffd800)),),
        centerTitle: true,
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
                  return BottomSheetinfocard();
                },
              );
            },
          ),
        ],
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
           qrcodeimg(),
           qecoode()
        ],
      ),
    );
  }
}
