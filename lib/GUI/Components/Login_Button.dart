import 'package:csce315_project3_13/Inherited_Widgets/Color_Manager.dart';
import 'package:csce315_project3_13/Colors/constants.dart';
import 'package:flutter/material.dart';


class Login_Button extends StatefulWidget {
  final VoidCallback onTap;
  final String buttonName;
  final Color? textColor;
  final double fontSize;
  final double buttonWidth;

  Login_Button({required this.onTap, required this.buttonName, this.textColor, this.fontSize = 24.0, this.buttonWidth = 130});

  @override
  _Login_ButtonState createState() => _Login_ButtonState();
}

class _Login_ButtonState extends State<Login_Button> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
              height: 50,
              width: widget.buttonWidth,
              decoration: BoxDecoration(
                color:  _isHovering ? Color_Manager.of(context).hover_color : Color_Manager.of(context).active_color, //buttonColor,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.transparent,
                  width: 2,
                ),
              ),
              child: Center(
                child: Stack(
                  children: [
                    Center(child: Text(widget.buttonName,
                      style: TextStyle(
                        fontSize: widget.fontSize,
                        color: widget.textColor?? Color_Manager.of(context).text_color,
                      ),
                    )),
                    Center(
                      child: InkWell(
                        onTap: widget.onTap,
                      ),
                    ),
                  ],
                ),
              )),
        ),

    );
  }
}