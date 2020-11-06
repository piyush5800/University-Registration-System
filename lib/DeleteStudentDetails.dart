import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:validators/validators.dart' as validator;

class DeleteStudentDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Delete Student Details"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(25.0),
            child: DeleteStudentDetailsBody(),
          ),
        ),
      ),
    );
  }
}

class DeleteStudentDetailsBody extends StatefulWidget {
  @override
  _DeleteStudentDetailsBodyState createState() =>
      _DeleteStudentDetailsBodyState();
}

class _DeleteStudentDetailsBodyState extends State<DeleteStudentDetailsBody> {
  final _formKey = GlobalKey<FormState>();

  String email;

  DocumentSnapshot userData;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Please enter the email address of the student you want to delete.",
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
                        this.userData = allData.docs[0];
                        await FirebaseFirestore.instance
                            .collection("deleted")
                            .doc()
                            .set({'email': userData['email']});
                        await FirebaseFirestore.instance
                            .collection("students")
                            .doc(userData.id)
                            .delete();
                        await FirebaseFirestore.instance
                            .collection("applications")
                            .doc(userData.id)
                            .delete();

                        final snackBar = SnackBar(
                            content: Text(
                                "Details deleted for ${userData['firstName']}."));
                        Scaffold.of(context).showSnackBar(snackBar);
                        print("Record Found for ${this.userData['firstName']}");
                      } else {
                        final snackBar = SnackBar(
                            content: Text(
                                "No Record exists for the entered email address."));
                        Scaffold.of(context).showSnackBar(snackBar);
                      }
                    }
                  },
                  child: Text(
                    "Delete Details",
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
            ],
          ),
        ),
      ],
    );
  }
}
