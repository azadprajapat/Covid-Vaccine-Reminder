import 'package:covid_vaccine_notifier/services/Language_Update/AppTranslation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Notification_Fab extends StatefulWidget {
   @override
  _Notification_FabState createState() => _Notification_FabState();
}

class _Notification_FabState extends State<Notification_Fab> {


  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 16,
      clipBehavior: Clip.antiAlias,
      shape:RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),

      ),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
        decoration:BoxDecoration(
          color: Theme.of(context).primaryColor,
         ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.notifications_active_rounded,color: Colors.white,size: 20,)
          ,SizedBox(width: 2,),
            Text(AppTranslations.of(context).text("SET NOTIFICATION REMINDER"),style: TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.w600),)
          ],
        ),
      ),
    );
  }
}
