import 'package:covid_vaccine_notifier/model/notificationdata.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPref{
  SharedPreferences _pref;
  Future<String> get_string(key)async{
    _pref = await SharedPreferences.getInstance();
   await _pref.reload();
    return  _pref.getString(key);
  }
  Future<void> set_string(key,value)async{
    _pref = await SharedPreferences.getInstance();
   await _pref.reload();
  await   _pref.setString(key, value);
  }

  Future<bool> get_bool(key)async{
    _pref = await SharedPreferences.getInstance();
   await _pref.reload();
    return _pref.getBool(key);
  }


  Future<Active_Notification_Modal> get_active_notification_modal()async{
    _pref = await SharedPreferences.getInstance();
    await  _pref.reload();
    return Active_Notification_Modal(
      age_selected: _pref.getString("age"),
      center_detail: _pref.getString("center_detail"),
      is_pin_search: _pref.getBool("is_pin_search")
    );
  }

  Future<void> set_active_notification_modal(Active_Notification_Modal modal)async{
    _pref = await SharedPreferences.getInstance();
   await _pref.setString("age", modal.age_selected);
   await _pref.setString("center_detail", modal.center_detail);
   await _pref.setBool("is_pin_search", modal.is_pin_search);
      return;
  }
}