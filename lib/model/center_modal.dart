class CenterModal{
  String name;
  String address;
  List<Sessions> sessions;
  String fee_type;
  String lat;
  String long;
  String district;
  CenterModal({this.name,this.address,this.sessions,this.fee_type,this.district,this.lat,this.long});
  factory CenterModal.fromJson(Map<String,dynamic> json){
    var session_list = json["sessions"] as List;
    return CenterModal(
      name: json["name"],
      lat: json['lat'].toString(),
      long: json['long'].toString(),
      address: json["address"],
      district: json["district_name"],
      fee_type: json["fee_type"],
      sessions:List.generate(session_list.length, (index) => Sessions.fromJson(session_list[index]))
    );

  }

}
class Sessions{
  int age_limit;
  int seat_availablity;
  String date;
  String vaccine;
  Sessions({this.age_limit,this.seat_availablity,this.date,this.vaccine});
  factory Sessions.fromJson(Map<String,dynamic>json){
    return Sessions(
     seat_availablity: json["available_capacity"],
      age_limit: json["min_age_limit"],
      vaccine: json['vaccine'],
      date: json['date']
    );
  }
}
