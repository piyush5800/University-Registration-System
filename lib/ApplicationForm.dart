import 'package:flutter/material.dart';
import 'StudentData.dart';
import 'package:validators/validators.dart' as validator;
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ApplicationForm extends StatefulWidget {
  final String role;
  ApplicationForm({this.role});

  @override
  _ApplicationFormState createState() => _ApplicationFormState();
}

class _ApplicationFormState extends State<ApplicationForm> {
  final _registrationFormKey = GlobalKey<FormState>();
  StudentData data = StudentData();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _registrationFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
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
          //First Name
          Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: TextFormField(
              validator: (value) {
                if (value.isEmpty) {
                  return "Please enter first name";
                }
                return null;
              },
              onSaved: (value) {
                data.firstName = value;
              },
              autocorrect: false,
              textAlign: TextAlign.left,
              enableSuggestions: false,
              style: TextStyle(fontSize: 18.0),
              decoration: InputDecoration(
                hintText: "First Name",
                hintStyle: TextStyle(fontSize: 18.0),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(18.0)),
                ),
              ),
            ),
          ),
          //Last Name
          Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: TextFormField(
              maxLength: 50,
              maxLengthEnforced: true,
              validator: (value) {
                if (value.isEmpty) {
                  return "Please enter last name";
                }
                return null;
              },
              onSaved: (value) {
                data.lastName = value;
              },
              autocorrect: false,
              textAlign: TextAlign.left,
              enableSuggestions: false,
              style: TextStyle(fontSize: 18.0),
              decoration: InputDecoration(
                hintText: "Last Name",
                hintStyle: TextStyle(fontSize: 18.0),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(18.0)),
                ),
              ),
            ),
          ),
          //Gender
          Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: TextFormField(
              maxLength: 50,
              maxLengthEnforced: true,
              validator: (value) {
                if (value.isEmpty) {
                  return "Please enter gender";
                } else if (value != "male" &&
                    value != "female" &&
                    value != "Male" &&
                    value != "Female" &&
                    value != "MALE" &&
                    value != "FEMALE") {
                  return "Please enter the correct gender";
                }
                return null;
              },
              onSaved: (value) {
                if (value == "female" ||
                    value == "Female" ||
                    value == "FEMALE") {
                  data.gender = "Female";
                } else if (value == "male" ||
                    value == "Male" ||
                    value == "MALE") {
                  data.gender = "Male";
                }
              },
              autocorrect: false,
              textAlign: TextAlign.left,
              enableSuggestions: false,
              style: TextStyle(fontSize: 18.0),
              decoration: InputDecoration(
                hintText: "Gender",
                hintStyle: TextStyle(fontSize: 18.0),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(18.0)),
                ),
              ),
            ),
          ),
          //Email
          Padding(
            padding: const EdgeInsets.only(top: 12.0),
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
                data.email = value;
              },
              autocorrect: false,
              textAlign: TextAlign.left,
              enableSuggestions: false,
              style: TextStyle(fontSize: 18.0),
              decoration: InputDecoration(
                hintText: "Email Address",
                hintStyle: TextStyle(fontSize: 18.0),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(18.0)),
                ),
              ),
            ),
          ),
          //Date of Birth
          Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: TextFormField(
              validator: (value) {
                if (value.isEmpty) {
                  return "Please enter the date of birth";
                } else if (!validator.isDate(value)) {
                  return "Please enter a valid date";
                }
                return null;
              },
              onSaved: (value) {
                data.dateOfBirth = DateTime.parse(value);
              },
              autocorrect: false,
              textAlign: TextAlign.left,
              enableSuggestions: false,
              style: TextStyle(fontSize: 18.0),
              decoration: InputDecoration(
                hintText: "Date of Birth",
                hintStyle: TextStyle(fontSize: 18.0),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(18.0)),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 8.0, right: 8.0),
            child: Text("YYYYMMDD Format"),
          ),
          //Phone Number
          Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: TextFormField(
              validator: (value) {
                if (value.isEmpty) {
                  return "Please enter the phone number";
                } else if (!validator.isNumeric(value) && value.length != 10) {
                  return "Please enter a valid phone number";
                }
                return null;
              },
              onSaved: (value) {
                data.phoneNumber = value;
              },
              autocorrect: false,
              textAlign: TextAlign.left,
              enableSuggestions: false,
              style: TextStyle(fontSize: 18.0),
              decoration: InputDecoration(
                hintText: "Phone Number",
                hintStyle: TextStyle(fontSize: 18.0),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(18.0)),
                ),
              ),
            ),
          ),
          //Category
          Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: TextFormField(
              validator: (value) {
                if (value.isEmpty) {
                  return "Please enter a gender code";
                } else if (value != "GEN" &&
                    value != "OBC" &&
                    value != "SC" &&
                    value != "ST") {
                  return "Please enter a valid category code";
                }
                return null;
              },
              onSaved: (value) {
                data.category = value;
              },
              autocorrect: false,
              textAlign: TextAlign.left,
              enableSuggestions: false,
              style: TextStyle(fontSize: 18.0),
              decoration: InputDecoration(
                hintText: "Category",
                hintStyle: TextStyle(fontSize: 18.0),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(18.0)),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 8.0, right: 8.0),
            child: Text("GEN/OBC/SC/ST"),
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
          //House Number
          Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: TextFormField(
              validator: (value) {
                if (value.isEmpty) {
                  return "Please enter House Number";
                }
                return null;
              },
              onSaved: (value) {
                data.house = value;
              },
              autocorrect: false,
              textAlign: TextAlign.left,
              enableSuggestions: false,
              style: TextStyle(fontSize: 18.0),
              decoration: InputDecoration(
                hintText: "House Number",
                hintStyle: TextStyle(fontSize: 18.0),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(18.0)),
                ),
              ),
            ),
          ),
          //Street Name
          Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: TextFormField(
              validator: (value) {
                if (value.isEmpty) {
                  return "Please enter Street Name";
                }
                return null;
              },
              onSaved: (value) {
                data.street = value;
              },
              autocorrect: false,
              textAlign: TextAlign.left,
              enableSuggestions: false,
              style: TextStyle(fontSize: 18.0),
              decoration: InputDecoration(
                hintText: "Street Name",
                hintStyle: TextStyle(fontSize: 18.0),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(18.0)),
                ),
              ),
            ),
          ),
          //City
          Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: TextFormField(
              validator: (value) {
                if (value.isEmpty) {
                  return "Please enter city";
                }
                return null;
              },
              onSaved: (value) {
                data.city = value;
              },
              autocorrect: false,
              textAlign: TextAlign.left,
              enableSuggestions: false,
              style: TextStyle(fontSize: 18.0),
              decoration: InputDecoration(
                hintText: "City",
                hintStyle: TextStyle(fontSize: 18.0),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(18.0)),
                ),
              ),
            ),
          ),
          //State
          Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: TextFormField(
              validator: (value) {
                if (value.isEmpty) {
                  return "Please enter state";
                }
                return null;
              },
              onSaved: (value) {
                data.state = value;
              },
              autocorrect: false,
              textAlign: TextAlign.left,
              enableSuggestions: false,
              style: TextStyle(fontSize: 18.0),
              decoration: InputDecoration(
                hintText: "State",
                hintStyle: TextStyle(fontSize: 18.0),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(18.0)),
                ),
              ),
            ),
          ),
          //Country
          Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: TextFormField(
              validator: (value) {
                if (value.isEmpty) {
                  return "Please enter country";
                }
                return null;
              },
              onSaved: (value) {
                data.country = value;
              },
              autocorrect: false,
              textAlign: TextAlign.left,
              enableSuggestions: false,
              style: TextStyle(fontSize: 18.0),
              decoration: InputDecoration(
                hintText: "Country",
                hintStyle: TextStyle(fontSize: 18.0),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(18.0)),
                ),
              ),
            ),
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
          SizedBox(
            height: 6,
          ),
          Text(
              "Please provide educational details for Class 10. Original documents will be verified during interviews."),
          //School - 10
          Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: TextFormField(
              validator: (value) {
                if (value.isEmpty) {
                  return "Please enter school name";
                }
                return null;
              },
              onSaved: (value) {
                data.school10 = value;
              },
              autocorrect: false,
              textAlign: TextAlign.left,
              enableSuggestions: false,
              style: TextStyle(fontSize: 18.0),
              decoration: InputDecoration(
                hintText: "School Name",
                hintStyle: TextStyle(fontSize: 18.0),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(18.0)),
                ),
              ),
            ),
          ),
          //Board - 10
          Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: TextFormField(
              validator: (value) {
                if (value.isEmpty) {
                  return "Please enter educational board";
                }
                return null;
              },
              onSaved: (value) {
                data.board10 = value;
              },
              autocorrect: false,
              textAlign: TextAlign.left,
              enableSuggestions: false,
              style: TextStyle(fontSize: 18.0),
              decoration: InputDecoration(
                hintText: "Education Board",
                hintStyle: TextStyle(fontSize: 18.0),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(18.0)),
                ),
              ),
            ),
          ),
          //Score - 10
          Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: TextFormField(
              validator: (value) {
                if (value.isEmpty) {
                  return "Please enter marks in percentage";
                } else if (double.parse(value) > 100.0 ||
                    double.parse(value) < 0.0) {
                  return "Please enter valid marks.";
                }
                return null;
              },
              onSaved: (value) {
                data.score10 = double.parse(value);
              },
              autocorrect: false,
              textAlign: TextAlign.left,
              enableSuggestions: false,
              style: TextStyle(fontSize: 18.0),
              decoration: InputDecoration(
                hintText: "Marks in percentage",
                hintStyle: TextStyle(fontSize: 18.0),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(18.0)),
                ),
              ),
            ),
          ),
          //Year - 10
          Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: TextFormField(
              validator: (value) {
                if (value.isEmpty) {
                  return "Please enter year";
                } else if (int.parse(value) > 9999 || int.parse(value) < 1000) {
                  return "Please enter valid year";
                }
                return null;
              },
              onSaved: (value) {
                data.year10 = int.parse(value);
              },
              autocorrect: false,
              textAlign: TextAlign.left,
              enableSuggestions: false,
              style: TextStyle(fontSize: 18.0),
              decoration: InputDecoration(
                hintText: "Year of passing",
                hintStyle: TextStyle(fontSize: 18.0),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(18.0)),
                ),
              ),
            ),
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
          SizedBox(
            height: 6,
          ),
          Text(
              "Please provide educational details for Class 12. Original documents will be verified during interviews."),
          //School - 12
          Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: TextFormField(
              validator: (value) {
                if (value.isEmpty) {
                  return "Please enter school name";
                }
                return null;
              },
              onSaved: (value) {
                data.school12 = value;
              },
              autocorrect: false,
              textAlign: TextAlign.left,
              enableSuggestions: false,
              style: TextStyle(fontSize: 18.0),
              decoration: InputDecoration(
                hintText: "School Name",
                hintStyle: TextStyle(fontSize: 18.0),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(18.0)),
                ),
              ),
            ),
          ),
          //Board - 12
          Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: TextFormField(
              validator: (value) {
                if (value.isEmpty) {
                  return "Please enter educational board";
                }
                return null;
              },
              onSaved: (value) {
                data.board12 = value;
              },
              autocorrect: false,
              textAlign: TextAlign.left,
              enableSuggestions: false,
              style: TextStyle(fontSize: 18.0),
              decoration: InputDecoration(
                hintText: "Education Board",
                hintStyle: TextStyle(fontSize: 18.0),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(18.0)),
                ),
              ),
            ),
          ),
          //Score - 12
          Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: TextFormField(
              validator: (value) {
                if (value.isEmpty) {
                  return "Please enter marks in percentage";
                } else if (double.parse(value) > 100.0 ||
                    double.parse(value) < 0.0) {
                  return "Please enter valid marks.";
                }
                return null;
              },
              onSaved: (value) {
                data.score12 = double.parse(value);
              },
              autocorrect: false,
              textAlign: TextAlign.left,
              enableSuggestions: false,
              style: TextStyle(fontSize: 18.0),
              decoration: InputDecoration(
                hintText: "Marks in percentage",
                hintStyle: TextStyle(fontSize: 18.0),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(18.0)),
                ),
              ),
            ),
          ),
          //Year - 12
          Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: TextFormField(
              validator: (value) {
                if (value.isEmpty) {
                  return "Please enter year";
                } else if (int.parse(value) > 9999 || int.parse(value) < 1000) {
                  return "Please enter valid year";
                }
                return null;
              },
              onSaved: (value) {
                data.year12 = int.parse(value);
              },
              autocorrect: false,
              textAlign: TextAlign.left,
              enableSuggestions: false,
              style: TextStyle(fontSize: 18.0),
              decoration: InputDecoration(
                hintText: "Year of passing",
                hintStyle: TextStyle(fontSize: 18.0),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(18.0)),
                ),
              ),
            ),
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
          SizedBox(
            height: 6,
          ),
          Text("Enter the code of one of the various available branches."),
          Container(
            width: 300,
            child: RaisedButton(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
              onPressed: () async {
                await Firebase.initializeApp();
                QuerySnapshot branchData = await FirebaseFirestore.instance
                    .collection("branches")
                    .get();
                Navigator.pushNamed(context, '/branchList',
                    arguments: {'branchData': branchData});
              },
              child: Text(
                "Click here for available branches.",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(18.0),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: TextFormField(
              validator: (value) {
                if (value.isEmpty) {
                  return "Please enter first choice.";
                } else if (value.toLowerCase() != "coe" &&
                    value.toLowerCase() != "it" &&
                    value.toLowerCase() != "se" &&
                    value.toLowerCase() != "ece") {
                  return "Please enter a valid choice";
                }
                return null;
              },
              onSaved: (value) {
                data.choice1 = value.toLowerCase();
              },
              autocorrect: false,
              textAlign: TextAlign.left,
              enableSuggestions: false,
              style: TextStyle(fontSize: 18.0),
              decoration: InputDecoration(
                hintText: "Choice 1",
                hintStyle: TextStyle(fontSize: 18.0),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(18.0)),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: TextFormField(
              validator: (value) {
                if (value.isEmpty) {
                  return "Please enter second choice.";
                } else if (value.toLowerCase() != "coe" &&
                    value.toLowerCase() != "it" &&
                    value.toLowerCase() != "se" &&
                    value.toLowerCase() != "ece") {
                  return "Please enter a valid choice";
                }
                return null;
              },
              onSaved: (value) {
                data.choice2 = value.toLowerCase();
              },
              autocorrect: false,
              textAlign: TextAlign.left,
              enableSuggestions: false,
              style: TextStyle(fontSize: 18.0),
              decoration: InputDecoration(
                hintText: "Choice 2",
                hintStyle: TextStyle(fontSize: 18.0),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(18.0)),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: TextFormField(
              validator: (value) {
                if (value.isEmpty) {
                  return "Please enter third choice.";
                } else if (value.toLowerCase() != "coe" &&
                    value.toLowerCase() != "it" &&
                    value.toLowerCase() != "se" &&
                    value.toLowerCase() != "ece") {
                  return "Please enter a valid choice";
                }
                return null;
              },
              onSaved: (value) {
                data.choice3 = value.toLowerCase();
              },
              autocorrect: false,
              textAlign: TextAlign.left,
              enableSuggestions: false,
              style: TextStyle(fontSize: 18.0),
              decoration: InputDecoration(
                hintText: "Choice 3",
                hintStyle: TextStyle(fontSize: 18.0),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
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
            width: 300,
            child: RaisedButton(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
              onPressed: () {
                if (_registrationFormKey.currentState.validate()) {
                  _registrationFormKey.currentState.save();
                  Navigator.pushNamed(context, '/registrationConfirm',
                      arguments: {
                        'studentData': this.data,
                        'role': widget.role
                      });
                }
              },
              child: Text(
                "Proceed",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
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
    );
  }
}
