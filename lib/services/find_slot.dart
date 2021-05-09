
import 'package:covid_vaccine_notifier/model/center_modal.dart';
import 'package:covid_vaccine_notifier/model/State_ID_modal.dart';
import 'package:covid_vaccine_notifier/model/notificationdata.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as HTTP;
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:covid_vaccine_notifier/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FindSlot  {
  Future<List<CenterModal>> search_center(url) async {
    var res = await HTTP.get(url);
    var data = json.decode(res.body);
    var raw_list = data["centers"] as List;
    List<CenterModal> center_list = await raw_list
        .map<CenterModal>((json) => CenterModal.fromJson(json))
        .toList();
    return center_list;
  }
  Future<NotificationModal> get_slot() async {
        SharedPreferences preferences = await SharedPreferences.getInstance();
       await preferences.reload();
      String url = preferences.getString("url");
      String age =  preferences.getString("age");
     if(url==null){
      print("unable to update value");
      return NotificationModal(founded: false);
    }
    print("finding for");
    print(url);
    print(age.toString());
    var res = await HTTP.get(url);
    var data = json.decode(res.body);
    int slots=0;
    List center_list = data["centers"] as List;
    if (center_list.length != 0) {
      center_list.forEach((center) {
        List session_list = center["sessions"] as List;
        if (session_list.length != 0) {
          session_list.forEach((session) {
            if (session["min_age_limit"].toString() == age.toString() &&
                session["available_capacity"] != 0) {
              slots+=session["available_capacity"];
            }
          });
        }
      });
    }

    return NotificationModal(age: age,founded: slots==0?false:true,capacity: slots);
  }

  Future<List<State_ID_Modal>> get_state_list() async {
    var url = "https://cdn-api.co-vin.in/api/v2/admin/location/states";
    var res = await HTTP.get(url);
    var data = json.decode(res.body);
    var raw_list = data["states"] as List;
    List<State_ID_Modal> state_list = await raw_list
        .map<State_ID_Modal>((json) => State_ID_Modal.fromJson(json))
        .toList();
    return state_list;
  }

  Future<List<District_ID_Modal>> get_district_list(state_id) async {
    var url = "https://cdn-api.co-vin.in/api/v2/admin/location/districts/" +
        state_id.toString();
    var res = await HTTP.get(url);
    var data = json.decode(res.body);
    var raw_list = data["districts"] as List;
    List<District_ID_Modal> district_list = await raw_list
        .map<District_ID_Modal>((json) => District_ID_Modal.fromJson(json))
        .toList();
    return district_list;
  }

  String get_url(bool _isPinSearch,String id){
    DateTime now = DateTime.now();
    String datee = DateFormat('dd-MM-yyyy').format(now);
    var url = _isPinSearch
        ? ("https://cdn-api.co-vin.in/api/v2/appointment/sessions/public/calendarByPin?pincode="+id+"&date=" +datee)
        : ("https://cdn-api.co-vin.in/api/v2/appointment/sessions/public/calendarByDistrict?district_id="+id +"&date="+datee);
    SharedPreferences.getInstance().then((value) {
      value.setString("url", url);
      value.setString("age", "18");
    });
     return url;
  }

}
