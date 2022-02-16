import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:googleapis/cloudbuild/v1.dart';
// import 'package:googleapis_auth/auth.dart';
import 'package:googleapis_auth/auth_io.dart';
// import 'package:meet_up/screens/createEventScreen.dart';
import 'package:meet_up/screens/landingpage.dart';
import 'package:googleapis/calendar/v3.dart' as cal;
import 'package:meet_up/secrets.dart';
import 'package:meet_up/utils/calendarEvents.dart';
import 'package:url_launcher/url_launcher.dart';


Future<void> main() async{ 
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

    
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  // const MyApp({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // home: createEvent(),
      home: LandingPage(),
      theme: ThemeData(
        
        // primarySwatch: ,
        primaryColor: Colors.redAccent
      ),
    );
  }
}