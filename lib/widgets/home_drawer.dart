import 'package:covid_vaccine_notifier/model/drawer_widget_modal.dart';
import 'package:covid_vaccine_notifier/screens/cowin_webview.dart';
import 'package:covid_vaccine_notifier/screens/drawer/how_to_use.dart';
import 'package:covid_vaccine_notifier/screens/drawer/privacy_policy.dart';
import 'package:covid_vaccine_notifier/services/Language_Update/AppTranslation.dart';
import 'package:covid_vaccine_notifier/services/Language_Update/Application.dart';
import 'package:covid_vaccine_notifier/services/shared_pref.dart';
import 'package:covid_vaccine_notifier/services/url_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeDrawer extends StatefulWidget {
  @override
  _HomeDrawerState createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {
  List<Drawer_Modal> drawer_items=[];
  @override
  void didChangeDependencies() {
    drawer_items=[
      Drawer_Modal(text: AppTranslations.of(context).text("How to use"),icon: FaIcon(FontAwesomeIcons.questionCircle,color: Theme.of(context).primaryColor,),onpress: (){
        Navigator.of(context).pop();
        Navigator.push(context, MaterialPageRoute(builder: (_)=>HowToUse()));
      }),
      Drawer_Modal(text: AppTranslations.of(context).text("Switch Language"),icon:FaIcon(FontAwesomeIcons.language,color: Theme.of(context).primaryColor,),onpress: ()async{
       String language_code = AppTranslations.of(context).currentLanguage;
        if(language_code=="hz"){
         await  application.onLocaleChanged(Locale("en"));
         await  SharedPref().set_string("language", "en");
       }else{
         await  application.onLocaleChanged(Locale("hz"));
         await  SharedPref().set_string("language", "hz");
       }
       }),
      Drawer_Modal(text: AppTranslations.of(context).text("Book on Cowin"),icon: FaIcon(FontAwesomeIcons.calendarAlt,color: Theme.of(context).primaryColor,),onpress: (){
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_)=>Cowin_Web_View()), (route) => false);
      }),
      Drawer_Modal(text: AppTranslations.of(context).text("Rate Us"),icon: FaIcon(FontAwesomeIcons.googlePlay,color: Theme.of(context).primaryColor,),onpress: (){
        Navigator.pop(context);
        launch(Url_Services.play_store);
      }),

      Drawer_Modal(text: AppTranslations.of(context).text("Write to Developer"),icon: FaIcon(FontAwesomeIcons.envelope,color: Theme.of(context).primaryColor,),onpress: (){
        Navigator.pop(context);
        launch("mailto:${Url_Services.developer_email}");
      }),
      Drawer_Modal(text: AppTranslations.of(context).text("Privacy Policy"),icon: FaIcon(FontAwesomeIcons.fileContract,color: Theme.of(context).primaryColor,),onpress: (){
        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(builder: (_)=>Privacy_Policy()));

      }),
    ];
     super.didChangeDependencies();
  }
  @override
  void initState() {
     super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 20,vertical: 30),
        width: MediaQuery.of(context).size.width/1.3,
        child: Column(
          children: [
             SizedBox(height: 20,),
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("lib/assets/logo.png"),
                  fit: BoxFit.cover
                )
              ),
            ),
            SizedBox(height: 40,),
            Column(
              children: List.generate(drawer_items.length, (index) =>
                  _drawer_tile(drawer_items[index])),
            )
          ],
        ),
      ),
    );
  }
  Widget _drawer_tile(Drawer_Modal modal){
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap:modal.onpress,
        child: Card(
          elevation: 0,
          shadowColor: Theme.of(context).primaryColor,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
          ),
          clipBehavior: Clip.none,
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color:Theme.of(context).primaryColor,width: 1)
            ),
            padding: EdgeInsets.symmetric(vertical: 5,horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(modal.text,style: TextStyle(fontSize: 14,fontWeight: FontWeight.w600),),
                modal.icon
              ],
            ),
          ),
        ),
      ),
    );
  }
}
