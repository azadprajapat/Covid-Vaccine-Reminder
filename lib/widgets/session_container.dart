import 'package:covid_vaccine_notifier/model/center_modal.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Session_Container extends StatefulWidget {
  var session;
  var filter_map;
  Session_Container({this.session,this.filter_map});
  @override
  _Session_ContainerState createState() => _Session_ContainerState();
}

class _Session_ContainerState extends State<Session_Container> {
  bool show_session=true;
  List<String> filters = [
    "Age 18+",
    "Age 45+",
    "Covishield",
    "Covaxin",
    "Free",
    "Paid"
  ];
  @override
  Widget build(BuildContext context) {
    Sessions session = widget.session;
    show_session=true;
    filters.forEach((element) {
      switch(element){
        case "Age 18+":{
          if(!widget.filter_map[element]&&session.age_limit==18){
            show_session=false;
            break;
          }
        }
        break;
        case "Age 45+":{
          if(!widget.filter_map[element]&&session.age_limit==45){
            show_session=false;
            break;
          }
          break;
        }
        break;
        case "Covishield":{
          if(!widget.filter_map[element]&&session.vaccine=="COVISHIELD"){
            show_session=false;
            break;
          }
          break;
        }

        break;
        case "Covaxin":{
          if(!widget.filter_map[element]&&session.vaccine=="COVAXIN"){
            show_session=false;
            break;
          }
          break;
        }

      }
    });
    return !show_session?Container():Container(
      padding: EdgeInsets.only(left: 10),
      child: Column(
        children: [
          Text(session.date),
          SizedBox(height: 5,),
          Text(session.vaccine),
          Container(
              padding: EdgeInsets.symmetric(horizontal: 5,vertical: 2),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: session.seat_availablity==0?Colors.red:Colors.green
              ),
              child: Text(session.seat_availablity==0?"Booked":session.seat_availablity.toString()
                ,style: TextStyle(color: Colors.white,),
              )),
          Text(session.age_limit.toString()+"+")
        ],
      ),
    );
  }
}
