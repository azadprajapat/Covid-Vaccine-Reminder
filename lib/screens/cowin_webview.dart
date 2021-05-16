import 'package:covid_vaccine_notifier/services/url_services.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import '../wrapper.dart';
const kAndroidUserAgent =
    'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/62.0.3202.94 Mobile Safari/537.36';


// ignore: prefer_collection_literals
final Set<JavascriptChannel> jsChannels = [
  JavascriptChannel(
      name: 'Print',
      onMessageReceived: (JavascriptMessage message) {
        print(message.message);
      }),
].toSet();


class Cowin_Web_View extends StatefulWidget {
  @override
  _Cowin_Web_ViewState createState() => _Cowin_Web_ViewState();
}

class _Cowin_Web_ViewState extends State<Cowin_Web_View> {
  final flutterWebviewPlugin = new FlutterWebviewPlugin();


  @override
  void initState() {
    FlutterWebviewPlugin().onUrlChanged.listen((String url) async{
      print("listner active");
      if (url.contains('.pdf')) {
        canLaunch(url) != null ? await launch(url) : throw 'Could not launch $url';
      }
    });
     super.initState();
  }
  @override
  void dispose() {
    FlutterWebviewPlugin().dispose();
     super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return
    WillPopScope(
     onWillPop: ()async{
     await  flutterWebviewPlugin.close();
     Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_)=>Wrapper(isStarted: false,)), (route) => false);
      },
      child: SafeArea(
        child: WebviewScaffold(
            url: Url_Services.covin_web_view,
            javascriptChannels: jsChannels,
            mediaPlaybackRequiresUserGesture: true,
             allowFileURLs: true,
            withZoom: true,
            withLocalStorage: true,
            hidden: true,
            initialChild: Container(
              color: Colors.white,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            )),
      ),
    );
  }
}
