import 'package:flutter/material.dart';
import 'BranchData.dart';
import 'package:validators/validators.dart' as validator;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class AddBranchDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Branch Details"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(25.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Please enter the details of the branch you want to add.",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                AddBranchDetailsBody(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AddBranchDetailsBody extends StatefulWidget {
  @override
  _AddBranchDetailsBodyState createState() => _AddBranchDetailsBodyState();
}

class _AddBranchDetailsBodyState extends State<AddBranchDetailsBody> {
  final _branchFormKey = GlobalKey<FormState>();
  BranchData _branchData = BranchData();
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _branchFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: TextFormField(
              validator: (value) {
                if (value.isEmpty) {
                  return "Please enter branch name";
                }
                return null;
              },
              onSaved: (value) {
                this._branchData.name = value;
              },
              autocorrect: false,
              textAlign: TextAlign.left,
              enableSuggestions: false,
              style: TextStyle(fontSize: 18.0),
              decoration: InputDecoration(
                hintText: "Branch Name",
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
                  return "Please enter branch code";
                }
                return null;
              },
              onSaved: (value) {
                this._branchData.code = value;
              },
              autocorrect: false,
              textAlign: TextAlign.left,
              enableSuggestions: false,
              style: TextStyle(fontSize: 18.0),
              decoration: InputDecoration(
                hintText: "Branch Code",
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
                  return "Please enter branch head name";
                }
                return null;
              },
              onSaved: (value) {
                this._branchData.head = value;
              },
              autocorrect: false,
              textAlign: TextAlign.left,
              enableSuggestions: false,
              style: TextStyle(fontSize: 18.0),
              decoration: InputDecoration(
                hintText: "Branch Head Name",
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
                  return "Please enter max seats is branch";
                } else if (!validator.isNumeric(value) ||
                    int.parse(value) < 0) {
                  return "Please enter a valid number";
                }
                return null;
              },
              onSaved: (value) {
                this._branchData.maxSeats = int.parse(value);
              },
              autocorrect: false,
              textAlign: TextAlign.left,
              enableSuggestions: false,
              style: TextStyle(fontSize: 18.0),
              decoration: InputDecoration(
                hintText: "Max Seats",
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
                  return "Please enter department";
                }
                return null;
              },
              onSaved: (value) {
                this._branchData.department = value;
              },
              autocorrect: false,
              textAlign: TextAlign.left,
              enableSuggestions: false,
              style: TextStyle(fontSize: 18.0),
              decoration: InputDecoration(
                hintText: "Department",
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
                if (_branchFormKey.currentState.validate()) {
                  _branchFormKey.currentState.save();

                  await Firebase.initializeApp();

                  QuerySnapshot existingBranch = await FirebaseFirestore
                      .instance
                      .collection('branches')
                      .where('code', isEqualTo: this._branchData.code)
                      .get()
                      .catchError(
                          (error) => print("Failed to add user: $error"));

                  if (existingBranch.size > 0) {
                    final snackBar = SnackBar(
                      content: Text("Branch with entered code already exists."),
                    );
                    Scaffold.of(context).showSnackBar(snackBar);
                  } else {
                    await FirebaseFirestore.instance
                        .collection('branches')
                        .doc()
                        .set({
                          'code': this._branchData.code,
                          'head': this._branchData.head,
                          'name': this._branchData.name,
                          'maxSeats': this._branchData.maxSeats,
                          'department': this._branchData.department,
                        })
                        .then((value) => print("Branch Added"))
                        .catchError(
                            (error) => print("Failed to add branch: $error"));
                    final snackBar = SnackBar(
                      content: Text("Branch Added"),
                    );
                    Scaffold.of(context).showSnackBar(snackBar);
                  }
                }
                _branchFormKey.currentState.reset();
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
