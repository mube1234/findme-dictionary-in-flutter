import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dictionary',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FirstPage(),
    );
  }
}

class MyHomePage extends StatefulWidget {

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _url ="https://owlbot.info/api/v4/dictionary/";
  String _token ="ca9512e3be26db77aeabb315c21662faf632c732";
  TextEditingController _controller = TextEditingController();

  StreamController _streamController;
  Stream _stream;

  _search() async {
      if(_controller.text == null || _controller.text.length == 0)
      {
        _streamController.add(null);
        return;
      }
      _streamController.add("waiting");
      final response = await http.get(Uri.parse(_url + _controller.text.trim()),
          headers: {'Authorization': 'Token ' + _token});
      if (response.body.contains('[{"message":"No definition :("}]')) {
        _streamController.add('NoData');
        return;
      } else {
        _streamController.add(json.decode(response.body));
        return;
      }



      // _streamController.add(json.decode(response.body));
  }
  @override
  void initState() {
    super.initState();
    _streamController = StreamController();
    _stream = _streamController.stream;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Find Me Dictionary")),
        backgroundColor: Colors.deepPurple,
        bottom: PreferredSize(
        preferredSize: Size.fromHeight(48.0),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(left: 12.0,bottom: 8.0,right: 5.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20)
                  ),
                  child: TextFormField(
                    onTap: (){

                    },
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: "Search for a word",
                      contentPadding: const EdgeInsets.only(left: 25.0),
                      border: InputBorder.none

                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(right: 10.0),
                child: IconButton(


                    icon: Icon(Icons.search,color: Colors.white,),
                    onPressed: (){
                      _search();
                    }
                    ),
              )
            ],
          ),
      ),
      ),
      body:Container(
        margin: EdgeInsets.all(10.0),
        child: StreamBuilder(
          stream: _stream,
          builder: (BuildContext abc, AsyncSnapshot snapshot){
              if(snapshot.data == null)
              {
                return Center(
                  child: Text("Enter a word you want to search"),
                );
              }
              if(snapshot.data == "waiting")
                {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              if (snapshot.data == 'NoData') {
                return Center(
                  child: Text(
                    'No Defination for this word',
                    // style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                );
              }
              return ListView.builder(
                  itemCount: snapshot.data["definitions"].length,
                  itemBuilder: (BuildContext context, int i)
                  {
                    return ListBody(
                      children: [
                        Container(
                          color: Colors.black12,
                          child: ListTile(
                            leading: snapshot.data['definitions'][i]['image_url'] ==
                                null
                                ? CircleAvatar(
                              backgroundColor: Colors.deepPurple,
                              child: Icon(Icons.hdr_strong_sharp),

                            )
                                : CircleAvatar(
                              backgroundImage: NetworkImage(snapshot
                                  .data['definitions'][i]['image_url']),

                            ),
                            title: Text(_controller.text.trim() +
                                "  (" +
                                snapshot.data['definitions'][i]['type'] +
                                ")",),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(14.0),
                          child: Text(snapshot.data["definitions"][i]["definition"]),
                        )
                      ],
                    );

                  }
              );
          },
        ),
      )

        //
       // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class FirstPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
      child:Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            child: Center(
              child: Text("Find Me Dictionary",style: TextStyle(
                color: Colors.indigo,
                fontWeight: FontWeight.bold,
                fontSize: 30
              ),),
            ),
          ),
          Container(
           height: 200,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/search.png"),
                    fit: BoxFit.fitHeight
                )
            ),
          ),
          SizedBox(
            width: 270,
            height: 60,
            child: RaisedButton(
              padding: EdgeInsets.symmetric(vertical: 8,horizontal: 30),
              onPressed: ()
              {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>MyHomePage()));
              },
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
              color: Colors.deepPurple,
              child: Text("Start",style: TextStyle(color: Colors.white,fontSize: 18.5),)
              ,),
          ),
          SizedBox(
            height: 16,
          ),
          SizedBox(
            width: 270,
            height: 60,
            child: RaisedButton(
              padding: EdgeInsets.symmetric(vertical: 8,horizontal: 30),
              onPressed: (){
                // Navigator.push(context, MaterialPageRoute(builder: (context) => SecondRoute()));
              },
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
              color: Colors.grey,
              child: Text("About",style: TextStyle(color: Colors.white,fontSize: 18.5),)
              ,),
          ),
          SizedBox(
            height: 16,
          ),
          SizedBox(
            width: 270,
            height: 60,
            child: RaisedButton(
              padding: EdgeInsets.symmetric(vertical: 8,horizontal: 30),
              onPressed: (){
                // return ExitButton();
              },
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15))),
              color: Colors.redAccent,
              child: Text("Exit",style: TextStyle(color: Colors.white,fontSize: 18.5),)
              ,),
          ),
        ],
      )),
    );
  }
}
