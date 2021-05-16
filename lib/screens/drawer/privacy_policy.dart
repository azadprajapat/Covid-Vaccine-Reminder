import 'package:covid_vaccine_notifier/screens/HomePage/home_page.dart';
import 'package:covid_vaccine_notifier/services/url_services.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
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
class Privacy_Policy extends StatefulWidget {
  @override
  _Privacy_PolicyState createState() => _Privacy_PolicyState();
}

class _Privacy_PolicyState extends State<Privacy_Policy> {
  final flutterWebviewPlugin = new FlutterWebviewPlugin();
  @override
  void dispose() {
    FlutterWebviewPlugin().dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{
        await  flutterWebviewPlugin.close();
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_)=>HomePage()), (route) => false);
      },
      child: SafeArea(
        child: WebviewScaffold(
            url: Url_Services.privacy_policy,
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


