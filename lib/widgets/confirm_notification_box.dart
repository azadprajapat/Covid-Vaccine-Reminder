
import 'package:covid_vaccine_notifier/services/Language_Update/AppTranslation.dart';
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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20)
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            AppTranslations.of(context).text("SET NOTIFICATION REMINDER"),style: TextStyle(fontWeight: FontWeight.w600,fontSize: 16,color: Theme.of(context).primaryColor),),
         SizedBox(height: 20,),
          Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
                border:
                Border.all(color: Theme.of(context).primaryColor),
                borderRadius: BorderRadius.circular(30)),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: !is_age_18?(){
                    setState(() {
                      is_age_18=!is_age_18;
                    });
                  }:null,
                  child: Container(
                    width: MediaQuery.of(context).size.width/3.2,
                    padding: EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          bottomLeft: Radius.circular(30)),
                      color: !is_age_18
                          ? Colors.white
                          : Theme.of(context).primaryColor,
                    ),
                    child: Center(
                      child: Text(
    AppTranslations.of(context).text("AGE 18+"),
                        style: TextStyle(
                            color: is_age_18
                                ? Colors.white
                                : Theme.of(context).primaryColor,
                            fontSize: 12),
                      ),
                    ),
                  ),
                ),

                InkWell(
                  onTap: is_age_18?(){
                    setState(() {
                      is_age_18=!is_age_18;
                    });
                  }:null,
                  child: Container(
                    width: MediaQuery.of(context).size.width/3.2,
                    padding: EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(30),
                          bottomRight: Radius.circular(30)),
                      color: is_age_18
                          ? Colors.white
                          : Theme.of(context).primaryColor,
                    ),
                    child: Center(
                      child: Text(AppTranslations.of(context).text("AGE 45+"),
                          style: TextStyle(
                              color: !is_age_18
                                  ? Colors.white
                                  : Theme.of(context).primaryColor,
                              fontSize: 12)),
                    ),
                  ),
                )
              ],
            ),
          ),

            SizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                  InterstitialAd _interstitalAd;
                  Interstitial_Ad().initialize_ad( _interstitalAd,false,false);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Theme.of(context).errorColor
                  ),
                  child: Text(AppTranslations.of(context).text("No"),style: TextStyle(color:Colors.white,fontSize: 16,fontWeight: FontWeight.w600),),
                ),
              ),
              SizedBox(width: 20,),

              InkWell(
                onTap: () async {
                  await widget.notify_parent(is_age_18?"18":"45");
                  setState(() {
                  });
                  Navigator.of(context).pop();
                 },
                child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Theme.of(context).primaryColor
                    ),
                    child: Text(AppTranslations.of(context).text("Yes"),style: TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.w600))),
              )
            ],
          )
        ],
      ),

    );
  }
}
