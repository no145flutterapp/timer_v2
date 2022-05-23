import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:focustimer/controllers/history_controller.dart';
import 'package:focustimer/models/history_model.dart';
import 'package:focustimer/screens/about_me_screen.dart';
import 'package:focustimer/screens/tasks_screen.dart';
import 'package:focustimer/utils/colors.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  double defaultValue = 1500;
  double value = 1500.0;
  bool isStarted = false;
  int focusedMins = 0;

  List<History> listHistory = [];

  late Timer _timer;

  HistoryController historyController = HistoryController();

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: green1));
    HistoryController.init();
  }

  void startTimer() {
    focusedMins = value.toInt();
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (value <= 1) {
          setState(() {
            timer.cancel();
            value = defaultValue;
            isStarted = false;
            listHistory = historyController.read("history");
            listHistory.add(
                History(dateTime: DateTime.now(), focusedSecs: focusedMins));
            historyController.save("history", listHistory);
            // print(historyController.read("history"));
          });
        } else {
          setState(() {
            value--;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.info_outline,
                      color: green1,
                      size: 35,
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (BuildContext context) =>
                                  const AboutMeScreen()));
                    },
                  ),
                  Text(
                    "FocusTask",
                    style: TextStyle(
                      fontSize: 25,
                      color: Color(0xff03989E),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.add_circle_outline,
                      color: green1,
                      size: 35,
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (BuildContext context) =>
                                  const HistoryScreen()));
                    },
                  ),
                ],
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Şu anki görev",
                      style: TextStyle(color: Colors.black, fontSize: 15),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Seçilen görev bu kısma gelecek",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: SizedBox(
                        width: 250,
                        height: 250,
                        child: Stack(
                          children: [
                            SleekCircularSlider(
                              initialValue: value,
                              min: 0,
                              max: 5401,
                              appearance: CircularSliderAppearance(
                                customWidths: CustomSliderWidths(
                                  trackWidth: 15,
                                  handlerSize: 20,
                                  progressBarWidth: 15,
                                  shadowWidth: 0,
                                ),
                                customColors: CustomSliderColors(
                                  trackColor: Color(0xff3EC5A5),
                                  progressBarColor: blue1,
                                  hideShadow: true,
                                  dotColor: Color(0xff3EC5A5),
                                ),
                                size: 250,
                                angleRange: 360,
                                startAngle: 270,
                              ),
                              onChange: (newValue) {
                                setState(() {
                                  value = newValue;
                                });
                              },
                              innerWidget: (double newValue) {
                                return Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SizedBox(
                                        height: 15,
                                      ),
                                      Text(
                                        "${(value ~/ 60).toInt().toString().padLeft(2, '0')}:${(value % 60).toInt().toString().padLeft(2, '0')}",
                                        style: TextStyle(
                                            color: Color(0xff9EDFCF),
                                            fontSize: 55,
                                            fontFamily: "Fredoka"),
                                      ),
                                      SizedBox(height: 15),
                                      Text(
                                        "Sayaç: 2/4 ! ",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontFamily: "Fredoka",
                                            color:
                                                Colors.grey.withOpacity(0.9)),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                            if (isStarted)
                              GestureDetector(
                                onTap: () {},
                                child: Container(
                                  width: 250,
                                  height: 250,
                                  color: Colors.transparent,
                                ),
                              )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Text(
                        "Hadi Dostum! ${(value ~/ 60).toInt().toString().padLeft(2, '0')} dk hayallerimiz için çalışalım."),
                    const SizedBox(
                      height: 30,
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          if (!isStarted) {
                            isStarted = true;
                            startTimer();
                          } else {
                            _timer.cancel();
                            value = defaultValue;
                            isStarted = false;
                          }
                        });
                      },
                      child: Container(
                        width: 200,
                        height: 50,
                        alignment: Alignment.center,
                        child: Icon(
                          isStarted
                              ? Icons.pause_circle_outline
                              : Icons.play_circle_outline,
                          color: Colors.black,
                          size: 70,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
