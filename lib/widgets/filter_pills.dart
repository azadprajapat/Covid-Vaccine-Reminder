import 'package:covid_vaccine_notifier/services/Language_Update/AppTranslation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget filter_pills(text, bool is_active,context) {
  return Container(
    width: 80,
    padding: EdgeInsets.symmetric( vertical: 8),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Theme.of(context).primaryColor),
        color: !is_active ? Colors.white : Theme.of(context).primaryColor),
    child: Center(
      child: Text(
        AppTranslations.of(context).text(text),
        style: TextStyle(
            fontSize: 12, color: is_active ? Colors.white : Theme.of(context).primaryColor),
      ),
    ),
  );
}
