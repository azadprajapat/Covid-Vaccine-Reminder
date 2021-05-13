
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'filter_pills.dart';
import 'interstital_ad.dart';

class ConfirmNotificationBox extends StatefulWidget {
  Function notify_parent;
  ConfirmNotificationBox({this.notify_parent});
  @override
  _ConfirmNotificationBoxState createState() => _ConfirmNotificationBoxState();
}

class _ConfirmNotificationBoxState extends State<ConfirmNotificationBox> {
  bool is_age_18=true;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Set Notification Reminder",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 16),),
         SizedBox(height: 20,),
           Row(
            children: [
              InkWell(
                  onTap: !is_age_18?(){
                    setState(() {
                      is_age_18=!is_age_18;
                    });
                  }:null,
                  child: filter_pills("Age18 +", is_age_18,context)),
              SizedBox(width: 20,),
              InkWell(
                  onTap: is_age_18?(){
                    setState(() {
                      is_age_18=!is_age_18;
                    });
                  }:null,
                  child: filter_pills("Age45 +", !is_age_18,context))
            ],
          ),
          SizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                  InterstitialAd _interstitalAd;
                  Interstitial_Ad().initialize_ad( _interstitalAd,false);
                },
                child: Text("No",style: TextStyle(color:
                Theme.of(context).errorColor,fontSize: 16,fontWeight: FontWeight.w600),),
              ),

              InkWell(
                onTap: () async {
                await  SharedPreferences.getInstance().then((value) => value.setString("age", is_age_18?"18":"45"));
                await widget.notify_parent();
                Navigator.of(context).pop();

                },
                child: Text("Yes",style: TextStyle(color: Theme.of(context).primaryColor,fontSize: 16,fontWeight: FontWeight.w600)),
              )
            ],
          )
        ],
      ),

    );
  }
}
