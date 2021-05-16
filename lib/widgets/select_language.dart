import 'package:covid_vaccine_notifier/services/Language_Update/AppTranslation.dart';
import 'package:covid_vaccine_notifier/services/Language_Update/Application.dart';
import 'package:covid_vaccine_notifier/services/shared_pref.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Select_language extends StatefulWidget {
  Function notifyParent;

  Select_language({this.notifyParent});

  @override
  _Select_languageState createState() => _Select_languageState();
}

class _Select_languageState extends State<Select_language> {
  bool language_english = true;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Select your language - अपनी भाषा चुनें",
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Theme.of(context).primaryColor),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
                border: Border.all(color: Theme.of(context).primaryColor),
                borderRadius: BorderRadius.circular(30)),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: !language_english
                      ? () {
                          setState(() {
                            language_english = !language_english;
                          });
                        }
                      : null,
                  child: Container(
                    width: MediaQuery.of(context).size.width / 3.0,
                     height: 35,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          bottomLeft: Radius.circular(30)),
                      color: !language_english
                          ? Colors.white
                          : Theme.of(context).primaryColor,
                    ),
                    child: Center(
                      child: Text(
                        "English",
                        style: TextStyle(
                            color: language_english
                                ? Colors.white
                                : Theme.of(context).primaryColor,
                            fontSize: 12),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: language_english
                      ? () {
                          setState(() {
                            language_english = !language_english;
                          });
                        }
                      : null,
                  child: Container(
                    width: MediaQuery.of(context).size.width / 3.0,
                     height: 35,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(30),
                          bottomRight: Radius.circular(30)),
                      color: language_english
                          ? Colors.white
                          : Theme.of(context).primaryColor,
                    ),
                    child: Center(
                      child: Text("हिंदी",
                          style: TextStyle(
                              color: !language_english
                                  ? Colors.white
                                  : Theme.of(context).primaryColor,
                              fontSize: 12)),
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () async {
                  if (language_english) {
                    await application.onLocaleChanged(Locale("en"));
                    await SharedPref().set_string("language", "en");
                  } else {
                    await application.onLocaleChanged(Locale("hz"));
                    await SharedPref().set_string("language", "hz");
                  }
                  Navigator.of(context).pop();
                  widget.notifyParent();
                },
                child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Theme.of(context).primaryColor),
                    child: Text("Done",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600))),
              )
            ],
          )
        ],
      ),
    );
  }
}
