class State_ID_Modal{
  int id;
  String state_name;
  State_ID_Modal({this.id,this.state_name});
  factory State_ID_Modal.fromJson(Map<String,dynamic> json){
    return State_ID_Modal(
    id: json['state_id'],
    state_name: json['state_name']
    );
  }
}
class District_ID_Modal{
  int id;
  String district_name;
  District_ID_Modal({this.id,this.district_name});
  factory District_ID_Modal.fromJson(Map<String,dynamic> json){
    return District_ID_Modal(
        id: json['district_id'],
        district_name: json['district_name']
    );
  }
}