import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ui/video.dart';
class Subscription extends StatefulWidget {
  @override
  _SubscriptionState createState() => _SubscriptionState();
}

class _SubscriptionState extends State<Subscription> {
  @override
  void initState() {
    getjsondata();
    // TODO: implement initState
    super.initState();
  }

var url="http://userapi.tk/youtube/subscription/";
var cdata;

Future<String> getjsondata() async {
  var response=await http.get(Uri.encodeFull(url));

  setState(() {
    var converdata=json.decode(response.body);
    cdata=converdata;
    print(cdata);
   
  });
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: 
          ListView.builder(
      itemCount: cdata.length,
      itemBuilder: (context,i) =>
             
        GestureDetector(
          onTap: (){
            print(cdata[i]);
 Navigator.push(
    context,
    MaterialPageRoute(builder: (context) =>  VideoPlayerScreen(cdata[i]),
  ));
},
                  child: new  Column(
                    
            children: <Widget>[
              
              
            
             Image.network(cdata[i]['ThumbmnilURL']),
             
              SizedBox(
                height: 5,
              ),
              ListTile(
                leading: CircleAvatar(
                   backgroundImage: NetworkImage(cdata[i]['ProfileiconURL']),
                ),
                title: 
                Text(
                 cdata[i]['Title'],
                 
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    
                  ),
                  
                ),
                
                subtitle: Text(cdata[i]['Name']+" . " +cdata[i]['Views'] +"Views " +cdata[i]['Day']),
                
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