import 'package:flutter/material.dart';

class Goku extends StatelessWidget {
  final birdY;

  Goku({
    this.birdY,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment(0, birdY),
        child: Image.asset(
          'lib/images/goku.png',
          width: 50,
          height: 50,
        ));
  }
}
