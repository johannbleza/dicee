import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';
import 'package:blinking_text/blinking_text.dart';

void main() {
  return runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: DicePage(),
      ),
    ),
  );
}

class DicePage extends StatefulWidget {
  const DicePage({super.key});

  @override
  State<DicePage> createState() => _DicePageState();
}

class _DicePageState extends State<DicePage> {
  int leftDice = 14;
  int rightDice = 14;
  int totalRoll = 0;
  String compare = '';
  bool repeat = true;
  Timer? _timer;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 80),
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('images/bg.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        children: [
          const Center(
            child: Text(
              "DICEE",
              style: TextStyle(
                fontFamily: 'Minecraft',
                color: Colors.white,
                fontSize: 60,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const Center(
            child: BlinkText(
              "TAP TO ROLL!",
              style: TextStyle(
                fontFamily: 'Minecraft',
                color: Colors.white,
                fontSize: 48,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 100, ),
            child: Center(
              child: Stack(
                children: [
                  Positioned(
                    right: 100,
                    bottom: 10,
                    child: TextButton(
                      onPressed: rollDice,
                      child: Image.asset('images/a$leftDice.png'),
                    ),
                  ),
                  Positioned(
                    child: TextButton(
                      onPressed: rollDice,
                      child: Image.asset('images/a$rightDice.png'),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 36, bottom: 20),
            child: Text(
              'Total roll is $totalRoll',
              style: const TextStyle(
                fontFamily: 'Minecraft',
                color: Colors.white,
                fontSize: 40,
              ),
            ),
          ),
          Text(
            compare,
            style: const TextStyle(
              fontFamily: 'Minecraft',
              fontSize: 28,
              color: Colors.white,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 40),
            child: TextButton(
              onPressed: toggleRepeatRoll,
              child: Text(
                "Autoplay: ${_timer == null || !_timer!.isActive ? 'OFF' : 'ON'}",
                style: const TextStyle(
                    fontFamily: 'Minecraft', fontSize: 40, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void rollDice() {
    rightDice = 1;
    leftDice = 1;
    compare = 'Rolling...';
    Timer.periodic(const Duration(milliseconds: 100), (timer) {
      setState(() {
        if (rightDice > 11) {
          timer.cancel();
          rightDice = 14 + Random().nextInt(20 - 14);
          leftDice = 14 + Random().nextInt(20 - 14);
          totalRoll = (rightDice - 13) + (leftDice - 13);
          if (rightDice > leftDice) {
            compare = 'Right dice rolls higher';
          } else if (leftDice > rightDice) {
            compare = 'Left dice rolls higher';
          } else {
            compare = 'Dice roll are equal';
          }
        } else {
          rightDice++;
          leftDice++;
        }
      });
    });
  }

  void toggleRepeatRoll() {
    rollDice();
    if (_timer == null || !_timer!.isActive) {
      _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
        rollDice();
      });
    } else {
      _timer?.cancel();
    }
  }
}
