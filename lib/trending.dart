import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ui/video.dart';
class Trending extends StatefulWidget {
  @override
  _TrendingState createState() => _TrendingState();
}

class _TrendingState extends State<Trending> {
  @override
  void initState() {
    getjsondata();
    // TODO: implement initState
    super.initState();
  }

var url="http://userapi.tk/youtube/trending/";
var ddata;

Future<String> getjsondata() async {
  var response=await http.get(Uri.encodeFull(url));

  setState(() {
    var converdata=json.decode(response.body);
    ddata=converdata;
    print(ddata);
   
  });
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: 
          ListView.builder(
      itemCount: ddata.length,
      itemBuilder: (context,i) =>
             
        GestureDetector(
          onTap: (){
            print(ddata[i]);
 Navigator.push(
    context,
    MaterialPageRoute(builder: (context) =>  VideoPlayerScreen(ddata[i]),
  ));
},
                  child: new  Column(
                    
            children: <Widget>[
              
              
            
             Image.network(ddata[i]['ThumbmnilURL']),
             
              SizedBox(
                height: 5,
              ),
              ListTile(
                leading: CircleAvatar(
                   backgroundImage: NetworkImage(ddata[i]['ProfileiconURL']),
                ),
                title: 
                Text(
                 ddata[i]['Title'],
                 
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    
                  ),
                  
                ),
                
                subtitle: Text(ddata[i]['Name']+" . " +ddata[i]['Views'] +"Views " +ddata[i]['Day']),
                
              ),
              SizedBox(
                height: 20,
              )
            ],
          ),
        ),
      
    )
        
      
    );
  }
  
}