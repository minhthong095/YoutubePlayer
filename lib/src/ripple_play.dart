import 'package:flutter/material.dart';

const kBorderWidthRipple = 1.5;

class RipplePlay extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;
  RipplePlay({required this.child, required this.onTap});
  @override
  _RipplePlayState createState() => _RipplePlayState();
}

class _RipplePlayState extends State<RipplePlay> {
  bool _on = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _on = !_on;
        });
        Future.delayed(Duration(milliseconds: 70)).then((_) {
          setState(() {
            _on = !_on;
          });
          widget.onTap();
        });
      },
      child: Stack(
        children: [
          Positioned.fill(
            child: AnimatedContainer(
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: _on ? Color(0x40ffffff) : Colors.transparent,
                      width: kBorderWidthRipple)),
              duration: Duration(milliseconds: 150),
            ),
          ),
          Positioned(
            left: kBorderWidthRipple,
            right: kBorderWidthRipple,
            top: kBorderWidthRipple,
            bottom: kBorderWidthRipple,
            child: AnimatedContainer(
                duration: Duration(milliseconds: 50),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _on ? Color(0x15ffffff) : Colors.transparent,
                )),
          ),
          widget.child
        ],
      ),
    );
  }
}
