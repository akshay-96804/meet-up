import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meet_up/screens/allEvents.dart';
import 'package:meet_up/screens/allGroups.dart';
import 'package:meet_up/screens/createGroupScreen.dart';
import 'package:meet_up/screens/createEventScreen.dart';

class LandingPage extends StatelessWidget {
  // const LandingPage({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text('MeetUp',style: GoogleFonts.poppins(
            fontSize: 30.0,
            fontWeight: FontWeight.bold
          ),),
           Container(
              height: MediaQuery.of(context).size.height*0.2,
              child: SvgPicture.asset('assets/img.svg')
            ),
          Column(
            children: [
              GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context){
                    return createEvent(); 
                  }));
                },
                child: Container(
                  padding: EdgeInsets.all(12.0),
            alignment: Alignment.center,
            color: Colors.redAccent,
            margin: EdgeInsets.symmetric(horizontal: 15.0,vertical: 5.0),
            width: double.infinity,
            child: Text('Create A New Event',style: GoogleFonts.poppins(
                color: Colors.white
            ),),
          ),
              ),
          GestureDetector(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context){
                return AllMeetsScreen(); 
              }));
            },
            child: Container(
              padding: EdgeInsets.all(12.0),
              alignment: Alignment.center,
              color: Colors.redAccent,
              margin: EdgeInsets.symmetric(horizontal: 15.0,vertical: 5.0),
              width: double.infinity,
              child: Text('View All Events',style: GoogleFonts.poppins(
                color: Colors.white
              ),),
            ),
          ),
          GestureDetector(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context){
                return CreateGroup(); 
              }));
            },
            child: Container(
              padding: EdgeInsets.all(12.0),
              alignment: Alignment.center,
              color: Colors.redAccent,
              margin: EdgeInsets.symmetric(horizontal: 15.0,vertical: 5.0),
              width: double.infinity,
              child: Text('Create A New Group',style: GoogleFonts.poppins(
                color: Colors.white
              ),),
            ),
          ),
          GestureDetector(
            onTap: (){
               Navigator.push(context, MaterialPageRoute(builder: (context){
                return AllGroupsScreen(); 
              }));
            },
            child: Container(
              padding: EdgeInsets.all(12.0),
              alignment: Alignment.center,
              color: Colors.redAccent,
              margin: EdgeInsets.symmetric(horizontal: 15.0,vertical: 5.0),
              width: double.infinity,
              child: Text('View All Groups',style: GoogleFonts.poppins(
                color: Colors.white
              ),),
            ),
          )
            ],
          )
        ],
      ),
    );
  }
}