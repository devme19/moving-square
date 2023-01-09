import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Moving Square',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SquareScreen(),
    );
  }
}

class SquareScreen extends StatefulWidget {
  const SquareScreen({Key? key}) : super(key: key);

  @override
  State<SquareScreen> createState() => _SquareScreenState();
}

class _SquareScreenState extends State<SquareScreen> {
  final double _squareSize = 100;
  Offset? _squarePosition;
  double _slope = 0;
  double _xDistance = 0;
  int _tapCount = 0;
  String imgUrl = '';
  double xStart = 0, yStart = 0;
  int _counter = 0;
  AppBar appBar = AppBar(
    title: Text('Moving Square'),
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    imgUrl = 'https://source.unsplash.com/random/$_counter';
  }

  @override
  Widget build(BuildContext context) {
    _squarePosition ??= Offset(
        (MediaQuery.of(context).size.width - _squareSize) / 2,
        (MediaQuery.of(context).size.height - _squareSize) / 2);

    return Scaffold(
      appBar: AppBar(
        title: Text('Moving Square'),
      ),
      body: Stack(
        children: [
          Listener(
            onPointerDown: ((event) {
              print('pointer down dx ${event.position.dx}');
              print('pointer down dy ${event.position.dy}');
              xStart = event.position.dx;
              yStart = event.position.dy;
            }),
            onPointerUp: ((event) {
              print('pointer up dx ${event.position.dx}');
              print('pointer up dy ${event.position.dy}');
              _tapCount++;
              _slope =
                  (-event.position.dy + yStart) / (event.position.dx - xStart);
              if (event.position.dx < xStart) {
                moveLeft(_slope, _tapCount);
              }
              if (event.position.dx > xStart) {
                moveRight(_slope, _tapCount);
              }
            }),
            child: Container(
              color: Colors.transparent,
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
            ),
          ),
          Positioned(
            left: _squarePosition!.dx,
            top: _squarePosition!.dy,
            child: InkWell(
              onTap: () {
                setState(() {
                  _counter++;
                  imgUrl = 'https://source.unsplash.com/random/$_counter';
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  border: Border.all(color: Colors.purple, width: 1),
                ),
                height: _squareSize,
                width: _squareSize,
                child: Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: ClipRRect(
                    child: Image.network(imgUrl, fit: BoxFit.cover),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void moveLeft(double slope, int i) {
    Timer.periodic(const Duration(milliseconds: 8), (timer) {
      if (_tapCount != i) {
        timer.cancel();
//Stop moving in this direction when the screen is tapped again

      }
      _xDistance = sqrt(1 / (1 + pow(slope, 2)));
      setState(() {
        _squarePosition = Offset(_squarePosition!.dx - _xDistance,
            _squarePosition!.dy + slope * _xDistance);
      });

//if the ball bounces off the top or bottom
      if (_squarePosition!.dy < 0 ||
          _squarePosition!.dy >
              MediaQuery.of(context).size.height -
                  _squareSize -
                  appBar.preferredSize.height -
                  MediaQuery.of(context).viewPadding.top) {
        timer.cancel();
        moveLeft(-slope, i);
      }
//if the ball bounces off the left
      if (_squarePosition!.dx < 0) {
        timer.cancel();
        moveRight(-slope, i);
      }
    });
  }

  void moveRight(double slope, int i) {
    Timer.periodic(const Duration(milliseconds: 8), (timer) {
      if (_tapCount != i) {
        timer.cancel();
//Stop moving in this direction when the screen is tapped again
      }
      _xDistance = sqrt(1 / (1 + pow(slope, 2)));
      setState(() {
        _squarePosition = Offset(_squarePosition!.dx + _xDistance,
            _squarePosition!.dy - slope * _xDistance);
      });

//if the ball bounces off the top or bottom

      if (_squarePosition!.dy < 0 ||
          _squarePosition!.dy >
              MediaQuery.of(context).size.height -
                  _squareSize -
                  appBar.preferredSize.height -
                  MediaQuery.of(context).viewPadding.top) {
        timer.cancel();
        moveRight(-slope, i);
      }
//if the ball bounces off the right
      if (_squarePosition!.dx >
          MediaQuery.of(context).size.width - _squareSize) {
        timer.cancel();
        moveLeft(-slope, i);
      }
    });
  }
}
