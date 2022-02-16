import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meet_up/models/eventInfo.dart';
import 'package:meet_up/models/groupModel.dart';

class FirebaseAdd{

  addEvent(EventModel event) async{
    CollectionReference events = FirebaseFirestore.instance.collection('events');
    await events.doc(event.id).set(event.toJson(event)).whenComplete(() {
      print("EVENT SUCCESSFULLY ADDED TO FIRESTORE");
    }).catchError((e){
      print(e);
    });
  }

  addGroup(GroupModel group) async{
    CollectionReference groups = FirebaseFirestore.instance.collection('groups');
    await groups.doc(group.title).set(toJSON(group)).whenComplete(() => {
      print("GROUP ADDED TO FIREBASE SUCCESSFULLY")
    });
  }

  getGroupsNameList(String name){
    List<String> groupNames = [];
    CollectionReference groups = FirebaseFirestore.instance.collection("groups");

    var getDocs = groups.get().then((value){
      var docs = value.docs.map((e) => e.data());

      docs.forEach((element) {
        GroupModel groupModel = GroupModel.fromJSON(element);
        groupNames.add(groupModel.title);
        });
      });

      print(groupNames);
  }

  getGroupsEmailList(String name){
    List<String> groupEmails = [];
    CollectionReference groups = FirebaseFirestore.instance.collection("groups");

    var getDocs = groups.where("title",isEqualTo: name).get().then((value){
      var docs = value.docs.map((e) => e.data());

      docs.forEach((element) {
        GroupModel groupModel = GroupModel.fromJSON(element);
        groupModel.emailList.forEach((element) {
          groupEmails.add(element);
        });
        });
      print(groupEmails);
     });
  }
}