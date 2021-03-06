import 'package:covid_vaccine_notifier/model/State_ID_modal.dart';
import 'package:covid_vaccine_notifier/services/Language_Update/AppTranslation.dart';
import 'package:covid_vaccine_notifier/services/find_slot.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StateDistrictForm extends StatefulWidget {
  Function notify_parent;
  StateDistrictForm({this.notify_parent});
  @override
  _StateDistrictFormState createState() => _StateDistrictFormState();
}

class _StateDistrictFormState extends State<StateDistrictForm> {
  String _state_chosenValue;
  String _district_chosenValue;
  List<State_ID_Modal> state_list=[];
  List<District_ID_Modal> district_list=[];
  bool _fetching=true;
  @override
  void initState() {
    get_state();
     super.initState();
  }
  void get_state()async{
    var list = await FindSlot().get_state_list();
   if(!mounted){
     Future.delayed(Duration(milliseconds: 1),(){
       setState(() {
         state_list=list;
         _fetching=false;
       });
     });
   }
    setState(() {
      state_list=list;
      _fetching=false;
    });


  }
  @override
  void dispose() {
     super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return _fetching?Center(child: CircularProgressIndicator(
      backgroundColor: Theme.of(context).primaryColor,
    )):Container(
        width: 300 * MediaQuery.of(context).size.width / 360,
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: Theme.of(context).primaryColor)
          ),
          child: DropdownButton<String>(
          value: _state_chosenValue,
          underline: Container(),
          isExpanded: true,
          style: TextStyle(color: Colors.black),

          items: state_list.map<DropdownMenuItem<String>>((State_ID_Modal modle) {
            return DropdownMenuItem<String>(
              value: modle.state_name,
              child: Text(modle.state_name),
            );
          }).toList(),
          hint: Text(
            AppTranslations.of(context).text("Select State"),
            style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w600),
          ),
          onChanged: (String value) async {
            setState(() {
              _district_chosenValue=null;
              district_list=[];
              _state_chosenValue = value;
            });
           await get_districts(value);
          },
      ),
        ),
          SizedBox(height: 20,),
          Container(
            height: 40,
            padding: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Theme.of(context).primaryColor)
            ),
            child: DropdownButton<String>(
              value: _district_chosenValue,
              underline: Container(),
              isExpanded: true,

              //elevation: 5,
              style: TextStyle(color: Colors.black),
              items: district_list.map<DropdownMenuItem<String>>((District_ID_Modal modle) {
                return DropdownMenuItem<String>(
                  value: modle.district_name,
                  child: Text(modle.district_name),
                );
              }).toList(),
              hint: Text(
    AppTranslations.of(context).text("Select District"),
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              ),
              onChanged: (String value) {
                setState(() {
                  _district_chosenValue = value;
                });
                for(var element in district_list){
                  if(element.district_name==value){
                    widget.notify_parent(element);

                    break;
                  }
                }

              },
            ),
          ),
        ],
      )
    );
  }
  void get_districts(value)async{
    var state_id;
    for(var element in state_list){
      if(element.state_name==value){
        state_id = element.id;
        break;
      }
    }
    if(state_id!=null){
    var raw_district_list = await FindSlot().get_district_list(state_id);
    setState(() {
      district_list=raw_district_list;
    });
    }
  }
}
