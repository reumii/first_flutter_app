import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'sub/firstPage.dart';
import 'sub/secondPage.dart';
import './animalItem.dart';
import './cupertinoMain.dart';
import 'largeFileMain.dart';
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      home: LargeFileMain(),
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
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {
  TabController? controller;
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
    );
  }
}
