import 'package:flutter/material.dart';
import 'package:meet_up/screens/HomePage.dart';
import 'package:meet_up/screens/allGroups.dart';
import 'package:meet_up/screens/createEventScreen.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  int _selectedIndex = 0;

  List<Map<String, dynamic>> _pages = [
    {'title': 'Home', 'screen': HomePage()},
    {'title': 'Create', 'screen': CreateMeet()},
    {'title': 'Groups', 'screen': GroupPage()}
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Meetify"),
        actions: [
          IconButton(icon: Icon(Icons.logout), onPressed: (){
            showDialog(context: context, builder: (context){
              return AlertDialog(
                title: Text("Are You Sure ?"),
                actions: [
                  MaterialButton(onPressed: (){

                  },child: Text("Yes"),),
                  MaterialButton(onPressed: (){
                    Navigator.pop(context);
                  },child: Text("No")),
                ],
              );
            });
          })
        ],
      ),
      body: _pages[_selectedIndex]['screen'],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(title:Text('Home'),icon: Icon(Icons.home)),
          BottomNavigationBarItem(title:Text('Create Meet'),icon: Icon(Icons.add)),
          BottomNavigationBarItem(title:Text('Groups'),icon: Icon(Icons.group_add_sharp)),
        ],
      ),
    );
  }
}
