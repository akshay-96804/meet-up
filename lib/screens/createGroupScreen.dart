import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meet_up/models/groupModel.dart';
import 'package:meet_up/utils/firebaseHandler.dart';

class CreateGroup extends StatefulWidget {
  // const CreateGroup({ Key? key }) : super(key: key);

  @override
  _CreateGroupState createState() => _CreateGroupState();
}

class _CreateGroupState extends State<CreateGroup> {
  final nameController = new TextEditingController();

  final emailController = new TextEditingController();

  List<String> emailsList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Create Group'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
               TextField(
                controller: nameController,
                decoration: InputDecoration(
                  hintText: 'Enter Title Of Group',
                  hintStyle: GoogleFonts.poppins(),
                ),
              ),
            SizedBox(height: 10.0),
            Row(
              children: [
                Expanded(child: TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    hintText: 'Enter valid email',
                    hintStyle: GoogleFonts.poppins()
                  ),
                )),
                Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.redAccent
                      ),
                      child: Center(child: IconButton(icon: Icon(Icons.add,size: 24.0,color: Colors.white),onPressed: (){
                          setState(() {
                                  emailsList.add(emailController.text);
                                  emailController.clear();
                            });
                      }),
                      ))
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Visibility(
              visible: emailsList.length>0,
              child: Text(
                "Members:",
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    fontSize: 20,
                  )
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: emailsList.length,
              itemBuilder: (context,index){
                return Text(emailsList[index],style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    fontSize: 18,
                  )));

            }),
            SizedBox(
              height: 30,
            ),
            GestureDetector(
              onTap: () async{
                GroupModel groupModel = GroupModel(
                  title: nameController.text,
                  emailList: emailsList
                );

                await FirebaseAdd().addGroup(groupModel);          
                Navigator.pop(context);    
              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 25.0),
                padding: EdgeInsets.all(15.0),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.blueAccent
                ),
                child: Text(
                      "CREATE",
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
