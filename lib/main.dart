import 'package:first_flutter_app/secondDetail.dart';
import 'package:first_flutter_app/subDetail.dart';
import 'package:first_flutter_app/thirdPage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'sub/firstPage.dart';
import 'sub/secondPage.dart';
import './animalItem.dart';
import './cupertinoMain.dart';
import 'largeFileMain.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'fileApp.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FileApp(),
    );
  }
}

class FirstPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _FirstPage();
}

class _FirstPage extends State<FirstPage>{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('sub page main'),
      ),
      body: Container(
        child: Center(
          child: Text('첫 번째 페이지'),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.of(context).pushNamed('/second');
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class SecondPage extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('Second Page'),
      ),
      body: Container(
        child: Center(
          child: ElevatedButton(
            onPressed: (){
              Navigator.of(context).pop(); //지금 페이지 종료
            },
            child: Text('돌아가기'),
          ),
        ),
      )
    );
  }
}

class HttpApp extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _HttpApp();
}

class _HttpApp extends State<HttpApp>{
  String result = '';
  List? data;
  TextEditingController? _editingController;
  ScrollController? _scrollController;
  int page = 1;

  @override
  void initState(){
    super.initState();
    data = new List.empty(growable: true);
    _editingController = new TextEditingController();
    _scrollController = new ScrollController();

    _scrollController!.addListener(() {
      if(_scrollController!.offset >= _scrollController!.position.maxScrollExtent && !_scrollController!.position.outOfRange){
        print('bottom');
        page++;
        getJSONData();
      }
    });
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller:_editingController,
          style: TextStyle(color : Colors.white),
          keyboardType: TextInputType.text,
          decoration: InputDecoration(hintText: '검색어를 입력하세요.'),
        ),
      ),
      body: Container(
        child: Center(
          child: data!.length==0
              ? Text(
                '데이터가 없습니다.',
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.center)
              : ListView.builder(
                  itemBuilder:(context, index) {
                    return Card(
                      child: Container(
                        child: Row(
                          children: <Widget>[
                            Image.network(
                              data![index]['thumbnail'],
                              height: 100,
                              width:100,
                              fit: BoxFit.contain,
                            ),
                            Column(
                              children: <Widget>[
                                Container(
                                  width:MediaQuery.of(context).size.width - 150,
                                  child: Text(
                                    data![index]['title'].toString(),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Text('저자 : ${data![index]['authors'].toString()}'),
                                Text('가격 : ${data![index]['sale_price'].toString()}'),
                                Text('판매중 : ${data![index]['status'].toString()}'),
                              ],
                            ),
                          ],
                          mainAxisAlignment: MainAxisAlignment.start,
                        )
                      ),
                    );
                  },
              itemCount: data!.length,
              controller: _scrollController,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          page = 1;
          data!.clear();
          getJSONData();
        },
        child: Icon(Icons.file_download),
      ),
    );
  }

  Future<String> getJSONData() async{
    var url = 'https://dapi.kakao.com/v3/search/book?target=title&page=$page&query=${_editingController!.value.text}';
    var response = await http.get(Uri.parse(url), headers:{"Authorization":"KakaoAK ea995363d3083668e2cdde08cfe0927b"});

    setState((){
      var dataConvertedToJSON = json.decode(response.body);
      List result = dataConvertedToJSON['documents'];
      data!.addAll(result);
    });
    return response.body;

  }
}

class WidgetApp extends StatefulWidget{
  @override
  _WidgetExampleState createState() => _WidgetExampleState();
}

class _WidgetExampleState extends State<WidgetApp>{
  String sum = '';
  TextEditingController value1 = TextEditingController();
  TextEditingController value2 = TextEditingController();
  List _buttonList = ['더하기','빼기','곱하기','나누기'];
  List<DropdownMenuItem<String>> _dropDownMenuItems = new List.empty(growable: true);
  String? _buttonText;

  @override
  void initState(){
    super.initState();
    for(var item in _buttonList){
      _dropDownMenuItems.add(DropdownMenuItem(value: item, child:Text(item)));
    }
    _buttonText = _dropDownMenuItems[0].value;
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('Widget Example'),
      ),
      body: Container(
        child: Center(
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(15),
                child: Text('flutter'),
              ),
              Padding(
                padding: EdgeInsets.only(left: 20, right: 20),
                child:  TextField(keyboardType: TextInputType.number, controller:value1),
              ),
              Padding(
                padding: EdgeInsets.only(left:20, right: 20),
                child: TextField(keyboardType: TextInputType.number, controller:value2),
              ),
              Padding(
                padding: EdgeInsets.all(15),
                child: ElevatedButton(
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.add),
                        Text(_buttonText!)
                      ],
                    ),
                    style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.amber)),
                    onPressed: (){
                      setState((){
                        var value1Int = double.parse(value1.value.text);
                        var value2Int = double.parse(value2.value.text);
                        var result;
                        if(_buttonText == '더하기'){
                          result = value1Int + value2Int;
                        }else if(_buttonText == '빼기'){
                          result = value1Int - value2Int;
                        }else if(_buttonText == '곱하기'){
                          result = value1Int * value2Int;
                        }else {
                          result = value1Int / value2Int;
                        }
                        sum = '$result';
                      });
                    }
                ),
              ),
              Padding(
                padding: EdgeInsets.all(15),
                child: Text(
                  '결과 : $sum',
                  style: TextStyle(fontSize: 20),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(15),
                child: DropdownButton(items: _dropDownMenuItems, onChanged: (String? value){
                  setState((){
                    _buttonText = value;
                  });
                }, value: _buttonText,),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
      _setData(_counter);
    });
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter'
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }

  void _setData(int value) async {
    var key = "count";
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setInt(key, value);
  }

  void _loadData() async {
    var key = "count";
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      var value = pref.getInt(key);
      if (value == null) {
        _counter = 0;
      } else {
        _counter = value;
      }
    });
  }

  /*TabController? controller;
  List<Animal> animalList = new List.empty(growable:true);

  @override
  void initState(){
    super.initState();
    controller = TabController(length:2, vsync: this);

    animalList.add(Animal(animalName:"벌", kind:"곤충", imagePath: "repo/images/bee.png"));
    animalList.add(Animal(animalName:"고양이", kind:"포유류", imagePath: "repo/images/cat.png"));
    animalList.add(Animal(animalName:"젖소", kind:"포유류", imagePath: "repo/images/cow.png"));
    animalList.add(Animal(animalName:"강아지", kind:"포유류", imagePath: "repo/images/dog.png"));
    animalList.add(Animal(animalName:"여우", kind:"포유류", imagePath: "repo/images/fox.png"));
    animalList.add(Animal(animalName:"원숭이", kind:"영장류", imagePath: "repo/images/monkey.png"));
    animalList.add(Animal(animalName:"돼지", kind:"포유류", imagePath: "repo/images/pig.png"));
    animalList.add(Animal(animalName:"늑대", kind:"포유류", imagePath: "repo/images/wolf.png"));
  }

  @override
  void dispos(){
    controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title:Text('ListView Example'),
      ) ,
        body: TabBarView(
        children:<Widget>[
          FirstApp(list:animalList),
          SecondApp(list:animalList)],
        controller: controller,
      ),
        bottomNavigationBar: TabBar(tabs:<Tab>[
        Tab(icon: Icon(Icons.looks_one, color:Colors.blue),),
        Tab(icon: Icon(Icons.looks_two, color:Colors.blue),),
      ], controller: controller,
      )
    );*/
}
