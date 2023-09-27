import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_meet/main.dart';
import 'package:intl/intl.dart';

import 'generated/l10n.dart';

class BaseSc extends StatefulWidget {
  const BaseSc({super.key});

  @override
  State<BaseSc> createState() => _BaseScState();
}

class _BaseScState extends State<BaseSc> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(title: Text(S.of(context).baseHome),),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              S.of(context).youhavepushedthebuttonthismanytime,
            ),

          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed:() async{

          if(Intl.getCurrentLocale()=="ar")
            {
              MyApp.changeLocale(context,S.delegate.supportedLocales[0]);
            }else
              {
                MyApp.changeLocale(context,S.delegate.supportedLocales[1]);
              }




        },
        tooltip: S.of(context).increment,
        child: const Icon(Icons.add),
      ),
    );
  }
}
