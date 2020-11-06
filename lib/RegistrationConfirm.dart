import 'package:flutter/material.dart';
import 'StudentData.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'PasswordGenerator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegistrationConfirm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Map arguments = ModalRoute.of(context).settings.arguments as Map;
    StudentData data = arguments["studentData"];
    return Scaffold(
      appBar: AppBar(
        title: Text("Confirm Details"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(25.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  "We have received the following information from you. Please review the information entered and click on submit button to submit it. You can go back to the previous screen to make any changes.",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  child: Text(
                    "PERSONAL DETAILS",
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Container(
                  height: 1.0,
                  color: Colors.black,
                ),
                ConfirmationItem(
                  title: "First Name",
                  data: data.firstName,
                ),
                ConfirmationItem(
                  title: "Last Name",
                  data: data.lastName,
                ),
                ConfirmationItem(
                  title: "Gender",
                  data: data.gender,
                ),
                ConfirmationItem(
                  title: "Email Address",
                  data: data.email,
                ),
                ConfirmationItem(
                  title: "Date of Birth",
                  data: DateFormat("yMMMMd").format(data.dateOfBirth),
                ),
                ConfirmationItem(
                  title: "Phone Number",
                  data: data.phoneNumber,
                ),
                ConfirmationItem(
                  title: "Category",
                  data: data.category,
                ),
                SizedBox(
                  height: 10.0,
                ),
                Container(
                  child: Text(
                    "MAILING ADDRESS",
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Container(
                  height: 1.0,
                  color: Colors.black,
                ),
                ConfirmationItem(
                  title: "House Number",
                  data: data.house,
                ),
                ConfirmationItem(
                  title: "Street Name",
                  data: data.street,
                ),
                ConfirmationItem(
                  title: "City",
                  data: data.city,
                ),
                ConfirmationItem(
                  title: "State",
                  data: data.state,
                ),
                ConfirmationItem(
                  title: "Country",
                  data: data.country,
                ),
                SizedBox(
                  height: 10.0,
                ),
                Container(
                  child: Text(
                    "EDUCATION - CLASS 10",
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Container(
                  height: 1.0,
                  color: Colors.black,
                ),
                ConfirmationItem(
                  title: "School",
                  data: data.school10,
                ),
                ConfirmationItem(
                  title: "Board",
                  data: data.board10,
                ),
                ConfirmationItem(
                  title: "Score",
                  data: data.score10.toString() + "%",
                ),
                ConfirmationItem(
                  title: "Year",
                  data: data.year10.toString(),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Container(
                  child: Text(
                    "EDUCATION - CLASS 12",
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Container(
                  height: 1.0,
                  color: Colors.black,
                ),
                ConfirmationItem(
                  title: "School",
                  data: data.school12,
                ),
                ConfirmationItem(
                  title: "Board",
                  data: data.board12,
                ),
                ConfirmationItem(
                  title: "Score",
                  data: data.score12.toString() + "%",
                ),
                ConfirmationItem(
                  title: "Year",
                  data: data.year12.toString(),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Container(
                  child: Text(
                    "PREFERENCE ORDER",
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Container(
                  height: 1.0,
                  color: Colors.black,
                ),
                ConfirmationItem(
                  title: "Choice 1",
                  data: data.choice1.toUpperCase(),
                ),
                ConfirmationItem(
                  title: "Choice 2",
                  data: data.choice2.toUpperCase(),
                ),
                ConfirmationItem(
                  title: "Choice 3",
                  data: data.choice3.toUpperCase(),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: 300,
                  child: RaisedButton(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                    onPressed: () async {
                      String password =
                          generatePassword(true, true, true, false, 10);
                      await Firebase.initializeApp();
                      try {
                        User user = (await FirebaseAuth.instance
                                .createUserWithEmailAndPassword(
                          email: data.email,
                          password: password,
                        ))
                            .user;
                        if (user != null) {
                          await FirebaseFirestore.instance
                              .collection('students')
                              .doc(user.uid)
                              .set({
                                'firstName': data.firstName,
                                'lastName': data.lastName,
                                'gender': data.gender,
                                'dateOfBirth': data.dateOfBirth,
                                'phoneNumber': data.phoneNumber,
                                'category': data.category,
                                'house': data.house,
                                'street': data.street,
                                'city': data.city,
                                'state': data.state,
                                'country': data.country,
                                'school10': data.school10,
                                'school12': data.school12,
                                'board10': data.board10,
                                'board12': data.board12,
                                'score10': data.score10,
                                'score12': data.score12,
                                'year10': data.year10,
                                'year12': data.year12,
                                'choice1': data.choice1,
                                'choice2': data.choice2,
                                'choice3': data.choice3,
                                'email': data.email,
                              })
                              .then((value) => print("User Added"))
                              .catchError((error) =>
                                  print("Failed to add user: $error"));
                          await FirebaseFirestore.instance
                              .collection('applications')
                              .doc(user.uid)
                              .set({
                                'status': 'In Review',
                                'allotedBranch': "",
                              })
                              .then((value) => print("User Added"))
                              .catchError((error) =>
                                  print("Failed to add user: $error"));
                          Navigator.pushNamed(context, '/registrationSuccess',
                              arguments: {
                                'password': password,
                                'role': arguments['role']
                              });
                        }
                      } catch (e) {
                        print(e);
                        switch (e.code) {
                          case "email-already-in-use":
                            {
                              final snackBar = SnackBar(
                                content: Text(
                                    "The email you have entered is already is use."),
                              );
                              Scaffold.of(context).showSnackBar(snackBar);

                              break;
                            }
                        }
                      }
                    },
                    child: Text(
                      "Submit Details",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(18.0),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ConfirmationItem extends StatelessWidget {
  final String title;
  final String data;

  ConfirmationItem({this.title, this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: Text(
        "$title: $data",
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}
