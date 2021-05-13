import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget filter_pills(text, bool is_active,context) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: Theme.of(context).primaryColor),
        color: !is_active ? Colors.white : Theme.of(context).primaryColor),
    child: Center(
      child: Text(
        text,
        style: TextStyle(
            fontSize: 12, color: is_active ? Colors.white : Theme.of(context).primaryColor),
      ),
    ),
  );
}
