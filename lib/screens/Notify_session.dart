import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foreground_service/foreground_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

class NotifySession extends StatefulWidget {
  @override
  _NotifySessionState createState() => _NotifySessionState();
}

class _NotifySessionState extends State<NotifySession> {
  bool isfounded = false;
  bool isrunning = false;


  @override
  void initState() {
    get_status();
    super.initState();
  }

  void get_status() async {
     bool status = await ForegroundService.foregroundServiceIsStarted();
    setState(() {
      isrunning = status;
    });
  }

  void _toggleForegroundServiceOnOff() async {
    final fgsIsRunning = await ForegroundService.foregroundServiceIsStarted();

    if (fgsIsRunning) {
      await ForegroundService.stopForegroundService();
    } else {
  //    maybeStartFGS();
    }
  }





   TextEditingController pin = new TextEditingController();
  TextEditingController age = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(

      child: Column(
        children: [
          Flexible(
            child: Text(
                'You will receive a notification as soon as any vaccination slot will be available for your preferences',
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          Padding(padding: EdgeInsets.all(8.0)),
          TextField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
                labelText: "Pincode", hintText: "your pincode ex: 3003456"),
            controller: pin,
          ),
          TextField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
                labelText: "Age category", hintText: "Age category ex: 18,45"),
            controller: age,
          ),
          MaterialButton(
              color: Colors.green,
              onPressed: () async {
                if(isrunning){
                  setState(() {
                    isrunning=!isrunning;
                  });

                   _toggleForegroundServiceOnOff();
                  return;
                }
                if (age.text == 18.toString() ||
                    age.text == 45.toString() && pin.text.length == 6) {
                  Future<SharedPreferences> _prefs =
                  SharedPreferences.getInstance();
                  SharedPreferences preferences = await _prefs;
                  await preferences.setString("pin", pin.text);
                  await preferences.setString("age", age.text);
                  setState(() {
                    isrunning= !isrunning;
                  });
                 // isolate2("hello");
                  _toggleForegroundServiceOnOff();
                  if(isrunning) {
                    showDialog(
                        context: context,
                        builder: (_) {
                          return AlertDialog(
                            contentPadding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                            content: Text(
                                "Started searching for pincode:${preferences
                                    .getString("pin")} and Age Category :${preferences
                                    .getString(
                                    "age")} \n Keep your app in the background and take care of notifications"),
                            actions: [
                              InkWell(
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text("Ok"),
                              )
                            ],
                          );
                        });
                  }
                } else {
                  showDialog(
                      context: context,
                      builder: (_) {
                        return AlertDialog(
                          content: Text("Enter valid Area pincode or age-group"),
                          actions: [
                            MaterialButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text("Ok"))
                          ],
                        );
                      });
                }
              },
              child: Text(!isrunning ? "Start Notifier" : "Stop Notifier",style: TextStyle(color: Colors.white),))

        ],
      ),
    );
  }
}
