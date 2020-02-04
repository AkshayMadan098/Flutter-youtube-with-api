import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:ui/video.dart';
import 'package:http/http.dart' as http;
class LibraryScreen extends StatefulWidget {
  @override
  _LibraryScreenState createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
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
    return ListView(
      children: <Widget>[
        _buildRecent(),
        _buildPersonal(context),
        _buildOffline(),
        _buildPlaylist(context),
      ],
    );
  }

  BoxDecoration _buildBottomBorder() => BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 1.0, color: Colors.grey),
        ),
      );

  Widget _buildRecent() {
    return Container(
      height: 205.0,
      decoration: _buildBottomBorder(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(top: 16.0, left: 16.0),
            child: Text("Recent"),
          ),
        
        ],
      ),
    );
  }

  Widget _buildPersonal(BuildContext context) {
    List<Map> items = [
      {"name": "History", "icon": Icon(Icons.history)},
      {"name": "My Videos", "icon": Icon(Icons.video_library)},
      {
        "name": "Watch Later",
        "icon": Icon(Icons.watch_later),
        "extra": "25 unwatched videos"
      },
    ];

    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: _buildBottomBorder(),
      child: Column(
        children: items
            .map((i) => ListTile(
                  leading: i["icon"],
                  title: i["extra"] == null
                      ? Text(i["name"])
                      : Row(
                          children: <Widget>[
                            Text(i["name"]),
                            Container(
                              margin: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                i["extra"],
                                style: Theme.of(context).textTheme.caption,
                              ),
                            ),
                          ],
                        ),
                ))
            .toList(),
      ),
    );
  }

  Widget _buildOffline() {
    return Container(
      decoration: _buildBottomBorder(),
      padding: const EdgeInsets.only(top: 16.0, left: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("Available offline"),
          ListTile(
            leading: Icon(Icons.file_download),
            title: Text("Downloads"),
            subtitle: Text("20 videos"),
            trailing: Icon(
              Icons.check_circle,
              color: Colors.blue[700],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildPlaylist(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 16.0, left: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Text("Playlist"),
              DropdownButton(
                style: Theme.of(context).textTheme.body1,
                items: [
                  DropdownMenuItem(child: Text("(Recently added)")),
                  DropdownMenuItem(child: Text("(A - Z)")),
                ],
                onChanged: null,
              ),
            ],
          ),
          ListTile(
            leading: Icon(Icons.thumb_up),
            title: Text("Liked videos"),
            subtitle: Text("248 videos"),
          ),
          ListTile(
            leading: Icon(Icons.account_circle),
            title: Text("Naija Music Videos 2018"),
            subtitle: Text("Fatyellowbaby . 1509 videos"),
          ),
        ],
      ),
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