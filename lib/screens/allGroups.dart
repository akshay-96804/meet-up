import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GroupPage extends StatelessWidget {
  // const GroupScreen({ Key? key }) : super(key: key);
  TextEditingController _groupName = TextEditingController();
  CollectionReference _collectionReference =
      FirebaseFirestore.instance.collection('users');
  TextEditingController memberController = TextEditingController();

  addGroup() {
    _collectionReference
        .doc(FirebaseAuth.instance.currentUser.uid)
        .collection('groups')
        .doc()
        .set({
      'user': FirebaseAuth.instance.currentUser.email,
      'group_name': _groupName.text,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(14.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("YOUR GROUPS",style: TextStyle(fontSize: 20.0),)
            ],
          ),
        ),
        Expanded(
          child: Container(
            child: StreamBuilder(
              builder: (context, snapshot) {
                return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .doc(FirebaseAuth.instance.currentUser.uid)
                        .collection('groups')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.data.size > 0) {
                        return ListView.builder(
                            itemCount: snapshot.data.docs.length,
                            itemBuilder: (context, index) {
                              return ExpansionTile(
                                title: Text(snapshot.data.docs[index]
                                    .data()['group_name'],style: TextStyle(fontSize: 18.0),),
                                children: [
                                  TextField(
                                    controller: memberController,
                                    decoration: InputDecoration(
                                        contentPadding: EdgeInsets.all(10.0),
                                        hintText: 'Enter Members in This Group',
                                        suffix: GestureDetector(
                                          onTap: () async {
                                            FirebaseFirestore.instance
                                                .collection('users')
                                                .doc(FirebaseAuth
                                                    .instance.currentUser.uid)
                                                .collection('groups')
                                                .doc(snapshot
                                                    .data.docs[index].id)
                                                .collection('members')
                                                .add({
                                              'name': memberController.text
                                            });
                                            memberController.clear();
                                          },
                                          child: Container(
                                            padding: EdgeInsets.all(10.0),
                                            color: Colors.amberAccent,
                                            margin: EdgeInsets.only(right: 8.0),
                                            child: Text('Add'),
                                          ),
                                        )),
                                  ),
                                  SizedBox(height: 12.0),
                                  Container(
                                      padding: EdgeInsets.all(12.0),
                                      height: 100.0,
                                      child: StreamBuilder<
                                          QuerySnapshot<Map<String, dynamic>>>(
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return Center();
                                          }
                                          return ListView.builder(
                                              itemCount:
                                                  snapshot.data.docs.length,
                                              itemBuilder: (context, index) {
                                                return Text(snapshot
                                                    .data.docs[index]
                                                    .data()['name']);
                                              });
                                        },
                                        stream: FirebaseFirestore.instance
                                            .collection('users')
                                            .doc(FirebaseAuth
                                                .instance.currentUser.uid)
                                            .collection('groups')
                                            .doc(snapshot.data.docs[index].id)
                                            .collection('members')
                                            .orderBy('name')
                                            .snapshots(),
                                      ))
                                ],
                              );
                            });
                      }
                      return Center(
                        child: Text("No Groups added"),
                      );
                    });
              },
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('Enter Name Of The Group'),
                    content: TextField(
                      controller: _groupName,
                    ),
                    actions: [
                      MaterialButton(
                          onPressed: () {
                            addGroup();
                            Navigator.pop(context);
                          },
                          child: Text("Save")),
                      MaterialButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text("Cancel"),
                      ),
                    ],
                  );
                });
          },
          child: Container(
            alignment: Alignment.center,
            width: double.infinity,
            decoration: BoxDecoration(
                shape: BoxShape.rectangle, color: Colors.blueAccent),
            padding: EdgeInsets.all(18.0),
            margin: EdgeInsets.symmetric(horizontal: 12.0, vertical: 14.0),
            child: Text(
              "Add a Group",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        )
      ],
    );
  }
}


/*

 */

