/// A widget representing a loading page shown while the application is loading.
/// This widget is used as the first screen shown to users when the application starts
/// and shows a spinning circle indicating the application is loading.
/// This widget extends [StatefulWidget] and overrides the [createState] method to
/// return a new instance of [_Win_Loading_PageState]. [_Win_Loading_PageState] is
/// responsible for building the UI of this widget.

import 'package:csce315_project3_13/Inherited_Widgets/Color_Manager.dart';
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
