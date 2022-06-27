import 'package:flutter/foundation.dart';
import 'package:googleapis/calendar/v3.dart';
import 'package:googleapis/calendar/v3.dart' as cal;
import 'package:googleapis_auth/auth.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:meet_up/secrets.dart';
import 'package:url_launcher/url_launcher.dart';


class CalendarFunctions{

static var calendar;

void prompt(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

Future<Map<String, String>> insert({
  
  @required String title,
  @required String description,
  @required String location,
  @required List<EventAttendee> attendeeEmailList,
  @required bool shouldNotifyAttendees,
  @required bool hasConferenceSupport,
  @required DateTime startTime,
  @required DateTime endTime,
}) async {
  Map<String, String> eventData = {} ;

  // If the account has multiple calendars, then select the "primary" one
  String calendarId = "primary";
  Event event = Event();

  event.summary = title;
  event.description = description;
  event.attendees = attendeeEmailList;
  event.location = location;

  if (hasConferenceSupport) {
    ConferenceData conferenceData = ConferenceData();
    CreateConferenceRequest conferenceRequest = CreateConferenceRequest();
    conferenceRequest.requestId = "${startTime.millisecondsSinceEpoch}-${endTime.millisecondsSinceEpoch}";
    conferenceData.createRequest = conferenceRequest;

    event.conferenceData = conferenceData;
  }

  EventDateTime start = new EventDateTime();
  start.dateTime = startTime;
  start.timeZone = "GMT+05:30";
  event.start = start;

  EventDateTime end = new EventDateTime();
  end.timeZone = "GMT+05:30";
  end.dateTime = endTime;
  event.end = end;

 try {
   var _clientID = new ClientId(mySecrets.getId(), "");
  const _scopes = const [cal.CalendarApi.calendarScope];

   await clientViaUserConsent(_clientID, _scopes, prompt).then((AuthClient client) async {
    CalendarFunctions.calendar = cal.CalendarApi(client);
  });
   await calendar.events
       .insert(event, calendarId,
           conferenceDataVersion: hasConferenceSupport ? 1 : 0, sendUpdates: shouldNotifyAttendees ? "all" : "none")
       .then((value) {
     print("Event Status: ${value.status}");

     if (value.status == "confirmed") {
       String joiningLink;
       String eventId;

        eventId = value.id;
        print(eventId);

        if (hasConferenceSupport) {
          joiningLink = "https://meet.google.com/${value.conferenceData.conferenceId}";
        }

        eventData = {
          'id': eventId, 
          'link': joiningLink
        };

        print('Event added to Google Calendar');
      } else {
        print("Unable to add event to Google Calendar");
      }
    });
  } catch (e) {
    print('Error creating event $e');
  }

  return eventData;
}
}