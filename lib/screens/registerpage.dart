// import 'package:book_cart_app/screens/authentication.dart';
// import 'package:book_cart_app/screens/registerPage.dart';
import 'package:flutter/material.dart';
import 'package:meet_up/screens/landingPage.dart';
import 'package:meet_up/utils/firebaseHandler.dart';
// import 'package:meetify/helpers/firebase_helpers.dart';
// import 'package:meetify/screens/homeScreen.dart';
import 'package:page_transition/page_transition.dart';


class RegisterPage extends StatefulWidget {
  // const RegisterPage({ Key? key }) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _isError = false;

  final _formKey = GlobalKey<FormState>();

  String errpr = "";
  bool _isloading = false;

  // AuthService _authService = AuthService();

  String email = "";
  String password = "";

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

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
                    controller: emailController,
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

                    controller: passwordController,
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
                print(emailController.text);
                print(passwordController.text);

                String status = await FirebaseHelpers().createAccount(emailController.text, passwordController.text);

                print(status);
                if(status == "Success"){
                  Navigator.pushReplacement(context, PageTransition(
                    child: LandingPage(),
                    type: PageTransitionType.rightToLeft
                  ));
               }},
              child: Container(
                margin: EdgeInsets.all(10.0),
                padding: EdgeInsets.all(15.0),
                alignment: Alignment.center,
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.circular(15.0)),
                child: Text(
                  'Register Now',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ));
  }
}
