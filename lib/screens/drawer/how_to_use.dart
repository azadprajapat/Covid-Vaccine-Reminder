import 'package:covid_vaccine_notifier/services/Language_Update/AppTranslation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HowToUse extends StatefulWidget {
  @override
  _HowToUseState createState() => _HowToUseState();
}

class _HowToUseState extends State<HowToUse> {
  List<Use_Features> features =[];
  List<Use_Features> instruction =[];
 @override
  void didChangeDependencies() {
     features = [
     Use_Features(AppTranslations.of(context).text("Search for nearby vaccination centers")),
     Use_Features(AppTranslations.of(context).text("Set notification reminder for slot availability at vaccination center",)),
     Use_Features(AppTranslations.of(context).text("send notification with high priority vibration and sound",)),
     Use_Features(AppTranslations.of(context).text("Directly book your slot by clicking on notification or from the app by clicking on 'Book on Cowin' in menu.")),
     Use_Features(AppTranslations.of(context).text("Support multi language")),
     Use_Features(AppTranslations.of(context).text("Compatible with almost every android device")),
     Use_Features(AppTranslations.of(context).text("Low battery drainage")),
   ];
     instruction=[
     Use_Features(AppTranslations.of(context).text("Maintain healthy internet connection for COVAC HELPER to work effectivily")),
     Use_Features(AppTranslations.of(context).text("if your device is in silent mode then enable sound for notification for better reach when slots are available",)),
     Use_Features(AppTranslations.of(context).text("If an active notification box is appearing on your home screen then your notification reminder is active and you can close the app"),),
     Use_Features(AppTranslations.of(context).text("if notification are not working properly in device then keep your app in background as this issue occur with some of the android device")),
     Use_Features(AppTranslations.of(context).text("It is a better practice to keep an eye on the app after an interval of 6-7 hours to ensure if the app is compatible with your device")),
     Use_Features(AppTranslations.of(context).text("This app uses Cowin public Api so if you are receving notification from the app but unable to book your slot due to unavailability of slots on Cowin then that is an issue with Cowin portal")),
     Use_Features(AppTranslations.of(context).text("If you have another issue please write to us to help you to fix your issue.")),
   ];

   super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text(
        AppTranslations.of(context).text('How to use'),
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 20,
              ),
              Text(
                AppTranslations.of(context).text("Features"),
                style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 20,
              ),
              Column(
                children: features.map((e) => _usetile(e.text,e.image)).toList(),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                AppTranslations.of(context).text("Instructions"),
                style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 20,
              ),
              Column(
                children: instruction.map((e) => _usetile(e.text,e.image)).toList(),
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _usetile(text, img) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(top: 5),
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
                color: Colors.black, borderRadius: BorderRadius.circular(10)),
          ),
          SizedBox(width: 10),
          Flexible(
              child: Text(text,
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w400)))
        ],
      ),
    );
  }
}

class Use_Features {
  var text;
  var image;
  Use_Features(this.text, {this.image});
}
