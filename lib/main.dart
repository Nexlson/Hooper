import 'package:flutter/material.dart';
import 'dart:async';

void main() => runApp(const Hoop());

class Hoop extends StatelessWidget {
  const Hoop({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hoop',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: const BasketballCounterHomePage(),
    );
  }
}

class BasketballCounterHomePage extends StatefulWidget {
  const BasketballCounterHomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _BasketballCounterHomePageState createState() =>
      _BasketballCounterHomePageState();
}

class _BasketballCounterHomePageState extends State<BasketballCounterHomePage> {
  int _teamAScore = 0;
  int _teamBScore = 0;
  int _timerSeconds = 0;
  late Timer _timer;
  bool _timerStarted = false;

  void _startEndTimer() {
    setState(() {
      _timerStarted = !_timerStarted;
    });
    if (_timerStarted) {
      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        setState(() {
          _timerSeconds++;
        });
      });
    } else {
      _timer.cancel();
    }
  }

  void _incrementPoint(team, point) {
    if (_timerSeconds == 0) {
      return;
    }
    if (team == 'teamA') {
      setState(() {
        _teamAScore += point.toInt() as int;
      });
    } else {
      setState(() {
        _teamBScore += point.toInt() as int;
      });
    }
  }

  void _resetScores() {
    if (_timerSeconds != 0) {
      setState(() {
        _timer.cancel();
      });
    }
    setState(() {
      _teamAScore = 0;
      _teamBScore = 0;
      _timerSeconds = 0;
    });
  }

  String _handleTimer(seconds) {
    if (seconds >= 60) {
      int minutes = seconds ~/ 60;
      int remainingSeconds = seconds % 60;
      String minutesStr = minutes
          .toString()
          .padLeft(2, '0'); // Pad minutes with leading zero if necessary
      String secondsStr = remainingSeconds.toString().padLeft(2, '0');
      return '$minutesStr: $secondsStr';
    }
    String secondsStr = seconds.toString().padLeft(2, '0');
    return '00: $secondsStr';
  }

  @override
  void dispose() {
    // Cancel the timer when the widget is disposed
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  children: [
                    const Text(
                      'Team A',
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => _incrementPoint('teamA', 2),
                      child: Text(
                        '$_teamAScore',
                        style: TextStyle(
                            fontSize: _teamAScore <= 100 ? 400 : 300,
                            color: _teamAScore > _teamBScore
                                ? Colors.deepOrange
                                : Colors.white),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => _incrementPoint('teamA', 3),
                      child: const Icon(
                        Icons.looks_3,
                        size: 50,
                      ),
                    )
                  ],
                ),
              ),
              GestureDetector(
                onTap: _startEndTimer,
                child: Text(
                  _handleTimer(_timerSeconds),
                  style: TextStyle(
                    fontSize: 50,
                    color: _timerSeconds != 0 ?Colors.deepOrange : Colors.white
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    const Text(
                      'Team B',
                      style: TextStyle(fontSize: 24, color: Colors.white),
                    ),
                    GestureDetector(
                      onTap: () => _incrementPoint('teamB', 2),
                      child: Text(
                        '$_teamBScore',
                        style: TextStyle(
                            fontSize: _teamBScore <= 100 ? 350 : 300,
                            color: _teamBScore > _teamAScore
                                ? Colors.deepOrange
                                : Colors.white),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => _incrementPoint('teamB', 3),
                      child: const Icon(
                        Icons.looks_3,
                        size: 50,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
          IconButton(
            onPressed: _resetScores,
            icon: const Icon(Icons.restart_alt),
            iconSize: 100,
            highlightColor: Colors.black,
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}
