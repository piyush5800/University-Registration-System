import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:validators/validators.dart' as validator;
import 'StudentData.dart';
import 'package:intl/intl.dart';

class EditStudentDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Student Details"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(25.0),
            child: EditStudentDetailsBody(),
          ),
        ),
      ),
    );
  }
}

class EditStudentDetailsBody extends StatefulWidget {
  @override
  _EditStudentDetailsBodyState createState() => _EditStudentDetailsBodyState();
}

class _EditStudentDetailsBodyState extends State<EditStudentDetailsBody> {
  final _emailFormKey = GlobalKey<FormState>();
  String email;
  DocumentSnapshot userData;
  bool isFetched = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Please enter the email address of the student whose details you want to edit.",
          style: TextStyle(
            fontSize: 18,
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Form(
          key: _emailFormKey,
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
                    if (_emailFormKey.currentState.validate()) {
                      _emailFormKey.currentState.save();
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
                PrefilledStudentDetailsForm(userData: this.userData),
            ],
          ),
        ),
      ],
    );
  }
}

class PrefilledStudentDetailsForm extends StatelessWidget {
  final DocumentSnapshot userData;
  final _studentEditingFormKey = GlobalKey<FormState>();
  final StudentData data = StudentData();
  PrefilledStudentDetailsForm({this.userData});

  @override
  Widget build(BuildContext context) {
    this.data.email = userData['email'];
    return Form(
      key: _studentEditingFormKey,
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
              maxLength: 50,
              maxLengthEnforced: true,
              initialValue: userData['firstName'],
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
              initialValue: userData['lastName'],
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
              initialValue: userData['gender'],
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
          //Date of Birth
          Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: TextFormField(
              initialValue: DateFormat("yyyyMMdd").format(
                  DateTime.parse(userData['dateOfBirth'].toDate().toString())),
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
              initialValue: userData['phoneNumber'],
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
              initialValue: userData['category'],
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
              initialValue: userData['house'],
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
              initialValue: userData['street'],
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
              initialValue: userData['city'],
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
              initialValue: userData['state'],
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
              initialValue: userData['country'],
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
              initialValue: userData['school10'],
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
              initialValue: userData['board10'],
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
              initialValue: userData['score10'].toString(),
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
              initialValue: userData['year10'].toString(),
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
              initialValue: userData['school12'],
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
              initialValue: userData['board12'],
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
              initialValue: userData['score12'].toString(),
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
              initialValue: userData['year12'].toString(),
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
          Text(
              "Please fill in the following fields with valid choices from the ones given below:\nCOE, IT, SE, ECE"),
          Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: TextFormField(
              initialValue: userData['choice1'].toString().toUpperCase(),
              validator: (value) {
                if (value.isEmpty) {
                  return "Please enter your first choice.";
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
              initialValue: userData['choice2'].toString().toUpperCase(),
              validator: (value) {
                if (value.isEmpty) {
                  return "Please enter your second choice.";
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
              initialValue: userData['choice3'].toString().toUpperCase(),
              validator: (value) {
                if (value.isEmpty) {
                  return "Please enter your third choice.";
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
              onPressed: () async {
                if (_studentEditingFormKey.currentState.validate()) {
                  _studentEditingFormKey.currentState.save();
                  await Firebase.initializeApp();
                  await FirebaseFirestore.instance
                      .collection('students')
                      .doc(userData.id)
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
                      .then((value) => print("User Details Updated"))
                      .catchError((error) =>
                          print("Failed to update user details: $error"));
                  final snackBar =
                      SnackBar(content: Text("The details have been updated."));
                  Scaffold.of(context).showSnackBar(snackBar);
                  FocusScope.of(context).unfocus();
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
