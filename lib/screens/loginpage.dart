import 'package:flutter/material.dart';
import 'package:meet_up/screens/landingPage.dart';
import 'package:meet_up/utils/firebaseHandler.dart';
// import 'package:meetify/screens/homeScreen.dart';
import 'package:page_transition/page_transition.dart';
// import 'package:meetify/helpers/firebase_helpers.dart';

class LoginPage extends StatefulWidget {
  // const LoginPage({ Key? key }) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isError = false;

  final _formKey = GlobalKey<FormState>();

  String errpr = "";
  bool _isloading = false;

  // AuthService _authService = AuthService();

  String email = "";
  String password = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            // automaticallyImplyLeading:false,
            iconTheme: IconThemeData(color: Colors.black),
            title: Text(
              'MeetiFy',
              style: TextStyle(color: Colors.black, fontSize: 30.0),
            ),
            centerTitle: true,
            // backgroundColor: Colors.transparent,
            elevation: 0.0),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    onChanged: (val) {
                      email = val;
                    },
                    validator: (val) => val.isEmpty || !val.contains('@')
                        ? 'Enter valid Email'
                        : null,
                    // controller: emailController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white70,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      hintText: 'Enter Email Address',
                      // hintStyle: TextStyle(color: Colors.)
                    ),
                  ),
                  SizedBox(height: 15.0),
                  TextFormField(
                    onChanged: (val) {
                      password = val;
                    },
                    validator: (val) =>
                        val.length < 6 ? 'Enter Password 6+ char long' : null,

                    // controller: passwordController,
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white70,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        hintText: 'Enter Password'),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () async {
                String status = await FirebaseHelpers().logInToAccount(email, password);
                if(status == "Success"){
                  Navigator.pushReplacement(context, PageTransition(
                    child: LandingPage(),
                    type: PageTransitionType.rightToLeft
                  ));
                }
              },
              child: Container(
                margin: EdgeInsets.all(10.0),
                padding: EdgeInsets.all(15.0),
                alignment: Alignment.center,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.circular(15.0)),
                child: Text(
                  'Login Now',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ));
  }
}
