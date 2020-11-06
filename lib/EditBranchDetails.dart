import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:validators/validators.dart' as validator;
import 'BranchData.dart';

class EditBranchDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Branch Details"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(25.0),
            child: EditBranchDetailsBody(),
          ),
        ),
      ),
    );
  }
}

class EditBranchDetailsBody extends StatefulWidget {
  @override
  _EditBranchDetailsBodyState createState() => _EditBranchDetailsBodyState();
}

class _EditBranchDetailsBodyState extends State<EditBranchDetailsBody> {
  final _branchFormKey = GlobalKey<FormState>();
  String branchCode;
  DocumentSnapshot branchData;
  bool isFetched = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Please enter the branch code of the branch whose details you want to edit.",
          style: TextStyle(
            fontSize: 18,
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Form(
          key: _branchFormKey,
          child: Column(
            children: [
              Container(
                width: 400,
                child: TextFormField(
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Please enter the branch code";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    this.branchCode = value;
                  },
                  autocorrect: false,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    hintText: "Branch Code",
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
                    if (_branchFormKey.currentState.validate()) {
                      _branchFormKey.currentState.save();
                      QuerySnapshot allData = await FirebaseFirestore.instance
                          .collection("branches")
                          .where('code', isEqualTo: this.branchCode)
                          .get();

                      if (allData.size > 0) {
                        setState(() {
                          this.branchData = allData.docs[0];
                          print("Record Found for ${this.branchData['name']}");
                          this.isFetched = true;
                        });
                      } else {
                        final snackBar = SnackBar(
                            content: Text(
                                "No Record exists for the entered branch code."));
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
                PrefilledBranchDetailsForm(branchData: this.branchData),
            ],
          ),
        ),
      ],
    );
  }
}

class PrefilledBranchDetailsForm extends StatelessWidget {
  final DocumentSnapshot branchData;
  final _branchEditingFormKey = GlobalKey<FormState>();
  final BranchData data = BranchData();
  PrefilledBranchDetailsForm({this.branchData});
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _branchEditingFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: TextFormField(
              initialValue: branchData['name'],
              validator: (value) {
                if (value.isEmpty) {
                  return "Please enter branch name";
                }
                return null;
              },
              onSaved: (value) {
                this.data.name = value;
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
              initialValue: branchData['code'],
              validator: (value) {
                if (value.isEmpty) {
                  return "Please enter branch code";
                }
                return null;
              },
              onSaved: (value) {
                this.data.code = value;
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
              initialValue: branchData['head'],
              validator: (value) {
                if (value.isEmpty) {
                  return "Please enter branch head name";
                }
                return null;
              },
              onSaved: (value) {
                this.data.head = value;
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
              initialValue: branchData['maxSeats'].toString(),
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
                this.data.maxSeats = int.parse(value);
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
              initialValue: branchData['department'],
              validator: (value) {
                if (value.isEmpty) {
                  return "Please enter department";
                }
                return null;
              },
              onSaved: (value) {
                this.data.department = value;
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
                if (_branchEditingFormKey.currentState.validate()) {
                  _branchEditingFormKey.currentState.save();
                  await Firebase.initializeApp();
                  await FirebaseFirestore.instance
                      .collection('branches')
                      .doc(branchData.id)
                      .set({
                        'name': this.data.name,
                        'code': this.data.code,
                        'head': this.data.head,
                        'department': this.data.department,
                        'maxSeats': this.data.maxSeats,
                      })
                      .then((value) => print("Branch Details Updated"))
                      .catchError((error) =>
                          print("Failed to update Branch details: $error"));
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
