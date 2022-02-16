import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:googleapis/calendar/v3.dart' as calendar hide Colors;
import 'package:intl/intl.dart';
import 'package:meet_up/models/eventInfo.dart';
import 'package:meet_up/models/groupModel.dart';
import 'package:meet_up/utils/calendarEvents.dart';
import 'package:meet_up/utils/firebaseHandler.dart';
// import 'package:googleapis/calendar/' as calendar;

class createEvent extends StatefulWidget {
  // const createEvent({ Key? key }) : super(key: key);

  @override
  _createEventState createState() => _createEventState();
}

class _createEventState extends State<createEvent> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  
  bool  _generateMeet = false ; 
  bool _notifyAttendees = false ; 

  DateTime date = DateTime.now();

  TimeOfDay startTime = TimeOfDay.now();

  TimeOfDay endTime = TimeOfDay.now();

  Future<void> _selectDate(BuildContext context) async{
    
    final DateTime picked  = await showDatePicker(context: context, 
           initialDate: date, 
           firstDate: DateTime(2022,2), 
           lastDate: DateTime(2023)
           );
    if(picked!=null && picked!=date){
      setState(() {
              date = picked; 
            });
      // print(date);
    }       
  }

  Future<TimeOfDay>_selectTime(BuildContext context) async{
   
   TimeOfDay picked  = await  showTimePicker(context: context, 
   initialTime: startTime, 
  
   builder: (BuildContext context,Widget child){
       return MediaQuery(
           data: MediaQuery.of(context)
           .copyWith(alwaysUse24HourFormat: true),
           child: child,
         ) ; 
     }
   );
   return picked ;
  }

  TextEditingController attendeeController = TextEditingController();

  List<calendar.EventAttendee> attendeesList = [];

 
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create An Event',style: GoogleFonts.poppins()),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(10.0),
              child: Text('Enter Details',style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 26.0
              ))),
             SizedBox(height: 10.0),
             Expanded(
               child: ListView(
                 shrinkWrap: true,
                 physics: BouncingScrollPhysics(),
                  //  crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     TextField(
                       style: GoogleFonts.poppins(),
                  controller: titleController,
                  decoration: InputDecoration(
                    hintText: 'Title',
                    hintStyle: GoogleFonts.poppins(),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      borderSide: BorderSide(color: Colors.redAccent)
                    )
                    // enabledBorder: OutlineInputBorder(
                    //   borderRadius: BorderRadius.circular(18.0),
                    //   borderSide: BorderSide(color: Colors.redAccent)
                    // )
                  ),
                ),
            SizedBox(height: 10.0),
            TextField(
              style: GoogleFonts.poppins(),
              controller: descriptionController,
                decoration: InputDecoration(
                  hintText: 'Description',
                  hintStyle: GoogleFonts.poppins(),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      borderSide: BorderSide(color: Colors.redAccent)
                    )
                ),
            ),
            SizedBox(height: 10.0),
            TextField(
              style: GoogleFonts.poppins(),
              controller: locationController,
                decoration: InputDecoration(
                 hintStyle: GoogleFonts.poppins(),
                  hintText: 'Location',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      borderSide: BorderSide(color: Colors.redAccent)
                    )
                  )
                ),
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: Divider(
                  endIndent: 10.0,
                  indent: 10.0,
                  color: Colors.redAccent,
                  thickness: 2.0,
                ),
            ),
            Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(DateFormat.yMMMd().format(date),style: GoogleFonts.poppins(
                      fontSize: 18.0
                    ),),
                    GestureDetector(
                      onTap: (){
                        _selectDate(context);
                      },
                      child: Text('Change Date',style: GoogleFonts.poppins(
                        color: Colors.redAccent
                      )),
                    )
                  ],
                ),
            ),
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: Divider(
                  endIndent: 10.0,
                  indent: 10.0,
                  color: Colors.redAccent,
                  thickness: 2.0,
                ),
            ),
            Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(MaterialLocalizations.of(context).formatTimeOfDay(startTime),style: GoogleFonts.poppins(
                      fontSize: 18.0
                    )),
                        GestureDetector(
                          onTap: () async{
                            startTime = await _selectTime(context);        
                            setState(() {});
                          },
                          child: Text('Change',style: GoogleFonts.poppins(
                            color: Colors.redAccent
                          )),
                        )
                      ],
                    ),
                    Text('to',style: GoogleFonts.poppins()),
                    Row(
                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(MaterialLocalizations.of(context).formatTimeOfDay(endTime),style: GoogleFonts.poppins(
                      fontSize: 18.0
                    )),
                        GestureDetector(
                          onTap: () async{
                            endTime = await _selectTime(context);        
                            setState(() {});
                          },
                          child: Text('Change',style: GoogleFonts.poppins(
                            color: Colors.redAccent
                          )),
                        )
                      ],
                    )
                  ],
                ),
            ),
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: Divider(
                  endIndent: 10.0,
                  indent: 10.0,
                  color: Colors.redAccent,
                  thickness: 2.0,
                ),
            ),
            Text('Add Attendees',style: GoogleFonts.poppins()),
            Row(
                children: [
                  Expanded(child: TextField(
                    style: GoogleFonts.poppins(),
                    controller: attendeeController,
                    decoration: InputDecoration(
                      hintText: 'Email :',
                      hintStyle: GoogleFonts.poppins()
                    ),
                  )),
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.redAccent
                    ),
                    child: Center(child: IconButton(icon: Icon(Icons.add,size: 24.0,color: Colors.white,), onPressed: (){
                              setState(() {
                                  calendar.EventAttendee newAttendee = new calendar.EventAttendee();
                                  newAttendee.email = attendeeController.text; 
                                  attendeesList.add(newAttendee);
                                  attendeeController.clear();
                              });
                    })))
                ],
            ),
            SizedBox(height: 20.0),
            Text('Or Select One of Your groups :',style: GoogleFonts.poppins()),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('groups').snapshots(),
              builder: (context,snapshot){
                if(snapshot.data.docs.length>0){
                  return ListView.builder(
                    shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (context,index){
                      
                      Map<String,dynamic> jsonData = snapshot.data.docs[index].data();
                      GroupModel myGroup = GroupModel.fromJSON(jsonData);

                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                    Text(myGroup.title,style: GoogleFonts.poppins()),
                    Container(
                      width: 40.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.redAccent
                    ),
                    child: Center(child: IconButton(icon: Icon(Icons.add,size: 24.0,color: Colors.white,), onPressed: (){
                       setState(() {
                               myGroup.emailList.forEach((element) {
                                 calendar.EventAttendee newAttendee = new calendar.EventAttendee();
                                 newAttendee.email = element ; 

                                 attendeesList.add(newAttendee);
                               })              ;
                            });
                    })))
                  ],
                      );
                  });
                }
                return Text('No Groups added yet');
              },
            ),
            Row(),
            Row(),
            SizedBox(height: 30.0),
            Text('Attendees: ',style: GoogleFonts.poppins()),
            ListView.builder(
              // padding: EdgeInsets.all(12.0),
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: attendeesList.length,
              itemBuilder: (context,index){
                 return ListTile(
                   title: Text(attendeesList[index].email,style: GoogleFonts.poppins()),
                 );
            }),
            SizedBox(height: 25.0),
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: Divider(
                  endIndent: 10.0,
                  indent: 10.0,
                  color: Colors.redAccent,
                  thickness: 2.0,
                ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Generate Google Meet : ',style: GoogleFonts.poppins()),
                  Switch(
                    value: _generateMeet, 
                    onChanged: (val){
                      setState(() {
                            _generateMeet = val ;                   
                        });
                    },
                    activeColor: Colors.redAccent,
                    )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Notify Attendees : ',style: GoogleFonts.poppins()),
                  Switch(
                    value: _notifyAttendees, 
                    onChanged: (val){
                      setState(() {
                            _notifyAttendees = val ;                   
                        });
                    },
                    activeColor: Colors.redAccent,
                    )
                ],
              ),
            ),
            SizedBox(height: 15.0),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10.0
              ),
              child: GestureDetector(
                onTap: () async{
                    DateTime startDateTime = DateTime(
                      date.year,
                      date.month,
                      date.day,
                      startTime.hour,
                      startTime.minute
                    );

                    DateTime endDateTime = DateTime(
                      date.year,
                      date.month,
                      date.day,
                      endTime.hour,
                      endTime.minute
                    );

                    await CalendarClient().insert(
                      title: titleController.text, 
                      description: descriptionController.text, 
                      location: locationController.text, 
                      attendeeEmailList: attendeesList, 
                      shouldNotifyAttendees: _notifyAttendees, 
                      hasConferenceSupport: true, 
                      startTime: startDateTime, 
                      endTime: endDateTime
                      )
                      .then((Map<String, String> eventData) async{
                         
                         String meetLink = ""; 
                         String eventId = eventData["id"];

                        // if(isConference)
                          meetLink = eventData["link"];

                           List<String> emailsList = [];
                           
                           for(int i=0 ; i<attendeesList.length ; i++){
                                    emailsList.add(attendeesList[i].email);
                            }

                          int startTimeSinceEpoch = startDateTime.millisecondsSinceEpoch;
                           int endTimeSinceEpoch = endDateTime.millisecondsSinceEpoch;

                          EventModel newEventModel = EventModel(
                            id: eventId,
                            description: descriptionController.text,
                            emails: emailsList,
                            endTimeSinceEpoch: endTimeSinceEpoch,
                            link: meetLink,
                            location: locationController.text,
                            startTimeSinceepoch: startTimeSinceEpoch,
                            title: titleController.text
                          );

                          await FirebaseAdd().addEvent(newEventModel);
                          
                          Navigator.pop(context);
                      });
                },
                child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(14.0),
                  color: Colors.redAccent,
                  child: Text('CREATE',style: GoogleFonts.poppins(
                    color: Colors.white
                  )),
                ),
              ),
            )
           ],                   
          ),
             ),
          ],
        ),
      ),
    );
  }
}