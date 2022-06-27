import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:googleapis/calendar/v3.dart' as calendar;
import 'package:intl/intl.dart';
import 'package:meet_up/utils/calendarEvents.dart';

List<String> grpMembers = [];

class CreateMeet extends StatefulWidget {
  // const GroupScreen({ Key? key }) : super(key: key);
  @override
  _CreateMeetState createState() => _CreateMeetState();
}

class _CreateMeetState extends State<CreateMeet> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController titleController = TextEditingController();
  TextEditingController detailController = TextEditingController();
  TextEditingController orgController = TextEditingController();

  final List<calendar.EventAttendee> attendeesList = [];

  bool _notify = false;
  bool _generate = false;

  @override
  void initState() {
    super.initState();
    grpMembers.clear();
  }

  DateTime date = DateTime.now();
  DateTime selectedDate = DateTime.now();

  TimeOfDay startTime = TimeOfDay.now();
  TimeOfDay endTime = TimeOfDay.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }

    print(selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    final localizations = MaterialLocalizations.of(context);

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Container(
              alignment: Alignment.center,
              width: double.infinity,
              child: Text('Enter Details',
                  style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0)),
            ),
          ),
          SizedBox(height: 12.0),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blueAccent),
                            borderRadius: BorderRadius.circular(10.0),
                            // borderSide: BorderSide.none
                          ),
                          hintText: 'Enter Title'),
                    ),
                    SizedBox(height: 12.0),
                    TextField(
                      controller: detailController,
                      decoration: InputDecoration(
                        hintText: 'Enter Details',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(color: Colors.blueAccent),
                        ),
                      ),
                    ),
                    SizedBox(height: 12.0),
                    TextField(
                      controller: orgController,
                      decoration: InputDecoration(
                        hintText: 'Enter Organisation',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                              color: Colors
                                  .blueAccent), // borderSide: BorderSide.none
                        ),
                      ),
                    ),
                    SizedBox(height: 12.0),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Add Groups',
                          style: TextStyle(
                            fontSize: 20.0,
                          )),
                    ),
                    Container(
                      child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                        stream: FirebaseFirestore.instance
                            .collection('users')
                            .doc(FirebaseAuth.instance.currentUser.uid)
                            .collection('groups')
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else if (snapshot.data.size > 0) {
                            return ListView.builder(
                                shrinkWrap: true,
                                itemCount: snapshot.data.docs.length,
                                itemBuilder: (context, index) {
                                  return Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text(
                                        snapshot.data.docs[index]
                                            .data()['group_name'],
                                        style: TextStyle(
                                            color: Colors.blueAccent,
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Container(
                                        child: IconButton(
                                            icon: Icon(Icons.add,
                                                color: Colors.blueAccent),
                                            onPressed: () async {
                                              QuerySnapshot<
                                                      Map<String, dynamic>>
                                                  queryData =
                                                  await FirebaseFirestore
                                                      .instance
                                                      .collection('users')
                                                      .doc(FirebaseAuth.instance
                                                          .currentUser.uid)
                                                      .collection('groups')
                                                      .doc(snapshot
                                                          .data.docs[index].id)
                                                      .collection('members')
                                                      .get();

                                              queryData.docs.forEach((element) {
                                                calendar.EventAttendee
                                                    newAttendee =
                                                    calendar.EventAttendee();
                                                newAttendee.email =
                                                    element.data()['name'];

                                                attendeesList.add(newAttendee);
                                                // grpMembers.add(element.data()['name']);
                                              });
                                              setState(() {});
                                            }),
                                      )
                                    ],
                                  );
                                });
                          }
                          return Text("No Groups added");
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child:
                          Text("Members :", style: TextStyle(fontSize: 20.0)),
                    ),
                    Container(
                      height: 90.0,
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: attendeesList.length,
                          // itemCount: grpMembers.length,
                          itemBuilder: (context, index) {
                            if (attendeesList.length > 0) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(attendeesList[index].email),
                              );
                            }
                            return Text("No Groups added");
                          }),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            DateFormat.yMMMd().format(selectedDate),
                            style: TextStyle(fontSize: 18.0),
                          ),
                          GestureDetector(
                              onTap: () {
                                _selectDate(context);
                                // setState(() {

                                //                   });
                              },
                              child: Text("Change",
                                  style: TextStyle(
                                      color: Colors.blueAccent,
                                      fontSize: 16.0)))
                        ],
                      ),
                    ),
                    SizedBox(height: 12.0),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                              localizations
                                  .formatTimeOfDay(startTime)
                                  .toString(),
                              style: TextStyle(fontSize: 18.0)),
                          GestureDetector(
                              onTap: () async {
                                final TimeOfDay picked_s = await showTimePicker(
                                    context: context,
                                    initialTime: startTime,
                                    builder:
                                        (BuildContext context, Widget child) {
                                      return MediaQuery(
                                        data: MediaQuery.of(context).copyWith(
                                            alwaysUse24HourFormat: false),
                                        child: child,
                                      );
                                    });

                                if (picked_s != null && picked_s != startTime)
                                  setState(() {
                                    startTime = picked_s;
                                  });
                              },
                              child: Text(
                                "Change",
                                style: TextStyle(
                                    color: Colors.blueAccent, fontSize: 16.0),
                              ))
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                              localizations.formatTimeOfDay(endTime).toString(),
                              style: TextStyle(fontSize: 18.0)),
                          GestureDetector(
                              onTap: () async {
                                final TimeOfDay picked_s = await showTimePicker(
                                    context: context,
                                    initialTime: startTime,
                                    builder:
                                        (BuildContext context, Widget child) {
                                      return MediaQuery(
                                        data: MediaQuery.of(context).copyWith(
                                            alwaysUse24HourFormat: false),
                                        child: child,
                                      );
                                    });

                                if (picked_s != null && picked_s != startTime)
                                  setState(() {
                                    endTime = picked_s;
                                  });
                              },
                              child: Text("Change",
                                  style: TextStyle(
                                      color: Colors.blueAccent,
                                      fontSize: 16.0)))
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text("Generate Google Meet : "),
                        Switch(
                            value: _generate,
                            onChanged: (val) {
                              setState(() {
                                _generate = val;
                              });
                            })
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text("Notify Attendees:  "),
                        Switch(
                            value: _notify,
                            onChanged: (val) {
                              print(val);

                              setState(() {
                                _notify = val;
                              });
                            })
                      ],
                    ),
                    SizedBox(height: 12.0),
                    GestureDetector(
                      onTap: () async {
                        DateTime startDateTime = DateTime(date.year, date.month,
                            date.day, startTime.hour, startTime.minute);

                        DateTime endDateTime = DateTime(date.year, date.month,
                            date.day, endTime.hour, endTime.minute);

                        // CalendarFunctions().insertEvent();

                        await CalendarFunctions()
                            .insert(
                                title: titleController.text,
                                description: detailController.text,
                                location: orgController.text,
                                attendeeEmailList: attendeesList,
                                shouldNotifyAttendees: _notify,
                                hasConferenceSupport: _generate,
                                startTime: startDateTime,
                                endTime: endDateTime)
                            .then((eventData) {
                          String meetLink = "";
                          String eventId = eventData["id"];

                          // if(_notify)
                          meetLink = eventData["link"];

                          List<String> emailsList = [];

                          for (int i = 0; i < attendeesList.length; i++) {
                            emailsList.add(attendeesList[i].email);
                          }

                          int startTimeSinceEpoch =
                              startDateTime.millisecondsSinceEpoch;
                          int endTimeSinceEpoch =
                              endDateTime.millisecondsSinceEpoch;

                          FirebaseFirestore.instance
                              .collection('users')
                              .doc(FirebaseAuth.instance.currentUser.uid)
                              .collection('meetings')
                              .add({
                            'id': eventId,
                            'description': detailController.text,
                            'emails': emailsList,
                            'endTimeSinceEpoch': endTimeSinceEpoch,
                            'link': meetLink,
                            'location': orgController.text,
                            'startTimeSinceepoch': startTimeSinceEpoch,
                            'title': titleController.text
                          });
                        });
                      },
                      child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 12.0),
                          decoration: BoxDecoration(color: Colors.blueAccent),
                          padding: EdgeInsets.all(12.0),
                          width: double.infinity,
                          alignment: Alignment.center,
                          child: Text(
                            "CREATE",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold,
                            ),
                          )),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
