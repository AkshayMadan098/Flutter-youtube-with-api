
import 'package:flutter/material.dart';
import 'package:ui/subscription.dart';
import 'home.dart';
import 'inbox.dart';
import 'library.dart';
import 'trending.dart';
import 'subscription.dart';


void main() => runApp(MyApp());
class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'YouTube',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'YouTube'),
    );
  }
}
class MyHomePage extends StatefulWidget {

  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;  
  @override
  
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex =0;


 List<Widget> _widgetOptions = <Widget>[
      Home(),
      Trending(),
      Subscription(),
      NotificationsScreen(),
      LibraryScreen(),
];
  
  
  @override
  Widget build(BuildContext context) {
    

  _onTapped(int index) {
    setState(() {
      _currentIndex = index;
     
      
    });
  }
 
    return Scaffold(
      appBar: AppBar(
       backgroundColor: Colors.white,
        title: Container(
          width: 100.0,
          height: 45.0,
          child: Image.network("https://darkeandtaylor.co.uk/wp/wp-content/uploads/2018/09/youtube-logo-png-transparent-image-e1537456990695.png"),

        ),
        actions: <Widget>
        [
          IconButton
          (
            icon: Icon(Icons.videocam,color: Colors.black54),
            onPressed: (){},
          ),
          IconButton
          (
            icon: Icon(Icons.search,color: Colors.black54),
            onPressed: (){},
          ),
         
         IconButton
          (
            icon: Icon(Icons.account_circle,color: Colors.black54),
            onPressed: (){},
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        fixedColor: Colors.red,
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap:   _onTapped,
        items: 
      [
        
        BottomNavigationBarItem
        (
          icon:Icon(Icons.home) ,
          title: Text("Home")
          
        ),
         BottomNavigationBarItem
         (
          icon:Icon(Icons.trending_up) ,
          title: Text("Trending")
         ),
         BottomNavigationBarItem
         (
          icon:Icon(Icons.subscriptions) ,
          title: Text("Subscription")
         ),
         BottomNavigationBarItem(
          icon:Icon(Icons.mail) ,
          title: Text("Inbox")
        ),
        BottomNavigationBarItem(
          icon:Icon(Icons.library_music) ,
          title: Text("Library")
        )
      ]
      ,),
      body:
 
     _widgetOptions.elementAt(_currentIndex)
  

    );
  }
 
}