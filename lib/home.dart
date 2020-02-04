import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ui/video.dart';
class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  
@override
  void initState() {
    getjsondata();
    // TODO: implement initState
    super.initState();
  }

var url="http://userapi.tk/youtube/";
var data;

Future<String> getjsondata() async {
  var response=await http.get(Uri.encodeFull(url));

  setState(() {
    var converdata=json.decode(response.body);
    data=converdata;
    print(data);
   
  });
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _body(),
    );
  }
  Widget _body() {
   
   
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context,i) =>
             
        GestureDetector(
          onTap: (){
            print(data[i]);
 Navigator.push(
    context,
    MaterialPageRoute(builder: (context) =>  VideoPlayerScreen(data[i]),
  ));
},
                  child: new  Column(
                    
            children: <Widget>[
              
              
            
             Image.network(data[i]['ThumbmnilURL']),
             
              SizedBox(
                height: 5,
              ),
              ListTile(
                leading: CircleAvatar(
                   backgroundImage: NetworkImage(data[i]['ProfileiconURL']),
                ),
                title: 
                Text(
                 data[i]['Title'],
                 
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    
                  ),
                  
                ),
                
                subtitle: Text(data[i]['Name']+" . " +data[i]['Views'] +"Views " +data[i]['Day']),
                
              ),
              SizedBox(
                height: 20,
              )
            ],
          ),
        ),
      
    );
  }
}