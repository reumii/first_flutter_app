import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'main.dart';

class IntroPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _IntroPage();
}

class _IntroPage extends State<IntroPage>{
  Widget logo = Icon(
    Icons.info,
    size:50,
  );

  @override
  void initState(){
    super.initState();
    initData();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold();
  }

  void initData() async{

  }
}