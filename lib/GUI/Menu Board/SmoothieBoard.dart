import 'dart:async';
import 'package:flutter/material.dart';

class SmoothieBoard extends StatefulWidget {
  final List<Map<String, dynamic>> items;
  final String category;
  final double width;
  final double height;
  final Color color;

  SmoothieBoard({Key? key,
    required this.items,
    required this.category,
    required this.width,
    required this.height,
    required this.color,
  }) : super(key: key);

  @override
  _SmoothieBoardState createState() => _SmoothieBoardState();
}

class _SmoothieBoardState extends State<SmoothieBoard> {
  int _startIndex = 0;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Timer? _timer;


  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 6), (timer) {
      setState(()
      {
        _startIndex = (_startIndex + (widget.width / 55).floor()) % (widget.items.length);
      });
      if (_startIndex < (widget.width / 55).floor())
        {
          _startIndex = 0;
        }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 2,
            color: widget.color,
          ),
          borderRadius: BorderRadius.circular(25.0),
        ),
        child: AnimatedOpacity(
          duration: const Duration(seconds: 1),
          opacity: 1.0,
          child: Column(
            children: [
              Container(
                height: 50,
                width: widget.width,
                decoration: BoxDecoration(
                  color: widget.color,
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: Center(
                  child: Text(
                    widget.category,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
               ),
              SizedBox(
                width: widget.width,
                child: Row(
                  children: [
                    SizedBox(width: widget.width / 2, height: 25),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            width: widget.width / 6,
                            child: const FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                'S',
                                style: TextStyle(fontSize: 10,),
                                maxLines: 1,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: widget.width / 6,
                            child: const FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                'M',
                                style: TextStyle(fontSize: 10),
                                maxLines: 1,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: widget.width / 6 - 8,
                            child: const FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                'L',
                                style: TextStyle(fontSize: 10),
                              ),
                            ),
                          ),]
                    )
                  ],
                ),
              ),
              for (var i = _startIndex;
              i < _startIndex + (widget.width / 55).floor() && i < widget.items.length;
              i++)
                Row(
                  children: [
                    Container(
                      width: (widget.width / 2),
                      height: 22,
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(left: 5),
                      margin: const EdgeInsets.only(bottom: 10),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          widget.items[i]['name'],
                          style: const TextStyle(
                            fontSize: 30,
                          ),
                          textAlign: TextAlign.start,
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      width: (widget.width / 2) - 8,
                      child: Row(
                        children: [
                          SizedBox(
                            width: widget.width / 6,
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                '\$${widget.items[i]['small']}',
                                style: const TextStyle(fontSize: 15,),
                                maxLines: 1,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: widget.width / 6,
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                '\$${widget.items[i]['medium']}',
                                style: const TextStyle(fontSize: 15),
                                maxLines: 1,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: widget.width / 6 - 8,
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                '\$${widget.items[i]['large']}',
                                style: const TextStyle(fontSize: 15),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
