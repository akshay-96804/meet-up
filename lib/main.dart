import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meet_up/screens/landingPage.dart';
import 'package:meet_up/screens/loginpage.dart';



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
        
        textTheme: TextTheme(
          title: GoogleFonts.lato(),
          body1: GoogleFonts.lato()
        ),
        primaryColor: Colors.blueAccent
      ),
    );
  }
}

class AuthState extends StatefulWidget {
  // const AuthState({ Key? key }) : super(key: key);

  @override
  State<AuthState> createState() => _AuthStateState();
}

class _AuthStateState extends State<AuthState> {
  User currUser = null ; 

  @override
  void initState() {
    super.initState();
    currUser = FirebaseAuth.instance.currentUser ;
  }

  @override
  Widget build(BuildContext context) {
    return currUser==null ? LoginPage():LandingPage();
  }
}