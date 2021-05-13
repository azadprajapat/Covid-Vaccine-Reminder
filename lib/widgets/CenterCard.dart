import 'dart:ui';
import 'package:covid_vaccine_notifier/widgets/session_container.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../model/center_modal.dart';
class CenterCard extends StatefulWidget {
  var filter_map;
  final CenterModal modal;
  CenterCard({this.modal,this.filter_map});
  @override
  _CenterCardState createState() => _CenterCardState();
}


class _CenterCardState extends State<CenterCard> {

  @override
  void initState() {
      super.initState();
  }
@override
  void didChangeDependencies() {
     super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    return  Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      elevation: 16.0,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.modal.name.length<25?widget.modal.name:widget.modal.name.substring(0,25)+"...",
                      style: TextStyle(
                          color: Colors.blue,
                          fontSize: 18,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: 3,),
                    Text(
                      widget.modal.address.length<35?widget.modal.address:widget.modal.address.substring(0,35)+"...",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w500),
                    ),

                  ],
                ),
                widget.modal.fee_type=="Paid"?Icon(Icons.monetization_on_outlined):Container(),

              ],
            ),
            SizedBox(height: 15,),
            Scrollbar(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: List.generate(widget.modal.sessions.length, (index) =>
                      Session_Container(session: widget.modal.sessions[index],filter_map: widget.filter_map,)),
                ),
              ),
            ),
          SizedBox(height: 10,)
          ],
        ),
      ),
    );
   }

}

