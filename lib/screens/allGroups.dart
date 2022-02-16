import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meet_up/models/groupModel.dart';

class AllGroupsScreen extends StatefulWidget {
  // const AllGroupsScreen({ Key? key }) : super(key: key);

  @override
  _AllGroupsScreenState createState() => _AllGroupsScreenState();
}

class _AllGroupsScreenState extends State<AllGroupsScreen> {
  CollectionReference groups = FirebaseFirestore.instance.collection('groups');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ALl Groups',style: GoogleFonts.poppins()),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: groups.snapshots(),
        builder: (context,snapshot){
            if(snapshot.hasData){
              if(snapshot.data.docs.length>0){
                return ListView.separated(
                  shrinkWrap: true,
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context,index){
                    Map<String,dynamic> groupData = snapshot.data.docs[index].data();
                    GroupModel groupModel = GroupModel.fromJSON(groupData);
                    
                    return ListTile(
                      title: Text(groupModel.title,style: GoogleFonts.poppins(
                        color: Colors.redAccent,
                        fontSize: 18.0
                      )),
                      subtitle: ListView.builder(
                        shrinkWrap: true,
                        itemCount: groupModel.emailList.length,
                        itemBuilder: (context,index){
                           return Text(groupModel.emailList[index],style: GoogleFonts.poppins(),);    
                      }),
                    );
                  }, 
                  separatorBuilder: (context,int){
                    return Divider();
                  }, 
                  );
               }
              else{
                return Container(
                    child: Center(
                      child: Text("No Groups"),
                    ));
              }
            }
            if(snapshot.connectionState==ConnectionState.waiting){
              return Center(
                child: CircularProgressIndicator(),
              ); 
            }
            else{
              return Text('Something Went Wrong');
            } 
        }),
      );
  }
}
