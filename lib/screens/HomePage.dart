import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';


class HomePage extends StatelessWidget {
  // const LandingPage({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser.uid)
          .collection('meetings')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.data.size > 0) {
          // DateTime startTime = snap

          //               DateTime endTime =
          //                   DateTime.fromMillisecondsSinceEpoch(
          //                       event.endTimeSinceEpoch)
          return ListView.builder(
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, index) {
                DateTime startTime =
                    DateTime.fromMillisecondsSinceEpoch(snapshot.data.docs[index].data()['startTimeSinceepoch']);
                DateTime endTime = DateTime.fromMillisecondsSinceEpoch(snapshot.data.docs[index].data()['endTimeSinceEpoch']);

                String startTimeString = DateFormat.jm().format(startTime);
                String endTimeString = DateFormat.jm().format(endTime);
                String dateString = DateFormat.yMMMMd().format(startTime);

                return Container(
                  
                  padding: EdgeInsets.all(12.0),
                  child: Card(
                                              color: Colors.blueAccent,

                    elevation: 2.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(snapshot.data.docs[index].data()['title'],style: TextStyle(fontSize: 22.0,color: Colors.white)),
                            SizedBox(height: 5.0),
                            Text(snapshot.data.docs[index].data()['description'],style: TextStyle(fontSize: 16.0,color: Colors.white)),
                                                        SizedBox(height: 5.0),
                            // Divider(
                            //   thickness: 5.0,
                            //   height: 10.0,
                            //   color: Colors.white,
                            // ),
                            SizedBox(height: 10.0),
                            Text(dateString,style: TextStyle(fontSize: 16.0,color: Colors.white)),
                                                        SizedBox(height: 5.0),
                                                                                    SizedBox(height: 10.0),

                            Text(startTimeString,style: TextStyle(fontSize: 16.0,color: Colors.white)),
                            Text('to',style: TextStyle(fontSize: 16.0,color: Colors.white)),
                            Text(endTimeString,style: TextStyle(fontSize: 16.0,color: Colors.white)),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () async{
                          print(snapshot.data.docs[index].data()['link']);
                          await launch(snapshot.data.docs[index].data()['link']);
                        },
                        child: Container(
                          margin: EdgeInsets.only(right: 8.0),
                          padding: EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 5.0,
                              color: Colors.lightBlueAccent,
                              // style: 
                            ),
                            color: Colors.blueAccent,
                            borderRadius: BorderRadius.circular(12.0)
                          ),
                          child: Text("Join Now",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
                          )),
                      )
                    ],
                  )),
                );
              });
        }
        return Center(child: Text("No Meetings scheduled"));
      },
    ));
  }
}
