import 'package:covid_vaccine_notifier/model/State_ID_modal.dart';
import 'package:covid_vaccine_notifier/screens/CenterList/center_list.dart';
import 'package:covid_vaccine_notifier/screens/Loading_screen.dart';
import 'package:covid_vaccine_notifier/services/Language_Update/AppTranslation.dart';
import 'package:covid_vaccine_notifier/widgets/active_notification_box.dart';
import 'package:covid_vaccine_notifier/services/find_slot.dart';
import 'package:covid_vaccine_notifier/widgets/ad_helper.dart';
import 'package:covid_vaccine_notifier/widgets/banner_add.dart';
import 'package:covid_vaccine_notifier/widgets/home_drawer.dart';
import 'package:covid_vaccine_notifier/widgets/state_district_form.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  bool _isPinSearch = true;
  TextEditingController pin_controller = new TextEditingController();
  District_ID_Modal district_modal = new District_ID_Modal();
  bool is_initialised=false;

  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 6),(){
      setState(() {
        is_initialised=true;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return !is_initialised?Loading_Screen():Scaffold(
      drawer: HomeDrawer(),
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text(
          'COVAC HELPER',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Stack(
          children: [
            Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                      AppTranslations.of(context)
                          .text("Search vaccination center"),
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 18,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          border:
                              Border.all(color: Theme.of(context).primaryColor),
                          borderRadius: BorderRadius.circular(30)),
                      child: Container(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () {
                                setState(() {
                                  _isPinSearch = true;
                                });
                              },
                              child: Container(
                                height: 40,
                                width: 150 *
                                    MediaQuery.of(context).size.width /
                                    360,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(30),
                                      bottomLeft: Radius.circular(30)),
                                  color: !_isPinSearch
                                      ? Colors.white
                                      : Theme.of(context).primaryColor,
                                ),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 6),
                                child: Center(
                                  child: Text(
                                    AppTranslations.of(context)
                                        .text("Search By PIN"),
                                    style: TextStyle(
                                        color: _isPinSearch
                                            ? Colors.white
                                            : Theme.of(context).primaryColor,
                                        fontSize: 14),
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  _isPinSearch = false;
                                });
                              },
                              child: Container(
                                height: 40,
                                width: 150 *
                                    MediaQuery.of(context).size.width /
                                    360,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(30),
                                      bottomRight: Radius.circular(30)),
                                  color: _isPinSearch
                                      ? Colors.white
                                      : Theme.of(context).primaryColor,
                                ),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 6),
                                child: Center(
                                  child: Text(
                                      AppTranslations.of(context)
                                          .text("Search By District"),
                                      style: TextStyle(
                                          color: !_isPinSearch
                                              ? Colors.white
                                              : Theme.of(context).primaryColor,
                                          fontSize: 14)),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                        width: 300 * MediaQuery.of(context).size.width / 360,
                        child: _isPinSearch
                            ? _PinForm()
                            : Center(
                                child: StateDistrictForm(
                                  notify_parent: (District_ID_Modal modal) {
                                    setState(() {
                                      district_modal = modal;
                                    });
                                  },
                                ),
                              )),
                    SizedBox(
                      height: 20,
                    ),
                    MaterialButton(
                      color: Theme.of(context).primaryColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      disabledColor: Colors.black38,
                      onPressed: () {
                        handle_search();
                      },
                      child: Text(
                        AppTranslations.of(context).text("Search"),
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(AppTranslations.of(context).text("The data is updated from Cowin in real-time"),style: TextStyle(color: Theme.of(context).primaryColor),)
                  ],
                )),
            Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ActiveNotificationBox(),
                  Container(
                      child: BannerAdWidget(
                          AdSize.banner, AdHelper.bannerAdUnitId1)),
                  Container(
                      child: BannerAdWidget(
                          AdSize.banner, AdHelper.bannerAdUnitId2)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void handle_search() async {
    FocusScope.of(context).unfocus();
    if (_isPinSearch && pin_controller.text.length == 6 ||
        !_isPinSearch && district_modal != null) {
      String url =
          FindSlot().get_url(_isPinSearch, pin_controller.text, district_modal);
      var result = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => CenterList(
                    url: url,
                    is_pin_search: _isPinSearch,
                    center_detail: _isPinSearch
                        ? pin_controller.text
                        : district_modal.district_name,
                  )));
      if (result != null) {
        setState(() {});
      }
    } else {
      showDialog(
          context: context,
          builder: (_) {
            return AlertDialog(
              content: Text(
                  AppTranslations.of(context).text("Enter valid Area pincode")),
              actions: [
                InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Theme.of(context).primaryColor),
                      child: Text(AppTranslations.of(context).text("Ok"),
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600))),
                )
              ],
            );
          });
    }
  }

  Widget _PinForm() {
    return Container(
      height: 40,
      child: TextField(
        autocorrect: true,
        controller: pin_controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          hintText: AppTranslations.of(context).text('Enter your PIN'),
          hintStyle: TextStyle(color: Colors.grey),
          filled: true,
          fillColor: Colors.white70,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(30.0)),
            borderSide:
                BorderSide(color: Theme.of(context).primaryColor, width: 1),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(30.0)),
            borderSide: BorderSide(color: Theme.of(context).primaryColor),
          ),
        ),
      ),
    );
  }
}
