import 'package:covid_vaccine_notifier/model/center_modal.dart';
import 'package:covid_vaccine_notifier/model/State_ID_modal.dart';
import 'package:covid_vaccine_notifier/model/notificationdata.dart';
import 'package:covid_vaccine_notifier/services/url_services.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as HTTP;
import 'dart:convert';

const base_url = Url_Services.cowin_base_api;
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



  Future<Notification_Founded_Modal> get_slot(url,Active_Notification_Modal active_notification_modal) async {
      if(url==null){
      print("unable to update value");
      return Notification_Founded_Modal(founded: false);
    }
    print("finding for");
    print(url);
    print(active_notification_modal.age_selected);
    var res = await HTTP.get(url);
    var data = json.decode(res.body);
    int slots=0;
    List center_list = data["centers"] as List;
    if (center_list.length != 0) {
      center_list.forEach((center) {
        List session_list = center["sessions"] as List;
        if (session_list.length != 0) {
          session_list.forEach((session) {
            if (session["min_age_limit"].toString() == active_notification_modal.age_selected.toString() &&
                session["available_capacity"] != 0) {
              slots+=session["available_capacity"];
            }
          });
        }
      });
    }
    if(slots==0){
      return Notification_Founded_Modal(founded: false);
    }
    return Notification_Founded_Modal(
      center_detail: active_notification_modal.center_detail,
      is_pin_search: active_notification_modal.is_pin_search,
      age_selected: active_notification_modal.age_selected,
        founded: slots==0?false:true,capacity: slots);
  }

  Future<List<State_ID_Modal>> get_state_list() async {
    var url = "${base_url}/admin/location/states";
    var res = await HTTP.get(url);
    var data = json.decode(res.body);
    var raw_list = data["states"] as List;
    List<State_ID_Modal> state_list = await raw_list
        .map<State_ID_Modal>((json) => State_ID_Modal.fromJson(json))
        .toList();
    return state_list;
  }

  Future<List<District_ID_Modal>> get_district_list(state_id) async {
    var url = "${base_url}/admin/location/districts/" +
        state_id.toString();
    var res = await HTTP.get(url);
    var data = json.decode(res.body);
    var raw_list = data["districts"] as List;
    List<District_ID_Modal> district_list = await raw_list
        .map<District_ID_Modal>((json) => District_ID_Modal.fromJson(json))
        .toList();
    return district_list;
  }

  String get_url(bool _isPinSearch,String pin,District_ID_Modal district_id_modal){
    DateTime now = DateTime.now();
    String datee = DateFormat('dd-MM-yyyy').format(now);
    var url = _isPinSearch
        ? ("${base_url}/appointment/sessions/public/calendarByPin?pincode="+pin+"&date=" +datee)
        : ("${base_url}/appointment/sessions/public/calendarByDistrict?district_id="+district_id_modal.id.toString() +"&date="+datee);
    return url;
  }
}
