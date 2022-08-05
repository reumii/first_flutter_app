import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FileApp extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _FileApp();
}

class _FileApp extends State<FileApp>{
  int _count = 0;

  Future<List<String>> readListFile() async {
    List<String> itemList = new List.empty(growable: true);
    TextEditingController controller = new TextEditingController();

    var key = 'first';
    SharedPreferences pref = await SharedPreferences.getInstance();
    bool? firstCheck = pref.getBool(key);
    var dir = await getApplicationDocumentsDirectory();
    bool fileExist = await File(dir.path + '/fruit.txt').exists();

    if(firstCheck == null || firstCheck == false || fileExist == false){
      pref.setBool(key, true);
      var file = await DefaultAssetBundle.of(context).loadString('repo/fruit.txt');
      File(dir.path + '/fruit.txt').writeAsStringSync(file);

      var array = file.split('\n');
      for(var item in array){
        print(item);
        itemList.add(item);
      }
      return itemList;
    }else{
      var file = await File(dir.path + '/fruit.txt').readAsString();
      var array = file.split('\n');
      for(var item in array){
        print(item);
        itemList.add(item);
      }
      return itemList;
    }
  }

  @override
  void initState(){
    super.initState();
    readCountFile();
    initData();
  }

  void initData() async {
    var result = await readListFile();
    setState((){
      itemList.addAll(result);
    });
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('File Example'),
      ),
      body: Container(
        child: Center(
          child: Text(
            '$_count',
            style: TextStyle(fontSize: 40),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          setState((){
            _count++;
          });
          writeCountFile(_count);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void writeCountFile(int count) async{
    var dir = await getApplicationDocumentsDirectory();
    File(dir.path + '/count.txt').writeAsStringSync(count.toString());
  }

  void readCountFile() async{
    try{
      var dir = await getApplicationDocumentsDirectory();
      var file = await File(dir.path + '/count.txt').readAsString();
      print(file);
      setState((){
        _count = int.parse(file);
      });
    } catch(e){
      print(e.toString());
    }
  }
}