import 'package:flutter/material.dart';
import 'package:validators/validators.dart' as validator;
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'RegistrationConfirm.dart';
import 'package:intl/intl.dart';

class ViewStudentDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("View Student Details"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(25.0),
            child: ViewStudentDetailsBody(),
          ),
        ),
      ),
    );
  }
}

class ViewStudentDetailsBody extends StatefulWidget {
  @override
  _ViewStudentDetailsBodyState createState() => _ViewStudentDetailsBodyState();
}

class _ViewStudentDetailsBodyState extends State<ViewStudentDetailsBody> {
  final _formKey = GlobalKey<FormState>();
  String email;
  DocumentSnapshot userData;
  bool isFetched = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Please enter the email address of the student you want to view.",
          style: TextStyle(
            fontSize: 18,
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Form(
          key: _formKey,
          child: Column(
            children: [
              Container(
                width: 400,
                child: TextFormField(
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Please enter the email";
                    } else if (!validator.isEmail(value)) {
                      return "Please enter the correct email";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    this.email = value;
                  },
                  autocorrect: false,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: "Email Address",
                    contentPadding: EdgeInsets.all(8.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(18.0)),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                width: 400,
                child: RaisedButton(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(18.0),
                    ),
                  ),
                  onPressed: () async {
                    await Firebase.initializeApp();
                    if (_formKey.currentState.validate()) {
                      _formKey.currentState.save();
                      QuerySnapshot allData = await FirebaseFirestore.instance
                          .collection("students")
                          .where('email', isEqualTo: this.email)
                          .get();

                      if (allData.size > 0) {
                        setState(() {
                          this.userData = allData.docs[0];
                          print(
                              "Record Found for ${this.userData['firstName']}");
                          this.isFetched = true;
                        });
                      } else {
                        final snackBar = SnackBar(
                            content: Text(
                                "No Record exists for the entered email address."));
                        Scaffold.of(context).showSnackBar(snackBar);
                        setState(() {
                          this.isFetched = false;
                        });
                      }
                    }
                  },
                  child: Text(
                    "Fetch Details",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              if (this.isFetched)
                StudentDetails(
                  userData: this.userData,
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class StudentDetails extends StatelessWidget {
  final DocumentSnapshot userData;
  StudentDetails({this.userData});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
          data: this.userData['firstName'],
        ),
        ConfirmationItem(
          title: "Last Name",
          data: this.userData['lastName'],
        ),
        ConfirmationItem(
          title: "Gender",
          data: this.userData['gender'],
        ),
        ConfirmationItem(
          title: "Email Address",
          data: this.userData['email'],
        ),
        ConfirmationItem(
          title: "Date of Birth",
          data: DateFormat("yMMMMd").format(
              DateTime.parse(userData['dateOfBirth'].toDate().toString())),
        ),
        ConfirmationItem(
          title: "Phone Number",
          data: this.userData['phoneNumber'],
        ),
        ConfirmationItem(
          title: "Category",
          data: this.userData['category'],
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
          data: this.userData['house'],
        ),
        ConfirmationItem(
          title: "Street Name",
          data: this.userData['street'],
        ),
        ConfirmationItem(
          title: "City",
          data: this.userData['city'],
        ),
        ConfirmationItem(
          title: "State",
          data: this.userData['state'],
        ),
        ConfirmationItem(
          title: "Country",
          data: this.userData['country'],
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
          data: this.userData['school10'],
        ),
        ConfirmationItem(
          title: "Board",
          data: this.userData['board10'],
        ),
        ConfirmationItem(
          title: "Score",
          data: this.userData['score10'].toString() + "%",
        ),
        ConfirmationItem(
          title: "Year",
          data: this.userData['year10'].toString(),
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
          data: this.userData['school12'],
        ),
        ConfirmationItem(
          title: "Board",
          data: this.userData['board12'],
        ),
        ConfirmationItem(
          title: "Score",
          data: this.userData['score12'].toString() + "%",
        ),
        ConfirmationItem(
          title: "Year",
          data: this.userData['year12'].toString(),
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
          data: this.userData['choice1'].toUpperCase(),
        ),
        ConfirmationItem(
          title: "Choice 2",
          data: this.userData['choice2'].toUpperCase(),
        ),
        ConfirmationItem(
          title: "Choice 3",
          data: this.userData['choice3'].toUpperCase(),
        ),
      ],
    );
  }
}
