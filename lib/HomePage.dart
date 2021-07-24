import 'dart:async';
import 'package:flutter/material.dart';
import 'package:untitled2/Goku.dart';
import 'package:untitled2/barriers.dart';

class HomePage extends StatefulWidget {
  const HomePage({key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static double birdY = 0;
  double initialPos = birdY;
  double height = 0;
  double time = 0;
  double gravity = -4.9;
  double velocity = 3.5;
  double birdWidth = 0.1;
  double birdHeight = 0.1;

  bool gameStarted = false;
  static List<double> barrierX = [2, 2 + 1.5];
  static double barrierWidth = 0.5;
  List<List<double>> barrierHeight = [
    [0.6, 0.4],
    [0.4, 0.6],
  ];

  void startGame() {
    gameStarted = true;
    Timer.periodic(Duration(milliseconds: 50), (timer) {
      height = gravity * time * time + velocity * time;
      setState(() {
        birdY = initialPos - height;
      });
      if (birdisDead()) {
        timer.cancel();
        _showDialog();
      }
      time += 0.1;
    });
  }

  void jump() {
    setState(() {
      time = 0;
      initialPos = birdY;
    });
  }

  void resetGame() {
    Navigator.pop(context);
    setState(() {
      birdY = 0;
      gameStarted = false;
      time = 0;
      initialPos = birdY;
    });
  }

  void _showDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.brown,
            title: Center(
              child: Text(
                " GAME OVER",
                style: TextStyle(color: Colors.white),
              ),
            ),
            actions: [
              GestureDetector(
                onTap: resetGame,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Container(
                    padding: EdgeInsets.all(7),
                    color: Colors.white,
                    child: Text(
                      'PLAY AGAIN',
                      style: TextStyle(color: Colors.brown),
                    ),
                  ),
                ),
              )
            ],
          );
        });
  }

  bool birdisDead() {
    if (birdY < -1 || birdY > 1) {
      return true;
    }
    for (int i = 0; i < barrierX.length; i++) {
      if (barrierX[i] <= birdWidth &&
          barrierX[i] + barrierWidth >= -birdWidth &&
          (birdY <= -1 + barrierHeight[i][0] ||
              birdY + birdHeight >= 1 - barrierHeight[i][1])) {
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: gameStarted ? jump : startGame,
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              flex: 3,
              child: Container(
                  color: Colors.blue,
                  child: Center(
                    child: Stack(
                      children: [
                        Goku(birdY: birdY),
                        MyBarrier(
                          barrierX: barrierX[0],
                          barrierHeight: barrierHeight[0][0],
                          barrierWidth: barrierWidth,
                          isThisBottomBarrier: false,
                        ),
                        MyBarrier(
                          barrierX: barrierX[1],
                          barrierHeight: barrierHeight[0][1],
                          barrierWidth: barrierWidth,
                          isThisBottomBarrier: false,
                        ),
                        MyBarrier(
                          barrierX: barrierX[0],
                          barrierHeight: barrierHeight[1][0],
                          barrierWidth: barrierWidth,
                          isThisBottomBarrier: false,
                        ),
                        MyBarrier(
                          barrierX: barrierX[1],
                          barrierHeight: barrierHeight[1][0],
                          barrierWidth: barrierWidth,
                          isThisBottomBarrier: false,
                        ),
                        MyBarrier(
                          barrierX: barrierX[0],
                          barrierHeight: barrierHeight[1][0],
                          barrierWidth: barrierWidth,
                          isThisBottomBarrier: false,
                        ),
                        Container(
                          alignment: Alignment(0, -0.5),
                          child: Text(
                            gameStarted ? "" : "Tap to play",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        )
                      ],
                    ),
                  )),
            ),
            Container(
              height: 15,
              color: Colors.green,
            ),
            Expanded(
              child: Container(color: Colors.brown),
            )
          ],
        ),
      ),
    );
  }
}
