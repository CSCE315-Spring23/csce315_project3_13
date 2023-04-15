import 'dart:async';

import 'package:csce315_project3_13/Colors/Color_Manager.dart';
import 'package:csce315_project3_13/GUI/Components/Page_Header.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';


class Win_Loading_Page extends StatefulWidget {
  static const String route = '/loading';
  const Win_Loading_Page({Key? key}) : super(key: key);

  @override
  State<Win_Loading_Page> createState() => _Win_Loading_PageState();
}

class _Win_Loading_PageState extends State<Win_Loading_Page> {


  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Page_Header(
          context: context,
          pageName: "Loading...",
          buttons: []),
      backgroundColor: Color_Manager.of(context).background_color,
      body: Container(
        child: Center(
          child: SpinKitRing(color: Color_Manager.of(context).active_color),
        ),
      ),
    );
  }
}
